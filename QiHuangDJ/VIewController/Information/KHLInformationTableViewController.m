//
//  KHLInformationTableViewController.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-17.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import "KHLInformationTableViewController.h"
#import "KHLInformationTableViewCell.h"
#import "InfomationViewController.h"
#import "MJRefresh.h"



#pragma mark - DEFINATION AND ENUMERATION

#define INFORMATION_CELL_PROPORTION (90.0f / 320.0f)
#define INFORMATION_MAJOR_TEXT_FONT_PROPORTION (14.0f / 320.0f)
#define INFORMATION_MEDIUM_TEXT_FONT_PROPORTION (12.0f / 320.0f)
#define INFORMATION_MINOR_TEXT_FONT_PROPORTION (10.0f / 320.0f)



#pragma mark - INTERFACE AND IMPLEMENTATION

@interface KHLInformationTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *informations;
@property (nonatomic, strong) NSString *currentPage;
@property (nonatomic, strong) NSString *allPages;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, setter=setNeedsRefresh:, getter=needsRefresh) BOOL refreshTag;

@end

@implementation KHLInformationTableViewController



#pragma mark - GETTER AND SETTER

- (NSMutableArray *)informations
{
    if (!_informations) _informations = [[NSMutableArray alloc] init];
    return _informations;
}



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setNeedsRefresh:TRUE];
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Configure navigation bar..
    [self setCascTitle:@"资讯列表"];
    [self setFanhui];
    
    // TEST type model..
    [self setType:@"article"];
    
    // Register notification..
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(informationListNotified:) name:@"KHLNotiInformationListAcquired" object:nil];
    
    // Request data..
    if ([self needsRefresh]) {
        [[KHLDataManager instance] informationListHUDHolder:self.view category:self.category type:self.type keyword:@"" page:@""];
        [self setNeedsRefresh:FALSE];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Remove notification..
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiInformationListAcquired" object:nil];
}


- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [self.tableView headerBeginRefreshing];
}

- (void)headerRereshing
{
    
}

- (void)footerRereshing
{
    
}

#pragma mark - TABLE VIEW DELEGATE

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width * INFORMATION_CELL_PROPORTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.informations.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    tableView.tableFooterView = [UIView new];
    KHLInformationTableViewCell *infoCell = [self.tableView dequeueReusableCellWithIdentifier:@"KHLInformationTableViewCell"];
    if (infoCell == nil) {
        infoCell = [[[NSBundle mainBundle] loadNibNamed:@"KHLInformationTableViewCell" owner:self options:nil] firstObject];
    } if (infoCell == nil) {
        infoCell = [[KHLInformationTableViewCell alloc] init];
    }
    
    // Configure fonts..
    UIFont *majorFont = [UIFont systemFontOfSize:(self.view.frame.size.width * INFORMATION_MAJOR_TEXT_FONT_PROPORTION)];
    UIFont *mediumFont = [UIFont systemFontOfSize:(self.view.frame.size.width * INFORMATION_MEDIUM_TEXT_FONT_PROPORTION)];
    UIFont *minorFont = [UIFont systemFontOfSize:(self.view.frame.size.width * INFORMATION_MINOR_TEXT_FONT_PROPORTION)];
    [infoCell.titleLabel setFont:majorFont];
    [infoCell.dateLabel setFont:mediumFont];
    [infoCell.descriptionLabel setFont:mediumFont];
    [infoCell.browseCountingLabel setFont:minorFont];
    [infoCell.posterLabel setFont:minorFont];
    
    // Acquire instance..
    InformationListInterface *information = [self.informations objectAtIndex:indexPath.row];
    
    // Configure thumb image view..
    if (information.imageUrl && ![information.imageUrl isEqualToString:@""]) {
        [infoCell.thumbImageView setImageWithURL:[NSURL URLWithString:information.imageUrl]];

    } else {
        [infoCell.thumbImageView setImage:[UIImage imageNamed:@"zhibo_huanchongtu@2x.png"]];
    }
    
    // Configure labels..
//    infoCell.titleLabel.text = @"喵描秒妙喵描秒妙喵描秒妙";
//    infoCell.dateLabel.text = @"1544.12.22";
//    NSString *description = @"霓为衣兮风为马。";
//    if (indexPath.row % 3 == 0) description = @"绛罗朱袖起飞云，大武明华瞰雄州。";
//    if (indexPath.row % 3 == 1) description = @"上元点鬟招萼绿，王母挥袂别飞琼。繁音急节十二遍，跳珠撼玉何铿铮。翔鸾舞了却收翅，唳鹤曲终长引声。当时乍见惊心目，凝视谛听殊未足。一落人间八九年，耳冷不曾闻此曲。湓城但听山魈语，巴峡唯闻杜鹃哭。";
//    infoCell.descriptionLabel.text = description;
//    infoCell.browseCountingLabel.text = [NSString stringWithFormat:@"浏览%.0f次", (2000.0f + 17 * indexPath.row)];
//    infoCell.posterLabel.text = @"喵了个咪的";
    infoCell.titleLabel.text = information.title ? information.title : @"（无标题）";
    infoCell.dateLabel.text = information.time ? information.time : @"";
    infoCell.descriptionLabel.text = information.brief ? information.brief : @"";
    infoCell.browseCountingLabel.text = information.count ? information.count : @"";
    infoCell.posterLabel.text = information.publisher ? information.publisher : @"";
    
    // Asign table view cell..
    cell = infoCell;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationListInterface *information = indexPath.row < self.informations.count ? [self.informations objectAtIndex:indexPath.row] : [[InformationListInterface alloc] init];
    SearchInterface *prestrain = [[SearchInterface alloc] init];
    [prestrain setIdentity:information.identity];
    [prestrain setCategory:information.category];
    [prestrain setTitle:information.category];
    [prestrain setCount:information.count];
    [prestrain setBrief:information.brief];
    [prestrain setTime:information.time];
    [prestrain setImageUrl:information.imageUrl];
    [self.tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    InfomationViewController *infoViewController = [[InfomationViewController alloc] init];
    [infoViewController setPrestrain:prestrain];
    [self.navigationController pushViewController:infoViewController animated:TRUE];
}



#pragma mark - NOTIFICATION METHODES

- (void)informationListNotified: (NSNotification *)notification
{
    NSDictionary *dict = notification.object;
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
        
        [self.informations removeAllObjects];
        self.currentPage = [NSString stringWithFormat:@"%@", [result objectForKey:@"page"]];
        self.allPages = [NSString stringWithFormat:@"%@", [result objectForKey:@"size"]];
        NSLog(@"data arr=%@",[result objectForKey:@"data"]);
        for (NSDictionary *data in [result objectForKey:@"data"]) {
            InformationListInterface *interface = [[InformationListInterface alloc] init];
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
            [self.informations addObject:interface];
            
            NSLog(@"export: %@ brief: %@", interface.identity, interface.brief);
        }
        
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
        
        // Refresh list layout after data received..
        [self.tableView reloadData];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}











@end
