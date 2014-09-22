//
//  MQLCustomViewController.m
//  Casc
//
//  Created by uustock1 on 14-6-18.
//  Copyright (c) 2014年 uustock1. All rights reserved.
//

#import "MQLCustomViewController.h"

@interface MQLCustomViewController ()

@end

@implementation MQLCustomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)setCascTitle:(NSString*)title{
    
    NSArray*titleArray=[title componentsSeparatedByString:@""];
    if (titleArray.count) {
        UIView*vc=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 220, 44)];
        vc.backgroundColor=[UIColor clearColor];
        
        UILabel *upLabel=[[UILabel alloc]initWithFrame:CGRectMake(-10, 10, 220, 20)];
        upLabel.textColor=[UIColor colorWithRed:246.0f/255 green:249.0f/255 blue:242.0f/255 alpha:1.0];
        upLabel.font=[UIFont boldSystemFontOfSize:19];
        upLabel.backgroundColor=[UIColor clearColor];
        upLabel.textAlignment=NSTextAlignmentCenter;
        [vc addSubview:upLabel];
        upLabel.text=[titleArray objectAtIndex:0];
        self.navigationItem.titleView=vc;
    }
}
-(void) setFanhui
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 34, 21);
    [btn setImage:[UIImage imageNamed:@"nav_btn_fanhui.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(fanhuiBtn) forControlEvents:UIControlEventTouchUpInside];;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] init];
    [leftBtn setCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
}
-(void)fanhuiBtn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_top.png"] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
