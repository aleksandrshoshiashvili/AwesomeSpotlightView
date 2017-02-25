#
#  Be sure to run `pod spec lint AwesomeSpotlightView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name             = 'AwesomeSpotlightView'
  s.version          = '0.1.0'
  s.summary          = 'Awesome tool for create tutorial or coach tour'

   s.description      = <<-DESC
Awesome TextField is a nice and simple library for iOS and Mac OSX. It's highly customizable and easy-to-use tool. Works perfectly for any registration or login forms in your app.
                       DESC

  s.homepage         = 'https://github.com/aleksandrshoshiashvili/AwesomeSpotlightView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aleksandrshoshishvili' => 'aleksandr.shoshishvili@gmail.com' }
  s.source           = { :git => 'https://github.com/aleksandrshoshiashvili/AwesomeSpotlightView.git', :tag => 'v0.1.0' }

  s.ios.deployment_target = '8.0'

  s.source_files  = 'AwesomeSpotlightView/Classes/**/*'

end
