//
//  JubaoViewController.h
//  QiHuangDJ
//
//  Created by 雅泰  on 14/11/10.
//  Copyright (c) 2014年 雅泰 . All rights reserved.
//

#import "MQLCustomViewController.h"

@interface JubaoViewController : MQLCustomViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSString *pinglunId;
@end
