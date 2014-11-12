//
//  PersonCenterViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "LoginViewController.h"

#import "KHLColor.h"
#import "KHLPICHeaderView.h"
#import "KHLPICRecommendedCell.h"
#import "KHLPICVideoItemCell.h"
#import "KHLPICSettingsViewController.h"
#import "KHLPICProfileViewController.h"

#pragma mark - DEFINATION AND ENUMERATION

#define COMMON_ITEM_DIVIDER_HEIGHT (2.0f)
#define HEADER_VIEW_HEIGHT (240.0f)
#define RECOMMENDED_INDICATOR_LABEL_HEIGHT (40.0f)
#define RECOMMENDED_CELL_PROPORTION (105.0f / 320.0f)
#define RECOMMENDED_LABEL_FONT_PROPORTION (11.0f / 320.0f)
#define VIDEO_CELL_PROPORTION (90.0f / 320.0f)
#define VIDEO_THUMB_IMAGE_PROPORTION (120.0f / 90.0f)
#define VIDEO_MAJOR_TEXT_FONT_PROPORTION (13.0f / 320.0f)
#define VIDEO_MINOR_TEXT_FONT_PROPORTION (11.0f / 320.0f)
#define VIDEO_CELL_TEXT_PADDING (6.0f)

typedef NS_ENUM(NSUInteger, KHLPICListState) {
    KHLPICListStateRecommend = 0,
    KHLPICListStateSubscription = 1,
    KHLPICListStateCollection = 2
};



#pragma mark - PROPERTIES AND IMPLEMENTATIONS

@interface PersonCenterViewController () <LoginDelegate, LogoutDelegate, KHLPICHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *pageHolder;
@property (weak, nonatomic) IBOutlet UIView *thumbHolder;
@property (weak, nonatomic) IBOutlet UIView *contentHolder;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, setter = setLogIn:, getter = isLogIn) BOOL bLogIn;
//@property (nonatomic) NSUInteger templateUsingState; // 1 for collection, 2 for subscription, 0 or else for unlogged..
@property (nonatomic) CGFloat contentFrameHeight;
@property (nonatomic, strong) NSString *currentPage;
@property (nonatomic, strong) NSString *allPages;
@property (nonatomic, strong) NSMutableArray *recommends;
@property (nonatomic, strong) NSMutableArray *subscriptions;
@property (nonatomic, strong) NSMutableArray *collections;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *token;

@property (nonatomic, getter = needRequestData) BOOL dataRequestTag;
@property (nonatomic) KHLPICListState state;

@property (nonatomic, strong) KHLPICHeaderView *headerView;

@end

@implementation PersonCenterViewController








#pragma mark - VIEW CONTROLLER LIFECYCLE

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.state = KHLPICListStateCollection;
        self.uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
        self.token = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
        [self setDataRequestTag:TRUE];
        if ((!self.uid) || (!self.token) || [self.uid isEqualToString:@""] || [self.token isEqualToString:@""]) {
            [self setLogIn:FALSE];
        } else {
            [self setLogIn:TRUE];
        }
    } return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    // Set background image for base view..
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bg@2x.png"]]];
    
    // Draw navigation bar..
    [self setNavigationRightButton];
    [self setCascTitle:@"个人中心"];
    [self setFanhui];
    
    // Register notification..
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recommendListNotified:) name:@"KHLNotiRecommendListAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subscriptionListNotified:) name:@"KHLNotiSubscriptionListAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectionListNotified:) name:@"KHLNotiCollectionListAcquired" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Remove notification..
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiRecommendListAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiSubscriptionListAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiCollectionListAcquired" object:nil];
}

- (void)viewDidLayoutSubviews
{
    [self refreshPhotoImageView];
    
    self.uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
    self.token = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
    if ((!self.uid) || (!self.token) || [self.uid isEqualToString:@""] || [self.token isEqualToString:@""]) {
        [self setLogIn:FALSE];
    } else {
        [self setLogIn:TRUE];
    }
    
    if ([self needRequestData]) {
        NSLog(@"did layout subviews. login? %d", self.isLogIn);
        
        // Post data request..
        if (self.isLogIn) {
            //[[KHLDataManager instance] subscriptionListHUDHolder:self.view uid:self.uid token:self.token];
            [self performSelector:@selector(onPressMyCollectionButton) withObject:nil];
            
        } else {
            [[KHLDataManager instance] recommendListHUDHolder:self.view];
        }
        
        [self setDataRequestTag:FALSE];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - ATTRIBUTES GETTER AND SETTER

- (void)setLogIn:(BOOL)bLogIn
{
    _bLogIn = bLogIn;
    if (bLogIn) {
        if (self.state == KHLPICListStateRecommend)
            self.state = KHLPICListStateCollection;
    } else {
        self.state = KHLPICListStateRecommend;
    }
    
    //[self refreshTableView];
}

- (NSMutableArray *)recommends
{
    if (!_recommends) _recommends = [[NSMutableArray alloc] init];
    return _recommends;
}

- (NSMutableArray *)subscriptions
{
    if (!_subscriptions) _subscriptions = [[NSMutableArray alloc] init];
    return _subscriptions;
}

- (NSMutableArray *)collections
{
    if (!_collections) _collections = [[NSMutableArray alloc] init];
    return _collections;
}





#pragma mark - LAYOUT CUSTOM METHODES

- (void)setNavigationRightButton
{
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setFrame:CGRectMake(0, 0, 32, 40)];
    [settingsButton setImage:[UIImage imageNamed:@"nav_btn_shezhi.png"] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(pushToSettingsViewController)
             forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    self.navigationItem.rightBarButtonItem = settingsBarButton;
}

- (void)pushToSettingsViewController
{
    KHLPICSettingsViewController *settingsViewController = [[KHLPICSettingsViewController alloc] init];
    settingsViewController.delegate = self;
    settingsViewController.displayLogoutButton = [self isLogIn];
    [self.navigationController pushViewController:settingsViewController animated:TRUE];
}



# pragma mark - LOGIN VIEW CONTROLLER DELEGATE

- (void)onLoginSuccess
{
    NSLog(@"onLoginSuccess Implementation");
//    [self setDataRequestTag:FALSE];
    [self setLogIn:TRUE];
    [self performSelector:@selector(onPressMyCollectionButton) withObject:nil];
}

-(void)onLoginFailed
{
    [self setLogIn:FALSE];
}

- (void)onLogoutSuccess
{
    NSLog(@"onLogoutSuccess Implementation");
//    [self setDataRequestTag:FALSE];
    [self setLogIn:FALSE];
    [[KHLDataManager instance] recommendListHUDHolder:self.view];
}



#pragma mark - TABLE VIEW PROTOCOL

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_VIEW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLogIn) {
        return self.view.frame.size.width * VIDEO_CELL_PROPORTION;
    } else {
        if (indexPath.row == 0) {
            return RECOMMENDED_INDICATOR_LABEL_HEIGHT;
        } else {
            return self.view.frame.size.width * RECOMMENDED_CELL_PROPORTION;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"KHLPICHeaderView" owner:self options:nil] firstObject];
    [self.headerView setDelegate:self];
    [self configureHeaderView];
    return self.headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.isLogIn) {
        return [self.recommends count] / 2 + ([self.recommends count] % 2 == 0 ? 0 : 1) + 1;
    } else if (self.state == KHLPICListStateSubscription) {
        return self.subscriptions.count;
    } else if (self.state == KHLPICListStateCollection) {
        return self.collections.count;
    } else {
        NSLog(@"will never appear..");
        return 8;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    // Logged In Template
    if (self.isLogIn) {
        
        // Create video item cell if no reusable template available..
        KHLPICVideoItemCell *viCell = [self.tableView dequeueReusableCellWithIdentifier:@"KHLPICVideoItemCell"];
        if (viCell == nil) {
            viCell = [[[NSBundle mainBundle] loadNibNamed:@"KHLPICVideoItemCell" owner:self options:nil] firstObject];
        }
        
        // Configure text attributes..
        UIFont *majorFont = [UIFont systemFontOfSize:(self.view.frame.size.width * VIDEO_MAJOR_TEXT_FONT_PROPORTION)];
        UIFont *minorFont = [UIFont systemFontOfSize:(self.view.frame.size.width * VIDEO_MINOR_TEXT_FONT_PROPORTION)];
        [viCell.browseCountingLabel setFont:minorFont];
        [viCell.dateLabel setFont:minorFont];
        
        // Configure title label..
        CGFloat subscribedTextWidth = viCell.dateLabel.frame.size.width;
        CGFloat subscribedTextHeight = viCell.frame.size.height - viCell.dateLabel.frame.size.height;
        NSString *description = @"";
        
        if (self.state == KHLPICListStateSubscription) {
            SubscriptionListInterface *interface = (indexPath.row < self.subscriptions.count ?
                                                    self.subscriptions[indexPath.row] : nil);
            
            // Configure thumb image view..
            [viCell.thumbImageView setImageWithURL:[NSURL URLWithString:interface.imageUrl]];
            
            // Configure title label..
            description = interface.title;
            
            // Configure attached information text..
            NSString *dateString = [interface.time length] > 10 ? [interface.time substringToIndex:10] : interface.time;
            [viCell.browseCountingLabel setText:[NSString stringWithFormat:@"浏览量：%@", interface.count]];
            [viCell.dateLabel setText:[NSString stringWithFormat:@"%@", dateString]];
            
        } else {
            CollectionListInterface *interface = (indexPath.row < self.collections.count ?
                                                  self.collections[indexPath.row] : nil);
            
            // Configure thumb image view..
            [viCell.thumbImageView setImageWithURL:[NSURL URLWithString:interface.imageUrl]];
            
            // Configure title label..
            description = interface.title;
            
            // Configure attached information text..
            [viCell.browseCountingLabel setText:[NSString stringWithFormat:@"浏览量：%@", interface.count]];
            [viCell.dateLabel setText:[NSString stringWithFormat:@"%@", interface.time]];
        }
        
        // Calculate description text..
        CGRect standardizedRect = [description boundingRectWithSize:CGSizeMake(subscribedTextWidth, MAXFLOAT)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:majorFont}
                                                            context:nil];
        [viCell.titleLabel setText:description];
        [viCell.titleLabel setTextColor:[UIColor blackColor]];
        [viCell.titleLabel setFont:majorFont];
        if (standardizedRect.size.height > subscribedTextHeight) {
            standardizedRect.size.height = 3 * [[NSString stringWithFormat:@"明"] boundingRectWithSize:CGSizeMake(subscribedTextWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:majorFont} context:nil].size.height;
        }
        standardizedRect.origin.y = VIDEO_CELL_TEXT_PADDING;
        standardizedRect.origin.x = viCell.titleLabel.frame.origin.x;
        [viCell.titleLabel setFrame:standardizedRect];
        [viCell.titleLabel setNumberOfLines:3];
        [viCell.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [viCell.titleLabel setTextAlignment:NSTextAlignmentNatural];
        
        // Asign video item cell to return cell..
        cell = viCell;
    }
    
    // Recommended Template
    else {
        
        // Create first row recommended indicator label..
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KHLPICRecommendedLabelCell"];
            cell.backgroundColor = [KHLColor tubai];
            [cell.imageView setImage:[UIImage imageNamed:@"gerenzhongxin_hongline.png"]];
            cell.textLabel.text = @"为我推荐";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.selectionStyle = UITableViewCellAccessoryNone;
            return cell;
        }
        
        // Create recommended cell if no reusable template available..
        KHLPICRecommendedCell *recoCell = [self.tableView dequeueReusableCellWithIdentifier:@"KHLPICRecommendedCell"];
        if (recoCell == nil) {
            recoCell = [[[NSBundle mainBundle] loadNibNamed:@"KHLPICRecommendedCell" owner:self options:nil] firstObject];
        }
        
        // Create instance of current using entity..
        NSInteger counter = indexPath.row * 2;
        RecommendListInterface *l = [self.recommends objectAtIndex:counter - 2];
        RecommendListInterface *r = nil;
        if (counter - 1 < [self.recommends count]) {
            r = [self.recommends objectAtIndex:counter - 1];
        } else {
            [recoCell.rightBackdropView setHidden:TRUE];
            [recoCell.rightImageView setHidden:TRUE];
            [recoCell.rightLabel setHidden:TRUE];
        }
        
        // Configure recommended cell image..
        if (l) {
            [recoCell.leftImageView setImageWithURL:[NSURL URLWithString:l.imageUrl]];
            [recoCell.leftLabel setText:l.title];
        }
        
        if (r) {
            [recoCell.rightImageView setImageWithURL:[NSURL URLWithString:r.imageUrl]];
            [recoCell.rightLabel setText:r.title];
        }
        
        // Configure recommended cell label..
        UIFont *labelFont = [UIFont systemFontOfSize:self.view.frame.size.width * RECOMMENDED_LABEL_FONT_PROPORTION];
        [recoCell.leftLabel setFont:labelFont];
        [recoCell.rightLabel setFont:labelFont];
        
        // Asign recommended cell to return cell..
        cell = recoCell;
    }
    
    //cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}


#pragma makr - UITABLEVIEW-DATASCOUR
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}


#pragma mark - HEADER VIEW DELEGATE

- (void)onPressMyCollectionButton
{
    NSLog(@"pressMyCollection");
    if (self.state == KHLPICListStateRecommend) {
        NSLog(@"to log in view controller");
        return;
    }
    
    self.state = KHLPICListStateCollection;
    [self.headerView.myCollectionButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.headerView.mySubscriptionButton setTitleColor:[KHLColor shiqing] forState:UIControlStateNormal];
    [self refreshButtonHolder];
    self.uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
    self.token = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
    [[KHLDataManager instance] collectionListHUDHolder:self.view uid:self.uid token:self.token];
}

- (void)onPressMySubscriptionButton
{
    NSLog(@"pressMySubscription");
    if (self.state == KHLPICListStateRecommend) {
        NSLog(@"to log in view controller");
        return;
    }
    
    self.state = KHLPICListStateSubscription;
    [self.headerView.myCollectionButton setTitleColor:[KHLColor shiqing] forState:UIControlStateNormal];
    [self.headerView.mySubscriptionButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self refreshButtonHolder];
    self.uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
    self.token = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
    [[KHLDataManager instance] subscriptionListHUDHolder:self.view uid:self.uid token:self.token];
}



#pragma mark - HEADER VIEW CUSTOM METHODES

- (void)configureHeaderView
{
    // Enable press gesture for thumb image view..
    UITapGestureRecognizer *pressPhotoImageViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressPhotoImageView)];
    [self.headerView.photoImageView setUserInteractionEnabled:TRUE];
    [self.headerView.photoImageView addGestureRecognizer:pressPhotoImageViewGesture];
    
    // Configure photo image view..
    UIImage *photoImage = [UIImage imageNamed:@"gerenzhongxin_touxiang.png"];
    self.headerView.photoImageView.layer.cornerRadius = self.headerView.photoImageView.frame.size.height/2;
    self.headerView.photoImageView.layer.masksToBounds = TRUE;
    self.headerView.photoImageView.layer.borderWidth = 2;
    self.headerView.photoImageView.layer.borderColor = [[KHLColor tubai] CGColor];
    self.headerView.photoImageView.layer.contents = (id)[photoImage CGImage];
    
    // Configure nickname label..
    self.headerView.nicknameLabel.text = @"";
    
    // Configure buttons and indicator..
    CGFloat indicator_x = 0;
    if (self.state == KHLPICListStateSubscription) {
        [self.headerView.myCollectionButton setTitleColor:[KHLColor shiqing] forState:UIControlStateNormal];
        [self.headerView.mySubscriptionButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        indicator_x = self.view.frame.size.width / 2;
    } else {
        [self.headerView.myCollectionButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.headerView.mySubscriptionButton setTitleColor:[KHLColor shiqing] forState:UIControlStateNormal];
    }
    self.headerView.buttonIndicatorView = [[UIView alloc] init];
    [self.headerView.buttonIndicatorView setBackgroundColor:[UIColor orangeColor]];
    [self.headerView.buttonIndicatorView setFrame:CGRectMake(indicator_x, self.headerView.buttonHolder.frame.size.height - COMMON_ITEM_DIVIDER_HEIGHT, self.view.frame.size.width / 2, COMMON_ITEM_DIVIDER_HEIGHT)];
    UIView *buttonDivider = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.buttonHolder.frame.size.height - COMMON_ITEM_DIVIDER_HEIGHT, self.view.frame.size.width, COMMON_ITEM_DIVIDER_HEIGHT)];
    [buttonDivider setBackgroundColor:[KHLColor shiqing]];
    [self.headerView.buttonHolder addSubview:buttonDivider];
    [self.headerView.buttonHolder addSubview:self.headerView.buttonIndicatorView];
    
//    self.tableView.separatorInset = UIEdgeInsetsMake(16, 0, 0, 0);
//    self.tableView.separatorColor = [UIColor whiteColor];
}

- (void)refreshPhotoImageView
{
    UIImage *photoImage;
    
    // Logged In Template
    if ([self isLogIn]) {
        // use thumb url to fill thumb image
        photoImage = [UIImage imageNamed:@"tzelann"];
        NSString *nickname = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUsername"];
        if (!nickname) nickname = @"用户名获取失败";
        self.headerView.nicknameLabel.text = nickname;
    }

    // Recommended Template
    else {
        photoImage = [UIImage imageNamed:@"gerenzhongxin_touxiang.png"];
        self.headerView.nicknameLabel.text = @"未登录";
    }
    
    self.headerView.photoImageView.layer.contents = (id)[photoImage CGImage];
}

- (void)pressPhotoImageView
{
    if ([self isLogIn]) {
        KHLPICProfileViewController *profileViewController = [[KHLPICProfileViewController alloc] init];
        [self.navigationController pushViewController:profileViewController animated:TRUE];
        
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        loginViewController.delegate = self;
        [self.navigationController pushViewController:loginViewController animated:TRUE];
    }
}

// Animate my collections and subscriptions button..
- (void)refreshButtonHolder
{
    if (self.state == KHLPICListStateCollection) {
        [UIView animateWithDuration:0.5f animations:^(void) {
            [self.headerView.buttonIndicatorView setFrame:CGRectMake(0, self.headerView.buttonHolder.frame.size.height - COMMON_ITEM_DIVIDER_HEIGHT, self.view.frame.size.width / 2, COMMON_ITEM_DIVIDER_HEIGHT)];
        } completion:^(BOOL finished) {
            
        }];
    }
    
    else if (self.state == KHLPICListStateSubscription) {
        [UIView animateWithDuration:0.5f animations:^(void) {
            [self.headerView.buttonIndicatorView setFrame:CGRectMake(self.view.frame.size.width / 2, self.headerView.buttonHolder.frame.size.height - COMMON_ITEM_DIVIDER_HEIGHT, self.view.frame.size.width / 2, COMMON_ITEM_DIVIDER_HEIGHT)];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)refreshTableView
{
    if (self.isLogIn) {
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    } else {
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    [self.tableView reloadData];
}



#pragma mark - NOTIFICATION METHODES

- (void)recommendListNotified: (NSNotification *)notification
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
        
        [self.recommends removeAllObjects];
        self.currentPage = [NSString stringWithFormat:@"%@", [result objectForKey:@"page"]];
        self.allPages = [NSString stringWithFormat:@"%@", [result objectForKey:@"size"]];
        NSLog(@"data arr=%@",[result objectForKey:@"data"]);
        for (NSDictionary *data in [result objectForKey:@"data"]) {
            RecommendListInterface *interface = [[RecommendListInterface alloc] init];
            interface.page = [NSString stringWithFormat:@"%@", [result objectForKey:@"page"]];
            interface.size = [NSString stringWithFormat:@"%@", [result objectForKey:@"size"]];
            interface.identity = [NSString stringWithFormat:@"%@", [data objectForKey:@"info_id"]];
            interface.category = [NSString stringWithFormat:@"%@", [data objectForKey:@"cate_id"]];
            interface.title = [NSString stringWithFormat:@"%@", [data objectForKey:@"title"]];
            interface.imageUrl = [NSString stringWithFormat:@"%@", [data objectForKey:@"image"]];
            interface.content = [NSString stringWithFormat:@"%@", [data objectForKey:@"content"]];
            interface.count = [NSString stringWithFormat:@"%@", [data objectForKey:@"count"]];
            interface.publisher = [NSString stringWithFormat:@"%@", [data objectForKey:@"nickname"]];
            interface.time = [NSString stringWithFormat:@"%@", [data objectForKey:@"time"]];
            interface.type = [NSString stringWithFormat:@"%@", [data objectForKey:@"type"]];
            [self.recommends addObject:interface];
            // NSLog(@"add %@", interface.title);
        }
        
        // Refresh list layout after data received..
        [self refreshTableView];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

- (void)subscriptionListNotified: (NSNotification *)notification
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
        
        [self.subscriptions removeAllObjects];
        self.currentPage = [NSString stringWithFormat:@"%@", [result objectForKey:@"page"]];
        self.allPages = [NSString stringWithFormat:@"%@", [result objectForKey:@"size"]];
        NSLog(@"data arr=%@",[result objectForKey:@"data"]);
        if ([[NSString stringWithFormat:@"%@", [result objectForKey:@"data"]] isEqualToString:@""])
            ; else
        for (NSDictionary *data in [result objectForKey:@"data"]) {
            SubscriptionListInterface *interface = [[SubscriptionListInterface alloc] init];
            interface.page = [NSString stringWithFormat:@"%@", [result objectForKey:@"page"]];
            interface.size = [NSString stringWithFormat:@"%@", [result objectForKey:@"size"]];
            interface.identity = [NSString stringWithFormat:@"%@", [data objectForKey:@"info_id"]];
            interface.category = [NSString stringWithFormat:@"%@", [data objectForKey:@"cate_id"]];
            interface.title = [NSString stringWithFormat:@"%@", [data objectForKey:@"title"]];
            interface.imageUrl = [NSString stringWithFormat:@"%@", [data objectForKey:@"image"]];
            interface.content = [NSString stringWithFormat:@"%@", [data objectForKey:@"content"]];
            interface.count = [NSString stringWithFormat:@"%@", [data objectForKey:@"count"]];
            interface.publisher = [NSString stringWithFormat:@"%@", [data objectForKey:@"nickname"]];
            interface.time = [NSString stringWithFormat:@"%@", [data objectForKey:@"time"]];
            interface.type = [NSString stringWithFormat:@"%@", [data objectForKey:@"type"]];
            [self.subscriptions addObject:interface];
        }
        
        // TEST
        if (self.subscriptions.count == 0)
            for (int i = 0; i < 3; i++) {
                SubscriptionListInterface *interface = [[SubscriptionListInterface alloc] init];
                interface.page = @"1";
                interface.size = @"1";
                interface.identity = @"1";
                interface.category = @"1";
                interface.title = @"北越雪谱";
                interface.imageUrl = @"http://img3.douban.com/lpic/s1745705.jpg";
                interface.content = @"喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝";
                interface.count = @"1776";
                interface.publisher = @"牧之";
                interface.time = @"1500-01-01";
                interface.type = @"article";
                [self.subscriptions addObject:interface];
            }
        
        // Refresh list layout after data received..
        [self refreshTableView];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

- (void)collectionListNotified: (NSNotification *)notification
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
        
        [self.collections removeAllObjects];
        self.currentPage = [NSString stringWithFormat:@"%@", [result objectForKey:@"page"]];
        self.allPages = [NSString stringWithFormat:@"%@", [result objectForKey:@"size"]];
        NSLog(@"data arr=%@",[result objectForKey:@"data"]);
        if ([[NSString stringWithFormat:@"%@", [result objectForKey:@"data"]] isEqualToString:@""])
            ; else
                for (NSDictionary *data in [result objectForKey:@"data"]) {
                    CollectionListInterface *interface = [[CollectionListInterface alloc] init];
                    interface.page = [NSString stringWithFormat:@"%@", [result objectForKey:@"page"]];
                    interface.size = [NSString stringWithFormat:@"%@", [result objectForKey:@"size"]];
                    interface.identity = [NSString stringWithFormat:@"%@", [data objectForKey:@"info_id"]];
                    interface.category = [NSString stringWithFormat:@"%@", [data objectForKey:@"cate_id"]];
                    interface.title = [NSString stringWithFormat:@"%@", [data objectForKey:@"title"]];
                    interface.imageUrl = [NSString stringWithFormat:@"%@", [data objectForKey:@"image"]];
                    interface.content = [NSString stringWithFormat:@"%@", [data objectForKey:@"content"]];
                    interface.count = [NSString stringWithFormat:@"%@", [data objectForKey:@"count"]];
                    interface.publisher = [NSString stringWithFormat:@"%@", [data objectForKey:@"nickname"]];
                    interface.time = [NSString stringWithFormat:@"%@", [data objectForKey:@"time"]];
                    interface.type = [NSString stringWithFormat:@"%@", [data objectForKey:@"type"]];
                    [self.subscriptions addObject:interface];
                }
        
        // TEST
        if (self.subscriptions.count == 0)
            for (int i = 0; i < 7; i++) {
                CollectionListInterface *interface = [[CollectionListInterface alloc] init];
                interface.page = @"1";
                interface.size = @"1";
                interface.identity = @"1";
                interface.category = @"1";
                interface.title = @"舜水先生文集";
                interface.imageUrl = @"http://gd1.alicdn.com/imgextra/i1/1914798654/T2GF4EX5NXXXXXXXXX-1914798654.jpg";
                interface.content = @"喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝喝";
                interface.count = @"5210";
                interface.publisher = @"舜水";
                interface.time = @"1692-05-21";
                interface.type = @"article";
                [self.collections addObject:interface];
            }
        
        // Refresh list layout after data received..
        [self refreshTableView];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}









@end
