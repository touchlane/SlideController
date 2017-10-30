Pod::Spec.new do |s|
  s.name             = 'SlideController'
  s.version          = '1.0.0'
  s.summary          = 'SlideController is a controller built for managing page-based UI.'
  s.description      = <<-DESC
  SlideController is replacement for Apple's UIPageControl completely written in Swift using power of generic types.
                       DESC
  s.homepage         = 'https://github.com/touchlane/SlideController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Touchlane LLC' => 'tech@touchlane.com' }
  s.source           = { :git => 'https://github.com/touchlane/SlideController.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'SlideController/Classes/**/*'
end
