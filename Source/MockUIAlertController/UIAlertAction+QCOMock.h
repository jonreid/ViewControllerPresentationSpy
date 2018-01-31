//  MockUIAlertController by Jon Reid, https://qualitycoding.org/
//  Copyright 2018 Jonathan M. Reid. See LICENSE.txt

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIAlertAction (QCOMock)

+ (void)qcoMock_swizzle;

- (void (^)(UIAlertAction *action))qcoMock_handler;

@end

NS_ASSUME_NONNULL_END
