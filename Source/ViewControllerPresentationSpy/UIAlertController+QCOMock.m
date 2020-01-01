//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org/
//  Copyright 2020 Quality Coding, Inc. See LICENSE.txt

#import "UIAlertController+QCOMock.h"

#import "NSObject+QCOMockAlerts.h"
#import "QCOMockPopoverPresentationController.h"
#import <objc/runtime.h>

NSString *const QCOMockAlertControllerPresentedNotification = @"QCOMockAlertControllerPresentedNotification";

@interface UIAlertController ()
@property (nonatomic, strong) QCOMockPopoverPresentationController *qcoMock_mockPopover;
@property (nonatomic, readwrite) UIAlertControllerStyle preferredStyle;
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
        self.preferredStyle = style;
        self.qcoMock_mockPopover = [[QCOMockPopoverPresentationController alloc] init];
    }
    return self;
}

- (UIPopoverPresentationController *)qcoMock_popoverPresentationController
{
    if ([self respondsToSelector:@selector(qcoMock_mockPopover)]) {
        return (id)self.qcoMock_mockPopover;
    }
    return nil;
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
