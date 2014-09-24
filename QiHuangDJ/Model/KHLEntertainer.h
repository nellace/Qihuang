//
//  Entertainer.h
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-9-23.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHLEntertainer : NSObject

/** 艺人ID */
@property (nonatomic, strong) NSString *identity;

/** 头像照片url地址 */
@property (nonatomic, strong) NSString *thumbUrl;

/** 艺人昵称 */
@property (nonatomic, strong) NSString *nickname;

/** 主持节目 */
@property (nonatomic, strong) NSString *programme;

/** 艺人经历 */
@property (nonatomic, strong) NSString *experience;

- (instancetype)initWithId:(NSString *)eid thumbUrl:(NSString *)url nickname:(NSString *)nick programme:(NSString *)prog experience:(NSString *)exp;

@end
