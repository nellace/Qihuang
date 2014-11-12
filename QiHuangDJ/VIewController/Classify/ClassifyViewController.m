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

@interface ClassifyViewController () <UISearchBarDelegate>
{
    UIImageView *backImage;
}
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
//    UISearchBar *se = [[SearchBarCustom alloc] init];
//    self.search = se;
    [self setFanhui];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHiden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setCascTitle:self.title];
}
//sg

- (void)keyboardShow :(NSNotification *)noti {
    backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImage.backgroundColor = [UIColor grayColor];
    backImage.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHid)];
    [backImage addGestureRecognizer:tap];
    backImage.alpha = 0.4;
    [self.view addSubview:backImage];
}

- (void)keyboardHiden:(NSNotification *)noti {
    
    [backImage removeFromSuperview];
}

- (void)keyboardHid {
    [self.search resignFirstResponder];
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
#pragma mark - UISEARCHBAR DELEGATE
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
@end
