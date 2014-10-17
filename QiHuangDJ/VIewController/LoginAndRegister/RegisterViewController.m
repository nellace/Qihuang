//
//  RegisterViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "RegisterViewController.h"

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
    NSLog(@"press confirm registration button");
}


@end
