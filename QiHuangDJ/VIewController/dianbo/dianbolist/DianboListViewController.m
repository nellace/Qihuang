//
//  DianboListViewController.m
//  QiHuangDJ
//
//  Created by 雅泰  on 14-10-11.
//  Copyright (c) 2014年 雅泰 . All rights reserved.
//

#import "DianboListViewController.h"
#import "SliderRightList.h"
#import "DianboListCollectionViewCell.h"
#import "DianboViewController.h"



#pragma mark - DEFINATION AND ENUMERATION

typedef NS_ENUM(NSInteger, KHLVODFilter) {
    KHLVODFilterLatest = 1,
    KHLVODFilterHotest = 2,
    KHLVODFilterShortest = 3
};



#pragma mark - INTERFACE AND IMPLEMENTATION

@interface DianboListViewController () {
    SliderRightList *rightView;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *vods;
@property (nonatomic, strong) NSString *currentPage;
@property (nonatomic, strong) NSString *allPages;
@property (nonatomic, getter=needsRequest, setter=setNeedsRequest:) BOOL dataRequestTag;
@property (nonatomic) KHLVODFilter filter;

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
    if ([self needsRequest]) {
        [[KHLDataManager instance] VODListHUDHolder:self.view type:[NSString stringWithFormat:@"%lu", self.filter] category:self.category page:@"" search:@""];
        [self setNeedsRequest:FALSE];
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [self.collectionItem registerNib:[UINib nibWithNibName:@"DianboListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"QHidentifierDianboCollectionCell"];
    
    // Register notification..
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoOnDemandListNotified:) name:@"KHLNotiVODListAcquired" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    // Remove notifications..
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
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
    rightView = [[[NSBundle mainBundle] loadNibNamed:@"SliderRightList" owner:self options:nil] lastObject];
    rightView.frame = CGRectMake(6000,-64, 120, self.view.frame.size.height);
    [self.view addSubview:rightView];
}

- (void)feileiBtnMethond:(UIButton *)sender {
    [UIView animateWithDuration:0.3f animations:^{
        if (sender.selected) {
            sender.selected = NO;
            self.view.frame = CGRectMake(0, 64, 320, self.view.frame.size.height);
            self.navigationController.navigationBar.frame = CGRectMake(self.view.frame.origin.x, 20, 320, 44);
            rightView.frame = CGRectMake(self.view.frame.size.width,-64, 283,self.view.frame.size.height+64);
            NSLog(@"sender.selected == no");
        }else {
            self.view.frame = CGRectMake(-(self.view.frame.size.width/6), 64, 320, self.view.frame.size.height);
            self.navigationController.navigationBar.frame = CGRectMake(self.view.frame.origin.x, 20, self.view.frame.size.width, 44);
            rightView.frame = CGRectMake(self.view.frame.size.width,-64, 283,self.view.frame.size.height+64);
            NSLog(@"view.x%f",self.view.frame.origin.x);
            NSLog(@"nav.x %f",self.navigationController.navigationBar.frame.origin.x);
            sender.selected = YES;
            NSLog(@"sender.selected == yes");
        }

    } completion:^(BOOL finished) {
        
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




#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.tableFooterView = [UIView new];
    static NSString *identifier = @"QHSliderRightList";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"视频分类";
    return cell;
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
        if (!result) {
            NSLog(@"妈蛋，result里没东西。");
            [[[UIAlertView alloc] initWithTitle:@"后台错误" message:@"result为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }
        
        [self.vods removeAllObjects];
        self.currentPage = [NSString stringWithFormat:@"%@", [result objectForKey:@"page"]];
        self.allPages = [NSString stringWithFormat:@"%@", [result objectForKey:@"size"]];
//        NSLog(@"data arr=%@",[result objectForKey:@"data"]);
        for (NSDictionary *data in [result objectForKey:@"data"]) {
            VODListInterface *interface = [[VODListInterface alloc] init];
            interface.page = [NSString stringWithFormat:@"%@", [result objectForKey:@"page"]];
            interface.size = [NSString stringWithFormat:@"%@", [result objectForKey:@"size"]];
            interface.identity = [NSString stringWithFormat:@"%@", [data objectForKey:@"info_id"]];
            interface.title = [NSString stringWithFormat:@"%@", [data objectForKey:@"title"]];
            interface.imageUrl = [NSString stringWithFormat:@"%@", [data objectForKey:@"image"]];
            interface.type = [NSString stringWithFormat:@"%@", [data objectForKey:@"model"]];
            [self.vods addObject:interface];
            
            NSLog(@"export: %@", interface.title);
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
        [self.collectionView reloadData];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}






@end
