# ViewControllerPresentationSpy

[![Build Status](https://travis-ci.org/jonreid/ViewControllerPresentationSpy.svg?branch=master)](https://travis-ci.org/jonreid/ViewControllerPresentationSpy)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Version](https://cocoapod-badges.herokuapp.com/v/ViewControllerPresentationSpy/badge.png)](https://cocoapods.org/pods/ViewControllerPresentationSpy)
[![Twitter Follow](https://img.shields.io/twitter/follow/qcoding.svg?style=social)](https://twitter.com/qcoding)

ViewControllerPresentationSpy has three verifiers:
* `AlertVerifier` to capture alerts and action sheets
* `PresentationVerifier` to capture presented view controllers
* `DismissalVerifier` to capture dismissed view controllers

Segues can be captured. Nothing is actually presented or dismissed. This means:

* The workflow doesn't pause for an alert action to be selected.
* Tests are blazing fast.
* You can test things with unit tests instead of UI tests.

For more discussion, see my blog post
[How to Test UIAlertControllers and Control Swizzling](http://qualitycoding.org/testing-uialertcontrollers/).


## Writing Tests

### What do I need to change in production code?

Nothing.

### How do I test an alert controller?

1. Instantiate an `AlertVerifier` before the Act phase of the test.
2. Invoke the code to create and present your alert or action sheet.

Information about the alert or action sheet is then available through the
[AlertVerifier](https://github.com/jonreid/ViewControllerPresentationSpy/blob/master/Source/ViewControllerPresentationSpy/AlertVerifier.swift).

For example, here's a test verifying:

 - That one alert was presented, with animation.
 - That the presenting view controller was the System Under Test.
 - The alert title.
 - The alert message.
 - The preferred style of UIAlertController.Style.
 - The titles and styles of each action.
 
`sut` is the System Under Test in the test fixture. The Swift version uses a handy `verify` method.

```swift
func test_showAlert_alertShouldHaveTitle() {
    let alertVerifier = AlertVerifier()

    sut.showAlert() // Whatever triggers the alert

    alertVerifier.verify(
        title: "Hello!",
        message: "How are you?",
        animated: true,
        presentingViewController: sut,
        actions: [
            .default("OK"),
            .cancel("Cancel"),
        ]
    )
}
```

```obj-c
- (void)test_showAlert_alertShouldHaveTitle
{
    QCOAlertVerifier *alertVerifier = [[QCOAlertVerifier alloc] init];

    [sut showAlert]; // Whatever triggers the alert

    XCTAssertEqual(alertVerifier.presentedCount, 1, @"presented count");
    XCTAssertEqualObjects(alertVerifier.title, @"Hello!", @"title");
    XCTAssertEqualObjects(alertVerifier.message, @"How are you?", @"message");
    XCTAssertEqual(alertVerifier.animated, YES, @"animated");
    XCTAssertEqual(alertVerifier.preferredStyle, UIAlertController.Style.alert, @"preferred style");
    XCTAssertEqual(alertVerifier.presentingViewController, sut, @"presenting view controller");
    XCTAssertEqual(alertVerifier.actions.count, 2, @"actions count);
    XCTAssertEqualObjects(alertVerifier.actions[0].title, @"OK", @"first action");
    XCTAssertEqual(alertVerifier.actions[0].style, UIAlertActionStyleDefault, @"first action");
    XCTAssertEqualObjects(alertVerifier.actions[1].title, @"Cancel", @"second action");
    XCTAssertEqual(alertVerifier.actions[1].style, UIAlertActionStyleCancel, @"second action");
}
```

### How can I invoke the closure associated with a UIAlertAction?

Go through the steps above to present your alert or action sheet. Then call
`executeAction (forButton:)` on your `AlertVerifier` with the button title. For example:

```swift
func test_executingActionForOKButton_shouldDoSomething() throws {
    let alertVerifier = AlertVerifier()
    sut.showAlert()
    
    try alertVerifier.executeAction(forButton: "OK")

    // Now assert what you want
}
```

```obj-c
- (void)test_executingActionForOKButton_shouldDoSomething
{
    QCOAlertVerifier *alertVerifier = [[QCOAlertVerifier alloc] init];
    [sut showAlert];

    NSError *error = nil;
    [alertVerifier executeActionForButton:@"OK" returningError:&error];

    XCTAssertNil(error);
    // Now add your own assertions
}
```

Because this method can throw an exception, declare the Swift test method as `throws` and call
the method with `try`. For Objective-C, pass in an NSError and check that it's not nil.

### How do I test a presented view controller?

1. Instantiate a `PresentationVerifier` before the Act phase of the test.
2. Invoke the code to create and present your view controller.

Information about the presentation is then available through the
[PresentationVerifier](https://github.com/jonreid/ViewControllerPresentationSpy/blob/master/Source/ViewControllerPresentationSpy/PresentationVerifier.swift).

For example, here's a test verifying:

 - That one view controller was presented, with animation.
 - That the presenting view controller was the System Under Test.
 - That the type of the presented view controller is correct.
 - That the presented view controller has a particular property.
 
`sut` is the System Under Test in the test fixture. The Swift version uses a handy `verify` method.

```swift
func test_presentedVC_shouldHaveSpecialSettingHello() {
    let presentationVerifier = PresentationVerifier()

    sut.showVC() // Whatever presents the view controller

    let nextVC: MyViewController? = presentationVerifier.verify(animated: true,
                                                                presentingViewController: sut)
    XCTAssertEqual(nextVC?.specialSetting, "Hello!")
}
```

```obj-c
- (void) test_presentedVC_shouldHaveSpecialSettingHello
{
    QCOPresentationVerifier *presentationVerifier = [[QCOPresentationVerifier alloc] init];

    [sut showVC]; // Whatever presents the view controller

    XCTAssertEqual(presentationVerifier.presentedCount, 1, @"presented count");
    XCTAssertTrue(presentationVerifier.animated, @"animated");
    XCTAssertEqual(presentationVerifier.presentingViewController, sut, @"presenting view controller");
    if (![presentationVerifier.presentedViewController isKindOfClass:[MyViewController class]])
    {
        XCTFail(@"Expected MyViewController, but was %@", presentationVerifier.presentedViewController);
        return;
    }
    MyViewController *nextVC = presentationVerifier.presentedViewController;
    XCTAssertEqualObjects(nextVC.specialSetting, @"Hello!");
}
```

### How do I test a segue?

It depends. First, follow the steps above for testing a presented view controller. Trigger the
segue from test code. For example, we can trigger a segue attached to a button by calling
`sendActions(for: .touchUpInside)` on the button.

**Segue Type: Present Modally**

That's all you need to do. _But you need to be aware of a memory issue:_

Neither the presenting view controller nor the presented view controller will be deallocated
during test execution. This can cause problems during test runs if either affects global state,
such as listening to the NotificationCenter. You may need to add special methods outside of
`deinit` that allow tests to clean them up. 

**Segue Type: Show**

A "Show" segue (which does push navigation) takes a little more work.

First, install the presenting view controller as the root view controller of a UIWindow. Make
this window visible.

```
let window = UIWindow()
window.rootViewController = sut
window.isHidden = false
```

To clean up memory at the end, add this to the beginning of the `tearDown()` method of the test
suite to pump the run loop:

```
RunLoop.current.run(until: Date())
```

This ensures that the window is deallocated at the end of the test case. That way, both the view
controllers will also cease to exist.

### How do I test dismissing a modal?

1. Instantiate a `DismissalVerifier` before the Act phase of the test.
2. Invoke the code to dismiss your modal.

Information about the dismissal is then available through the
[DismissalVerifier](https://github.com/jonreid/ViewControllerPresentationSpy/blob/master/Source/ViewControllerPresentationSpy/DismissalVerifier.swift).

For example, here's a test verifying that a particular view controller was dismissed, with animation.
 
`sut` is the System Under Test in the test fixture. The Swift version uses a handy `verify` method.

```swift
func test_dismissingVC() {
    let dismissalVerifier = DismissalVerifier()

    sut.dismissVC() // Whatever dismisses the view controller

    dismissalVerifier.verify(animated: true, dismissedViewController: sut)
}
```

```obj-c
- (void) test_dismissingVC
{
    QCODismissalVerifier *dismissalVerifier = [[QCODismissalVerifier alloc] init];

    [sut dismissVC]; // Whatever dismisses the view controller

    XCTAssertEqual(dismissalVerifier.dismissedCount, 1, @"dismissed count");
    XCTAssertTrue(dismissalVerifier.animated, @"animated");
    XCTAssertEqual(dismissalVerifier.presentingViewController, sut, @"dismissed view controller");
}
```

### How can I invoke the closure passed to present(_:animated:completion:) or dismiss(_:completion)?

The production code completion handler is captured in the verifier's `capturedCompletion` property.

### How can I test something that's presented or dismissed using DispatchQueue.main?

Create an expectation in your test case. Fulfill it in the verifier's `testCompletion` closure.
Add a short wait at the start of the Assert phase.

```swift
func test_showAlertOnMainDispatchQueue_shouldDoSomething() {
    let alertVerifier = AlertVerifier()
    let expectation = self.expectation(description: "alert presented")
    alertVerifier.testCompletion = { expectation.fulfill() }
    
    sut.showAlert()
    
    waitForExpectations(timeout: 0.001)
    // Now assert what you want
}
```

```swift
func test_presentViewControllerOnMainDispatchQueue_shouldDoSomething() {
    let presentationVerifier = PresentationVerifier()
    let expectation = self.expectation(description: "view controller presented")
    presentationVerifier.testCompletion = { expectation.fulfill() }
    
    sut.showVC()
    
    waitForExpectations(timeout: 0.001)
    // Now assert what you want
}
```

### Can I see some examples?

There are sample apps in both Swift and Objective-C. Run them on both phone & pad to see what
they do, then read the ViewControllerAlertTests and ViewControllerPresentationTests.


## Adding it to your project

### CocoaPods

Add the following to your Podfile, changing "MyTests" to the name of your test target:

```ruby
target 'MyTests' do
  inherit! :search_paths
  pod 'ViewControllerPresentationSpy', '~> 4.2'
end
```

### Carthage

Add the following to your Cartfile:

```
github "jonreid/ViewControllerPresentationSpy" ~> 4.2
```

### Prebuilt Framework

Prebuilt binaries are available on
[GitHub](https://github.com/jonreid/ViewControllerPresentationSpy/releases).

- Drag ViewControllerPresentationSpy.framework into your project, specifying "Copy items into
  destination group's folder".
- Add a "Copy Files" build phase to copy ViewControllerPresentationSpy.framework to your Products
  Directory.
