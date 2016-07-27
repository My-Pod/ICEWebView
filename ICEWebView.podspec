Pod::Spec.new do |s|
s.name             = 'ICEWebView'
s.version          = '1.0.1'
s.summary          = '对WebView的封装'
s.description      = <<-DESC
TODO: 对UIWebView 和 WKWebView 的整合封装
DESC

s.homepage         = 'https://github.com/My-Pod/ICEWebView'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'gumengxiao' => 'rare_ice@163.com' }
s.source           = { :git => 'https://github.com/My-Pod/ICEWebView.git', :tag => s.version.to_s }

s.ios.deployment_target = '7.0'
s.source_files = 'Classes/*.{h,m}'
s.frameworks = 'WebKit'

end
