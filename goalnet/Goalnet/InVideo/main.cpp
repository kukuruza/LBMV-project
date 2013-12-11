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
    ValueArg<string> cmdSharpness ("", "sharpness", "path of txt with sharpness", true, "/dev/null", "string", cmd);
    ValueArg<string> cmdRespPath ("r", "responses", "path of txt with responses", false, "/dev/null", "string", cmd);
    SwitchArg cmdNotShowVideo ("", "dark", "do not show video", cmd);

    
    // parse user input
    cmd.parse(argc, argv);
    string videoInPath = cmdInput.getValue();
    string txtSharpnessPath = cmdSharpness.getValue();
    string txtRespPath = cmdRespPath.getValue();
    float thresh = cmdThresh.getValue();
    bool notShowVideo = cmdNotShowVideo.getValue();
    
    cv::VideoCapture video = evg::openVideo  (videoInPath);    
    Mat sharpness = evg::dlmread(txtSharpnessPath);
    
    ofstream ofs(txtRespPath.c_str());
    if (!ofs)
    {
        cerr << "Connot open respnse file: " << txtRespPath << endl;
        return -1;
    }
    
    set<int> indices;
    const int slidingwindowSize = 24;
    for (int i = 0; i < sharpness.rows - 1.5 * slidingwindowSize; i += slidingwindowSize / 2)
    {
        Mat window = sharpness(Range(i, i+slidingwindowSize), Range(0,1));
        Point iMax;
        double dummy1, dummy2;
        minMaxLoc (window, &dummy1, &dummy2, &iMax);
        //cout << iMax.y << " " << i + iMax.y << endl;
        indices.insert(i + iMax.y);
    }
    
    cout << "finished with processing peaks" << endl;
    cout << "number of frames to process: " << indices.size() << endl;
    
    if (!notShowVideo)
        namedWindow("frame");

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
        
        if (!notShowVideo)
        {
            imshow("frame", image);
            waitKey(10);
        }

        Mat image32f;
        image.convertTo(image32f, CV_32F);

        Mat output;
        float response1, response2;
        int period1 = 0, period2 = 0;

        detectNetInImage (image32f, thresh, false, &period1, &response1, &output);
        detectNetInImage (image32f, thresh, true,  &period2, &response2, &output);

        const float NormPeriodDiff = 2;

        float metrics = response1 * response2 / (NormPeriodDiff + abs(period1 -  period2)) * 1000;
        cout << "frame: " << i << "/" << sharpness.rows << ", sec: " << int(i / 25) << " - " 
             << 1/response1 << " " << 1/response2 << endl;
        ofs << i << " " << 1/response1 << " " << 1/response2 << endl;
        
    }

    return 0;
}

