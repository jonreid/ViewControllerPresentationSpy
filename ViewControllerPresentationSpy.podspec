Pod::Spec.new do |s|
  s.name     = 'ViewControllerPresentationSpy'
  s.version  = '5.1.0'
  s.summary  = 'Unit test presented view controllers, alerts, and action sheets for iOS'
  s.description = <<-DESC
                    ViewControllerPresentationSpy has three verifiers:
                    * AlertVerifier to capture alerts and action sheets
                    * PresentationVerifier to capture presented view controllers
                    * DismissalVerifier to capture dismissed view controllers

                    Segues can be captured. For alerts, no actual alerts are presented. This means:

                    * The workflow doesn't pause for an action to be selected.
                    * Tests are blazing fast.
                    * You can test things with unit tests instead of UI tests.
                  DESC
  s.homepage = 'https://github.com/jonreid/ViewControllerPresentationSpy'
  s.license  = 'MIT'
  s.author   = { 'Jon Reid' => 'jon@qualitycoding.org' }
  s.social_media_url = 'https://twitter.com/qcoding'
    
  s.ios.deployment_target = '10.0'
  s.source   = { :git => 'https://github.com/jonreid/ViewControllerPresentationSpy.git', :tag => 'v5.1.0' }
  s.source_files = 'Source/ViewControllerPresentationSpy/*.{h,m,swift}'
  s.public_header_files = 'Source/ViewControllerPresentationSpy/QCOMockPopoverPresentationController.h', 'Source/ViewControllerPresentationSpy/UIAlertAction+QCOMock.h', 'Source/ViewControllerPresentationSpy/UIAlertController+QCOMock.h', 'Source/ViewControllerPresentationSpy/UIViewController+QCOMock.h'
  s.requires_arc = true
  s.swift_version = "5.0"
  s.weak_framework = "XCTest"
  s.user_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/Library/Frameworks"',
  }
end
