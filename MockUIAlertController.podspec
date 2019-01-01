Pod::Spec.new do |s|
  s.name     = 'MockUIAlertController'
  s.version  = '3.1.0'
  s.summary  = 'Mock alerts and action sheets for iOS unit tests'
  s.description = <<-DESC
                    MockUIAlertController lets you mock iOS alerts and action sheets for unit tests.

                    No actual alerts are presented. This means:

                    * The workflow doesn't pause for an action to be selected.
                    * Tests are blazing fast.
                  DESC
  s.homepage = 'https://github.com/jonreid/MockUIAlertController'
  s.license  = 'MIT'
  s.author   = { 'Jon Reid' => 'jon@qualitycoding.org' }
  s.social_media_url = 'https://twitter.com/qcoding'
    
  s.ios.deployment_target = '9.0'
  s.source   = { :git => 'https://github.com/jonreid/MockUIAlertController.git', :tag => 'v3.1.0' }
  s.source_files = 'Source/MockUIAlertController/*.{h,m}'
  s.public_header_files = 'Source/MockUIAlertController/QCOMockAlertVerifier.h', 'Source/MockUIAlertController/QCOMockPopoverPresentationController.h'
  s.requires_arc = true
end