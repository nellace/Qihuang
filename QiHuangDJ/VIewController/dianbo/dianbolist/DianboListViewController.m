//
//  DianboListViewController.m
//  QiHuangDJ
//
//  Created by 雅泰  on 14-10-11.
//  Copyright (c) 2014年 雅泰 . All rights reserved.
//

#import "DianboListViewController.h"
//#import "SliderRightList.h"
#import "DianboListCollectionViewCell.h"
#import "DianboViewController.h"
#import "KHLCategorySliderTableViewCell.h"



#pragma mark - DEFINATION AND ENUMERATION

#define SLIDER_WIDTH (250.0f)

typedef NS_ENUM(NSInteger, KHLVODFilter) {
    KHLVODFilterLatest = 1,
    KHLVODFilterHotest = 2,
    KHLVODFilterShortest = 3
};



#pragma mark - INTERFACE AND IMPLEMENTATION

@interface DianboListViewController () {
    UITableView *rightView;
}

@property (weak, nonatomic) IBOutlet UIView *holder;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *vods;
@property (nonatomic, strong) NSString *currentPage;
@property (nonatomic, strong) NSString *allPages;
@property (nonatomic, getter=needsRequest, setter=setNeedsRequest:) BOOL dataRequestTag;
@property (nonatomic) KHLVODFilter filter;

@property (nonatomic, strong) NSMutableArray *categories;

@end

@implementation DianboListViewController {
    
    IBOutletCollection(UIButton) NSArray *btnCollection;
    __weak IBOutlet UISearchBar *mySearch;
    UIImageView * imgBG;  //用于键盘弹出时 触摸隐藏键盘的imageView
    
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
        [[KHLDataManager instance] VODListHUDHolder:self.view type:[NSString stringWithFormat:@"%lu", self.filter] category:self.category page:@"" search:@""];
    }
}




#pragma mark - VIEW CONTROLLER LIFE CYCLE

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setNeedsRequest:TRUE];
        [self setFilter:KHLVODFilterLatest];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self setCascTitle:@"视频"];
    [self setFanhui];
    [self rightViewUI];
    [self rightBtnItemUI];
    
    [mySearch setImage:[UIImage imageNamed:@"nav_icon_sousuo.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    //键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHiden:) name:UIKeyboardWillHideNotification object:nil];
    
    // Request data..
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
    if (uid && token) {
        [[KHLDataManager instance] categoryListHUDHolder:self.view uid:uid token:token];
    } else {
        
    }
    
    if ([self needsRequest]) {
        [[KHLDataManager instance] VODListHUDHolder:self.view type:[NSString stringWithFormat:@"%lu", self.filter] category:self.category page:@"" search:@""];
        [self setNeedsRequest:FALSE];
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [self.collectionItem registerNib:[UINib nibWithNibName:@"DianboListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"QHidentifierDianboCollectionCell"];
    
    // Register notification..
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryListNotified:) name:@"KHLNotiCategoryListAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoOnDemandListNotified:) name:@"KHLNotiVODListAcquired" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    // Remove notifications..
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiCategoryListAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiVODListAcquired" object:nil];
}




#pragma mark - CUSTOM LAYOUT METHODES

- (void)rightBtnItemUI {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_btn_baocun@2x.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_btn_baocun_press@2x.png"] forState:UIControlStateHighlighted];
    [btn setTitle:@"分类" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 42, 27)];
    [btn setTitleColor:[KHLColor colorFromHexRGB:@"FE6024"] forState:UIControlStateNormal];
    [btn.titleLabel setFont: [UIFont systemFontOfSize:14.0f]];
    UIBarButtonItem *fenleiRightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(feileiBtnMethond:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = fenleiRightBtn;
}

- (void)rightViewUI {
//    rightView = [[[NSBundle mainBundle] loadNibNamed:@"SliderRightList" owner:self options:nil] lastObject];
    rightView = [[UITableView alloc] init];
//    rightView.frame = CGRectMake(320 - SLIDER_WIDTH, -64, SLIDER_WIDTH, self.view.frame.size.height + 64);
    rightView.frame = CGRectMake(320 - SLIDER_WIDTH, -64, SLIDER_WIDTH, self.view.frame.size.height + 64);
    rightView.delegate = self;
    rightView.dataSource = self;
    [rightView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"celan_bg@2x.png"]]];
//    [rightView setUserInteractionEnabled:TRUE];
//    [rightView.tableView setUserInteractionEnabled:TRUE];
//    rightView.tableView1.scrollEnabled = YES;
//    [self.view insertSubview:rightView atIndex:0];
    [self.view addSubview:rightView];
    [self.view insertSubview:rightView belowSubview:self.holder];
}

- (void)feileiBtnMethond:(UIButton *)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        if (sender.selected) {
            sender.selected = NO;
            self.holder.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
            self.navigationController.navigationBar.frame = CGRectMake(self.holder.frame.origin.x, 20, 320, 44);
//            rightView.frame = CGRectMake(320 - SLIDER_WIDTH, -64, SLIDER_WIDTH, self.view.frame.size.height + 64);
        }else {
            self.holder.frame = CGRectMake(-SLIDER_WIDTH, 0, 320, self.view.frame.size.height);
            self.navigationController.navigationBar.frame = CGRectMake(self.holder.frame.origin.x, 20, self.view.frame.size.width, 44);
//            rightView.frame = CGRectMake(320, -64, SLIDER_WIDTH, self.view.frame.size.height + 64);
            sender.selected = YES;
        }

    } completion:^(BOOL finished) {
        [self.view setNeedsDisplay];
    }];
}




#pragma mark - KeyboardNotification

- (void)keyboardShow :(NSNotification *)noti {
    imgBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imgBG.backgroundColor = [UIColor grayColor];
    imgBG.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHid)];
    [imgBG addGestureRecognizer:tap];
    imgBG.alpha = 0.4;
    [self.view addSubview:imgBG];
}

- (void)keyboardHiden:(NSNotification *)noti {

    [imgBG removeFromSuperview];
}

- (void)keyboardHid {
    [mySearch resignFirstResponder];
}




#pragma mark - UISearchDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
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
    [self.navigationController pushViewController:dianboVC animated:YES];
}




//#pragma mark - UITableViewDataSource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 3;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    tableView.tableFooterView = [UIView new];
//    static NSString *identifier = @"QHSliderRightList";
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    cell.textLabel.text = @"视频分类";
//    return cell;
//}




//#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}



#pragma mark - TABLE VIEW DELEGATE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
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
            [cCell.categorySubscribeButton setImage:[UIImage imageNamed:@"celan_dinngyue_press.png"] forState:UIControlStateNormal];
            [cCell.categorySubscribeButton setEnabled:TRUE];
        } else if ([@"0" isEqualToString:instance.subscribed]){
            [cCell.categorySubscribeButton setImage:[UIImage imageNamed:@"celan_dinngyue.png"] forState:UIControlStateNormal];
            [cCell.categorySubscribeButton setEnabled:TRUE];
        } else {
            [cCell.categorySubscribeButton setEnabled:FALSE];
        }
    }

    // Asign category slider cell..
    cell = cCell;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

- (IBAction)clickSubscribeCategoryButton: (UIButton *)sender
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
    
    if (uid && token) {
        if (-1 < sender.tag < self.categories.count) {
            CategoryListInterface *instance = [self.categories objectAtIndex:sender.tag];
            NSLog(@"click: %@, %@, %@", instance.title, instance.category, instance.subscribed);
        } else {
            NSLog(@"you were shocked!");
        }
    } else {
        
    }
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
        if (!result) {
            NSLog(@"妈蛋，result里没东西。");
            [[[UIAlertView alloc] initWithTitle:@"后台错误" message:@"result为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }
        
        [self.vods removeAllObjects];
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
    
//    // TEST
//    for (int i = 0; i < 15; i++) {
//        CategoryListInterface *instance = [[CategoryListInterface alloc] init];
//        instance.category = @"12";
//        instance.title = @"瓦量两";
//        instance.subscribed = @"1";
//        [self.categories addObject:instance];
//    }
//    
//    // ref
//    [rightView reloadData];
}






@end
