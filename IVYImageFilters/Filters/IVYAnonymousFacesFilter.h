//
//  IVYAnonymousFacesFilter.h
//  IVYImageFilters
//
//  Created by ivoryxiong on 14-5-6.
//  Copyright (c) 2014年 IVORY. All rights reserved.
//

#import <CoreImage/CoreImage.h>

@interface IVYAnonymousFacesFilter : CIFilter
@property (retain, nonatomic) CIImage *inputImage;
@property (assign, nonatomic) CGFloat inputRadius;
@property (assign, nonatomic) CGFloat inputTop;
@property (assign, nonatomic) CGFloat inputCenter;
@property (assign, nonatomic) CGFloat inputBottom;

@end
