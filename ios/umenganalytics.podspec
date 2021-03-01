#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint umenganalytics.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'umenganalytics'
  s.version          = '0.0.1'
  s.summary          = 'umeng analytics for flutter'
  s.description      = <<-DESC
umeng analytics for flutter
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'UMCommon', '~>7.2.5'
  #s.dependency 'UMCCommon', '~>7.2.5'
  #s.dependency 'UMCAnalytics','~>6.1.0'
  s.dependency 'UMPush'
  #s.dependency 'UMCCommonLog', '2.0.0'

  s.platform = :ios, '8.0'
  s.framework = 'CoreTelephony', 'SystemConfiguration'
  s.libraries = 'z', 'sqlite3'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  
end
