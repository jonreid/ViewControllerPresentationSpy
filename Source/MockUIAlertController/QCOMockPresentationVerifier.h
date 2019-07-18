//  MockUIAlertController by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 Jonathan M. Reid. See LICENSE.txt

#import <UIKit/UIKit.h>

#import "QCOMockPopoverPresentationController.h" // Convenience import instead of @class


NS_ASSUME_NONNULL_BEGIN

/*!
 * @abstract Captures mocked presented view controllers.
 * @discussion Instantiate a QCOMockPresentationVerifier before the execution phase of the test. Then
 * invoke the code to create and present your view controller. Information about the view controller
 * is then available through the QCOMockPresentationVerifier.
 */
@interface QCOMockPresentationVerifier : NSObject

@property (nonatomic, assign) NSUInteger presentedCount;
@property (nonatomic, strong) UIViewController *presentedViewController;
@property (nonatomic, strong) UIViewController *presentingViewController;
@property (nonatomic, assign) BOOL animated;
@property (nullable, nonatomic, copy) void (^completion)(void);

/*!
 * @abstract Initializes a newly allocated verifier.
 * @discussion Instantiating a QCOMockPresentationVerifier swizzles UIViewController. It remains swizzled
 * until the QCOMockPresentationVerifier is deallocated.
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
