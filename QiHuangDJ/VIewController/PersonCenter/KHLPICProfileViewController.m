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
@property (weak, nonatomic) IBOutlet UITextField *blogTextField;
@property (weak, nonatomic) IBOutlet UILabel *registerDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *qqTextField;
@property (weak, nonatomic) IBOutlet UIView *birthDatePickerHolderView;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *birthDateLabel;

@property (nonatomic) NSString *nickname;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *gender;
@property (nonatomic) NSString *birthdate;
@property (nonatomic) NSString *blog;
@property (nonatomic) NSString *regtime;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *qq;

@property (nonatomic) NSDate *currentPickedDate;

@property (nonatomic) CGFloat topOffset;
@property (nonatomic) CGFloat keyHeight;

@end

@implementation KHLPICProfileViewController

#define BIRTHDAY_FORMAT @"yyyy-MM-dd"

#define GENDER_MALE @"1"
#define GENDER_FEMALE @"2"
#define GENDER_UNSPECIFIED @"3"



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure background tap recognization to hide keyboard and date picker..
    UITapGestureRecognizer *tapToHideRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapToHideRecognizer addTarget:self action:@selector(hideKeyboard:)];
    [tapToHideRecognizer addTarget:self action:@selector(hideBirthDatePicker:)];
    [tapToHideRecognizer setCancelsTouchesInView:FALSE];
    [self.view addGestureRecognizer:tapToHideRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Draw navigation bar and attach items..
    [self setCascTitle:@"个人资料"];
    [self setFanhui];
    [self drawRightNavigationButton];
    
    // Load initial data..
    [self loadPIDataToRefreshView];
    
    // Set initial keyboard height..
    [self setKeyHeight:253];
    
    // Register notification..
    [self registerNotification];
    
    // Configure birthdate picker..
    [self.birthDatePickerHolderView setHidden:TRUE];
    [self.birthDatePicker setMaximumDate:[NSDate date]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Remove notification..
    [self unregisterNotification];
}



#pragma mark - ATTRIBUTES GETTER AND SETTER

@synthesize gender = _gender;
@synthesize birthdate = _birthdate;

- (void)setGender:(NSString *)gender
{
    if ([gender isEqualToString:GENDER_MALE]) {
        [self.genderLabel setText:@"男"];
    } else {
        [self.genderLabel setText:@"女"];
    }
    
    _gender = gender;
}

- (void)setBirthdate:(NSString *)birthdate
{
    if (!birthdate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:BIRTHDAY_FORMAT];
        _birthdate = [formatter stringFromDate:[NSDate date]];
    } else _birthdate = birthdate;
}

- (NSString *)phone
{
    if (!_phone) _phone = @"";
    return _phone;
}

- (NSString *)name
{
    if (!_name) _name = @"";
    return _name;
}
- (NSString *)location
{
    if (!_location) _location = @"";
    return _location;
}

- (NSString *)gender
{
    if (!_gender) _gender = @"";
    return _gender;
}

- (NSString *)birthdate
{
    if (!_birthdate) _birthdate = @"";
    return _birthdate;
}

- (NSString *)blog
{
    if (!_blog) _blog = @"";
    return _blog;
}

- (NSString *)qq
{
    if (!_qq) _qq = @"";
    return _qq;
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

- (void)loadPIDataToRefreshView
{
    [self setNickname:[[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUsername"]];
    [self setPhone:[[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIPhoneNumber"]];
    [self setName:[[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIName"]];
    [self setGender:[[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIGender"]];
    [self setBirthdate:[[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIBirthday"]];
    [self setBlog:[[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIBlog"]];
    [self setRegtime:[[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIRegisterTime"]];
    [self setEmail:[[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIEmail"]];
    [self setQq:[[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIQQ"]];
    
    [self.nicknameLabel setText:self.nickname];
    [self.phoneTextField setText:self.phone];
    [self.nameTextField setText:self.name];
    [self.birthDateLabel setText:self.birthdate];
    [self.blogTextField setText:self.blog];
    [self.registerDateLabel setText:self.regtime];
    [self.emailLabel setText:self.email];
    [self.qqTextField setText:self.qq];
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

- (void)hideBirthDatePicker: (UITapGestureRecognizer *)tap
{
    [self.birthDatePickerHolderView setHidden:TRUE];
//    [UIView beginAnimations:@"HideBirthDatePicker" context:nil];
//    [UIView setAnimationDuration:0.30f];
//    [self.birthDatePickerHolderView setFrame:CGRectMake(self.birthDatePickerHolderView.frame.origin.x, self.view.frame.size.height + self.view.frame.origin.y, self.birthDatePickerHolderView.frame.size.width, self.birthDatePickerHolderView.frame.size.height)];
//    [UIView commitAnimations];
}



#pragma mark - USER INTERACTION RESPONSE

- (void)pressSaveButton
{
    self.nickname = self.nicknameLabel.text;
    self.phone = self.phoneTextField.text;
    self.name = self.nameTextField.text;
    self.blog = self.blogTextField.text;
    self.qq = self.qqTextField.text;
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
//    NSLog(@"\nuid=%@\ntoken=%@\nnickname=%@\nphone=%@\nname=%@\nblog=%@\nqq=%@\nbirthday=%@\ngender=%@", uid, token, self.nickname, self.phone, self.name, self.blog, self.qq, self.birthdate, self.gender);
    if ((!uid) || (!token)) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"token获取失败，请重新登录。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
    [[KHLDataManager instance] modifyPersonalInformationHUDHolder:self.view uid:uid phone:self.phone name:self.name gender:self.gender birthday:self.birthdate blog:self.blog qq:self.qq token:token];
}

- (IBAction)pressGenderToggleButton:(UIButton *)sender
{
    if ([self.gender isEqualToString:GENDER_MALE]) {
        [self setGender:GENDER_FEMALE];
    } else {
        [self setGender:GENDER_MALE];
    }
}

- (IBAction)pressBirthdatePickButton:(UIButton *)sender
{
    // Test init date
//    NSDateComponents *initComponents = [[NSDateComponents alloc] init];
//    [initComponents setYear:1991];
//    [initComponents setMonth:5];
//    [initComponents setDay:21];
//    [initComponents setHour:0];
//    [initComponents setMinute:0];
//    [initComponents setSecond:0];
//    NSCalendar *initCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDate *initDate = [initCalendar dateFromComponents:initComponents];
    
    if (![self.birthDatePickerHolderView isHidden]) {
        [self.birthDatePickerHolderView setHidden:TRUE];
    } else {
        // Create date formatter and transform string into date..
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:BIRTHDAY_FORMAT];
        NSDate *stringDate = [formatter dateFromString:self.birthdate];
        if (!stringDate) {
            stringDate = [NSDate date];
        }
        [self.birthDatePicker setDate:stringDate];
        [self.birthDatePickerHolderView setHidden:FALSE];
    }
}

- (IBAction)changeBirthDatePicker:(UIDatePicker *)sender
{
    self.currentPickedDate = sender.date;
}

- (IBAction)pressConfirmPickedBirthDate:(UIButton *)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:BIRTHDAY_FORMAT];
    self.birthdate = [formatter stringFromDate:self.birthDatePicker.date];
    
    self.birthDateLabel.text = self.birthdate;
}

- (IBAction)pressCancelPickedBirthDate:(UIButton *)sender
{
    
}

#pragma mark - TEXT FIELD DELEGATE

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self hideBirthDatePicker:nil];
    [textField setBackgroundColor:[KHLColor xiaotubai]];
    return TRUE;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.topOffset = self.view.frame.origin.y;
    
    UIView *v = textField;
    CGFloat offset = v.frame.size.height + v.frame.origin.y;
    for (int i = 0; ![v isEqual:self.view]; i++) {
        v = [v superview];
        
        offset += v.frame.origin.y;
        if ([v isKindOfClass:[UIScrollView class]]) {
            UIScrollView *sv = (id)v;
            offset -= sv.contentOffset.y;
        }
    }
    offset -= self.topOffset;
    CGFloat dis = self.view.frame.size.height - offset - self.keyHeight;
    if (dis < 0) {
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



#pragma mark - NOTIFICATION METHODES

- (void)registerNotification
{
    // Keyboard notifications..
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // Custom data notification..
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personalInformationModificationNotified:) name:@"KHLNotiPersonalInformationModify" object:nil];
    
    
}

- (void)unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiPersonalInformationModify" object:nil];
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
//    NSLog(@"+ will hide");
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
}

- (void)personalInformationModificationNotified: (NSNotification *)notification
{
    NSDictionary *dict = [notification object];
    if (!dict) {
        NSLog(@"妈蛋，返回nil了。");
        return;
    }
    
    if ([[dict objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        NSLog(@"个人资料修改成功。");
        [[NSUserDefaults standardUserDefaults] setObject:self.nickname forKey:@"KHLPIUsername"];
        [[NSUserDefaults standardUserDefaults] setObject:self.phone forKey:@"KHLPIPhoneNumber"];
        [[NSUserDefaults standardUserDefaults] setObject:self.name forKey:@"KHLPIName"];
        [[NSUserDefaults standardUserDefaults] setObject:self.gender forKey:@"KHLPIGender"];
        [[NSUserDefaults standardUserDefaults] setObject:self.birthdate forKey:@"KHLPIBirthday"];
        [[NSUserDefaults standardUserDefaults] setObject:self.blog forKey:@"KHLPIBlog"];
        [[NSUserDefaults standardUserDefaults] setObject:self.regtime forKey:@"KHLPIRegisterTime"];
        [[NSUserDefaults standardUserDefaults] setObject:self.email forKey:@"KHLPIEmail"];
        [[NSUserDefaults standardUserDefaults] setObject:self.qq forKey:@"KHLPIQQ"];
        [self.navigationController popViewControllerAnimated:TRUE];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}


@end
