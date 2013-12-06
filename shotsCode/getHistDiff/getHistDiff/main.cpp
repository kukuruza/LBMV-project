//
//  main.cpp
//  splitShots
//
//  Created by Evgeny on 11/9/13.
//  Copyright (c) 2013 Evgeny Toropov. All rights reserved.
//

#include "tclap/CmdLine.h"
#include <opencv2/core/core.hpp>
#include "opencv2/imgproc/imgproc.hpp"
#include <boost/filesystem.hpp>
#include <fstream>
#include "tclap/CmdLine.h"
#include "mediaLoadSave.h"

using namespace std;
using namespace cv;
using namespace boost::filesystem;
using namespace TCLAP;


Mat getHistFromFrame (Mat frame, int binsPerCh)
{
      vector<Mat> bgr_planes;
      split( frame, bgr_planes );

      /// Set the ranges ( for B,G,R) )
      float range[] = { 0, 256 } ;
      const float* histRange = { range };

      bool uniform = true; bool accumulate = false;

      // histogram vector
      Mat hist = Mat (binsPerCh * 3, 1, CV_32F);
      Mat b_hist = hist(cv::Range(0, binsPerCh), cv::Range(0, 1));
      Mat g_hist = hist(cv::Range(binsPerCh, binsPerCh * 2), cv::Range(0, 1));
      Mat r_hist = hist(cv::Range(binsPerCh * 2, binsPerCh * 3), cv::Range(0, 1));

      cout << b_hist.rows << " " << b_hist.cols << endl;
      cout << r_hist.rows << " " << r_hist.cols << endl;
      cout << g_hist.rows << " " << g_hist.cols << endl;
      cout << &binsPerCh << " " << histRange;
      cout << "Here" << endl;
    

      /// Compute the histograms:
      calcHist( &bgr_planes[0], 1, 0, Mat(), b_hist, 1, &binsPerCh, &histRange, uniform, accumulate );
      calcHist( &bgr_planes[1], 1, 0, Mat(), g_hist, 1, &binsPerCh, &histRange, uniform, accumulate );
      calcHist( &bgr_planes[2], 1, 0, Mat(), r_hist, 1, &binsPerCh, &histRange, uniform, accumulate );
      
      cout << "here" << endl;
    
      /*
      // Draw the histograms for B, G and R
      int hist_w = 512; int hist_h = 400;

      Mat histImage( hist_h, hist_w, CV_8UC3, Scalar( 0,0,0) );

      /// Normalize the result to [ 0, histImage.rows ]
      normalize(b_hist, b_hist, 0, histImage.rows, NORM_MINMAX, -1, Mat() );
      normalize(g_hist, g_hist, 0, histImage.rows, NORM_MINMAX, -1, Mat() );
      normalize(r_hist, r_hist, 0, histImage.rows, NORM_MINMAX, -1, Mat() );

      /// Draw for each channel
      int bin_w = cvRound( (double) hist_w/binsPerCh );
      for( int i = 1; i < binsPerCh; i++ )
      {
          line( histImage, Point( bin_w*(i-1), hist_h - cvRound(b_hist.at<float>(i-1)) ) ,
                           Point( bin_w*(i), hist_h - cvRound(b_hist.at<float>(i)) ),
                           Scalar( 255, 0, 0), 2, 8, 0  );
          line( histImage, Point( bin_w*(i-1), hist_h - cvRound(g_hist.at<float>(i-1)) ) ,
                           Point( bin_w*(i), hist_h - cvRound(g_hist.at<float>(i)) ),
                           Scalar( 0, 255, 0), 2, 8, 0  );
          line( histImage, Point( bin_w*(i-1), hist_h - cvRound(r_hist.at<float>(i-1)) ) ,
                           Point( bin_w*(i), hist_h - cvRound(r_hist.at<float>(i)) ),
                           Scalar( 0, 0, 255), 2, 8, 0  );
      }

      /// Display
      namedWindow("calcHist Demo", CV_WINDOW_AUTOSIZE );
      imshow("calcHist Demo", histImage );

      waitKey(0);
      */
    
      return hist;
}


int main(int argc, const char * argv[])
{
    // define requested input
    CmdLine cmd ("undistort a set of images using opencv", ' ', "0", false);
    typedef ValueArg<string> ArgStr;
    typedef UnlabeledMultiArg<string> MultiargStr;
    ValueArg<string> cmdInput ("i", "input", "input video", true, "", "string", cmd);
    ValueArg<string> cmdOutput ("o", "output", "path of txt with hist_diff", false, "/dev/null", "string", cmd);
    ValueArg<unsigned int> cmdFirstFrame ("1", "1st", "first frame number", false, 0, "int", cmd);
    ValueArg<unsigned int> cmdLastFrame ("2", "2nd", "last frame number", false, -1, "int", cmd);
    ValueArg<int> cmdBinsPerChannel ("", "bins", "bins per channel", false, 50, "int", cmd);
    
    // parse user input
    cmd.parse(argc, argv);
    string videoInPath = cmdInput.getValue();
    string videoOutPath = cmdOutput.getValue();
    int firstFrame = cmdFirstFrame.getValue();
    unsigned int lastFrame = cmdLastFrame.getValue();
    unsigned int binsPerCh = cmdBinsPerChannel.getValue();

    // open output file
    ofstream ofs (videoOutPath.c_str());
    if (!ofs )
    {
        cerr << "Failed to create file " << videoOutPath << endl;
        return -1;
    }
    
    cv::VideoCapture videoIn = evg::openVideo (videoInPath);
    Mat frame;
    unsigned int i = 0;
    
    // skip first "firstFrame" frames
    for (i = 0; i != firstFrame; ++i)
        videoIn.read(frame);
    
    // process first frame;
    ++i;
    videoIn.read(frame);
    Mat hist1 = getHistFromFrame (frame, binsPerCh);
    
    // process frame by frame
    for (; videoIn.read(frame) && i != lastFrame; ++i)
    {
        Mat hist0 = hist1.clone();
        hist1 = getHistFromFrame (frame, binsPerCh);
        
        float diff = sum(abs(hist1 - hist0))[0] / binsPerCh / 3;
        
        // to file
        ofs << i << " " << diff << endl;
        
        // to cout in order to keep track of progress
        if (i % 10000 == 0)
            cout << i << endl;
    }
    
    videoIn.release();

    return 0;
}