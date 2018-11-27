# LLMPay/EBank

[![Version](https://img.shields.io/cocoapods/v/LLMPay.svg?style=flat)](https://cocoapods.org/pods/LLMPay)
[![License](https://img.shields.io/cocoapods/l/LLMPay.svg?style=flat)](https://cocoapods.org/pods/LLMPay)
[![Platform](https://img.shields.io/cocoapods/p/LLMPay.svg?style=flat)](https://cocoapods.org/pods/LLMPay)

# 连连支付银行APP支付统一网关 iOS SDK 接入指南

> 本指南为连连支付银行APP支付统一网关iOS SDK 模式接入指南， 阅读对象为接入 LLMPay/EBank SDK 的开发者  

## 场景介绍
商户APP调用连连支付提供的 iOS SDK 调用客户端的支付模块。

如果用户安装了对应银行的 APP， 商户 APP 就会跳转到安装的银行 APP 中完成支付， 支付完成后跳回商户APP 内， 最后由商户根据连连支付 SDK 的回调，处理返回的支付结果， 并展示给用户。

如果用户没有安装对应的银行APP， 会在 SDK 内启动 WAP 支付页面进行支付， 支付完成后， 由代理方法返回给商户支付结果。

**商户需要在接收到回调后调用商户服务端的订单查询接口**

## SDK 文件说明

|文件名|                       说明|
|------------------           |-------------------                   |
|libLLPaySDKCore.a            |	SDK base模块                        |
|libLLMPay.a                  |	连连支付银行 APP 支付统一网关 iOS SDK  |
|LLEBankPay.h                 |	SDK 头文件                           |
|LLEBankResources.bundle      |  资源文件， 包含自定义 css 以及图片资源|
|README-EBank.md              |	连连支付银行APP支付统一网关iOS SDK接入指南|
|CHANGELOG.md                 |	更新日志                              |
|BankLib文件夹						|	银行 SDK 与资源                       |

# 集成 SDK

## 一、 使用 Pod 接入

在 podfile 中加入以下代码执行 `pod install` 即可

`pod 'LLMPay/EBank'`

## 二、直接导入工程

### 2.1 导入 SDK 以及 资源文件

1. 导入连连支付LLEBankPay的静态库及相应的 LLEBankResources.bundle 文件（请勿更改 bundle 文件名）
2. 导入对应银行的 SDK 和 bundle 文件

请检查 build phases 中 是否有导入

* libLLEBankPay.a
* libABCAppCaller.a (农行 SDK )
* ICBCPaySDK.framework (工行 SDK )
* CCBNetPaySDK.framework （建行SDK）

Copy Bundle Resources  是否有引入

* LLEBankResources.bundle 
* ICBCPaySDK.bundle (工行资源包)
* CCBSDK.bundle （建行资源包）

接入**工商银行**所需的第三方组件。 主要为[XML组件](https://github.com/neonichu/GDataXML/tree/master/Sources/GDataXML)、网络请求框架 [AFNetWorking](https://github.com/AFNetworking/AFNetworking/)、[base64组件](https://github.com/nicklockwood/Base64) 、[GTM Base 64](https://github.com/r258833095/GTMBase64)、[toast组件](https://github.com/scalessec/Toast)。

## 三、Xcode 配置

> Build Setting

如果使用 CocoaPods， 无需配置

* Other linker flags  
	* 添加 **-ObjC**  解决使用LLEBankPaySDK中分类时出现的Unrecognized Selector的问题
	* 添加**-lxml2**  解决“Libxml/tree.h” file not found
* Header Search Path
	* 添加 **/usr/include/libxml2**  解决“Libxml/tree.h” file not found

> Build Phases 

如果使用 CocoaPods， 无需配置

* Compile sources
	* 找到GTMBase64.m 和 GDataXmlNode.m， 点击右边的Compiler Flags 添加 **-fno-objc-arc** 以禁用ARC
	
> Info

* Plist : Custom iOS Target Properties
* 为了调起银行的 APP ， 需要在 info.plist 中，将银行APP的Scheme添加到白名单中
* 添加 key **LSApplicationQueriesSchemes** ，Type 设置为 NSArray 类型， 并添加以下items (String)
	* mbspay    （中国建设银行）
	* bankabc   （中国农业银行）
	* com.icbc.iphoneclient   （中国工商银行）
	* cmbmobilebank   （招商银行）
	* bocpay    （中国银行）
	
```xml
<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>mbspay</string>
		<string>bankabc</string>
		<string>com.icbc.iphoneclient</string>
		<string>cmbmobilebank</string>
		<string>bocpay</string>
	</array>
```

> URL Types

为了让银行APP在处理完交易后点击返回商户能返回商户的APP， 需要配置商户APP的URL Schemes

* 添加 URL Schemes，设置 Identifier 为 LLEBankScheme, 此处需要添加三个 schemes，  建行与中行需要单独配置，每个 schemes 中间以英文逗号隔开，schemes 格式如下：
	1. schemes 格式为 ll + 商户号 + 字母
	2. schemes 格式为 comccbpay105330173990049+字母如（llebankpay）
	3. schemes 为 bocmcht

```xml
<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLName</key>
			<string>LLEBankScheme</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>ll201310102000003524EbankPay</string>
				<string>comccbpay105330173990049EBankPay</string>
				<string>bocmcht</string>
			</array>
		</dict>
	</array>
```
>  App Transport Security Settings

* **若Allow Arbitrary Loads为NO**，请设置建行的ExceptionDomain
* Info.plist Open As Source Code 然后加入以下Xml代码

```xml
<dict>
		<key>NSAllowsArbitraryLoads</key>
		<false/>
		<key>NSExceptionDomains</key>
		<dict>
			<key>ccb.com.cn</key>
			<dict>
				<key>NSExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSExceptionMinimumTLSVersion</key>
				<string>TLSv1.2</string>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSRequiresCertificateTransparency</key>
				<true/>
				<key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
				<false/>
			</dict>
		</dict>
	</dict>	
```

## 四、代码示例

> 调用 SDK 参数说明  

* gateway_url  创单返回的url，以llebankpay:// 开头

> **使用APP调用**  

```objc
[[LLEBankPay sharedSDK] llEBankPayWithUrl:request.URL.absoluteString complete:^(LLPayResult result, NSDictionary *dic) {
    //在回调中， 根据result与dic处理
}];
```

> **使用WAP调用**  

*WAP中的处理：*

商户需要在wap页面中创单，创完单后，取出gateway_url，直接使用`window.location.href`加载，

*APP中的处理*

在webView的代理方法中拦截scheme `llebankpay`，拦截到后直接使用url的absoluteString调用SDK

```objc
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
```

**支付完成后请务必发起订单结果轮询， 确认支付结果，包括非正常返回情况**

> 回调处理  

需要在APP Delegate中加入以下代码：

```objc
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [LLEBankPay handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [LLEBankPay handleOpenURL:url];
}
```


## 五、SDK返回码说明

|返回码|说明|
|-----|-----|
|LE0000|用户操作完成，请通过轮询查询方式获取订单支付结果|
|	LE0001	|	用户中途取消支付操作	|
|	LE0002	|	交易在WAP中处理完成	|
|	LE0003	|	交易在APP中处理完成	|
|	LE0011	|	交易异常，该SDK并未支持此手机银行	|
|	LE0012	|	商户请求参数校验错误[%s]	|
|	LE1001	|	支付处理失败!	|
|	LE1002	|	交易异常，手机银行IP被禁止	|
|	LE1003	|	交易已支付成功	|
|	LE9001	|	请求接口报文返回异常	|
**请注意，支付完成后必须通过订单查询接口查询订单结果，LE1001支付处理失败也可能是因为没有导入银行的SDK**

## 注意事项
* 本SDK最低支持 iOS 8.0
* 工行SDK暂不支持bitcode

