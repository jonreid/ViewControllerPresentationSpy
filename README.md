# MockUIAlertController

[![Build Status](https://travis-ci.org/jonreid/MockUIAlertController.svg?branch=master)](https://travis-ci.org/jonreid/MockUIAlertController)
[![Coverage Status](https://coveralls.io/repos/jonreid/MockUIAlertController/badge.svg?branch=master&service=github)](https://coveralls.io/github/jonreid/MockUIAlertController?branch=master)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Version](https://cocoapod-badges.herokuapp.com/v/MockUIAlertController/badge.png)](https://cocoapods.org/pods/MockUIAlertController)
[![Twitter Follow](https://img.shields.io/twitter/follow/qcoding.svg?style=social)](https://twitter.com/qcoding)

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

### How do I test an alert controller?

1. `@import MockUIAlertController.h;` or add it to your Swift test target's bridging header.
2. Instantiate a `QCOMockAlertVerifier` before the Act phase of the test.
3. Invoke the code to create and present your alert or action sheet.

Information about the alert or action sheet is then available through the
[QCOMockAlertVerifier](https://github.com/jonreid/MockUIAlertController/blob/master/Source/MockUIAlertController/QCOMockAlertVerifier.h).

For example, here's a test verifying the title (and that the alert is presented exactly once). `sut` is the System Under Test
in the test fixture.

```swift
func test_showAlert_alertShouldHaveTitle() {
    let alertVerifier = QCOMockAlertVerifier()

    sut.showAlert() // Whatever triggers the alert

    XCTAssertEqual(alertVerifier.presentedCount, 1, "presented count")
    XCTAssertEqual(alertVerifier.title, "Hello!", "title")
}
```

```obj-c
- (void)test_showAlert_alertShouldHaveTitle {
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert]; // Whatever triggers the alert

    XCTAssertEqual(alertVerifier.presentedCount, 1, @"presented count");
    XCTAssertEqualObjects(alertVerifier.title, @"Hello!", @"title");
}
```

To guard against tests which accidentally present real alerts, I recommend placing the alert verifier in the test fixture with `setUp()`/`tearDown()`:

```swift
private var alertVerifier: QCOMockAlertVerifier!

override func setUp() {
    super.setUp()
    alertVerifier = QCOMockAlertVerifier()
}

override func setUp() {
    alertVerifier = nil
    super.tearDown()
}
```

### How can I invoke the block associated with a UIAlertAction?

Go through the steps above to present your alert or action sheet using `QCOMockAlertController`.
Then call `executeActionForButton(withTitle:)` on your `QCOMockAlertVerifier` with the button title.
For example:

```swift
func test_executingActionForOKButton_shouldDoSomething() {
    let alertVerifier = QCOMockAlertVerifier()
    sut.showAlert()
    
    alertVerifier.executeActionForButton(withTitle: "OK")

    // Now assert what you want
}
```

```obj-c
- (void)test_executingActionForOKButton_shouldDoSomething {
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];
    [sut showAlert];

    [alertVerifier executeActionForButtonWithTitle:@"OK"];

    // Now assert what you want
}
```

### How can I test an alert that's presented using DispatchQueue.main?

Create an expectation in your test case. Fulfill it in the alert verifier's completion block. Add a short wait at the start of the Assert phase.

```swift
func test_showAlertOnMainDispatchQueue_shouldDoSomething() {
    let alertVerifier = QCOMockAlertVerifier()
    let expectation = self.expectation(description: "alert presented")
    alertVerifier.closure = { expectation.fulfill() }
    
    sut.showAlert()
    
    waitForExpectations(timeout: 0.001)
    // Now assert what you want
}
```

### Can I see some examples?

There are sample apps in both Swift and Objective-C. Run them on both phone & pad to see what they do, then read the ViewController tests.


## Adding it to your project

### Swift use

For Swift, add

```obj-c
@import MockUIAlertController;
```

to the bridging header of your test target. If you don't have it as a separate module, then `#import "MockUIAlertController.h"`

### CocoaPods

Add the following to your Podfile, changing "MyTests" to the name of your test target:

```ruby
target 'MyTests' do
  inherit! :search_paths
  pod 'MockUIAlertController', '~> 3.0'
end
```

### Carthage

Add the following to your Cartfile:

```
github "jonreid/MockUIAlertController" ~> 3.0
```

### Building It Yourself

Make sure to take everything from Source/MockUIAlertController.
