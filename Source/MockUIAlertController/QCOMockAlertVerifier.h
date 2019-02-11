//  MockUIAlertController by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 Jonathan M. Reid. See LICENSE.txt

#import <UIKit/UIKit.h>

#import "QCOMockPopoverPresentationController.h" // Convenience import instead of @class


NS_ASSUME_NONNULL_BEGIN

/*!
 * @abstract Captures mocked UIAlertController arguments.
 * @discussion Instantiate a QCOMockAlertVerifier before the execution phase of the test. Then
 * invoke the code to create and present your alert. Information about the alert is then available
 * through the QCOMockAlertVerifier.
 */
@interface QCOMockAlertVerifier : NSObject

@property (nonatomic, assign) NSUInteger presentedCount;
@property (nonatomic, strong) UIViewController *presentingViewController;
@property (nonatomic, assign) BOOL animated;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;
@property (nonatomic, assign) UIAlertControllerStyle preferredStyle;
@property (nonatomic, copy) NSArray<UIAlertAction *> *actions;
@property (nullable, nonatomic, strong) UIAlertAction *preferredAction;
@property (nonatomic, readonly) NSArray *actionTitles DEPRECATED_MSG_ATTRIBUTE("Use actions");
@property (nullable, nonatomic, strong) QCOMockPopoverPresentationController *popover;
@property (nullable, nonatomic, copy) NSArray<UITextField *> *textFields;
@property (nullable, nonatomic, copy) void (^completion)(void);

/*!
 * @abstract Initializes a newly allocated verifier.
 * @discussion Instantiating a QCOMockAlertVerifier swizzles UIAlertController. It remains swizzled
 * until the QCOMockAlertVerifier is deallocated.
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/*!
 * @abstract Returns the UIAlertActionStyle for the button with the specified title.
 * @discussion Throws an exception if no button with that title is found.
 */
- (UIAlertActionStyle)styleForButtonWithTitle:(NSString *)title DEPRECATED_MSG_ATTRIBUTE("Use actions");

/*!
 * @abstract Executes the action for the button with the specified title.
 * @discussion Throws an exception if no button with that title is found.
 */
- (void)executeActionForButtonWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
