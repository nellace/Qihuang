//
//  KHLColor.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-9-24.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import "KHLColor.h"

@implementation KHLColor

+ (CGFloat)value:(NSUInteger)integer
{
    CGFloat convertedBasicValue = integer > 255 ? 255.0f : (CGFloat)integer;
    return convertedBasicValue / 255.0f;
}

+ (UIColor *)red:(NSUInteger)r green:(NSUInteger)g blue:(NSUInteger)b
{
    return [UIColor colorWithRed:[KHLColor value:r] green:[KHLColor value:g] blue:[KHLColor value:b] alpha:1];
}

/** 素 */
+ (UIColor *)su
{
    return [KHLColor red:255 green:255 blue:255];
}

/** 荼白 */
+ (UIColor *)tubai
{
    return [KHLColor red:245 green:245 blue:245];
}

/** 石青 */
+ (UIColor *)shiqing
{
    return [KHLColor red:173 green:173 blue:173];
}

@end
