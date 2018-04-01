//
//  CPSDK.h
//  CPSDK
//
//  Created by 汤昊 on 2018/2/7.
//  Copyright © 2018年 ydld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPConsume.h"
#import "CPDevice.h"
#import "CPDeviceList.h"
#import "CPMessage.h"

//! Project version number for CPSDK.
FOUNDATION_EXPORT double CPSDKVersionNumber;

//! Project version string for CPSDK.
FOUNDATION_EXPORT const unsigned char CPSDKVersionString[];


/**
 *  普通回调
 */
typedef void(^CPSDKCompletionBlock)(NSDictionary * _Nullable resultDic);
/**
 *  网络请求成功的回调
 */
typedef void(^CPSDKSuccessBlock)(NSDictionary * _Nullable responseObject);
/**
 *  网络请求失败的回调
 */
typedef void(^CPSDKFailureBlock)(NSError * _Nullable error);


@protocol CPSDKDelegate;


@interface CPSDK : NSObject


/**
 *  创建单例服务
 *
 *  @return 返回单例对象
 */
+ (CPSDK *_Nullable)sharedCPSDK;

/**
 *  接受游戏结果通知的delegate, 需将游戏房间所在的 controller 设为其代理
 *
 */
@property(nonatomic, weak, nullable) id <CPSDKDelegate> delegate;

/**
 *  sdk初始化
 *  @param appId      appId
 *  @param appSecret      appsecret         生成APPID和SECRET请与友游客服联系
 *  @param completionBlock 初始化成功的回调
 */
+ (void)initWithAppid:(NSString *_Nullable)appId appSecret:(NSString *_Nullable)appSecret callback:(CPSDKCompletionBlock _Nullable )completionBlock;

/**
 *   户id绑定
 *
 *  @param uid      用户Id
 *  @param successBlock 绑定成功的回调
 */
- (void)bindingUid:(NSString *_Nullable)uid success:(CPSDKSuccessBlock _Nullable)successBlock;

/**
 *  获取设备列表
 *
 *  @param roomtype  int 列表类型（0：全部 | 1:最新 | 2：最热）默认全部
 *  @param getpage  int 要展示哪个分页的数据(默认 1)
 *  @param pageCount  int   每页显示的数量(默认 20)
 */
- (void)getDeviceListWithRoomType:(int)roomtype currentPage:(int)getpage countPerPage:(int)pageCount  success:(void (^ __nullable)(CPDeviceList * _Nullable deviceList))successCallback;

/**
 *  获取消费档位列表
 *
 *  @param deviceId  int   设备id
 *  @param successCallback    获取数据成功后的回调
 */
- (void)getConsumeListWithDeviceId:(int)deviceId success:(void (^ __nullable)(NSArray<CPConsume *> * _Nullable consumeList))successCallback;

/**
 *  获取用户币数
 *
 *  @param successBlock  获取成功的回调
 */
- (void)getUserWalletSuccess:(CPSDKSuccessBlock _Nullable )successBlock;

/**
 *  给用户加币
 *
 *  @param coinNum  int 加币数量
 *  @param deviceId  int 设备id，可选参数，数据统计用
 */
- (void)addcoinWithcoinNum:(int)coinNum deviceId:(int)deviceId success:(CPSDKSuccessBlock _Nullable )successBlock;

/**
 *   用户进入房间
 *
 */
- (void)joinRoom;

/**
 *   用户离开房间
 *
 */
- (void)leaveRoom;

/**
 *  使用消费档位游戏，游戏中会通过websocket接受到实时游戏结果，只需实现代理方法即可，如果该机器90s内收不到websocket通知的游戏结果，将自动结束游戏
 *
 *  @param deviceId  int   设备id
 *  @param consumeId  int   消费档位ID
 */
- (void)playGameWithConsumeId:(int)consumeId deviceId:(int)deviceId success:(CPSDKSuccessBlock _Nullable )successBlock;

/**
 *  结束游戏
 *
 *  @param deviceId  int   设备id
 */
- (void)endGameWithDeviceId:(int)deviceId success:(CPSDKSuccessBlock _Nullable )successBlock;

/**
 *  雨刷控制
 *
 *  @param deviceId  int   设备id
 */
- (void)wipeWithDeviceId:(int)deviceId success:(CPSDKSuccessBlock _Nullable )successBlock;

/**
 *  SDK销毁
 *
 *  @return  是否成功
 */
- (BOOL)destroy;


@end



/**
 *  websocket 代理，  玩游戏过程中，是通过 websocket 来通知游戏开始or结束
 *
 */
@protocol CPSDKDelegate <NSObject>

@optional

/**
 *  websocket 关闭时候调用
 *
 */
- (void)CPwebSocketDidCloseWithCode:(NSInteger)code reason:(NSString *_Nullable)reason wasClean:(BOOL)wasClean;

@required
/**
 *  websocket 连接成功
 */
- (void)CPwebSocketdidOpen;
/**
 *  websocket 接受到消息
 *  @param  message   消息
 */
- (void)CPwebSocketdidReceiveMessage:(CPMessage * _Nullable )message;
/**
 *  websocket 连接失败的回调
 *  @param  error   错误信息
 */
- (void)CPwebSocketDidFailWithError:(NSError *_Nullable)error;


@end

