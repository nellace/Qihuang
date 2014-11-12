//
//  LoginViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"


@interface LoginViewController () 
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *autoLoginButton;
@property (nonatomic, setter = setAutoLogin:, getter = isAutoLogin) BOOL bAutoLogin;
@end

@implementation LoginViewController



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // ..
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Draw navigation bar..
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bg@2x.png"]]];
    [self setCascTitle:@"登录"];
    [self setFanhui];
    
    // Init Layout and attributes..
    [self setAutoLogin:TRUE];
    [self.usernameTextField setBackgroundColor:[UIColor clearColor]];
    [self.passwordTextField setBackgroundColor:[UIColor clearColor]];
    self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用户名/邮箱" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // Register notification..
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotified:) name:@"KHLNotiLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retrievePasswordNotified:) name:@"KHLNotiRetrievePassword" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotified:) name:@"HKLUrlThrild" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    // Remove notification..
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiLogin" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiRetrievePassword" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



# pragma mark - ATTRIBUTES GETTER AND SETTER

- (void)setAutoLogin:(BOOL)bAutoLogin
{
    _bAutoLogin = bAutoLogin;
    [[NSUserDefaults standardUserDefaults] setBool:bAutoLogin forKey:@"KHLAutoLogin"];
    if (_bAutoLogin) {
        [self.autoLoginButton setImage:[UIImage imageNamed:@"denglu_zidongdenglu_press.png"]
                              forState:UIControlStateNormal];
    } else {
        [self.autoLoginButton setImage:[UIImage imageNamed:@"denglu_zidongdenglu.png"]
                              forState:UIControlStateNormal];
    }
}

# pragma mark - USER INTERACTION RESPONSE

- (IBAction)pressCancel:(UIButton *)sender
{
    [self.delegate onLoginFailed];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressCommit:(UIButton *)sender
{
    if (self.usernameTextField.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (!(self.usernameTextField.text.length >= 3 && self.usernameTextField.text.length <= 21)) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名长度3-21个字符" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.passwordTextField.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (!(self.passwordTextField.text.length >= 6 && self.passwordTextField.text.length <= 20)) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码长度6-20个字符" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [[KHLDataManager instance] loginHUDHolder:self.view loginName:self.usernameTextField.text password:self.passwordTextField.text];
}

- (IBAction)pressInterrelatedLoginWithQQ:(UIButton *)sender
{
    [self umengThirdWithName:UMShareToQQ];
}

- (IBAction)pressInterrelatedLoginWithWeibo:(UIButton *)sender
{
    [self umengThirdWithName:UMShareToSina];
}

-(void)umengThirdWithName:(NSString *)thirdName {
    //此处调用授权的方法,你可以把下面的platformName 替换成 UMShareToSina,UMShareToTencent等
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:thirdName];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        NSLog(@"login response is %@",response);
        
        //     获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:thirdName];
            NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
        [[KHLDataManager instance] thirdLogin:self.view third_type:thirdName sina_id:snsAccount.usid tencet_id:snsAccount.usid third_username:snsAccount.userName];
        }
    });

}

- (IBAction)pressRegisterButton:(UIButton *)sender
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)pressAutoLoginButton:(UIButton *)sender
{
    self.bAutoLogin = !self.bAutoLogin;
}

- (IBAction)pressForgotPasswordButton:(UIButton *)sender
{
    [[KHLDataManager instance] retrievePasswordHUDHolder:self.view email:@"cl4p_prime@hotmail.com"];
}

#pragma mark - NOTIFICATION METHODES

- (void)loginNotified: (NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    if (!dict) {
        NSLog(@"妈蛋，返回nil了。");
        return;
    }
    
    if ([[dict objectForKey:@"resultCode"] isEqualToString:@"0"])
    {
        NSDictionary *result = [dict objectForKey:@"result"];
        LoginInterface *interface = [[LoginInterface alloc] init];
        interface.uid = [NSString stringWithFormat:@"%@", [result objectForKey:@"uid"]];
        interface.token = [NSString stringWithFormat:@"%@", [result objectForKey:@"token"]];
        interface.username = [NSString stringWithFormat:@"%@", [result objectForKey:@"username"]];
        interface.phone = [NSString stringWithFormat:@"%@", [result objectForKey:@"mobile"]];
        interface.name = [NSString stringWithFormat:@"%@", [result objectForKey:@"nameture"]];
        interface.gender = [NSString stringWithFormat:@"%@", [result objectForKey:@"sex"]];
        interface.birthday = [NSString stringWithFormat:@"%@", [result objectForKey:@"birthday"]];
        interface.blog = [NSString stringWithFormat:@"%@", [result objectForKey:@"blogaddress"]];
        interface.regtime = [NSString stringWithFormat:@"%@", [result objectForKey:@"registertime"]];
        interface.email = [NSString stringWithFormat:@"%@", [result objectForKey:@"email"]];
        interface.qq = [NSString stringWithFormat:@"%@", [result objectForKey:@"qq"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:interface.uid forKey:@"KHLPIUID"];
        [[NSUserDefaults standardUserDefaults] setObject:interface.token forKey:@"KHLPIToken"];
        [[NSUserDefaults standardUserDefaults] setObject:interface.username forKey:@"KHLPIUsername"];
        [[NSUserDefaults standardUserDefaults] setObject:interface.phone forKey:@"KHLPIPhoneNumber"];
        [[NSUserDefaults standardUserDefaults] setObject:interface.name forKey:@"KHLPIName"];
        [[NSUserDefaults standardUserDefaults] setObject:interface.gender forKey:@"KHLPIGender"];
        [[NSUserDefaults standardUserDefaults] setObject:interface.birthday forKey:@"KHLPIBirthday"];
        [[NSUserDefaults standardUserDefaults] setObject:interface.blog forKey:@"KHLPIBlog"];
        [[NSUserDefaults standardUserDefaults] setObject:interface.regtime forKey:@"KHLPIRegisterTime"];
        [[NSUserDefaults standardUserDefaults] setObject:interface.email forKey:@"KHLPIEmail"];
        [[NSUserDefaults standardUserDefaults] setObject:interface.qq forKey:@"KHLPIQQ"];
        

        
        if ((!interface.uid) || (!interface.token)) {
            [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:@"获取用户token失败。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }
        
        [self.delegate onLoginSuccess];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if ([[dict objectForKey:@"resultCode"] isEqualToString:@"2"]) {
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:@"登录失效，请重新登录。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

- (void)retrievePasswordNotified:(NSNotification *)notification
{
    
}


@end
