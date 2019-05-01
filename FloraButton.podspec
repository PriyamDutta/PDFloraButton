#
# Be sure to run `pod lib lint FloraButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FloraButton'
  s.version          = '2.0.0'
  s.summary          = 'Use radial floating button for any corners and edges.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Add this library to use the radial floating buttons aka "FloraButtons".
                       DESC

  s.homepage         = 'https://github.com/PriyamDutta/PDFloraButton'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PriyamDutta' => 'iopriyam93@gmail.com' }
  s.source           = { :git => 'https://github.com/PriyamDutta/PDFloraButton.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.swift_version = '4.0'

  s.source_files = 'FloraButton/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FloraButton' => ['FloraButton/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
end
