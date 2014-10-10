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

@property (nonatomic,weak) IBOutlet UILabel * label;
@end

@implementation SuperStartViewController

#define BASIC_LINE_HEIGHT 35
#define BASIC_DIVIDER_HEIGHT 1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [self setControllableWidth:self.entertainerScrollView.frame.size.width];
    [self setControllableHeight:self.entertainerScrollView.frame.size.height];
    //[self refreshScrollView];
    [self refreshEntertainersScrollView];
}

- (void)refreshEntertainersScrollView
{
    NSArray *entertainers = [self MakeSimulateEntertainersWithCapacity:3];
    for (int i = 0; i < [entertainers count]; i++) {
        
    }
    
    [self.entertainerScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.entertainerScrollView setContentSize:CGSizeMake(self.controllableWidth * [entertainers count], 0)];
}

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

- (NSArray *)MakeSimulateEntertainersWithCapacity: (NSUInteger)capacity
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:capacity];
    for (int i = 0; i < capacity; i++) {
        KHLEntertainer *entertainer = [[KHLEntertainer alloc] initWithId:[NSString stringWithFormat:@"E%d", i+1]
                                                 thumbUrl:@"http://d.hiphotos.baidu.com/baike/w%3D268%3Bg%3D0/sign=7ae1850eb01bb0518f24b42e0e41bd89/fcfaaf51f3deb48f5fc228f2f31f3a292df57877.jpg"
                                                 nickname:[NSString stringWithFormat:@"万户%d代", i+1]
                                                programme:@"火箭飞天尝试"
                                               experience:@"约当15世纪之末，有一位中国明代的官吏叫万户，他在一把座椅的背后，装上47枚当时可能买到的最大火箭。他把自己捆绑在椅子的前边，两只手各拿一个大风筝。然后叫他的仆人同时点燃47枚大火箭，其目的是想借火箭向前推进的力量，加上风筝上升的力量飞向前方。——《Rockets and Jets》by Herbert S. Zim, 1945, America"];
        [array addObject:entertainer];
    }
    
    return [array copy];
}

@end
