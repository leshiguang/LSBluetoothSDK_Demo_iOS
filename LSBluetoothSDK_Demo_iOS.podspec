#
# Be sure to run `pod lib lint LSBluetoothSDK_Demo_iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LSBluetoothSDK_Demo_iOS'
  s.version          = '0.1.0'
  s.summary          = 'A short description of LSBluetoothSDK_Demo_iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/alex.wu/LSBluetoothSDK_Demo_iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'alex.wu' => 'alex.wu@dianping.com' }
  s.source           = { :git => 'https://github.com/alex.wu/LSBluetoothSDK_Demo_iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LSBluetoothSDK_Demo_iOS/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LSBluetoothSDK_Demo_iOS' => ['LSBluetoothSDK_Demo_iOS/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'LSBluetoothSDK_iOS'
   s.libraries = "z", "c++", "stdc++"
   s.static_framework = true
end
