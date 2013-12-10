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
    CmdLine cmd ("detect goalnet from an image", ' ', "0", false);
    typedef ValueArg<string> ArgStr;
    ValueArg<string> cmdInput ("i", "input", "input image", true, "", "string", cmd);
    ValueArg<string> cmdOutput ("o", "output", "path of txt with responses", false, "/dev/null", "string", cmd);
    ValueArg<float> cmdThresh ("t", "threshold", "method threshold", false, 0.2f, "float", cmd);
    
    // parse user input
    cmd.parse(argc, argv);
    string imageInPath = cmdInput.getValue();
    string txtOutPath = cmdOutput.getValue();
    float thresh = cmdThresh.getValue();
    
    Mat image = evg::loadImage (imageInPath);
    
    Mat imChannels[3];
    split(image, imChannels);
    image = imChannels[2];
    //imshow("Red", image);
    //waitKey(-1);
    //return 0;
    
    image.convertTo(image, CV_32F);

    float metrics;
    Mat output;
    bool detected = detectNetInImage (image, thresh, false, &metrics, &output);
    
    cout << "metrics " << metrics << " vs threshold " << thresh << endl;
    if (detected)
        cout << "detected peak" << endl;

    // printout
    evg::dlmwrite (txtOutPath, output);
    

}

