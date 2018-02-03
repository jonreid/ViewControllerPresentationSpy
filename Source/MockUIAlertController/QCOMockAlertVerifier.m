//  MockUIAlertController by Jon Reid, https://qualitycoding.org/
//  Copyright 2018 Jonathan M. Reid. See LICENSE.txt

#import "QCOMockAlertVerifier.h"

#import "UIAlertAction+QCOMock.h"
#import "UIAlertController+QCOMock.h"
#import "UIViewController+QCOMock.h"


static void swizzleMocks(void)
{
    [UIAlertAction qcoMock_swizzle];
    [UIAlertController qcoMock_swizzle];
    [UIViewController qcoMock_swizzle];
}

@interface QCOMockAlertVerifier ()
@property (nonatomic, copy) NSArray<UIAlertAction *> *actions;
@end

@implementation QCOMockAlertVerifier

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(alertControllerWasPresented:)
                                                     name:QCOMockAlertControllerPresentedNotification
                                                   object:nil];
        swizzleMocks();
    }
    return self;
}

- (void)dealloc
{
    swizzleMocks();
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)alertControllerWasPresented:(NSNotification *)notification
{
    UIAlertController *alertController = notification.object;
    self.presentedCount += 1;
    self.presentingViewController = notification.userInfo[QCOMockViewControllerPresentingViewControllerKey];
    self.animated = [notification.userInfo[QCOMockViewControllerAnimatedKey] boolValue];
    self.title = alertController.title;
    self.message = alertController.message;
    self.preferredStyle = alertController.preferredStyle;
    self.actions = alertController.actions;
    self.popover = (id)alertController.popoverPresentationController;
}

- (NSArray *)actionTitles
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (UIAlertAction *action in self.actions)
        [array addObject: action.title ? action.title : [NSNull null]];
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
    void (^handler)(UIAlertAction *) = [action qcoMock_handler];
    if (handler)
        handler(action);
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
