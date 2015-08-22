//  MockUIAlertController by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "QCOMockAlertVerifier.h"

#import "UIAlertAction+QCOMock.h"
#import "UIAlertController+QCOMock.h"
#import "UIViewController+QCOMock.h"

@interface QCOMockAlertVerifier ()
@property (nonatomic, copy) NSArray *actions;
@end


static void swizzleMocks(void)
{
    [UIAlertAction qcoMock_swizzle];
    [UIAlertController qcoMock_swizzle];
    [UIViewController qcoMock_swizzle];
}

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
    self.animated = notification.userInfo[QCOMockViewControllerAnimatedKey];
    self.title = alertController.title;
    self.message = alertController.message;
    self.preferredStyle = alertController.qcoMock_preferredAlertStyle;
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
    [action qcoMock_handler](action);
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
