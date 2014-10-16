//
//  KHLPICHeaderView.h
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-14.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//
//  Keahoarl Personal Information Center Header View Template
//

#import <UIKit/UIKit.h>

@protocol KHLPICHeaderViewDelegate <NSObject>
//- (void)onPressPhotoImageView;
- (void)onPressMyCollectionButton;
- (void)onPressMySubscriptionButton;
@end

@interface KHLPICHeaderView : UIView

@property (nonatomic, assign) id<KHLPICHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonHolder;
@property (weak, nonatomic) IBOutlet UIButton *myCollectionButton;
@property (weak, nonatomic) IBOutlet UIButton *mySubscriptionButton;

@property (strong, nonatomic) UIView *buttonIndicatorView;

@end
