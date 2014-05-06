//
//  IVYViewController.m
//  IVYImageFilters
//
//  Created by ivoryxiong on 14-5-6.
//  Copyright (c) 2014年 IVORY. All rights reserved.
//

#import "IVYViewController.h"
#import "IVYAnonymousFacesCompositing.h"
#import "IVYVignetteFaceCompositing.h"
#import "IVYOldFilmCompositing.h"

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

    NSArray *filters = @[@"anonymousFaces", @"vignetteFace", @"anonymousFaces", @"anonymousFaces", @"anonymousFaces", @"sepiaTone"];
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
    UIImage * processedImage = (UIImage*)[self performSelector:sel withObject:self.orgImg];
    self.imageView.image = processedImage;
}

- (UIImage *)sepiaTone:(UIImage *)orgImg {
    NSLog(@"user filters : IVYOldFilmCompositing");
    IVYBaseFilterCompositing  *compositing = [[IVYOldFilmCompositing alloc] init];
    return [compositing filterImage:orgImg configs:nil];
}

- (UIImage *)anonymousFaces:(UIImage *)orgImg {
    NSLog(@"user filters : IVYAnonymousFacesFilter");
    IVYBaseFilterCompositing  *compositing = [[IVYAnonymousFacesCompositing alloc] init];
    return [compositing filterImage:orgImg configs:nil];
}

- (UIImage *)vignetteFace:(UIImage *)orgImg {
    NSLog(@"user filters : IVYVignetteFaceCompositing");
    IVYBaseFilterCompositing  *compositing = [[IVYVignetteFaceCompositing alloc] init];
    return [compositing filterImage:orgImg configs:nil];
}
@end

