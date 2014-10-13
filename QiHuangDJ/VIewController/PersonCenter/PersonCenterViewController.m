//
//  PersonCenterViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "KHLColor.h"
#import "KHLRecommendedCollectionViewCell.h"
#import "LoginViewController.h"

@interface PersonCenterViewController () <LoginDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *pageHolder;
@property (weak, nonatomic) IBOutlet UIView *thumbHolder;
@property (weak, nonatomic) IBOutlet UIView *buttonHolder;
@property (weak, nonatomic) IBOutlet UIView *contentHolder;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIButton *myCollectionButton;
@property (weak, nonatomic) IBOutlet UIButton *mySubscriptionButton;
@property (weak, nonatomic) IBOutlet UICollectionView *recommendedCollectionView;
@property (nonatomic, setter = setLogIn:, getter = isLogIn) BOOL bLogIn;
@property (nonatomic) NSUInteger templateUsingState; // 1 for collection, 2 for subscription, 0 or else for unlogged..
@property (nonatomic) CGFloat contentFrameHeight;
@property (strong, nonatomic) UIView *buttonIndicatorView;
@property (strong, nonatomic) NSArray *items;
@end

@implementation PersonCenterViewController

#define COMMON_ITEM_DIVIDER_HEIGHT (2.0f)

#define RECOMMENDED_ITEM_PROPORTION (200.0f / 315.0f)
#define RECOMMENDED_ITEM_SPACING (5.0f)
#define RECOMMENDED_ITEM_TEXT_VIEW_PROPORTION (60.0f / 200.0f)

#define SUBSCRIBED_ITEM_IMAGE_OCCUPANCY (235.0f / 640.0f)
#define SUBSCRIBED_ITEM_PROPORTION (180.0f / 640.0f)
#define SUBSCRIBED_ITEM_TEXT_PROPORTION (130.0f / 180.0f)
#define SUBSCRIBED_ITEM_DIVIDER_HEIGHT (1.0f)
#define SUBSCRIBED_ITEM_TEXT_PADDING (6.0f)



#pragma mark VIEW CONTROLLER LIFECYCLE

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
    [self.myCollectionButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.mySubscriptionButton setTitleColor:[KHLColor shiqing] forState:UIControlStateNormal];
    self.buttonIndicatorView = [[UIView alloc] init];
    [self.buttonIndicatorView setBackgroundColor:[UIColor orangeColor]];
    [self.buttonIndicatorView setFrame:CGRectMake(0, self.buttonHolder.frame.size.height - COMMON_ITEM_DIVIDER_HEIGHT, self.view.frame.size.width / 2, COMMON_ITEM_DIVIDER_HEIGHT)];
    UIView *buttonDivider = [[UIView alloc] initWithFrame:CGRectMake(0, self.buttonHolder.frame.size.height - COMMON_ITEM_DIVIDER_HEIGHT, self.view.frame.size.width, COMMON_ITEM_DIVIDER_HEIGHT)];
    [buttonDivider setBackgroundColor:[KHLColor shiqing]];
    [self.buttonHolder addSubview:buttonDivider];
    [self.buttonHolder addSubview:self.buttonIndicatorView];
    
    // Enable press gesture for thumb image view..
    UITapGestureRecognizer *pressThumbImageViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressThumbImageView)];
    [self.thumbImageView setUserInteractionEnabled:TRUE];
    [self.thumbImageView addGestureRecognizer:pressThumbImageViewGesture];
}


-(void)viewDidLoad {
    [self.recommendedCollectionView registerClass:[KHLRecommendedCollectionViewCell class] forCellWithReuseIdentifier:@"KHLRecommendedCollectionViewCell"];

}

//- (void)viewWillLayoutSubviews
//{
//    NSLog(@"View will layout subviews");
//    [self refreshButtonHolder];
//    [self refreshThumbImageViewWithPersonalInfomation:nil];
//    [self refreshContentScrollViewWithData:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8"]];
//}

- (void)viewDidLayoutSubviews
{
    [self refreshButtonHolder];
    [self refreshThumbImageViewWithPersonalInfomation:nil];
    [self refreshContentScrollViewWithData:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8"]];
    //[self refreshContentViewWithData:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ATTRIBUTES GETTER AND SETTER

- (void)setLogIn:(BOOL)bLogIn
{
//    [[NSUserDefaults standardUserDefaults] setBool:_bLogIn forKey:@"isLogin"];
//    [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    _bLogIn = bLogIn;
    if (bLogIn) {
        //        [self.myCollectionButton setEnabled:TRUE];
        //        [self.mySubscriptionButton setEnabled:TRUE];
    } else {
        //        [self.myCollectionButton setEnabled:FALSE];
        //        [self.mySubscriptionButton setEnabled:FALSE];
        self.templateUsingState = 0;
    }
}

- (NSArray *)items
{
    if (!_items) _items = [[NSArray alloc] init];
    return _items;
}



#pragma mark LAYOUT CUSTOM METHODES

// Refresh my collections and subscriptions button..
- (void)refreshButtonHolder
{
    
    if (self.templateUsingState == 1) {
        [UIView animateWithDuration:0.5f animations:^(void) {
            //NSLog(@"animation start");
            [self.buttonIndicatorView setFrame:CGRectMake(0, self.buttonHolder.frame.size.height - COMMON_ITEM_DIVIDER_HEIGHT, self.view.frame.size.width / 2, COMMON_ITEM_DIVIDER_HEIGHT)];
        } completion:^(BOOL finished) {
            //NSLog(@"animation end: %d", finished);
        }];
    }
    
    else if (self.templateUsingState == 2) {
        [UIView animateWithDuration:0.5f animations:^(void) {
            //NSLog(@"animation start");
            [self.buttonIndicatorView setFrame:CGRectMake(self.view.frame.size.width / 2, self.buttonHolder.frame.size.height - COMMON_ITEM_DIVIDER_HEIGHT, self.view.frame.size.width / 2, COMMON_ITEM_DIVIDER_HEIGHT)];
        } completion:^(BOOL finished) {
            //NSLog(@"animation end: %d", finished);
        }];
    }
    
    //NSLog(@"Indicator (%.0f/%.0f/%.0f/%.0f)", self.buttonIndicatorView.frame.origin.x, self.buttonIndicatorView.frame.origin.y, self.buttonIndicatorView.frame.size.width, self.buttonIndicatorView.frame.size.height);
}

// Refresh and cut thumb image view to circle and add a white bound..
- (void)refreshThumbImageViewWithPersonalInfomation:(id)personale
{
    UIImage *thumbImage = nil;
    
    // Logged In Template
    if ([self isLogIn]) {
        // use thumb url to fill thumb image
        thumbImage = [UIImage imageNamed:@"tzelann"];
        self.nicknameLabel.text = @"图开门啊图开门";
    }
    
    // Recommended Template
    else {
        thumbImage = [UIImage imageNamed:@"tzelann_logout"];
        self.nicknameLabel.text = @"图图图未登录";
    }
    
    // Configure the thumb image view to bounded circle style..
    self.thumbImageView.layer.cornerRadius = self.thumbImageView.frame.size.height/2;
    self.thumbImageView.layer.masksToBounds = TRUE;
    self.thumbImageView.layer.borderWidth = 2;
    self.thumbImageView.layer.borderColor = [[KHLColor tubai] CGColor];
    self.thumbImageView.layer.contents = (id)[thumbImage CGImage];
    
//    UIButton *thumbViewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.thumbImageView.frame.size.width, self.thumbImageView.frame.size.height)];
//    [thumbViewButton addTarget:self action:@selector(pressThumbImageView) forControlEvents:UIControlEventTouchUpInside];
//    [self.thumbImageView addSubview:thumbViewButton];

    
}

// Refresh content scroll view..
- (void)refreshContentScrollViewWithData:(NSArray *)videoItems
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
        
        // Calculate subscribed item frame size for template..
        CGFloat subscribedItemWidth = self.view.frame.size.width;
        CGFloat subscribedItemHeight = subscribedItemWidth * SUBSCRIBED_ITEM_PROPORTION;
        CGFloat subscribedImageWidth = subscribedItemWidth * SUBSCRIBED_ITEM_IMAGE_OCCUPANCY;
        CGFloat subscribedTextWidth = subscribedItemWidth - subscribedImageWidth - 2 * SUBSCRIBED_ITEM_TEXT_PADDING;
        CGFloat subscribedTextHeight = subscribedItemHeight * SUBSCRIBED_ITEM_TEXT_PROPORTION;
        
        // Calculate content holder frame height..
        self.contentFrameHeight = [videoItems count] * (subscribedItemHeight + SUBSCRIBED_ITEM_DIVIDER_HEIGHT) - SUBSCRIBED_ITEM_DIVIDER_HEIGHT;
        //NSLog(@"Single Item Height: %.0f", subscribedItemHeight);
        //NSLog(@"Content Frame Height: %.0f", self.contentFrameHeight);
        if (self.contentFrameHeight > self.contentHolder.frame.size.height) {
            [self.contentHolder setFrame:CGRectMake(self.contentHolder.frame.origin.x, self.contentHolder.frame.origin.y, self.contentHolder.frame.size.width, self.contentFrameHeight)];
        }
        
        for (int i = 0; i < [videoItems count]; i++) {
            
            // Calculate font size depending on screen size..
            CGFloat majorFontSize = 14.0f / 320.0f * self.view.frame.size.width;
            CGFloat minorFontSize = 11.0f / 320.0f * self.view.frame.size.width;
            UIFont *usedFont = [UIFont systemFontOfSize:majorFontSize];
            UIFont *usedMinorFont = [UIFont systemFontOfSize:minorFontSize];
            
            // Create UI Views for a single video item..
            UIView *videoItemHolder = [[UIView alloc] initWithFrame:CGRectMake(0, currentHeight, subscribedItemWidth, subscribedItemHeight)];
            UIImageView *videoItemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, subscribedImageWidth, subscribedItemHeight)];
            UILabel *videoItemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(subscribedImageWidth + SUBSCRIBED_ITEM_TEXT_PADDING, 0, subscribedTextWidth, subscribedTextHeight)];
            UILabel *videoItemBrowseCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(subscribedImageWidth + SUBSCRIBED_ITEM_TEXT_PADDING, subscribedTextHeight + SUBSCRIBED_ITEM_TEXT_PADDING, subscribedTextWidth - 2 * SUBSCRIBED_ITEM_TEXT_PADDING, subscribedItemHeight - subscribedTextHeight - SUBSCRIBED_ITEM_TEXT_PADDING)];
            UILabel *videoItemPublishDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(subscribedImageWidth + SUBSCRIBED_ITEM_TEXT_PADDING, subscribedTextHeight + SUBSCRIBED_ITEM_TEXT_PADDING, subscribedTextWidth - 2 * SUBSCRIBED_ITEM_TEXT_PADDING, subscribedItemHeight - subscribedTextHeight - SUBSCRIBED_ITEM_TEXT_PADDING)];

            // Configure holder..
            [videoItemHolder setBackgroundColor:[UIColor whiteColor]];
            
            // Configure image view..
            UIImage *videoImage = [[UIImage alloc] init];
            if (i % 3 == 0) videoImage = [UIImage imageNamed:@"mings-cavalry-anti-japanese-samurai"];
            if (i % 3 == 1) videoImage = [UIImage imageNamed:@"mings-student-on-journey"];
            if (i % 3 == 2) videoImage = [UIImage imageNamed:@"mings-ships-sailing"];
            [videoItemImageView setImage:videoImage];
            
            // Configure video title label..
            NSString *description = @"霓为衣兮风为马。";
            if (i % 3 == 0) description = @"绛罗朱袖起飞云，大武明华瞰雄州。";
            if (i % 3 == 1) description = @"离绪悄微弦，永夜清霜透幕帘。明日回头江树远，怀贤。目断晴空雁字连。离绪悄微弦，永夜清霜透幕帘。明日回头江树远，怀贤。目断晴空雁字连。";
            CGRect standardizedRect = [description boundingRectWithSize:CGSizeMake(subscribedTextWidth, MAXFLOAT)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:usedFont}
                                                                context:nil];
            [videoItemTitleLabel setText:description];
            [videoItemTitleLabel setTextColor:[UIColor blackColor]];
            [videoItemTitleLabel setFont:usedFont];
            if (standardizedRect.size.height > subscribedTextHeight) {
                //standardizedRect.size.height = subscribedTextHeight;
                standardizedRect.size.height = 3 * [[NSString stringWithFormat:@"明"] boundingRectWithSize:CGSizeMake(subscribedTextWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:usedFont} context:nil].size.height;
            }
            standardizedRect.origin.y = SUBSCRIBED_ITEM_TEXT_PADDING;
            standardizedRect.origin.x = videoItemTitleLabel.frame.origin.x;
            [videoItemTitleLabel setFrame:standardizedRect];
            [videoItemTitleLabel setNumberOfLines:3];
            [videoItemTitleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            [videoItemTitleLabel setTextAlignment:NSTextAlignmentNatural];
            
            // Configure browse count label..
            [videoItemBrowseCountLabel setText:@"浏览量：17"];
            [videoItemBrowseCountLabel setTextColor:[UIColor blackColor]];
            [videoItemBrowseCountLabel setFont:usedMinorFont];
            [videoItemBrowseCountLabel setNumberOfLines:1];
            [videoItemPublishDateLabel setTextAlignment:NSTextAlignmentLeft];
            
            // Configure publish date label..
            [videoItemPublishDateLabel setText:@"1532-05-21"];
            [videoItemPublishDateLabel setTextColor:[UIColor blackColor]];
            [videoItemPublishDateLabel setFont:usedMinorFont];
            [videoItemPublishDateLabel setNumberOfLines:1];
            [videoItemPublishDateLabel setTextAlignment:NSTextAlignmentRight];
            
            // Add views to single item holder and insert it to content holder..
            [videoItemHolder addSubview:videoItemImageView];
            [videoItemHolder addSubview:videoItemTitleLabel];
            [videoItemHolder addSubview:videoItemBrowseCountLabel];
            [videoItemHolder addSubview:videoItemPublishDateLabel];
            [self.contentHolder addSubview:videoItemHolder];
            currentHeight += subscribedItemHeight;
            
            // Draw list divider..
            if (i != [videoItems count] - 1) {
                UIView *videoItemListDivider = [[UIView alloc] initWithFrame:CGRectMake(0, currentHeight, subscribedItemWidth, SUBSCRIBED_ITEM_DIVIDER_HEIGHT)];
                [videoItemListDivider setBackgroundColor:[KHLColor tubai]];
                [self.contentHolder addSubview:videoItemListDivider];
                currentHeight += SUBSCRIBED_ITEM_DIVIDER_HEIGHT;
            }
        }
        
    }
    
    // Recommended Template
    else {
        
        // Calculate recommended item frame size for template..
        CGFloat recommendedItemWidth = (self.view.frame.size.width - RECOMMENDED_ITEM_SPACING) / 2;
        CGFloat recommendedItemHeight = recommendedItemWidth * RECOMMENDED_ITEM_PROPORTION;
        //NSLog(@"RECOMMEND size(%.2f/%.2f)", recommendedItemWidth, recommendedItemHeight);
        
        // Calculate content holder frame height..
        self.contentFrameHeight = ([videoItems count] + 1)/2 * (recommendedItemHeight + RECOMMENDED_ITEM_SPACING);
        //NSLog(@"Content Frame Height: %.0f", self.contentFrameHeight);
        if (self.contentFrameHeight > self.contentHolder.frame.size.height) {
            [self.contentHolder setFrame:CGRectMake(self.contentHolder.frame.origin.x, self.contentHolder.frame.origin.y, self.contentHolder.frame.size.width, self.contentFrameHeight)];
        }
        
        for (int i = 0; i < [videoItems count]; i++) {
            CGFloat horizontalOriginX = i%2 == 0 ? 0 : recommendedItemWidth + RECOMMENDED_ITEM_SPACING;
            CGFloat textHeight = recommendedItemHeight * RECOMMENDED_ITEM_TEXT_VIEW_PROPORTION;
            
            // Create UI views for a single video item..
            UIView *videoItemHolder = [[UIView alloc] initWithFrame:CGRectMake(horizontalOriginX, currentHeight, recommendedItemWidth, recommendedItemHeight)];
            UIImageView *videoItemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, recommendedItemWidth, recommendedItemHeight)];
            UILabel * videoItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, recommendedItemHeight - textHeight, recommendedItemWidth, textHeight)];
            
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
            
            if (horizontalOriginX) currentHeight += recommendedItemHeight + RECOMMENDED_ITEM_SPACING;
        }
        
        //UIScrollView *recommendScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.contentHolder.frame.size.width, self.contentHolder.frame.size.height)];
        //self.contentHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    //NSLog(@"CONTENT HOLDER frame(%.0f/%.0f/%.0f/%.0f)", self.contentHolder.frame.origin.x, self.contentHolder.frame.origin.y, self.contentHolder.frame.size.width, self.contentHolder.frame.size.height);
    
    
    [self.pageHolder setContentSize:CGSizeMake(self.pageHolder.frame.size.width, self.thumbHolder.frame.size.height + self.buttonHolder.frame.size.height + self.contentHolder.frame.size.height)];
    [self.pageHolder setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)refreshContentViewWithData: (NSArray *)items
{
    [self.recommendedCollectionView setBackgroundColor:[UIColor clearColor]];
    //[self.contentHolder setBackgroundColor:[UIColor greenColor]];
    //[self.pageHolder setBackgroundColor:[UIColor brownColor]];
    //NSLog(@"== START REQUESTING REFRESH %d", [self.items count]);
    self.items = items;
    [self.recommendedCollectionView setFrame:CGRectMake(self.recommendedCollectionView.frame.origin.x, self.recommendedCollectionView.frame.origin.y, self.recommendedCollectionView.frame.size.width, 600)];
    [self.recommendedCollectionView setContentSize:CGSizeMake(self.recommendedCollectionView.frame.size.width, self.recommendedCollectionView.frame.size.height)];
    [self.contentHolder setFrame:CGRectMake(self.contentHolder.frame.origin.x, self.contentHolder.frame.origin.y, self.contentHolder.frame.size.width, self.recommendedCollectionView.frame.size.height)];
    [self.pageHolder setContentSize:CGSizeMake(self.pageHolder.frame.size.width, self.thumbHolder.frame.size.height + self.buttonHolder.frame.size.height + self.contentHolder.frame.size.height)];
    [self.pageHolder setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.recommendedCollectionView registerClass:[KHLRecommendedCollectionViewCell class] forCellWithReuseIdentifier:@"KHLRecommendedCollectionViewCell"];
    [self.recommendedCollectionView reloadData];
    
//    NSLog(@"- PagH (%.0f,%.0f) [%.0f x %.0f] <%.0f x %.0f>", self.pageHolder.frame.origin.x, self.pageHolder.frame.origin.y, self.pageHolder.frame.size.width, self.pageHolder.frame.size.height, self.pageHolder.contentSize.width, self.pageHolder.contentSize.height);
//    NSLog(@"- - ConH (%.0f,%.0f) [%.0f x %.0f]", self.contentHolder.frame.origin.x, self.contentHolder.frame.origin.y, self.contentHolder.frame.size.width, self.contentHolder.frame.size.height);
//    NSLog(@"- - - RecH (%.0f,%.0f) [%.0f x %.0f] <%.0f x %.0f>", self.recommendedCollectionView.frame.origin.x, self.recommendedCollectionView.frame.origin.y, self.recommendedCollectionView.frame.size.width, self.recommendedCollectionView.frame.size.height, self.recommendedCollectionView.contentSize.width, self.recommendedCollectionView.contentSize.height);
    
    //NSLog(@"== END REQUESTING REFRESH %d", [self.items count]);
    
}



#pragma mark USER INTERACTION RESPONSE

- (void)pressThumbImageView
{
//    [self setLogIn:!self.isLogIn];
//    [self refreshThumbImageViewWithPersonalInfomation:nil];
//    [self refreshContentScrollViewWithData:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8"]];
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    loginViewController.delegate = self;
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (IBAction)pressMyCollection:(UIButton *)sender
{
    NSLog(@"pressMyCollection");
    
    self.templateUsingState = 1;
    [self.myCollectionButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.mySubscriptionButton setTitleColor:[KHLColor shiqing] forState:UIControlStateNormal];
    [self refreshButtonHolder];
}

- (IBAction)pressMySubscription:(UIButton *)sender
{
    NSLog(@"pressMySubscription");
    self.templateUsingState = 2;
    [self.myCollectionButton setTitleColor:[KHLColor shiqing] forState:UIControlStateNormal];
    [self.mySubscriptionButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self refreshButtonHolder];
}

- (void)onLoginSuccess
{
    NSLog(@"onLoginSuccess Implementation");
    [self setLogIn:TRUE];
    [self refreshThumbImageViewWithPersonalInfomation:nil];
    [self refreshContentScrollViewWithData:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8"]];
}

-(void)onLoginFailed
{
    NSLog(@"onLoginFailed Implementation");
    [self setLogIn:FALSE];
    [self refreshThumbImageViewWithPersonalInfomation:nil];
    [self refreshContentScrollViewWithData:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8"]];
}



#pragma mark COLLECTION VIEW PROTOCOL

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //NSLog(@"== REQUESTING ROW COUNT: %d", [self.items count]);
    return [self.items count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KHLRecommendedCollectionViewCell *recommendedCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KHLRecommendedCollectionViewCell" forIndexPath:indexPath];
    if (recommendedCollectionCell == nil) {
        recommendedCollectionCell = [[[NSBundle mainBundle] loadNibNamed:@"KHLRecommendedCollectionViewCell" owner:self options:nil] lastObject];
    }
    
    //NSLog(@"== REQUESTING CELL section: %d, row: %d", indexPath.section, indexPath.row);
    
    switch (indexPath.row % 3) {
        case 0:
            [recommendedCollectionCell.thumbImageView setImage:[UIImage imageNamed:@"mings-cavalry-anti-japanese-samurai"]];
            break;
            
        case 1:
            [recommendedCollectionCell.thumbImageView setImage:[UIImage imageNamed:@"mings-ships-sailing"]];
            break;
            
        case 2:
            [recommendedCollectionCell.thumbImageView setImage:[UIImage imageNamed:@"mings-student-on-journey"]];
            break;
            
        default:
            break;
    }
    
    return recommendedCollectionCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.delegate = self;
    [self presentViewController:loginVC animated:YES completion:nil];
    
//    NSLog(@"RecH (%.0f,%.0f) [%.0f x %.0f] <%.0f x %.0f>", self.recommendedCollectionView.frame.origin.x, self.recommendedCollectionView.frame.origin.y, self.recommendedCollectionView.frame.size.width, self.recommendedCollectionView.frame.size.height, self.recommendedCollectionView.contentSize.width, self.recommendedCollectionView.contentSize.height);
//    NSLog(@"ConH (%.0f,%.0f) [%.0f x %.0f]", self.contentHolder.frame.origin.x, self.contentHolder.frame.origin.y, self.contentHolder.frame.size.width, self.contentHolder.frame.size.height);
//    NSLog(@"PagH (%.0f,%.0f) [%.0f x %.0f] <%.0f x %.0f>", self.pageHolder.frame.origin.x, self.pageHolder.frame.origin.y, self.pageHolder.frame.size.width, self.pageHolder.frame.size.height, self.pageHolder.contentSize.width, self.pageHolder.contentSize.height);
}

@end
