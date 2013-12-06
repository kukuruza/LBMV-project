#include "tclap/CmdLine.h"
#include <opencv2/core/core.hpp>
#include "opencv2/imgproc/imgproc.hpp"
#include <boost/filesystem.hpp>
#include <fstream>
#include <set>

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
    ValueArg<string> cmdSharpness ("", "sharpness", "path of txt with sharpness", false, "/dev/null", "string", cmd);
    ValueArg<string> cmdRespPath ("r", "responses", "path of txt with responses", false, "/dev/null", "string", cmd);
    
    ValueArg<float> cmdThresh ("t", "threshold", "method threshold", false, 0.2f, "float", cmd);
    ValueArg<int> cmdPeriod ("p", "period", "every N-th frame is processed", false, 25, "int", cmd);
    ValueArg<int> cmdChannel ("c", "channel", "0-1-2 stand for B-G-R", false, 2, "int", cmd);
    ValueArg<float> cmdSigma ("s", "sigma", "smoothing sigma", false, 1, "float", cmd);
    
    
    // parse user input
    cmd.parse(argc, argv);
    string videoInPath = cmdInput.getValue();
    string txtSharpnessPath = cmdSharpness.getValue();
    string txtRespPath = cmdRespPath.getValue();
    float thresh = cmdThresh.getValue();
    int period = cmdPeriod.getValue();
    int channel = cmdChannel.getValue();
    assert (channel >= 0 && channel < 3);
    
    
    cv::VideoCapture video = evg::openVideo  (videoInPath);
    
    /*
    // detect frames
    vector<int> sharpnessVec;
    for (int i = 0; ; ++i)
    {
        Mat image;
        if ( !video.read(image) )
        {
            cout << "break at i = " << i << endl;
            break;
        }
        
        cvtColor(image, image, CV_BGR2GRAY);
        
        Matx33f laplaceKernel = Matx33f(0,-1,0, -1,4,-1, 0,-1,0);
        Mat laplacedImage;
        filter2D(image, laplacedImage, -1, laplaceKernel);
        int sharp = int(sum(abs(laplacedImage))[0] * 0.001);
        
        sharpnessVec.push_back(sharp);
        ostringstream oss;
        oss << sharp;
    }
    Mat sharpness = Mat(sharpnessVec);
    evg::dlmwrite(txtOutPath, sharpness);
    
    */
    
    Mat sharpness = evg::dlmread(txtSharpnessPath);
    
    set<int> indices;
    const int slidingwindowSize = 24;
    for (int i = 0; i < sharpness.rows - 1.5 * slidingwindowSize; i += slidingwindowSize / 2)
    {
        Mat window = sharpness(Range(i, i+slidingwindowSize), Range(0,1));
        Point iMax;
        double dummy1, dummy2;
        minMaxLoc (window, &dummy1, &dummy2, &iMax);
        cout << iMax.y << " " << i + iMax.y << endl;
        indices.insert(i + iMax.y);
    }
    
    cout << "finished with processing peaks, set size: " << indices.size() << endl;
    
    Mat responses = Mat(0,3,CV_32F);
    video = evg::openVideo (videoInPath);
    for (int i = 0; ; ++i)
    {
        Mat image;
        if ( !video.read(image) )
        {
            cout << "break at i = " << i << endl;
            break;
        }
        
        if (find(indices.begin(), indices.end(), i) == indices.end())
            continue;
        
        
        cvtColor(image, image, CV_BGR2GRAY);
        
        ostringstream oss;
        oss << sharpness.at<int>(i);
        
        //putText(image, oss.str(), cv::Point(1,40), CV_FONT_HERSHEY_SIMPLEX, 1, Scalar(255));
        //imshow("frame", image);
        //waitKey(-1);
        
        
        Matx13f response;

        Mat image32f;
        image.convertTo(image32f, CV_32F);

        Mat output;
        detectNetInImage (image32f, thresh, false, &response(1), &output);
        detectNetInImage (image32f, thresh, true,  &response(2), &output);

        response(0) = i;
        responses.push_back(Mat(response));

        cout << response(1) * response(2) << endl;
        
    }

    
    cout << responses.rows << " " << responses.cols << endl;
    evg::dlmwrite(txtRespPath, responses);
    
    
    return 0;
}

