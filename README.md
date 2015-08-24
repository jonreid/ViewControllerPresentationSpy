# MockUIAlertController

[![Build Status](https://travis-ci.org/jonreid/MockUIAlertController.svg?branch=master)](https://travis-ci.org/jonreid/MockUIAlertController)
[![Coverage Status](https://coveralls.io/repos/jonreid/MockUIAlertController/badge.svg?branch=master&service=github)](https://coveralls.io/github/jonreid/MockUIAlertController?branch=master)
[![Cocoapods Version](https://cocoapod-badges.herokuapp.com/v/MockUIAlertController/badge.png)](http://cocoapods.org/?q=MockUIAlertController)

MockUIAlertController lets you mock iOS alerts and action sheets for unit tests,
based on the UIAlertController introduced for iOS 8.

(For old UIAlertView or UIActionSheet mocking, use
[MockUIAlertViewActionSheet](https://github.com/jonreid/MockUIAlertViewActionSheet).)

No actual alerts are presented. This means:

* The workflow doesn't pause for an action to be selected
* Tests are blazing fast.


## What do I need to change in production code?

Nothing.

## What can I test?

1. Instantiate a `QCOMockAlertVerifier` before the execution phase of the test.
2. Invoke the code to create and present your alert or action sheet.

Information about the alert or action sheet is then available through the
[QCOMockAlertVerifier](https://github.com/jonreid/MockUIAlertController/blob/master/TestSupport/QCOMockAlertVerifier.h).

For example, here's a test verifying the title. `sut` is the system under test
in the test fixture.

```obj-c
- (void)testShowAlert_AlertShouldHaveTitle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    XCTAssertEqualObjects(alertVerifier.title, @"Title");
}
```

See the sample app for more examples. One set of examples use
[OCHamcrest assertions](https://github.com/hamcrest/OCHamcrest), but OCHamcrest
is not required.


## How can I invoke the block associated with a UIAlertAction?

Go through steps 1 and 2 above to present your alert or action sheet using
`QCOMockAlertController`. Then call `-executeActionForButtonWithTitle:` on your
`QCOMockAlertVerifier` with the button title.
