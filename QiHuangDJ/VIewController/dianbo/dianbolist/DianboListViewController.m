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

@interface DianboListViewController () {
    SliderRightList *rightView;
}


@end

@implementation DianboListViewController {
    
    IBOutletCollection(UIButton) NSArray *btnCollection;
    __weak IBOutlet UISearchBar *mySearch;
    UIImageView * imgBG;  //用于键盘弹出时 触摸隐藏键盘的imageView
    
}
#pragma mark
#pragma mark Life cyle
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
}

- (void)viewWillAppear:(BOOL)animated {

    [self.collectionItem registerNib:[UINib nibWithNibName:@"DianboListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"QHidentifierDianboCollectionCell"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
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
#pragma mark
#pragma mark KeyboardNotification

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
#pragma mark
#pragma mark UISearchDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark
#pragma mark ButtonActionMethod
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
            
            break;
            
        case 102:       //hot
            
            break;
        case 103:       //shortTime
            
            break;
            
        default:
            break;
    }
}

#pragma mark
#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    static NSString *identifier = @"QHidentifierDianboCollectionCell";
    DianboListCollectionViewCell * collectioncell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    if (collectioncell == nil) {
        collectioncell = [[[NSBundle mainBundle] loadNibNamed:@"DianboListCollectionViewCell" owner:self options:nil]lastObject];
    }
    return collectioncell;
}


#pragma mark
#pragma mark UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DianboViewController * dianboVC = [[DianboViewController alloc] initWithNibName:@"DianboViewController" bundle:nil];
    [self.navigationController pushViewController:dianboVC animated:YES];
}

#pragma mark
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.tableFooterView = [UIView new];
    static NSString *identifier =@"QHSliderRightList";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"视频分类";
    return cell;
}

#pragma mark
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
