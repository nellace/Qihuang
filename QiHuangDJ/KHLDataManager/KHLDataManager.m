//
//  KHLDataManager.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-28.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import "KHLDataManager.h"

@implementation KHLDataManager

#pragma mark - sinleton
+ (KHLDataManager *)instance
{
    static KHLDataManager *instanceDataManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instanceDataManager = [[self alloc] init];
    });
    
    return instanceDataManager;
}

#pragma mark - 2.1 （2.1）注册新用户
- (void)registerHUDHolder:(UIView *)holder
                 username:(NSString *)username
                 password:(NSString *)password
                   gender:(NSString *)gender
                    email:(NSString *)email
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlRegister];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           username, @"username",
                           password, @"password",
                           gender, @"sex",
                           email, @"email",
                           nil];
    
    [self methodePostName:KHLNotiRegistered holder:holder url:ustr arguments:param];
}

#pragma mark - 2.2 （2.2）登录
- (void)loginHUDHolder:(UIView *)holder
             loginName:(NSString *)loginName
              password:(NSString *)password
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlLogin];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           loginName, @"loginname",
                           password, @"password",
                           nil];
    
    [self methodePostName:KHLNotiLogin holder:holder url:ustr arguments:param];
}

#pragma mark - 2.3 （2.22）找回密码
- (void)retrievePasswordHUDHolder:(UIView *)holder
                            email:(NSString *)email
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlRetrievePassword];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           email, @"email", nil];
    
    [self methodePostName:KHLNotiRetrievePassword holder:holder url:ustr arguments:param];
}

#pragma mark - 3.1 （2.3）获取推荐列表
- (void)recommendListHUDHolder:(UIView *)holder
                          page:(NSString *)page
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlRecommendListAcquire,page];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self methodeGetName:KHLNotiRecommendListAcquired holder:holder url:ustr];
}

#pragma mark - 3.2 （2.4）获取订阅列表
- (void)subscriptionListHUDHolder:(UIView *)holder
                              uid:(NSString *)uid
                            token:(NSString *)token
                             page: (NSString *)page
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlSubscriptionListAcquire, uid, token,page];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self methodeGetName:KHLNotiSubscriptionListAcquired holder:holder url:ustr];
}

#pragma mark - 3.3 （2.5）获取收藏列表
- (void)collectionListHUDHolder:(UIView *)holder
                            uid:(NSString *)uid
                          token:(NSString *)token
                           page:(NSString *)page
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlCollectionListAcquire, uid, token,page];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self methodeGetName:KHLNotiCollectionListAcquired holder:holder url:ustr];
}

#pragma mark - 4.2 （2.6）修改个人资料
- (void)modifyPersonalInformationHUDHolder:(UIView *)holder
                                       uid:(NSString *)uid
                                     phone:(NSString *)phone
                                      name:(NSString *)name
                                    gender:(NSString *)gender
                                  birthday:(NSString *)birthday
                                      blog:(NSString *)blog
                                        qq:(NSString *)qq
                                     token:(NSString *)token
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlPersonalInformationModify];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           uid, @"uid",
                           phone, @"mobile",
                           name, @"nameture",
                           gender, @"sex",
                           birthday, @"birthday",
                           blog, @"blogaddress",
                           qq, @"qq",
                           token, @"token",
                           nil];
    
    [self methodePostName:KHLNotiPersonalInformationModify holder:holder url:ustr arguments:param];
}

#pragma mark - 5.1 （2.7）首页图片（轮播图、背景图）
- (void)homepageImagesHUDHolder:(UIView *)holder
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlHomepageImagesAcquire];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self methodeGetName:KHLNotiHomepageImagesAcquired holder:holder url:ustr];
}

#pragma mark - 6.1 （2.8）获取直播列表
- (void)liveListHUDHolder:(UIView *)holder
                     type:(NSString *)type
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlLiveListAcquire, type];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self methodeGetName:KHLNotiLiveListAcquired holder:holder url:ustr];
}

#pragma mark - 6.2 （2.9）获取直播详情
- (void)liveDetailHUDHolder:(UIView *)holder identity:(NSString *)identity uid:(NSString *)uid token:(NSString *)token
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlLiveDetailAcquire];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           identity, @"info_id",
                           uid, @"uid",
                           token, @"token",
                           nil];
    
    [self methodePostName:KHLNotiLiveDetailAcquired holder:holder url:ustr arguments:param];
}

#pragma mark - 7.1 （2.14）获取点播列表
- (void)VODListHUDHolder:(UIView *)holder
                    type:(NSString *)type
                category:(NSString *)category
                    page:(NSString *)page
                  search:(NSString *)keyword
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlVODListAcquire, type, category, page, keyword];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self methodeGetName:KHLNotiVODListAcquired holder:holder url:ustr];
}

#pragma mark - 7.2 （2.15）获取点播详情
- (void)VODDetailHUDHolder:(UIView *)holder
                  identity:(NSString *)identity
                      type:(NSString *)type
                       uid:(NSString *)uid
                     token:(NSString *)token
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlVODDetailAcquire];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    [self methodeGetName:KHLNotiVODDetailAcquired holder:holder url:ustr];
    
//    NSString *ustr = [NSString stringWithFormat:KHLUrlVODDetailAcquire,agrum];
    NSDictionary *param = [[NSDictionary alloc]initWithObjectsAndKeys:
                           identity,@"info_id",
                           type,@"model",
                           uid,@"uid",
                           token,@"token",
                           nil];
    
    [self methodePostName:KHLNotiVODDetailAcquired holder:holder url:ustr arguments:param];
}

#pragma mark - 8.1 （2.12）订阅
- (void)subscribeHUDHolder:(UIView *)holder
                       uid:(NSString *)uid
                  category:(NSString *)category
                     token:(NSString *)token
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlSubscribeCategory];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           uid, @"uid",
                           category, @"cate_id",
                           token, @"token",
                           nil];
    
    [self methodePostName:KHLNotiSubscribeCategory holder:holder url:ustr arguments:param];
}

#pragma mark - 8.2 （2.13）退订
- (void)unsubscribeHUDHolder:(UIView *)holder
                         uid:(NSString *)uid
                    category:(NSString *)category
                       token:(NSString *)token
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlUnsubscribeCategory];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           uid, @"uid",
                           category, @"cate_id",
                           token, @"token",
                           nil];
    
    [self methodePostName:KHLNotiUnsubscribeCategory holder:holder url:ustr arguments:param];
}

#pragma mark - 9.1 （2.16）添加收藏
//sg
- (void)collectArticleHUDHolder:(UIView *)holder
                            uid:(UIView *)uid
                       identity:(UIView *)identity
                       category:(UIView *)category
                          token:(UIView *)token
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlCollectArticle];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           uid, @"uid",
                           identity, @"info_id",
                           category, @"cate_id",
                           token, @"token",
                           nil];
    
    [self methodePostName:KHLNotiCollectArticle holder:holder url:ustr arguments:param];
}

#pragma mark - 9.2 （2.17）取消收藏
- (void)uncollectArticleHUDHolder:(UIView *)holder
                              uid:(NSString *)uid
                         identity:(NSString *)identity
                         category:(NSString *)category
                            token:(NSString *)token
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlUncollectArticle];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           uid, @"uid",
                           identity, @"info_id",
                           category, @"cate_id",
                           token, @"token",
                           nil];
    
    [self methodePostName:KHLNotiUncollectArticle holder:holder url:ustr arguments:param];
}

#pragma mark - 10.1 （2.18）获取艺人列表
- (void)entertainersListHUDHolder:(UIView *)holder
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlEntertainersListAcquire];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self methodeGetName:KHLNotiEntertainersAcquired holder:holder url:ustr];
}

#pragma mark - 11.1 （2.19）获取资讯列表
- (void)informationListHUDHolder:(UIView *)holder
                        category:(NSString *)category
                            type:(NSString *)type
                         keyword:(NSString *)keyword
                            page:(NSString *)page
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlInformationListAcquire, category, type, keyword, page];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self methodeGetName:KHLNotiInformationListAcquired holder:holder url:ustr];
}

#pragma mark - 11.2 （2.20）获取资讯详情
- (void)informationDetailHUDHolder:(UIView *)holder
                          identity:(NSString *)identity
                              type:(NSString *)type
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlInformationDetailAcquire, identity, type];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self methodeGetName:KHLNotiInformationDetailAcquired holder:holder url:ustr];
}

#pragma mark - 12.1 （2.21）搜索
- (void)searchHUDHolder:(UIView *)holder
                keyword:(NSString *)keyword
                   page: (NSString *)page
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlSearch, keyword,page];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self methodeGetName:KHLNotiSearchResult holder:holder url:ustr];
}

#pragma mark - ?.? （2.11）举报
- (void)reportHUDHolder:(UIView *)holder
               identity:(NSString *)identity
                   type:(NSString *)type
                    uid:(NSString *)uid
                  token:(NSString *)token
             targetType:(NSString *)targetType
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlReport];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           identity, @"info_id",
                           type, @"type",
                           uid, @"uid",
                           token, @"token",
                           targetType, @"model",
                           nil];
    
    [self methodePostName:KHLNotiReported holder:holder url:ustr arguments:param];
}

#pragma mark - ?.? （2.10）评论
- (void)replyHUDHolder:(UIView *)holder
                   uid:(NSString *)uid
                target:(NSString *)target
               content:(NSString *)content
                 token:(NSString *)token
            targetType:(NSString *)targetType
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlCommentReply];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           uid, @"uid",
                           target, @"info_id",
                           content, @"content",
                           token, @"token",
                           targetType, @"model",
                           nil];
    
    [self methodePostName:KHLNotiReplied holder:holder url:ustr arguments:param];
}

#pragma mark - 2.23
- (void)commentlistHUDHolder:(UIView *)holder
                       model:(NSString *)model
                     zhiboid:(NSString *)zhiboid
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlcommentlist];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           model, @"model",
                           zhiboid, @"info_id",
                           nil];
    
    [self methodePostName:KHLNotiCommentListAcquired holder:holder url:ustr arguments:param];
}

#pragma mark - (2.25) 点播分类列表
- (void)categoryListHUDHolder:(UIView *)holder uid:(NSString *)uid token:(NSString *)token
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlCategoryListAcquire];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           uid, @"uid",
                           token, @"token",
                           nil];
    
    [self methodePostName:KHLNotiCategoryListAcquired holder:holder url:ustr arguments:param];
}

//sg 2.26
- (void)goodHUDHolder:(UIView *)holder
                  uid:(NSString *)uid
                token:(NSString *)token
           comment_id:(NSString *)comment_id
                model:(NSString *)model
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlGoodWithComment];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           uid, @"uid",
                           token, @"token",
                           comment_id,@"info_id",
                           model,@"model",
                           nil];
    
    [self methodePostName:KHLNotiCommentLiked holder:holder url:ustr arguments:param];
}

- (void)zanHUDHolder:(UIView *)holder
                 uid:(NSString *)uid
               token:(NSString *)token
             info_id:(NSString *)info_id
               model:(NSString*)model
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlGoodWithComment];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc]initWithObjectsAndKeys:
                           uid, @"uid",
                           token, @"token",
                           info_id, @"info_id",
                           model, @"model",
                           nil];
    
    [self methodePostName:KHLNotiPraised holder:holder url:ustr arguments:param];
}

- (void)badHUDHolder:(UIView *)holder
                 uid:(NSString *)uid
               token:(NSString *)token
          comment_id:(NSString *)comment_id
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlbadWithComment];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           uid, @"uid",
                           token, @"token",
                           comment_id,@"info_id",
                           nil];
    
    [self methodePostName:KHLNotiCommentDisliked holder:holder url:ustr arguments:param];
}

- (void)thirdLogin:(UIView *)holder
        third_type:(NSString *)third_type
           sina_id:(NSString *)sina_id
         tencet_id:(NSString *)tencet_id
    third_username:(NSString*)third_username
{
    NSString *ustr = [NSString stringWithFormat:HKLUrlThrild];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           third_type, @"type",
                           sina_id, @"sina_id",
                           tencet_id,@"open_id",
                           third_username,@"sina_uname",
                           nil];
    
    [self methodePostName:KHLNotiThirdPartyLogin holder:holder url:ustr arguments:param];
}

#pragma mark - 2.24 二级导航
- (void)subpageHUDHolder:(UIView *)holder
                category:(NSString *)category
{
    NSString *ustr = [NSString stringWithFormat:KHLUrlSubpage, category];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self methodeGetName:KHLNotiSubpageAcquired holder:holder url:ustr];
}



#pragma mark - IT'S COOL AND ELEGANT TO DO THIS WAY BUT I DONT KNOW HOW TO CALL

- (void)methodeGetName:(NSString *)notificationName
                holder:(UIView *)holder
                   url:(NSString *)url
{
    // Print methode name and arguments..
    NSLog(@"+ GET  %@: %@", notificationName, url);
    
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    // Create client and try get methode..
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

- (void)methodePostName:(NSString *)notificationName
                 holder:(UIView *)holder
                    url:(NSString *)url
              arguments:(NSDictionary *)arguments
{
    // Print methode name and arguments..
    NSLog(@"+ POST %@: %@", notificationName, arguments);
    
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    // Create client and try post methode..
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client postPath:url parameters:arguments success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}




@end
