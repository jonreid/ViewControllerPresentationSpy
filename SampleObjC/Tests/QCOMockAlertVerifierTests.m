@import MockUIAlertController;

#import "ViewController.h"

@import XCTest;


@interface QCOMockAlertVerifierTests : XCTestCase
@end

@implementation QCOMockAlertVerifierTests
{
    QCOMockAlertVerifier *sut;
    ViewController *vc;
}

- (void)setUp
{
    [super setUp];
    sut = [[QCOMockAlertVerifier alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    vc = [storyboard instantiateViewControllerWithIdentifier:@"main"];
    [vc loadViewIfNeeded];
}

- (void)tearDown
{
    sut = nil;
    vc = nil;
    [super tearDown];
}

- (void)showAlert
{
    [vc.showAlertButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)test_styleForButtonWithTitle_withNonexistentTitle_shouldThrowException
{
    [self showAlert];
    
    @try {
        [sut styleForButtonWithTitle:@"NO SUCH BUTTON"];
        XCTFail(@"Expected exception to be thrown");
    } @catch (NSException *exception) {
        XCTAssertEqual(exception.name, NSInternalInconsistencyException, @"name");
        XCTAssertEqualObjects(exception.reason, @"Button not found", @"reason");
    }
}

- (void)test_executeActionForButtonWithTitle_withNonexistentTitle_shouldThrowException
{
    [self showAlert];

    @try {
        [sut executeActionForButtonWithTitle:@"NO SUCH BUTTON"];
        XCTFail(@"Expected exception to be thrown");
    } @catch (NSException *exception) {
        XCTAssertEqual(exception.name, NSInternalInconsistencyException, @"name");
        XCTAssertEqualObjects(exception.reason, @"Button not found", @"reason");
    }
}

- (void)test_executeActionForButtonWithTitle_withoutHandler_shouldNotCrash
{
    [self showAlert];

    [sut executeActionForButtonWithTitle:@"No Handler"];
}

- (void)test_presentingNonAlertViewController_shouldNotTriggerVerifier
{
    [vc presentNonAlert];

    XCTAssertEqual(sut.presentedCount, 0);
}

- (void)test_showingAlert_shouldExecuteCompletionBlock
{
    __block int completionCallCount = 0;
    sut.completion = ^{
        completionCallCount += 1;
    };
    
    [self showAlert];
    
    XCTAssertEqual(completionCallCount, 1);
}

- (void)test_notShowingAlert_shouldNotExecuteCompletionBlock
{
    __block int completionCallCount = 0;
    sut.completion = ^{
        completionCallCount += 1;
    };
    
    XCTAssertEqual(completionCallCount, 0);
}

@end
