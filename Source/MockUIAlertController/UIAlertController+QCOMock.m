//  MockUIAlertController by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "UIAlertController+QCOMock.h"

#import "NSObject+QCOMockAlerts.h"
#import "QCOMockPopoverPresentationController.h"
#import <objc/runtime.h>

NSString *const QCOMockAlertControllerPresentedNotification = @"QCOMockAlertControllerPresentedNotification";

@interface UIAlertController ()
@property (nonatomic, strong) QCOMockPopoverPresentationController *qcoMock_mockPopover;
@end


@implementation UIAlertController (QCOMock)

+ (void)qcoMock_swizzle
{
    [self qcoMockAlerts_replaceClassMethod:@selector(alertControllerWithTitle:message:preferredStyle:)
                                withMethod:@selector(qcoMock_alertControllerWithTitle:message:preferredStyle:)];
    [self qcoMockAlerts_replaceInstanceMethod:@selector(popoverPresentationController)
                                   withMethod:@selector(qcoMock_popoverPresentationController)];
}

+ (instancetype)qcoMock_alertControllerWithTitle:(NSString *)title
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
        self.qcoMock_preferredAlertStyle = style;
        self.qcoMock_mockPopover = [[QCOMockPopoverPresentationController alloc] init];
    }
    return self;
}

- (UIPopoverPresentationController *)qcoMock_popoverPresentationController
{
    return (id)self.qcoMock_mockPopover;
}

- (UIAlertControllerStyle)qcoMock_preferredAlertStyle
{
    NSNumber *style = objc_getAssociatedObject(self, @selector(qcoMock_preferredAlertStyle));
    return (UIAlertControllerStyle)style.intValue;
}

- (void)setQcoMock_preferredAlertStyle:(UIAlertControllerStyle)style
{
    objc_setAssociatedObject(self, @selector(qcoMock_preferredAlertStyle), @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QCOMockPopoverPresentationController *)qcoMock_mockPopover
{
    return objc_getAssociatedObject(self, @selector(qcoMock_mockPopover));
}

- (void)setQcoMock_mockPopover:(QCOMockPopoverPresentationController *)popover
{
    objc_setAssociatedObject(self, @selector(qcoMock_mockPopover), popover, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
