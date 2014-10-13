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

@implementation LiveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self navBuildUI];

}

- (void)navBuildUI {
    [self setFanhui];
    [self setCascTitle:@"直播"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
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
        [self dingyueBtnUI:cell];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"zhibo_huanchongtu"];
    cell.textLabel.text = @"一起风暴吧";
    
    cell.selectedBackgroundView.backgroundColor = [UIColor blackColor];
    return cell;
}

- (void)dingyueBtnUI :(UITableViewCell *)cell{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(cell.contentView.frame.size.width - 80, (cell.frame.size.height - 20)/2, 40, 20)];
    [btn setTitle:@"订阅" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn setTitleColor:[KHLColor colorFromHexRGB:@"FE6024"]forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"zhibo_dingyue"] forState:UIControlStateNormal];
    [cell.contentView addSubview:btn];
}

#pragma marks
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoLiveViewController *video = [[VideoLiveViewController alloc] initWithNibName:@"VideoLiveViewController" bundle:nil];
    [self.navigationController pushViewController:video animated:YES];
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
