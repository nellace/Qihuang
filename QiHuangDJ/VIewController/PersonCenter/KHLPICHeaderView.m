//
//  KHLPICHeaderView.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-14.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//
//  Keahoarl Personal Information Center Header View Template
//

#import "KHLPICHeaderView.h"

@implementation KHLPICHeaderView



#pragma mark - VIEW LIFECYCLE

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    
    return self;
}



#pragma mark - CUSTOM METHODES

- (void)initialization
{
    NSLog(@"initialization");
}



#pragma mark - USER INTERACTION RESPONSE

- (IBAction)pressMyCollectionButton:(UIButton *)sender
{
    [self.delegate onPressMyCollectionButton];
}

- (IBAction)pressMySubscriptionButton:(UIButton *)sender
{
    [self.delegate onPressMySubscriptionButton];
}

//- (void)pressPhotoImageView
//{
//    [self.delegate onPressPhotoImageView];
//}

@end
