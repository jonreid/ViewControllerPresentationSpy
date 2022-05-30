// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2022 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const QCOMockViewControllerPresentingViewControllerKey;
extern NSString *const QCOMockViewControllerAnimatedKey;
extern NSString *const QCOMockViewControllerCompletionKey;
extern NSString *const QCOMockViewControllerPresentedNotification;
extern NSString *const QCOMockViewControllerDismissedNotification;
extern NSString *const QCOMockAlertControllerPresentedNotification;

@interface UIViewController (QCOMock)

+ (void)qcoMock_swizzleCapturePresent;
+ (void)qcoMock_swizzleCaptureDismiss;
@end

NS_ASSUME_NONNULL_END
