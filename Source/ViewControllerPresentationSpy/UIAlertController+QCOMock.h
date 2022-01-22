//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2022 Jonathan M. Reid. See LICENSE.txt

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const QCOMockAlertControllerPresentedNotification;

@interface UIAlertController (QCOMock)

+ (instancetype)qcoMock_alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle;
- (instancetype)initQCOMockWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)style;
#if TARGET_OS_IOS
- (UIPopoverPresentationController *)qcoMock_popoverPresentationController;
#endif
@end

NS_ASSUME_NONNULL_END
