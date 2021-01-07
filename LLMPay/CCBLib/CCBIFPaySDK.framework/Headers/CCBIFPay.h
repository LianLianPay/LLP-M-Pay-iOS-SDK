//
//  CCBIFPay.h
//  CCBIFPaySDK
//
//  Created by 陈启扬 on 2019/12/25.
//  Copyright © 2019 陈启扬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^CompletionBlock)(NSDictionary * _Nullable dic);

NS_ASSUME_NONNULL_BEGIN

@interface CCBIFPay : NSObject
/**
 *  创建支付单例服务
 *
 *  @return 返回单例对象
 */
+ (instancetype)defaultService;

/**
 *  获取当前版本号
 *
 *  @return 当前版本字符串
 */
- (NSString *)currentVersion;


/**
 支付接口 （合并支付）  能跳转APP则APP跳转支付，否则网页支付
 
 @param orderStr        订单信息 以 key1=value1&key2=value2 拼接
 @param completionBlock 支付结果回调
 */
- (void)payOrder:(NSString *)orderStr
        callback:(CompletionBlock)completionBlock;

/**
 *  处理app支付跳回商户app携带的支付结果Url
 *
 *  @param resultUrl        支付结果url
 *  @param completionBlock  支付结果回调
 *  在application openURL方法 调用
 */
- (void)processOrderWithPaymentResult:(NSURL *)resultUrl
                      standbyCallback:(CompletionBlock)completionBlock;
@end

NS_ASSUME_NONNULL_END
