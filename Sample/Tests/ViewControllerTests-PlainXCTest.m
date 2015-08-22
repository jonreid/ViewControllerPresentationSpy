// System under test
#import "ViewController.h"

// Test support
#import "QCOMockAlertVerifier.h"
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

- (void)testShowAlertButton_ShouldHaveAction
{
    NSArray *touchUpActions = [sut.showAlertButton actionsForTarget:sut
                                                    forControlEvent:UIControlEventTouchUpInside];

    XCTAssertEqual(touchUpActions.count, (NSUInteger)1);
    XCTAssertEqualObjects(touchUpActions[0], @"showAlert:");
}

- (void)testShowActionSheetButton_ShouldHaveAction
{
    [sut view];

    NSArray *touchUpActions = [sut.showActionSheetButton actionsForTarget:sut
                                                          forControlEvent:UIControlEventTouchUpInside];

    XCTAssertEqual(touchUpActions.count, (NSUInteger)1);
    XCTAssertEqualObjects(touchUpActions[0], @"showActionSheet:");
}

- (void)testShowAlert_ShouldPresentModal
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];
    
    XCTAssertEqual(alertVerifier.presentedCount, (NSUInteger)1);
}

- (void)testShowActionSheet_ShouldPresentModal
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showActionSheet:nil];

    XCTAssertEqual(alertVerifier.presentedCount, (NSUInteger)1);
}

- (void)testShowAlert_ShouldPreferAlert
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    XCTAssertEqual(alertVerifier.preferredStyle, UIAlertControllerStyleAlert);
}

- (void)testShowActionSheet_ShouldPreferActionSheet
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showActionSheet:nil];

    XCTAssertEqual(alertVerifier.preferredStyle, UIAlertControllerStyleActionSheet);
}

- (void)testShowAlert_ShouldPresentWithAnimation
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    XCTAssertTrue(alertVerifier.animated);
}

- (void)testShowActionSheet_ShouldPresentWithAnimation
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showActionSheet:nil];

    XCTAssertTrue(alertVerifier.animated);
}

- (void)testShowAlert_PresentedAlertShouldHaveTitle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    XCTAssertEqualObjects(alertVerifier.title, @"Title");
}

- (void)testShowActionSheet_PresentedSheetShouldHaveTitle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showActionSheet:nil];

    XCTAssertEqualObjects(alertVerifier.title, @"Title");
}

- (void)testShowAlert_PresentedAlertShouldHaveMessage
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    XCTAssertEqualObjects(alertVerifier.message, @"Message");
}

- (void)testShowActionSheet_PresentedSheetShouldHaveMessage
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showActionSheet:nil];

    XCTAssertEqualObjects(alertVerifier.message, @"Message");
}

- (void)testShowAlert_PresentedAlertShouldHaveActions
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    XCTAssertEqual(alertVerifier.actionTitles.count, (NSUInteger)3);
    XCTAssertEqualObjects(alertVerifier.actionTitles[0], @"Default");
    XCTAssertEqualObjects(alertVerifier.actionTitles[1], @"Cancel");
    XCTAssertEqualObjects(alertVerifier.actionTitles[2], @"Destroy");
}

- (void)testShowActionSheet_PresentedSheetShouldHaveActions
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showActionSheet:nil];

    XCTAssertEqual(alertVerifier.actionTitles.count, (NSUInteger)3);
    XCTAssertEqualObjects(alertVerifier.actionTitles[0], @"Default");
    XCTAssertEqualObjects(alertVerifier.actionTitles[1], @"Cancel");
    XCTAssertEqualObjects(alertVerifier.actionTitles[2], @"Destroy");
}

- (void)testShowAlert_DefaultButtonShouldHaveDefaultStyle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    XCTAssertEqual([alertVerifier styleForButtonWithTitle:@"Default"], UIAlertActionStyleDefault);
}

- (void)testShowAlert_CancelButtonShouldHaveCancelStyle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    XCTAssertEqual([alertVerifier styleForButtonWithTitle:@"Cancel"], UIAlertActionStyleCancel);
}

- (void)testShowAlert_DestroyButtonShouldHaveDestructiveStyle
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    XCTAssertEqual([alertVerifier styleForButtonWithTitle:@"Destroy"], UIAlertActionStyleDestructive);
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
    
    XCTAssertEqual(alertVerifier.popover.sourceView, tappedButton);
}

- (void)testShowActionSheet_PopoverSourceRectShouldBeTappedButtonBounds
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];
    UIButton *tappedButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 2, 3, 4)];

    [sut showActionSheet:tappedButton];

    XCTAssertEqualObjects(NSStringFromCGRect(alertVerifier.popover.sourceRect), NSStringFromCGRect(tappedButton.bounds));
}

- (void)testShowActionSheet_PopoverPermittedArrowDirectionsShouldBeAnyDirection
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showActionSheet:nil];

    XCTAssertEqual(alertVerifier.popover.permittedArrowDirections, UIPopoverArrowDirectionAny);
}

@end
