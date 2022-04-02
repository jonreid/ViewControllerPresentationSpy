//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2022 Jonathan M. Reid. See LICENSE.txt

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const QCOMockViewControllerPresentingViewControllerKey;
extern NSString *const QCOMockViewControllerAnimatedKey;
extern NSString *const QCOMockViewControllerCompletionKey;
extern NSString *const QCOMockViewControllerPresentedNotification;
extern NSString *const QCOMockViewControllerDismissedNotification;
extern NSString *const QCOMockAlertControllerPresentedNotification;

@interface UIViewController (QCOMock)
+ (void)qcoMock_swizzleCaptureAlert;
+ (void)qcoMock_swizzleCaptureViewController;
+ (void)qcoMock_swizzleCaptureDismiss;
@end

NS_ASSUME_NONNULL_END
