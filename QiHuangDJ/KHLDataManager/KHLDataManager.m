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
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlRegister];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           username, @"username",
                           password, @"password",
                           gender, @"sex",
                           email, @"email",
                           nil];
    NSLog(@"register url=%@ param=%@", ustr, param);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client postPath:ustr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"register succ=\n%@ \n(reason=%@)", json, [json objectForKey:@"reason"]);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiRegistered" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"register fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiRegistered" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 2.2 （2.2）登录
- (void)loginHUDHolder:(UIView *)holder
             loginName:(NSString *)loginName
              password:(NSString *)password
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlLogin];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           loginName, @"loginname",
                           password, @"password",
                           nil];
    NSLog(@"login url=%@ param=%@", ustr, param);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client postPath:ustr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"login succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiLogin" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"login fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiLogin" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 2.3 （2.22）找回密码
- (void)retrievePasswordHUDHolder:(UIView *)holder
                            email:(NSString *)email
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlRetrievePassword];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           email, @"email", nil];
    NSLog(@"retrieve password url=%@ param=%@", ustr, param);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client postPath:ustr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"retrieve password succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiRetrievePassword" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"retrieve password fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiRetrievePassword" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 3.1 （2.3）获取推荐列表
- (void)recommendListHUDHolder:(UIView *)holder
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlRecommendListAcquire];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"recommend ustr=%@", ustr);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client getPath:ustr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"recommend succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiRecommendListAcquired" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"recommend fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiRecommendListAcquired" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 3.2 （2.4）获取订阅列表
- (void)subscriptionListHUDHolder:(UIView *)holder
                              uid:(NSString *)uid
                            token:(NSString *)token
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlSubscriptionListAcquire, uid, token];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"subscription ustr=%@", ustr);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client getPath:ustr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSLog(@"subscription succ=\n%@", json);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiSubscriptionListAcquired" object:json];
        
        // Stop progress HUD..
        [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"subscription fail=\n%@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiSubscriptionListAcquired" object:nil];
        
        // Stop progress HUD..
        [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
    }];
}

#pragma mark - 3.3 （2.5）获取收藏列表
- (void)collectionListHUDHolder:(UIView *)holder
                            uid:(NSString *)uid
                          token:(NSString *)token
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlCollectionListAcquire, uid, token];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"collection ustr=%@", ustr);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client getPath:ustr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSLog(@"collection succ=\n%@", json);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiCollectionListAcquired" object:json];
        
        // Stop progress HUD..
        [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"collection fail=\n%@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiCollectionListAcquired" object:nil];
        
        // Stop progress HUD..
        [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
    }];
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
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
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
    NSLog(@"PIM url=%@ param=%@", ustr, param);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client postPath:ustr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"PIM succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiPersonalInformationModify" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"PIM fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiPersonalInformationModify" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 5.1 （2.7）首页图片（轮播图、背景图）
- (void)homepageImagesHUDHolder:(UIView *)holder
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlHomepageImagesAcquire];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"homepage ustr=%@", ustr);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client getPath:ustr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"homepage succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiHomepageImagesAcquired" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"homepage fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiHomepageImagesAcquired" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 6.1 （2.8）获取直播列表
- (void)liveListHUDHolder:(UIView *)holder
                     type:(NSString *)type
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlLiveListAcquire, type];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"livelist ustr=%@", ustr);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client getPath:ustr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"livelist succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiLiveListAcquired" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"livelist fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiLiveListAcquired" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 6.2 （2.9）获取直播详情
- (void)liveDetailHUDHolder:(UIView *)holder identity:(NSString *)identity uid:(NSString *)uid token:(NSString *)token
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlLiveDetailAcquire];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           identity, @"info_id",
                           uid, @"uid",
                           token, @"token",
                           nil];
    NSLog(@"livedetail url=%@ param=%@", ustr, param);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client postPath:ustr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"livedetail succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiLiveDetailAcquired" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"livedetail fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiLiveDetailAcquired" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 7.1 （2.14）获取点播列表
- (void)VODListHUDHolder:(UIView *)holder
                    type:(NSString *)type
                category:(NSString *)category
                    page:(NSString *)page
                  search:(NSString *)keyword
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlVODListAcquire, type, category, page, keyword];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"vodlist ustr=%@", ustr);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client getPath:ustr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"vodlist succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiVODListAcquired" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"vodlist fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiVODListAcquired" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 7.2 （2.15）获取点播详情
- (void)VODDetailHUDHolder:(UIView *)holder
                  identity:(NSString *)identity
                      type:(NSString *)type
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlVODDetailAcquire, identity, type];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"voddetail ustr=%@", ustr);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client getPath:ustr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"voddetail succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiVODDetailAcquired" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"voddetail fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiVODDetailAcquired" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 8.1 （2.12）订阅
- (void)subscribeHUDHolder:(UIView *)holder
                       uid:(NSString *)uid
                  category:(NSString *)category
                     token:(NSString *)token
{
//    // Start progress HUD..
//    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
//    
//    NSString *ustr = [NSString stringWithFormat:KHLUrlSubscribeCategory, uid, category, token];
//    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"subscribe ustr=%@", ustr);
//    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
//    [client getPath:ustr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         NSError *error;
//         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
//         NSLog(@"subscribe succ=\n%@", json);
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiSubscribeCategory" object:json];
//         
//         // Stop progress HUD..
//         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         NSLog(@"subscribe fail=\n%@", error);
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiSubscribeCategory" object:nil];
//         
//         // Stop progress HUD..
//         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
//     }];
    
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlSubscribeCategory];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           uid, @"uid",
                           category, @"cate_id",
                           token, @"token",
                           nil];
    NSLog(@"subscribe url=%@ param=%@", ustr, param);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client postPath:ustr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"subscribe succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiSubscribeCategory" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"subscribe fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiSubscribeCategory" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 8.2 （2.13）退订
- (void)unsubscribeHUDHolder:(UIView *)holder
                         uid:(NSString *)uid
                    category:(NSString *)category
                       token:(NSString *)token
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlUnsubscribeCategory];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           uid, @"uid",
                           category, @"cate_id",
                           token, @"token",
                           nil];
    NSLog(@"unsubscribe url=%@ param=%@", ustr, param);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client postPath:ustr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"unsubscribe succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiUnsubscribeCategory" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"unsubscribe fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiUnsubscribeCategory" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 9.1 （2.16）添加收藏
- (void)collectArticleHUDHolder:(UIView *)holder
                            uid:(UIView *)uid
                       identity:(UIView *)identity
                       category:(UIView *)category
                          token:(UIView *)token
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlCollectArticle];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           uid, @"uid",
                           identity, @"info_id",
                           category, @"cate_id",
                           token, @"token",
                           nil];
    NSLog(@"collect url=%@ param=%@", ustr, param);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client postPath:ustr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"collect succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiCollectArticle" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"collect fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiCollectArticle" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 9.2 （2.17）取消收藏
- (void)uncollectArticleHUDHolder:(UIView *)holder
                              uid:(NSString *)uid
                         identity:(NSString *)identity
                         category:(NSString *)category
                            token:(NSString *)token
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlUncollectArticle];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           uid, @"uid",
                           identity, @"info_id",
                           category, @"cate_id",
                           token, @"token",
                           nil];
    NSLog(@"uncollect url=%@ param=%@", ustr, param);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client postPath:ustr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"uncollect succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiUncollectArticle" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"uncollect fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiUncollectArticle" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 10.1 （2.18）获取艺人列表
- (void)entertainersListHUDHolder:(UIView *)holder
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlEntertainersListAcquire];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"entertainers ustr=%@", ustr);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client getPath:ustr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"entertainers succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiEntertainersAcquired" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"entertainers fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiEntertainersAcquired" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 11.1 （2.19）获取资讯列表
- (void)informationListHUDHolder:(UIView *)holder
                        category:(NSString *)category
                            type:(NSString *)type
                         keyword:(NSString *)keyword
                            page:(NSString *)page
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlInformationListAcquire, category, type, keyword, page];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"infolist ustr=%@", ustr);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client getPath:ustr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"infolist succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiInformationListAcquired" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"infolist fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiInformationListAcquired" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 11.2 （2.20）获取资讯详情
- (void)informationDetailHUDHolder:(UIView *)holder
                          identity:(NSString *)identity
                              type:(NSString *)type
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlInformationDetailAcquire, identity, type];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"infodetail ustr=%@", ustr);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client getPath:ustr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"infodetail succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiInformationDetailAcquired" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"infodetail fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiInformationDetailAcquired" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 12.1 （2.21）搜索
- (void)searchHUDHolder:(UIView *)holder
                keyword:(NSString *)keyword
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlSearch, keyword];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"search ustr=%@", ustr);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client getPath:ustr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"search succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiSearchResult" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"search fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiSearchResult" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - ?.? （2.11）举报
- (void)reportHUDHolder:(UIView *)holder
               identity:(NSString *)identity
                   type:(NSString *)type
                    uid:(NSString *)uid
                  token:(NSString *)token
             targetType:(NSString *)targetType
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlReport];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           identity, @"info_id",
                           type, @"type",
                           uid, @"uid",
                           token, @"token",
                           targetType, @"model",
                           nil];
    NSLog(@"report url=%@ param=%@", ustr, param);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client postPath:ustr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"report succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiReported" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"report fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiReported" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - ?.? （2.10）评论
- (void)replyHUDHolder:(UIView *)holder
                   uid:(NSString *)uid
                target:(NSString *)target
               content:(NSString *)content
                 token:(NSString *)token
            targetType:(NSString *)targetType
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlCommentReply];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           uid, @"uid",
                           target, @"info_id",
                           content, @"content",
                           token, @"token",
                           targetType, @"model",
                           nil];
    NSLog(@"reply url=%@ param=%@", ustr, param);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client postPath:ustr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"reply succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiReplied" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"reply fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiReplied" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

#pragma mark - 2.23
- (void)commentlistHUDHolder :(UIView *)holder
                          model:(NSString *)model
                      zhiboid:(NSString *)zhiboid {
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlcommentlist];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           model, @"model",
                           zhiboid, @"info_id",
                           nil];
    NSLog(@"reply url=%@ param=%@", ustr, param);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client postPath:ustr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"commentlist succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLUrlcommentlist" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"commentlist fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLUrlcommentlist" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];

}

#pragma mark - (2.25) 点播分类列表
- (void)categoryListHUDHolder:(UIView *)holder uid:(NSString *)uid token:(NSString *)token
{
    // Start progress HUD..
    [MBProgressHUD showHUDAddedTo:holder animated:TRUE];
    
    NSString *ustr = [NSString stringWithFormat:KHLUrlCategoryListAcquire];
    ustr = [ustr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           uid, @"uid",
                           token, @"token",
                           nil];
    NSLog(@"catelist url=%@ param=%@", ustr, param);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHLUrlBase]];
    [client postPath:ustr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"catelist succ=\n%@", json);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiCategoryListAcquired" object:json];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"catelist fail=\n%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"KHLNotiCategoryListAcquired" object:nil];
         
         // Stop progress HUD..
         [MBProgressHUD hideAllHUDsForView:holder animated:TRUE];
     }];
}

@end
