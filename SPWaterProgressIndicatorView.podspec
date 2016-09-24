#
#  Be sure to run `pod spec lint SPWaterProgressIndicatorView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name                      = "SPWaterProgressIndicatorView"
  s.version                   = "1.1"
  s.summary                   = "A custom subclass of UIView, which indicates the progress of task in percent."

  s.homepage                  = "https://github.com/antonio081014/SPWaterWaveProgressIndicatorView"
  # s.screenshots  = "https://github.com/antonio081014/SPWaterWaveProgressIndicatorView/blob/master/3.gif"

  s.license                   = "MIT"

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author                    = { "Antonio081014" => "antonio081014@antonio081014.com" }
  s.social_media_url          = "http://twitter.com/Antonio081014"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform                  = :ios, "8.0"
  s.ios.deployment_target     = '8.0'
  s.requires_arc              = true

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source                    = { :git => "https://github.com/antonio081014/SPWaterWaveProgressIndicatorView.git", :tag => "#{s.version}" }
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files              = "Pod/SPWaterProgressIndicatorView.swift"

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
end
