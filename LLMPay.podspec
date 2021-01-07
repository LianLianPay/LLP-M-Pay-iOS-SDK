Pod::Spec.new do |s|
    s.name             = 'LLMPay'
    s.version          = '4.1.0'
    s.summary          = '连连支付统一网关支付SDK，LLMPay SDK with gateway_url'
    
    s.description      = <<-DESC
    LLMPaySDK是一个统一网关支付SDK，支持连连支付的认证支付、快捷支付、分期付、银行APP支付等支付方式， 支持短信、TouchID、FaceID等验证方式
    DESC
    
    s.homepage         = 'https://gitee.com/LLPayiOS/LLMPay'
    s.license          = { :type => 'Copyright', :text => '© 2003-2020 Lianlian Yintong Electronic Payment Co., Ltd. All rights reserved.' }
    s.author           = { 'LLPayiOSDev' => 'iosdev@lianlianpay.com' }
    s.source           = { :git => 'https://gitee.com/LLPayiOS/LLMPay.git', :tag => s.version.to_s }
    s.platform = :ios
    s.ios.deployment_target = '8.0'
    s.requires_arc = true
    s.default_subspecs = 'MPay'
    
    s.subspec 'Core' do |cs|
        cs.vendored_library = 'LLMPay/Core/libLLPaySDKCore.a'
        cs.xcconfig = { 'OTHER_LDFLAGS' => '-lObjC'}
    end
    
    s.subspec 'MPay' do |ms|
        ms.vendored_library = 'LLMPay/MPay/libLLMobilePay.a'
        ms.public_header_files = 'LLMPay/MPay/*.h'
        ms.resource = 'LLMPay/MPay/LLMPayResources.bundle'
        ms.dependency 'LLMPay/Core'
        ms.source_files = 'LLMPay/MPay/*.h'
    end
    
    s.subspec 'EBank' do |es|
        es.vendored_library = 'LLMPay/EBank/libLLEBankPay.a'
        es.public_header_files = 'LLMPay/EBank/*.h'
        es.resource = 'LLMPay/EBank/LLEBankResources.bundle'
        es.dependency 'LLMPay/Core'
        es.source_files = 'LLMPay/EBank/*.h'
        es.dependency 'LLMPay/ICBC'
        es.dependency 'LLMPay/CCBLib'
    end
    
    #包含微信支付的新架构SDK
    s.subspec 'Wechat' do |ws|
        ws.vendored_library = 'LLMPay/Wechat/libLLMWeChat.a'
        ws.dependency 'LLMPay/MPay'
        ws.dependency 'WechatOpenSDK', '1.8.5'
    end
    
    s.subspec 'ICBC' do |gs|
        gs.vendored_frameworks = 'LLMPay/ICBC/ICBCPaySDK.framework'
        gs.resource = 'LLMPay/ICBC/ICBCPaySDK.bundle'
        gs.dependency 'AFNetworking','~>3.0'
        gs.dependency 'Toast'
    end
    
    s.subspec 'CCBLib' do |gs|
        gs.vendored_frameworks = 'LLMPay/CCBLib/CCBIFPaySDK.framework'
    end


end
