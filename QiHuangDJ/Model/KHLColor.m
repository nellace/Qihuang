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

/** 小石青 */
+ (UIColor *)xiaoshiqing
{
    return [KHLColor red:189 green:189 blue:189];
}

/** 橘黄 */
+ (UIColor *)juhuang
{
    return [KHLColor red:251 green:97 blue:49];
}

/** 小荼白 */
+ (UIColor *)xiaotubai
{
    return [KHLColor red:250 green:250 blue:250];
}

/** 青灰 */
+ (UIColor *)qinghui
{
    return [KHLColor red:222 green:222 blue:222];
}

/** 棕 */
+ (UIColor *)zong
{
    return [KHLColor red:26 green:13 blue:7];
}

#pragma mark - 工具方法

/*!
 * @method 通过16进制计算颜色
 * @abstract
 * @discussion
 * @param 16机制
 * @result 颜色对象
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}
@end
