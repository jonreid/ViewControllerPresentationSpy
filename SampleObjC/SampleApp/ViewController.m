#import "ViewController.h"


@implementation ViewController

- (IBAction)showAlert:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title"
                                                                             message:@"Message"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [self setUpActionsForAlertController:alertController];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Placeholder";
    }];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (IBAction)showActionSheet:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title"
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

    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)presentNonAlert
{
    [self presentViewController:[[UIViewController alloc] init] animated:NO completion:nil];
}

- (void)setUpActionsForAlertController:(UIAlertController *)alertController
{
    self.alertDefaultActionExecuted = NO;
    self.alertCancelActionExecuted = NO;
    self.alertDestroyActionExecuted = NO;

    UIAlertAction *actionWithoutHandler = [UIAlertAction actionWithTitle:@"No Handler"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Default"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              self.alertDefaultActionExecuted = YES;
                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                             self.alertCancelActionExecuted = YES;
                                                         }];
    UIAlertAction *destroyAction = [UIAlertAction actionWithTitle:@"Destroy"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action) {
                                                              self.alertDestroyActionExecuted = YES;
                                                          }];
    [alertController addAction:actionWithoutHandler];
    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
    [alertController addAction:destroyAction];
    alertController.preferredAction = defaultAction;
}

@end
