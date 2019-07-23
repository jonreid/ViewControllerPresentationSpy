@import ViewControllerPresentationSpy;

#import "ViewController.h"

@import XCTest;


@interface PresentationVerifierTests : XCTestCase
@end

@implementation PresentationVerifierTests
{
    QCOPresentationVerifier *sut;
    ViewController *vc;
}

- (void)setUp
{
    [super setUp];
    sut = [[QCOPresentationVerifier alloc] init];
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

- (void)presentViewController
{
    [vc.codePresentModalButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)test_presentingVC_withCompletion_shouldCaptureCompletionBlock
{
    __block int completionCallCount = 0;
    vc.viewControllerPresentedCompletion = ^{
        completionCallCount += 1;
    };
    
    [self presentViewController];
    
    XCTAssertEqual(completionCallCount, 0, @"precondition");
    sut.capturedCompletion();
    XCTAssertEqual(completionCallCount, 1);
}

- (void)test_presentingVC_withoutCompletion_shouldNotCaptureCompletionBlock
{
    [self presentViewController];
    
    XCTAssertNil(sut.capturedCompletion);
}

- (void)test_presentingVC_shouldExecuteCompletionBlock
{
    __block int completionCallCount = 0;
    sut.completion = ^{
        completionCallCount += 1;
    };
    
    [self presentViewController];
    
    XCTAssertEqual(completionCallCount, 1);
}

- (void)test_notPresentingVC_shouldNotExecuteCompletionBlock
{
    __block int completionCallCount = 0;
    sut.completion = ^{
        completionCallCount += 1;
    };
    
    XCTAssertEqual(completionCallCount, 0);
}
 
@end
