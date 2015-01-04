//
//  UIWebView+sizeToFitWithImage.m
//  QiHuangDJ
//
//  Created by yatai on 15/1/4.
//  Copyright (c) 2015年 yatai. All rights reserved.
//

#import "UIWebView+sizeToFitWithImage.h"

@implementation UIWebView (sizeToFitWithImage)

-(void)sizeToFitWithImage:(NSMutableString *)htmlCode {
    [htmlCode appendString:@"<html>"];
    [htmlCode appendString:@"<head>"];
//    [htmlCode appendString:@"<meta charset=/"utf-8/">"];
//    [htmlCode appendString:@"<meta id=/"viewport/" name=/"viewport/" content=/"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false/" />"];
//    [htmlCode appendString:@"<meta name=/"apple-mobile-web-app-capable/" content=/"yes/" />"];
//    [htmlCode appendString:@"<meta name=/"apple-mobile-web-app-status-bar-style/" content=/"black/" />"];
//    [htmlCode appendString:@"<meta name=/"black/" name=/"apple-mobile-web-app-status-bar-style/" />"];
    [htmlCode appendString:@"<style>img{width:100%;}</style>"];
    [htmlCode appendString:@"<style>table{width:100%;}</style>"];
    [htmlCode appendString:@"<title>webview</title>"];
    
    [self loadHTMLString:htmlCode baseURL:nil];
}
@end
