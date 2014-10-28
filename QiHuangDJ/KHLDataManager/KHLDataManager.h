//
//  KHLDataManager.h
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-28.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "KHLUrls.h"

@interface KHLDataManager : NSObject

#pragma mark - 获取单例文件实例
+ (KHLDataManager *)instance;



#pragma mark - 2.1 （2.1）注册新用户
/*
 
 类型：
 POST
 
 参数：
 username  用户名
 password  密码
 gender    性别（1：男 2：女）
 email     邮箱
 
 返回：
 {
 “resultCode”:”0”,   返回码
 ”reason”:”success”, 返回说明
 ”result”:”134”      返回注册用户ID
 }
 
 使用：
 KHLUrlBase
 KHLUrlRegister
 
 */
- (void)registerHUDHolder: (UIView *)holder
                 username: (NSString *)username
                 password: (NSString *)password
                   gender: (NSString *)gender
                    email: (NSString *)email;



#pragma mark - 2.2 （2.2）登录
/*
 
 类型：
 POST
 
 参数：
 loginname  登录名（用户名或邮箱）
 password   密码
 
 返回：
 {
 “resultCode”:”0”,
 “reason”: “success”,
 “result”:
 {
 “id”:”2”,
 “username”: “1399451621000”,
 “mobile”:”13264395694”,
 “nameture”:”杨阳”,
 “address”:”北京”,
 “sex”:”男”,
 “birthday”:”1991-01-01”,
 “blogaddress”:www.csdn.blogs.xxx,
 “registertime”:”2014-08-02”,
 “email”:”923609666@qq.com”,
 “qq”:”12345678”
 }
 }
 
 使用：
 KHLUrlBase
 KHLUrlLogin
 
 */
- (void)loginHUDHolder: (UIView *)holder
             loginName: (NSString *)loginName
              password: (NSString *)password;



#pragma mark - 2.3 （2.22）找回密码
/*
 
 类型：
 POST
 
 参数：
 email  登录名（用户名或邮箱）
 
 返回：
 {
 “resultCode”:“0”,
 “reason”: “success”,
 }
 
 使用：
 KHLUrlBase
 KHLUrlRetrievePassword
 
 */
- (void)retrievePasswordHUDHolder: (UIView *)holder
                            email: (NSString *)email;




#pragma mark - 3.1 （2.3）获取推荐列表
/*
 
 类型：
 GET
 
 参数：
 无
 
 返回：
 {
 “resultCode”:”0”,
 “reason”: “success”,
 “tuijianlist”:
 [
 {
 “name”: “瞎子”,
 “image”: “http://www.xxx.com/imagepath”,
 ”id”:”1”
 },
 {
 “name”: “中单”,
 “image”: “http://www.xxx.com/imagepath”,
 ”id”:”3”
 }
 ]
 }
 
 使用：
 KHLUrlBase
 KHLUrlRecommendListAcquire
 
 */
- (void)recommendListHUDHolder: (UIView *)holder;



#pragma mark - 3.2 （2.4）获取订阅列表
/*
 
 类型：
 GET
 
 参数：
 uid    用户ID
 token  用户订阅
 
 返回：
 {
 "resultCode": "0",
 "reason": "success",
 "result":
 {
 "page": "1",
 "size": "1",
 "data":
 [
 {
 "info_id": "25",
 "cate_id": "28",
 "title": "香蕉Banana以转会形式正式加入Newbee战队",
 "image": "/img/2014/03/13/532150bad6bd1.jpg",
 "content": "<br />　　经过与iG电子竞技俱乐部友好协商，原iG电子竞技俱乐部DOTA2",
 "count": "1263",
 "nickname": "",
 "time": "2014-03-13 14:27:14",
 "model": "article"
 }
 ]
 }
 }
 
 使用：
 KHLUrlBase
 KHLUrlSubscriptionListAcquire
 
 */
- (void)subscriptionListHUDHolder: (UIView *)holder
                              uid: (NSString *)uid
                            token: (NSString *)token;




#pragma mark - 3.3 （2.5）获取收藏列表
/*
 
 类型：
 GET
 
 参数：
 uid    用户ID
 token  用户订阅
 
 返回：
 {
 "resultCode": "0",
 "reason": "success",
 "result":
 {
 "page": "1",
 "size": "1",
 "data":
 [
 {
 "info_id": "94",
 "cate_id": "45",
 "title": "4.5正式补丁：狮子酒桶重做完毕，鳄鱼后期增强",
 "image": "http://image.175kh.com/E.jpg",
 "content": "<p><span style=\"font-size:14px;\">&nbsp;",
 "count": "595",
 "nickname": "",
 "time": "2014-04-04 14:29:02",
 "model": "article"
 }
 ]
 }
 }
 
 使用：
 KHLUrlBase
 KHLUrlCollectionListAcquire
 
 */
- (void)collectionListHUDHolder: (UIView *)holder
                            uid: (NSString *)uid
                          token: (NSString *)token;



#pragma mark - 4.2 （2.6）修改个人资料
/*
 
 类型：
 POST
 
 参数：
 uid          用户ID
 mobile       电话号码
 nameture     真实姓名
 sex          性别（1男，2女）
 birthday     生日(yyyy-MM-dd)
 blogaddress  博客地址
 qq           QQ号码
 token        用户token
 
 返回：
 {
 “resultCode”:”0”,
 “reason”: “success”,
 }
 
 使用：
 KHLUrlBase
 KHLUrlPersonalInformationModify
 
 */
- (void)modifyPersonalInformationHUDHolder: (UIView *)holder
                                       uid: (NSString *)uid
                                     phone: (NSString *)phone
                                      name: (NSString *)name
                                    gender: (NSString *)gender
                                  birthday: (NSString *)birthday
                                      blog: (NSString *)blog
                                        qq: (NSString *)qq
                                     token: (NSString *)token;



#pragma mark - 5.1 （2.7）首页图片（轮播图、背景图）
/*
 
 类型：
 GET
 
 参数：
 无
 
 返回：
 {
 "resultCode": "0",
 "reason": "success",
 "result":
 {
 "version": "0.1",
 "lunboimg":
 [
 {
 "image": "",
 "url": ""
 }
 ],
 "homebgimg":
 [
 {
 "image": "",
 "name": "直播",
 "cate_id": "-1"
 },
 {
 "image": "",
 "name": "七煌艺人",
 "cate_id": "-2"
 },
 {
 "image": "",
 "name": "炉石传说",
 "cate_id": "40"
 }
 ]
 }
 }
 
 使用：
 KHLUrlBase
 KHLUrlHomepageImagesAcquire
 
 */
- (void)homepageImagesHUDHolder: (UIView *)holder;



#pragma mark - 6.1 （2.8）获取直播列表
/*
 
 类型：
 GET
 
 参数：
 game  游戏类型
 空  首页直接进入
 1   英雄联盟
 2   炉石传说
 3   DOTA2
 
 返回：
 {
 "resultCode": "0",
 "reason": "success",
 "result":
 {
 "zhibolist":
 [
 {
 "info_id": "16",
 "cate_id": "134",
 "image": "",
 "name": "OGN春季赛",
 "time": "04月08日 09:39"
 }
 ],
 "yugaolist": []
 }
 }
 
 使用：
 KHLUrlBase
 KHLUrlLiveListAcquire
 
 */
- (void)liveListHUDHolder: (UIView *)holder
                     type: (NSString *)type;



#pragma mark - 6.2 （2.9）获取直播详情
/*
 
 类型：
 POST
 
 参数：
 info_id  直播ID
 uid      用户ID
 token    用户token
 
 返回：
 {
 "resultCode": "0",
 "reason": "success",
 "result":
 {
 "info_id": "16",
 "cate_id": "134",
 "url": "http://www.fengyunzhibo.com/tv/1395698_1384400073210.htm",
 "name": "OGN春季赛",
 "model": "live",
 "isdingyue": "0"
 }
 }
 
 使用：
 KHLUrlBase
 KHLUrlLiveDetailAcquire
 
 */
- (void)liveDetailHUDHolder: (UIView *)holder
                   identity: (NSString *)identity
                        uid: (NSString *)uid
                      token: (NSString *)token;



#pragma mark - 7.1 （2.14）获取点播列表
/*
 
 类型：
 GET
 
 参数：
 type     类型
 1 最新视频
 2 最热视屏
 3 最短时长（暂无）
 cate_id  分类ID
 p        当前页码（默认为1）
 
 返回：
 {
 "resultCode": "0",
 "reason": "success",
 "result":
 {
 "page": "24",
 "size": "24",
 "data":
 [
 {
 "info_id": "83",
 "title": "外服V4.5补丁即出 大圣或将遭殃",
 "image": "xxxxxxx.jpg",
 "model": "article"
 }
 ]
 }
 }
 
 使用：
 KHLUrlBase
 KHLUrlVODListAcquire
 
 */
- (void)VODListHUDHolder: (UIView *)holder
                    type: (NSString *)type
                category: (NSString *)category
                    page: (NSString *)page;



#pragma mark - 7.2 （2.15）获取点播详情
/*
 
 类型：
 GET
 
 参数：
 info_id  点播ID
 model    类型
 
 返回：
 {
 "resultCode": "0",
 "reason": "success",
 "result":
 {
 "info_id": "83",
 "cate_id": "45",
 "liulan": "1170",
 "editor": "",
 "url": "http://lol.175khkh.com/1374391352821/content/1395823629652.html",
 "title": "外服V4.5补丁即出 大圣或将遭殃"
 }
 }
 
 使用：
 KHLUrlBase
 KHLUrlVODDetailAcquire
 
 */
- (void)VODDetailHUDHolder: (UIView *)holder
                  identity: (NSString *)identity
                      type: (NSString *)type;



#pragma mark - 8.1 （2.12）订阅
/*
 
 类型：
 GET
 
 参数：
 uid      用户ID
 cate_id  分类ID
 token    用户token
 
 返回：
 {
 “resultCode”:“0”,
 “reason”: “success”,
 “dingyueid”,”22”
 }
 
 使用：
 KHLUrlBase
 KHLUrlSubscribeCategory
 
 */
- (void)subscribeHUDHolder: (UIView *)holder
                       uid: (NSString *)uid
                  category: (NSString *)category
                     token: (NSString *)token;



#pragma mark - 8.2 （2.13）退订
/*
 
 类型：
 POST
 
 参数：
 uid      用户ID
 cate_id  分类ID
 token    用户token
 
 返回：
 {
 “resultCode”:”0”,
 “reason”: “success”
 }
 
 使用：
 KHLUrlBase
 KHLUrlUnsubscribeCategory
 
 */
- (void)unsubscribeHUDHolder: (UIView *)holder
                         uid: (NSString *)uid
                    category: (NSString *)category
                       token: (NSString *)token;



#pragma mark - 9.1 （2.16）添加收藏
/*
 
 类型：
 POST
 
 参数：
 uid      用户ID
 info_id  收藏的视频ID
 cate_id  分类ID
 token    用户token
 
 返回：
 {
 “resultCode”:“0”,
 “reason”: “success”
 }
 
 使用：
 KHLUrlBase
 KHLUrlCollectArticle
 
 */
- (void)collectArticleHUDHolder: (UIView *)holder
                            uid: (NSString *)uid
                       identity: (NSString *)identity
                       category: (NSString *)category
                          token: (NSString *)token;



#pragma mark - 9.2 （2.17）取消收藏
/*
 
 类型：
 POST
 
 参数：
 uid      用户ID
 info_id  收藏的视频ID
 cate_id  分类ID
 token    用户token
 
 返回：
 {
 “resultCode”:“0”,
 “reason”: “success”
 }
 
 使用：
 KHLUrlBase
 KHLUrlUncollectArticle
 
 */
- (void)uncollectArticleHUDHolder: (UIView *)holder
                              uid: (NSString *)uid
                         identity: (NSString *)identity
                         category: (NSString *)category
                            token: (NSString *)token;



#pragma mark - 10.1 （2.18）获取艺人列表
/*
 
 类型：
 GET
 
 参数：
 无
 
 返回：
 {
 “resultCode”:“0”,
 “reason”: “success”,
 “result”:
 [
 {
 “nickname”:”xixi”,
 ”title”:”kkkk”,
 ”content”:”领证会时人”
 },
 {
 “nickname”:”xixi”,
 ”title”:”kkkk”,
 ”content”:”领证会时人”
 }
 ]
 }
 
 使用：
 KHLUrlBase
 KHLUrlEntertainersListAcquire
 
 */
- (void)entertainersListHUDHolder: (UIView *)holder;



#pragma mark - 11.1 （2.19）获取资讯列表
/*
 
 类型：
 GET
 
 参数：
 cate_id  分类ID
 model    类型
 search   搜索文本（可为空）
 page     页码（默认为1）
 
 返回：
 {
 "resultCode": "0",
 "reason": "success",
 "result":
 {
 "page": "1",
 "size": "1",
 "data":
 [
 {
 "info_id": "40",
 "cate_id": "55",
 "title": "绝美Coser秀 3.19DOTA2发布会惊艳世界",
 "content": "test content",
 "count": "816",
 "nickname": "小A",
 "time": "2014-03-30 12:42:36",
 "model": "article",
 "image": ""
 }
 ]
 }
 }
 
 使用：
 KHLUrlBase
 KHLUrlInformationListAcquire
 
 */
- (void)informationListHUDHolder: (UIView *)holder
                        category: (NSString *)category
                            type: (NSString *)type
                         keyword: (NSString *)keyword
                            page: (NSString *)page;



#pragma mark - 11.2 （2.20）获取资讯详情
/*
 
 类型：
 GET
 
 参数：
 info_id  资讯ID
 model    类型
 
 返回：
 {
 "resultCode": "0",
 "reason": "success",
 "result":
 [
 {
 "info_id": "40",
 "title": "绝美Coser秀 3.19DOTA2发布会惊艳世界",
 "cate_id": "55",
 "source": "",
 "imagelist": "",
 "count": "816",
 "nickname": "小A",
 "content": "你一定关注到了亲临现场的大神，关注到了那些曾经站在巅峰的人们的身影，感受到了《Free to Play》电影给你的启发和触动。但在关注这些的同时，也不要忽略这些美丽的COSER。想必在以后的发布会中，会有更多的英雄被专业的COSER所诠 释。他们让英雄更有生命力，他们，惊艳了整个世界",
 "time": "2014-03-30 12:42:36"
 }
 ]
 }
 
 使用：
 KHLUrlBase
 KHLUrlInformationDetailAcquire
 
 */
- (void)informationDetailHUDHolder: (UIView *)holder
                          identity: (NSString *)identity
                              type: (NSString *)type;



#pragma mark - 12.1 （2.21）搜索
/*
 
 类型：
 GET
 
 参数：
 search  关键字
 
 返回：
 {
 "resultCode": "0",
 "reason": "success",
 "result":
 {
 "page": "1",
 "size": "1",
 "data":
 [
 {
 "info_id": "52",
 "cate_id": "55",
 "image": "DOTA2官方YY频道除了将第一时间带来《Free to Play》的放映……",
 "count": "696",
 "nickname": "",
 "time": "2014-04-04 11:29:04",
 "model": "article"
 }
 ]
 }
 }
 
 使用：
 KHLUrlBase
 KHLUrlSearch
 
 */
- (void)searchHUDHolder: (UIView *)holder
                keyword: (NSString *)keyword;



#pragma mark - ?.? （2.11）举报
/*
 
 类型：
 POST
 
 参数：
 info_id  举报评论ID
 type     举报类型
 1 垃圾广告
 2 淫秽信息
 3 不实信息
 4 人身攻击
 5 泄露隐私
 6 敏感消息
 7 虚拟中奖
 8 其它
 uid      用户ID
 token    用户token
 model    举报对象类型
 
 返回：
 {
 “resultCode”:“0”,
 “reason”: “success”,
 }
 
 使用：
 KHLUrlBase
 KHLUrlReport
 
 */
- (void)reportHUDHolder: (UIView *)holder
               identity: (NSString *)identity
                   type: (NSString *)type
                    uid: (NSString *)uid
                  token: (NSString *)token targetType: (NSString *)targetType;

#pragma mark - ?.? （2.10）评论
/*
 
 类型：
 POST
 
 参数：
 uid      用户ID
 info_id  被评论者ID
 content  评论内容
 token    用户token
 model    评论对象类型
 
 返回：
 {
 “resultCode”:“0”,
 “reason”:“success”,
 “count”:”333”
 }
 
 使用：
 KHLUrlBase
 KHLUrlCommentReply
 
 */
- (void)replyHUDHolder: (UIView *)holder
                   uid: (NSString *)uid
                target: (NSString *)target
               content: (NSString *)content
                 token: (NSString *)token
            targetType: (NSString *)targetType;



@end
