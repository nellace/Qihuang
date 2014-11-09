//
//  LTPlayerSDK.h
//  LetvIphoneClient
//
//  Created by Letv on 13-11-26.
//
//

#import <Foundation/Foundation.h>
//#import "LTPlayerSDK+LTCloudPlayer.h"

/* --------------SDK使用说明--------------------- */
/*
 * 1. 此SDK支持iOS5.0及以上版本
 *
 * 2. 使用此SDK时，除已提供的静态库外，需引用以下苹果官方库：
 *    AudioToolbox.framework
 *    MediaPlayer.framework
 *    UIKit.framework
 *    CoreGraphics.framework
 *    Foundation.framework
 *    ImageIO.framework
 *    SystemConfiguration.framework
 *    CoreTelephony.framework
 *    AdSupport.framework
 *    CoreFoundation.framework
 *    libz.dylib
 *    libicucore.dylib
 *
 * 3. 使用此SDK时，需在工程Build Settings下，Linking中的Other Linker Flag添加-ObjC
 */
/* --------------------------------------------- */


/* 视频码流 */
typedef NS_ENUM(NSInteger, LTVideoCodeType)
{
    LTVideoCodeTypeUnknown  = 0,    // 未知
    
    LTVideoCodeTypeLD       = 1,    // 流畅
    LTVideoCodeTypeSD       = 2,    // 高清
    LTVideoCodeTypeHD       = 3,    // 超清
};

@protocol LTPlayerDelegate <NSObject>

@optional
// 视频播放失败
- (void)LTPlayerFailed;

// 播放结束返回。返回调用播放器显示方法时传入的各个参数值；若未传入ap值，默认为NO.
- (void)LTPlayerActionBackWithUserUnique:(NSString *)userUnique
                             videoUnique:(NSString *)videoUnique
                               videoName:(NSString *)videoName
                                      ap:(BOOL)ap;





//add by zhangyanfang

// 获取播放记录
- (NSTimeInterval)LTPlayerGetCurrentPlaybackTime:(NSString*)vid;

// 设置播放记录
- (void)LTPlayerSetCurrentPlayBackTime:(NSTimeInterval)currentPlaybackTime
                               withVid:(NSString*)vid
                             withTitle:(NSString*)title
                            withWebUrl:(NSString*)webUrl
                          withDuration:(NSTimeInterval)duration;

//// 播放结束返回
//- (void)LTPlayerActionBack:(NSString*)vid;

// 清晰度列表，返回希望播放的VideoCode
- (LTVideoCodeType)LTPlayerVideoCodeType:(NSArray*)videoCodeType withVid:(NSString*)vid;

@end

@interface LTPlayerSDK : NSObject

/*
 @abstract		播放器显示
 @discussion
 @param         userUnique - 乐视云视频分配用户唯一标识
 @param			videoUnique － 视频唯一标识
 @param			videoName － 视频名称
 @param			playerDelegate － 播放器回调
 */
+ (void)showWithUserUnique:(NSString *)userUnique
               videoUnique:(NSString *)videoUnique
                 videoName:(NSString *)videoName
            playerDelegate:(id<LTPlayerDelegate>)playerDelegate;

/*
 @abstract		播放器显示
 @discussion
 @param         userUnique - 乐视云视频分配用户唯一标识
 @param			videoUnique － 视频唯一标识
 @param			videoName － 视频名称
 @param			ap － 是否自动播放
 @param			playerDelegate － 播放器回调
 */
+ (void)showWithUserUnique:(NSString *)userUnique
               videoUnique:(NSString *)videoUnique
                 videoName:(NSString *)videoName
                        ap:(BOOL)ap
            playerDelegate:(id<LTPlayerDelegate>)playerDelegate;
/*
 @abstract		播放器显示
 @discussion
 @param         userUnique - 乐视云视频分配用户唯一标识
 @param			videoUnique － 视频唯一标识
 @param			videoName － 视频名称
 @param			payerName － 收费用户名称
 @param			checkCode － 收费验证码
 @param			ap － 是否自动播放
 @param			playerDelegate － 播放器回调
 */

+ (void)showWithUserUnique:(NSString *)userUnique
               videoUnique:(NSString *)videoUnique
                 videoName:(NSString *)videoName
                 payerName:(NSString *)payerName
                 checkCode:(NSString *)checkCode
                        ap:(BOOL)ap
            playerDelegate:(id<LTPlayerDelegate>)playerDelegate;

+ (void)showWithUserUnique:(NSString *)userUnique
               videoUnique:(NSString *)videoUnique
                 videoName:(NSString *)videoName
                 payerName:(NSString *)payerName
                 checkCode:(NSString *)checkCode
                        ap:(BOOL)ap
          inViewController:(UIViewController *)viewController
            playerDelegate:(id<LTPlayerDelegate>)playerDelegate;

/*
 @abstract		播放器销毁
 @discussion
 @param			animated - 是否有过场动画
 */
+ (void)dismiss:(BOOL)animated;
+ (NSTimeInterval)LTPlayerGetVideoDuration;

@end