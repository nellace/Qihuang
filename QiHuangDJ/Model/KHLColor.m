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

+ (UIColor *)transWhite
{
    return [UIColor colorWithRed:[KHLColor value:255] green:[KHLColor value:255] blue:[KHLColor value:255] alpha:0.7];
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

# pragma mark
# pragma mark 计算时间方法
+(NSString*)returnTheTimelabel:(NSString*)theTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * d = [dateFormatter dateFromString:theTime];
    
    NSDate *now = [[NSDate alloc]init];
    
    
    NSTimeInterval late = [now timeIntervalSinceDate:d];
    NSString *returnStr ;
    if(late<3600)
    {
        if ((int)(late/60) == 0 )
        {
            returnStr = @"刚刚";
        }else
        {
            returnStr = [NSString stringWithFormat:@"%i分前",(int)(late/60)];
        }
    }
    else if(late>=3600&&late<3600*24) {
        returnStr = [NSString stringWithFormat:@"%i小时前",(int)(late/3600)];
    }
    else if(late>=3600*24&&late<3600*48)
    {
        returnStr = [NSString stringWithFormat:@"昨天"];
    }
    else
    {
        //NSDateFormatter *dateFormatter1 =[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *returnYear = [dateFormatter stringFromDate:d];
        NSString *nowReturnYear = [dateFormatter stringFromDate:now];
        
        
        if([returnYear isEqualToString:nowReturnYear])
        {
            [dateFormatter setDateFormat:@"MM-dd"];
            
            returnStr = [dateFormatter stringFromDate:d];
        }
        else
        {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            returnStr = [dateFormatter stringFromDate:d];
        }
    }
    return returnStr;
}

+ (BOOL)isLogin {
    NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
    NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
    if (!(uidStr == nil || tokenStr == nil)) {
        return YES;
    } else {
        
        return NO;
    }
}

@end
