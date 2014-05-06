//
//  IVYViewController.m
//  IVYImageFilters
//
//  Created by ivoryxiong on 14-5-6.
//  Copyright (c) 2014年 IVORY. All rights reserved.
//

#import "IVYViewController.h"
#import "IVYAnonymousFacesFilter.h"
#import <CoreImage/CoreImage.h>
#import <CoreImage/CIFilter.h>

@interface IVYViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *orgImg;
@end

@implementation IVYViewController
- (void)loadView {
    NSArray *filtersName = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    NSLog(@"BuiltIn filters :\n%@", filtersName);
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    [self.imageView setCenter:CGPointMake(self.view.bounds.size.width * 0.5, 64 + self.imageView.bounds.size.height * 0.5)];
    [self.view addSubview:self.imageView];

    NSArray *filters = @[@"sepiaTone", @"gaussianBlur", @"anonymousFaces", @"sepiaTone", @"sepiaTone", @"sepiaTone"];
    NSInteger ord = 0;
    for (NSString *filter in filters) {
        UIButton *button = [self buttonWithTitle:filter];
        [button setCenter:CGPointMake(10 + (self.view.bounds.size.width * 0.5) * (ord % 2) + button.bounds.size.width * 0.5, 64 + self.imageView.bounds.size.height + 10 * (1 + ord/2) + button.bounds.size.height * (0.5 + ord / 2))];
        [self.view addSubview:button];
        ++ ord;
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
        [_imageView setImage:[UIImage imageNamed:@"wp001"]];
        self.orgImg = _imageView.image;
    }
    return _imageView;
}

- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 140, 30)];
    [button setBackgroundColor:[UIColor grayColor]];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(processImage:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)processImage:(UIButton *)sender {
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", sender.titleLabel.text]);
    CIFilter *filter = (CIFilter*)[self performSelector:sel withObject:self.orgImg];

    CIContext *context = [CIContext contextWithOptions:NULL];
    CIImage *ciimage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:ciimage fromRect:[ciimage extent]];
    UIImage *uiimage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);

    self.imageView.image = uiimage;
}

- (CIFilter *)sepiaTone:(UIImage *)orgImg {
    NSLog(@"user filters : CISepiaTone");
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setValue:[CIImage imageWithCGImage:self.orgImg.CGImage] forKey:@"inputImage"];
    [filter setValue:@0.8 forKey:@"inputIntensity"];
    return filter;
}

- (CIFilter *)gaussianBlur:(UIImage *)orgImg {
    NSLog(@"user filters : CIGaussianBlur");
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:[CIImage imageWithCGImage:self.orgImg.CGImage] forKey:@"inputImage"];
    [filter setValue:@1 forKey:@"inputRadius"];
    return filter;
}

- (CIFilter *)anonymousFaces:(UIImage *)orgImg {
    NSLog(@"user filters : IVYAnonymousFacesFilter");
    CIFilter *filter = [CIFilter filterWithName:@"IVYAnonymousFacesFilter"];
    [filter setValue:[CIImage imageWithCGImage:self.orgImg.CGImage] forKey:@"inputImage"];
    return filter;
}

@end

