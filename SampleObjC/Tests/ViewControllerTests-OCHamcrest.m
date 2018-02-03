// System under test
#import "ViewController.h"

// Test support
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <MockUIAlertController/QCOMockAlertVerifier.h>
@import XCTest;


@interface ViewControllerTests_OCHamcrest : XCTestCase
@end

@implementation ViewControllerTests_OCHamcrest
{
    QCOMockAlertVerifier *alertVerifier;
    ViewController *sut;
}

- (void)setUp
{
    [super setUp];
    alertVerifier = [[QCOMockAlertVerifier alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    sut = [storyboard instantiateViewControllerWithIdentifier:@"main"];
    [sut view];
}

- (void)tearDown
{
    alertVerifier = nil;
    sut = nil;
    [super tearDown];
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

- (void)testTappingShowAlertButton_ShouldPresentAlert
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    assertThat(@(alertVerifier.presentedCount), is(equalTo(@1)));
}

- (void)testTappingShowActionSheetButton_ShouldPresentAlert
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@(alertVerifier.presentedCount), is(equalTo(@1)));
}

- (void)testShowAlert_ShouldPreferAlert
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@(alertVerifier.preferredStyle), is(@(UIAlertControllerStyleAlert)));
}

- (void)testShowActionSheet_ShouldPreferActionSheet
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@(alertVerifier.preferredStyle), is(@(UIAlertControllerStyleActionSheet)));
}

- (void)testShowAlert_ShouldProvidePresentingViewController
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    assertThat(alertVerifier.presentingViewController, is(sameInstance(sut)));
}

- (void)testShowActionSheet_ShouldProvidePresentingViewController
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    assertThat(alertVerifier.presentingViewController, is(sameInstance(sut)));
}

- (void)testShowAlert_ShouldPresentWithAnimation
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@(alertVerifier.animated), is(@YES));
}

- (void)testShowActionSheet_ShouldPresentWithAnimation
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@(alertVerifier.animated), is(@YES));
}

- (void)testShowAlert_PresentedAlertShouldHaveTitle
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.title, is(@"Title"));
}

- (void)testShowActionSheet_PresentedSheetShouldHaveTitle
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.title, is(@"Title"));
}

- (void)testShowAlert_PresentedAlertShouldHaveMessage
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.message, is(@"Message"));
}

- (void)testShowActionSheet_PresentedSheetShouldHaveMessage
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.message, is(@"Message"));
}

- (void)testShowAlert_PresentedAlertShouldHaveActions
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.actionTitles, containsIn(@[ @"No Handler", @"Default", @"Cancel", @"Destroy" ]));
}

- (void)testShowActionSheet_PresentedSheetShouldHaveActions
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.actionTitles, containsIn(@[ @"No Handler", @"Default", @"Cancel", @"Destroy" ]));
}

- (void)testShowAlert_DefaultButtonShouldHaveDefaultStyle
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@([alertVerifier styleForButtonWithTitle:@"Default"]), is(@(UIAlertActionStyleDefault)));
}

- (void)testShowAlert_CancelButtonShouldHaveCancelStyle
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@([alertVerifier styleForButtonWithTitle:@"Cancel"]), is(@(UIAlertActionStyleCancel)));
}

- (void)testShowAlert_DestroyButtonShouldHaveDestructiveStyle
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@([alertVerifier styleForButtonWithTitle:@"Destroy"]), is(@(UIAlertActionStyleDestructive)));
}

- (void)testShowAlert_ExecutingActionForDefaultButton_ShouldDoSomethingMeaningful
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [alertVerifier executeActionForButtonWithTitle:@"Default"];

    XCTAssertTrue(sut.alertDefaultActionExecuted);
}

- (void)testShowAlert_ExecutingActionForCancelButton_ShouldDoSomethingMeaningful
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [alertVerifier executeActionForButtonWithTitle:@"Cancel"];

    XCTAssertTrue(sut.alertCancelActionExecuted);
}

- (void)testShowAlert_ExecutingActionForDestroyButton_ShouldDoSomethingMeaningful
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [alertVerifier executeActionForButtonWithTitle:@"Destroy"];

    XCTAssertTrue(sut.alertDestroyActionExecuted);
}

- (void)testShowActionSheet_PopoverSourceViewShouldBeTappedButton
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    assertThat(alertVerifier.popover.sourceView, is(sameInstance(sut.showActionSheetButton)));
}

- (void)testShowActionSheet_PopoverSourceRectShouldBeTappedButtonBounds
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(NSStringFromCGRect(alertVerifier.popover.sourceRect),
            is(NSStringFromCGRect(sut.showActionSheetButton.bounds)));
}

- (void)testShowActionSheet_PopoverPermittedArrowDirectionsShouldBeAnyDirection
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@(alertVerifier.popover.permittedArrowDirections), is(@(UIPopoverArrowDirectionAny)));
}

@end
