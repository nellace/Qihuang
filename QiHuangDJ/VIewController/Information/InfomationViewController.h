//
//  InfomationViewController.h
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "MQLCustomViewController.h"

@interface InfomationViewController : MQLCustomViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) SearchInterface *prestrain;
@property (nonatomic,retain) IBOutlet UIButton *likeBtn;
@end
