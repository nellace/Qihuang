//
//  KHLPICSettingsViewController.h
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-16.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQLCustomViewController.h"

@protocol LogoutDelegate <NSObject>
- (void)onLogoutSuccess;
@end

@interface KHLPICSettingsViewController : MQLCustomViewController

@property (nonatomic, assign) id<LogoutDelegate> delegate;

@end
