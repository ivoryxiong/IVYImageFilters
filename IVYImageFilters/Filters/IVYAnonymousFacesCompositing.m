//
//  IVYAnonymousFacesCompositing.m
//  IVYImageFilters
//
//  Created by ivoryxiong on 14-5-6.
//  Copyright (c) 2014年 IVORY. All rights reserved.
//

#import "IVYAnonymousFacesCompositing.h"

@implementation IVYAnonymousFacesCompositing

- (UIImage *)filterImage:(UIImage *)image configs:(NSDictionary *)configs {
    UIImage *retImg = [super filterImage:image configs:configs];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciImage = [CIImage imageWithCGImage:self.orignalImage.CGImage];
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:nil];
    NSArray *features = [detector featuresInImage:ciImage options:nil];
    
    if ([features count]) {
        CIFaceFeature *faceFeature = [features firstObject];
        CGFloat centerX = faceFeature.bounds.origin.x+faceFeature.bounds.size.width / 2.0;
        CGFloat centerY = faceFeature.bounds.origin.y+faceFeature.bounds.size.height / 2.0;
        CGFloat radius = MIN(faceFeature.bounds.size.width,faceFeature.bounds.size.height) / 1.5;
        CIFilter *radialGradient = [CIFilter filterWithName:@"CIRadialGradient"keysAndValues:
                                    @"inputRadius0", @(self.orignalImage.size.width*2/3),
                                    @"inputRadius1", @(radius + 10.0f),
                                    @"inputColor0", [CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                                    @"inputColor1", [CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0],
                                    kCIInputCenterKey, [CIVector vectorWithX:centerX Y:centerY],nil];
        CIFilter *compositing = [CIFilter filterWithName:@"CISourceOverCompositing" keysAndValues:
                                 kCIInputImageKey,radialGradient.outputImage,
                                 kCIInputBackgroundImageKey,ciImage,nil];
        CGImageRef cgImage = [context createCGImage:compositing.outputImage fromRect:CGRectMake(0, 0, self.orignalImage.size.width, self.orignalImage.size.height)];
        retImg = [UIImage imageWithCGImage:cgImage];
    }

    return retImg;
}
@end
