/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                        使用声明                                                  //
//                                 1、可选参数不填赋值nil                                             //
//                                 2、所有参数为NSString类型（completeBlock除外）                      //
/////////////////////////////////////////////////////////////////////////////////////////////////////

typedef enum  CYStatusCode
{
    CYSuccess           = 0,    /* 成功 */
    CYParamsError       = 1,    /* 参数错误 */
    CYLoginError        = 2,    /* 登录错误 */
    CYOtherError        = 3,    /* 其他错误 */
}CYStatusCode;

typedef void (^CompleteBlock)(CYStatusCode statusCode,NSString *responseStr);

#define kChangyanLoginNotification @"kChangyanLoginNotification"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChangyanSDK : NSObject

#pragma mark ------- 配置接口 -------

/*
 *  功能 : 配置APP必须参数
 *  参数 :
 *        appID                 :必须,系统后台分配的appID [一定要用自己的 不要用demo中的]
 *        appKey                :必须,系统后台分配的appKey [一定要用自己的 不要用demo中的]
 *        redirectUrl           :必须,系统后台配置的redirectUrl [一定要用自己的 不要用demo中的]
 *        anonymousAccessToken  :必选,系统后台配置的匿名登陆token [一定要用自己的 不要用demo中的]
 *  返回 : 无
 */
+ (void)registerApp:(NSString *)appID appKey:(NSString *)appKey redirectUrl:(NSString *)redirectUrl anonymousAccessToken:(NSString *) token;

/*
 *  功能 : 设置是否允许匿名发表评论  默认YES
 */
+ (void)setAllowAnonymous:(BOOL)value;

/*
 *  功能 : 设置是否允许发表评论的时候进行打分  默认YES
 */
+ (void)setAllowRate:(BOOL)value;

/*
 * 功能 : 设置是否允许上传图片  默认YES
 */
+ (void)setAllowUpload:(BOOL)value;

/*
 * 功能 : 设置是否有自己的登陆入口,如果有,则必须使用setLoginViewController接口配置自己的loginViewController  默认 NO
 */
+ (void)setAllowSelfLogin:(BOOL)value;

/*
 * 功能 : 设置是否允许第三方登陆搜狐登陆  默认YES
 */
+ (void)setAllowHohuLogin:(BOOL)value;

/*
 * 功能 : 设置是否允许第三方登陆微博登陆  默认YES
 */
+ (void)setAllowWeiboLogin:(BOOL)value;

/*
 * 功能 : 设置是否允许第三方登陆QQ登陆  默认YES
 */
+ (void)setAllowQQLogin:(BOOL)value;

/*
 * 功能 : 设置自己的登陆界面
 */
+ (void)setLoginViewController:(UIViewController *)loginController;

/*
 * 功能 : 设置评列表下方评论入口悬浮框 不设置则使用默认的
 */
+ (void)setFloatPostButton:(UIButton *)postCommentButton;

/*
 * 功能 : 设置导航栏背景颜色(ios6及其以下版本无效) 不设置则使用默认的
 */
+ (void)setNavigationBackgroundColor:(UIColor *)color;

/*
 * 功能 : 设置导航栏文字颜色(ios6及其以下版本无效) 不设置则使用默认的
 */
+ (void)setNavigationTintColor:(UIColor *)color;


#pragma mark ------- 界面接口 -------
/*
 *  功能 : 获取畅言发评论接口
 *  参数 :
 *        postCommentRect          :如果不传postButton,将使用postCommentRect,如果传入postButton,此处应传入postButton.frame
 *        postButton               :可选,若传入postButton,则使用传入的postButton
 *        topicUrl                 :新发文章必选 (新发文章没有topicID,此处用来生成topicID)
 *        topicSourceID            :可选,文章sourceID (在topicUrl与sourceID都提供的情况下优先使用sourceID)
 *        topicID                  :可选,(topicID是畅言生成的id 若已获取到topicID 尽量使用topicID)
 *        categoryID               :可选,频道ID (用于分频道)
 *        topicTitle               :文章标题 (可选)
 *  返回 : UIView
 */
+ (id)getPostCommentBar:(CGRect)postCommentRect
      postCommentButton:(UIButton *)postButton
               topicUrl:(NSString *)topicUrl
          topicSourceID:(NSString *)topicSourceID
                topicID:(NSString *)topicID
             categoryID:(NSString *)categoryID
             topicTitle:(NSString *)topicTitle
                 target:(UIViewController *)baseController;

/*
 *  功能 : 获取评论list接口
 *  参数 :
 *        listCommentRect          :如果不传postButton,将使用postCommentRect,如果传入postButton,此处应传入postButton.frame
 *        listButton               :可选,若传入postButton,则使用传入的postButton
 *        topicUrl                 :新发文章必选 (新发文章没有topicID,此处用来生成topicID)
 *        topicSourceID            :可选,文章sourceID (在topicUrl与sourceID都提供的情况下优先使用sourceID)
 *        topicID                  :可选,(topicID是畅言生成的id 若已获取到topicID 尽量使用topicID)
 *        categoryID               :频道ID (可选, 用于分频道)
 *        topicTitle               :文章标题 (可选)
 *  返回 : UIView
 */
+ (id)getListCommentBar:(CGRect)listCommentRect
      listCommentButton:(UIButton *)listButton
               topicUrl:(NSString *)topicUrl
          topicSourceID:(NSString *)topicSourceID
                topicID:(NSString *)topicID
             categoryID:(NSString *)categoryID
             topicTitle:(NSString *)topicTitle
                 target:(UIViewController *)baseController;

/*
 *  功能 : 获取默认tool bar接口 包括一个发评论按钮和一个列表按钮
 *  参数 :
 *        barRect                  :整个tool bar的 frame (必须)
 *        postRect                 :发评论按钮的 frame (必须, 其位置相对于barRect)
 *        listRect                 :评论列表的 frame (必须, 其位置相对于barRect)
 *        topicUrl                 :新发文章必选 (新发文章没有topicID,此处用来生成topicID)
 *        topicSourceID            :可选,文章sourceID (在topicUrl与sourceID都提供的情况下优先使用sourceID)
 *        topicID                  :可选,(topicID是畅言生成的id 若已获取到topicID 尽量使用topicID)
 *        categoryID               :频道ID (可选, 用于分频道)
 *        topicTitle               :文章标题 (可选)
 *  返回 : UIView
 */
+ (id)getDefaultCommentBar:(CGRect)barRect
            postButtonRect:(CGRect)postRect
            listButtonRect:(CGRect)listRect
                  topicUrl:(NSString *)topicUrl
             topicSourceID:(NSString *)topicSourceID
                   topicID:(NSString *)topicID
                categoryID:(NSString *)categoryID
                topicTitle:(NSString *)topicTitle
                    target:(UIViewController *)baseController;

/* 功能 : 获取评论发表框  UIViewController (使用了UINavigatonBar)
 *        topicUrl                 :新发文章必选 (新发文章没有topicID,此处用来生成topicID)
 *        topicSourceID            :可选,文章sourceID (在topicUrl与sourceID都提供的情况下优先使用sourceID)
 *        topicID                  :可选,(topicID是畅言生成的id 若已获取到topicID 尽量使用topicID)
 *        categoryID               :频道ID (可选, 用于分频道)
 *        topicTitle               :文章标题 (可选)
 *        replyPlaceHolder         :评论框placeholder
 * 返回 : UIViewController
 */
+ (id)getPostCommentViewController:(NSString *)topicUrl
                           topicID:(NSString *)topicID
                     topicSourceID:(NSString *)topicSourceID
                        categoryID:(NSString *)categoryID
                        topicTitle:(NSString *)topicTitle
                  replyPlaceHolder:(NSString *)replyPlaceHolder;

/* 功能 : 获取评论列表页  UIViewController (使用了UINavigatonBar)
 *        topicUrl                 :新发文章必选 (新发文章没有topicID,此处用来生成topicID)
 *        topicSourceID            :可选,文章sourceID (在topicUrl与sourceID都提供的情况下优先使用sourceID)
 *        topicID                  :可选,(topicID是畅言生成的id 若已获取到topicID 尽量使用topicID)
 *        categoryID               :频道ID (可选, 用于分频道)
 *        topicTitle               :文章标题 (可选)
 * 返回 : UIViewController
 */
+ (id)getListCommentViewController:(NSString *)topicUrl
                           topicID:(NSString *)topicID
                     topicSourceID:(NSString *)topicSourceID
                        categoryID:(NSString *)categoryID
                        topicTitle:(NSString *)topicTitle;

#pragma mark ------ 数据接口 -----
/*
 *  功能 : 获取文章及评论信息，文章不存在则创建
 *  参数 :
 *        topicURL      : 必选
 *        topicTitle    : 可选
 *        topicSourceID : 可选,文章sourceID (同上, 在topicUrl与sourceID都提供的情况下优先使用sourceID)
 *        pageSize      : (可选,默认为0)
 *        hotSize       : (可选,默认为0)
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)loadTopic:(NSString *)topicUrl
       topicTitle:(NSString *)topicTitle
    topicSourceID:(NSString *)topicSourceID
         pageSize:(NSString *)pageSize
          hotSize:(NSString *)hotSize
    completeBlock:(CompleteBlock)completeBlock;


/*
 *  功能 : 获取评论数
 *  参数 :
 *        topicUrl       : (三个必须提供一个)
 *        topicSourceID  : (三个必须提供一个)
 *        topicID        : (三个必须提供一个)
 *        completeBlock  : 回调
 *  返回 : 无
 */
+ (void)getCommentCount:(NSString *)topicID
          topicSourceID:(NSString *)topicSourceID
               topicUrl:(NSString *)topicUrl
          completeBlock:(CompleteBlock)completeBlock;


/*
 *  功能 : 批量获取文章评论数, 批量接口无法实时更新缓存, 所以此接口非实时
 *  参数 :
 *        topicIds        : (文章唯一标识，topicSourceIds topicUrls topicIds 任选其一) 优先级最高
 *        topicSourceIds  : (文章唯一标识，topicSourceIds topicUrls topicIds 任选其一) 优先级次之
 *        topicUrls       : (文章唯一标识，topicSourceIds topicUrls topicIds 任选其一) 优先级最低
 *        completeBlock   : 回调
 *  返回 : 无
 */
+ (void)getCommentCounts:(NSString *)topicIDs
          topicSourceIds:(NSString *)topicSourceIDs
               topicUrls:(NSString *)topicUrls
           completeBlock:(CompleteBlock)completeBlock;


/*
 *  功能 : 分页获取文章评论列表
 *  参数 :
 *        topicID       : (必须)
 *        pageSize      : (可填,默认30)
 *        pageNo        : (可填,默认1)
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)getTopicComments:(NSString *)topicID
                pageSize:(NSString *)pageSize
                  pageNo:(NSString *)pageNo
           completeBlock:(CompleteBlock)completeBlock;

/*
 *  功能 : 获取Topic某个comment的回复列表
 *  参数 :
 *        topicID       : 文章ID(必须)
 *        commentID     : 评论ID(必须)
 *        pageSize      : (可填,默认30)
 *        pageNo        : (可填,默认1)
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)getCommentReplies:(NSString *)topicID
                commentID:(NSString *)commentID
                 pageSize:(NSString *)pageSize
                   pageNo:(NSString *)pageNo
            completeBlock:(CompleteBlock)completeBlock;


/*
 *  功能 : 顶或者踩某条评论
 *  参数 :
 *        actionType    : (必须) 1:顶 2:踩
 *        topicID       : 文章ID(必须)
 *        commentID     : 评论ID(必须)
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)commentAction:(NSInteger)actionType
              topicID:(NSString *)topicID
            commentID:(NSString *)commentID
        completeBlock:(CompleteBlock)completeBlock;


/*
 *  功能 : 获取topic的平均分
 *  参数 :
 *        topicID        : 畅言新闻id(三个必须提供一个)
 *        topicSourceID  : 新闻在本网站中的id(三个必须提供一个)
 *        topicUrl       : 新闻url(三个必须提供一个)
 *        simple         : 是否查询所有带有评分的评论，true：不查询，false：查询
 *        completeBlock  : 回调
 *  返回 : 无
 */
+ (void)getTopicAverageScore:(NSString *)topicID
               topicSourceID:(NSString *)topicSourceID
                    topicUrl:(NSString *)topicUrl
                      simple:(BOOL)simple
               completeBlock:(CompleteBlock)completeBlock;

/*
 *  功能 : 获取topic最新评分评论
 *  参数 :
 *        topicID        : 畅言新闻id(三个必须提供一个)
 *        topicSourceID  : 新闻在本网站中的id(三个必须提供一个)
 *        topicUrl       : 新闻url(三个必须提供一个)
 *        count          : 评论数 默认 5
 *        completeBlock  : 回调
 *  返回 : 无
 */
+ (void)getTopicScoreComments:(NSString *)topicID
                topicSourceID:(NSString *)topicSourceID
                     topicUrl:(NSString *)topicUrl
                        count:(NSInteger )count
                completeBlock:(CompleteBlock)completeBlock;


/*
 *  功能 : 匿名发表评论
 *  参数 :
 *        topicID       : 要评论的话题ID(必须)
 *        content       : 评论内容(必须)
 *        replyID       : 回复的评论ID (可选,用于评论回复)
 *        score         : 对topic的评分（可选,默认0分）
 *        appType       : 40:iPhone 41:iPad 42:Android
 *        picUrls       : 附带图片URL数组,url中不能包含“,"
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)anonymousSubmitComment:(NSString *)topicID
                       content:(NSString *)content
                       replyID:(NSString *)replyID
                         score:(NSString *)score
                       appType:(NSInteger )appType
                       picUrls:(NSArray *)picUrls
                 completeBlock:(CompleteBlock)completeBlock;


/*
 *  功能 : 获取站点后台配置的匿名用户信息
 *  参数 : completeBlock : 回调
 *  返回 : 无
 */
+ (void)getAnonymousUserInfo:(CompleteBlock)completeBlock;

#pragma mark ------ 登陆接口 ------

/*
 *  功能 : 判断用户是否登录或者登陆是否过期
 *  参数 : 无
 *  返回 : YES:登录 NO:未登陆
 */
+ (BOOL)isLogin;

/*
 *  功能 : 登出
 *  参数 : 无
 *  返回 : 无
 */
+ (void)logout;

/*
 *  功能 : Oauth2登录
 *  参数 :
 *        platform      : 登陆平台 3:QQ 2:新浪 11:搜狐
 *        platform      : 2:新浪 3:QQ 11:搜狐
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)thirdPartLogin:(NSInteger)platform
         completeBlock:(CompleteBlock)completeBlock;

/*
 *  功能 : 单点登录
 *  参数 :
 *        isvUserID     : 站点用户的ID (必须)
 *        nickName      : 站点用户的用户名 (必须)
 *        profileUrl    : 站点用户的个人主页
 *        imgUrl        : 站点用户的用户头像
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)loginSSO:(NSString *)userID
        userName:(NSString *)nickName
      profileUrl:(NSString *)profileUrl
          imgUrl:(NSString *)imgUrl
   completeBlock:(CompleteBlock)completeBlock;

/*
 *  功能 : 获取登陆用户信息
 *  参数 : completeBlock : 回调
 *  返回 : 无
 */
+ (void)getUserInfo:(CompleteBlock)completeBlock;

#pragma mark ----- 需登陆数据接口 ----
/*
 *  功能 : 提交评论或者回复某条评论
 *  参数 :
 *        topicID       : 要评论的话题ID(必须)
 *        content       : 评论内容(必须)
 *        replyID       : (可填, 若为评论回复则必须传被回复评论的ID)
 *        score         : 评分（可选，若不打分请传nil）
 *        appType       : 40:iPhone 41:iPad 42:Android
 *        picUrls       : 附带图片URL数组,url不能包含","
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)submitComment:(NSString *)topicID
              content:(NSString *)content
              replyID:(NSString *)replyID
                score:(NSString *)score
              appType:(NSInteger )appType
              picUrls:(NSArray *)picUrls
        completeBlock:(CompleteBlock)completeBlock;

/*
 *  功能 : 获取用户最新回复（需要登录）
 *  参数 :
 *        pageSize       : (可填,默认10)
 *        pageNo         : (可填,默认1)
 *        completeBlock  : 回调
 *  返回 : 无
 */
+ (void)getUserNewReply:(NSString *)pageSize
                 pageNo:(NSString *)pageNo
          completeBlock:(CompleteBlock)completeBlock;

#pragma mark ----- 其他接口 ----
/*
 *  功能 : 上传评论的附属文件，应该是图片（需要登录）
 *  参数 :
 *        fileData      : 上传文件的二进制数据
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)uploadAttach:(NSData *)fileData
       completeBlock:(CompleteBlock)completeBlock;
@end
