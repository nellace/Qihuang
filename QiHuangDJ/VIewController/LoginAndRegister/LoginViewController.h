//
//  LoginViewController.h
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "MQLCustomViewController.h"
#import "UMSocial.h"
@protocol LoginDelegate <NSObject>
-(void)onLoginSuccess;
-(void)onLoginFailed;
@end

@interface LoginViewController : MQLCustomViewController <UMSocialUIDelegate,UITextFieldDelegate>

@property(nonatomic, assign) id<LoginDelegate> delegate;

@end
