//
//  JubaoViewController.m
//  QiHuangDJ
//
//  Created by 雅泰  on 14/11/10.
//  Copyright (c) 2014年 雅泰 . All rights reserved.
//

#import "JubaoViewController.h"

@interface JubaoViewController ()


@end

@implementation JubaoViewController
{
    NSArray *listArray ;
    NSInteger lines; //记录行号
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setFanhui];
    [self setCascTitle:@"举报"];
    listArray = [[NSArray alloc] initWithObjects:@"垃圾广告",@"淫秽信息",@"不实信息",@"人身攻击",@"泄漏隐私",@"敏感消息",@"虚拟中奖",@"其它", nil];
    [self rightWithSendBtnUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jubaoNotifiMethod:) name:@"KHLNotiReported" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiReported" object:nil];
}
- (void)jubaoNotifiMethod:(NSNotification *)aNotification {
    NSDictionary *aDic = aNotification.object;
    if (aDic == nil) {
        NSLog(@"jubao failed");
    }
    if ([[aDic objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        lines = 0;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)rightWithSendBtnUI {
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.frame = CGRectMake(0, 0, 40, 27);
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"nav_btn_baocun"] forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"nav_btn_baocun_press"] forState:UIControlStateHighlighted];
    [sendBtn addTarget:self action:@selector(sendJubaoMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
}
- (void)sendJubaoMethod:(UIButton *)sender {
    NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
    NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
    if (!(uidStr == nil || tokenStr == nil)) {
        NSString *typeStr = [NSString stringWithFormat:@"%d",lines];
        [[KHLDataManager instance] reportHUDHolder:self.view identity:self.pinglunId type:typeStr uid:uidStr token:tokenStr targetType:@"comment"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITABLEVIEW_DATASCOUR

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableFooterView = [UIView new];
    static NSString *identifier = @"jubaoVCIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = listArray[indexPath.row];

    return cell;
}

#pragma mark - UITABLEVIEW_DELEGATE
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView * imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhibo_jubao_duigou@2x"]];
    imageV.frame = CGRectMake(300, 10, 18, 15);
    [cell.contentView addSubview:imageV];
    lines = indexPath.row;
    lines ++;

}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *arr = cell.contentView.subviews;
    for (id abc in arr) {
        if ([abc isKindOfClass:[UIImageView class]]) {
            [abc removeFromSuperview];
        }
    }

}
@end
