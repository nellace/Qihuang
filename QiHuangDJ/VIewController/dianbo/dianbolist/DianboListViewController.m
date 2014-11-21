//
//  DianboListViewController.m
//  QiHuangDJ
//
//  Created by 雅泰  on 14-10-11.
//  Copyright (c) 2014年 雅泰 . All rights reserved.
//

#import "DianboListViewController.h"
#import "DianboListCollectionViewCell.h"
#import "DianboViewController.h"
#import "KHLCategorySliderTableViewCell.h"
#import "LoginViewController.h"
#import "MJRefresh.h"

#define MJRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

#pragma mark - DEFINATION AND ENUMERATION

#define SLIDER_WIDTH (250.0f)
#define STATUS_BAR_HEIGHT (20.0f)
#define NAVIGATION_BAR_HEIGHT (44.0f)

typedef NS_ENUM(NSInteger, KHLVODFilter) {
    KHLVODFilterLatest = 1,
    KHLVODFilterHotest = 2,
    KHLVODFilterShortest = 3
};



#pragma mark - INTERFACE AND IMPLEMENTATION

@interface DianboListViewController () <LoginDelegate> {
    UITableView *rightView;
    NSArray *copyArray;
    int pCount;
}

@property (weak, nonatomic) IBOutlet UIView *holder;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *vods;
@property (nonatomic, strong) NSString *currentPage;
@property (nonatomic, strong) NSString *allPages;
@property (nonatomic, getter=needsRequest, setter=setNeedsRequest:) BOOL dataRequestTag;
@property (nonatomic, getter=bSliderShowing, setter=setSliderShowing:) BOOL sliderShowHideTag;
@property (nonatomic) KHLVODFilter filter;

@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic) NSInteger categoryListIndex;
@property (nonatomic,assign)BOOL headerRefresh;

@property (nonatomic) CGFloat fixedWidth;

@end

@implementation DianboListViewController {
    
    IBOutletCollection(UIButton) NSArray *btnCollection;
    __weak IBOutlet UISearchBar *mySearch;
    UIImageView * imgBG;  //用于键盘弹出时 触摸隐藏键盘的imageView
    UIButton * fenleiBtn;
    
}

#pragma mark - ATTRIBUTES GETTER AND SETTER

- (NSMutableArray *)vods
{
    if (!_vods) _vods = [[NSMutableArray alloc] init];
    return _vods;
}

- (NSMutableArray *)categories
{
    if (!_categories) _categories = [[NSMutableArray alloc] init];
    return _categories;
}

- (void)setFilter:(KHLVODFilter)filter
{
    _filter = filter;
    if (![self needsRequest]) {
        [[KHLDataManager instance] VODListHUDHolder:self.view type:[NSString stringWithFormat:@"%d", self.filter] category:self.category page:@"" search:@""];
    }
}




#pragma mark - VIEW CONTROLLER LIFE CYCLE

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setNeedsRequest:TRUE];
        [self setFilter:KHLVODFilterLatest];
        [self setSliderShowing:FALSE];
        [self setCategoryListIndex:-1];
        [self setHeaderRefresh:YES];
        
        imgBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height)];
        imgBG.backgroundColor = [UIColor blackColor];
        imgBG.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHid)];
        [imgBG addGestureRecognizer:tap];
        imgBG.alpha = 0.6f;
        imgBG.hidden = YES;
        [self.view addSubview:imgBG];

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self setCascTitle:@"视频"];
    [self setFanhui];
    [self setFixedWidth:self.view.frame.size.width];
    [self rightViewUI];
    [self rightBtnItemUI];
    [self addFooter];
    [self addHeader];
    
    pCount = 1;
    
//    [mySearch setImage:[UIImage imageNamed:@"nav_icon_sousuo.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    

}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.collectionItem registerNib:[UINib nibWithNibName:@"DianboListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"QHidentifierDianboCollectionCell"];
    [self registerNotification];
    // Request data..
    if ([self needsRequest]) {
        [[KHLDataManager instance] VODListHUDHolder:self.view type:[NSString stringWithFormat:@"%d", self.filter] category:self.category page:@"" search:@""];
        
        NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
        NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
        [[KHLDataManager instance] categoryListHUDHolder:self.view uid:uid token:token];
        [self setNeedsRequest:FALSE];
    }
    //键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHiden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)registerNotification {
    // Register notification..
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryListNotified:) name:@"KHLNotiCategoryListAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoOnDemandListNotified:) name:@"KHLNotiVODListAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categorySubscribeNotified:) name:@"KHLNotiSubscribeCategory" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryUnsubscribeNotified:) name:@"KHLNotiUnsubscribeCategory" object:nil];

}

- (void)viewDidAppear:(BOOL)animated
{
//    // Request categories list..
//    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
//    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
//    [[KHLDataManager instance] categoryListHUDHolder:[[UIView alloc] init] uid:uid token:token];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    // Remove notifications..
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiCategoryListAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiVODListAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiSubscribeCategory" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiUnsubscribeCategory" object:nil];
}

#pragma mark
#pragma mark REFRESH
//sg
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;

    // 添加下拉刷新头部控件
    [self.collectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        if (pCount>1) {
            pCount = 1;
        }
        if (_headerRefresh == FALSE) {
            _headerRefresh = TRUE;
        }
        if (![self needsRequest]) {
            [[KHLDataManager instance] VODListHUDHolder:self.view type:[NSString stringWithFormat:@"%d", self.filter] category:self.category page:[NSString stringWithFormat:@"%D",pCount] search:@""];
            
            NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
            NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
            [[KHLDataManager instance] categoryListHUDHolder:self.view uid:uid token:token];
        }
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.collectionView reloadData];
            // 结束刷新
            [vc.collectionView headerEndRefreshing];
        });
    } dateKey:@"collection"];
    // dateKey用于存储刷新时间，也可以不传值，可以保证不同界面拥有不同的刷新时间
    NSLog(@"pCount---- %D",pCount);
    
#pragma mark 自动刷新(一进入程序就下拉刷新)
//    [self.collectionView headerBeginRefreshing];
}
- (void)addFooter
{
    
    __unsafe_unretained typeof(self) vc = self;
    [self.collectionView addFooterWithCallback:^{
        pCount++;
        if (_headerRefresh == TRUE) {
            _headerRefresh = FALSE;
        }
        if (![self needsRequest]) {
            [[KHLDataManager instance] VODListHUDHolder:self.view type:[NSString stringWithFormat:@"%d", self.filter] category:self.category page:[NSString stringWithFormat:@"%D",pCount] search:@""];
            
            NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
            NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
            [[KHLDataManager instance] categoryListHUDHolder:self.view uid:uid token:token];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.collectionView reloadData];
            // 结束刷新
            [vc.collectionView footerEndRefreshing];
        });
    }];
    NSLog(@"pCountfoot---- %D",pCount);
}



#pragma mark - CUSTOM LAYOUT METHODES

- (void)rightBtnItemUI {
    fenleiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fenleiBtn setBackgroundImage:[UIImage imageNamed:@"nav_btn_baocun@2x.png"] forState:UIControlStateNormal];
    [fenleiBtn setBackgroundImage:[UIImage imageNamed:@"nav_btn_baocun_press@2x.png"] forState:UIControlStateHighlighted];
    [fenleiBtn setTitle:@"分类" forState:UIControlStateNormal];
    [fenleiBtn setFrame:CGRectMake(0, 0, 42, 27)];
    [fenleiBtn setTitleColor:[KHLColor colorFromHexRGB:@"FE6024"] forState:UIControlStateNormal];
    [fenleiBtn.titleLabel setFont: [UIFont systemFontOfSize:14.0f]];
    UIBarButtonItem *fenleiRightBtn = [[UIBarButtonItem alloc] initWithCustomView:fenleiBtn];
    [fenleiBtn addTarget:self action:@selector(feileiBtnMethond:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = fenleiRightBtn;
}

- (void)rightViewUI {
    //    rightView = [[[NSBundle mainBundle] loadNibNamed:@"SliderRightList" owner:self options:nil] lastObject];
    rightView = [[UITableView alloc] init];
    //    rightView.frame = CGRectMake(self.fixedWidth - SLIDER_WIDTH, -64, SLIDER_WIDTH, self.view.frame.size.height + 64);
    rightView.frame = CGRectMake(self.fixedWidth - SLIDER_WIDTH, -64, SLIDER_WIDTH, self.view.frame.size.height);
    rightView.delegate = self;
    rightView.dataSource = self;
    [rightView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"celan_bg@2x.png"]]];
    //    [rightView setUserInteractionEnabled:TRUE];
    //    [rightView.tableView setUserInteractionEnabled:TRUE];
    //    rightView.tableView1.scrollEnabled = YES;
    //    [self.view insertSubview:rightView atIndex:0];
    [rightView setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:rightView];
    [self.view insertSubview:rightView belowSubview:self.holder];
}

- (void)feileiBtnMethond:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.3f animations:^{
        if ([self bSliderShowing]) {
            self.holder.frame = CGRectMake(0, 0, self.fixedWidth, self.view.frame.size.height);
            self.navigationController.navigationBar.frame = CGRectMake(self.holder.frame.origin.x, 20, self.fixedWidth, 44);
            [self setSliderShowing:FALSE];
        } else {
            self.holder.frame = CGRectMake(-SLIDER_WIDTH, 0, self.fixedWidth, self.view.frame.size.height);
            self.navigationController.navigationBar.frame = CGRectMake(self.holder.frame.origin.x, 20, self.view.frame.size.width, 44);
            [self setSliderShowing:TRUE];
        }
        
    } completion:^(BOOL finished) {
        
//        // Request data..
//        if (sender.selected) {
//            NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
//            NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
//            [[KHLDataManager instance] categoryListHUDHolder:[[UIView alloc] init] uid:uid token:token];
//        }
    }];
}


#pragma mark - KeyboardNotification

- (void)keyboardShow :(NSNotification *)noti {
    imgBG.hidden = NO;
    
    self.holder.frame = CGRectMake(0, 0, self.fixedWidth, self.view.frame.size.height);
    self.navigationController.navigationBar.frame = CGRectMake(self.holder.frame.origin.x, 20, self.view.frame.size.width, 44);
    [self setSliderShowing:TRUE];
}

- (void)keyboardHiden:(NSNotification *)noti {
    imgBG.hidden = YES;
    fenleiBtn.hidden = NO;
//    [imgBG removeFromSuperview];
}

- (void)keyboardHid {
    [mySearch resignFirstResponder];
}




#pragma mark - UISearchDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if (searchBar.text.length != 0) {
         [[KHLDataManager instance] VODListHUDHolder:self.view type:@"1" category:self.category page:[NSString stringWithFormat:@"%d", self.filter] search:searchBar.text];
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入的内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    [searchBar resignFirstResponder];
}



#pragma mark - ButtonActionMethod

- (IBAction)sectionBtn:(id)sender {
    
    UIButton * btn = (UIButton *)sender;
    NSInteger tagBtn = btn.tag;
    
    for (UIButton * btn1 in btnCollection) {
        if ([btn1 isEqual:btn]) {
            btn.selected = YES;
        }else {
            btn1.selected = NO;
        }
    }
    switch (tagBtn) {
            
        case 101:       //news
            [self setFilter:KHLVODFilterLatest];
            break;
            
        case 102:       //hot
            [self setFilter:KHLVODFilterHotest];
            break;
        case 103:       //shortTime
            [self setFilter:KHLVODFilterShortest];
            break;
            
        default:
            break;
    }
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.vods.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    static NSString *identifier = @"QHidentifierDianboCollectionCell";
    DianboListCollectionViewCell * vodCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (vodCell == nil) {
        vodCell = [[[NSBundle mainBundle] loadNibNamed:@"DianboListCollectionViewCell" owner:self options:nil]lastObject];
    }
    
    // Acquire instance..
    VODListInterface *vod = [self.vods objectAtIndex:indexPath.row];
    
    // Configure image view..
    if (vod.imageUrl && ![vod.imageUrl isEqualToString:@""]) {
        [vodCell.backdropImageView setImageWithURL:[NSURL URLWithString:vod.imageUrl]];
    } else {
        [vodCell.backdropImageView setImage:[UIImage imageNamed:@"zhibo_huanchongtu@2x.png"]];
    }
    
    // Configure label..
    vodCell.titleLabel.text = vod.title ? vod.title : @"（无标题）";
    
    // Asign VOD cell..
    cell = vodCell;
    return cell;
}


#pragma mark - UICollectionDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:TRUE];
    DianboViewController *dianboVC = [[DianboViewController alloc] initWithNibName:@"DianboViewController" bundle:nil];
    VODListInterface * vodlist = self.vods[indexPath.row];
    dianboVC.info_id = vodlist.identity;
    dianboVC.imageUrl = vodlist.imageUrl;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.holder.frame = CGRectMake(0, 0, self.fixedWidth, self.view.frame.size.height);
        self.navigationController.navigationBar.frame = CGRectMake(self.holder.frame.origin.x, 20, self.fixedWidth, 44);
        [self setSliderShowing:FALSE];
    } completion:^(BOOL finished) {
        [self.navigationController pushViewController:dianboVC animated:YES];
    }];
}



#pragma mark - TABLE VIEW DELEGATE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.fixedWidth, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT)];
    UIView *headerFooter = [[UIView alloc] initWithFrame:CGRectMake(0, sectionHeader.frame.size.height - 1, sectionHeader.frame.size.width, 1)];
    [headerFooter setBackgroundColor:[UIColor blackColor]];
    [sectionHeader addSubview:headerFooter];
    [sectionHeader setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"celan_bg@2x.png"]]];
    return sectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create view instance..
    UITableViewCell *cell = nil;
    KHLCategorySliderTableViewCell *cCell = [tableView dequeueReusableCellWithIdentifier:@"KHLCategorySliderTableViewCell"];
    if (!cCell) {
        cCell = [[[NSBundle mainBundle] loadNibNamed:@"KHLCategorySliderTableViewCell" owner:self options:nil] firstObject];
    }
    
    // Acquire data instance..
    CategoryListInterface *instance = [self.categories objectAtIndex:indexPath.row];
    cCell.categorySubscribeButton.tag = indexPath.row;
    
    // Configure image and title..
    if (instance) {
        cCell.categoryLabel.text = instance.title ? instance.title : @"（无标题）";
        [cCell.categorySubscribeButton addTarget:self action:@selector(clickSubscribeCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
        if ([@"1" isEqualToString:instance.subscribed]) {
            [cCell.categorySubscribeButton setTitleColor:[KHLColor juhuang] forState:UIControlStateNormal];
            [cCell.categorySubscribeButton setBackgroundImage:[UIImage imageNamed:@"celan_dinngyue_press.png"] forState:UIControlStateNormal];
            [cCell.categorySubscribeButton setEnabled:TRUE];
        } else if ([@"0" isEqualToString:instance.subscribed]){
            [cCell.categorySubscribeButton setTitleColor:[KHLColor tubai] forState:UIControlStateNormal];
            [cCell.categorySubscribeButton setBackgroundImage:[UIImage imageNamed:@"celan_dinngyue.png"] forState:UIControlStateNormal];
            [cCell.categorySubscribeButton setEnabled:TRUE];
        } else {
            [cCell.categorySubscribeButton setEnabled:FALSE];
        }
    }
    
    cCell.selectedBackgroundView = [[UIView alloc] initWithFrame:cCell.frame];
    cCell.selectedBackgroundView.backgroundColor = [KHLColor zong];
    
    // Asign category slider cell..
    cell = cCell;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    [self setSliderShowing:FALSE];
    [UIView beginAnimations:@"CloseSliderView" context:nil];
    [UIView setAnimationDuration:0.2f];
    self.holder.frame = CGRectMake(0, 0, self.fixedWidth, self.view.frame.size.height);
    self.navigationController.navigationBar.frame = CGRectMake(self.holder.frame.origin.x, 20, self.fixedWidth, 44);
    [UIView commitAnimations];
    
    if (-1 < indexPath.row < self.categories.count) {
        CategoryListInterface *instance = [self.categories objectAtIndex:indexPath.row];
        if (instance.category) {
            [[KHLDataManager instance] VODListHUDHolder:self.view type:[NSString stringWithFormat:@"%d", self.filter] category:instance.category page:@"" search:@""];
        }
    }
}

- (IBAction)clickSubscribeCategoryButton: (UIButton *)sender
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
    
    if (uid && token) {
        if (-1 < sender.tag < self.categories.count) {
            CategoryListInterface *instance = [self.categories objectAtIndex:sender.tag];
            [self setCategoryListIndex:sender.tag];
            if ([instance.subscribed isEqualToString:@"0"]) {
                [[KHLDataManager instance] subscribeHUDHolder:[[UIView alloc] init] uid:uid category:instance.category token:token];
            }
            else if ([instance.subscribed isEqualToString:@"1"]) {
                [[KHLDataManager instance] unsubscribeHUDHolder:[[UIView alloc] init] uid:uid category:instance.category token:token];
            }
        } else {
            // 点出天际了……
        }
    } else {
        // Not logged in..
        
        [UIView animateWithDuration:0.3f animations:^{
            self.holder.frame = CGRectMake(0, 0, self.fixedWidth, self.view.frame.size.height);
            self.navigationController.navigationBar.frame = CGRectMake(self.holder.frame.origin.x, 20, self.fixedWidth, 44);
            [self setSliderShowing:FALSE];
        } completion:^(BOOL finished) {
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            loginViewController.delegate = self;
            [self.navigationController pushViewController:loginViewController animated:TRUE];
        }];
    }
}



#pragma mark - LOGIN DELEGATE

- (void)onLoginSuccess
{
    // Request VOD list..
    [[KHLDataManager instance] VODListHUDHolder:self.view type:[NSString stringWithFormat:@"%i", self.filter] category:self.category page:@"" search:@""];
    
    // Request categories list..
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
    [[KHLDataManager instance] categoryListHUDHolder:self.view uid:uid token:token];
}

- (void)onLoginFailed
{
    
}






#pragma mark - NOTIFICATION METHODES

- (void)videoOnDemandListNotified: (NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    if (!dict) {
        NSLog(@"妈蛋，返回nil了。");
        return;
    }
    
    if ([[dict objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        
        NSDictionary *result = [dict objectForKey:@"result"];
        NSMutableArray *data = [result objectForKey:@"data"];
        if ([data count] == 0) {
//            NSLog(@"妈蛋，result里没东西。");
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"此分类下暂无更多视频。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//            return;
        }
        if (_headerRefresh == TRUE) {
            [self.vods removeAllObjects];
        }
        self.currentPage = [NSString stringWithFormat:@"%@", [result objectForKey:@"page"]];
        self.allPages = [NSString stringWithFormat:@"%@", [result objectForKey:@"size"]];
        for (NSDictionary *data in [result objectForKey:@"data"]) {
            VODListInterface *interface = [[VODListInterface alloc] init];
            interface.page = [NSString stringWithFormat:@"%@", [result objectForKey:@"page"]];
            interface.size = [NSString stringWithFormat:@"%@", [result objectForKey:@"size"]];
            interface.identity = [NSString stringWithFormat:@"%@", [data objectForKey:@"info_id"]];
            interface.title = [NSString stringWithFormat:@"%@", [data objectForKey:@"title"]];
            interface.imageUrl = [NSString stringWithFormat:@"%@", [data objectForKey:@"image"]];
            interface.type = [NSString stringWithFormat:@"%@", [data objectForKey:@"model"]];
            [self.vods addObject:interface];
            
        }
        //sg
        NSLog(@"%D",[self.vods count]);
        // Refresh list layout after data received..
        [self.collectionView reloadData];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

- (void)categoryListNotified: (NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    if (!dict) {
        NSLog(@"妈蛋，返回nil了。");
        return;
    }
    
    if ([[dict objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        NSArray *results = [dict objectForKey:@"result"];
        if (!results) {
            NSLog(@"妈蛋，results里没东西。");
            [[[UIAlertView alloc] initWithTitle:@"后台错误" message:@"result为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }
        
        [self.categories removeAllObjects];
        for (NSDictionary *result in results) {
            CategoryListInterface *interface = [[CategoryListInterface alloc] init];
            interface.category = [NSString stringWithFormat:@"%@", [result objectForKey:@"cate_id"]];
            interface.title = [NSString stringWithFormat:@"%@", [result objectForKey:@"title"]];
            interface.subscribed = [NSString stringWithFormat:@"%@", [result objectForKey:@"subscribe"]];
            [self.categories addObject:interface];
            
            NSLog(@"export: %@, %@, %@", interface.title, interface.category, interface.subscribed);
        }
        
        // Refresh categories list..
        [rightView reloadData];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

- (void)categorySubscribeNotified: (NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    if (!dict) {
        NSLog(@"妈蛋，返回nil了。");
        return;
    }
    
    if ([[dict objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        
        // Subscribe success..
        [[[UIAlertView alloc] initWithTitle:@"订阅成功" message:@"订阅成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        if (-1 < self.categoryListIndex < self.categories.count) {
            [self.categories[self.categoryListIndex] setSubscribed:@"1"];
            [rightView reloadData];
        }
        
    } else {
        
        // Subscribe fail..
        [[[UIAlertView alloc] initWithTitle:@"订阅失败" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

- (void)categoryUnsubscribeNotified: (NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    if (!dict) {
        NSLog(@"妈蛋，返回nil了。");
        return;
    }
    
    if ([[dict objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        
        // Subscribe success..
        [[[UIAlertView alloc] initWithTitle:@"退订成功" message:@"退订成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        if (-1 < self.categoryListIndex < self.categories.count) {
            [self.categories[self.categoryListIndex] setSubscribed:@"0"];
            [rightView reloadData];
        }
        
    } else {
        
        // Subscribe fail..
        [[[UIAlertView alloc] initWithTitle:@"退订失败" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}






@end
