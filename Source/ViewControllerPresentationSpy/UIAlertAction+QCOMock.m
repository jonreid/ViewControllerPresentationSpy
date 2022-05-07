//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2022 Jonathan M. Reid. See LICENSE.txt

#import "UIAlertAction+QCOMock.h"

#import "ViewControllerPresentationSpy/ViewControllerPresentationSpy-Swift.h"
#import <objc/runtime.h>

void *const foo = @"foo";

@implementation UIAlertAction (QCOMock)

- (void (^ __nullable)(UIAlertAction *action))qcoMock_handler
{
    UIAlertActionExtraProperties *extraProperties = objc_getAssociatedObject(self, foo);
    return extraProperties.handler;
}

@end
