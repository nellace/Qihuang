//
//  DataManagerModel.h
//  QiHuangDJ
//
//  Created by 雅泰  on 14/10/28.
//  Copyright (c) 2014年 雅泰 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManagerModel : NSObject

@end



#pragma mark - 注册
@interface RegisterInterface : NSObject

@end



#pragma mark - 登录
@interface LoginInterface : NSObject

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *blog;
@property (nonatomic, strong) NSString *regtime;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *qq;

@end



#pragma mark - 推荐列表

@interface RecommendListInterface : NSObject

@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *size;

@property (nonatomic, strong) NSString *identity;  // info_id
@property (nonatomic, strong) NSString *category;  // cate_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageUrl;  // image
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *publisher; // nickname
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *type;      // model (article)

@end



#pragma mark - 订阅列表

@interface SubscriptionListInterface : NSObject

@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *size;

@property (nonatomic, strong) NSString *identity;  // info_id
@property (nonatomic, strong) NSString *category;  // cate_id
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageUrl;  // image
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *publisher; // nickname
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *type;      // model

@end



#pragma mark - 收藏列表

@interface CollectionListInterface : NSObject

@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *size;

@property (nonatomic, strong) NSString *identity;  // info_id
@property (nonatomic, strong) NSString *category;  // cate_id
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageUrl;  // image
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *publisher; // nickname
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *type;      // model

@end



#pragma mark - 修改个人资料

@interface PIMInterface : NSObject

@end



#pragma mark - 首页图片

@interface HomepageImagesInterface : NSObject

@property (nonatomic, strong) NSString *version;

@property (nonatomic, strong) NSString *loopingImageName;      // lunboimg->image
@property (nonatomic, strong) NSString *loopingImageUrl;       // lunboimg->url

@property (nonatomic, strong) NSString *backdropImageName;     // homebgimg->name
@property (nonatomic, strong) NSString *backdropImageUrl;      // homebgimg->image
@property (nonatomic, strong) NSString *backdropImageCategory; // homebgimg->cate_id

@end



#pragma mark - 直播列表

@interface LiveListInterface : NSObject

@property (nonatomic, strong) NSString *identity;  // zhibolist->info_id
@property (nonatomic, strong) NSString *category;  // zhibolist->cate_id
@property (nonatomic, strong) NSString *imageUrl;  // zhibolist->image
@property (nonatomic, strong) NSString *name;      // zhibolist->name
@property (nonatomic, strong) NSString *time;      // zhibolist->time


// yugaolist?

@end



#pragma mark - 直播详情

@interface LiveDetailInterface : NSObject

@property (nonatomic, strong) NSString *identity;    // info_id
@property (nonatomic, strong) NSString *category;    // cate_id
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;       // name or title ?
@property (nonatomic, strong) NSString *type;        // model
@property (nonatomic, strong) NSString *subscribed;  // isdingyue (1 yes, 0 no)

@end



#pragma mark - 回复

@interface ReplyInterface : NSObject

@end



#pragma mark - 举报

@interface ReportInterface : NSObject

@end



#pragma mark - 订阅

@interface SubscribeInterface : NSObject

@end



#pragma mark - 取消订阅

@interface UnsubscribeInterface : NSObject

@end



#pragma mark - 获取点播列表

@interface VODListInterface : NSObject

@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *size;

@property (nonatomic, strong) NSString *identity;  // info_id
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageUrl;  // image
@property (nonatomic, strong) NSString *type;      // model

@end



#pragma mark - 获取点播详情

@interface VODDetailInterface : NSObject

@property (nonatomic, strong) NSString *identity;  // info_id
@property (nonatomic, strong) NSString *category;  // cate_id
@property (nonatomic, strong) NSString *count;     // liulan
@property (nonatomic, strong) NSString *publisher; // editor? nickname?
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;

@end



#pragma mark - 添加收藏

@interface CollectInterface : NSObject

@end



#pragma mark - 取消收藏

@interface UncollectInterface : NSObject

@end



#pragma mark - 艺人列表

@interface EntertainersListInterface : NSObject

@property (nonatomic, strong) NSString *nickname;   // name    昵称
@property (nonatomic, strong) NSString *programme;  // show    节目
@property (nonatomic, strong) NSString *experience; // content 经历
@property (nonatomic, strong) NSString *imageUrl;   // images  图片地址

@end



#pragma mark - 获取资讯列表

@interface InformationListInterface : NSObject

@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *size;

@property (nonatomic, strong) NSString *identity;  // info_id
@property (nonatomic, strong) NSString *category;  // cate_id
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageUrl;  // image
@property (nonatomic, strong) NSString *brief;     // content 资讯简介
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *publisher; // 发布人名称
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *type;      // model

@end



#pragma mark - 获取资讯详情

@interface InformationDetailInterface : NSObject

@property (nonatomic, strong) NSString *identity;  // info_id
@property (nonatomic, strong) NSString *category;  // cate_id
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *imageUrls; // imagelist
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *publisher; // nickname
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *time;

@end



#pragma mark - 搜索

@interface SearchInterface : NSObject

@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *size;

@property (nonatomic, strong) NSString *identity;  // info_id
@property (nonatomic, strong) NSString *category;  // cate_id
@property (nonatomic, strong) NSString *imageUrl;  // image
@property (nonatomic, strong) NSString *brief;     // content
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *publisher; // nickname
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *type;      // model

@end



#pragma mark - 找回密码

@interface RetrievePasswordInterface : NSObject

@end



#pragma mark - 评论列表

@interface CommentListInterface : NSObject

@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *size;

@property (nonatomic, strong) NSString *poster;            // comment_id
@property (nonatomic, strong) NSString *username;          // uname
@property (nonatomic, strong) NSString *portraitImageUrl;  // uimage
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *countGood;         // good
@property (nonatomic, strong) NSString *countBad;          // bad
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *type;              // model


@end



