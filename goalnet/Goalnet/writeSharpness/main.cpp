#include "tclap/CmdLine.h"
#include <opencv2/core/core.hpp>
#include "opencv2/imgproc/imgproc.hpp"
#include <boost/filesystem.hpp>
#include <fstream>
#include <set>

#include "mediaLoadSave.h"

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
    
    // parse user input
    cmd.parse(argc, argv);
    string videoInPath = cmdInput.getValue();
    string txtSharpnessPath = cmdSharpness.getValue();
    
    
    cv::VideoCapture video = evg::openVideo  (videoInPath);
    
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
    evg::dlmwrite(txtSharpnessPath, sharpness);
    
    return 0;
}

