//
//  DianboViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "DianboViewController.h"
#import "DianboCell.h"
@interface DianboViewController ()
@property (weak, nonatomic) IBOutlet UITextField *shuruTextFiled;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;


@end

@implementation DianboViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setCascTitle:@"点播"];
        [self setFanhui];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyboardHeight:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


# pragma mark UITableViewDataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"评论区（231）";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"KHLDianboCell";
    DianboCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DianboCell" owner:self options:nil]lastObject];
    }
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

- (void)viewWillLayoutSubviews {

}
@end
