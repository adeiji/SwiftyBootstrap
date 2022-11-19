#
# Be sure to run `pod lib lint SwiftyBootstrap.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftyBootstrap'
  s.version          = '1.32'
  s.summary          = 'Bootstrap for Swift.'
  s.swift_versions   = ['5.0']

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
My own version of Bootstrap written for Swift and iOS. I wrote this because I felt that iOS needed a library that made it easier to write UIs programmatically that spanned across devices.
                       DESC

  s.homepage         = 'https://github.com/adeiji/SwiftyBootstrap'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'adeiji' => 'adeiji@yahoo.com' }
  s.source           = { :git => 'https://github.com/adeiji/SwiftyBootstrap.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'SwiftyBootstrap/Classes/**/*'
  
  s.dependency 'SnapKit', '5.0.1'
end
