//
//  DianboViewController.h
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "MQLCustomViewController.h"

@interface DianboViewController : MQLCustomViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) NSString *info_id;
@end
