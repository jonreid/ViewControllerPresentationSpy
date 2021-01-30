//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2021 Quality Coding, Inc. See LICENSE.txt

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertAction (QCOMock)
+ (void)qcoMock_swizzle;
- (void (^ __nullable)(UIAlertAction *action))qcoMock_handler;
@end

NS_ASSUME_NONNULL_END
