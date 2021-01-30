//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2021 Quality Coding, Inc. See LICENSE.txt

@import ViewControllerPresentationSpy;

#import "StoryboardNextViewController.h"

@import XCTest;


@interface DismissalVerifierTests : XCTestCase
@end

@implementation DismissalVerifierTests
{
    QCODismissalVerifier *sut;
    StoryboardNextViewController *vc;
}

- (void)setUp
{
    [super setUp];
    sut = [[QCODismissalVerifier alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([StoryboardNextViewController class])];
    [vc loadViewIfNeeded];
}

- (void)tearDown
{
    sut = nil;
    vc = nil;
    [super tearDown];
}

- (void)dismissViewController
{
    UIBarButtonItem *button = vc.cancelButton;
    [button.target performSelector:button.action withObject:nil];
}

- (void)test_dismissingVC_shouldCaptureAnimationFlag
{
    [self dismissViewController];
    
    XCTAssertTrue(sut.animated);
}

- (void)test_dismissingVC_shouldCaptureDismissedViewController
{
    [self dismissViewController];
    
    XCTAssertEqual(sut.dismissedViewController, vc);
}

- (void)test_dismissingVC_withCompletion_shouldCaptureCompletionBlock
{
    __block int completionCallCount = 0;
    vc.viewControllerDismissedCompletion = ^{
        completionCallCount += 1;
    };
    
    [self dismissViewController];
    
    XCTAssertEqual(completionCallCount, 0, @"precondition");
    sut.capturedCompletion();
    XCTAssertEqual(completionCallCount, 1);
}

- (void)test_dismissingVC_withoutCompletion_shouldNotCaptureCompletionBlock
{
    [self dismissViewController];
    
    XCTAssertNil(sut.capturedCompletion);
}

- (void)test_dismissingVC_shouldExecuteCompletionBlock
{
    __block int completionCallCount = 0;
    sut.testCompletion = ^{
        completionCallCount += 1;
    };
    
    [self dismissViewController];
    
    XCTAssertEqual(completionCallCount, 1);
}

- (void)test_notDismissingVC_shouldNotExecuteCompletionBlock
{
    __block int completionCallCount = 0;
    sut.testCompletion = ^{
        completionCallCount += 1;
    };
    
    XCTAssertEqual(completionCallCount, 0);
}

@end
