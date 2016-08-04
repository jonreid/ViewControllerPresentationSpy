Version 1.1.1
-------------
_04 Aug 2016_

- Change UIAlertController's actual `preferredStyle` instead of keeping it in an associated
  property, to avoid UIKit consistency exceptions. _Thanks to: nirgin_
- Allow `executeActionForButtonWithTitle:` even when no handler was set. _Thanks to: John Foulkes_
- Don't record presentation of non-alerts. _Thanks to: Tom Bates_
- Quiet runtime warning about attempting to load view controller while deallocating.
  _Thanks to: Marcelo Fabri_


Version 1.1.0
-------------
_24 Dec 2015_

- Repackage as Cocoa Touch Framework project.
- Support Carthage.
- CocoaPods: Distinguish between public headers and private headers.


Version 1.0.0
-------------
_23 Aug 2015_

- Initial release. Thanks to Victor Ilyukevich for suggestions, testing, and
cleanup.
