Pod::Spec.new do |s|
  s.name             = 'SlideController'
  s.version          = '1.5.2'
  s.summary          = 'SlideController is replacement for Apple\'s UIPageControl completely written in Swift using power of generic types.'
  s.description      = <<-DESC
  Swipe between pages with an interactive title navigation control. Configure horizontal or vertical chains for unlimited pages amount.
                       DESC
  s.homepage         = 'https://github.com/BetsOnTee/SlideController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Touchlane LLC' => 'tech@touchlane.com' }
  s.source           = { :git => 'https://github.com/BetsOnTee/SlideController.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'
  s.source_files = 'Source/*.swift'
end
