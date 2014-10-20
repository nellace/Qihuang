//
//  InfomationViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "InfomationViewController.h"

@interface InfomationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *attachLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end

@implementation InfomationViewController



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setCascTitle:@"资讯详情"];
    [self setFanhui];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - ???

- (void)refreshData
{
    NSString *content = @"致身千乘卿相归把钓渔钩春昼五湖烟浪秋夜一天云月此外尽悠悠永弃人间事吾道付沧州";
    NSString *finalContent = @"";
    //NSUInteger i = 2 + arc4random()%5;
    for (int i = 0; i < 5 + 3 * arc4random()%10; i++) {
        finalContent = [NSString stringWithFormat:@"%@%@", finalContent, content];
    }
    
    [self.bodyLabel setText:finalContent];
}



@end
