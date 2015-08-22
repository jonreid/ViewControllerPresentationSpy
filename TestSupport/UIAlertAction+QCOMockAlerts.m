//  MockUIAlertController by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "UIAlertAction+QCOMockAlerts.h"

#import "NSObject+QCOMockAlerts.h"
#import <objc/runtime.h>


@implementation UIAlertAction (QCOMockAlerts)

+ (void)qcoMockAlerts_swizzle
{
    [self replaceClassMethod:@selector(actionWithTitle:style:handler:)
                  withMethod:@selector(qcoMockAlerts_actionWithTitle:style:handler:)];
}

+ (instancetype)qcoMockAlerts_actionWithTitle:(NSString *)title
                                        style:(UIAlertActionStyle)style
                                      handler:(void (^)(UIAlertAction *action))handler
{
    UIAlertAction *action = [self qcoMockAlerts_actionWithTitle:title style:style handler:handler];
    objc_setAssociatedObject(action, @selector(qco_handler), handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return action;
}

- (void (^)(UIAlertAction *action))qco_handler
{
    return objc_getAssociatedObject(self, @selector(qco_handler));
}

@end
