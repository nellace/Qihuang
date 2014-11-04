//
//  LiveListViewController.m
//  QiHuangDJ
//
//  Created by 雅泰  on 14-10-10.
//  Copyright (c) 2014年 雅泰 . All rights reserved.
//

#import "LiveListViewController.h"
#import "VideoLiveViewController.h"
@interface LiveListViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation LiveListViewController {
    NSMutableArray * yugaoListArray;
    NSMutableArray *zhiboListArray;
    LiveListInterface *liveListinterface;
    __weak IBOutlet UITableView *mainTableView;
}

# pragma mark
# pragma mark LIFE CYCLE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    yugaoListArray = [NSMutableArray new];
    zhiboListArray = [NSMutableArray new];
    
    [self navBuildUI];
    [self networkingRequestWithLiveList];

}

- (void)viewWillAppear:(BOOL)animated {
    [self registerNotification];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self removeNotification];
}

- (void)navBuildUI {
    [self setFanhui];
    [self setCascTitle:@"直播"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark 
# pragma mark NETWORKING REQUEST

- (void)networkingRequestWithLiveList {
    [[KHLDataManager  instance] liveListHUDHolder:self.view type:@""];
}
//KHLNotiLiveListAcquired
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveListNotification:) name:@"KHLNotiLiveListAcquired" object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiLiveListAcquired" object:nil];
}

- (void)liveListNotification:(NSNotification *)aNotification {
    NSDictionary * aDic = aNotification.object;
    if (aDic == nil) {
        NSLog(@"live list request failed");
        return;
    }
//获得直播列表
    NSArray * zhiboarray = [[aDic objectForKey:@"result"] objectForKey:@"zhibolist"];
    for (NSDictionary * dic in zhiboarray) {
        liveListinterface = [LiveListInterface new];
        liveListinterface.category = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cate_id"]];
        liveListinterface.identity = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info_id"]];
        liveListinterface.imageUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"image"]];
        liveListinterface.time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]];
        liveListinterface.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        [zhiboListArray addObject:liveListinterface];
    }
    
// 获取预告列表
    NSArray * yugaoarray =[[aDic objectForKey:@"result"] objectForKey:@"yugaolist"];
    for (NSDictionary * dic in yugaoarray) {
        liveListinterface = [LiveListInterface new];
        liveListinterface.category = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cate_id"]];
        liveListinterface.identity = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info_id"]];
        liveListinterface.imageUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"image"]];
        liveListinterface.time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]];
        liveListinterface.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        [yugaoListArray addObject:liveListinterface];
    }
    [mainTableView reloadData];
}
#pragma mark
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = nil;
    if (section == 0) {
        view = [self sectionViewUI:@"正在直播"];
        
    }
    if (section == 1) {
        view =[self sectionViewUI:@"直播预告"];
    }
    return view;
}

- (UIView *)sectionViewUI:(NSString *)title {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    [view setBackgroundColor:[KHLColor colorFromHexRGB:@"F6F6F6"]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    label.textColor = [KHLColor colorFromHexRGB:@"FE6024"];
    label.text = title;
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableFooterView.backgroundColor = [KHLColor colorFromHexRGB:@"F6F6F6"];
    static NSString *identifierStr = @"identifierStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
//        [self dingyueBtnUI:cell];
    }
    
    if (indexPath.section == 0) {
        liveListinterface = zhiboListArray[indexPath.row];
        if ([liveListinterface.imageUrl isEqualToString:@""]) {
             cell.imageView.image = [UIImage imageNamed:@"zhibo_huanchongtu"];
        }else {
            [cell.imageView setImageWithURL:[NSURL URLWithString:liveListinterface.imageUrl]];
        }
        cell.textLabel.text = liveListinterface.name;
    }else {
        liveListinterface = yugaoListArray[indexPath.row];
        [cell.imageView setImageWithURL:[NSURL URLWithString:liveListinterface.imageUrl]];
        
        cell.textLabel.text = liveListinterface.name;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.imageView.image = [UIImage imageNamed:@"zhibo_huanchongtu"];
//    cell.textLabel.text = @"一起风暴吧";
    
    cell.selectedBackgroundView.backgroundColor = [UIColor blackColor];
    return cell;
}

- (void)dingyueBtnUI :(UITableViewCell *)cell{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(cell.contentView.frame.size.width - 100, (cell.frame.size.height - 35)/2, 70, 35)];
    [btn setTitle:@"订阅" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn setTitleColor:[KHLColor colorFromHexRGB:@"FE6024"]forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"zhibo_dingyue"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dingyueBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn];
}

- (void)dingyueBtnMethod:(UIButton *)sender {
    
    if (sender.selected) {
        
        sender.selected = NO;
        [sender setTitle:@"取消订阅" forState:UIControlStateNormal];
        return;
        
    }else{

        sender.selected = YES;

        [sender setTitle:@"订阅" forState:UIControlStateNormal];
        return;
    }
    
}

#pragma marks
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        liveListinterface = zhiboListArray [indexPath.row];
        
    }else {
        liveListinterface = yugaoListArray [indexPath.row];
    }
    
   VideoLiveViewController *video = [[VideoLiveViewController alloc] initWithNibName:@"VideoLiveViewController" bundle:nil];
    video.liveInfoID = liveListinterface.identity;
    [self.navigationController pushViewController:video animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger lines = 0;
    if (section == 0) {
        lines = zhiboListArray.count;
    }else {
        lines = yugaoListArray.count;
    }
    return lines;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
