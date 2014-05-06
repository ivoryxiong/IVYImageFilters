//
//  IVYBaseFilterCompositing.m
//  IVYImageFilters
//
//  Created by ivoryxiong on 14-5-6.
//  Copyright (c) 2014年 IVORY. All rights reserved.
//

#import "IVYBaseFilterCompositing.h"

@implementation IVYBaseFilterCompositing

- (UIImage *)filterImage:(UIImage *)image configs:(NSDictionary *)configs {
    _configs = configs;
    _orignalImage = image;
    return _orignalImage;
}

@end
