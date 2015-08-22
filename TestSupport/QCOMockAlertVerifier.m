//  MockUIAlertController by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "QCOMockAlertVerifier.h"

#import "UIAlertAction+QCOMockAlerts.h"
#import "UIAlertController+QCOMockAlerts.h"
#import "UIViewController+QCOMockAlerts.h"


@interface QCOMockAlertVerifier ()
@property (nonatomic, copy) NSArray *actions;
@end

@implementation QCOMockAlertVerifier

- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(alertControllerWasPresented:)
                                                     name:QCOMockAlertControllerPresentedNotification
                                                   object:nil];
        [UIAlertAction qcoMockAlerts_swizzle];
        [UIAlertController qcoMockAlerts_swizzle];
        [UIViewController qcoMockAlerts_swizzle];
    }
    return self;
}

- (void)dealloc
{
    [UIAlertAction qcoMockAlerts_swizzle];
    [UIAlertController qcoMockAlerts_swizzle];
    [UIViewController qcoMockAlerts_swizzle];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)alertControllerWasPresented:(NSNotification *)notification
{
    UIAlertController *alertController = notification.object;
    self.presentedCount += 1;
    self.animated = notification.userInfo[@"animated"];
    self.title = alertController.title;
    self.message = alertController.message;
    self.preferredStyle = alertController.qcoMockAlerts_preferredAlertStyle;
    self.actions = alertController.actions;
    self.popover = (id)alertController.popoverPresentationController;
}

- (NSArray *)actionTitles
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (UIAlertAction *action in self.actions)
        [array addObject:action.title];
    return [array copy];
}

- (UIAlertActionStyle)styleForButtonWithTitle:(NSString *)title
{
    UIAlertAction *action = [self actionWithTitle:title];
    return action.style;
}

- (void)executeActionForButtonWithTitle:(NSString *)title
{
    UIAlertAction *action = [self actionWithTitle:title];
    [action qco_handler](action);
}

- (UIAlertAction *)actionWithTitle:(NSString *)title
{
    for (UIAlertAction *action in self.actions)
        if ([action.title isEqualToString:title])
            return action;
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Button not found"
                                 userInfo:nil];
}

@end
