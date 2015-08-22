//  MockUIAlertController by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "UIViewController+QCOMock.h"

#import "NSObject+QCOMockAlerts.h"
#import "UIAlertController+QCOMock.h"

NSString *const QCOMockViewControllerAnimatedKey = @"QCOMockViewControllerAnimatedKey";


@implementation UIViewController (QCOMock)

+ (void)qcoMock_swizzle
{
    [self qcoMockAlerts_replaceInstanceMethod:@selector(presentViewController:animated:completion:)
                                   withMethod:@selector(qcoMock_presentViewController:animated:completion:)];
}

- (void)qcoMock_presentViewController:(UIViewController *)viewControllerToPresent
                             animated:(BOOL)flag
                           completion:(void (^)(void))completion
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:QCOMockAlertControllerPresentedNotification
                      object:viewControllerToPresent
                    userInfo:@{ QCOMockViewControllerAnimatedKey : @(flag) }];
    if (completion)
        completion();
}

@end
