# MockUIAlertController

[![Build Status](https://travis-ci.org/jonreid/MockUIAlertController.svg?branch=master)](https://travis-ci.org/jonreid/MockUIAlertController)
[![Coverage Status](https://coveralls.io/repos/jonreid/MockUIAlertController/badge.svg?branch=master&service=github)](https://coveralls.io/github/jonreid/MockUIAlertController?branch=master)
[![CocoaPods Version](https://cocoapod-badges.herokuapp.com/v/MockUIAlertController/badge.png)](https://cocoapods.org/pods/MockUIAlertController)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

MockUIAlertController lets you mock iOS alerts and action sheets for unit tests. It works for Swift as well as Objective-C.

(For old UIAlertView or UIActionSheet mocking, use
[MockUIAlertViewActionSheet](https://github.com/jonreid/MockUIAlertViewActionSheet).)

No actual alerts are presented. This means:

* The workflow doesn't pause for an action to be selected
* Tests are blazing fast.

For more discussion, see my blog post [How to Test UIAlertControllers and Control Swizzling](http://qualitycoding.org/testing-uialertcontrollers/).


## Writing Tests

### What do I need to change in production code?

Nothing.

## How do I test an alert controller?

1. `#import <MockUIAlertController/QCOMockAlertVerifier.h>` (or add it to your Swift test target's bridging header)
2. Instantiate a `QCOMockAlertVerifier` before the execution phase of the test.
3. Invoke the code to create and present your alert or action sheet.

Information about the alert or action sheet is then available through the
[QCOMockAlertVerifier](https://github.com/jonreid/MockUIAlertController/blob/master/Source/MockUIAlertController/QCOMockAlertVerifier.h).

For example, here's a test verifying the title. `sut` is the system under test
in the test fixture.

```obj-c
- (void)testShowAlert_AlertShouldHaveTitle {
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert]; // Whatever triggers the alert

    XCTAssertEqualObjects(alertVerifier.title, @"Title");
}
```

```swift
func testShowAlert_AlertShouldHaveTitle() {
    let alertVerifier = QCOMockAlertVerifier()

    sut.showAlert() // Whatever triggers the alert

    XCTAssertEqual(alertVerifier.title, "Title")
}
```

To guard against tests which accidentally present real alerts, I recommend placing the alert verifier in the test fixture with `setUp`/`tearDown`.


## How can I invoke the block associated with a UIAlertAction?

Go through the steps above to present your alert or action sheet using `QCOMockAlertController`.
Then call `-executeActionForButtonWithTitle:` on your `QCOMockAlertVerifier` with the button title.
For example:

```obj-c
- (void)testShowAlert_ExecutingActionForOKButton_ShouldDoSomething {
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert];
    [alertVerifier executeActionForButtonWithTitle:@"OK"];

    // Now assert what you want
}
```

```swift
func testShowAlert_ExecutingActionForOKButton_ShouldDoSomething() {
    let alertVerifier = QCOMockAlertVerifier()

    sut.showAlert()
    alertVerifier.executeActionForButton(withTitle: "OK")

    // Now assert what you want
}
```

### Can I see some examples?

See the sample apps. Run them on both phone & pad to see what they do, then read the ViewController tests.


## Adding it to your project

### CocoaPods

Add the following to your Podfile, changing "MyTests" to the name of your test target:

```ruby
target 'MyTests' do
  inherit! :search_paths
  pod 'MockUIAlertController', '~> 2.0'
end
```

### Carthage

Add the following to your Cartfile:

```
github "jonreid/MockUIAlertController" ~> 2.0
```

### Building It Yourself

Make sure to take everything from Source/MockUIAlertController.
