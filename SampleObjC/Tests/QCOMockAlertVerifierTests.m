@import MockUIAlertController;

#import "ViewController.h"

@import XCTest;


@interface QCOMockAlertVerifierTests : XCTestCase
@end

@implementation QCOMockAlertVerifierTests
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
    [sut loadViewIfNeeded];
}

- (void)tearDown
{
    alertVerifier = nil;
    sut = nil;
    [super tearDown];
}

- (void)test_tryingToGetStyleForNonexistentButton_shouldThrowException
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    @try {
        [alertVerifier styleForButtonWithTitle:@"NO SUCH BUTTON"];
        XCTFail(@"Expected exception to be thrown");
    } @catch (NSException *exception) {
        XCTAssertEqual(exception.name, NSInternalInconsistencyException, @"name");
        XCTAssertEqualObjects(exception.reason, @"Button not found", @"reason");
    }
}

- (void)test_tryingToExecuteActionForNonexistentButton_shouldThrowException
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    @try {
        [alertVerifier executeActionForButtonWithTitle:@"NO SUCH BUTTON"];
        XCTFail(@"Expected exception to be thrown");
    } @catch (NSException *exception) {
        XCTAssertEqual(exception.name, NSInternalInconsistencyException, @"name");
        XCTAssertEqualObjects(exception.reason, @"Button not found", @"reason");
    }
}

- (void)test_tryingToExecuteActionForButtonWithoutHandler_shouldNotCrash
{
    [sut.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    [alertVerifier executeActionForButtonWithTitle:@"No Handler"];
}

- (void)test_presentingViewControllerThatIsNotAnAlert_shouldNotTriggerVerifier
{
    [sut presentNonAlert];

    XCTAssertEqual(alertVerifier.presentedCount, 0);
}

@end
