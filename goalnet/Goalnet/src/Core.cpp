//
//  bimodalFilter.cpp
//  Goalnet
//
//  Created by Evgeny on 11/19/13.
//  Copyright (c) 2013 Evgeny Toropov. All rights reserved.
//

#include "Core.h"

using namespace std;
using namespace cv;


cv::Mat getBimodalKernel (const cv::Mat& srcKernel, const int dist, const bool doFlip)
{
    assert (srcKernel.rows == 1 || srcKernel.cols == 1);
    
    Mat singleKernel = srcKernel.clone();
    
    // must be one col
    if (singleKernel.cols == 1)
         singleKernel = singleKernel.t();
         
    int length = singleKernel.cols;
    
    Mat destKernel = Mat::zeros (1, length + dist, singleKernel.type());
    
    singleKernel.copyTo( destKernel(Range(0,1), Range(0, length)) );
    
    if (doFlip)
        singleKernel *= -1;
    
    singleKernel.copyTo( destKernel(Range(0,1), Range(dist, length+dist)) );
    
    return destKernel;
}


bool detectNetInImage (const Mat& image, const float thresh, bool transp,
                       int* period, float* metricsOutput, Mat* matOutput)
{
    const int kernelWidth = 5;
    const int firstDist = 10;
    const int maxDist = 128 + firstDist;
    
    const int MinPeakFreq = 5;

    // get gaussian kernel
    float gradKernleArr[] = { 0.0133f, 0.1080f, 0.2420f, 0, -0.2420f, -0.1080f, -0.0133f };
    Mat gradKernel = Mat(1, 7, CV_32F, &gradKernleArr);
    
    
    // collect different distances
    vector<float> responses (maxDist - firstDist);
    for (int dist = firstDist; dist != maxDist; ++dist)
    {
        Mat bimodalKernel = getBimodalKernel (gradKernel, dist, true);
        bimodalKernel = Mat::ones(kernelWidth,1,CV_32F) * bimodalKernel;
        
        Mat output;
        if (transp)
            bimodalKernel = bimodalKernel.t();
        filter2D(image, output, -1, bimodalKernel);
        responses[dist - firstDist] = sum(sum(abs(output)))[0] / output.rows / output.cols;
    }
    
    // connect ends
    double diff = (responses[responses.size()-1] - responses[0]) / responses.size();
    for (int i = 0; i != responses.size(); ++i)
        responses[i] -= i * diff;
    Mat matResponses = Mat(responses);
    matResponses -= mean(matResponses)[0];
    
    //for (int i = 0; i != responses.size(); ++i)
    //    cout << matResponses.at<float>(i,0) << endl;
    
    //cout << "rows: " << matResponses.rows << " x cols: " << matResponses.cols << endl;
    
    // get fft
    Mat fftCompl = Mat::zeros(matResponses.size(), CV_32FC2);
    cv::dft (matResponses, fftCompl, DFT_COMPLEX_OUTPUT);
    
    //cout << fftCompl << endl;
    
    // get real part
    Mat fftChannels[2];
    split( fftCompl, fftChannels );
    Mat fft = fftChannels[0];
    fft = abs(fft);
    
    // remove the second half, as well as the 0th and 1st harmonics
    int indHalf = int(fft.rows / 2);
    assert (indHalf > 2);
    fft.at<float>(0,0) = 0;
    fft.at<float>(1,0) = 0;
    Mat fftCrop = fft(Range(0, indHalf), Range(0,1));
    
    //for (int i = 0; i != fftCrop.rows; ++i)
    //    cout << fftChannels[0].at<float>(i,0) << endl;
    
    
    
    // now the magic starts. Maybe more magic is necessary
    
    // get the max
    double maxVal = -1;
    int maxInd = -1;
    Mat fftPeakArea = fftCrop(Range(MinPeakFreq, fftCrop.rows), Range(0,1));
    minMaxIdx (fftPeakArea, NULL, &maxVal, NULL, &maxInd);
    assert (maxInd >= 0);
    
    // get the mean without the peak +- 30%
    int peakStart = round(maxInd * 0.7);
    int peakEnd   = round(maxInd * 1.3);
    double sumFft = sum(fftCrop)[0];
    double sumPeak = sum( fftCrop(Range(peakStart, peakEnd+1), Range(0,1)) )[0];
    double meanWithoutPeak = (sumFft - sumPeak) / (fftCrop.rows + peakEnd-peakStart+1);
        
    // copy for printout if necessary
    if (matOutput != NULL)
    {
        *matOutput = Mat(fft.rows, 2, CV_32F);
        matResponses.copyTo((*matOutput)(Range(0,fft.rows), Range(0,1)));
        fft.copyTo((*matOutput)(Range(0,fft.rows), Range(1,2)));
    }


    if (period == NULL)
        cout << "period: " << matResponses.rows / (maxInd+MinPeakFreq) << endl;
    else
        *period = matResponses.rows / (maxInd+MinPeakFreq);

    // get the decision
    float metrics = meanWithoutPeak / maxVal;
    if (metricsOutput != NULL) *metricsOutput = metrics;
    if (metrics < thresh)
        return 1;
    else
        return 0;
}


