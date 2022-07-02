// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2022 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

#import "NSObject+QCOMockAlerts.h"

#import <objc/runtime.h>

@implementation NSObject (QCOMockAlerts)

+ (void)qcoMockAlerts_replaceInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

@end
