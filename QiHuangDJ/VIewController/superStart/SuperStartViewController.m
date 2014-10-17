//
//  SuperStartViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "SuperStartViewController.h"
#import "KHLColor.h"
#import "KHLEntertainer.h"
#import "AFNetworking.h"
#import "KHLEntertainerHolderView.h"

@interface SuperStartViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *entertainerScrollView;
@property (nonatomic) CGFloat controllableWidth;
@property (nonatomic) CGFloat controllableHeight;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //KHLEntertainerHolderView *view = [[[NSBundle mainBundle]loadNibNamed:@"KHLEntertainerHolderView" owner:self options:nil] lastObject];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self setControllableWidth:self.entertainerScrollView.frame.size.width];
//    [self setControllableHeight:self.entertainerScrollView.frame.size.height];
    //NSLog(@"+ view will appear");
    //[self refreshEntertainersScrollView];
    [self setCascTitle:@"七煌艺人"];
    [self setFanhui];
    
    [self setControllableWidth:self.entertainerScrollView.frame.size.width];
    [self setControllableHeight:self.entertainerScrollView.frame.size.height];
    [self refreshEntertainersScrollView];
}

- (void)viewDidAppear:(BOOL)animated
{
    //[self refreshEntertainersScrollView];
    //NSLog(@"+ view did appear");
}

- (void)viewWillLayoutSubviews
{
//    [self setControllableWidth:self.entertainerScrollView.frame.size.width];
//    [self setControllableHeight:self.entertainerScrollView.frame.size.height];
//    [self refreshEntertainersScrollView];
}



#pragma mark - CUSTOM LAYOUT METHODES

- (void)refreshEntertainersScrollView
{
    for (UIView *subview in [self.entertainerScrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    NSArray *entertainers = [self MakeSimulateEntertainersWithCapacity:13];
    for (int i = 0; i < [entertainers count]; i++) {
        KHLEntertainerHolderView * holder = [[[NSBundle mainBundle] loadNibNamed:@"KHLEntertainerHolderView" owner:self options:nil]lastObject];
        [holder setFrame:CGRectMake(i * self.controllableWidth, 0, self.controllableWidth, self.controllableHeight)];
        
        [holder loadData:entertainers[i] useWindowSize:self.view.frame.size];
        
//        NSLog(@"- MainH (%.0f, %.0f) [%.0f x %.0f]", holder.frame.origin.x, holder.frame.origin.y, holder.frame.size.width, holder.frame.size.height);
//        NSLog(@"- - Holde (%.0f, %.0f) [%.0f x %.0f] <%.0f x %.0f>", holder.holderScrollView.frame.origin.x, holder.holderScrollView.frame.origin.y, holder.holderScrollView.frame.size.width, holder.holderScrollView.frame.size.height, holder.holderScrollView.contentSize.width, holder.holderScrollView.contentSize.height);
//        NSLog(@"- - - Label (%.0f, %.0f) [%.0f x %.0f]", holder.experienceLabel.frame.origin.x, holder.experienceLabel.frame.origin.y, holder.experienceLabel.frame.size.width, holder.experienceLabel.frame.size.height);
        
        [self.entertainerScrollView addSubview:holder];
        
//        CGFloat expectedHeight = holder.experienceHolder.frame.origin.y + holder.experienceLabel.frame.size.height + 80;
//        expectedHeight = expectedHeight > self.view.frame.size.height ? expectedHeight : self.view.frame.size.height;
//        [holder.holderScrollView setContentSize:CGSizeMake(0, expectedHeight)];
//        UIEdgeInsets contentinset = UIEdgeInsetsMake(0, 0, self.entertainerScrollView.contentSize.height, 0);
//        self.entertainerScrollView.contentInset = contentinset;
    }
    
    [self.entertainerScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.entertainerScrollView setContentSize:CGSizeMake(self.controllableWidth * [entertainers count], 0)];
}

/*
- (void)refreshScrollView
{
    NSArray *entertainers = [self MakeSimulateEntertainersWithCapacity:3];
    const CGFloat iconSpacing = 5.0f;
    CGFloat contentWidth = 0.0f;
    CGFloat maxHolderHeight = 0.0f;
    for (int i = 0; i < [entertainers count]; i++) {
        
        //UIView * vi = [[NSBundle mainBundle] loadNibNamed:@"dddd" owner:self options:nil];
        
        // Holder Scroll View
        UIScrollView *holderScrollView = [[UIScrollView alloc] init];
        
        // Holder View
        CGFloat holderHeight = 0.0f;
        UIView *holder = [[UIView alloc] init];
        
        // Thumb View
        UIImageView *thumbView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.controllableWidth, 190)];
        [thumbView setBackgroundColor:[UIColor redColor]];
        //[thumbView setImageWithURL:[NSURL URLWithString:[entertainers[i] thumbUrl]]];
        [thumbView setContentMode:UIViewContentModeScaleToFill];
        [holder addSubview:thumbView];
        holderHeight += thumbView.frame.size.height;
        
        // Thumb Spacing View
        UIView *thumbSpacingView = [[UIView alloc] initWithFrame:CGRectMake(0, holderHeight, self.controllableWidth, 20)];
        [thumbSpacingView setBackgroundColor:[KHLColor tubai]];
        [holder addSubview:thumbSpacingView];
        holderHeight += thumbSpacingView.frame.size.height;
        
        // Content Dividing Header View
        UIView *contentDividingHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, holderHeight, self.controllableWidth, BASIC_DIVIDER_HEIGHT)];
        [contentDividingHeaderView setBackgroundColor:[KHLColor shiqing]];
        [holder addSubview:contentDividingHeaderView];
        holderHeight += contentDividingHeaderView.frame.size.height;
        
        // Nickname Holder View
        UIView *nicknameView = [[UIView alloc] init]; {
            contentWidth = 1.0f;
            
            // Nickname Icon
            UIImageView *nicknameIcon = [[UIImageView alloc] initWithFrame:CGRectMake(contentWidth + iconSpacing, 0, 15, BASIC_LINE_HEIGHT)];
            [nicknameIcon setImage:[UIImage imageNamed:@"qihuangyiren_icon_nicheng@2x.png"]];
            [nicknameIcon setContentMode:UIViewContentModeScaleAspectFit];
            [nicknameView addSubview:nicknameIcon];
            contentWidth += nicknameIcon.frame.size.width + 2 * iconSpacing;
            
            // Nickname Label
            UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentWidth, 0, 40, BASIC_LINE_HEIGHT)];
            [nicknameLabel setText:@"昵称"];
            [nicknameLabel setTextAlignment:NSTextAlignmentLeft];
            [nicknameLabel setFont:[UIFont systemFontOfSize:14]];
            [nicknameView addSubview:nicknameLabel];
            contentWidth += nicknameLabel.frame.size.width;
            
            // Nickname Dividing View
            UIView *nicknameDividingView = [[UIView alloc] initWithFrame:CGRectMake(contentWidth, BASIC_LINE_HEIGHT, self.controllableHeight - contentWidth, BASIC_DIVIDER_HEIGHT)];
            [nicknameDividingView setBackgroundColor:[KHLColor shiqing]];
            [nicknameView addSubview:nicknameDividingView];
            
            // Nickname Text View
            UILabel *nicknameTextView = [[UILabel alloc] initWithFrame:CGRectMake(contentWidth, 0, self.controllableWidth - contentWidth, BASIC_LINE_HEIGHT)];
            [nicknameTextView setText:[entertainers[i] nickname]];
            [nicknameTextView setFont:[UIFont systemFontOfSize:14]];
            [nicknameView addSubview:nicknameTextView];
            contentWidth += nicknameTextView.frame.size.width;
        }
        [nicknameView setFrame:CGRectMake(0, holderHeight, self.controllableWidth, BASIC_LINE_HEIGHT + BASIC_DIVIDER_HEIGHT)];
        [nicknameView setBackgroundColor:[UIColor whiteColor]];
        [holder addSubview:nicknameView];
        holderHeight += nicknameView.frame.size.height;
        
        // Programme Holder View
        UIView *programmeView = [[UIView alloc] init]; {
            contentWidth = 1.0f;
            
            // Programme Icon
            UIImageView *programmeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(contentWidth + iconSpacing, 0, 15, BASIC_LINE_HEIGHT)];
            [programmeIcon setImage:[UIImage imageNamed:@"qihuangyiren_icon_jiemu@2x.png"]];
            [programmeIcon setContentMode:UIViewContentModeScaleAspectFit];
            [programmeView addSubview:programmeIcon];
            contentWidth += programmeIcon.frame.size.width + 2 * iconSpacing;
            
            // Programme Label
            UILabel *programmeLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentWidth, 0, 40, BASIC_LINE_HEIGHT)];
            [programmeLabel setText:@"节目"];
            [programmeLabel setTextAlignment:NSTextAlignmentLeft];
            [programmeLabel setFont:[UIFont systemFontOfSize:14]];
            [programmeView addSubview:programmeLabel];
            contentWidth += programmeLabel.frame.size.width;
            
            // Programme Dividing View
            UIView *programmeDividingView = [[UIView alloc] initWithFrame:CGRectMake(contentWidth, BASIC_LINE_HEIGHT, self.controllableHeight - contentWidth, BASIC_DIVIDER_HEIGHT)];
            [programmeDividingView setBackgroundColor:[KHLColor shiqing]];
            [programmeView addSubview:programmeDividingView];
            
            // Programme Text View
            UILabel *programmeTextView = [[UILabel alloc] initWithFrame:CGRectMake(contentWidth, 0, self.controllableWidth - contentWidth, BASIC_LINE_HEIGHT)];
            [programmeTextView setText:[entertainers[i] programme]];
            [programmeTextView setFont:[UIFont systemFontOfSize:14]];
            [programmeView addSubview:programmeTextView];
            contentWidth += programmeTextView.frame.size.width;
        }
        [programmeView setFrame:CGRectMake(0, holderHeight, self.controllableWidth, BASIC_LINE_HEIGHT + BASIC_DIVIDER_HEIGHT)];
        [programmeView setBackgroundColor:[UIColor whiteColor]];
        [holder addSubview:programmeView];
        holderHeight += programmeView.frame.size.height;
        
        // Experience Holder View
        CGFloat expHeight = 0.0f;
        UIView *experienceView = [[UIView alloc] init]; {
            contentWidth = 1.0f;
            
            // Experience Icon
            UIImageView *experienceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(contentWidth + iconSpacing, 0, 15, BASIC_LINE_HEIGHT)];
            [experienceIcon setImage:[UIImage imageNamed:@"qihuangyiren_icon_jingli@2x.png"]];
            [experienceIcon setContentMode:UIViewContentModeScaleAspectFit];
            [experienceView addSubview:experienceIcon];
            contentWidth += experienceIcon.frame.size.width + 2 * iconSpacing;
            
            // Experience Label
            UILabel *experienceLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentWidth, 0, 40, BASIC_LINE_HEIGHT)];
            [experienceLabel setText:@"经历"];
            [experienceLabel setTextAlignment:NSTextAlignmentLeft];
            [experienceLabel setFont:[UIFont systemFontOfSize:14]];
            [experienceView addSubview:experienceLabel];
            contentWidth += experienceLabel.frame.size.width;
            
            // Experience Text View
            CGFloat w = self.controllableWidth - contentWidth;
            NSString *s = [entertainers[i] experience];
            UIFont *f = [UIFont systemFontOfSize:14];
            CGSize bs = CGSizeMake(w, MAXFLOAT);
            CGRect lr = [s boundingRectWithSize:bs options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : f} context:nil];
            UITextView *experienceTextView = [[UITextView alloc] initWithFrame:CGRectMake(contentWidth, 0, w, lr.size.height)];
            [experienceTextView setText:s];
            [experienceTextView setFont:[UIFont systemFontOfSize:14]];
            [experienceTextView setTextAlignment:NSTextAlignmentNatural];
            [experienceTextView setScrollEnabled:FALSE];
            
            [experienceView addSubview:experienceTextView];
            contentWidth += experienceTextView.frame.size.width;
            expHeight = experienceTextView.frame.size.height;
        }
        [experienceView setFrame:CGRectMake(0, holderHeight, self.controllableWidth, expHeight)];
        [experienceView setBackgroundColor:[UIColor whiteColor]];
        [holder addSubview:experienceView];
        holderHeight += experienceView.frame.size.height;
        
        // Content Dividing Footer View
        UIView *contentDividingFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, holderHeight, self.controllableHeight, BASIC_DIVIDER_HEIGHT)];
        [contentDividingFooterView setBackgroundColor:[KHLColor shiqing]];
        [holder addSubview:contentDividingFooterView];
        holderHeight += contentDividingHeaderView.frame.size.height;
        
        // Cosy View
        UIView *cosyView = [[UIView alloc] initWithFrame:CGRectMake(0, holderHeight, self.controllableHeight, 80)];
        [cosyView setBackgroundColor:[KHLColor tubai]];
        [holder addSubview:cosyView];
        holderHeight += cosyView.frame.size.height;
        
        // Calculate and resize holder..
        //  and add holder to scroll view..
        [holder setBackgroundColor:[UIColor greenColor]];
        [holder setFrame:CGRectMake(0, 0, self.controllableWidth, holderHeight)];
        [holderScrollView setFrame:CGRectMake(i * self.controllableWidth, 0, self.controllableWidth, self.controllableHeight)];
        [holderScrollView setContentSize:CGSizeMake(0, holder.frame.size.height)];
        [holderScrollView addSubview:holder];
        
//        [holderScrollView setBackgroundColor:[UIColor brownColor]];
//        [self.entertainerScrollView setBackgroundColor:[UIColor cyanColor]];
//        [self.view setBackgroundColor:[UIColor redColor]];
        
        [self.entertainerScrollView addSubview:holderScrollView];
        
        maxHolderHeight = maxHolderHeight < holderHeight ? holderHeight : maxHolderHeight;
        
        //NSLog(@"holder height:%.2f", holderHeight);
        //NSLog(@"thumb frame:%.2f/%.2f", thumbView.frame.size.width, thumbView.frame.size.height);
        //NSLog(@"ctt: %.2f/%.2f  scr: %.2f/%.2f  hol: %.2f/%.2f" ,holderScrollView.contentSize);
    }
    
    [self.entertainerScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.entertainerScrollView setContentSize:CGSizeMake(self.controllableWidth * [entertainers count], 0)];
    NSLog(@"==== CONTENT: %.2f ====", self.entertainerScrollView.contentSize.height);
}
 */



#pragma mark - DEBUG METHODES

- (NSArray *)MakeSimulateEntertainersWithCapacity: (NSUInteger)capacity
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:capacity];
    for (int i = 0; i < capacity; i++) {
        KHLEntertainer *entertainer = [[KHLEntertainer alloc] initWithId:[NSString stringWithFormat:@"E%d", i+1]
                                                 thumbUrl:@""
                                                 nickname:@""
                                                programme:@""
                                               experience:@""];
        switch (i % 3) {
            case 0:
                entertainer.thumbUrl = @"http://wd600.10yan.com/uploadfile/2012/0518/20120518105444247.jpg";
                entertainer.nickname = @"徐振之";
                entertainer.programme = @"徐霞客游记";
                entertainer.experience = @"我药当大侠！";
                break;
                
            case 1:
                entertainer.thumbUrl = @"http://c.hiphotos.baidu.com/baike/w%3D268/sign=2dd016050a46f21fc9345955ce256b31/b3119313b07eca809f226119912397dda144832d.jpg";
                entertainer.nickname = @"朱权";
                entertainer.programme = @"飞瀑连珠";
                entertainer.experience = @"宁子飞瀑，衡子遗音，益子韵磬，潞子中和。复养和，宣和，汉鸾，绕梁，号钟，列子，仲尼，此君，竹节，师旷诸式。";
                break;
                
            case 2:
                // test: 约当15世纪之末，有一位中国明代的官吏叫万户，他在一把座椅的背后，装上47枚当时可能买到的最大火箭。他把自己捆绑在椅子的前边，两只手各拿一个大风筝。然后叫他的仆人同时点燃47枚大火箭，其目的是想借火箭向前推进的力量，加上风筝上升的力量飞向前方。——《Rockets and Jets》by Herbert S. Zim, 1945, America
                entertainer.thumbUrl = @"http://imgsrc.baidu.com/baike/pic/item/bd7042604bfa568a8db10d8c.jpg";
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
