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
    CmdLine cmd ("check video frames video", ' ', "0", false);
    ValueArg<string> cmdInput ("i", "input", "input video", true, "", "string", cmd);
    ValueArg<int> cmdFrame ("f", "frame", "frame number", false, -1, "int", cmd);
    ValueArg<string> cmdFrameFile ("", "frame_file", "file for specified frame", false, "", "string", cmd);
    SwitchArg cmdNotShowVideo ("", "dark", "do not show video", cmd);
    
    // parse user input
    cmd.parse(argc, argv);
    string videoInPath = cmdInput.getValue();
    int frameNum = cmdFrame.getValue();
    bool notShowVideo = cmdNotShowVideo.getValue();
    string frameFile = cmdFrameFile.getValue();
    
    cv::VideoCapture video = evg::openVideo  (videoInPath);
    
    if (!notShowVideo)
        namedWindow("video");

    Mat interstingFrame;
    Mat image;
    for (int i = 0; ; ++i)
    {
        if ( !video.read(image) )
        {
            cout << "break at i = " << i << endl;
            break;
        }

        if (frameNum == i)
            interstingFrame = image.clone();
        
        if (!notShowVideo)
        {
            cvtColor(image, image, CV_BGR2GRAY);
            imshow ("video", image);
            int a = waitKey(20);
            if (a == 27) break;
        }
    }

    if (frameNum != -1)
    {
        imshow("frame", interstingFrame);
        if (frameFile != "")
            imwrite(frameFile, interstingFrame);
        waitKey(-1);
    }

    return 0;
}

