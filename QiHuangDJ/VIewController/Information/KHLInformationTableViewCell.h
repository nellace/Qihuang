//
//  KHLInformationTableViewCell.h
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-17.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHLInformationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *browseCountingLabel;
@property (weak, nonatomic) IBOutlet UILabel *posterLabel;


@end
