//  MockUIAlertController by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "UIViewController+QCOMockAlerts.h"

#import "QCOMockAlertController.h"
#import <objc/runtime.h>


@implementation UIViewController (QCOMockAlerts)

+ (void)qcoMockAlerts_swizzle
{
    SEL originalSelector = @selector(presentViewController:animated:completion:);
    SEL swizzledSelector = @selector(qcoMockAlerts_presentViewController:animated:completion:);
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)qcoMockAlerts_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if (![viewControllerToPresent isKindOfClass:[QCOMockAlertController class]])
    {
        [self qcoMockAlerts_presentViewController:viewControllerToPresent animated:flag completion:completion];
        return;
    }

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:QCOMockAlertControllerPresentedNotification
                      object:viewControllerToPresent
                    userInfo:@{ @"animated": @(flag) }];
    if (completion)
        completion();
}

@end
