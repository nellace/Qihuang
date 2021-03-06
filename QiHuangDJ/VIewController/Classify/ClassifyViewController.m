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
#import "LiveListViewController.h"
#import "KHLInformationTableViewController.h"
#import "KHLSearchResultViewController.h"

@interface ClassifyViewController () <UISearchBarDelegate> {
    UIImageView *backImage;
    NSString *keyWord;
}


@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *moduleImageViews;

@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (nonatomic, strong) NSMutableArray *modules;

@end

@implementation ClassifyViewController



#pragma mark - ATTRIBUTES GETTER AND SETTER

- (NSMutableArray *)modules
{
    if (!_modules) _modules = [[NSMutableArray alloc] init];
    return _modules;
}

- (NSString *)gameId
{
    if (!_gameId) _gameId = @"";
    return _gameId;
}



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
    backImage.hidden = YES;
    [self setCascTitle:self.title];
    
    // Register notifications..
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowWithClass:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidenWithClass:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchResultMethod:) name:@"KHLNotiSearchResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subpageNotified:) name:@"KHLNotiSubpageAcquired" object:nil];
    
    // Request subpage data..
    [[KHLDataManager instance] subpageHUDHolder:self.view category:self.category];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Remove notifications..
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiSearchResult" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiSubpageAcquired" object:nil];
}

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
        NSMutableArray *data = [result objectForKey:@"data"];
        if ([data count] == 0) {
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
        searchResultViewController.keyWord = keyWord;
        [self.navigationController pushViewController:searchResultViewController animated:TRUE];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }

}

#pragma mark - USER INTERACTION RESPONSE

- (IBAction)VideoLive:(id)sender
{
//    VideoLiveViewController * videoLiveVC = [[VideoLiveViewController alloc] initWithNibName:@"VideoLiveViewController" bundle:nil];
//    [self.navigationController pushViewController:videoLiveVC animated:YES];
    LiveListViewController *liveListViewController = [[LiveListViewController alloc] init];
    liveListViewController.gameId = self.gameId;
    [self.navigationController pushViewController:liveListViewController animated:TRUE];
}

- (IBAction)dianbo:(id)sender
{
    DianboListViewController * dianboVC = [[DianboListViewController alloc] initWithNibName:@"DianboListViewController" bundle:nil];
    SubpageInterface *interface = [self.modules objectAtIndex:1];
    if (interface) {
        dianboVC.category = interface.category;
    }
    
//    NSLog(@"%@",dic);
//    dianboVC.category = [dic objectForKey:@"_category"];
    [self.navigationController pushViewController:dianboVC animated:YES];
}

- (IBAction)Infomation:(id)sender
{
    KHLInformationTableViewController *informationViewController = [[KHLInformationTableViewController alloc] init];
    SubpageInterface *interface = [self.modules objectAtIndex:2];
    if (interface) {
        informationViewController.category = interface.category;
    }
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
    //sg
    KHLSearchResultViewController *search = [[KHLSearchResultViewController alloc]init];
    keyWord = searchBar.text;
    [[KHLDataManager instance] searchHUDHolder:self.view keyword:searchBar.text page:@""];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // [self.search resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    backImage.alpha = 0.1;
//    [backImage removeFromSuperview];
    
}



#pragma mark - CUSTOM LAYOUT METHODES

- (void)refreshModules
{
    if (self.modules.count < 3) {
        return;
    } else {
        for (int i = 0; i < 3; i++) {
            [[self.moduleImageViews objectAtIndex:i] setImageWithURL:[NSURL URLWithString:[[self.modules objectAtIndex:i] imageUrl]]];
        }
    }
}




#pragma mark - NOTIFICATION METHODES

- (void)subpageNotified: (NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    if (!dict) {
        NSLog(@"妈蛋，返回nil了。");
        return;
    }
    
    if ([[dict objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        
        NSDictionary *result = [dict objectForKey:@"result"];
        if ((!result) || (result.count == 0)) {
            NSLog(@"妈蛋，result里没东西。");
            [[[UIAlertView alloc] initWithTitle:@"后台错误" message:@"result为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }
        
        [self.modules removeAllObjects];
        for (NSDictionary *data in result) {
            SubpageInterface *interface = [[SubpageInterface alloc] init];
            interface.category = [NSString stringWithFormat:@"%@", [data objectForKey:@"cate_id"]];
            interface.title = [NSString stringWithFormat:@"%@", [data objectForKey:@"title"]];
            interface.imageUrl = [NSString stringWithFormat:@"%@", [data objectForKey:@"image"]];
            interface.type = [NSString stringWithFormat:@"%@", [data objectForKey:@"model"]];
            [self.modules addObject:interface];
        }
        
        // Refresh modules..
        [self refreshModules];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}





@end
