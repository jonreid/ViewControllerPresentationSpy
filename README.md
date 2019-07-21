# ViewControllerPresentationSpy

[![Build Status](https://travis-ci.org/jonreid/ViewControllerPresentationSpy.svg?branch=master)](https://travis-ci.org/jonreid/ViewControllerPresentationSpy)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Version](https://cocoapod-badges.herokuapp.com/v/ViewControllerPresentationSpy/badge.png)](https://cocoapods.org/pods/ViewControllerPresentationSpy)
[![Twitter Follow](https://img.shields.io/twitter/follow/qcoding.svg?style=social)](https://twitter.com/qcoding)

ViewControllerPresentationSpy intercepts presented view controllers, including alerts and actions sheets. It's compatible with both Swift and Objective-C.

No actual view controllers alerts are presented. This means:

* The workflow doesn't pause for an alert action to be selected.
* Tests are blazing fast.

For more discussion, see my blog post [How to Test UIAlertControllers and Control Swizzling](http://qualitycoding.org/testing-uialertcontrollers/).


## Writing Tests

### What do I need to change in production code?

Nothing.

### How do I test a presented view controller?

1. Instantiate a `PresentationVerifier` before the Act phase of the test.
2. Invoke the code to create and present your view controller.

Information about the presentation is then available through the
[PresententationVerifier](https://github.com/jonreid/ViewControllerPresentationSpy/blob/master/Source/ViewControllerPresentationSpy/PresentationVerifier.swift).

### How do I test a segue?

It depends. First, follow the steps above for testing a presented view controller. Trigger the segue from test code. For example, we can trigger a segue attached to a button by calling `sendActions(for: .touchUpInside)` on the button.

**Segue Type: Present Modally**

That's all you need to do.

_Warning:_ Neither the presenting view controller nor the presented view controller will be deallocated during test execution. This can cause problems during test runs if either listens to the NotificationCenter. You'll need to add special methods to stop observing the notification center.

**Segue Type: Show**

A Show segue (which does push navigation) takes a little more work.

First, install the presenting view controller as the root view controller of a UIWindow. Make this window visible.

```
    let window = UIWindow()
    window.rootViewController = sut
    window.isHidden = false
```

Then in the `tearDown()` method of the test suite, execute

```
RunLoop.current.run(until: Date())
```

This ensures that both the presenting view controller and the presented view controller are deallocated at the end of the test case.

### How do I test an alert controller?

1. Instantiate an `AlertVerifier` before the Act phase of the test.
2. Invoke the code to create and present your alert or action sheet.

Information about the alert or action sheet is then available through the
[AlertVerifier](https://github.com/jonreid/ViewControllerPresentationSpy/blob/master/Source/ViewControllerPresentationSpy/AlertVerifier.swift).

For example, here's a test verifying the title (and that the alert is presented exactly once). `sut` is the System Under Test
in the test fixture.

```swift
func test_showAlert_alertShouldHaveTitle() {
    let alertVerifier = AlertVerifier()

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

### How can I invoke the block associated with a UIAlertAction?

Go through the steps above to present your alert or action sheet.
Then call `executeActionForButton(withTitle:)` on your `AlertVerifier` with the button title.
For example:

```swift
func test_executingActionForOKButton_shouldDoSomething() throws {
    let alertVerifier = AlertVerifier()
    sut.showAlert()
    
    try alertVerifier.executeActionForButton(withTitle: "OK")

    // Now assert what you want
}
```

```obj-c
- (void)test_executingActionForOKButton_shouldDoSomething {
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];
    [sut showAlert];

    NSError *error = nil;
    [alertVerifier executeActionForButtonWithTitle:@"OK" returningError:];

    XCTAssertNil(error);
    // Now add your own assertions
}
```

### How can I test an alert that's presented using DispatchQueue.main?

Create an expectation in your test case. Fulfill it in the alert verifier's completion block. Add a short wait at the start of the Assert phase.

```swift
func test_showAlertOnMainDispatchQueue_shouldDoSomething() {
    let alertVerifier = AlertVerifier()
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

### CocoaPods

Add the following to your Podfile, changing "MyTests" to the name of your test target:

```ruby
target 'MyTests' do
  inherit! :search_paths
  pod 'ViewControllerPresentationSpy', '~> 4.0'
end
```

### Carthage

Add the following to your Cartfile:

```
github "jonreid/ViewControllerPresentationSpy" ~> 4.0
```

### Building It Yourself

Make sure to take everything from Source/ViewControllerPresentationSpy.
