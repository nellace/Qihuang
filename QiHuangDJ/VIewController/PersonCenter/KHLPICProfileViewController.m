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
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setCascTitle:@"个人资料"];
    [self setFanhui];
    [self drawRightNavigationButton];
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

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
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
//}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField setBackgroundColor:[UIColor clearColor]];
//    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}



@end
