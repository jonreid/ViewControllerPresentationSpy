//  MockUIAlertController by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "QCOMockAlertController.h"

#import "QCOMockPopoverPresentationController.h"

NSString *const QCOMockAlertControllerPresentedNotification = @"QCOMockAlertControllerPresentedNotification";


@interface QCOMockAlertController ()
@property (nonatomic, strong) QCOMockPopoverPresentationController *mockPopover;
@end


@implementation QCOMockAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    return [[self alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)style
{
    self = [super init];
    if (self)
    {
        _preferredAlertStyle = style;
        _mockPopover = [[QCOMockPopoverPresentationController alloc] init];
        self.title = title;
        self.message = message;
    }
    return self;
}

- (UIPopoverPresentationController *)popoverPresentationController
{
    return (id)self.mockPopover;
}

@end
