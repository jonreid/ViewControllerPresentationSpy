//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2021 Quality Coding, Inc. See LICENSE.txt

#import "CodeNextViewController.h"

#import "StoryboardNextViewController.h"
#import "ViewController.h"

@import ViewControllerPresentationSpy;
@import XCTest;

@interface ViewControllerPresentationTests : XCTestCase
@end

@implementation ViewControllerPresentationTests

{
    QCOPresentationVerifier *presentationVerifier;
    ViewController *sut;
}

- (void)setUp
{
    [super setUp];
    presentationVerifier = [[QCOPresentationVerifier alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    sut = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ViewController class])];
    [sut loadViewIfNeeded];
}

- (void)tearDown
{
    [NSRunLoop.currentRunLoop runUntilDate:NSDate.date]; // Free objects after segue show
    presentationVerifier = nil;
    sut = nil;
    [super tearDown];
}

- (void)test_outlets_shouldBeConnected
{
    XCTAssertNotNil(sut.seguePresentModalButton);
    XCTAssertNotNil(sut.segueShowButton);
    XCTAssertNotNil(sut.codePresentModalButton);
}

- (void)test_tappingSeguePresentModalButton_shouldPresentNextViewControllerWithGreenBackground
{
    [sut.seguePresentModalButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    XCTAssertEqual(presentationVerifier.presentedCount, 1, @"presented count");
    XCTAssertEqual(presentationVerifier.presentingViewController, sut, @"presenting view controller");
    XCTAssertTrue(presentationVerifier.animated, @"animated");
    if (![presentationVerifier.presentedViewController isKindOfClass:[StoryboardNextViewController class]])
    {
        XCTFail(@"Expected presented view controller to be %@, but was %@",
                [StoryboardNextViewController class], presentationVerifier.presentedViewController);
        return;
    }
    StoryboardNextViewController *nextVC = (StoryboardNextViewController *)presentationVerifier.presentedViewController;
    XCTAssertEqual(nextVC.backgroundColor, UIColor.greenColor, @"Background color passed in");
}

- (void)test_tappingSegueShowButton_shouldShowNextViewControllerWithRedBackground
{
    UIWindow *window = [[UIWindow alloc] init];
    window.rootViewController = sut;
    window.hidden = NO;

    [sut.segueShowButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    XCTAssertEqual(presentationVerifier.presentedCount, 1, @"presented count");
    XCTAssertEqual(presentationVerifier.presentingViewController, sut, @"presenting view controller");
    XCTAssertTrue(presentationVerifier.animated, @"animated");
    if (![presentationVerifier.presentedViewController isKindOfClass:[StoryboardNextViewController class]])
    {
        XCTFail(@"Expected presented view controller to be %@, but was %@",
                [StoryboardNextViewController class], presentationVerifier.presentedViewController);
        return;
    }
    StoryboardNextViewController *nextVC = (StoryboardNextViewController *)presentationVerifier.presentedViewController;
    XCTAssertEqual(nextVC.backgroundColor, UIColor.redColor, @"Background color passed in");
}

- (void)test_tappingCodeModalButton_shouldPresentNextViewControllerWithPurpleBackground
{
    [sut.codePresentModalButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    XCTAssertEqual(presentationVerifier.presentedCount, 1, @"presented count");
    XCTAssertEqual(presentationVerifier.presentingViewController, sut, @"presenting view controller");
    XCTAssertTrue(presentationVerifier.animated, @"animated");
    if (![presentationVerifier.presentedViewController isKindOfClass:[CodeNextViewController class]])
    {
        XCTFail(@"Expected presented view controller to be %@, but was %@",
                [ViewController class], presentationVerifier.presentedViewController);
        return;
    }
    CodeNextViewController *nextVC = (CodeNextViewController *)presentationVerifier.presentedViewController;
    XCTAssertEqual(nextVC.backgroundColor, UIColor.purpleColor, @"Background color passed in");
}

@end
