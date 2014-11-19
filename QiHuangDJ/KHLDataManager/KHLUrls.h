//
//  KHLUrls.h
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-28.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#ifndef QiHuangDJ_KHLUrls_h
#define QiHuangDJ_KHLUrls_h

#pragma mark - 1.1 （2.0）接口访问地址
#define KHLUrlBase @"http://www.175kh.com/api/"

#pragma mark - 2.1 （2.1）注册新用户
#define KHLUrlRegister @"app_register.php"//?username=%@&password=%@&sex=%@&email=%@"

#pragma mark - 2.2 （2.2）登录
#define KHLUrlLogin @"app_login.php"//?loginname=%@&password=%@"

#pragma mark - 2.3 （2.22）找回密码
#define KHLUrlRetrievePassword @"app_forget.php"//?email=%@"

#pragma mark - 3.1 （2.3）获取推荐列表
#define KHLUrlRecommendListAcquire @"app_tuijianlist.php"

#pragma mark - 3.2 （2.4）获取订阅列表
#define KHLUrlSubscriptionListAcquire @"app_dingyuelist.php?uid=%@&token=%@"

#pragma mark - 3.3 （2.5）获取收藏列表
#define KHLUrlCollectionListAcquire @"app_shoucanglist.php?uid=%@&token=%@"

#pragma mark - 4.1 获取个人资料？

#pragma mark - 4.2 （2.6）修改个人资料
#define KHLUrlPersonalInformationModify @"app_editinfo.php"//?uid=%@&mobile=%@&nameture=%@&sex=%@&birthday=%@&blogaddress=%@&qq=%@&token=%@"

#pragma mark - 5.1 （2.7）首页图片（轮播图、背景图）
#define KHLUrlHomepageImagesAcquire @"app_home.php"

#pragma mark - 6.1 （2.8）获取直播列表
#define KHLUrlLiveListAcquire @"app_zhibolist.php?game=%@"

#pragma mark - 6.2 （2.9）获取直播详情（获取评论？）
#define KHLUrlLiveDetailAcquire @"app_zhibo.php"//?info_id=%@&uid=%@&token=%@"

#pragma mark - 7.1 （2.14）获取点播列表
#define KHLUrlVODListAcquire @"app_dianbolist.php?type=%@&cate_id=%@&p=%@&search=%@"

#pragma mark - 7.2 （2.15）获取点播详情（获取评论？）
#define KHLUrlVODDetailAcquire @"app_dianbo.php?info_id=%@&model=%@"

#pragma mark - 8.1 （2.12）订阅
#define KHLUrlSubscribeCategory @"app_dingyue.php"//?uid=%@&cate_id=%@&token=%@"

#pragma mark - 8.2 （2.13）退订
#define KHLUrlUnsubscribeCategory @"app_quxiaodingyue.php"//?uid=%@&cate_id=%@&token=%@"

#pragma mark - 9.1 （2.16）添加收藏
#define KHLUrlCollectArticle @"app_shoucang.php"//?uid=%@&info_id=%@&cate_id=%@&token=%@"

#pragma mark - 9.2 （2.17）取消收藏
#define KHLUrlUncollectArticle @"app_quxiaodingyue.php"//?uid=%@&info_id=%@&cate_id=%@token=%@"

#pragma mark - 10.1 （2.18）获取艺人列表
#define KHLUrlEntertainersListAcquire @"app_ourstar.php"

#pragma mark - 11.1 （2.19）获取资讯列表
#define KHLUrlInformationListAcquire @"app_zixunlist.php?cate_id=%@&model=%@&search=%@&p=%@"

#pragma mark - 11.2 （2.20）获取资讯详情
#define KHLUrlInformationDetailAcquire @"app_zixuninfo.php?info_id=%@&model=%@"

#pragma mark - 12.1 （2.21）搜索
#define KHLUrlSearch @"app_search.php?search=%@"

#pragma mark - ?.? （2.11）举报
#define KHLUrlReport @"app_jubao.php"//?info_id=%@&type=%@&uid=%@&token=%@&model=%@"

#pragma mark - ?.? （2.10）评论
#define KHLUrlCommentReply @"app_pinglun.php"//?uid=%@&info_id=%@&content=%@&token=%@&model=%@"

#pragma mark - (2.23) 评论列表
#define KHLUrlcommentlist @"app_commentlist.php"

#pragma mark - (2.25) 点播分类列表
#define KHLUrlCategoryListAcquire @"app_catelist.php"

#pragma mark - (2.26) 评论 - 顶
#define KHLUrlGoodWithComment @"app_good.php"

#pragma mark - (2.27) 评论 - 踩
#define KHLUrlbadWithComment @"app_bad.php"

#pragma mark - (2.28)  第三方登陆
#define HKLUrlThrild @"app_thirdparty.php"

#pragma mark - (2.24) 二级导航图片
#define KHLUrlSubpage @"app_district.php?cate_id=%@"

#endif
