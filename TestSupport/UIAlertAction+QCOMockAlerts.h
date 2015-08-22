//  MockUIAlertController by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import <UIKit/UIKit.h>


@interface UIAlertAction (QCOMockAlerts)

+ (void)qcoMock_swizzle;

- (void (^)(UIAlertAction *action))qcoMock_handler;

@end
