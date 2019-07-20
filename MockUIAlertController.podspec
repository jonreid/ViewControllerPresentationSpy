Pod::Spec.new do |s|
  s.name     = 'ViewControllerPresentationSpy'
  s.version  = '3.2.0'
  s.summary  = 'Mock alerts and action sheets for iOS unit tests'
  s.description = <<-DESC
                    ViewControllerPresentationSpy lets you mock iOS alerts and action sheets for unit tests.

                    No actual alerts are presented. This means:

                    * The workflow doesn't pause for an action to be selected.
                    * Tests are blazing fast.
                  DESC
  s.homepage = 'https://github.com/jonreid/ViewControllerPresentationSpy'
  s.license  = 'MIT'
  s.author   = { 'Jon Reid' => 'jon@qualitycoding.org' }
  s.social_media_url = 'https://twitter.com/qcoding'
    
  s.ios.deployment_target = '9.0'
  s.source   = { :git => 'https://github.com/jonreid/ViewControllerPresentationSpy.git', :tag => 'v3.2.0' }
  s.source_files = 'Source/ViewControllerPresentationSpy/*.{h,m}'
  s.public_header_files = 'Source/ViewControllerPresentationSpy/QCOMockAlertVerifier.h', 'Source/ViewControllerPresentationSpy/QCOMockPopoverPresentationController.h'
  s.requires_arc = true
end