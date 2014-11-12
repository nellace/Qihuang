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
#import "KHLSearchResultViewController.h"
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
    
   
    backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height)];
    backImage.backgroundColor = [UIColor blackColor];
    backImage.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHiddenWithTap)];
    [backImage addGestureRecognizer:tap];
    backImage.alpha = 0.6f;
    backImage.hidden = YES;
    [self.view addSubview:backImage];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowWithClass:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidenWithClass:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchResultMethod:) name:@"KHLNotiSearchResult" object:nil];
    
    backImage.hidden = YES;
    [self setCascTitle:self.title];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiSearchResult" object:nil];
}
//sg

- (void)keyboardShowWithClass :(NSNotification *)noti {

    backImage.hidden = NO;
}

- (void)keyboardHidenWithClass:(NSNotification *)noti {
    backImage.hidden = YES;
}

- (void)keyboardHiddenWithTap {
    [self.search resignFirstResponder];
    self.search.text = @"";
    
}

- (void)searchResultMethod:(NSNotification *)aNotification {
    NSDictionary *dict = aNotification.object;
    if (!dict) {
        NSLog(@"妈蛋，返回nil了。");
        return;
    }
    
    if ([[dict objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        
        NSDictionary *result = [dict objectForKey:@"result"];
        if (!result) {
            NSLog(@"妈蛋，result里没东西。");
            [[[UIAlertView alloc] initWithTitle:@"后台错误" message:@"result为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }
        
        NSMutableArray *videos = [[NSMutableArray alloc] init];
        NSMutableArray *informations = [[NSMutableArray alloc] init];
        
        //        [self.informations removeAllObjects];
        //        self.currentPage = [NSString stringWithFormat:@"%@", [result objectForKey:@"page"]];
        //        self.allPages = [NSString stringWithFormat:@"%@", [result objectForKey:@"size"]];
        //        NSLog(@"data arr=%@",[result objectForKey:@"data"]);
        for (NSDictionary *data in [result objectForKey:@"data"]) {
            SearchInterface *interface = [[SearchInterface alloc] init];
            interface.page = [NSString stringWithFormat:@"%@", [result objectForKey:@"page"]];
            interface.size = [NSString stringWithFormat:@"%@", [result objectForKey:@"size"]];
            interface.identity = [NSString stringWithFormat:@"%@", [data objectForKey:@"info_id"]];
            interface.category = [NSString stringWithFormat:@"%@", [data objectForKey:@"cate_id"]];
            interface.title = [NSString stringWithFormat:@"%@", [data objectForKey:@"title"]];
            interface.imageUrl = [NSString stringWithFormat:@"%@", [data objectForKey:@"image"]];
            interface.brief = [NSString stringWithFormat:@"%@", [data objectForKey:@"content"]];
            interface.count = [NSString stringWithFormat:@"%@", [data objectForKey:@"count"]];
            interface.publisher = [NSString stringWithFormat:@"%@", [data objectForKey:@"nickname"]];
            interface.time = [NSString stringWithFormat:@"%@", [data objectForKey:@"time"]];
            interface.type = [NSString stringWithFormat:@"%@", [data objectForKey:@"model"]];
            
            if ([@"video" isEqualToString:interface.type]) {
                [videos addObject:interface];
            } else if ([@"article" isEqualToString:interface.type]) {
                [informations addObject:interface];
            }
        }
        //
        //        // TEST
        //        for (int i = 0; i < 8; i++) {
        //            InformationListInterface *interface = [[InformationListInterface alloc] init];
        //            interface.identity = @"1";
        //            interface.category = self.category;
        //            interface.title = @"大风！大风！大风！";
        //            interface.imageUrl = @"";
        //            interface.brief = @"上元点鬟招萼绿，王母挥袂别飞琼。繁音急节十二遍，跳珠撼玉何铿铮。翔鸾舞了却收翅，唳鹤曲终长引声。当时乍见惊心目，凝视谛听殊未足。一落人间八九年，耳冷不曾闻此曲。湓城但听山魈语，巴峡唯闻杜鹃哭。";
        //            interface.count = @"1776";
        //            interface.publisher = @"赢扶苏";
        //            interface.time = @"1368-10-01";
        //            interface.type = self.type;
        //            [self.informations addObject:interface];
        //        }
        //
        // Push to search result view controller..
        KHLSearchResultViewController *searchResultViewController = [[KHLSearchResultViewController alloc] init];
        searchResultViewController.videos = [videos copy];
        searchResultViewController.informations = [informations copy];
        [self.navigationController pushViewController:searchResultViewController animated:TRUE];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }

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
    //[self.search resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //[self.search resignFirstResponder];
    if (searchBar.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [[KHLDataManager instance] searchHUDHolder:self.view keyword:searchBar.text];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // [self.search resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    backImage.alpha = 0.1;
//    [backImage removeFromSuperview];
    
}
@end
