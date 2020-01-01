//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org/
//  Copyright 2020 Quality Coding, Inc. See LICENSE.txt

#import "UIViewController+QCOMock.h"

#import "NSObject+QCOMockAlerts.h"
#import "UIAlertController+QCOMock.h"
#import <ViewControllerPresentationSpy/ViewControllerPresentationSpy-Swift.h>

NSString *const QCOMockViewControllerPresentingViewControllerKey = @"QCOMockViewControllerPresentingViewControllerKey";
NSString *const QCOMockViewControllerAnimatedKey = @"QCOMockViewControllerAnimatedKey";
NSString *const QCOMockViewControllerCompletionKey = @"QCOMockViewControllerCompletionKey";
NSString *const QCOMockViewControllerPresentedNotification = @"QCOMockViewControllerPresentedNotification";
NSString *const QCOMockViewControllerDismissedNotification = @"QCOMockViewControllerDismissedNotification";

@implementation UIViewController (QCOMock)

+ (void)qcoMock_swizzleCaptureAlert
{
    [self qcoMockAlerts_replaceInstanceMethod:@selector(presentViewController:animated:completion:)
                                   withMethod:@selector(qcoMock_presentViewControllerCapturingAlert:animated:completion:)];
}

+ (void)qcoMock_swizzleCaptureViewController
{
    [self qcoMockAlerts_replaceInstanceMethod:@selector(presentViewController:animated:completion:)
                                   withMethod:@selector(qcoMock_presentViewControllerCapturingIt:animated:completion:)];
}

+ (void)qcoMock_swizzleCaptureDismiss
{
    [self qcoMockAlerts_replaceInstanceMethod:@selector(dismissViewControllerAnimated:completion:)
                                   withMethod:@selector(qcoMock_dismissViewControllerAnimated:completion:)];
}

- (void)qcoMock_presentViewControllerCapturingAlert:(UIViewController *)viewControllerToPresent
                                           animated:(BOOL)flag
                                         completion:(void (^ __nullable)(void))completion
{
    if (![viewControllerToPresent isKindOfClass:[UIAlertController class]])
        return;
    
    [viewControllerToPresent loadViewIfNeeded];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    QCOClosureContainer *closureContainer = [[QCOClosureContainer alloc] initWithClosure:completion];
    [nc postNotificationName:QCOMockAlertControllerPresentedNotification
                      object:viewControllerToPresent
                    userInfo:@{
                            QCOMockViewControllerPresentingViewControllerKey: self,
                            QCOMockViewControllerAnimatedKey: @(flag),
                            QCOMockViewControllerCompletionKey: closureContainer,
                    }];
}

- (void)qcoMock_presentViewControllerCapturingIt:(UIViewController *)viewControllerToPresent
                                        animated:(BOOL)flag
                                      completion:(void (^ __nullable)(void))completion
{
    [viewControllerToPresent loadViewIfNeeded];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    QCOClosureContainer *closureContainer = [[QCOClosureContainer alloc] initWithClosure:completion];
    [nc postNotificationName:QCOMockViewControllerPresentedNotification
                      object:viewControllerToPresent
                    userInfo:@{
                            QCOMockViewControllerPresentingViewControllerKey: self,
                            QCOMockViewControllerAnimatedKey: @(flag),
                            QCOMockViewControllerCompletionKey: closureContainer,
                    }];
}

- (void)qcoMock_dismissViewControllerAnimated:(BOOL)flag
                                   completion:(void (^ __nullable)(void))completion
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    QCOClosureContainer *closureContainer = [[QCOClosureContainer alloc] initWithClosure:completion];
    [nc postNotificationName:QCOMockViewControllerDismissedNotification
                      object:self
                    userInfo:@{
                            QCOMockViewControllerAnimatedKey: @(flag),
                            QCOMockViewControllerCompletionKey: closureContainer,
                    }];
}

@end
