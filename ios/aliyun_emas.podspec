#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint aliyun_emas.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'aliyun_emas'
  s.version          = '0.0.1'
  s.summary          = 'Aliyun emas plugins for Flutter'
  s.description      = <<-DESC
Aliyun emas plugins for Flutter.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Timothy' => 'ygmpkk@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AlicloudPush', '~> 1.9.9.1'
  s.dependency 'AlicloudMANLight', '~> 1.1.0'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
