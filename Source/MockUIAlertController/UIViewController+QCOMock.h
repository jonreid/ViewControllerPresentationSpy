//  MockUIAlertController by Jon Reid, https://qualitycoding.org/
//  Copyright 2018 Jonathan M. Reid. See LICENSE.txt

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const QCOMockViewControllerPresentingViewControllerKey;
extern NSString *const QCOMockViewControllerAnimatedKey;


@interface UIViewController (QCOMock)

+ (void)qcoMock_swizzle;

@end

NS_ASSUME_NONNULL_END
