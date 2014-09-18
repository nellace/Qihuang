//
//  ViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "ViewController.h"
#import "ClassifyViewController.h"
#import "VideoLiveViewController.h"
#import "SuperStartViewController.h"
#import "LoginViewController.h"
#import "PersonCenterViewController.h"
@interface ViewController ()

@end

@implementation ViewController {
    ClassifyViewController *classify ;
    BOOL isLogin;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isLogin = NO;  //判断是否登录过
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    classify = [[ClassifyViewController alloc] initWithNibName:@"ClassifyViewController" bundle:nil];
    [self navUI];
}

- (void)navUI {
    //左侧按钮
    
    //中部搜索条
    
    //右侧按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 34, 21);
    [btn setTitle:@"设置" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(fanhuiBtnMethond) forControlEvents:UIControlEventTouchUpInside];;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] init];
    [leftBtn setCustomView:btn];
    self.navigationItem.rightBarButtonItem = leftBtn;
}

- (void)fanhuiBtnMethond {
    if (isLogin) {
        
        PersonCenterViewController * personCenterVC = [[PersonCenterViewController alloc] initWithNibName:@"PersonCenterViewController" bundle:nil];
        [self.navigationController pushViewController:personCenterVC animated:YES];

    } else {
        isLogin = YES;
        LoginViewController * loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (IBAction)zhibo:(id)sender {
    VideoLiveViewController * videoLiveVC = [[VideoLiveViewController alloc] initWithNibName:@"VideoLiveViewController" bundle:nil];
    [self.navigationController pushViewController:videoLiveVC animated:YES];
}

- (IBAction)qihuangyiren:(id)sender {
    SuperStartViewController * superVC = [[SuperStartViewController alloc] initWithNibName:@"SuperStartViewController" bundle:nil];
    [self.navigationController pushViewController:superVC animated:YES];
}
- (IBAction)LOL:(id)sender {
    [self.navigationController pushViewController:classify animated:YES];
}
- (IBAction)LSchuanshuo:(id)sender {
        [self.navigationController pushViewController:classify animated:YES];
}
- (IBAction)dota2:(id)sender {
        [self.navigationController pushViewController:classify animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
