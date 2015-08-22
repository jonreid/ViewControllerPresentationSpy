//  MockUIAlertController by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import <UIKit/UIKit.h>

extern NSString *const QCOMockAlertControllerPresentedNotification;


@interface UIAlertController (QCOMockAlerts)

@property (nonatomic, assign) UIAlertControllerStyle qcoMockAlerts_preferredAlertStyle;

+ (void)qcoMock_swizzle;

@end
