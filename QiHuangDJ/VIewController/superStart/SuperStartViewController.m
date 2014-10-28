//
//  SuperStartViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "SuperStartViewController.h"
#import "KHLColor.h"
#import "AFNetworking.h"
#import "KHLEntertainerHolderView.h"

@interface SuperStartViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *entertainerScrollView;
@property (nonatomic) CGFloat controllableWidth;
@property (nonatomic) CGFloat controllableHeight;
@property (nonatomic, strong) NSMutableArray *entertainers;
@end

@implementation SuperStartViewController {
    
}

#define BASIC_LINE_HEIGHT 35
#define BASIC_DIVIDER_HEIGHT 1



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.entertainerScrollView setBackgroundColor:[KHLColor tubai]];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Draw navigation bar..
    [self setCascTitle:@"七煌艺人"];
    [self setFanhui];
    
    // Config attributes..
    [self setControllableWidth:self.entertainerScrollView.frame.size.width];
    [self setControllableHeight:self.entertainerScrollView.frame.size.height];
    //[self refreshEntertainersScrollView];
    
    // Register notification..
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(entertainersListNotified:) name:@"KHLNotiEntertainersAcquired" object:nil];
    
    // Init actions..
    [[KHLDataManager instance] entertainersListHUDHolder:self.view];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Remove notification..
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiEntertainersAcquired" object:nil];
}



#pragma mark - ATTRIBUTES GETTER AND SETTER

- (NSMutableArray *)entertainers
{
    if (!_entertainers) _entertainers = [[NSMutableArray alloc] init];
    return _entertainers;
}



#pragma mark - CUSTOM LAYOUT METHODES

- (void)refreshEntertainersScrollView
{
    for (UIView *subview in [self.entertainerScrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    if (self.entertainers.count == 0)
        self.entertainers = [[self MakeSimulateEntertainersWithCapacity:1] mutableCopy];
    for (int i = 0; i < [self.entertainers count]; i++) {
        KHLEntertainerHolderView * holder = [[[NSBundle mainBundle] loadNibNamed:@"KHLEntertainerHolderView" owner:self options:nil] firstObject];
        [holder setFrame:CGRectMake(i * self.controllableWidth, 0, self.controllableWidth, self.controllableHeight)];
        [holder loadData:self.entertainers[i] useWindowSize:self.view.frame.size];
        [self.entertainerScrollView addSubview:holder];
    }
    
    [self.entertainerScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.entertainerScrollView setContentSize:CGSizeMake(self.controllableWidth * [self.entertainers count], 0)];
}



#pragma mark - NOTIFICATION METHODES

- (void)entertainersListNotified: (NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    if (!dict) {
        NSLog(@"妈蛋，返回nil了。");
        return;
    }
    
    if ([[dict objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        [self.entertainers removeAllObjects];
        for (NSDictionary *result in [dict objectForKey:@"result"]) {
            EntertainersListInterface *interface = [[EntertainersListInterface alloc] init];
            interface.imageUrl = [NSString stringWithFormat:@"%@", [result objectForKey:@"images"]];
            interface.nickname = [NSString stringWithFormat:@"%@", [result objectForKey:@"name"]];
            interface.programme = [NSString stringWithFormat:@"%@", [result objectForKey:@"show"]];
            interface.experience = [NSString stringWithFormat:@"%@", [result objectForKey:@"content"]];
            [self.entertainers addObject:interface];
        }
        
        // Refresh list layout after data received..
        [self refreshEntertainersScrollView];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"后台出错" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}



#pragma mark - DEBUG METHODES

- (NSArray *)MakeSimulateEntertainersWithCapacity: (NSUInteger)capacity
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:capacity];
    for (int i = 0; i < capacity; i++) {
        EntertainersListInterface *entertainer = [[EntertainersListInterface alloc] init];
        switch (i % 3) {
            case 0:
                entertainer.imageUrl = @"http://wd600.10yan.com/uploadfile/2012/0518/20120518105444247.jpg";
                entertainer.nickname = @"徐振之";
                entertainer.programme = @"徐霞客游记";
                entertainer.experience = @"我药当大侠！";
                break;
                
            case 1:
                entertainer.imageUrl = @"http://c.hiphotos.baidu.com/baike/w%3D268/sign=2dd016050a46f21fc9345955ce256b31/b3119313b07eca809f226119912397dda144832d.jpg";
                entertainer.nickname = @"朱权";
                entertainer.programme = @"飞瀑连珠";
                entertainer.experience = @"宁子飞瀑，衡子遗音，益子韵磬，潞子中和。复养和，宣和，汉鸾，绕梁，号钟，列子，仲尼，此君，竹节，师旷诸式。";
                break;
                
            case 2:
                // test: 约当15世纪之末，有一位中国明代的官吏叫万户，他在一把座椅的背后，装上47枚当时可能买到的最大火箭。他把自己捆绑在椅子的前边，两只手各拿一个大风筝。然后叫他的仆人同时点燃47枚大火箭，其目的是想借火箭向前推进的力量，加上风筝上升的力量飞向前方。——《Rockets and Jets》by Herbert S. Zim, 1945, America
                entertainer.imageUrl = @"http://imgsrc.baidu.com/baike/pic/item/bd7042604bfa568a8db10d8c.jpg";
                entertainer.nickname = @"万户";
                entertainer.programme = @"火箭飞天试验";
                entertainer.experience = @"……同时点燃47枚大火箭，其目的是想借火箭向前推进的力量，加上风筝上升的力量飞向前方…………同时点燃47枚大火箭，其目的是想借火箭向前推进的力量，加上风筝上升的力量飞向前方…………同时点燃47枚大火箭，其目的是想借火箭向前推进的力量，加上风筝上升的力量飞向前方…………同时点燃47枚大火箭，其目的是想借火箭向前推进的力量，加上风筝上升的力量飞向前方…………同时点燃47枚大火箭，其目的是想借火箭向前推进的力量，加上风筝上升的力量飞向前方……";
                break;
                
            default:
                break;
        }
        [array addObject:entertainer];
    }
    
    return [array copy];
}

@end
