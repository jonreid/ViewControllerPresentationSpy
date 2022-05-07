//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2022 Jonathan M. Reid. See LICENSE.txt

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern void *const foo;

@interface UIAlertAction (QCOMock)

- (void (^ __nullable)(UIAlertAction *action))qcoMock_handler;
@end

NS_ASSUME_NONNULL_END
