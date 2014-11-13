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

@property (weak, nonatomic) IBOutlet UITableView *mainTabe;
@property (strong,nonatomic) NSMutableArray *listMutableArr;

@end

static  NSInteger goodCount; //记录等号


@implementation DianboViewController {
    NSString *otherUserName;
    NSString *infomId;
    NSString *cateId;
   
    
}

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
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullScreenMehod)];
    
    [self.videoScaleImageView addGestureRecognizer:tap];
    [self.videoScaleImageView setImageWithURL:[NSURL URLWithString:self.imageUrl]];
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

- (void)viewDidDisappear:(BOOL)animated {
    [self removeNotificaiton];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - dianboInfo
-(void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyboardHeight:) name:UIKeyboardWillChangeFrameNotification object:nil];
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
}

- (void)removeNotificaiton {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiVODDetailAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLUrlcommentlist" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiReplied" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLUrlGoodWithComment" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLUrlbadWithComment" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiCollectArticle" object:nil];
}

- (void)requestDianboInfo {

    [[KHLDataManager instance] VODDetailHUDHolder:self.view identity:self.info_id type:@"article"];
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
        self.timeLabel.text = [timeStr substringToIndex:10];
        self.titleForVideoLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        self.liulanCountLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"count"]];
        self.editorLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
//        infomId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info_id"]];
//        cateId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cate_id"]];
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
}

- (void)addCollectionNotifiMethod:(NSNotification *)aNotification {
    NSDictionary *aDic = aNotification.object;
    NSLog(@"%@",[aDic objectForKey:@"reason"]);
    if (aDic == nil) {
        NSLog(@"bad for collect falied");
        return;
    }else if ([[aDic objectForKey:@"resultCode"] isEqualToString:@"0"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
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
- (IBAction)collectonMethod:(id)sender {
    if ([KHLColor isLogin]) {
        NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
        NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
        [[KHLDataManager instance] collectArticleHUDHolder:self.view uid:uidStr identity:@"81" category:@"45" token:tokenStr];
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
        NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
        NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
        CommentListInterface * commentlist = self.listMutableArr[sender.tag];
        goodCount = sender.tag;
        [[KHLDataManager instance] goodHUDHolder:self.view uid:uidStr token:tokenStr comment_id:commentlist.poster];
    } else {
        [self pushLoginVCMethod];
    }
}

- (void)badDianboMethod:(UIButton *)sender {
    if ([KHLColor isLogin]) {
        NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
        NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
        CommentListInterface * commentlist = self.listMutableArr[sender.tag];
        goodCount = sender.tag;
        [[KHLDataManager instance] badHUDHolder:self.view uid:uidStr token:tokenStr comment_id:commentlist.poster];
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
@end
