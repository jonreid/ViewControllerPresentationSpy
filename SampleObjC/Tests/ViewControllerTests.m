// System under test
#import "ViewController.h"

// Test support
@import MockUIAlertController;
@import XCTest;


@interface ViewControllerTests : XCTestCase
@end

@implementation ViewControllerTests
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
    XCTAssertNotNil(sut.showAlertButton);
    XCTAssertNotNil(sut.showActionSheetButton);
}

- (void)test_tappingShowAlertButton_shouldPresentAlert
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    XCTAssertEqual(alertVerifier.presentedCount, 1, @"presented count");
    XCTAssertEqual(alertVerifier.preferredStyle, UIAlertControllerStyleAlert, @"preferred style");
    XCTAssertEqual(alertVerifier.presentingViewController, sut, @"presenting view controller");
    XCTAssertTrue(alertVerifier.animated, @"animated");
    XCTAssertEqualObjects(alertVerifier.title, @"Title", @"title");
    XCTAssertEqualObjects(alertVerifier.message, @"Message", @"message");
}

- (void)test_tappingShowActionSheetButton_shouldPresentActionSheet
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.presentedCount, 1, @"presented count");
    XCTAssertEqual(alertVerifier.preferredStyle, UIAlertControllerStyleActionSheet, @"preferred style");
    XCTAssertEqual(alertVerifier.presentingViewController, sut, @"presenting view controller");
    XCTAssertTrue(alertVerifier.animated, @"animated");
    XCTAssertEqualObjects(alertVerifier.title, @"Title", @"title");
    XCTAssertEqualObjects(alertVerifier.message, @"Message", @"message");
}

- (void)test_actionSheetPopover
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    XCTAssertEqual(alertVerifier.popover.sourceView, sut.showActionSheetButton, @"source view");
    XCTAssertEqualObjects(NSStringFromCGRect(alertVerifier.popover.sourceRect),
            NSStringFromCGRect(sut.showActionSheetButton.bounds),
            @"source rect");
    XCTAssertEqual(alertVerifier.popover.permittedArrowDirections, UIPopoverArrowDirectionAny, @"permitted arrow directions");
}

- (void)test_presentedAlert_shouldHaveActions
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.actionTitles.count, 4U);
    XCTAssertEqualObjects(alertVerifier.actionTitles[0], @"No Handler");
    XCTAssertEqualObjects(alertVerifier.actionTitles[1], @"Default");
    XCTAssertEqualObjects(alertVerifier.actionTitles[2], @"Cancel");
    XCTAssertEqualObjects(alertVerifier.actionTitles[3], @"Destroy");
}

- (void)test_presentedActionSheet_shouldHaveActions
{
    [sut.showActionSheetButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(alertVerifier.actionTitles.count, 4U);
    XCTAssertEqualObjects(alertVerifier.actionTitles[0], @"No Handler");
    XCTAssertEqualObjects(alertVerifier.actionTitles[1], @"Default");
    XCTAssertEqualObjects(alertVerifier.actionTitles[2], @"Cancel");
    XCTAssertEqualObjects(alertVerifier.actionTitles[3], @"Destroy");
}

- (void)test_styleForButtonWithTitle_withDefaultButton_shouldHaveDefaultStyle
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual([alertVerifier styleForButtonWithTitle:@"Default"], UIAlertActionStyleDefault);
}

- (void)test_styleForButtonWithTitle_withCancelButton_shouldHaveCancelStyle
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual([alertVerifier styleForButtonWithTitle:@"Cancel"], UIAlertActionStyleCancel);
}

- (void)test_styleForButtonWithTitle_withDestroyButton_shouldHaveDestructiveStyle
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual([alertVerifier styleForButtonWithTitle:@"Destroy"], UIAlertActionStyleDestructive);
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
