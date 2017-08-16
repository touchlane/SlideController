#
# Be sure to run `pod lib lint SlideController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SlideController'
  s.version          = '0.1.1'
  s.summary          = 'A short description of SlideController.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/PandaSystems/SlideController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Panda System' => 'tech@panda-systems.com' }
  s.source           = { :git => 'https://github.com/PandaSystems/SlideController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'SlideController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SlideController' => ['SlideController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
