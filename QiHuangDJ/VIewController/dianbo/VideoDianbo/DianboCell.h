//
//  DianboCell.h
//  QiHuangDJ
//
//  Created by 雅泰  on 14/10/28.
//  Copyright (c) 2014年 雅泰 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DianboCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgeWithIcon;
@property (weak, nonatomic) IBOutlet UIButton *jubaoMedhod;
@property (weak, nonatomic) IBOutlet UIButton *huifuMehod;
@property (weak, nonatomic) IBOutlet UILabel *goodCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *badCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
