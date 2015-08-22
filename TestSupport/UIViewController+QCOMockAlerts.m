//  MockUIAlertController by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "UIViewController+QCOMockAlerts.h"

#import "NSObject+QCOMockAlerts.h"
#import "UIAlertController+QCOMockAlerts.h"


@implementation UIViewController (QCOMockAlerts)

+ (void)qcoMock_swizzle
{
    [self qcoMock_replaceInstanceMethod:@selector(presentViewController:animated:completion:)
                             withMethod:@selector(qcoMock_presentViewController:animated:completion:)];
}

- (void)qcoMock_presentViewController:(UIViewController *)viewControllerToPresent
                             animated:(BOOL)flag
                           completion:(void (^)(void))completion
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:QCOMockAlertControllerPresentedNotification
                      object:viewControllerToPresent
                    userInfo:@{ @"animated": @(flag) }];
    if (completion)
        completion();
}

@end
