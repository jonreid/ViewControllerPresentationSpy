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
    ViewController *sut;
}

- (void)setUp
{
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    sut = [storyboard instantiateViewControllerWithIdentifier:@"main"];
    [sut view];
}

- (void)tearDown
{
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
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];
    
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    assertThat(@(alertVerifier.presentedCount), is(equalTo(@1)));
}

- (void)testTappingShowActionSheetButton_ShouldPresentAlert
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];
    
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@(alertVerifier.presentedCount), is(equalTo(@1)));
}

- (void)testShowAlert_ShouldPreferAlert
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@(alertVerifier.preferredStyle), is(@(UIAlertControllerStyleAlert)));
}

- (void)testShowActionSheet_ShouldPreferActionSheet
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@(alertVerifier.preferredStyle), is(@(UIAlertControllerStyleActionSheet)));
}

- (void)testShowAlert_ShouldPresentWithAnimation
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.animated, is(@YES));
}

- (void)testShowActionSheet_ShouldPresentWithAnimation
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.animated, is(@YES));
}

- (void)testShowAlert_PresentedAlertShouldHaveTitle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.title, is(@"Title"));
}

- (void)testShowActionSheet_PresentedSheetShouldHaveTitle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.title, is(@"Title"));
}

- (void)testShowAlert_PresentedAlertShouldHaveMessage
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.message, is(@"Message"));
}

- (void)testShowActionSheet_PresentedSheetShouldHaveMessage
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.message, is(@"Message"));
}

- (void)testShowAlert_PresentedAlertShouldHaveActions
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.actionTitles, containsIn(@[ @"No Handler", @"Default", @"Cancel", @"Destroy" ]));
}

- (void)testShowActionSheet_PresentedSheetShouldHaveActions
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(alertVerifier.actionTitles, containsIn(@[ @"No Handler", @"Default", @"Cancel", @"Destroy" ]));
}

- (void)testShowAlert_DefaultButtonShouldHaveDefaultStyle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@([alertVerifier styleForButtonWithTitle:@"Default"]), is(@(UIAlertActionStyleDefault)));
}

- (void)testShowAlert_CancelButtonShouldHaveCancelStyle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@([alertVerifier styleForButtonWithTitle:@"Cancel"]), is(@(UIAlertActionStyleCancel)));
}

- (void)testShowAlert_DestroyButtonShouldHaveDestructiveStyle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@([alertVerifier styleForButtonWithTitle:@"Destroy"]), is(@(UIAlertActionStyleDestructive)));
}

- (void)testShowAlert_ExecutingActionForDefaultButton_ShouldDoSomethingMeaningful
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [alertVerifier executeActionForButtonWithTitle:@"Default"];

    XCTAssertTrue(sut.alertDefaultActionExecuted);
}

- (void)testShowAlert_ExecutingActionForCancelButton_ShouldDoSomethingMeaningful
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [alertVerifier executeActionForButtonWithTitle:@"Cancel"];

    XCTAssertTrue(sut.alertCancelActionExecuted);
}

- (void)testShowAlert_ExecutingActionForDestroyButton_ShouldDoSomethingMeaningful
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [alertVerifier executeActionForButtonWithTitle:@"Destroy"];

    XCTAssertTrue(sut.alertDestroyActionExecuted);
}

- (void)testShowActionSheet_PopoverSourceViewShouldBeTappedButton
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];
    
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    assertThat(alertVerifier.popover.sourceView, is(sameInstance(sut.showActionSheetButton)));
}

- (void)testShowActionSheet_PopoverSourceRectShouldBeTappedButtonBounds
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];
    
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(NSStringFromCGRect(alertVerifier.popover.sourceRect),
            is(NSStringFromCGRect(sut.showActionSheetButton.bounds)));
}

- (void)testShowActionSheet_PopoverPermittedArrowDirectionsShouldBeAnyDirection
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    assertThat(@(alertVerifier.popover.permittedArrowDirections), is(@(UIPopoverArrowDirectionAny)));
}

@end
