Pod::Spec.new do |s|
  s.name             = 'SlideController'
  s.version          = '1.2.1'
  s.summary          = 'SlideController is replacement for Apple\'s UIPageControl completely written in Swift using power of generic types.'
  s.description      = <<-DESC
  Swipe between pages with an interactive title navigation control. Configure horizontal or vertical chains for unlimited pages amount.
                       DESC
  s.homepage         = 'https://github.com/touchlane/SlideController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Touchlane LLC' => 'tech@touchlane.com' }
  s.source           = { :git => 'https://github.com/touchlane/SlideController.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'Source/*.swift'
end
