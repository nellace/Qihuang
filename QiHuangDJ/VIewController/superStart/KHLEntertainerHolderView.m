//
//  KHLEntertainerHolderView.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-9.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import "KHLEntertainerHolderView.h"

@interface KHLEntertainerHolderView() 
@property (nonatomic) CGSize size;
@end

@implementation KHLEntertainerHolderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)loadData:(KHLEntertainer *)entertainer useWindowSize:(CGSize)size
{
    self.size = CGSizeMake(size.width, size.height);
    
    [self.photoImageView setImageWithURL:[NSURL URLWithString:[entertainer thumbUrl]]];
    [self.nicknameLabel setText:[entertainer nickname]];
    [self.programmeLabel setText:[entertainer programme]];
    
    
    NSMutableAttributedString *exp = [[NSMutableAttributedString alloc] initWithString:[entertainer experience]];
    NSMutableParagraphStyle *paras = [[NSMutableParagraphStyle alloc] init];
    [paras setLineSpacing:9];
    [exp addAttribute:NSParagraphStyleAttributeName value:paras range:NSMakeRange(0, [exp length])];
    [self.experienceLabel setAttributedText:exp];
    [self.experienceLabel setNumberOfLines:0];
    
    CGFloat expectedHeight = self.experienceHolder.frame.origin.y + self.experienceLabel.frame.size.height + 80;
    expectedHeight = expectedHeight > self.size.height ? expectedHeight : self.size.height;
    [self.holderScrollView setContentSize:CGSizeMake(0, expectedHeight)];
}

- (IBAction)pressLaLaLa:(UIButton *)sender
{
    [self.holderView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mings-ships-sailing"]]];
    
    CGFloat expectedHeight = self.experienceHolder.frame.origin.y + self.experienceLabel.frame.size.height + 80;
    NSLog(@"exp height: %.0f, window height: %.0f", expectedHeight, self.size.height);
    expectedHeight = expectedHeight > self.size.height ? expectedHeight : self.size.height;
    [self.holderScrollView setContentSize:CGSizeMake(0, expectedHeight)];
    
//    UIView *v = [self.holderView viewForBaselineLayout];
//    [self.holderView setBackgroundColor:[UIColor clearColor]];
//    UIView *v = self.holderView;
//    UIImage *img = [self getImageFromView:self.holderView];
//    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
//    [iv setImage:img];
//    for (UIView *view in [self.holderScrollView subviews]) {
//        [view removeFromSuperview];
//    }
//    [self.holderScrollView setBackgroundColor:[UIColor redColor]];
//    [v setFrame:CGRectMake(0, 0, v.frame.size.width, expectedHeight)];
//    [self.holderScrollView addSubview:iv];
    
//    [self.holderView removeConstraints:[self.holderView constraints]];
    
    NSLog(@"holder scroll view (%.0f, %.0f) [%.0f x %.0f] <%.0f x %.0f>", self.holderScrollView.frame.origin.x, self.holderScrollView.frame.origin.y, self.holderScrollView.frame.size.width, self.holderScrollView.frame.size.height, self.holderScrollView.contentSize.width, self.holderScrollView.contentSize.height);
    
    NSLog(@"LALALA (%.0f, %.0f) [%.0f x %.0f]", self.experienceLabel.frame.origin.x, self.experienceLabel.frame.origin.y, self.experienceLabel.frame.size.width, self.experienceLabel.frame.size.height);
}

- (UIImage *)getImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
