//
//  PersonCenterViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "KHLColor.h"

@interface PersonCenterViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *pageHolder;
@property (weak, nonatomic) IBOutlet UIView *thumbHolder;
@property (weak, nonatomic) IBOutlet UIView *buttonHolder;
@property (weak, nonatomic) IBOutlet UIView *contentHolder;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (nonatomic, setter = setLogIn:, getter = isLogIn) BOOL bLogIn;
@property (nonatomic) CGFloat contentFrameHeight;
@end

@implementation PersonCenterViewController

#define RECOMMEND_ITEM_PROPORTION (200.0f / 315.0f)
#define RECOMMEND_ITEM_SPACING (5.0f)
#define RECOMMEND_ITEM_TEXT_VIEW_PROPORTION (60.0f / 200.0f)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setFanhui];
        [self setLogIn:FALSE];
    } return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Set background image for base view..
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bg@2x.png"]]];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Refresh view details depending on received data..
    [self refreshThumbImageViewWithUrl:nil];
//    [self refreshContentScrollViewWithData:@[@"0", @"1", @"2", @"3", @"4"]];
}

// Refresh and cut thumb image view to circle and add a white bound..
- (void)refreshThumbImageViewWithUrl: (id)personale
{
    UIImage *thumbImage = nil;
    
    // Logged In Template
    if ([self isLogIn]) {
        // use thumb url to fill thumb image
    }
    
    // Recommend Template
    else {
        thumbImage = [UIImage imageNamed:@"tzelann"];
        self.nicknameLabel.text = @"图图图未登录";
    }
    
    // Configure the thumb image view to bounded circle style..
    self.thumbImageView.layer.cornerRadius = self.thumbImageView.frame.size.height/2;
    self.thumbImageView.layer.masksToBounds = TRUE;
    self.thumbImageView.layer.borderWidth = 2;
    self.thumbImageView.layer.borderColor = [[KHLColor tubai] CGColor];
    self.thumbImageView.layer.contents = (id)[thumbImage CGImage];
}

// Refresh content scroll view..
- (void)refreshContentScrollViewWithData: (NSArray *)videoItems
{
    // Clear content holder..
    for (UIView *view in [self.contentHolder subviews]) {
        [view removeFromSuperview];
    }
    
    // Current used height
    CGFloat currentHeight = 0;
    
//    // A Testing Line
//    UIView *aLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentHolder.frame.size.width, 1)];
//    [aLine setBackgroundColor:[KHLColor shiqing]];
//    [self.contentHolder addSubview:aLine];
//    currentHeight += aLine.frame.size.height;
    
    // Logged In Template
    if ([self isLogIn]) {
        
        // Calculate content holder frame height..
        
    }
    
    // Recommend Template
    else {
        
        // Calculate recommend item width for recommend template..
        CGFloat recommendItemWidth = (self.view.frame.size.width - RECOMMEND_ITEM_SPACING) / 2;
        CGFloat recommendItemHeight = recommendItemWidth * RECOMMEND_ITEM_PROPORTION;
        NSLog(@"RECOMMEND size(%.2f/%.2f)", recommendItemWidth, recommendItemHeight);
        
        // Calculate content holder frame height..
        self.contentFrameHeight = ([videoItems count] + 1)/2 * (recommendItemHeight + RECOMMEND_ITEM_SPACING);
        NSLog(@"Content Frame Height: %.0f", self.contentFrameHeight);
        if (self.contentFrameHeight > self.contentHolder.frame.size.height) {
            [self.contentHolder setFrame:CGRectMake(self.contentHolder.frame.origin.x, self.contentHolder.frame.origin.y, self.contentHolder.frame.size.width, self.contentFrameHeight)];
        }
        
        for (int i = 0; i < [videoItems count]; i++) {
            CGFloat horizontalOriginX = i%2 == 0 ? 0 : recommendItemWidth + RECOMMEND_ITEM_SPACING;
            CGFloat textHeight = recommendItemHeight * RECOMMEND_ITEM_TEXT_VIEW_PROPORTION;
            
            // Create UI views for a single video item..
            UIView *videoItemHolder = [[UIView alloc] initWithFrame:CGRectMake(horizontalOriginX, currentHeight, recommendItemWidth, recommendItemHeight)];
            UIImageView *videoItemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, recommendItemWidth, recommendItemHeight)];
            UILabel * videoItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, recommendItemHeight - textHeight, recommendItemWidth, textHeight)];
            
            // Acquire image from url to fill the image view and do configurations..
            UIImage *videoImage = [[UIImage alloc] init];
            if (i % 3 == 0) videoImage = [UIImage imageNamed:@"mings-cavalry-anti-japanese-samurai"];
            if (i % 3 == 1) videoImage = [UIImage imageNamed:@"mings-student-on-journey"];
            if (i % 3 == 2) videoImage = [UIImage imageNamed:@"mings-ships-sailing"];
            [videoItemImageView setImage:videoImage];
            
            // Set label text to video description and do configurations..
            NSString *description = @"霓为衣兮风为马。";
            if (i % 3 == 0) description = @"绛罗朱袖起飞云，大武明华瞰雄州。";
            if (i % 3 == 1) description = @"离绪悄微弦，永夜清霜透幕帘。明日回头江树远，怀贤。目断晴空雁字连。";
            [videoItemLabel setText:description];
            [videoItemLabel setFont:[UIFont systemFontOfSize:12]];
            [videoItemLabel setBackgroundColor:[UIColor whiteColor]];
            [videoItemLabel setTextColor:[UIColor blackColor]];
            [videoItemLabel setNumberOfLines:2];
            [videoItemLabel setAlpha:0.75];
            //[videoItemLabel setTextAlignment:NSTextAlignmentLeft];
            //[videoItemLabel setContentMode:UIViewContentModeBottomLeft];
            
            // Add views to single item holder and insert it to content holder..
            [videoItemHolder addSubview:videoItemImageView];
            [videoItemHolder addSubview:videoItemLabel];
            [self.contentHolder addSubview:videoItemHolder];
            
            if (horizontalOriginX) currentHeight += recommendItemHeight + RECOMMEND_ITEM_SPACING;
        }
        
        
//        if (self.contentFrameHeight > self.contentHolder.frame.size.height) {
//            [self.contentHolder setFrame:CGRectMake(self.contentHolder.frame.origin.x, self.contentHolder.frame.origin.y, self.contentHolder.frame.size.width, self.contentFrameHeight)];
//        }
        
        NSLog(@"CONTENT HOLDER frame(%.0f/%.0f/%.0f/%.0f)", self.contentHolder.frame.origin.x, self.contentHolder.frame.origin.y, self.contentHolder.frame.size.width, self.contentHolder.frame.size.height);
        
        
        [self.pageHolder setContentSize:CGSizeMake(self.pageHolder.frame.size.width, self.thumbHolder.frame.size.height + self.buttonHolder.frame.size.height + self.contentHolder.frame.size.height)];
        [self.pageHolder setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        NSLog(@"PAGE frame(%.0f/%.0f) content(%.0f/%.0f)", self.pageHolder.frame.size.width, self.pageHolder.frame.size.height, self.pageHolder.contentSize.width, self.pageHolder.contentSize.height);
        
        //UIScrollView *recommendScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.contentHolder.frame.size.width, self.contentHolder.frame.size.height)];
        //self.contentHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
}

- (void)viewDidLayoutSubviews
{
    [self refreshContentScrollViewWithData:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
