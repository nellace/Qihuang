//
//  KHLRecommendedCollectionViewCell.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-9.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import "KHLRecommendedCollectionViewCell.h"

@interface KHLRecommendedCollectionViewCell()


@end

@implementation KHLRecommendedCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"KHLRecommendedCollectionViewCell" owner:self options:nil];
        if (views.count < 1) {
            return nil;
        }
        if (![[views objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [views objectAtIndex:0];
    }
    return self;
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
