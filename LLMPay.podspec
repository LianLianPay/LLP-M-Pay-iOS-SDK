Pod::Spec.new do |s|
    s.name             = 'LLMPay'
    s.version          = '4.0.1'
    s.summary          = 'LLMPay iOS SDK'
    
    s.description      = <<-DESC
    LLMPaySDK是一个统一网关支付SDK，支持连连支付的认证支付、快捷支付、分期付、银行APP支付等支付方式， 支持短信、TouchID、FaceID等验证方式
    DESC
    
    s.homepage         = 'https://gitee.com/LLPayiOS/LLMPay'
    s.license          = { :type => 'Copyright', :text => '© 2003-2019 Lianlian Yintong Electronic Payment Co., Ltd. All rights reserved.' }
    s.author           = { 'LLPayiOSDev' => 'iosdev@lianlianpay.com' }
    s.source           = { :git => 'https://gitee.com/LLPayiOS/LLMPay.git', :tag => s.version.to_s }
    s.platform = :ios
    s.ios.deployment_target = '8.0'
    s.requires_arc = true
    s.default_subspecs = 'MPay'
    
    s.subspec 'Core' do |cs|
        cs.vendored_library = 'LLMPay/Core/*.a'
        cs.xcconfig = { 'OTHER_LDFLAGS' => '-lObjC'}
    end
    
    s.subspec 'MPay' do |ms|
        ms.vendored_library = 'LLMPay/MPay/*.a'
        ms.public_header_files = 'LLMPay/MPay/*.h'
        ms.resource = 'LLMPay/MPay/LLMPayResources.bundle'
        ms.dependency 'LLMPay/Core'
        ms.source_files = 'LLMPay/MPay/*.h'
    end
    
    s.subspec 'EBank' do |es|
        es.vendored_library = 'LLMPay/EBank/*.a'
        es.public_header_files = 'LLMPay/EBank/*.h'
        es.resource = 'LLMPay/EBank/LLEBankResources.bundle'
        es.dependency 'LLMPay/Core'
        es.source_files = 'LLMPay/EBank/*.h'
        
        #ICBC Dependency
        es.dependency 'AFNetworking','~>3.0'
        es.dependency 'Toast'
        es.xcconfig = {'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2'}
        es.libraries = 'xml2'
    end
    
end
