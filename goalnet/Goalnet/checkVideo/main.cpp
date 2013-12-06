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
    CmdLine cmd ("check video frames video", ' ', "0", false);
    ValueArg<string> cmdInput ("i", "input", "input video", true, "", "string", cmd);
    
    // parse user input
    cmd.parse(argc, argv);
    string videoInPath = cmdInput.getValue();
    
    cv::VideoCapture video = evg::openVideo  (videoInPath);
    
    for (int i = 0; ; ++i)
    {
        Mat image;
        if ( !video.read(image) )
        {
            cout << "break at i = " << i << endl;
            break;
        }
        
        cvtColor(image, image, CV_BGR2GRAY);
        imshow ("test", image);
        waitKey(30);
    }
    
    return 0;
}

