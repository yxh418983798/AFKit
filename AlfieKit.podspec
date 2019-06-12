:Pod::Spec.new do |s|
    s.name         = "AlfieKit"
    s.version      = "1.0.0"
    s.ios.deployment_target = '8.0'
    s.summary      = "AFKit，为开发者提供便捷安全的项目框架"
    s.homepage     = "https://github.com/yxh418983798/AFKit.git"
    s.license              = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "Simple" => "418983798@qq.com" }
    s.source       = { :git => "https://github.com/yxh418983798/AFKit.git", :tag => s.version }
    s.source_files  = "AFKit/*"
    s.frameworks = 'Foundation', 'UIKit', 'QuartzCore'
    s.vendored_frameworks = 'AFKit.framework'
    s.requires_arc = true
end
