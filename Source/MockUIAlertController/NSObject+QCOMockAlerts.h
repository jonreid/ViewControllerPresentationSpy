//  MockUIAlertController by Jon Reid, https://qualitycoding.org/
//  Copyright 2018 Jonathan M. Reid. See LICENSE.txt

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSObject (QCOMockAlerts)

+ (void)qcoMockAlerts_replaceClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;
+ (void)qcoMockAlerts_replaceInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
