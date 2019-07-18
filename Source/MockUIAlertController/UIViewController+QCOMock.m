//  MockUIAlertController by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 Jonathan M. Reid. See LICENSE.txt

#import "UIViewController+QCOMock.h"

#import "NSObject+QCOMockAlerts.h"
#import "UIAlertController+QCOMock.h"

NSString *const QCOMockViewControllerPresentingViewControllerKey = @"QCOMockViewControllerPresentingViewControllerKey";
NSString *const QCOMockViewControllerAnimatedKey = @"QCOMockViewControllerAnimatedKey";
NSString *const QCOMockViewControllerPresentedNotification = @"QCOMockViewControllerPresentedNotification";


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

- (void)qcoMock_presentViewControllerCapturingAlert:(UIViewController *)viewControllerToPresent
                                           animated:(BOOL)flag
                                         completion:(void (^ __nullable)(void))completion
{
    if (![viewControllerToPresent isKindOfClass:[UIAlertController class]])
        return;

    [viewControllerToPresent loadViewIfNeeded];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:QCOMockAlertControllerPresentedNotification
                      object:viewControllerToPresent
                    userInfo:@{
                            QCOMockViewControllerPresentingViewControllerKey : self,
                            QCOMockViewControllerAnimatedKey : @(flag),
                    }];
    if (completion)
        completion();
}

- (void)qcoMock_presentViewControllerCapturingIt:(UIViewController *)viewControllerToPresent
                                        animated:(BOOL)flag
                                      completion:(void (^ __nullable)(void))completion
{
    [viewControllerToPresent loadViewIfNeeded];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:QCOMockViewControllerPresentedNotification
                      object:viewControllerToPresent
                    userInfo:@{
                            QCOMockViewControllerPresentingViewControllerKey : self,
                            QCOMockViewControllerAnimatedKey : @(flag),
                    }];
    if (completion)
        completion();
}

@end
