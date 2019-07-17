//
//  LLEBankPay.h
//  LLEBankPay
//
//  Created by EvenLin on 2018/4/24.
//  Copyright © 2018年 LianLian Pay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum LLPayResult {
    kLLPayResultSuccess = 0,      /**< 支付成功 */
    kLLPayResultFail = 1,         /**< 支付失败 */
    kLLPayResultCancel = 2,       /**< 支付取消，用户行为 */
    kLLPayResultInitError,        /**< 支付初始化错误，订单信息有误，签名失败等 */
    kLLPayResultInitParamError,   /**< 支付订单参数有误，无法进行初始化，未传必要信息等 */
    kLLPayResultUnknow,           /**< 其他 */
    kLLPayResultRequestingCancel, /**< 授权支付后取消(支付请求已发送) */
} LLPayResult;

@interface LLEBankPay : NSObject

+ (nonnull instancetype)sharedSDK;

/**
 SDK 默认由 window.rootVC present, 若已占用,请自定义
 */
@property (nonatomic, strong, nullable) UIViewController *customVC;


/**
 调用银行 APP 支付 SDK
 
 @param gatewayUrl 创单获取到的 gatewayUrl
 @param complete  回调
 */
- (void)llEBankPayWithUrl:(nonnull NSString *)gatewayUrl complete:(nonnull void(^)(LLPayResult result, NSDictionary<NSString *,NSString *> *_Nullable dic))complete;


/**
 处理银行 APP 回调
 
 @param url  url
 @return bool
 */
+ (BOOL)handleOpenURL:(nullable NSURL *)url;

/**
 获取SDK当前版本
 
 @return 版本号
 */
+ (nonnull NSString *)getSDKVersion;

/**
 *  切换正式、测试服务器（默认不调用是正式环境，请不要随意使用该函数切换至测试环境）
 *
 *  @param isTestServer YES测试环境，NO正式环境
 */
+ (void)switchToTestServer:(BOOL)isTestServer;

@end
