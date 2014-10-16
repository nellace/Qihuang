//
//  KHLPICVideoItemCell.h
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-15.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHLPICVideoItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *browseCountingLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
