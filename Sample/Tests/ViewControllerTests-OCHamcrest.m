// System under test
#import "ViewController.h"

// Test support
#import "QCOMockAlertVerifier.h"
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>


@interface ViewControllerTests_OCHamcrest : XCTestCase
@end

@implementation ViewControllerTests_OCHamcrest
{
    ViewController *sut;
}

- (void)setUp
{
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    sut = [storyboard instantiateViewControllerWithIdentifier:@"main"];
    [sut view];
}

- (void)testShowAlertButton_ShouldBeConnected
{
    UIButton *button = sut.showAlertButton;

    assertThat(button, is(notNilValue()));
}

- (void)testShowActionSheetButton_ShouldBeConnected
{
    UIButton *button = sut.showActionSheetButton;

    assertThat(button, is(notNilValue()));
}

- (void)testShowAlertButton_ShouldHaveAction
{
    NSArray *touchUpActions = [sut.showAlertButton actionsForTarget:sut
                                                    forControlEvent:UIControlEventTouchUpInside];

    assertThat(touchUpActions, contains(@"showAlert:", nil));
}

- (void)testShowActionSheetButton_ShouldHaveAction
{
    [sut view];

    NSArray *touchUpActions = [sut.showActionSheetButton actionsForTarget:sut
                                                          forControlEvent:UIControlEventTouchUpInside];

    assertThat(touchUpActions, contains(@"showActionSheet:", nil));
}

- (void)testShowAlert_ShouldPresentModal
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];
    
    assertThat(@(alertVerifier.presentedCount), is(equalTo(@1)));
}

- (void)testShowActionSheet_ShouldPresentModal
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showActionSheet:nil];

    assertThat(@(alertVerifier.presentedCount), is(equalTo(@1)));
}

- (void)testShowAlert_ShouldPreferAlert
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    assertThat(@(alertVerifier.preferredStyle), is(@(UIAlertControllerStyleAlert)));
}

- (void)testShowActionSheet_ShouldPreferActionSheet
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showActionSheet:nil];

    assertThat(@(alertVerifier.preferredStyle), is(@(UIAlertControllerStyleActionSheet)));
}

- (void)testShowAlert_ShouldPresentWithAnimation
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    assertThat(alertVerifier.animated, is(@YES));
}

- (void)testShowActionSheet_ShouldPresentWithAnimation
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showActionSheet:nil];

    assertThat(alertVerifier.animated, is(@YES));
}

- (void)testShowAlert_PresentedAlertShouldHaveTitle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    assertThat(alertVerifier.title, is(@"Title"));
}

- (void)testShowActionSheet_PresentedSheetShouldHaveTitle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showActionSheet:nil];

    assertThat(alertVerifier.title, is(@"Title"));
}

- (void)testShowAlert_PresentedAlertShouldHaveMessage
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    assertThat(alertVerifier.message, is(@"Message"));
}

- (void)testShowActionSheet_PresentedSheetShouldHaveMessage
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showActionSheet:nil];

    assertThat(alertVerifier.message, is(@"Message"));
}

- (void)testShowAlert_PresentedAlertShouldHaveActions
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    assertThat(alertVerifier.actionTitles, contains(@"Default", @"Cancel", @"Destroy", nil));
}

- (void)testShowActionSheet_PresentedSheetShouldHaveActions
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showActionSheet:nil];

    assertThat(alertVerifier.actionTitles, contains(@"Default", @"Cancel", @"Destroy", nil));
}

- (void)testShowAlert_DefaultButtonShouldHaveDefaultStyle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    assertThat(@([alertVerifier styleForButtonWithTitle:@"Default"]), is(@(UIAlertActionStyleDefault)));
}

- (void)testShowAlert_CancelButtonShouldHaveCancelStyle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    assertThat(@([alertVerifier styleForButtonWithTitle:@"Cancel"]), is(@(UIAlertActionStyleCancel)));
}

- (void)testShowAlert_DestroyButtonShouldHaveDestructiveStyle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    assertThat(@([alertVerifier styleForButtonWithTitle:@"Destroy"]), is(@(UIAlertActionStyleDestructive)));
}

- (void)testShowAlert_ExecutingActionForDefaultButton_ShouldDoSomethingMeaningful
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];
    [alertVerifier executeActionForButtonWithTitle:@"Default"];

    XCTAssertTrue(sut.alertDefaultActionExecuted);
}

- (void)testShowAlert_ExecutingActionForCancelButton_ShouldDoSomethingMeaningful
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];
    [alertVerifier executeActionForButtonWithTitle:@"Cancel"];

    XCTAssertTrue(sut.alertCancelActionExecuted);
}

- (void)testShowAlert_ExecutingActionForDestroyButton_ShouldDoSomethingMeaningful
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];
    [alertVerifier executeActionForButtonWithTitle:@"Destroy"];

    XCTAssertTrue(sut.alertDestroyActionExecuted);
}

- (void)testShowActionSheet_PopoverSourceViewShouldBeTappedButton
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];
    UIButton *tappedButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2, 3, 4)];
    
    [sut showActionSheet:tappedButton];
    
    assertThat(alertVerifier.popover.sourceView, is(sameInstance(tappedButton)));
}

- (void)testShowActionSheet_PopoverSourceRectShouldBeTappedButtonBounds
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];
    UIButton *tappedButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2, 3, 4)];

    [sut showActionSheet:tappedButton];

    assertThat(NSStringFromCGRect(alertVerifier.popover.sourceRect), is(NSStringFromCGRect(tappedButton.bounds)));
}

- (void)testShowActionSheet_PopoverPermittedArrowDirectionsShouldBeAnyDirection
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showActionSheet:nil];

    assertThat(@(alertVerifier.popover.permittedArrowDirections), is(@(UIPopoverArrowDirectionAny)));
}

@end
