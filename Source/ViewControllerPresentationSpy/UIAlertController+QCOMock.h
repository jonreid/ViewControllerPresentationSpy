//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2021 Quality Coding, Inc. See LICENSE.txt

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const QCOMockAlertControllerPresentedNotification;

@interface UIAlertController (QCOMock)
+ (void)qcoMock_swizzle;
@end

NS_ASSUME_NONNULL_END
