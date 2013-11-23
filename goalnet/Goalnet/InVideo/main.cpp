#include "tclap/CmdLine.h"
#include <opencv2/core/core.hpp>
#include "opencv2/imgproc/imgproc.hpp"
#include <boost/filesystem.hpp>
#include <fstream>

#include "mediaLoadSave.h"
#include "Core.h"

using namespace std;
using namespace cv;
using namespace boost::filesystem;
using namespace TCLAP;



int main(int argc, const char * argv[])
{
    // define requested input
    CmdLine cmd ("detect goalnet from a video", ' ', "0", false);
    typedef ValueArg<string> ArgStr;
    ValueArg<string> cmdInput ("i", "input", "input video", true, "", "string", cmd);
    ValueArg<string> cmdOutput ("o", "output", "path of txt with detections", false, "/dev/null", "string", cmd);
    ValueArg<float> cmdThresh ("t", "threshold", "method threshold", false, 0.2f, "float", cmd);
    ValueArg<int> cmdPeriod ("p", "period", "every N-th net is processed", false, 25, "int", cmd);
    ValueArg<int> cmdChannel ("c", "channel", "0-1-2 stand for B-G-R", false, 2, "int", cmd);
    ValueArg<float> cmdSigma ("s", "sigma", "smoothing sigma", false, 1, "float", cmd);
    
    
    // parse user input
    cmd.parse(argc, argv);
    string videoInPath = cmdInput.getValue();
    string txtOutPath = cmdOutput.getValue();
    float thresh = cmdThresh.getValue();
    int period = cmdPeriod.getValue();
    int channel = cmdChannel.getValue();
    assert (channel >= 0 && channel < 3);
    float sigma = cmdSigma.getValue();
    
    
    ofstream ofs (txtOutPath.c_str());
    if (!ofs)
    {
        cout << "Couldn't open " << txtOutPath << endl;
        return -1;
    }
    
    cv::VideoCapture video = evg::openVideo  (videoInPath);
    
    // detect frames
    vector<float> detectedFrames;
    for (int i = 0; ; ++i)
    {
        Mat image;
        if ( !video.read(image) ) return 0;
        
        if (i % period == 0)
        {
            Mat imChannels[3];
            split(image, imChannels);
            image = imChannels[channel];

            //imshow("Red", image);
            //waitKey(-1);
            
            image.convertTo(image, CV_32F);

            float metrics;
            Mat output;
            detectedFrames[i/period] = float(detectNetInImage (image, thresh, &metrics, &output));
            
            ofs << metrics << " " << (detectedFrames[i/period] ? "1" : "0") << endl;
        }
    }
    
    // get high density of detected regions
    Mat smoothedDetected = Mat(Mat(detectedFrames).size(), CV_32F);
    int kernelSize = int(sigma * 4);
    cv::GaussianBlur (Mat(detectedFrames), smoothedDetected, Size(kernelSize, kernelSize), sigma);
    
    // linear sum of detected
    Range rangeOfFiltered = Range (int(kernelSize/2), smoothedDetected.rows - int(kernelSize/2));
    float detectedSum = sum(smoothedDetected(rangeOfFiltered, Range(0,1)))[0];
    
    // normalize to [0 1]
    const float CoefUp = 0.3;
    double result = atan(CoefUp * detectedSum) / CV_PI * 2;
    
    
    return 0;
}

