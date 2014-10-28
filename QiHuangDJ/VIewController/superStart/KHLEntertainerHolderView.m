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

- (void)loadData:(EntertainersListInterface *)entertainer useWindowSize:(CGSize)size
{
    self.size = CGSizeMake(size.width, size.height);
    
    [self.photoImageView setImageWithURL:[NSURL URLWithString:[entertainer imageUrl]]];
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
