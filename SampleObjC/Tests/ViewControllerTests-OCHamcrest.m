// System under test
#import "ViewController.h"

// Test support
@import MockUIAlertController;
@import OCHamcrestIOS;
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

- (void)test_outlets_shouldBeConnected
{
    assertThat(sut.showAlertButton, isNot(nilValue()));
    assertThat(sut.showActionSheetButton, isNot(nilValue()));
}

- (void)test_tappingShowAlertButton_shouldPresentAlert
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    assertThat(@(alertVerifier.presentedCount), is(equalTo(@1)));
}

- (void)test_tappingShowActionSheetButton_shouldPresentAlert
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@(alertVerifier.presentedCount), is(equalTo(@1)));
}

- (void)test_preferredStyleForAlert_shouldBeAlert
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@(alertVerifier.preferredStyle), is(@(UIAlertControllerStyleAlert)));
}

- (void)test_preferredStyleForActionSheet_shouldBeActionSheet
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@(alertVerifier.preferredStyle), is(@(UIAlertControllerStyleActionSheet)));
}

- (void)test_presentingViewControllerForAlert_shouldBeSystemUnderTest
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    assertThat(alertVerifier.presentingViewController, is(sameInstance(sut)));
}

- (void)test_presentingViewControllerForActionSheet_shouldBeSystemUnderTest
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    assertThat(alertVerifier.presentingViewController, is(sameInstance(sut)));
}

- (void)test_showingAlert_shouldPresentWithAnimation
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@(alertVerifier.animated), is(@YES));
}

- (void)test_showingActionSheet_shouldPresentWithAnimation
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@(alertVerifier.animated), is(@YES));
}

- (void)test_titleForAlert
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.title, is(@"Title"));
}

- (void)test_titleForActionSheet
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.title, is(@"Title"));
}

- (void)test_messageForAlert
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.message, is(@"Message"));
}

- (void)test_messageForActionSheet
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.message, is(@"Message"));
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

- (void)test_presentedAlert_shouldHaveActions
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.actionTitles, containsIn(@[ @"No Handler", @"Default", @"Cancel", @"Destroy" ]));
}

- (void)test_presentedActionSheet_shouldHaveActions
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.actionTitles, containsIn(@[ @"No Handler", @"Default", @"Cancel", @"Destroy" ]));
}

- (void)test_styleForButtonWithTitle_withDefaultButton_shouldHaveDefaultStyle
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@([alertVerifier styleForButtonWithTitle:@"Default"]), is(@(UIAlertActionStyleDefault)));
}

- (void)test_styleForButtonWithTitle_withCancelButton_shouldHaveCancelStyle
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@([alertVerifier styleForButtonWithTitle:@"Cancel"]), is(@(UIAlertActionStyleCancel)));
}

- (void)test_styleForButtonWithTitle_withDestroyButton_shouldHaveDestructiveStyle
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@([alertVerifier styleForButtonWithTitle:@"Destroy"]), is(@(UIAlertActionStyleDestructive)));
}

- (void)test_executeActionForButtonWithTitle_withDefaultButton_shouldExecuteDefaultAction
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [alertVerifier executeActionForButtonWithTitle:@"Default"];

    XCTAssertTrue(sut.alertDefaultActionExecuted);
}

- (void)test_executeActionForButtonWithTitle_withCancelButton_shouldExecuteCancelAction
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [alertVerifier executeActionForButtonWithTitle:@"Cancel"];

    XCTAssertTrue(sut.alertCancelActionExecuted);
}

- (void)test_executeActionForButtonWithTitle_withDestroyButton_shouldExecuteDestroyAction
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [alertVerifier executeActionForButtonWithTitle:@"Destroy"];

    XCTAssertTrue(sut.alertDestroyActionExecuted);
}

@end
