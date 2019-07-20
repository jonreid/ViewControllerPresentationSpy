#import "CodeNextViewController.h"

#import "StoryboardNextViewController.h"
#import "ViewController.h"

@import MockUIAlertController;
@import XCTest;

@interface ViewControllerPresentationTests : XCTestCase
@end

@implementation ViewControllerPresentationTests

{
    QCOMockPresentationVerifier *presentationVerifier;
    ViewController *sut;
}

- (void)setUp
{
    [super setUp];
    presentationVerifier = [[QCOMockPresentationVerifier alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    sut = [storyboard instantiateViewControllerWithIdentifier:@"main"];
    [sut loadViewIfNeeded];
}

- (void)tearDown
{
    presentationVerifier = nil;
    sut = nil;
    [super tearDown];
}

- (void)test_outlets_shouldBeConnected
{
    XCTAssertNotNil(sut.seguePresentModalButton);
    XCTAssertNotNil(sut.codeModalButton);
}

- (void)test_tappingSeguePresentModalButton_shouldPresentNextViewControllerWithGreenBackground
{
    [sut.seguePresentModalButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    XCTAssertEqual(presentationVerifier.presentedCount, 1, @"presented count");
    XCTAssertEqual(presentationVerifier.presentingViewController, sut, @"presenting view controller");
    XCTAssertTrue(presentationVerifier.animated, @"animated");
    if (![presentationVerifier.presentedViewController isKindOfClass:[StoryboardNextViewController class]]) {
        XCTFail(@"Expected presented view controller to be %@, but was %@",
                [StoryboardNextViewController class], presentationVerifier.presentedViewController);
        return;
    }
    StoryboardNextViewController *nextVC = (StoryboardNextViewController *)presentationVerifier.presentedViewController;
    XCTAssertEqual(nextVC.backgroundColor, UIColor.greenColor, @"Background color passed in");
}

- (void)test_tappingCodeModalButton_shouldPresentNextViewControllerWithPurpleBackground
{
    [sut.codeModalButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    XCTAssertEqual(presentationVerifier.presentedCount, 1, @"presented count");
    XCTAssertEqual(presentationVerifier.presentingViewController, sut, @"presenting view controller");
    XCTAssertTrue(presentationVerifier.animated, @"animated");
    if (![presentationVerifier.presentedViewController isKindOfClass:[CodeNextViewController class]]) {
        XCTFail(@"Expected presented view controller to be %@, but was %@",
                [ViewController class], presentationVerifier.presentedViewController);
        return;
    }
    CodeNextViewController *nextVC = (CodeNextViewController *)presentationVerifier.presentedViewController;
    XCTAssertEqual(nextVC.backgroundColor, UIColor.purpleColor, @"Background color passed in");
}

@end
