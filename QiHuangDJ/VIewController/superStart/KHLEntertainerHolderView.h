//
//  KHLEntertainerHolderView.h
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-9.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHLEntertainer.h"

@interface KHLEntertainerHolderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *programmeLabel;
@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;
@property (weak, nonatomic) IBOutlet UIView *holderView;
@property (weak, nonatomic) IBOutlet UIScrollView *holderScrollView;
@property (weak, nonatomic) IBOutlet UIView *experienceHolder;

- (void)loadData:(KHLEntertainer *)entertainer useWindowSize:(CGSize)size;

@end
