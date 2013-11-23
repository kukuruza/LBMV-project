#ifndef EVG_MISCELLANEOUS
#define EVG_MISCELLANEOUS

#include <iostream>
#include <iomanip>
#include <string>
#include <exception>
#include <opencv2/core/core.hpp>

namespace cv {
namespace evg {
    
    

//
// display the type of the image from the type number, i.e. 0 -> CV_8UC1
//
 
// from http://stackoverflow.com/questions/12335663/getting-enum-names-e-g-cv-32fc1-of-opencv-image-types
inline std::string getImageType (const int number)
{
    // find type
    int imgTypeInt = number%8;
    std::string imgTypeString;
    //
    switch (imgTypeInt)
    {
        case 0:
            imgTypeString = "8U";
            break;
        case 1:
            imgTypeString = "8S";
            break;
        case 2:
            imgTypeString = "16U";
            break;
        case 3:
            imgTypeString = "16S";
            break;
        case 4:
            imgTypeString = "32S";
            break;
        case 5:
            imgTypeString = "32F";
            break;
        case 6:
            imgTypeString = "64F";
            break;
        default:
            break;
    }
    //
    // find channel
    int channel = (number/8) + 1;
    //
    std::stringstream type;
    type<<"CV_"<<imgTypeString<<"C"<<channel;
    //
    return type.str();
}



//
// overload operator<< for cv::Matx.
//   matrix is displayed with a limited precision and numbers are aligned
//

template<typename Tp, int m, int n>
std::ostream& operator<< (std::ostream& os, const cv::Matx<Tp, m, n>& M)
{
    os << std::showpos;
    os << std::setprecision(3);
    os << std::fixed;
    
    for (int row = 0; row != m; ++row)
    {
        os << (row == 0 ? "[ " : "  ");
        for (int col = 0; col != n; ++col)
            os << M(row, col) << " ";
        os << (row == m-1 ? "]" : "\n");
        os << std::flush;
    }
    return os;
}


} // namespace evg
} // namespace cv

#endif  // EVG_MISCELLANEOUS
