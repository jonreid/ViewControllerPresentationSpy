//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 Jonathan M. Reid. See LICENSE.txt

#import "QCOMockPresentationVerifier.h"

#import "UIViewController+QCOMock.h"

static void swizzleMocks(void)
{
    [UIViewController qcoMock_swizzleCaptureViewController];
}

@implementation QCOMockPresentationVerifier

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(viewControllerWasPresented:)
                                                     name:QCOMockViewControllerPresentedNotification
                                                   object:nil];
        swizzleMocks();
    }
    return self;
}

- (void)dealloc
{
    swizzleMocks();
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewControllerWasPresented:(NSNotification *)notification
{
    self.presentedCount += 1;
    self.presentedViewController = notification.object;
    self.presentingViewController = notification.userInfo[QCOMockViewControllerPresentingViewControllerKey];
    self.animated = [notification.userInfo[QCOMockViewControllerAnimatedKey] boolValue];
    if (self.completion)
        self.completion();
}

@end
