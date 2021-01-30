//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2021 Quality Coding, Inc. See LICENSE.txt

@import ViewControllerPresentationSpy;

#import "ViewController.h"

@import XCTest;

@interface AlertVerifierTests : XCTestCase
@end

@implementation AlertVerifierTests
{
    QCOAlertVerifier *sut;
    ViewController *vc;
}

- (void)setUp
{
    [super setUp];
    sut = [[QCOAlertVerifier alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ViewController class])];
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

- (void)test_executeActionForButtonWithTitle_withNonexistentTitle_shouldReturnError
{
    [self showAlert];

    NSError *error = nil;
    [sut executeActionForButton:@"NO SUCH BUTTON" andReturnError:&error];

    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, 0); // buttonNotFound
    XCTAssertEqualObjects(error.domain, @"ViewControllerPresentationSpy.AlertVerifierErrors");
}

- (void)test_executeActionForButtonWithTitle_withoutHandler_shouldNotCrash
{
    [self showAlert];

    NSError *error = nil;
    [sut executeActionForButton:@"No Handler" andReturnError:&error];

    XCTAssertNil(error);
}

- (void)test_presentingNonAlertViewController_shouldNotTriggerVerifier
{
    [vc presentNonAlert];

    XCTAssertEqual(sut.presentedCount, 0);
}

- (void)test_showingAlert_withCompletion_shouldCaptureCompletionBlock
{
    __block int completionCallCount = 0;
    vc.alertPresentedCompletion = ^{
        completionCallCount += 1;
    };
    
    [self showAlert];
    
    XCTAssertEqual(completionCallCount, 0, @"precondition");
    sut.capturedCompletion();
    XCTAssertEqual(completionCallCount, 1);
}

- (void)test_showingAlert_withoutCompletion_shouldNotCaptureCompletionBlock
{
    [self showAlert];
    
    XCTAssertNil(sut.capturedCompletion);
}

- (void)test_showingAlert_shouldExecuteTestCompletionBlock
{
    __block int completionCallCount = 0;
    sut.testCompletion = ^{
        completionCallCount += 1;
    };
    
    [self showAlert];
    
    XCTAssertEqual(completionCallCount, 1);
}

- (void)test_notShowingAlert_shouldNotExecuteTestCompletionBlock
{
    __block int completionCallCount = 0;
    sut.testCompletion = ^{
        completionCallCount += 1;
    };
    
    XCTAssertEqual(completionCallCount, 0);
}

@end
