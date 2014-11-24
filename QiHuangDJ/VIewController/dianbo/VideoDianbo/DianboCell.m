//
//  DianboCell.m
//  QiHuangDJ
//
//  Created by 雅泰  on 14/10/28.
//  Copyright (c) 2014年 雅泰 . All rights reserved.
//

#import "DianboCell.h"

@interface DianboCell()
@property (weak, nonatomic) IBOutlet UIView *measurement;
@end

@implementation DianboCell

- (CGFloat)measuremented
{
    return (self.measurement ? self.measurement.frame.origin.y : 0);
}

- (void)rowHeight:(NSString *)content {

}

@end
