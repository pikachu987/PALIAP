#
# Be sure to run `pod lib lint PALIAP.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PALIAP'
  s.version          = '0.1.0'
  s.summary          = 'PALIAP'
  s.description      = <<-DESC
My Lib PALIAP
                       DESC
  s.homepage         = 'https://github.com/pikachu987/PALIAP'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pikachu987' => 'pikachu77769@gmail.com' }
  s.source           = { :git => 'https://github.com/pikachu987/PALIAP.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'PALIAP/Classes/**/*'
  s.swift_version = '5.0'
end
