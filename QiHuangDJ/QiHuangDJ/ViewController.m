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
    //左侧图片
    UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 59, 27)];
    [imgLogo setImage:[UIImage imageNamed:@"shouye_logo.png"]];
    UIBarButtonItem *imgLeft = [[UIBarButtonItem alloc ] initWithCustomView:imgLogo];
    self.navigationItem.leftBarButtonItem = imgLeft;
    //中间导航
    SearchBarCustom *search = [SearchBarCustom new];
    [search customSearchBarUI:@"home"];
    self.navigationItem.titleView = search;
    //右侧按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 40);
    [btn setImage:[UIImage imageNamed:@"nav_btn_shezhi.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(fanhuiBtnMethond) forControlEvents:UIControlEventTouchUpInside];;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] init];
    [leftBtn setCustomView:btn];
    self.navigationItem.rightBarButtonItem = leftBtn;
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
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
    NSLog(@"fjjjfjfjfjjfj");
}

- (IBAction)qihuangyiren:(id)sender {
    SuperStartViewController * superVC = [[SuperStartViewController alloc] initWithNibName:@"SuperStartViewController" bundle:nil];
    [self.navigationController pushViewController:superVC animated:YES];
}
- (IBAction)LOL:(id)sender {
    classify.title = @"英雄联盟";
    [self.navigationController pushViewController:classify animated:YES];
}
- (IBAction)LSchuanshuo:(id)sender {
        classify.title = @"炉石传说";
        [self.navigationController pushViewController:classify animated:YES];
}
- (IBAction)dota2:(id)sender {
        classify.title = @"刀塔2";
        [self.navigationController pushViewController:classify animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end