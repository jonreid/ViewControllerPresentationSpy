#import <MockUIAlertController/QCOMockAlertVerifier.h>

#import "ViewController.h"

#import <OCHamcrestIOS/OCHamcrestIOS.h>
@import XCTest;


@interface QCOMockAlertVerifierTests : XCTestCase
@end

@implementation QCOMockAlertVerifierTests
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

- (void)testShowAlert_TryingToGetStyleForNonexistentButton_ShouldThrowInternalInconsistency
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];
    
    assertThat(^{ [alertVerifier styleForButtonWithTitle:@"NO SUCH BUTTON"]; },
            throwsException(hasProperty(@"name", NSInternalInconsistencyException)));
}

- (void)testShowAlert_TryingToGetStyleForNonexistentButton_ShouldThrowExceptionWithReason
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    assertThat(^{ [alertVerifier styleForButtonWithTitle:@"NO SUCH BUTTON"]; },
            throwsException(hasProperty(@"reason", @"Button not found")));
}

- (void)testShowAlert_TryingToExecuteActionForNonexistentButton_ShouldThrowInternalInconsistency
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    assertThat(^{ [alertVerifier executeActionForButtonWithTitle:@"NO SUCH BUTTON"]; },
            throwsException(hasProperty(@"name", NSInternalInconsistencyException)));
}

- (void)testShowAlert_TryingToExecuteActionForNonexistentButton_ShouldThrowExceptionWithReason
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    assertThat(^{ [alertVerifier executeActionForButtonWithTitle:@"NO SUCH BUTTON"]; },
            throwsException(hasProperty(@"reason", @"Button not found")));
}

- (void)testShowAlert_TryingToExecuteActionForButtonWithoutHandler_ShouldNotCrash
{
    QCOMockAlertVerifier *alertVerifier = [[QCOMockAlertVerifier alloc] init];

    [sut showAlert:nil];

    [alertVerifier executeActionForButtonWithTitle:@"No Handler"];
}

@end
