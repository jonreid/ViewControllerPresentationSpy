//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2022 Jonathan M. Reid. See LICENSE.txt

#import "UIViewController+QCOMock.h"

#import "NSObject+QCOMockAlerts.h"
#if __has_include("ViewControllerPresentationSpy-Swift.h")
    #import "ViewControllerPresentationSpy-Swift.h"
#else
    #import <ViewControllerPresentationSpy/ViewControllerPresentationSpy-Swift.h>
#endif

NSString *const QCOMockViewControllerPresentingViewControllerKey = @"QCOMockViewControllerPresentingViewControllerKey";
NSString *const QCOMockViewControllerAnimatedKey = @"QCOMockViewControllerAnimatedKey";
NSString *const QCOMockViewControllerCompletionKey = @"QCOMockViewControllerCompletionKey";
NSString *const QCOMockViewControllerPresentedNotification = @"QCOMockViewControllerPresentedNotification";
NSString *const QCOMockViewControllerDismissedNotification = @"QCOMockViewControllerDismissedNotification";
NSString *const QCOMockAlertControllerPresentedNotification = @"QCOMockAlertControllerPresentedNotification";

@implementation UIViewController (QCOMock)

+ (void)qcoMock_swizzleCapturePresent
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
    
    QCOClosureContainer *closureContainer = [[QCOClosureContainer alloc] initWithClosure:completion];
    [self viewControllerToPresent:viewControllerToPresent animated:flag closureContainer:closureContainer];
}

- (void)viewControllerToPresent:(UIViewController *)viewControllerToPresent animated:(BOOL)flag closureContainer:(QCOClosureContainer *)closureContainer
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
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
