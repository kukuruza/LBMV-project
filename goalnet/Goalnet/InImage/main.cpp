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
    
    Mat image32f;
    image.convertTo(image32f, CV_32F);

    Mat output;
    float response1, response2;
    int period1 = 0, period2 = 0;

    detectNetInImage (image32f, thresh, false, &period1, &response1, &output);
    detectNetInImage (image32f, thresh, true,  &period2, &response2, &output);

    const float NormPeriodDiff = 2;

    cout << 1/response1 << " " << 1/response2 << endl;

    // printout
    evg::dlmwrite (txtOutPath, output);
    

}

