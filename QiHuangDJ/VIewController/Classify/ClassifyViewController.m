//
//  ClassifyViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "ClassifyViewController.h"
#import "VideoLiveViewController.h"

#import "InfomationViewController.h"
#import "DianboListViewController.h"
@interface ClassifyViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *search;

@end

@implementation ClassifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self setFanhui];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UISearchBar *se = [[SearchBarCustom alloc] init];
    self.search = se;
}
- (void)viewWillAppear:(BOOL)animated {
    [self setCascTitle:self.title];
}
- (void)viewWillLayoutSubviews {

}
- (IBAction)VideoLive:(id)sender {
    VideoLiveViewController * videoLiveVC = [[VideoLiveViewController alloc] initWithNibName:@"VideoLiveViewController" bundle:nil];
    [self.navigationController pushViewController:videoLiveVC animated:YES];
}
- (IBAction)dianbo:(id)sender {
    DianboListViewController * dianboVC = [[DianboListViewController alloc] initWithNibName:@"DianboListViewController" bundle:nil];
    [self.navigationController pushViewController:dianboVC animated:YES];
}
- (IBAction)Infomation:(id)sender {
    InfomationViewController *infoVC = [[InfomationViewController alloc] initWithNibName:@"InfomationViewController" bundle:nil];
    [self.navigationController pushViewController:infoVC animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
