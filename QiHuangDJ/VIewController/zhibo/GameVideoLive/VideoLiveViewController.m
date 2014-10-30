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

    __weak IBOutlet NSLayoutConstraint *keyboardHeight;
    __weak IBOutlet UIView *inputViewWithTextFiled;
}

@end

@implementation VideoLiveViewController {
    
    BOOL isHiddenStatusBar; //判断是不是隐藏statusBar
    MPMoviePlayerViewController *moviePlayerViewController;
    __weak IBOutlet UIView *mediaPlayBGView; //viwe来承载播放器  用于适配
    CGRect mediaPleayViewFrame;
    UIView *gongjutiaoView;  //全屏工具条
    UIButton * fullScreenBtn; //全屏按钮
    BOOL isHiddenForGongjutiao; //工具条是否隐藏
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setCascTitle:@"直播"];
        [self setFanhui];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyboardHeight:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
# pragma mark
# pragma mark  添加播放器 设置播放器横屏

- (void)addVideoViewController{
    moviePlayerViewController = [[MPMoviePlayerViewController alloc] init];

    moviePlayerViewController.view.frame = mediaPlayBGView.bounds;
    mediaPleayViewFrame = moviePlayerViewController.view.frame;
    moviePlayerViewController.moviePlayer.controlStyle = MPMovieControlStyleNone;
    //给播放器添加单击手势

    [mediaPlayBGView addSubview:moviePlayerViewController.view];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMediaPlayerMethod)];
    tap.delegate = self;
    [moviePlayerViewController.view addGestureRecognizer:tap];
    
    //控制view添加到播放器view上
    [moviePlayerViewController.view addSubview:[self fullScreenViewUI]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (void)tapMediaPlayerMethod {
    [self isHiddenWithGongjutiao:NO];
}

- (UIView *)fullScreenViewUI {
    
    gongjutiaoView = [[UIView alloc] initWithFrame:CGRectMake(0, mediaPlayBGView.frame.origin.y - gongjutiaoView.frame.size.height, mediaPlayBGView.bounds.size.width, 40)];
    gongjutiaoView.frame = CGRectMake(0, mediaPlayBGView.frame.size.height - gongjutiaoView.frame.size.height, mediaPlayBGView.bounds.size.width, 40);
    gongjutiaoView.backgroundColor = [UIColor grayColor];
    
    
    fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fullScreenBtn.frame = CGRectMake(gongjutiaoView.frame.size.width - fullScreenBtn.frame.size.width,0,40, gongjutiaoView.frame.size.height);
    fullScreenBtn.frame =CGRectMake(mediaPlayBGView.frame.size.width - fullScreenBtn.frame.size.width,
                                    0, 40, 40);
    [fullScreenBtn setTitle:@"全屏" forState:UIControlStateNormal];
    [fullScreenBtn setBackgroundColor:[UIColor redColor]];
    [fullScreenBtn addTarget:self action:@selector(fuScreenMethod:) forControlEvents:UIControlEventTouchUpInside];
    [gongjutiaoView addSubview:fullScreenBtn];
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
        [UIView animateWithDuration:0.3f animations:^{
            
            CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_4);
            [mediaPlayBGView setTransform:transform];
            mediaPlayBGView.transform = CGAffineTransformIdentity;
            mediaPlayBGView.frame = mediaPleayViewFrame;
            
            gongjutiaoView.frame = CGRectMake(0, mediaPlayBGView.frame.size.height - gongjutiaoView.frame.size.height, mediaPlayBGView.bounds.size.width, 40);
            fullScreenBtn.frame =CGRectMake(gongjutiaoView.frame.size.width - fullScreenBtn.frame.size.width,
                                            0, 40, 40);
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
        [UIView animateWithDuration:1.0f animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2);
            [mediaPlayBGView setTransform:transform];
            
             mediaPlayBGView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
            gongjutiaoView.frame = CGRectMake(0, mediaPlayBGView.frame.size.width - 40, mediaPlayBGView.frame.size.height, 40);
            fullScreenBtn.frame =CGRectMake(gongjutiaoView.frame.size.width - fullScreenBtn.frame.size.width,
                                            0, 40, gongjutiaoView.frame.size.height);
            [self isHiddenWithGongjutiao:NO];
        } completion:^(BOOL finished) {
            [self isHiddenWithGongjutiao:YES];

        }];
        [CATransaction commit];
        sender.selected = YES;
    }
}
//工具条隐藏方法
- (void)isHiddenWithGongjutiao:(BOOL)yesOrNo {
    gongjutiaoView.hidden = yesOrNo;
    if (!yesOrNo) {
        [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(hiddenGongju) userInfo:nil repeats:NO];
    }
}

- (void)hiddenGongju {
 
    [UIView animateWithDuration:2.0f animations:^{
        gongjutiaoView.alpha = 1.0f;
        gongjutiaoView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        gongjutiaoView.alpha = 1.0f;
        gongjutiaoView.hidden = YES;
    }];
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
        inputViewWithTextFiled.frame = CGRectMake(inputViewWithTextFiled.frame.origin.x
                                          ,inputViewWithTextFiled.frame.size.height + deltaY, inputViewWithTextFiled.frame.size.width, inputViewWithTextFiled.frame.size.height);
        keyboardHeight.constant = (deltaY + inputViewWithTextFiled.frame.size.height - 80);
        NSLog(@"keyboard %f",keyboardHeight.constant);
        
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
    return 6;
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
    return cell;
}

# pragma mark 
# pragma mark BUTTON ACTION METHOD
- (IBAction)pinglunMethondWithBottomBar:(id)sender {
    [inputTextFiled becomeFirstResponder];
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
