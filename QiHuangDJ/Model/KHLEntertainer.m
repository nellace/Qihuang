//
//  Entertainer.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-9-23.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import "KHLEntertainer.h"

@implementation KHLEntertainer

- (instancetype)initWithId: (NSString *)eid
                  thumbUrl: (NSString *)url
                  nickname: (NSString *)nick
                 programme: (NSString *)prog
                experience: (NSString *)exp
{
    self = [super init];
    
    if (self) {
        [self setIdentity:eid];
        [self setThumbUrl:url];
        [self setNickname:nick];
        [self setProgramme:prog];
        [self setExperience:exp];
    }
    
    return self;
}

@end
