//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2022 Jonathan M. Reid. See LICENSE.txt

#import "UIAlertController+QCOMock.h"

#import "NSObject+QCOMockAlerts.h"
#import "QCOMockPopoverPresentationController.h"
#import <objc/runtime.h>
#import "ViewControllerPresentationSpy/ViewControllerPresentationSpy-Swift.h"

NSString *const QCOMockAlertControllerPresentedNotification = @"QCOMockAlertControllerPresentedNotification";

@interface UIAlertController ()
#if TARGET_OS_IOS
@property (nonatomic, strong) QCOMockPopoverPresentationController *qcoMock_mockPopover;
#endif
@end

@implementation UIAlertController (QCOMock)

- (instancetype)initQCOMockWithTitle:(NSString *)title
                             message:(NSString *)message
                      preferredStyle:(UIAlertControllerStyle)style
{
    self = [super init];
    if (self)
    {
        self.title = title;
        self.message = message;
        [self attachExtraPropertiesWithStyle:style];
#if TARGET_OS_IOS
        self.qcoMock_mockPopover = [[QCOMockPopoverPresentationController alloc] init];
#endif
    }
    return self;
}

#if TARGET_OS_IOS

- (QCOMockPopoverPresentationController *)qcoMock_mockPopover
{
    return objc_getAssociatedObject(self, @selector(qcoMock_mockPopover));
}

- (void)setQcoMock_mockPopover:(QCOMockPopoverPresentationController *)popover
{
    objc_setAssociatedObject(self, @selector(qcoMock_mockPopover), popover, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#endif

@end
