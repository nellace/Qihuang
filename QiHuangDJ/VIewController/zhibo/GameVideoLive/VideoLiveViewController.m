//
//  VideoLiveViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "VideoLiveViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DianboCell.h"
#import "LoginViewController.h"
@interface VideoLiveViewController () <UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UMSocialUIDelegate> {
    __weak IBOutlet UITextField *inputTextFiled;
    __weak IBOutlet UILabel *liveTtitle;
    __weak IBOutlet NSLayoutConstraint *keyboardHeight;
    __weak IBOutlet UITableView *mainTableView;
    __weak IBOutlet UIView *inputViewWithTextFiled;
}

@end

@implementation VideoLiveViewController {
    
    BOOL isHiddenStatusBar; //判断是不是隐藏statusBar
    __weak IBOutlet UIView *mediaPlayBGView; //viwe来承载播放器  用于适配
    MPMoviePlayerViewController *moviePlayerViewController;
    CGRect mediaPleayViewFrame;
    UIButton * fullScreenBtn; //全屏按钮
    LiveDetailInterface * liveDetailInterface;
    NSMutableArray * listForTableView;
    NSString *otherUserName; //被回复人的用户名
    
    UIViewController *listViewController ;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setCascTitle:@"直播"];
        [self setFanhui];
        listForTableView = [[NSMutableArray alloc] init];
    }
    return self;
}
# pragma mark
# pragma mark LIFE CYCLE
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addVideoViewController];
    [self registerNotification];
    [self rightButtonMethod];
     [self requestNetworkData];
}

- (void)viewWillAppear:(BOOL)animated {
    
   
}

- (void)viewDidAppear:(BOOL)animated {
    

}
- (void)viewDidDisappear:(BOOL)animated {
    [self removeNotification];
}

#pragma mark - RIGHT- BUTTON - METHOD

-(void)rightButtonMethod {
    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"nav_btn_baocun.png"] forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"nav_btn_baocun_press.png"] forState:UIControlStateHighlighted];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setFrame:CGRectMake(0, 0, 42, 27)];
    [shareBtn setTitleColor:[KHLColor colorFromHexRGB:@"FE6024"] forState:UIControlStateNormal];
    [shareBtn.titleLabel setFont: [UIFont systemFontOfSize:14.0f]];
    UIBarButtonItem *fenleiRightBtn = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    [shareBtn addTarget:self action:@selector(shareBtnMethond:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = fenleiRightBtn;
}


- (void)shareBtnMethond:(UIButton *)sender {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"687706a51ff9836859a643485fc684bddacc3576"
                                      shareText:@"友盟社会化分享让您快速实现分享等社会化功能，http://umeng.com/social"
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:@[UMShareToSina]
                                       delegate:self];
}
#pragma mark - Register Notification
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyboardHeight:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    直播详情
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveDetailMethodWithNotification:) name:@"KHLNotiLiveDetailAcquired" object:nil];
//    评论列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentListMehod:) name:@"KHLUrlcommentlist" object:nil];
    //评论
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyMethod:) name:@"KHLNotiReplied" object:nil];
}

- (void)removeNotification {
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiLiveDetailAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLUrlcommentlist" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiReplied" object:nil];
}



# pragma mark
# pragma mark NETWORKING REQUEST METHOD

- (void)requestNetworkData {
    NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
    NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
    if (!([uidStr isEqualToString:@""] && [tokenStr isEqualToString:@""] && [self.liveInfoID isEqualToString:@""])) {
        self.liveInfoID = @"110";
        [[KHLDataManager instance] liveDetailHUDHolder:self.view identity:self.liveInfoID uid:uidStr token:tokenStr];
    }else {
        NSLog(@"请求数据的参数为空");
    }
    //获取评论列表
    [[KHLDataManager instance] commentlistHUDHolder:self.view model:@"live" zhiboid:self.liveInfoID];
//    4063
}

- (void)liveDetailMethodWithNotification:(NSNotification *)aNotification {
    NSDictionary *aDic = aNotification.object;
    if (aDic == nil) {
        NSLog(@"live detail failed");
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    if ([[aDic objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        NSDictionary * dic = [aDic objectForKey:@"result"];
        liveDetailInterface = [LiveDetailInterface new];
        liveDetailInterface.identity = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info_id"]];
        liveDetailInterface.category = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cate_id"]];
        liveDetailInterface.url = [NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]];
        liveDetailInterface.title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        
        liveTtitle.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        //从网络获取到url 然后播放
        [moviePlayerViewController.moviePlayer setContentURL:[NSURL URLWithString:liveDetailInterface.url]];
    }
}
//获取评论列表的通知方法
- (void)commentListMehod:(NSNotification *)aNotification {
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

            [listForTableView addObject:commentlist];
        }
        [mainTableView reloadData];
    }
}

- (void)replyMethod:(NSNotification *)aNotification {
    NSDictionary * aDic = aNotification.object;
    if (aDic == nil) {
        NSLog(@"reply failed");
        return;
    }
    
    if ([[aDic objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUsername"];
        NSString *replyTitle;
        NSLog(@"otherUserName  %@",otherUserName);
        if (otherUserName.length == 0) {
            replyTitle = username;
        }else {
            replyTitle = [NSString stringWithFormat:@"%@回复%@",username,otherUserName];
        }
        
        CommentListInterface * commentlist = [CommentListInterface new];
        commentlist.content = inputTextFiled.text;
        commentlist.username = replyTitle;
        commentlist.time = @"1234";
        commentlist.countBad = @"0";
        commentlist.countGood = @"0";
        
        [listForTableView insertObject:commentlist atIndex:0];
        [mainTableView reloadData];
        [inputTextFiled resignFirstResponder];
        inputTextFiled.text = @"";
        otherUserName = @"";
    }
}
# pragma mark
# pragma mark  添加播放器 设置播放器横屏

- (void)addVideoViewController{
    moviePlayerViewController = [[MPMoviePlayerViewController alloc] init];

    moviePlayerViewController.view.frame = mediaPlayBGView.bounds;
    mediaPleayViewFrame = moviePlayerViewController.view.frame;
    moviePlayerViewController.moviePlayer.controlStyle = MPMovieControlStyleNone;

    [mediaPlayBGView addSubview:moviePlayerViewController.view];
    
     //给播放器添加单击手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMediaPlayerMethod)];
    tap.delegate = self;
    [moviePlayerViewController.view addGestureRecognizer:tap];
    moviePlayerViewController.moviePlayer.shouldAutoplay = YES;
    //全屏按钮添加到播放器view上
    [moviePlayerViewController.view addSubview:[self fullScreenViewUI]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (void)tapMediaPlayerMethod {

}

- (UIView *)fullScreenViewUI {
    
    fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fullScreenBtn.frame = CGRectMake(mediaPlayBGView.frame.size.width - fullScreenBtn.frame.size.width,mediaPlayBGView.frame.size.height - 40,40, 40);
    fullScreenBtn.frame =CGRectMake(mediaPlayBGView.frame.size.width - fullScreenBtn.frame.size.width,
                                    (mediaPlayBGView.frame.size.height - 40), 40, 40);
    [fullScreenBtn setImage:[UIImage imageNamed:@"zhibo_icon_fangda"] forState:UIControlStateNormal];
    [fullScreenBtn setImage:[UIImage imageNamed:@"zhibo_icon_suoxiao"] forState:UIControlStateSelected];
    [fullScreenBtn setBackgroundColor:[UIColor blackColor]];
    fullScreenBtn.alpha = 0.6f;
    [fullScreenBtn addTarget:self action:@selector(fuScreenMethod:) forControlEvents:UIControlEventTouchUpInside];
    return fullScreenBtn;
}

//隐藏原本的viewController的statusBar
- (BOOL)prefersStatusBarHidden{
    return isHiddenStatusBar;
}

- (void)showStatusBar{
    isHiddenStatusBar = NO;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}
- (void)hideStatusBar{
    isHiddenStatusBar = YES;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)fuScreenMethod:(UIButton *)sender{
    if (sender.selected) {
        
        //全屏转半屏
        [CATransaction begin];
        [UIView animateWithDuration:0.5f animations:^{
            
            CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_4);
            [mediaPlayBGView setTransform:transform];
            mediaPlayBGView.transform = CGAffineTransformIdentity;
            mediaPlayBGView.frame = mediaPleayViewFrame;
            
            fullScreenBtn.frame =CGRectMake(mediaPlayBGView.frame.size.width - fullScreenBtn.frame.size.width,
                                            (mediaPlayBGView.frame.size.height - 40), 40, 40);
        } completion:^(BOOL finished) {
            [self showStatusBar];
            self.navigationController.navigationBarHidden = NO;
        }];
        [CATransaction commit];
        sender.selected = NO;
    } else {
        self.navigationController.navigationBarHidden = YES;

        [self hideStatusBar];
        [CATransaction begin];
        //半屏转全屏
        [UIView animateWithDuration:0.5 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2);
            [mediaPlayBGView setTransform:transform];
            
             mediaPlayBGView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);

            fullScreenBtn.frame =CGRectMake(mediaPlayBGView.frame.size.height - 40,
                                            mediaPlayBGView.frame.size.width - 40, 40, 40);
        } completion:^(BOOL finished) {

        }];
        [CATransaction commit];
        sender.selected = YES;
    }
}


#pragma mark
# pragma mark KEYBOARD HEIGHT CHANGE
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

        keyboardHeight.constant = -deltaY;

        [self.view updateConstraints];
        
    } completion:^(BOOL finished) {
        
    }];
    
    [CATransaction commit];
}


#pragma mark
#pragma mark UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (listForTableView.count == 0) {
        return @"暂无评论";
    }
    return [NSString stringWithFormat:@"评论区（%i）", listForTableView.count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listForTableView.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"KHLDianboCell";
    DianboCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DianboCell" owner:self options:nil]lastObject];
        [cell.huifuMehod addTarget:self action:@selector(pinglunMethondWithBottomBar:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //行号给tag
    cell.huifuMehod.tag = indexPath.row;
    
    CommentListInterface * commentlist = listForTableView[indexPath.row];
    cell.contentLabel.text = commentlist.content;
    cell.goodCountLabel.text = commentlist.countGood;
    cell.badCountLabel.text = commentlist.countBad;
//    [cell.imgeWithIcon setImageWithURL:[NSURL URLWithString:commentlist.portraitImageUrl]];
    cell.timeLabel.text = [KHLColor returnTheTimelabel:commentlist.time];
    
    
    NSString * usernametext;
    
    if (commentlist.usernameWithReply.length == 0) {
        usernametext = commentlist.username;
    }else {
        usernametext = [NSString stringWithFormat:@"%@回复%@",commentlist.username,commentlist.usernameWithReply];
    }
    cell.titleLabel.text = usernametext;
    
    return cell;
}

# pragma mark 
# pragma mark BUTTON ACTION METHOD
- (IBAction)pinglunMethondWithBottomBar:(id)sender {

    NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
    NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
    if (!(uidStr == nil || tokenStr == nil)) {
        UIButton * btn = (UIButton * )sender;
        inputTextFiled.tag =btn.tag;
        [inputTextFiled becomeFirstResponder];

    } else {
        LoginViewController * loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];

        [self.navigationController pushViewController:loginVC animated:YES];
    }
    

}
- (IBAction)actionForpinglunMehod:(id)sender {
    if ([inputTextFiled.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }else {
        NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
        NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
       
        //取出点击行的相关信息
       
        NSString * comment_id;
        
        if (inputTextFiled.tag == 101) {
            comment_id = self.liveInfoID;
        }else {
             CommentListInterface * commentlist = listForTableView[inputTextFiled.tag];
            otherUserName = commentlist.username;
            comment_id = commentlist.poster;
        }
        [[KHLDataManager instance] replyHUDHolder:self.view uid:uidStr target:comment_id content:inputTextFiled.text token:tokenStr targetType:@"comment"];
        NSLog(@"comment_id%@",comment_id);
    }
}
- (IBAction)returnRootHomePage:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)zanMethod:(id)sender {
}

- (void)huifuMehod:(UIButton *)sender {
    [inputTextFiled becomeFirstResponder];
}

# pragma mark - UITEXTFILED DELEGATE
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
