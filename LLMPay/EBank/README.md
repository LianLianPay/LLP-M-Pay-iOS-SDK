# LLMPay/EBank

[![Version](https://img.shields.io/cocoapods/v/LLMPay.svg?style=flat)](https://cocoapods.org/pods/LLMPay)
[![License](https://img.shields.io/cocoapods/l/LLMPay.svg?style=flat)](https://cocoapods.org/pods/LLMPay)
[![Platform](https://img.shields.io/cocoapods/p/LLMPay.svg?style=flat)](https://cocoapods.org/pods/LLMPay)

# 连连支付统一网关 银行APP支付 iOS SDK 接入指南

> 本指南为连连支付银行APP支付统一网关iOS SDK 模式接入指南， 阅读对象为接入 LLMPay/EBank SDK 的开发者  

## 一、场景介绍
商户APP调用连连支付提供的 iOS SDK 调用客户端的支付模块。

如果用户安装了对应银行的 APP， 商户 APP 就会跳转到安装的银行 APP 中完成支付， 支付完成后跳回商户APP 内， 最后由商户根据连连支付 SDK 的回调，处理返回的支付结果， 并展示给用户。

如果用户没有安装对应的银行APP， 会在 SDK 内启动 WAP 支付页面进行支付， 支付完成后， 由代理方法返回给商户支付结果。

**商户需要在接收到回调后调用商户服务端的订单查询接口**

## 二、SDK 文件说明

|文件名|                       说明|
|------------------           |-------------------                   |
|libLLPaySDKCore.a            |	SDK base模块                        |
|libLLMPay.a                  |	连连支付银行 APP 支付统一网关 iOS SDK  |
|LLEBankPay.h                 |	SDK 头文件                           |
|LLEBankResources.bundle      |  资源文件， 包含自定义 css 以及图片资源   |
|README.md                		|	连连支付银行APP支付统一网关iOS SDK接入指南|
|CHANGELOG.md                 |	更新日志                              |

## 三、集成连连银行APP支付 SDK

> 使用 Pod 接入

在 podfile 中加入以下代码执行 `pod install` 即可

`pod 'LLMPay/EBank'`

> 直接导入工程

导入连连支付银行APP支付的静态库、银行framework及相应的 bundle 文件（请勿更改 bundle 文件名）

- 请检查 build phases 中 是否有导入**`*.a`,`*.framework`**

- Copy Bundle Resources  是否有引入**`*.bundle`**
- 若导入工行SDK，请依赖[AFNetWorking](https://github.com/AFNetworking/AFNetworking/)、
[toast组件](https://github.com/scalessec/Toast)这两个第三方库

## 四、Xcode 配置

### 4.1 Build Setting 

**如果使用 CocoaPods， 则无需配置**

* Other linker flags  
	* 添加 **-ObjC**  解决使用LLEBankPaySDK中分类时出现的Unrecognized Selector的问题
	
### 4.2 Info

* Plist : Custom iOS Target Properties
* 为了调起银行的 APP ， 需要在 info.plist 中，将银行APP的Scheme添加到白名单中
* 添加 key **LSApplicationQueriesSchemes** ，Type 设置为 NSArray 类型， 并添加以下items (String)
	* com.icbc.iphoneclient   （中国工商银行）
	* cmbmobilebank   （招商银行）
	* bocpay    （中国银行）

### 4.3 URL Types

为了让银行APP在处理完交易后点击返回商户能返回商户的APP， 需要配置商户APP的 URL Schemes

* 添加 URL Schemes，设置 Identifier 为 **LLEBankScheme**, 此处需要添加 2 个 scheme，  建行与中行需要单独配置，每个 scheme 中间以英文逗号隔开，scheme 格式如下：
	1. scheme 格式为 ll*****
	2. scheme 为 lianlianpay
	
### 4.4 App Transport Security Settings

* **若 Allow Arbitrary Loads 为 NO**，请设置`Allow Arbitrary Loads in Web Content`为YES

## 五、代码示例

### 5.1 调用 SDK 参数说明  

`gateway_url` 为商户服务端请求连连服务端创单API返回的参数，以`llebankpay://` 开头

### 5.2 **使用APP调用**  

```objc
[[LLEBankPay sharedSDK] llEBankPayWithUrl:request.URL.absoluteString complete:^(LLPayResult result, NSDictionary *dic) {
    //在回调中， 根据result与dic处理
}];
```

### 5.3 **使用WAP调用**  

> *WAP中的处理：*

商户需要在wap页面中创单，创完单后，取出gateway_url，直接使用`window.location.href`加载，

> *APP中的处理*

在webView的代理方法中拦截scheme `llebankpay`，拦截到后直接使用url的absoluteString调用SDK

```objc
//UIWebView
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *scheme = request.URL.scheme;
    if ([scheme isEqualToString:@"llebankpay"]) {
        //invoke llebankpay sdk here
        [[LLEBankPay sharedSDK] llEBankPayWithUrl:request.URL.absoluteString complete:^(LLPayResult result, NSDictionary *dic) {
            //在回调中， 根据result与dic处理
        }];
    }
    return YES;
}

//WKWebView
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *requestUrl = [navigationAction.request URL];
    NSString *urlScheme = [requestUrl scheme];
    if ([urlScheme isEqualToString:@"llebankpay"]) {
        //invoke llebankpay sdk here
        [[LLEBankPay sharedSDK] llEBankPayWithUrl:request.URL.absoluteString complete:^(LLPayResult result, NSDictionary *dic) {
            //在回调中， 根据result与dic处理
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
```

**支付完成后请务必发起订单结果轮询， 确认支付结果，包括非正常返回情况**

### 5.4 回调处理  

为了收到银行SDK的回调，需要在APP Delegate中加入以下代码：

```objc
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [LLEBankPay handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [LLEBankPay handleOpenURL:url];
}
```


## 六、SDK返回码说明

|返回码|说明|
|-----|-----|
|  LE0000  |  支付成功  |  
|  LE0002  |  交易在WAP中处理完成  |  
|  LE0003  |  交易在APP中处理完成  |  
|  LE0106  |  银行卡查询失败  |  
|  LE1001  |  SDK签名验证失败  |  
|  LE1004  |  商户请求参数校验错误  |
|  LE1005  |  请求处理失败  |  
|  LE1006  |  用户中途取消操作  |  
|  LE1007  |  网络链接繁忙  |  
|  LE0011  |  交易异常，该SDK并未支持此手机银行  |  
|  LE1020  |  调起该支付方式失败  |  
|  LE1021  |  该设备不支持此支付方式  |  
|  LE1022  |  该银行渠道暂不支持！  |  
|  LE1102  |  输入的卡号有误，请重新输入  |  
|  LE2102  |  获取手机权限失败  |  
|  LE3002  |  支付方式返回异常  |  
|  LE5001  |  卡bin查询失败  |  
|  LE8001  |  钱包用户状态异常  |  
|  LE9912  |  该卡不支持  |  
|  LE9999  |  系统错误  |  

**请注意，支付完成后必须通过订单查询接口查询订单结果，LE1001支付处理失败也可能是因为没有导入银行的SDK**

## 注意事项
* 本SDK最低支持 iOS 8.0

## Author

LLPayiOSDev, iosdev@lianlianpay.com

## License

© 2003-2019 Lianlian Yintong Electronic Payment Co., Ltd. All rights reserved.

