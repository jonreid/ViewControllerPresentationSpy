#import "ViewController.h"

@implementation ViewController

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        // Use the real UIAlertController by default. Make sure you have a test verifying this.
        _alertControllerClass = [UIAlertController class];
    }
    return self;
}

- (IBAction)showAlert:(id)sender
{
    // Call self.alertControllerClass instead of UIAlertController
    UIAlertController *alertController = [self.alertControllerClass alertControllerWithTitle:@"Title"
                                                                                     message:@"Message"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    [self setUpActionsForAlertController:alertController];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)showActionSheet:(id)sender
{
    // Call self.alertControllerClass instead of UIAlertController
    UIAlertController *alertController = [self.alertControllerClass alertControllerWithTitle:@"Title"
                                                                                     message:@"Message"
                                                                              preferredStyle:UIAlertControllerStyleActionSheet];
    [self setUpActionsForAlertController:alertController];

    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover)
    {
        popover.sourceView = sender;
        popover.sourceRect = [sender bounds];
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)setUpActionsForAlertController:(UIAlertController *)alertController
{
    self.alertDefaultActionExecuted = NO;
    self.alertCancelActionExecuted = NO;
    self.alertDestroyActionExecuted = NO;

    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Default"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action){
                                                              self.alertDefaultActionExecuted = YES;
                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action){
                                                             self.alertCancelActionExecuted = YES;
                                                         }];
    UIAlertAction *destroyAction = [UIAlertAction actionWithTitle:@"Destroy"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action){
                                                              self.alertDestroyActionExecuted = YES;
                                                          }];
    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
    [alertController addAction:destroyAction];
}

@end
