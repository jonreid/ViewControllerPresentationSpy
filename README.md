# MockUIAlertController

[![Build Status](https://travis-ci.org/jonreid/MockUIAlertController.svg?branch=master)](https://travis-ci.org/jonreid/MockUIAlertController)
[![Coverage Status](https://coveralls.io/repos/jonreid/MockUIAlertController/badge.svg?branch=master&service=github)](https://coveralls.io/github/jonreid/MockUIAlertController?branch=master)

MockUIAlertController lets you mock iOS alerts and action sheets for unit tests,
based on the UIAlertController introduced for iOS 8.

No actual alerts are presented. This means:

* The workflow doesn't pause for an action to be selected
* Tests are blazing fast.


## What do I need to change in production code?

To support redirection between UIAlertController and the mock, we need an extra
layer of indirection. I use property injection with a lazy getter that defaults
to the real UIAlertController:

```obj-c
@property (nonatomic, strong) Class alertControllerClass;
```

```obj-c
- (Class)alertControllerClass
{
    if (!_alertControllerClass) {
        _alertControllerClass = [UIAlertController class];
    }
    return _alertControllerClass;
}
```

Then modify any calls to UIAlertController that you want to make unit-testable.
Replace `UIAlertController` with `self.alertControllerClass`:

```obj-c
UIAlertController *alertController =
        [self.alertControllerClass alertControllerWithTitle:@"Title"
                                                    message:@"Message"
                                             preferredStyle:UIAlertControllerStyleAlert];
```
 

## What can I test?

For starters, make sure you have a test verifying the default value of
`alertControllerClass`.

In other tests:

1. Instantiate a `QCOMockAlertVerifier` before the execution phase of the test.
2. Inject `QCOMockAlertController` as the `alertControllerClass`.
3. Invoke the code to create and present your alert or action sheet.

Information about the alert or action sheet is then available through the
[QCOMockAlertVerifier](https://github.com/jonreid/MockUIAlertController/blob/master/TestSupport/QCOMockAlertVerifier.h).

For example, here's a test verifying the title. `sut` is the system under test
in the test fixture.

```obj-c
- (void)testShowAlert_AlertShouldHaveTitle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];
    sut.alertControllerClass = [QCOMockAlertController class];

    [sut showAlert:nil];

    XCTAssertEqualObjects(alertVerifier.title, @"Title");
}
```

See the sample app for more examples. One set of examples use
[OCHamcrest assertions](https://github.com/hamcrest/OCHamcrest), but OCHamcrest
is not required.


## How can I invoke the block associated with a UIAlertAction?

Go through steps 1, 2 and 3 above to present your alert or action sheet using
`QCOMockAlertController`. Then call `-executeActionForButtonWithTitle:` on your
`QCOMockAlertVerifier` with the button title.
