//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2022 Jonathan M. Reid. See LICENSE.txt

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertAction (QCOMock)
+ (instancetype)qcoMock_actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *))handler;
- (void (^ __nullable)(UIAlertAction *action))qcoMock_handler;
@end

NS_ASSUME_NONNULL_END
