//
//  InfomationViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "InfomationViewController.h"
#import "DianboCell.h"
#import "infomationForHeader.h"
#import "LoginViewController.h"
#import "JubaoViewController.h"
@interface InfomationViewController () <UIWebViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeighAuto;

@property (nonatomic, getter=needsPrestrain, setter=setNeedsPrestrain:) BOOL prestrainTag;
@property (nonatomic, strong) InformationDetailInterface *detail;
@property (weak, nonatomic) IBOutlet UITextField *inputTextFiled;

//@property (nonatomic, strong) NSMutableArray *heights;

@end

static  NSInteger goodCount; //记录等号

@implementation InfomationViewController {
    infomationForHeader * infoHeader;
    NSInteger sectionHeight;
    NSMutableArray *listArrayWithInfo;
    NSString *otherUserName;  //被评论人的名子
}

#pragma mark - ATTRIBUTES GETTER AND SETTER

- (SearchInterface *)prestrain
{
    if (!_prestrain) _prestrain = [[SearchInterface alloc] init];
    return _prestrain;
}

- (InformationDetailInterface *)detail
{
    if (!_detail) _detail = [[InformationDetailInterface alloc] init];
    return _detail;
}

//- (NSMutableArray *)heights
//{
//    if (!_heights) _heights = [[NSMutableArray alloc] init];
//    return _heights;
//}

//- (void)configureHeightsArray
//{
//    if (self.heights.count != listArrayWithInfo.count) {
//        [self.heights removeAllObjects];
//        for (int i = 0; i < listArrayWithInfo.count; i++) {
//            NSNumber *height = [[NSNumber alloc] initWithFloat:0];
//            [self.heights addObject:height];
//        }
//    }
//}

#pragma mark - VIEW CONTROLLER LIFECYCLE

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setCascTitle:@"资讯详情"];
        [self setFanhui];
        [self setNeedsPrestrain:TRUE];
        listArrayWithInfo = [NSMutableArray new];
        infoHeader = [[[NSBundle mainBundle] loadNibNamed:@"InfomationForHeader" owner:self options:nil]lastObject];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    sectionHeight = 336;
    if ([self needsPrestrain]) {
        [self loadPrestrainData];
        [self setNeedsPrestrain:FALSE];
    }

    // Register notifications..
    [self registerNotification];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSInteger heght = webView.frame.size.height;
    
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    infoHeader.webViewLaytou.frame = webView.frame;
    infoHeader.webViewHeight.constant = webView.frame.size.height;
    NSInteger infoheight = infoHeader.frame.size.height + (webView.frame.size.height - heght);

    [self.mainTableView beginUpdates];
    sectionHeight = infoheight;
    [self.mainTableView endUpdates];

}

- (void)viewDidDisappear:(BOOL)animated
{
    // Remove notifications..
    [self removeNotificaiton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Request data..
//    [[KHLDataManager instance] informationDetailHUDHolder:self.view identity:self.prestrain.identity type:self.prestrain.category];
    [[KHLDataManager instance] informationDetailHUDHolder:self.view identity:self.prestrain.identity type:@"article"];
     [[KHLDataManager instance] commentlistHUDHolder:self.view model:@"article" zhiboid:self.prestrain.identity];
}

#pragma mark - ABOUT NSNOTIFICATION
-(void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHeightInfo:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(informationDetailNotified:) name:@"KHLNotiInformationDetailAcquired" object:nil];
    //zan
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoZanNotified:) name:@"KHLUrlZanWithModel" object:nil];
    
    //commentlist
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoCommentlistMehod:) name:@"KHLUrlcommentlist" object:nil];
    //评论
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyInfoMethod:) name:@"KHLNotiReplied" object:nil];
    //good
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodInfoNotifiMethod:) name:@"KHLUrlGoodWithComment" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(badInfoNotifiMethod:) name:@"KHLUrlbadWithComment" object:nil];
    //KHLUrlGoodWithComment
}

- (void)removeNotificaiton {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiInformationDetailAcquired" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLUrlcommentlist" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiReplied" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLUrlGoodWithComment" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLUrlbadWithComment" object:nil];
}

#pragma mark - NOTIFICATION METHODES

- (void)informationDetailNotified: (NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    if (!dict) {
        NSLog(@"妈蛋，返回nil了。");
        return;
    }
    
    if ([[dict objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        
        //        NSInteger c = [[dict objectForKey:@"result"] count];
        NSArray *results = [dict objectForKey:@"result"];
        NSDictionary *result = nil;
        if (!results || results.count == 0) {
            NSLog(@"妈蛋，results里没东西。");
            [[[UIAlertView alloc] initWithTitle:@"后台错误" message:@"results为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        } else {
            result = [results firstObject];
            if (!result) {
                NSLog(@"妈蛋，result里没东西。");
                [[[UIAlertView alloc] initWithTitle:@"后台错误" message:@"result为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                return;
            }
        }
        
        self.detail.identity = [NSString stringWithFormat:@"%@", [result objectForKey:@"info_id"]];
        self.detail.category = [NSString stringWithFormat:@"%@", [result objectForKey:@"cate_id"]];
        self.detail.title = [NSString stringWithFormat:@"%@", [result objectForKey:@"title"]];
        self.detail.source = [NSString stringWithFormat:@"%@", [result objectForKey:@"source"]];
        self.detail.imageUrls = [result objectForKey:@"imagelist"];
        self.detail.count = [NSString stringWithFormat:@"%@", [result objectForKey:@"count"]];
        self.detail.publisher = [NSString stringWithFormat:@"%@", [result objectForKey:@"nickname"]];
        self.detail.content = [NSString stringWithFormat:@"%@", [result objectForKey:@"content"]];
        self.detail.time = [NSString stringWithFormat:@"%@", [result objectForKey:@"time"]];
        
        // Refresh with received detail..
        [self loadDetailData];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}
//comment list
- (void)infoCommentlistMehod:(NSNotification *)aNotification {
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
            
            [listArrayWithInfo addObject:commentlist];
        }
//        NSLog(@"comment list frame front %d",sectionHeight);
//        [self configureHeightsArray];
//        [self.mainTableView reloadData];
//        [self configureHeightsArray];
        [self.mainTableView reloadData];
//        NSLog(@"comment list frame blowe %d",sectionHeight);
    }
    
}

//reply
- (void)replyInfoMethod:(NSNotification *)aNotification {
    NSDictionary * aDic = aNotification.object;
    if (aDic == nil) {
        NSLog(@"reply failed");
        return;
    }
    
    if ([[aDic objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUsername"];
        NSString *replyTitle;
//        NSLog(@"othexrUserName  %@",otherUserName);
        if (otherUserName.length == 0) {
            replyTitle = username;
        }else {
            replyTitle = [NSString stringWithFormat:@"%@回复%@",username,otherUserName];
        }
        
        CommentListInterface * commentlist = [CommentListInterface new];
        commentlist.content = self.inputTextFiled.text;
        commentlist.username = replyTitle;
        commentlist.time = @"1234";
        commentlist.countBad = @"0";
        commentlist.countGood = @"0";
        
        [listArrayWithInfo insertObject:commentlist atIndex:0];
//        [self configureHeightsArray];
//        [self.mainTableView reloadData];
//        [self configureHeightsArray];
        [self.mainTableView reloadData];
//        NSLog(@"! DATA RELOAD!!!");
        [self.inputTextFiled resignFirstResponder];
        self.inputTextFiled.text = @"";
        otherUserName = @"";
    }
    
}

- (void)infoZanNotified:(NSNotification *)aNotification
{
    NSDictionary *aDic = aNotification.object;
    if (aDic == nil) {
        NSLog(@"zan for dianbo failed");
    }
}

// good
- (void)goodInfoNotifiMethod:(NSNotification *)aNotification {
    NSDictionary *aDic = aNotification.object;
    if (aDic == nil) {
        NSLog(@"good for dianbo falied");
    }
    
    if ([[aDic objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        //ui数量加1
        CommentListInterface *commentlist = listArrayWithInfo[goodCount];
        NSInteger good = [commentlist.countGood integerValue];
        good ++;
        commentlist.countGood = [NSString stringWithFormat:@"%d",good];
        [listArrayWithInfo replaceObjectAtIndex:goodCount withObject:commentlist];
//        [self configureHeightsArray];
//        [self.mainTableView reloadData];
//        [self configureHeightsArray];
        [self.mainTableView reloadData];
        goodCount = 0;
    } else {
        
        // Failed to post a LIKE action..
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[aDic objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }

}
// bad
-(void)badInfoNotifiMethod:(NSNotification *)aNotification {
    NSDictionary *aDic = aNotification.object;
    if (aDic == nil) {
        NSLog(@"bad for dianbo falied");
    }
    
    if ([[aDic objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        //ui数量加1
        CommentListInterface *commentlist = listArrayWithInfo[goodCount];
        NSInteger good = [commentlist.countBad integerValue];
        good ++;
        commentlist.countBad = [NSString stringWithFormat:@"%d",good];
        [listArrayWithInfo replaceObjectAtIndex:goodCount withObject:commentlist];
//        [self configureHeightsArray];
//        [self.mainTableView reloadData];
//        [self configureHeightsArray];
        [self.mainTableView reloadData];
        goodCount = 0;
    } else {
        
        // Failed to post a DISLIKE action..
        [[[UIAlertView alloc] initWithTitle:@"后台拒绝" message:[aDic objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

#pragma mark - KEYBOARD HEIGHT
- (void)keyboardHeightInfo:(NSNotification *)aNotification {
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
        
        _keyboardHeighAuto.constant = -deltaY;
        
        [self.view updateConstraints];
        
    } completion:^(BOOL finished) {
        
    }];
    
    [CATransaction commit];

}

#pragma mark - CUSTOM LAYOUT METHODES

- (void)loadPrestrainData
{
    infoHeader.titleLabel.text = self.prestrain.title;
    infoHeader.bodyLabel.text = self.prestrain.brief;
}

- (void)loadDetailData
{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *date = [dateFormatter dateFromString:self.detail.time];
//    NSLog(@"time? %@, date? %@", self.detail.time, date);
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *dateString = [dateFormatter stringFromDate:date];
    NSString *dateString = [self.detail.time length] > 10 ? [self.detail.time substringToIndex:10] : @"";
    
    infoHeader.titleLabel.text = [NSString stringWithFormat:@"%@", self.detail.title];
    infoHeader.attachLabel.text = [NSString stringWithFormat:@"来源：%@ 时间：%@ 浏览量：%@ 编辑：%@", self.detail.source, dateString, self.detail.count, self.detail.publisher];
//    self.bodyLabel.text = [NSString stringWithFormat:@"%@", self.detail.content];
//    NSLog(@"content%@",self.detail.content);
    [infoHeader.webViewLaytou loadHTMLString:self.detail.content baseURL:nil];
    infoHeader.commentLabel.text = @"";
    
    if (self.detail.imageUrls && [self.detail.imageUrls isKindOfClass:[NSArray class]] && [self.detail.imageUrls firstObject] && [[self.detail.imageUrls firstObject] isKindOfClass:[NSString class]]) {
        //[self.photoImageView setImageWithURL:[NSURL URLWithString:[self.detail.imageUrls objectAtIndex:0]]];
        BOOL loaded = FALSE;
        for (id item in self.detail.imageUrls) {
            NSLog(@"what is this: %@", item);
            loaded = false;
        }
    } else {
        [infoHeader.photoImageView setImage:[UIImage imageNamed:@"zhibo_huanchongtu@2x.png"]];
    }

}



#pragma mark - BUTTON ACTION METHOD

- (IBAction)backRootMehod:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)showKeyboard:(id)sender {
    if ([KHLColor isLogin]) {
        [self.inputTextFiled becomeFirstResponder];
    } else {
        [self pushLoginVCMethod];
    }
}

- (IBAction)zanMehod:(id)sender {
    if ([KHLColor isLogin]) {
        NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
        NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
        [[KHLDataManager instance] zanHUDHolder:self.view uid:uidStr token:tokenStr info_id:@"45" model:@"article"];
    }else{
        [self pushLoginVCMethod];
    }
    
}

- (IBAction)discussMehod:(id)sender {
    if ([self.inputTextFiled.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }else {
        NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
        NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
        
        //取出点击行的相关信息
        
        NSString * comment_id;
        NSString * modelStr;
        if (self.inputTextFiled.tag == 101) {
            comment_id = self.prestrain.identity;
            modelStr = @"article";
        }else {
            CommentListInterface * commentlist = listArrayWithInfo[self.inputTextFiled.tag];
            otherUserName = commentlist.username;
            comment_id = commentlist.poster;
            modelStr = @"comment";
        }
        [[KHLDataManager instance] replyHUDHolder:self.view uid:uidStr target:comment_id content:self.inputTextFiled.text token:tokenStr targetType:modelStr];
    }

    
}



#pragma mark - UITEXTFILED -DELEGATE -

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UITABLEVIEW-DATASCOUR
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return infoHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    NSLog(@"headerHeight %d",sectionHeight);
    return sectionHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listArrayWithInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableFooterView = [UIView new];
    static NSString *identifier = @"KHLDianboCell";
    
    DianboCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DianboCell" owner:self options:nil]lastObject];
        [cell.huifuMehod addTarget:self action:@selector(pinglunMethondWithBottomBarAndMessage:) forControlEvents:UIControlEventTouchUpInside];
        [cell.jubaoMedhod addTarget:self action:@selector(jubaoMessageMehod:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goodMethod addTarget:self action:@selector(goodMessageMethod:) forControlEvents:UIControlEventTouchUpInside];
        [cell.badMethod addTarget:self action:@selector(badMessageMethod:) forControlEvents:UIControlEventTouchUpInside];
    }
    tableView.tableFooterView = [UIView new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //行号给tag
    cell.huifuMehod.tag = indexPath.row;
    cell.jubaoMedhod.tag = indexPath.row;
    cell.goodMethod.tag = indexPath.row;
    cell.badMethod.tag = indexPath.row;
    
    
    CommentListInterface * commentlist = listArrayWithInfo[indexPath.row];
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
    
//    if ([[self.heights objectAtIndex:indexPath.row] floatValue] > 0) {
//        NSNumber *num = [self.heights objectAtIndex:indexPath.row];
//        num = [NSNumber numberWithFloat:[cell measuremented]];
////        NSLog(@"- EXT - %d : %.2f to %.2f",
////              [indexPath row],
////              [[self.heights objectAtIndex:indexPath.row] floatValue],
////              [num floatValue]);
//        if ([[self.heights objectAtIndex:indexPath.row] floatValue] != [num floatValue]) {
//            [self.heights setObject:num atIndexedSubscript:indexPath.row];
//            [self configureHeightsArray];
//            [self.mainTableView reloadData];
//        }
//    } else {
//        NSNumber *num = [self.heights objectAtIndex:indexPath.row];
//        num = [NSNumber numberWithFloat:[cell measuremented]];
//        [self.heights setObject:num atIndexedSubscript:indexPath.row];
////        NSLog(@"+ CRT - %d : %.2f",
////              [indexPath row],
////              [num floatValue]);
//        if ([num floatValue] == 120.0f) {
//            [self configureHeightsArray];
//            [self.mainTableView reloadData];
//        }
//    }

    return cell;
}

#pragma mark - UITABLVIEW-DELEGATE
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentListInterface* commentlist = listArrayWithInfo[indexPath.row];
    DianboCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DianboCell" owner:self options:nil] lastObject];
    NSString *string = commentlist.content;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.contentLabel.frame.size.width, MAXFLOAT)];
    label.numberOfLines = 0;
    label.font = cell.contentLabel.font;
    
    
//    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:string];
//    NSMutableParagraphStyle *paras = [[NSMutableParagraphStyle alloc] init];
//    [paras setLineSpacing:1.0f];
//    [aString addAttribute:NSParagraphStyleAttributeName value:paras range:NSMakeRange(0, [aString length])];
//    [label setAttributedText:aString];
    
    
    
    
    label.text = string;
    [label sizeToFit];
    CGFloat height = [cell measuremented] - cell.contentLabel.frame.size.height + label.frame.size.height;
    
//    NSLog(@"- %d HEIGHT: %.1f, ACTUAL: %.1f", indexPath.row, height, [[self.heights objectAtIndex:indexPath.row] floatValue]);
    
    
    
    return height;
//    return [[self.heights objectAtIndex:indexPath.row] floatValue] > 0 ? [[self.heights objectAtIndex:indexPath.row] floatValue] : 120;
}

#pragma mark - UITableViewCell Button Method
- (void)pinglunMethondWithBottomBarAndMessage:(UIButton *)sender {
    if ([KHLColor isLogin]) {
        UIButton * btn = (UIButton * )sender;
        self.inputTextFiled.tag =btn.tag;
        [self.inputTextFiled becomeFirstResponder];
    } else {
        [self pushLoginVCMethod];
    }

}

- (void)jubaoMessageMehod:(UIButton *)sender {
    if ([KHLColor isLogin]) {
        JubaoViewController *jubaoVC = [[JubaoViewController alloc] initWithNibName:@"JubaoViewController" bundle:nil];
        CommentListInterface * commentlist = listArrayWithInfo[sender.tag];
        jubaoVC.pinglunId =commentlist.poster;
        [self.navigationController pushViewController:jubaoVC animated:YES];
    } else {
        [self pushLoginVCMethod];
    }
}

- (void)goodMessageMethod:(UIButton *)sender {
    if ([KHLColor isLogin]) {
        NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
        NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
        CommentListInterface * commentlist = listArrayWithInfo[sender.tag];
        goodCount = sender.tag;
        [[KHLDataManager instance] goodHUDHolder:self.view uid:uidStr token:tokenStr comment_id:commentlist.poster];
    } else {
        [self pushLoginVCMethod];
    }

}

-(void)badMessageMethod:(UIButton *)sender {
    if ([KHLColor isLogin]) {
        NSString * uidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIUID"];
        NSString * tokenStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"KHLPIToken"];
        CommentListInterface * commentlist = listArrayWithInfo[sender.tag];
        goodCount = sender.tag;
        [[KHLDataManager instance] badHUDHolder:self.view uid:uidStr token:tokenStr comment_id:commentlist.poster];
    } else {
        [self pushLoginVCMethod];
    }

}
- (void)pushLoginVCMethod {
    
    LoginViewController * loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

-(void)reloadForTableViewWithWebViewHeight:(NSInteger)het {
//    [self configureHeightsArray];
//    [self.mainTableView reloadData];
//    [self configureHeightsArray];
    [self.mainTableView reloadData];
}

@end
