//
//  ViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "ViewController.h"
#import "ClassifyViewController.h"
#import "LiveListViewController.h"
#import "SuperStartViewController.h"
#import "LoginViewController.h"
#import "PersonCenterViewController.h"
#import "KHLSearchResultViewController.h"
#import "KHLGamesphereViewController.h"
#import "InfomationViewController.h"
#import "DianboViewController.h"
#import "VideoLiveViewController.h"

@interface ViewController () <UIScrollViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *anchorView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutScroller;
@property (weak, nonatomic) IBOutlet UIPageControl *headerPageControl;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *backdropImageViewCollection;
@property (weak, nonatomic) IBOutlet UIImageView *GameCenterBGImage;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *moduleLabelCollection;


@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *backdropImages;
@property (nonatomic, strong) NSMutableArray *loopingImages;
@property (nonatomic, strong) NSString *version;
@property (nonatomic,retain) NSString *keyWord;

@end

@implementation ViewController {
    ClassifyViewController *classify ;
    BOOL isLogin;
    UIImageView * backImage;
    SearchBarCustom *search ;
    NSString *gameBGStr; //游戏圈背景图片
}


#pragma mark - DEFINITION AND ENUMERATION

#define CAROUSEL_SCROLLING_SPEED 0.65f
#define CAROUSEL_SCROLLING_DURATION 3.0f

typedef NS_ENUM(NSUInteger, KHLHomeBackdropTag) {
    KHLHomeBackdropTagLive = 0,
    KHLHomeBackdropTagEntertainers = 1,
    KHLHomeBackdropTagHearthStone = 2,
    KHLHomeBackdropTagLOL = 3,
    KHLHomeBackdropTagDotA = 4
};



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isLogin = NO;  //判断是否登录过
        
        // If not auto login configured, remove user defaults..
        BOOL autoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"KHLAutoLogin"];
        if (!autoLogin) {
            NSLog(@"Not auto login, clear user defaults..");
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIUID"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIToken"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIUsername"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIPhoneNumber"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIName"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIGender"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIBirthday"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIBlog"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIRegisterTime"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIEmail"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIQQ"];
        }
         [self navUI];
       
        
     

    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Draw background image..
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bg@2x.png"]]];
    
    // Register notification..
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homepageImagesNotified:) name:@"KHLNotiHomepageImagesAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchResultNotified:) name:@"KHLNotiSearchResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHiden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardShow :(NSNotification *)noti {
    backImage.hidden = NO;
}

- (void)keyboardHiden:(NSNotification *)noti {
    
    backImage.hidden = YES;
}

- (void)keyboardHid {
    [search resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Remove notification..
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiHomepageImagesAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiSearchResult" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImage.backgroundColor = [UIColor blackColor];
    backImage.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHid)];
    [backImage addGestureRecognizer:tap];
    backImage.alpha = 0.6f;
    backImage.hidden = YES;
    [self.view addSubview:backImage];
    
     classify = [ClassifyViewController new];
    //sg mainscrollview 滚动条隐藏
    self.mainScrollView.showsVerticalScrollIndicator = false;
    
    // Request homepage image data..
    [[KHLDataManager instance] homepageImagesHUDHolder:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - ATTRIBUTES GETTER AND SETTER

- (NSMutableArray *)loopingImages
{
    if (!_loopingImages)
        _loopingImages = [[NSMutableArray alloc] init];
    return _loopingImages;
}

- (NSMutableArray *)backdropImages
{
    if (!_backdropImages)
        _backdropImages = [[NSMutableArray alloc] init];
    return _backdropImages;
}



#pragma mark - CUSTOM LAYOUT METHODES

- (void)navUI {
    //左侧图片
    UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 59, 35)];
    [imgLogo setImage:[UIImage imageNamed:@"shouye_logo_custom.png"]];
    UIBarButtonItem *imgLeft = [[UIBarButtonItem alloc ] initWithCustomView:imgLogo];
    self.navigationItem.leftBarButtonItem = imgLeft;
    //中间导航
    search = [SearchBarCustom new];
    search.placeholder = @"搜索";

    [search customSearchBarUI:@"home"];
    search.delegate = self;
    self.navigationItem.titleView = search;
    //右侧按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 40);
    [btn setImage:[UIImage imageNamed:@"nav_btn_shezhi.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(settingBtnMethond) forControlEvents:UIControlEventTouchUpInside];;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] init];
    [leftBtn setCustomView:btn];
    self.navigationItem.rightBarButtonItem = leftBtn;
}

- (void)settingBtnMethond
{
    PersonCenterViewController * personCenterVC = [[PersonCenterViewController alloc] initWithNibName:@"PersonCenterViewController" bundle:nil];
    [self.navigationController pushViewController:personCenterVC animated:YES];
}

- (void)configureCarousel: (UIScrollView *)carousel
                indicator: (UIPageControl *)indicator
        withLoopingThings: (NSMutableArray *)loopings
{
    // Configure page controller..
    indicator.numberOfPages = [loopings count];
    indicator.currentPageIndicatorTintColor = [KHLColor juhuang];
    indicator.pageIndicatorTintColor = [KHLColor transWhite];
    
    // Calculate frame..
    CGFloat width = carousel.frame.size.width;
    CGFloat height = carousel.frame.size.height;
    CGFloat y = 0;
    
    // Avoid empty head..
    if (loopings.count == 0) {
        HomepageImagesInterface *avoider = [[HomepageImagesInterface alloc] init];
        avoider.loopingImageUrl = @"";
        [loopings addObject:avoider];
    }
    
    // Create images..
    for (int i = 0; i < loopings.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        CGFloat x = i * width;
        imageView.frame = CGRectMake(x, y, width, height);
        // using testing image..
        HomepageImagesInterface *looping = [loopings objectAtIndex:i];
        if (looping.loopingImageUrl && ![looping.loopingImageUrl isEqualToString:@""]) {
            [imageView setImageWithURL:[NSURL URLWithString:looping.loopingImageUrl]];
//            imageView.contentMode = UIViewContentModeScaleAspectFill;

//            imageView.frame = CGRectMake(x, y, width, height);
            NSLog(@"lunbo imageview%f",imageView.frame.size.height);
        } else {
            [imageView setImage:[UIImage imageNamed:@"huanchong_shouyeguanggao@2x.png"]];
        }
        
        UITapGestureRecognizer *tapLoopingRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressLoopingImageView)];
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(nextImage)];
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backToBrforeImage)];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        
        [imageView setUserInteractionEnabled:TRUE];
        [imageView addGestureRecognizer:tapLoopingRecognizer];
        [imageView addGestureRecognizer:swipeLeft];
        [imageView addGestureRecognizer:swipeRight];
        
        carousel.showsHorizontalScrollIndicator = NO;
        [carousel addSubview:imageView];
    }
    
    // Configure scrolling content..
    [carousel setContentSize:CGSizeMake([loopings count] * width, 0)];
    
    // Enable paging..
    [carousel setPagingEnabled:TRUE];
    
    // Configure listener for scroll view..
    [carousel setDelegate:self];
    
    // Start timer..
    [self openTimer:self.timer duration:CAROUSEL_SCROLLING_DURATION];
}

- (void)nextImage
{
    [self nextImageCarousel:self.headerScrollView indicator:self.headerPageControl withLoopingThings:self.loopingImages inSpeed:CAROUSEL_SCROLLING_SPEED];
}
//sg返回上一个image
- (void)backToBrforeImage
{
    [self backImageCarousel:self.headerScrollView indicator:self.headerPageControl withLoopingThings:self.loopingImages inSpeed:CAROUSEL_SCROLLING_SPEED];
}

- (void)backImageCarousel: (UIScrollView *)carousel
                indicator: (UIPageControl *)indicator
        withLoopingThings: (NSMutableArray *)loopings
                  inSpeed: (NSTimeInterval )speed
{
    NSInteger page = indicator.currentPage;
    if (page == 0) {
        page = loopings.count - 1;
    }else
    {
        page--;
    }
    //滚回去的坐标
    CGFloat x = page * carousel.frame.size.width;
    [UIView beginAnimations:@"BackContentOffset" context:nil];
    [UIView setAnimationDuration:speed];
    carousel.contentOffset = CGPointMake(x, 0);
    [UIView commitAnimations];
}

- (void)nextImageCarousel: (UIScrollView *)carousel
                indicator: (UIPageControl *)indicator
        withLoopingThings: (NSMutableArray *)loopings
                  inSpeed: (NSTimeInterval)speed
{
    NSInteger page = indicator.currentPage;
    if (page == loopings.count - 1) {
        page = 0;
    } else {
        page++;
    }
    
    // Scroll carousel..
    CGFloat x = page * carousel.frame.size.width;
    [UIView beginAnimations:@"MoveContentOffset" context:nil];
    [UIView setAnimationDuration:speed];
    carousel.contentOffset = CGPointMake(x, 0);
    [UIView commitAnimations];
}

- (void)drawBackdropImages
{
    // Draw backdrop images to view..
    for (int i = 0; i < self.backdropImageViewCollection.count; i++) {
        HomepageImagesInterface *backdrop = self.backdropImages[i];
        if (backdrop && backdrop.backdropImageUrl && ![backdrop.backdropImageUrl isEqualToString:@""]) {
            [self.backdropImageViewCollection[i] setImageWithURL:[NSURL URLWithString:[self.backdropImages[i] backdropImageUrl]]];
        } else {
            [self.backdropImageViewCollection[i] setImage:[UIImage imageNamed:@"huanchong_shouye.png"]];
        }
        
        [self.moduleLabelCollection[i] setText:[NSString stringWithFormat:@"%@", backdrop.backdropImageName]];
    }
}

- (void)saveCategoryIdentities
{
    // Avoid bastard objects that cant respond to function 'backdropImageCategory'..
    for (int i = 0; i < self.backdropImages.count; i++) {
        if (![[self.backdropImages objectAtIndex:i] respondsToSelector:@selector(backdropImageCategory)]) {
            NSLog(@"Function category unresponded at backdrop images list index: %d", i);
            return;
        } else {
            NSLog(@"Category: %@ Name: %@", [self.backdropImages[i] backdropImageCategory], [self.backdropImages[i] backdropImageName]);
        }
    }
    
    // Add category identities to user defaults..
    [[NSUserDefaults standardUserDefaults] setObject:[self.backdropImages[0] backdropImageCategory] forKey:@"KHLCategoryLive"];
    [[NSUserDefaults standardUserDefaults] setObject:[self.backdropImages[1] backdropImageCategory] forKey:@"KHLCategoryEntertainers"];
    [[NSUserDefaults standardUserDefaults] setObject:[self.backdropImages[2] backdropImageCategory] forKey:@"KHLCategoryHearthStone"];
    [[NSUserDefaults standardUserDefaults] setObject:[self.backdropImages[3] backdropImageCategory] forKey:@"KHLCategoryLOL"];
    [[NSUserDefaults standardUserDefaults] setObject:[self.backdropImages[4] backdropImageCategory] forKey:@"KHLCategoryDota"];
}



#pragma mark - USER INTERACTION RESPONSE

- (IBAction)zhibo:(id)sender {
    LiveListViewController * videoLiveVC = [[LiveListViewController alloc] initWithNibName:@"LiveListViewController" bundle:nil];
    [videoLiveVC setGameId:@""];
    [self.navigationController pushViewController:videoLiveVC animated:YES];
}

- (IBAction)qihuangyiren:(id)sender
{
    SuperStartViewController * superVC = [[SuperStartViewController alloc] initWithNibName:@"SuperStartViewController" bundle:nil];
    [self.navigationController pushViewController:superVC animated:YES];
}

- (IBAction)LOL:(id)sender
{
    classify.title = [self.moduleLabelCollection[3] text];;
    classify.category = [[NSUserDefaults standardUserDefaults] objectForKey:@"KHLCategoryLOL"];
    classify.gameId = @"1";
    [self.navigationController pushViewController:classify animated:YES];
}

- (IBAction)LSchuanshuo:(id)sender
{
    classify.title = [self.moduleLabelCollection[2] text];;
    classify.category = [[NSUserDefaults standardUserDefaults] objectForKey:@"KHLCategoryHearthStone"];
    classify.gameId = @"2";
    [self.navigationController pushViewController:classify animated:YES];
}

- (IBAction)dota2:(id)sender
{
    classify.title = [self.moduleLabelCollection[4] text];;
    classify.category = [[NSUserDefaults standardUserDefaults] objectForKey:@"KHLCategoryDota"];
    classify.gameId = @"3";
    [self.navigationController pushViewController:classify animated:YES];
}

- (IBAction)pressGamesphereButton:(UIButton *)sender
{
    
    KHLGamesphereViewController *gamesphereViewController = [[KHLGamesphereViewController alloc] init];
    [self.navigationController pushViewController:gamesphereViewController animated:TRUE];
}

- (void)pressLoopingImageView
{
    NSInteger index = self.headerPageControl.currentPage;
    if (-1 < index < self.loopingImages.count) {
        HomepageImagesInterface *looping = [self.loopingImages objectAtIndex:index];
        if ([@"article" isEqualToString:looping.loopingType]) {
            InfomationViewController *detailViewController = [[InfomationViewController alloc] init];
            SearchInterface *prestrain = [[SearchInterface alloc] init];
            [prestrain setIdentity:looping.loopingIdentity];
            [prestrain setCategory:looping.loopingType];
            [prestrain setImageUrl:looping.loopingImageUrl];
            [detailViewController setPrestrain:prestrain];
            [self.navigationController pushViewController:detailViewController animated:TRUE];
        } else if ([@"live" isEqualToString:looping.loopingType]) {
            // goto live
             VideoLiveViewController*vodViewController = [[VideoLiveViewController alloc] init];

            vodViewController.liveInfoID = looping.loopingIdentity;
            [self.navigationController pushViewController:vodViewController animated:TRUE];
        } else {
            // 你点到奇怪的东西了……
        }
    }
}




#pragma mark - NOTIFICATION METHODES

- (void)homepageImagesNotified: (NSNotification *)notification
{
    // Base layer..
    NSDictionary *dict = notification.object;
    if (!dict) {
        NSLog(@"妈蛋，返回nil了。");
        return;
    }
    
    if ([[dict objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        
        // Result layer..
        NSDictionary *result = [dict objectForKey:@"result"];
        if (!result) {
            NSLog(@"妈蛋，result里没东西。");
            return;
        }
        
        // Acquire version..
        self.version = [NSString stringWithFormat:@"%@", [result objectForKey:@"version"]];

        // Looping images layer..
        NSDictionary *loopings = [result objectForKey:@"lunboimg"];
        if (loopings && loopings.count > 0) {
            [self.loopingImages removeAllObjects];
            for (NSDictionary *looping in loopings) {
                
                HomepageImagesInterface *interface = [[HomepageImagesInterface alloc] init];
                interface.version = [NSString stringWithFormat:@"%@", [result objectForKey:@"version"]];
                interface.loopingImageUrl = [NSString stringWithFormat:@"%@", [looping objectForKey:@"image"]];
                interface.loopingIdentity = [NSString stringWithFormat:@"%@", [looping objectForKey:@"info_id"]];
                interface.loopingType = [NSString stringWithFormat:@"%@", [looping objectForKey:@"model"]];
                [self.loopingImages addObject:interface];
            }
            
            
       
            
            // Draw looping images to view..
            [self configureCarousel:self.headerScrollView indicator:self.headerPageControl withLoopingThings:self.loopingImages];
            
        } else {
            NSLog(@"没有接受到任何轮播图！");
        }
        
        // Backdrop images layer..
        NSArray *backdrops = [result objectForKey:@"homebgimg"];
        if (backdrops && backdrops.count >= self.backdropImageViewCollection.count) {
            [self.backdropImages removeAllObjects];
//            for (NSDictionary *backdrop in backdrops) {
//                
//            }
            for (NSInteger i =0; i<backdrops.count; i++) {
                if (i == 0) {
                    NSDictionary *backdrop1 = backdrops[i];
                    gameBGStr  = [backdrop1 objectForKey:@"image"];
                    NSLog(@"gameCenter BG %@",gameBGStr);

                    self.GameCenterBGImage.image =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:gameBGStr]]];
                }else {
                    NSDictionary *backdrop = backdrops[i];
                    HomepageImagesInterface *interface = [[HomepageImagesInterface alloc] init];
                    interface.version = [NSString stringWithFormat:@"%@", [result objectForKey:@"version"]];
                    interface.backdropImageName = [NSString stringWithFormat:@"%@", [backdrop objectForKey:@"name"]];
                    interface.backdropImageUrl = [NSString stringWithFormat:@"%@", [backdrop objectForKey:@"image"]];
                    interface.backdropImageCategory = [NSString stringWithFormat:@"%@", [backdrop objectForKey:@"cate_id"]];
                    [self.backdropImages addObject:interface];
                }
            }
            // Draw backdrop images to view..
            [self drawBackdropImages];

            // Save category identities..
            [self saveCategoryIdentities];
            
        } else if (backdrops.count < self.backdropImageViewCollection.count) {
            NSLog(@"背景图数量不足！");
        } else {
            NSLog(@"没有接受到背景图！");
        }
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台出错"
                                    message:[dict objectForKey:@"reason"]
                                   delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil, nil] show];    }
}

- (void)searchResultNotified: (NSNotification *)notification
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
        searchResultViewController.keyWord = _keyWord;
        [self.navigationController pushViewController:searchResultViewController animated:TRUE];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}



#pragma mark - SCROLL VIEW DELEGATE

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat carouselWidth = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + carouselWidth / 2) / carouselWidth;
    self.headerPageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self closeTimer:self.timer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self openTimer:self.timer duration:CAROUSEL_SCROLLING_DURATION];
}



#pragma mark - SEARCH BAR DELEGATE

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    _keyWord = searchBar.text;
    NSLog(@"using keyword: %@", _keyWord);
    //sg
    [[KHLDataManager instance] searchHUDHolder:self.view keyword:_keyWord page:@""];
}



#pragma mark - HEADER CAROUSEL TIMER METHODES

- (void)openTimer: (NSTimer *)timer duration: (NSTimeInterval)duration
{
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(nextImage) userInfo:nil repeats:TRUE];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)closeTimer: (NSTimer *)timer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}









@end
