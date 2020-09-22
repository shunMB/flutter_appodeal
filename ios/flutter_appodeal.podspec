#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_appodeal'
  s.version          = '0.0.4'
  s.summary          = 'A Flutter plugin for Appodel SDK'
  s.description      = <<-DESC
A Flutter plugin for Appodel SDK
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'APDAdColonyAdapter', '2.6.5.1' 
  s.dependency 'APDAmazonAdsAdapter', '2.6.5.1' 
  s.dependency 'APDAppLovinAdapter', '2.6.5.1' 
  s.dependency 'APDAppodealAdExchangeAdapter', '2.6.5.1' 
  s.dependency 'APDChartboostAdapter', '2.6.5.1' 
  s.dependency 'APDFacebookAudienceAdapter', '2.6.5.1' 
  s.dependency 'APDGoogleAdMobAdapter', '2.6.5.2' 
  s.dependency 'APDInMobiAdapter', '2.6.5.1' 
  s.dependency 'APDInnerActiveAdapter', '2.6.5.1' 
  s.dependency 'APDIronSourceAdapter', '2.6.5.1' 
  s.dependency 'APDMintegralAdapter', '2.6.5.1' 
  s.dependency 'APDMyTargetAdapter', '2.6.5.1' 
  s.dependency 'APDOguryAdapter', '2.6.5.1' 
  s.dependency 'APDOpenXAdapter', '2.6.5.1' 
  s.dependency 'APDPubnativeAdapter', '2.6.5.1' 
  s.dependency 'APDSmaatoAdapter', '2.6.5.1' 
  s.dependency 'APDStartAppAdapter', '2.6.5.1' 
  s.dependency 'APDTapjoyAdapter', '2.6.5.1' 
  s.dependency 'APDUnityAdapter', '2.6.5.1' 
  s.dependency 'APDVungleAdapter', '2.6.5.1' 
  s.dependency 'APDYandexAdapter', '2.6.5.1' 
  s.static_framework = true
  s.ios.deployment_target = '9.0'
end

