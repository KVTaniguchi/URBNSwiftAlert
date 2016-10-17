#
# Be sure to run `pod lib lint URBNSwiftAlert.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'URBNSwiftAlert'
  s.version          = '0.1.0'
  s.summary          = 'A swift version of URBNAlert by Ryan Garchinsky.'


  s.homepage         = 'https://github.com/kvtaniguchi/URBNSwiftAlert'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kevin Taniguchi' => 'kv.taniguchi@gmail.com' }
  s.source           = { :git => 'https://github.com/kvtaniguchi/URBNSwiftAlert.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'URBNSwiftAlert/Classes/**/*'
  
  # s.resource_bundles = {
  #   'URBNSwiftAlert' => ['URBNSwiftAlert/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
