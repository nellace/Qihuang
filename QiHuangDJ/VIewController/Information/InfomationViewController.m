//
//  InfomationViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "InfomationViewController.h"

@interface InfomationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *attachLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (nonatomic, getter=needsPrestrain, setter=setNeedsPrestrain:) BOOL prestrainTag;
@property (nonatomic, strong) InformationDetailInterface *detail;

@end

@implementation InfomationViewController



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



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setCascTitle:@"资讯详情"];
        [self setFanhui];
        [self setNeedsPrestrain:TRUE];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self needsPrestrain]) {
        [self loadPrestrainData];
        [self setNeedsPrestrain:FALSE];
    }
    
    // Register notifications..
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(informationDetailNotified:) name:@"KHLNotiInformationDetailAcquired" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Remove notifications..
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiInformationDetailAcquired" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Request data..
//    [[KHLDataManager instance] informationDetailHUDHolder:self.view identity:self.prestrain.identity type:self.prestrain.category];
    [[KHLDataManager instance] informationDetailHUDHolder:self.view identity:self.prestrain.identity type:@"article"];
}



#pragma mark - CUSTOM LAYOUT METHODES

- (void)loadPrestrainData
{
    self.titleLabel.text = self.prestrain.title;
    self.bodyLabel.text = self.prestrain.brief;
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
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@", self.detail.title];
    self.attachLabel.text = [NSString stringWithFormat:@"来源：%@ 时间：%@ 浏览量：%@ 编辑：%@", self.detail.source, dateString, self.detail.count, self.detail.publisher];
    self.bodyLabel.text = [NSString stringWithFormat:@"%@", self.detail.content];
    self.commentLabel.text = @"";
    
    if (self.detail.imageUrls && [self.detail.imageUrls isKindOfClass:[NSArray class]] && [self.detail.imageUrls firstObject] && [[self.detail.imageUrls firstObject] isKindOfClass:[NSString class]]) {
        //[self.photoImageView setImageWithURL:[NSURL URLWithString:[self.detail.imageUrls objectAtIndex:0]]];
        BOOL loaded = FALSE;
        for (id item in self.detail.imageUrls) {
            NSLog(@"what is this: %@", item);
            loaded = false;
        }
    } else {
        [self.photoImageView setImage:[UIImage imageNamed:@"zhibo_huanchongtu@2x.png"]];
    }
}

- (void)refreshData
{
    NSString *content = @"致身千乘卿相归把钓渔钩春昼五湖烟浪秋夜一天云月此外尽悠悠永弃人间事吾道付沧州";
    NSString *finalContent = @"";
    //NSUInteger i = 2 + arc4random()%5;
    for (int i = 0; i < 5 + 3 * arc4random()%10; i++) {
        finalContent = [NSString stringWithFormat:@"%@%@", finalContent, content];
    }
    
    [self.bodyLabel setText:finalContent];
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











@end
