# ViewControllerPresentationSpy

[![Build Status](https://github.com/jonreid/ViewControllerPresentationSpy/actions/workflows/build.yml/badge.svg)](https://github.com/jonreid/ViewControllerPresentationSpy/actions/workflows/build.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fjonreid%2FViewControllerPresentationSpy%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/jonreid/ViewControllerPresentationSpy)
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

For concrete examples, see _[iOS Unit Testing by Example](https://pragprog.com/titles/jrlegios/ios-unit-testing-by-example/):_ chapter 9 "Testing Alerts," and chapter 10 "Testing Navigation Between Screens."

<!-- toc -->
## Contents

  * [Writing Tests](#writing-tests)
    * [What do I need to change in production code?](#what-do-i-need-to-change-in-production-code)
    * [How do I test an alert controller?](#how-do-i-test-an-alert-controller)
    * [How can I invoke the closure associated with a UIAlertAction?](#how-can-i-invoke-the-closure-associated-with-a-uialertaction)
    * [How do I test a presented view controller?](#how-do-i-test-a-presented-view-controller)
    * [How do I test a segue?](#how-do-i-test-a-segue)
    * [How do I test dismissing a modal?](#how-do-i-test-dismissing-a-modal)
    * [How can I invoke the closure passed to present or dismiss?](#how-can-i-invoke-the-closure-passed-to-present-or-dismiss)
    * [How can I test something that's presented or dismissed using DispatchQueue.main?](#how-can-i-test-something-thats-presented-or-dismissed-using-dispatchqueuemain)
    * [Can I see some examples?](#can-i-see-some-examples)
  * [How Do I Add ViewControllerPresentationSpy to My Project?](#how-do-i-add-viewcontrollerpresentationspy-to-my-project)
    * [Swift Package Manager](#swift-package-manager)
    * [CocoaPods](#cocoapods)
    * [Carthage](#carthage)
    * [Prebuilt Framework](#prebuilt-framework)
    * [Build Your Own](#build-your-own)<!-- endToc -->

## Writing Tests

### What do I need to change in production code?

Nothing.

### How do I test an alert controller?

1. Instantiate an `AlertVerifier` before the Act phase of the test.
2. Invoke the code to create and present your alert or action sheet.

Information about the alert or action sheet is then available through the
[AlertVerifier](https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/Source/ViewControllerPresentationSpy/AlertVerifier.swift).

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
    [alertVerifier executeActionForButton:@"OK" andReturnError:&error];

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
[PresentationVerifier](https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/Source/ViewControllerPresentationSpy/PresentationVerifier.swift).

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
[DismissalVerifier](https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/Source/ViewControllerPresentationSpy/DismissalVerifier.swift).

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

### How can I invoke the closure passed to present or dismiss?

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


## How Do I Add ViewControllerPresentationSpy to My Project?

### Swift Package Manager

Include a ViewControllerPresentationSpy package in your Package.swift manifest's array of dependencies:

```swift
dependencies: [
    .package(
        url: "https://github.com/jonreid/ViewControllerPresentationSpy",
        .upToNextMajor(from: "7.0.0")
    ),
],
```

### CocoaPods

Add the following to your Podfile, changing "MyTests" to the name of your test target:

```ruby
target 'MyTests' do
  inherit! :search_paths
  pod 'ViewControllerPresentationSpy', '~> 7.0'
end
```

### Carthage

Add the following to your Cartfile:

```
github "jonreid/ViewControllerPresentationSpy" ~> 7.0
```

### Prebuilt Framework

A prebuilt binary is available on [GitHub](https://github.com/jonreid/ViewControllerPresentationSpy/releases).
The binary is packaged as ViewControllerPresentationSpy.xcframework, containing these architectures:
* Mac Catalyst
* iOS device
* iOS simulator
* tvOS device
* tvOS simulator

Drag the XCFramework into your project.

### Build Your Own

If you want to build ViewControllerPresentationSpy yourself, clone the repo, then

```sh
$ cd Source
$ ./MakeDistribution.sh
```
