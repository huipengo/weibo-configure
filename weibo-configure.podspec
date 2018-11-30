#
# Be sure to run `pod lib lint weibo-configure.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'weibo-configure'
    s.version          = '0.0.1'
    s.summary          = 'weibo-configure is a developer debug Tool...'

    s.homepage         = 'https://github.com/huipengo/weibo-configure'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'huipengo' => 'penghui_only@163.com' }
    s.source           = { :git => 'https://github.com/huipengo/weibo-configure.git', :tag => s.version.to_s }

    s.ios.deployment_target = '9.0'
    s.requires_arc = true

    s.frameworks = "UIKit", "Foundation"

    s.default_subspec = 'wb-service-configure'

    s.subspec 'wb-motion' do |ss|
        ss.source_files = 'Pod/Classes/Motion/*.{h,m}'
        ss.dependency 'weibo-configure/wb-service-configure'
        ss.dependency 'weibo-configure/wb-fps'
        ss.dependency 'weibo-configure/wb-flex'
    end

    s.subspec 'wb-service-configure' do |ss|
        ss.source_files = 'Pod/Classes/Service/*.{h,m}'
        ss.resources    = 'Pod/Classes/Service/*.{bundle,xib}'
        ss.dependency "YYModel", ">= 1.0.4"
        ss.dependency "MBProgressHUD", ">= 1.1.0"
    end

    s.subspec 'wb-fps' do |ss|
        ss.source_files = 'Pod/Classes/FPS/*.{h,m}'
    end
    
    s.subspec 'wb-flex' do |ss|
        ss.source_files = 'Pod/Classes/FLEX_io/**/*.{h,m}'
    end
  
end
