// System under test
#import "ViewController.h"

// Test support
#import <MockUIAlertController/QCOMockAlertVerifier.h>
#import <XCTest/XCTest.h>


@interface ViewControllerTests_PlainXCTest : XCTestCase
@end

@implementation ViewControllerTests_PlainXCTest
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

    XCTAssertNotNil(button);
}

- (void)testShowActionSheetButton_ShouldBeConnected
{
    UIButton *button = sut.showActionSheetButton;

    XCTAssertNotNil(button);
}

- (void)testTappingShowAlertButton_ShouldPresentAlert
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    XCTAssertEqual(alertVerifier.presentedCount, 1U);
}

- (void)testTappingShowActionSheetButton_ShouldPresentAlert
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.presentedCount, 1U);
}

- (void)testShowAlert_ShouldPreferAlert
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.preferredStyle, UIAlertControllerStyleAlert);
}

- (void)testShowActionSheet_ShouldPreferActionSheet
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.preferredStyle, UIAlertControllerStyleActionSheet);
}

- (void)testShowAlert_ShouldPresentWithAnimation
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertTrue(alertVerifier.animated);
}

- (void)testShowActionSheet_ShouldPresentWithAnimation
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertTrue(alertVerifier.animated);
}

- (void)testShowAlert_PresentedAlertShouldHaveTitle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqualObjects(alertVerifier.title, @"Title");
}

- (void)testShowActionSheet_PresentedSheetShouldHaveTitle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqualObjects(alertVerifier.title, @"Title");
}

- (void)testShowAlert_PresentedAlertShouldHaveMessage
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqualObjects(alertVerifier.message, @"Message");
}

- (void)testShowActionSheet_PresentedSheetShouldHaveMessage
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqualObjects(alertVerifier.message, @"Message");
}

- (void)testShowAlert_PresentedAlertShouldHaveActions
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.actionTitles.count, 4U);
    XCTAssertEqualObjects(alertVerifier.actionTitles[0], @"No Handler");
    XCTAssertEqualObjects(alertVerifier.actionTitles[1], @"Default");
    XCTAssertEqualObjects(alertVerifier.actionTitles[2], @"Cancel");
    XCTAssertEqualObjects(alertVerifier.actionTitles[3], @"Destroy");
}

- (void)testShowActionSheet_PresentedSheetShouldHaveActions
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.actionTitles.count, 4U);
    XCTAssertEqualObjects(alertVerifier.actionTitles[0], @"No Handler");
    XCTAssertEqualObjects(alertVerifier.actionTitles[1], @"Default");
    XCTAssertEqualObjects(alertVerifier.actionTitles[2], @"Cancel");
    XCTAssertEqualObjects(alertVerifier.actionTitles[3], @"Destroy");
}

- (void)testShowAlert_DefaultButtonShouldHaveDefaultStyle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual([alertVerifier styleForButtonWithTitle:@"Default"], UIAlertActionStyleDefault);
}

- (void)testShowAlert_CancelButtonShouldHaveCancelStyle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual([alertVerifier styleForButtonWithTitle:@"Cancel"], UIAlertActionStyleCancel);
}

- (void)testShowAlert_DestroyButtonShouldHaveDestructiveStyle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual([alertVerifier styleForButtonWithTitle:@"Destroy"], UIAlertActionStyleDestructive);
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
    
    XCTAssertEqual(alertVerifier.popover.sourceView, sut.showActionSheetButton);
}

- (void)testShowActionSheet_PopoverSourceRectShouldBeTappedButtonBounds
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];
    
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqualObjects(NSStringFromCGRect(alertVerifier.popover.sourceRect),
            NSStringFromCGRect(sut.showActionSheetButton.bounds));
}

- (void)testShowActionSheet_PopoverPermittedArrowDirectionsShouldBeAnyDirection
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.popover.permittedArrowDirections, UIPopoverArrowDirectionAny);
}

@end
