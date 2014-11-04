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
@interface VideoLiveViewController () <UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
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
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setCascTitle:@"直播"];
        [self setFanhui];
        listForTableView = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"1",@"2", nil];
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
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerNotification];
    [self requestNetworkData];
}

- (void)viewDidAppear:(BOOL)animated {
    

}
- (void)viewDidDisappear:(BOOL)animated {
    [self removeNotification];
}
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyboardHeight:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveDetailMethodWithNotification:) name:@"KHLNotiLiveDetailAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentListMehod:) name:@"KHLUrlcommentlist" object:nil];
}

- (void)removeNotification {
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiLiveDetailAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLUrlcommentlist" object:nil];
}

# pragma mark
# pragma mark NETWORKING REQUEST

- (void)requestNetworkData {
    NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
    NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
    if (!([uidStr isEqualToString:@""] && [tokenStr isEqualToString:@""] && [self.liveInfoID isEqualToString:@""])) {
        [[KHLDataManager instance] liveDetailHUDHolder:self.view identity:self.liveInfoID uid:uidStr token:tokenStr];
    }else {
        NSLog(@"请求数据的参数为空");
    }
}

- (void)liveDetailMethodWithNotification:(NSNotification *)aNotification {
    NSDictionary *aDic = aNotification.object;
    if (aDic == nil) {
        NSLog(@"live detail failed");
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
//        [moviePlayerViewController.moviePlayer setContentURL:[NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"]];
    }
}
//获取评论列表的通知方法
- (void)commentListMehod:(NSNotification *)aNotification {
    
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
    fullScreenBtn.frame = CGRectMake(mediaPlayBGView.frame.size.width - fullScreenBtn.frame.size.width,mediaPlayBGView.frame.size.height - 20,20, 20);
    fullScreenBtn.frame =CGRectMake(mediaPlayBGView.frame.size.width - fullScreenBtn.frame.size.width,
                                    (mediaPlayBGView.frame.size.height - 20), 20, 20);
    [fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"zhibo_icon_fangda"] forState:UIControlStateNormal];
    [fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"zhibo_icon_suoxiao"] forState:UIControlStateSelected];
    [fullScreenBtn addTarget:self action:@selector(fuScreenMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [gongjutiaoView addSubview:fullScreenBtn];
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
                                            (mediaPlayBGView.frame.size.height - 20), 20, 20);
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

            fullScreenBtn.frame =CGRectMake(mediaPlayBGView.frame.size.height - 20,
                                            mediaPlayBGView.frame.size.width - 20, 20, 20);


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

//        inputViewWithTextFiled.frame = CGRectMake(inputViewWithTextFiled.frame.origin.x
//                                          ,100, inputViewWithTextFiled.frame.size.width, inputViewWithTextFiled.frame.size.height);
        keyboardHeight.constant = -(deltaY - 10);
        inputViewWithTextFiled.hidden = NO;
        
        [self.view updateConstraints];
        
    } completion:^(BOOL finished) {
        
    }];
    
    [CATransaction commit];
}


#pragma mark
#pragma mark UITableViewDataSource

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
    }
    
    NSString * str = listForTableView[indexPath.row];

    return cell;
}

# pragma mark 
# pragma mark BUTTON ACTION METHOD
- (IBAction)pinglunMethondWithBottomBar:(id)sender {
    [inputTextFiled becomeFirstResponder];
}
- (IBAction)actionForpinglunMehod:(id)sender {
    [listForTableView insertObject:@"10月31日下午，习近平出席全军政治工作会议并发表重要讲话。他强调，革命的政治工作是革命军队的生命线。在长期实践中，我军政治工作形成了一整套优良传统，" atIndex:0];
    [mainTableView reloadData];
    [inputTextFiled resignFirstResponder];
}
- (IBAction)returnRootHomePage:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)zanMethod:(id)sender {
}

# pragma mark
# pragma mark UITEXTFILED DELEGATE
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
