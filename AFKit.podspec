:Pod::Spec.new do |s|
    s.name         = "AFKit"
    s.version      = "1.0.0"
    s.platform     = :ios, "8.0"    
    s.summary      = "AFKit，为开发者提供便捷安全的项目框架"
    s.homepage     = "https://github.com/yxh418983798/AFKit.git"
    s.license      = "MIT"
    s.author             = { "Alfie" => "418983798@qq.com" }
    s.source       = { :git => "https://github.com/yxh418983798/AFKit.git", :tag => s.version}
    s.source_files  = "AFKit/**/*.{h,m}"
    s.requires_arc = true
end
