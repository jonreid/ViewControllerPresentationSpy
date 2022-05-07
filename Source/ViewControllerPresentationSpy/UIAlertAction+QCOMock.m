//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2022 Jonathan M. Reid. See LICENSE.txt

#import "UIAlertAction+QCOMock.h"

#import "NSObject+QCOMockAlerts.h"
#import "ViewControllerPresentationSpy/ViewControllerPresentationSpy-Swift.h"
#import <objc/runtime.h>

void *const foo = @"foo";

@implementation UIAlertAction (QCOMock)

+ (instancetype)qcoMock_actionWithTitle:(NSString *)title
                                  style:(UIAlertActionStyle)style
                                handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertAction *action = [self qcoMock_actionWithTitle:title style:style handler:handler];
    UIAlertActionExtraProperties *extraProperties = [[UIAlertActionExtraProperties alloc] initWithHandler:handler];
    objc_setAssociatedObject(action, foo, extraProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return action;
}

- (void (^ __nullable)(UIAlertAction *action))qcoMock_handler
{
    UIAlertActionExtraProperties *extraProperties = objc_getAssociatedObject(self, foo);
    return extraProperties.handler;
}

@end
