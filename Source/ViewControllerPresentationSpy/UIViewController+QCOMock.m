// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2022 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

#import "UIViewController+QCOMock.h"

#import "NSObject+QCOMockAlerts.h"
#if __has_include("ViewControllerPresentationSpy-Swift.h")
    #import "ViewControllerPresentationSpy-Swift.h"
#else
    #import <ViewControllerPresentationSpy/ViewControllerPresentationSpy-Swift.h>
#endif

NSString *const QCOMockViewControllerPresentedNotification = @"QCOMockViewControllerPresentedNotification";
NSString *const QCOMockViewControllerDismissedNotification = @"QCOMockViewControllerDismissedNotification";
NSString *const QCOMockAlertControllerPresentedNotification = @"QCOMockAlertControllerPresentedNotification";
