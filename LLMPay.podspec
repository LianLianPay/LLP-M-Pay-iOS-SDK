Pod::Spec.new do |s|
    s.name             = 'LLMPay'
    s.version          = '3.3.2'
    s.summary          = 'LLMPay iOS SDK'
    
    s.description      = <<-DESC
    LLMPaySDK是一个统一网关支付SDK，支持连连支付的认证支付、快捷支付、分期付等支付方式， 支持短信、TouchID、FaceID等验证方式
    DESC
    
    s.homepage         = 'https://gitee.com/LLPayiOS/LLMPay'
    s.license          = { :type => 'CopyRight', :text => '© 2003-2018 Lianlian Yintong Electronic Payment Co., Ltd. All rights reserved.' }
    s.author           = { 'LLPayiOSDev' => 'iosdev@yintong.com.cn' }
    s.source           = { :git => 'https://gitee.com/LLPayiOS/LLMPay.git', :tag => s.version.to_s }
    s.platform = :ios
    s.ios.deployment_target = '8.0'
    s.requires_arc = true
    s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }
    s.source_files = 'LLMPay/**/*.{h,m}'
    s.public_header_files = 'LLMPay/**/*.h'
    s.ios.vendored_library = 'LLMPay/*.a'
    s.resource = 'LLMPay/Assets/*.bundle'
end
