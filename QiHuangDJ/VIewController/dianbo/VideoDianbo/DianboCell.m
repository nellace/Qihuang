//
//  DianboCell.m
//  QiHuangDJ
//
//  Created by 雅泰  on 14/10/28.
//  Copyright (c) 2014年 雅泰 . All rights reserved.
//

#import "DianboCell.h"

@implementation DianboCell

- (void)rowHeight:(NSString *)content {

    UIFont *tfont = [UIFont systemFontOfSize:14.0];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    ////////   ios 7
    CGSize sizeText = [content boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;


}

@end
