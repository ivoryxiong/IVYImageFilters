//
//  IVYBaseFilterCompositing.h
//  IVYImageFilters
//
//  Created by ivoryxiong on 14-5-6.
//  Copyright (c) 2014年 IVORY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVYBaseFilterCompositing : NSObject
@property (nonatomic, strong, readonly) NSDictionary *configs;
@property (nonatomic, strong, readonly) UIImage *orignalImage;

- (UIImage *)filterImage:(UIImage *)image configs:(NSDictionary *)configs;

@end
