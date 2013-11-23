//
//  bimodalFilter.h
//  Goalnet
//
//  Created by Evgeny on 11/19/13.
//  Copyright (c) 2013 Evgeny Toropov. All rights reserved.
//

#ifndef __Goalnet__bimodalKernel__
#define __Goalnet__bimodalKernel__

#include <iostream>
#include <opencv2/core/core.hpp>
#include "opencv2/imgproc/imgproc.hpp"


cv::Mat getBimodalKernel (const cv::Mat& srcKernel, const int dist, const bool doFlip);

bool    detectNetInImage (const cv::Mat& image, const float thresh,
                          float* metricsOutput = NULL, cv::Mat* matOutput = NULL);


#endif /* defined(__Goalnet__bimodalKernel__) */
