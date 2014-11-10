//
//  KHLColor.h
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-9-24.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHLColor : NSObject

+ (UIColor *)tubai;
+ (UIColor *)shiqing;
+ (UIColor *)juhuang;
+ (UIColor *)xiaotubai;
+ (UIColor *)qinghui;
+ (UIColor *)xiaoshiqing;
+ (UIColor *)zong;
+ (UIColor *)transWhite;

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

@end
