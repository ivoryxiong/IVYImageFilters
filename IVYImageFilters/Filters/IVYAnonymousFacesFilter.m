//
//  IVYAnonymousFacesFilter.m
//  IVYImageFilters
//
//  Created by ivoryxiong on 14-5-6.
//  Copyright (c) 2014年 IVORY. All rights reserved.
//

#import "IVYAnonymousFacesFilter.h"
#import <CoreImage/CIDetector.h>
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface IVYAnonymousFacesFilter ()
//@property (nonatomic, strong) CIImage *inputImage;
@property (nonatomic, strong) CIVector *faceCenter;
@property (nonatomic, strong) CIFeature *face;

@end

@implementation IVYAnonymousFacesFilter

- (void)setDefaults
{
    [self setValue:@(10) forKey:@"inputRadius"];
    [self setValue:@(0.5) forKey:@"inputCenter"];
    [self setValue:@(0.25) forKey:@"inputBottom"];
    [self setValue:@(0.75) forKey:@"inputTop"];
}

- (CIImage *) outputImage {
    /*
    CGRect cropRect = self.inputImage.extent;
    CGFloat height = cropRect.size.height;
    
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur"
                                keysAndValues:@"inputImage", self.inputImage,
                      @"inputRadius", @(self.inputRadius), nil];
    blur = [CIFilter filterWithName:@"CICrop"
                      keysAndValues:@"inputImage", blur.outputImage,
            @"inputRectangle", [CIVector vectorWithCGRect:cropRect], nil];
    
    CIFilter *topGradient = [CIFilter filterWithName:@"CILinearGradient"
                                       keysAndValues:@"inputPoint0", [CIVector vectorWithX:0 Y:(self.inputTop * height)],
                             @"inputColor0", [CIColor colorWithRed:0 green:1 blue:0 alpha:1],
                             @"inputPoint1", [CIVector vectorWithX:0 Y:(self.inputCenter * height)],
                             @"inputColor1", [CIColor colorWithRed:0 green:1 blue:0 alpha:0], nil];
    CIFilter *bottomGradient = [CIFilter filterWithName:@"CILinearGradient"
                                          keysAndValues:@"inputPoint0", [CIVector vectorWithX:0 Y:(self.inputBottom * height)],
                                @"inputColor0", [CIColor colorWithRed:0 green:1 blue:0 alpha:1],
                                @"inputPoint1", [CIVector vectorWithX:0 Y:(self.inputCenter * height)],
                                @"inputColor1", [CIColor colorWithRed:0 green:1 blue:0 alpha:0], nil];
    topGradient = [CIFilter filterWithName:@"CICrop"
                             keysAndValues:@"inputImage", topGradient.outputImage,
                   @"inputRectangle", [CIVector vectorWithCGRect:cropRect], nil];
    bottomGradient = [CIFilter filterWithName:@"CICrop"
                                keysAndValues:@"inputImage", bottomGradient.outputImage,
                      @"inputRectangle", [CIVector vectorWithCGRect:cropRect], nil];
    CIFilter *gradients = [CIFilter filterWithName:@"CIAdditionCompositing"
                                     keysAndValues:@"inputImage", topGradient.outputImage,
                           @"inputBackgroundImage", bottomGradient.outputImage, nil];
    
    CIFilter *tiltShift = [CIFilter filterWithName:@"CIBlendWithMask"
                                     keysAndValues:@"inputImage", blur.outputImage,
                           @"inputBackgroundImage", self.inputImage,
                           @"inputMaskImage", gradients.outputImage, nil];
    
    return tiltShift.outputImage;
    
     */
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:self.inputImage fromRect:CGRectMake(0, 0, self.inputImage.extent.size.width, self.inputImage.extent.size.height)];
    UIImage *orgImg = [UIImage imageWithCGImage:cgImage];
    CIImage *ciImage = [CIImage imageWithCGImage:orgImg.CGImage];

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
                                    @"inputRadius0", @(orgImg.size.width*2/3),
                                    @"inputRadius1", @(radius + 10.0f),
                                    @"inputColor0", [CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                                    @"inputColor1", [CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0],
                                    kCIInputCenterKey, [CIVector vectorWithX:centerX Y:centerY],nil];
        CIFilter *compositing = [CIFilter filterWithName:@"CISourceOverCompositing" keysAndValues:
                                 kCIInputImageKey,radialGradient.outputImage,
                                 kCIInputBackgroundImageKey,ciImage,nil];
        return [compositing outputImage];
    } else {
        return self.inputImage;
    }
}

- (CIImage *)shadeMapImage {
    CIFilter *radialGradientFilter = [CIFilter filterWithName:@"CIRadialGradient"];
    NSLog(@"===> w %0.2f  h %0.2f", self.inputImage.extent.size.width, self.inputImage.extent.size.height);
    double length = MAX(self.inputImage.extent.size.width, self.inputImage.extent.size.height);
    NSLog(@"===> back %0.2f  face %0.2f", length, self.face.bounds.size.height + 50);

//    [radialGradientFilter setValue:[NSNumber numberWithDouble:length] forKey:@"inputRadius0"];
//    [radialGradientFilter setValue:[NSNumber numberWithDouble:(self.face.bounds.size.height + 50)] forKey:@"inputRadius1"];
//    [radialGradientFilter setValue:self.faceCenter forKey:@"inputCenter"];

    [radialGradientFilter setValue:@400.f forKey:@"inputRadius0"];
    [radialGradientFilter setValue:@50.f forKey:@"inputRadius1"];
    [radialGradientFilter setValue:[CIVector vectorWithX:200.0f Y:200.0f] forKey:@"inputCenter"];

    [radialGradientFilter setValue:[CIColor colorWithCGColor:[UIColor whiteColor].CGColor] forKey:@"inputColor0"];
    [radialGradientFilter setValue:[CIColor colorWithCGColor:[UIColor redColor].CGColor] forKey:@"inputColor1"];

    CIContext *context = [CIContext contextWithOptions:NULL];
    CIImage *ciimage = [radialGradientFilter outputImage];
    CGImageRef cgimg = [context createCGImage:ciimage fromRect:[ciimage extent]];
    UIImage *uiimage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);

    CIImage *retImage = radialGradientFilter.outputImage;
    [self storeImage:uiimage];
    return retImage;
}

-(void)storeImage:(UIImage *)image {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"a"] stringByAppendingPathExtension:@"png"];
    NSData *data = UIImagePNGRepresentation(image);
    BOOL yes = [data writeToFile:path atomically:YES];
    NSLog(@"================>path : %@\n image : %@ \n data: %@ \n ans :%d", path, image, data, yes);

}

@end
