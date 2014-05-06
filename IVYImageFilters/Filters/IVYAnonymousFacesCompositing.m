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
        //mask images
        CIImage *maskImage = nil;
        for (CIFeature *f in features) {
            CGFloat centerX = f.bounds.origin.x + f.bounds.size.width / 2.0;
            CGFloat centerY = f.bounds.origin.y + f.bounds.size.height / 2.0;
            CGFloat radius = MIN(f.bounds.size.width, f.bounds.size.height) / 1.5;
            CIFilter *radialGradient = [CIFilter filterWithName:@"CIRadialGradient" keysAndValues:
                                        @"inputRadius0", @(radius),
                                        @"inputRadius1", @(radius + 1.0f),
                                        @"inputColor0", [CIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0],
                                        @"inputColor1", [CIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0],
                                        kCIInputCenterKey, [CIVector vectorWithX:centerX Y:centerY],
                                        nil];
            CIImage *circleImage = [radialGradient valueForKey:kCIOutputImageKey];
            if (nil == maskImage)
                maskImage = circleImage;
            else
                maskImage = [[CIFilter filterWithName:@"CISourceOverCompositing" keysAndValues:
                              kCIInputImageKey, circleImage,
                              kCIInputBackgroundImageKey, maskImage,
                              nil] valueForKey:kCIOutputImageKey];
        }
        //CIPixellate
        CIFilter *pixellate = [CIFilter filterWithName:@"CIPixellate" keysAndValues:
                                    @"inputImage", ciImage,
                                    @"inputScale", @(MAX(self.orignalImage.size.width, self.orignalImage.size.height)/60.0),
                                    nil];
        CIImage *pixellateImage = [pixellate valueForKey:kCIOutputImageKey];


        CIFilter *blendWithMask = [CIFilter filterWithName:@"CIBlendWithMask"
                                               keysAndValues:
                                                    @"inputImage", pixellateImage,
                                     @"inputBackgroundImage", ciImage,
                                     @"inputMaskImage", maskImage,
                                     nil];

        CGImageRef cgImage = [context createCGImage:blendWithMask.outputImage fromRect:CGRectMake(0, 0, self.orignalImage.size.width, self.orignalImage.size.height)];
        retImg = [UIImage imageWithCGImage:cgImage];
    }

    return retImg;
}
@end
