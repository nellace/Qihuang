//
//  DianboViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "DianboViewController.h"
#import "DianboCell.h"
#import "LoginViewController.h"
#import "JubaoViewController.h"
#import <ShareSDK/ShareSDK.h>
//#import "LTPlayerSDK.h"
@interface DianboViewController ()
@property (weak, nonatomic) IBOutlet UITextField *shuruTextFiled;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;
@property (weak, nonatomic) IBOutlet UIImageView *videoScaleImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *liulanCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *editorLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleForVideoLabel;
@property (weak, nonatomic) IBOutlet UILabel *zanCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *mainTabe;
@property (strong,nonatomic) NSMutableArray *listMutableArr;

@property (nonatomic, weak) NSTimer *countDownTimer;
@property (nonatomic) CGFloat groundOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carriageOffsetConstraint;


@end

static  NSInteger goodCount; //记录等号


@implementation DianboViewController {
    NSString *otherUserName;
    NSString *infomId;
    NSString *cateId;
//    BOOL isCollected;
    int zanCount;
    NSString *isCollected;
    BOOL hadDingPingLun;
    BOOL hadCaiPingLun;
    BOOL hadZan;
    int dingCountDown;
    int caiCountDown;
}



#pragma mark - ATTRIBUTES GETTER AND SETTER

- (CGFloat)groundOffset
{
    return self.inputView ? self.inputView.frame.size.height : 0;
}



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setCascTitle:@"点播"];
        [self setFanhui];
        self.listMutableArr = [NSMutableArray new];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapScreenBackdrop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreenBackdrop)];
    [self.view addGestureRecognizer:tapScreenBackdrop];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullScreenMehod)];
    
    [self rightButtonMethod];
    [self.videoScaleImageView addGestureRecognizer:tap];

}

- (void)fullScreenMehod {
//    [LTPlayerSDK showWithUserUnique:@"cbec2a7d04"
//                        videoUnique:@"128342e318"
//                          videoName:nil
//                          payerName:nil
//                          checkCode:nil
//                                 ap:YES
//                   inViewController:self
//                     playerDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerNotification];
    [self requestDianboInfo];

}
- (void)viewDidAppear:(BOOL)animated
{
    if ([isCollected integerValue] == 1) {
        [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"icon_shoucang_press"] forState:UIControlStateNormal];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [self removeNotificaiton];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - dianboInfo
-(void)registerNotification {
    NSLog(@"registered..");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //zan
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zanNotifiMethod:) name:@"KHLUrlZanWithModel" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyboardHeight:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dianboInfoMehod:) name:@"KHLNotiVODDetailAcquired" object:nil];
    //commentlist
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dianboCommentlistMehod:) name:@"KHLUrlcommentlist" object:nil];
    //评论
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyDianboMethod:) name:@"KHLNotiReplied" object:nil];
    //good
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodDianboNotifiMethod:) name:@"KHLUrlGoodWithComment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(badDianboNotifiMethod:) name:@"KHLUrlbadWithComment" object:nil];

    // collection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCollectionNotifiMethod:) name:@"KHLNotiCollectArticle" object:nil];
    //uncollection
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uncollectionNotificationMethod:) name:@"KHLNotiUncollectArticle" object:nil];
}

- (void)removeNotificaiton {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiVODDetailAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLUrlcommentlist" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiPraised" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiReplied" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLUrlGoodWithComment" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLUrlbadWithComment" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiCollectArticle" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"KHLNotiUncollectArticle" object:nil];
}

- (void)requestDianboInfo {
    NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
    NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];

    [[KHLDataManager instance] VODDetailHUDHolder:self.view identity:self.info_id type:@"article" uid:uidStr token:tokenStr];
    //获取评论列表
    [[KHLDataManager instance] commentlistHUDHolder:self.view model:@"article" zhiboid:self.info_id];
}

- (void)dianboInfoMehod:(NSNotification *)aNotification {
    NSDictionary *aDic = aNotification.object;
    if (aDic == nil) {
        NSLog(@"dianbo request failed");
        return;
    }
    NSDictionary *dic = [aDic objectForKey:@"result"];
    if ([[aDic objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        NSString *timeStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]];
        zanCount = [[dic objectForKey:@"zan"]integerValue];
        self.zanCountLabel.text = [NSString stringWithFormat:@"%d",zanCount];
        self.timeLabel.text = [timeStr substringToIndex:10];
        self.titleForVideoLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        self.liulanCountLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"count"]];
        self.editorLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
        self.imageUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"image"]];
        [self.videoScaleImageView setImageWithURL:[NSURL URLWithString:self.imageUrl]];
        isCollected = [NSString stringWithFormat:@"%@",[dic objectForKey:@"collect"]];
        infomId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info_id"]];
        cateId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cate_id"]];
    }
    
    if ([[aDic objectForKey:@"resultCode"] isEqualToString:@"1"]) {
        NSString *messageStr = [aDic objectForKey:@"reason"];

     UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] ;
        [alert show];
    }
}

- (void)dianboCommentlistMehod:(NSNotification *)aNotification {
    NSDictionary *aDic = aNotification.object;
    if (aDic == nil) {
        NSLog(@"commentList failed"); return;
    }
    if ([[aDic objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        NSDictionary * dic = [aDic objectForKey:@"result"];
        NSArray * arr = [dic objectForKey:@"data"];
        for (NSDictionary *dataDic in arr) {
            CommentListInterface *commentlist = [CommentListInterface new];
            commentlist.username = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"uname"]];
            commentlist.poster   = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"comment_id"]];
            commentlist.portraitImageUrl = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"uimage"]];
            commentlist.content  = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"content"]];
            commentlist.countBad = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"bad"]];
            commentlist.countGood= [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"good"]];
            commentlist.time     = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"time"]];
            commentlist.usernameWithReply = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"reply"]];
            
            [self.listMutableArr addObject:commentlist];
        }
        [self.mainTabe reloadData];
    }
}

- (void)replyDianboMethod:(NSNotification *)aNotification {
    NSDictionary * aDic = aNotification.object;
    if (aDic == nil) {
        NSLog(@"reply failed");
        return;
    }
    
    if ([[aDic objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUsername"];
        NSString *replyTitle;
        NSLog(@"othexrUserName  %@",otherUserName);
        if (otherUserName.length == 0) {
            replyTitle = username;
        }else {
            replyTitle = [NSString stringWithFormat:@"%@回复%@",username,otherUserName];
        }
        
        CommentListInterface * commentlist = [CommentListInterface new];
        commentlist.content = self.shuruTextFiled.text;
        commentlist.username = replyTitle;
        commentlist.time = @"1234";
        commentlist.countBad = @"0";
        commentlist.countGood = @"0";
        
        [self.listMutableArr insertObject:commentlist atIndex:0];
        [self.mainTabe reloadData];
        [self.shuruTextFiled resignFirstResponder];
        self.shuruTextFiled.text = @"";
        otherUserName = @"";
    }
}
- (void)goodDianboNotifiMethod:(NSNotification *)aNotification {
    NSDictionary *aDic = aNotification.object;
    if (aDic == nil) {
        NSLog(@"good for dianbo falied");
    }
    //ui数量加1
    CommentListInterface *commentlist = self.listMutableArr[goodCount];
    NSInteger good = [commentlist.countGood integerValue];
    good ++;
    commentlist.countGood = [NSString stringWithFormat:@"%d",good];
    [self.listMutableArr replaceObjectAtIndex:goodCount withObject:commentlist];
    [self.mainTabe reloadData];
        goodCount = 0;
    hadDingPingLun = YES;
    dingCountDown = 10;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    
}

- (void)timeFireMethod
{
    
    if (dingCountDown) {
        dingCountDown--;
        if (dingCountDown == 0) {
            hadDingPingLun = NO;
            [self.countDownTimer invalidate];
        }
    }

    if (caiCountDown) {
        caiCountDown--;
        if (caiCountDown == 0) {
            hadCaiPingLun = NO;
            [self.countDownTimer invalidate];
        }
    }
}

- (void)badDianboNotifiMethod:(NSNotification *)aNotification {
    NSDictionary *aDic = aNotification.object;
    if (aDic == nil) {
        NSLog(@"bad for dianbo falied");
    }
    //ui数量加1
    CommentListInterface *commentlist = self.listMutableArr[goodCount];
    NSInteger good = [commentlist.countBad integerValue];
    good ++;
    commentlist.countBad = [NSString stringWithFormat:@"%d",good];
    [self.listMutableArr replaceObjectAtIndex:goodCount withObject:commentlist];
    [self.mainTabe reloadData];
    goodCount = 0;
    hadCaiPingLun = YES;
    caiCountDown = 10;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}

- (void)addCollectionNotifiMethod:(NSNotification *)aNotification {
    NSDictionary *aDic = aNotification.object;
    NSLog(@"%@",[aDic objectForKey:@"reason"]);
    if (aDic == nil) {
        NSLog(@"bad for collect falied");
        return;
    }else if ([[aDic objectForKey:@"resultCode"] isEqualToString:@"0"])
    {
        isCollected = @"1";
        [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"icon_shoucang_press"] forState:UIControlStateNormal];

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)uncollectionNotificationMethod:(NSNotification*)aNotification
{
    NSDictionary *dic = aNotification.object;
    NSLog(@"%@",[dic objectForKey:@"reason"]);
    if (dic == nil) {
        NSLog(@"bad for uncollect falied");
        return;
    }else if ([[dic objectForKey:@"resultCode"] isEqualToString:@"0"])
    {
        isCollected = @"0";
        [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"icon_shoucang"] forState:UIControlStateNormal];

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"取消收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}
# pragma mark UITableViewDataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *str = [NSString stringWithFormat:@"评论区 (%d)",self.listMutableArr.count];
    return str;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listMutableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableFooterView = [UIView new];
    tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    static NSString *identifier = @"KHLDianboCell";
    
    DianboCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DianboCell" owner:self options:nil]lastObject];
        [cell.huifuMehod addTarget:self action:@selector(pinglunMethondWithBottomBarAndDianbo:) forControlEvents:UIControlEventTouchUpInside];
        [cell.jubaoMedhod addTarget:self action:@selector(jubaoDianboMehod:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goodMethod addTarget:self action:@selector(goodDianboMethod:) forControlEvents:UIControlEventTouchUpInside];
        [cell.badMethod addTarget:self action:@selector(badDianboMethod:) forControlEvents:UIControlEventTouchUpInside];
    }
    tableView.tableFooterView = [UIView new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //行号给tag
    cell.huifuMehod.tag = indexPath.row;
    cell.jubaoMedhod.tag = indexPath.row;
    cell.goodMethod.tag = indexPath.row;
    cell.badMethod.tag = indexPath.row;

    
    CommentListInterface * commentlist = self.listMutableArr[indexPath.row];
    cell.contentLabel.text = commentlist.content;

    cell.goodCountLabel.text = commentlist.countGood;
    cell.badCountLabel.text = commentlist.countBad;
    
    //    [cell.imgeWithIcon setImageWithURL:[NSURL URLWithString:commentlist.portraitImageUrl]];

    cell.timeLabel.text =  [KHLColor returnTheTimelabel:commentlist.time];
    
    NSString * usernametext;
    
    if (commentlist.usernameWithReply.length == 0) {
        usernametext = commentlist.username;
    }else {
        usernametext = [NSString stringWithFormat:@"%@回复%@",commentlist.username,commentlist.usernameWithReply];
    }
    cell.titleLabel.text = usernametext;
    return cell;
}

# pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0f;
}

# pragma mark Button Method
- (IBAction)discussMehod:(id)sender {
    [self.shuruTextFiled becomeFirstResponder];
}

- (IBAction)zanMethod:(id)sender {
    NSLog(@"123");
    if ([KHLColor isLogin]) {
        if (hadZan == NO) {
            NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
            NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
            [[KHLDataManager instance]zanHUDHolder:self.view uid:uidStr token:tokenStr info_id:self.info_id model:@"article"];
        }else
        {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"" message:@"已经点过赞了哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alter show];
        }
    }else {
        [self pushLoginVCMethod];
    }

}

- (void)zanNotifiMethod:(NSNotification *)aNotification
{
    NSDictionary *aDic = aNotification.object;
    if ([[aDic objectForKey:@"resultCode"]integerValue] == 0) {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"" message:@"点赞成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alter show];
        NSLog(@"------1");
        zanCount++;
        hadZan = YES;
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"zhibo_btn_zan_press"] forState:UIControlStateNormal];
        self.zanCountLabel.text = [NSString stringWithFormat:@"%d",zanCount];
    }
}


- (IBAction)fabiaopinglunMethod:(id)sender {
    if ([self.shuruTextFiled.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }else {
        NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
        NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
        
        //取出点击行的相关信息
        
        NSString * comment_id;
        NSString * modelStr;
        if (self.shuruTextFiled.tag == 101) {
            comment_id = self.info_id;
            modelStr = @"article";
        }else {
            CommentListInterface * commentlist = self.listMutableArr[self.shuruTextFiled.tag];
            otherUserName = commentlist.username;
            comment_id = commentlist.poster;
            modelStr = @"comment";
        }
        [[KHLDataManager instance] replyHUDHolder:self.view uid:uidStr target:comment_id content:self.shuruTextFiled.text token:tokenStr targetType:modelStr];
    }
}
//sg
- (IBAction)collectonMethod:(id)sender {
    if ([KHLColor isLogin]) {
        if ([isCollected isEqualToString:@"0"]) {
            NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
            NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
            [[KHLDataManager instance] collectArticleHUDHolder:self.view uid:uidStr identity:infomId    category:cateId token:tokenStr];
        }else
        {
            NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
            NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
            [[KHLDataManager instance]uncollectArticleHUDHolder:self.view uid:uidStr identity:infomId category:cateId token:tokenStr];
        }
    }else {
        [self pushLoginVCMethod];
    }
    
}
- (void)pinglunMethondWithBottomBarAndDianbo:(UIButton *)sender {
    if ([KHLColor isLogin]) {
        UIButton * btn = (UIButton * )sender;
        self.shuruTextFiled.tag =btn.tag;
        [self.shuruTextFiled becomeFirstResponder];
    } else {
        [self pushLoginVCMethod];
    }
}
- (IBAction)retRootVC:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)jubaoDianboMehod:(UIButton *)sender {
    if ([KHLColor isLogin]) {
        JubaoViewController *jubaoVC = [[JubaoViewController alloc] initWithNibName:@"JubaoViewController" bundle:nil];
        CommentListInterface * commentlist = self.listMutableArr[sender.tag];
        jubaoVC.pinglunId =commentlist.poster;
        [self.navigationController pushViewController:jubaoVC animated:YES];
    } else {
        [self pushLoginVCMethod];
    }
}

- (void)goodDianboMethod:(UIButton *)sender {
    if ([KHLColor isLogin]) {
        if (hadDingPingLun == NO) {
            NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
            NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
            CommentListInterface * commentlist = self.listMutableArr[sender.tag];
            goodCount = sender.tag;
            [[KHLDataManager instance] goodHUDHolder:self.view uid:uidStr token:tokenStr comment_id:commentlist.poster model:@"comment"];
        }else
        {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"" message:@"不能频繁点赞" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alter show];
        }
    } else {
        [self pushLoginVCMethod];
    }
}

- (void)badDianboMethod:(UIButton *)sender {
    if ([KHLColor isLogin]) {
        if (hadCaiPingLun == NO) {
            NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
            NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
            CommentListInterface * commentlist = self.listMutableArr[sender.tag];
            goodCount = sender.tag;
            [[KHLDataManager instance] badHUDHolder:self.view uid:uidStr token:tokenStr comment_id:commentlist.poster];
        }else{
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"" message:@"不能频繁操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alter show];

        }
    } else {
        [self pushLoginVCMethod];
    }

}
# pragma mark textFiledCreateUI
- (void)textFiledCreateUI {
    
}
# pragma mark TextFiledDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void)changeKeyboardHeight:(NSNotification *)aNotification {
    //获取到键盘frame 变化之前的frame
    NSValue  *keyboardBeginBounds = [[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect = [keyboardBeginBounds CGRectValue];
    
    //获取到键盘frame变化之后的frame
    NSValue *keyboardEndBounds = [[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect = [keyboardEndBounds CGRectValue];
    
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    //拿frame变化之后的origin.y-变化之前的origin.y，其差值(带正负号)就是我们self.view的y方向上的增量
    
    [CATransaction begin];
    [UIView animateWithDuration:0.3f animations:^{
        self.inputView.frame = CGRectMake(self.inputView.frame.origin.x
                                          ,253-100, self.inputView.frame.size.width, self.inputView.frame.size.height);
        self.keyboardHeight.constant = -deltaY;

        [self.view updateConstraints];
    
    } completion:^(BOOL finished) {

    }];

    [CATransaction commit];
}

- (void)pushLoginVCMethod {

    LoginViewController * loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];

}
//share
-(void)rightButtonMethod {
    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"nav_btn_baocun.png"] forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"nav_btn_baocun_press.png"] forState:UIControlStateHighlighted];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setFrame:CGRectMake(0, 0, 42, 27)];
    [shareBtn setTitleColor:[KHLColor colorFromHexRGB:@"FE6024"] forState:UIControlStateNormal];
    [shareBtn.titleLabel setFont: [UIFont systemFontOfSize:14.0f]];
    UIBarButtonItem *fenleiRightBtn = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    [shareBtn addTarget:self action:@selector(shareInfo:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = fenleiRightBtn;
}

- (void)shareInfo:(UIButton*)sender
{
    NSLog(@"123");
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeQQSpace, nil];
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"logo_80" ofType:@"png"];
    id<ISSContent>publishContent = [ShareSDK content:@"这个应用不错" defaultContent:@"" image:[ShareSDK imageWithPath:imagePath] title:@"七煌" url:@"http://i.imgur.com/4SvHy9L.gifv" description:@"七煌好应用的一条测试信息" mediaType:SSPublishContentMediaTypeNews];
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:nil];
    
    [ShareSDK showShareActionSheet:container shareList:shareList content:publishContent statusBarTips:YES authOptions:authOptions shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil oneKeyShareList:[NSArray defaultOneKeyShareList] cameraButtonHidden:NO mentionButtonHidden:NO topicButtonHidden:NO qqButtonHidden:NO wxSessionButtonHidden:NO wxTimelineButtonHidden:NO showKeyboardOnAppear:NO shareViewDelegate:nil friendsViewDelegate:nil picViewerViewDelegate:nil] result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSPublishContentStateSuccess) {
             NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
        }else if (state ==SSPublishContentStateFail)
        {
             NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
        }
    }];
//    [ShareSDK showShareActionSheet:container shareList:shareList content:publishContent statusBarTips:YES authOptions:[ShareSDK defaultShareOptionsWithTitle:nil oneKeyShareList:[NSArray defaultOneKeyShareList] cameraButtonHidden:NO mentionButtonHidden:NO topicButtonHidden:NO qqButtonHidden:NO wxSessionButtonHidden:NO wxTimelineButtonHidden:NO showKeyboardOnAppear:NO shareViewDelegate:nil friendsViewDelegate:nil picViewerViewDelegate:nil] result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//        if (state == SSPublishContentStateSuccess) {
//             NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
//        }else if (state == SSPublishContentStateFail)
//        {
//            NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//        }
//    }];
}

#pragma mark - KEYBOARD AND INPUT RELATED METHODES

- (void)keyboardWillChangeFrame: (NSNotification *)notification
{
    CGRect enRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat offset = self.view.frame.size.height - enRect.origin.y + self.groundOffset + self.navigationController.navigationBar.frame.size.height + 20;
    
    if (self.groundOffset == offset) {
        offset = 0;
    }
    
    [CATransaction begin];
    [UIView animateWithDuration:0.3f animations:^{
        [self.inputView setFrame:CGRectMake(self.inputView.frame.origin.x , self.view.frame.size.height - offset, self.inputView.frame.size.width, self.inputView.frame.size.height)];
        [self.carriageOffsetConstraint setConstant:-offset];
        [self.inputView updateConstraints];
    }];
    [CATransaction commit];
}

- (void)tapScreenBackdrop
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    [self.shuruTextFiled resignFirstResponder];
}




@end
