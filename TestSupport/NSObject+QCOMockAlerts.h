//  MockUIAlertController by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import <Foundation/Foundation.h>


@interface NSObject (QCOMockAlerts)

+ (void)qcoMock_replaceClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;
+ (void)qcoMock_replaceInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;

@end
