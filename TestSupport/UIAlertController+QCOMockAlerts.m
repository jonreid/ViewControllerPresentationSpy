//  MockUIAlertController by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "UIAlertController+QCOMockAlerts.h"

#import "NSObject+QCOMockAlerts.h"
#import "QCOMockPopoverPresentationController.h"
#import <objc/runtime.h>

NSString *const QCOMockAlertControllerPresentedNotification = @"QCOMockAlertControllerPresentedNotification";

static char const * const preferredAlertStyleKey = "qcoMockAlerts_preferredAlertStyle";
static char const * const mockPopoverKey = "qcoMockAlerts_mockPopover";

@interface UIAlertController ()
@property (nonatomic, strong) QCOMockPopoverPresentationController *qcoMockAlerts_mockPopover;
@end


@implementation UIAlertController (QCOMockAlerts)

+ (void)qcoMock_swizzle
{
    [self qcoMockAlerts_replaceClassMethod:@selector(alertControllerWithTitle:message:preferredStyle:)
                                withMethod:@selector(qcoMockAlerts_alertControllerWithTitle:message:preferredStyle:)];
    [self qcoMockAlerts_replaceInstanceMethod:@selector(popoverPresentationController)
                                   withMethod:@selector(qcoMockAlerts_popoverPresentationController)];
}

+ (instancetype)qcoMockAlerts_alertControllerWithTitle:(NSString *)title
                                               message:(NSString *)message
                                        preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    return [[self alloc] initQCOMockWithTitle:title message:message preferredStyle:preferredStyle];
}

- (instancetype)initQCOMockWithTitle:(NSString *)title
                             message:(NSString *)message
                      preferredStyle:(UIAlertControllerStyle)style
{
    self = [super init];
    if (self)
    {
        self.title = title;
        self.message = message;
        self.qcoMockAlerts_preferredAlertStyle = style;
        self.qcoMockAlerts_mockPopover = [[QCOMockPopoverPresentationController alloc] init];
    }
    return self;
}

- (UIPopoverPresentationController *)qcoMockAlerts_popoverPresentationController
{
    return (id)self.qcoMockAlerts_mockPopover;
}

- (UIAlertControllerStyle)qcoMockAlerts_preferredAlertStyle
{
    NSNumber *style = objc_getAssociatedObject(self, preferredAlertStyleKey);
    return (UIAlertControllerStyle)style.intValue;
}

- (void)setQcoMockAlerts_preferredAlertStyle:(UIAlertControllerStyle)style
{
    objc_setAssociatedObject(self, preferredAlertStyleKey, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QCOMockPopoverPresentationController *)qcoMockAlerts_mockPopover
{
    return objc_getAssociatedObject(self, mockPopoverKey);
}

- (void)setQcoMockAlerts_mockPopover:(QCOMockPopoverPresentationController *)popover
{
    objc_setAssociatedObject(self, mockPopoverKey, popover, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
