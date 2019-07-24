Pod::Spec.new do |s|
  s.name     = 'ViewControllerPresentationSpy'
  s.version  = '4.0.0'
  s.summary  = 'Unit test presented view controllers, alerts, and action sheets for iOS'
  s.description = <<-DESC
                    ViewControllerPresentationSpy intercepts presented view controllers, including alerts and actions sheets.

                    Segues can be captured. For alerts, no actual alerts are presented. This means:

                    * The workflow doesn't pause for an action to be selected.
                    * Tests are blazing fast.
                    * You can test things with unit tests instead of UI tests.
                  DESC
  s.homepage = 'https://github.com/jonreid/ViewControllerPresentationSpy'
  s.license  = 'MIT'
  s.author   = { 'Jon Reid' => 'jon@qualitycoding.org' }
  s.social_media_url = 'https://twitter.com/qcoding'
    
  s.ios.deployment_target = '10.2'
  s.source   = { :git => 'https://github.com/jonreid/ViewControllerPresentationSpy.git', :tag => 'v4.0.0' }
  s.source_files = 'Source/ViewControllerPresentationSpy/*.{h,m}'
  s.public_header_files = 'Source/ViewControllerPresentationSpy/QCOMockPopoverPresentationController.h', 'Source/ViewControllerPresentationSpy/UIAlertAction+QCOMock.h', 'Source/ViewControllerPresentationSpy/UIAlertController+QCOMock.h', 'Source/ViewControllerPresentationSpy/UIViewController+QCOMock.h'
  s.requires_arc = true
  s.swift_version = "5.0"
end
