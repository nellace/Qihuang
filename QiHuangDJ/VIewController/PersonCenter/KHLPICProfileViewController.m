//
//  KHLPICProfileViewController.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-20.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import "KHLPICProfileViewController.h"
#import "KHLColor.h"

@interface KHLPICProfileViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
// birthdate
@property (weak, nonatomic) IBOutlet UITextField *blogTextField;
@property (weak, nonatomic) IBOutlet UILabel *registerDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *qqTextField;

@property (nonatomic) CGFloat topOffset;
@property (nonatomic) CGFloat keyHeight;

@end

@implementation KHLPICProfileViewController



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [tapGestureRecognizer setCancelsTouchesInView:FALSE];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self unregisterNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setCascTitle:@"个人资料"];
    [self setFanhui];
    [self drawRightNavigationButton];
    
    [self setKeyHeight:253];
    [self registerNotification];
    
//    UIView *background = [self.view superview];
//    if (![self.mainView isEqual:self.view]) {
//        NSLog(@"yoooo");
//        [self.mainView setBackgroundColor:[KHLColor tubai]];
//    }
}



#pragma mark - LAYOUT CUSTOM METHODES

- (void)drawRightNavigationButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_btn_baocun@2x.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_btn_baocun_press@2x.png"] forState:UIControlStateHighlighted];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 42, 27)];
    [btn setTitleColor:[KHLColor colorFromHexRGB:@"FE6024"] forState:UIControlStateNormal];
    [btn.titleLabel setFont: [UIFont systemFontOfSize:14.0f]];
    [btn addTarget:self action:@selector(pressSaveButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightNavigationBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightNavigationBarButton;
}



#pragma mark - CUSTOM METHODES

- (void)hideKeyboard: (UITapGestureRecognizer *)tap
{
    [self.phoneTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.locationTextField resignFirstResponder];
    [self.blogTextField resignFirstResponder];
    [self.qqTextField resignFirstResponder];
}



#pragma mark - USER INTERACTION RESPONSE

- (void)pressSaveButton
{
    NSLog(@"保个存呀");
}

- (IBAction)pressGenderToggleButton:(UIButton *)sender
{
    
}



#pragma mark - TEXT FIELD DELEGATE

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField setBackgroundColor:[KHLColor xiaotubai]];
    return TRUE;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    CGRect frame = textField.frame;
//    int offset = frame.origin.y + frame.size.height - (self.view.frame.size.height - 216);
//    NSLog(@"offset: %d, 1: %.0f, 2: %.0f", offset, (frame.origin.y + frame.size.height), (self.view.frame.size.height - 216));
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    if (offset > 0) {
//        NSLog(@"孤执行了！");
//        self.view.frame = CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height);
//    }
//    [UIView commitAnimations];
    
//    for (UIView *v = textField, int i = 0; [v isEqual:self.view]; v = [v superview], i++) {
//        NSLog(@"");
//    }
//    NSLog(@"self.view (%.0f, %.0f) [%.0f x %.0f]", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.topOffset = self.view.frame.origin.y;
//    self.keyHeight = 250;
    
    UIView *v = textField;
    CGFloat offset = v.frame.size.height + v.frame.origin.y;
    for (int i = 0; ![v isEqual:self.view]; i++) {
        v = [v superview];
        
//        NSLog(@"No.%d, (frame.y = %.0f)", i, v.frame.origin.y);
        
        offset += v.frame.origin.y;
        if ([v isKindOfClass:[UIScrollView class]]) {
            UIScrollView *sv = (id)v;
            offset -= sv.contentOffset.y;
        }
    }
    offset -= self.topOffset;
    NSLog(@" == final offset: %.0f", offset);
    CGFloat dis = self.view.frame.size.height - offset - self.keyHeight;
    if (dis < 0) {
//        NSLog(@"孤执行了！");
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:0.50f];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + dis, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [textField setBackgroundColor:[UIColor clearColor]];
////    CGFloat navOffset = self.navigationController.navigationBar.frame.size.height;
////    NSLog(@"nb height:  %.0f", navOffset);
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:0.50f];
//    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    [UIView commitAnimations];
//}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    // Clear background white color while ending editing..
    [textField setBackgroundColor:[UIColor clearColor]];
    
    // Animate reset self.view's frame..
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.30f];
    self.view.frame = CGRectMake(0, self.topOffset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}



#pragma mark - KEYBOARD NOTIFICATION

- (void)registerNotification
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)unregisterNotification
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillShow: (NSNotification *)notification
{
//    NSDictionary *info = [notification userInfo];
//    CGFloat pre = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
//    CGFloat height = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:0.30f];
//    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - (height - pre), self.view.frame.size.width, self.view.frame.size.height);
//    [UIView commitAnimations];
//    
//    self.keyHeight = height;
//    NSLog(@"+ will show: %.0f pre: %.0f", height, pre);
}

//- (void)keyboardDidShow: (NSNotification *)notification
//{
//    NSDictionary *info = [notification userInfo];
//    CGFloat height = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    
//    self.keyHeight = height;
//    NSLog(@"+ did show: %.0f", self.keyHeight);
//}

- (void)keyboardWillHide: (NSNotification *)notification
{
    NSLog(@"+ will hide");
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:0.30f];
//    self.view.frame = CGRectMake(0, self.topOffset, self.view.frame.size.width, self.view.frame.size.height);
//    [UIView commitAnimations];
}

- (void)keyboardWillChangeFrame: (NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat pre = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    CGFloat height = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.30f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - (height - pre), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    if (self.keyHeight < height)
        self.keyHeight = height;
    NSLog(@"+ will change frame %.0f pre: %.0f", height, pre);
}


@end
