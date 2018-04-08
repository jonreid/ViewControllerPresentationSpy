// System under test
#import "ViewController.h"

// Test support
@import MockUIAlertController;
@import XCTest;


@interface ViewControllerTests_PlainXCTest : XCTestCase
@end

@implementation ViewControllerTests_PlainXCTest
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

    XCTAssertNotNil(button);
}

- (void)testShowActionSheetButton_ShouldBeConnected
{
    UIButton *button = sut.showActionSheetButton;

    XCTAssertNotNil(button);
}

- (void)testTappingShowAlertButton_ShouldPresentAlert
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    XCTAssertEqual(alertVerifier.presentedCount, 1U);
}

- (void)testTappingShowActionSheetButton_ShouldPresentAlert
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.presentedCount, 1U);
}

- (void)testShowAlert_ShouldPreferAlert
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.preferredStyle, UIAlertControllerStyleAlert);
}

- (void)testShowActionSheet_ShouldPreferActionSheet
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.preferredStyle, UIAlertControllerStyleActionSheet);
}

- (void)testShowActionSheet_ShouldProvidePresentingViewController
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    XCTAssertEqual(alertVerifier.presentingViewController, sut);
}

- (void)testShowAlert_ShouldProvidePresentingViewController
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    XCTAssertEqual(alertVerifier.presentingViewController, sut);
}

- (void)testShowAlert_ShouldPresentWithAnimation
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertTrue(alertVerifier.animated);
}

- (void)testShowActionSheet_ShouldPresentWithAnimation
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertTrue(alertVerifier.animated);
}

- (void)testShowAlert_PresentedAlertShouldHaveTitle
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqualObjects(alertVerifier.title, @"Title");
}

- (void)testShowActionSheet_PresentedSheetShouldHaveTitle
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqualObjects(alertVerifier.title, @"Title");
}

- (void)testShowAlert_PresentedAlertShouldHaveMessage
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqualObjects(alertVerifier.message, @"Message");
}

- (void)testShowActionSheet_PresentedSheetShouldHaveMessage
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqualObjects(alertVerifier.message, @"Message");
}

- (void)testShowAlert_PresentedAlertShouldHaveActions
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.actionTitles.count, 4U);
    XCTAssertEqualObjects(alertVerifier.actionTitles[0], @"No Handler");
    XCTAssertEqualObjects(alertVerifier.actionTitles[1], @"Default");
    XCTAssertEqualObjects(alertVerifier.actionTitles[2], @"Cancel");
    XCTAssertEqualObjects(alertVerifier.actionTitles[3], @"Destroy");
}

- (void)testShowActionSheet_PresentedSheetShouldHaveActions
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.actionTitles.count, 4U);
    XCTAssertEqualObjects(alertVerifier.actionTitles[0], @"No Handler");
    XCTAssertEqualObjects(alertVerifier.actionTitles[1], @"Default");
    XCTAssertEqualObjects(alertVerifier.actionTitles[2], @"Cancel");
    XCTAssertEqualObjects(alertVerifier.actionTitles[3], @"Destroy");
}

- (void)testShowAlert_DefaultButtonShouldHaveDefaultStyle
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual([alertVerifier styleForButtonWithTitle:@"Default"], UIAlertActionStyleDefault);
}

- (void)testShowAlert_CancelButtonShouldHaveCancelStyle
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual([alertVerifier styleForButtonWithTitle:@"Cancel"], UIAlertActionStyleCancel);
}

- (void)testShowAlert_DestroyButtonShouldHaveDestructiveStyle
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual([alertVerifier styleForButtonWithTitle:@"Destroy"], UIAlertActionStyleDestructive);
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
    
    XCTAssertEqual(alertVerifier.popover.sourceView, sut.showActionSheetButton);
}

- (void)testShowActionSheet_PopoverSourceRectShouldBeTappedButtonBounds
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqualObjects(NSStringFromCGRect(alertVerifier.popover.sourceRect),
            NSStringFromCGRect(sut.showActionSheetButton.bounds));
}

- (void)testShowActionSheet_PopoverPermittedArrowDirectionsShouldBeAnyDirection
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.popover.permittedArrowDirections, UIPopoverArrowDirectionAny);
}

@end
