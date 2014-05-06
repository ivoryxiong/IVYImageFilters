//
//  IVYOldFilmCompositing.m
//  IVYImageFilters
//
//  Created by ivoryxiong on 14-5-6.
//  Copyright (c) 2014年 IVORY. All rights reserved.
//

#import "IVYOldFilmCompositing.h"

@implementation IVYOldFilmCompositing
- (UIImage *)filterImage:(UIImage *)image configs:(NSDictionary *)configs {
    UIImage *retImg = [super filterImage:image configs:configs];

    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciImage = [CIImage imageWithCGImage:self.orignalImage.CGImage];

    CIFilter *spiaTone = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:@"inputImage", ciImage, @"inputIntensity", @1.0, nil];
    //TODO: add more filter
    CGImageRef cgImage = [context createCGImage:spiaTone.outputImage fromRect:CGRectMake(0, 0, self.orignalImage.size.width, self.orignalImage.size.height)];
    retImg = [UIImage imageWithCGImage:cgImage];
    return retImg;
}
@end
