//
//  ClassifyViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "ClassifyViewController.h"
#import "VideoLiveViewController.h"
//#import "NewsViewController.h"
#import "InfomationViewController.h"
#import "DianboListViewController.h"
#import "KHLInformationTableViewController.h"

@interface ClassifyViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *search;

@end

@implementation ClassifyViewController



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UISearchBar *se = [[SearchBarCustom alloc] init];
    self.search = se;
    [self setFanhui];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setCascTitle:self.title];
}



#pragma mark - USER INTERACTION RESPONSE

- (IBAction)VideoLive:(id)sender
{
    VideoLiveViewController * videoLiveVC = [[VideoLiveViewController alloc] initWithNibName:@"VideoLiveViewController" bundle:nil];
    [self.navigationController pushViewController:videoLiveVC animated:YES];
}

- (IBAction)dianbo:(id)sender
{
    DianboListViewController * dianboVC = [[DianboListViewController alloc] initWithNibName:@"DianboListViewController" bundle:nil];
    dianboVC.category = self.category;
    [self.navigationController pushViewController:dianboVC animated:YES];
}

- (IBAction)Infomation:(id)sender
{
    KHLInformationTableViewController *informationViewController = [[KHLInformationTableViewController alloc] init];
    informationViewController.category = self.category;
    [self.navigationController pushViewController:informationViewController animated:TRUE];
}

@end
