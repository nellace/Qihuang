//
//  KHLSearchResultSubViewController.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-11-4.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import "KHLSearchResultSubViewController.h"
#import "KHLInformationTableViewCell.h"
#import "InfomationViewController.h"
#import "DianboViewController.h"
#import "MJRefresh.h"



#pragma mark - DEFINATION AND ENUMERATION

#define INFORMATION_CELL_PROPORTION (90.0f / 320.0f)
#define INFORMATION_MAJOR_TEXT_FONT_PROPORTION (14.0f / 320.0f)
#define INFORMATION_MEDIUM_TEXT_FONT_PROPORTION (12.0f / 320.0f)
#define INFORMATION_MINOR_TEXT_FONT_PROPORTION (10.0f / 320.0f)



#pragma mark - INTERFACE AND IMPLEMENTATION

@interface KHLSearchResultSubViewController () <UITableViewDataSource, UITableViewDelegate>
{
    int pCount;
    NSMutableArray *searchResultArray;
    BOOL headerRefresh;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation KHLSearchResultSubViewController



#pragma mark - ATTRIBUTES GETTER AND SETTER

- (NSMutableArray *)datasource
{
    if (!_datasource) _datasource = [[NSMutableArray alloc] init];
    return _datasource;
}



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setCascTitle:@"搜索结果"];
        [self setFanhui];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRefresh];
    headerRefresh = TRUE;
    pCount = 1;
    searchResultArray = [[NSMutableArray alloc]initWithArray:self.datasource];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resultListed:) name:@"KHLNotiSearchResult" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"KHLNotiSearchResult" object:nil];
}


- (void)resultListed: (NSNotification *)aNotification
{
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
        if (headerRefresh == TRUE) {
            pCount = 1;
            [searchResultArray removeAllObjects];
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
            
//            if ([@"video" isEqualToString:interface.type]) {
//                [videos addObject:interface];
//            } else if ([@"article" isEqualToString:interface.type]) {
//                [informations addObject:interface];
//            }
            
            if ([interface.type isEqualToString:self.type])
                [searchResultArray addObject:interface];
        }
        /*
        KHLSearchResultViewController *searchResultViewController = [[KHLSearchResultViewController alloc] init];
        searchResultViewController.videos = [videos copy];
        searchResultViewController.informations = [informations copy];
        [self.navigationController pushViewController:searchResultViewController animated:TRUE];
         */
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }

}


- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (void)headerRereshing
{
    if (headerRefresh == FALSE) {
        headerRefresh = TRUE;
    }
    [[KHLDataManager instance]searchHUDHolder:self.view keyword:_keyWord page:@"1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    
    if (headerRefresh == TRUE) {
        headerRefresh = FALSE;
    }
        pCount++;
    [[KHLDataManager instance]searchHUDHolder:self.view keyword:_keyWord page:[NSString stringWithFormat:@"%D",pCount]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    });
}

#pragma mark - TABLE VIEW DELEGATE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchResultArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width * INFORMATION_CELL_PROPORTION;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    KHLInformationTableViewCell *iCell = [self.tableView dequeueReusableCellWithIdentifier:@"KHLInformationTableViewCell"];
    if (!iCell) {
        iCell = [[[NSBundle mainBundle] loadNibNamed:@"KHLInformationTableViewCell" owner:self options:nil] firstObject];
    } if (!iCell) {
        iCell = [[KHLInformationTableViewCell alloc] init];
    }
    
    // Configure fonts..
    UIFont *majorFont = [UIFont systemFontOfSize:(self.view.frame.size.width * INFORMATION_MAJOR_TEXT_FONT_PROPORTION)];
    UIFont *mediumFont = [UIFont systemFontOfSize:(self.view.frame.size.width * INFORMATION_MEDIUM_TEXT_FONT_PROPORTION)];
    UIFont *minorFont = [UIFont systemFontOfSize:(self.view.frame.size.width * INFORMATION_MINOR_TEXT_FONT_PROPORTION)];
    [iCell.titleLabel setFont:majorFont];
    [iCell.dateLabel setFont:mediumFont];
    [iCell.descriptionLabel setFont:mediumFont];
    [iCell.browseCountingLabel setFont:minorFont];
    [iCell.posterLabel setFont:minorFont];
    
    // Acquire instance..
    SearchInterface *information = [searchResultArray objectAtIndex:indexPath.row];
    
    // Configure thumb image view..
    if (information.imageUrl && ![information.imageUrl isEqualToString:@""]) {
        [iCell.thumbImageView setImageWithURL:[NSURL URLWithString:information.imageUrl]];
    } else {
        [iCell.thumbImageView setImage:[UIImage imageNamed:@"zhibo_huanchongtu@2x.png"]];
    }
    
    // Configure labels..
    iCell.titleLabel.text = information.title ? information.title : @"（无标题）";
    iCell.dateLabel.text = information.time ? information.time : @"";
    iCell.descriptionLabel.text = information.brief ? information.brief : @"";
    iCell.browseCountingLabel.text = information.count ? information.count : @"";
    iCell.posterLabel.text = information.publisher ? information.publisher : @"";
    
    // Asign table view cell..
    cell = iCell;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Acquire instance..
    SearchInterface *information = [self.datasource objectAtIndex:indexPath.row];
    UIViewController *detailViewController = nil;
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    // Configure prestrain and target view controller..
    if ([@"video" isEqualToString:information.type]) {
        detailViewController = [[DianboViewController alloc] init];
    } else if ([@"article" isEqualToString:information.type]) {
        detailViewController = [[InfomationViewController alloc] init];
        [(InfomationViewController *)detailViewController setPrestrain:information];
    } else {
        // 看来是搜到什么奇怪的东西了……
        return;
    }
    
    // Push to detail view controller..
    [self.navigationController pushViewController:detailViewController animated:TRUE];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

@end
