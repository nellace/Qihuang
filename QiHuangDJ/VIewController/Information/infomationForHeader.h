//
//  infomationForHeader.h
//  QiHuangDJ
//
//  Created by 雅泰  on 14/11/11.
//  Copyright (c) 2014年 雅泰 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface infomationForHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *attachLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;
@property (weak, nonatomic) IBOutlet UIWebView *webViewLaytou;
@end
