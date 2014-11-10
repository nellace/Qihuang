//
//  RegisterViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "RegisterViewController.h"
#import "KHLDataManager.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UIButton *licenseAgreementCheckButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmRegistrationButton;
@property (weak, nonatomic) IBOutlet UIButton *genderToggleButton;


@property (nonatomic, setter = setLicenseAgreed:, getter = isLicenseAgreed) BOOL bLicenseAgreed;

/**
 *  GENDER_MALE
 *  GENDER_FEMALE
 *  GENDER_UNSPECIFIED
 */
@property (nonatomic) NSInteger gender;

@end

#define GENDER_MALE 1
#define GENDER_FEMALE 0
#define GENDER_UNSPECIFIED -1

@implementation RegisterViewController


#pragma mark - VIEW CONTROLLER LIFECYCLE

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setCascTitle:@"注册"];
        [self setFanhui];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setGender:GENDER_MALE];
    [self setLicenseAgreed:TRUE];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Register notification..
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerNotified:) name:@"KHLNotiRegistered" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Remove notification..
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiRegistered" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



# pragma mark - ATTRIBUTES GETTER AND SETTER

- (void)setLicenseAgreed:(BOOL)bLicenseAgreed
{
    _bLicenseAgreed = bLicenseAgreed;
    if (_bLicenseAgreed) {
        [self.licenseAgreementCheckButton setImage:[UIImage imageNamed:@"woyaozhuce_tiaokuan_press.png"] forState:UIControlStateNormal];
        [self.confirmRegistrationButton setEnabled:TRUE];
    } else {
        [self.licenseAgreementCheckButton setImage:[UIImage imageNamed:@"woyaozhuce_tiaokuan.png"] forState:UIControlStateNormal];
        [self.confirmRegistrationButton setEnabled:FALSE];
    }
}

- (void)setGender:(NSInteger)gender
{
    _gender = gender;
    if (_gender == GENDER_MALE) {
        [self.genderTextField setText:@"男"];
    } else if (_gender == GENDER_FEMALE) {
        [self.genderTextField setText:@"女"];
    } else {
        [self.genderTextField setText:@""];
    }
}


# pragma mark - USER INTERACTION RESPONSE

- (IBAction)pressGenderToggleButton:(UIButton *)sender
{
    if (self.gender == GENDER_MALE) {
        [self setGender:GENDER_FEMALE];
    } else {
        [self setGender:GENDER_MALE];
    }
}

- (IBAction)pressLicenseAgreementCheckButton:(UIButton *)sender
{
    [self setLicenseAgreed:!self.bLicenseAgreed];
}

- (IBAction)pressConfirmRegistrationButton:(UIButton *)sender
{
    if ([[self.nicknameTextField text] isEqualToString:@""]
        || [[self.passwordTextField text] isEqualToString:@""]
        || [[self.confirmPasswordTextField text] isEqualToString:@""]
        || [[self.emailTextField text] isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入完整的信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    } else if (![[self.passwordTextField text] isEqualToString:[self.confirmPasswordTextField text]]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码输入不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    } else {
        NSString *username = [self.nicknameTextField text];
        NSString *password = [self.passwordTextField text];
        NSString *gender = (self.gender == GENDER_MALE ? @"1" : @"2");
        NSString *email = [self.emailTextField text];
        [[KHLDataManager instance] registerHUDHolder:self.view username:username password:password gender:gender email:email];
    }
}



#pragma mark - NOTIFICATION METHODES

- (void)registerNotified: (NSNotification *)notification
{
    NSDictionary *dict = [notification object];
    if (!dict) {
        NSLog(@"妈蛋，返回nil了。");
        return;
    }
    
    if ([[dict objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        NSLog(@"注册成功。uid=%@", [dict objectForKey:@"result"]);
        [[[UIAlertView alloc] initWithTitle:@"注册成功" message:@"注册成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        [self.navigationController popViewControllerAnimated:TRUE];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}


@end
