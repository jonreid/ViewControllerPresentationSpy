#import "ViewController.h"

#import "CodeNextViewController.h"
#import "StoryboardNextViewController.h"

@implementation ViewController

- (IBAction)showAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title"
                                                                             message:@"Message"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [self setUpActionsForAlertController:alertController];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Placeholder";
    }];
    [self presentViewController:alertController animated:YES completion:self.alertPresentedCompletion];
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

    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void)setUpActionsForAlertController:(UIAlertController *)alertController
{
    self.alertDefaultActionCount = 0;
    self.alertCancelActionCount = 0;
    self.alertDestroyActionCount = 0;
    
    UIAlertAction *actionWithoutHandler = [UIAlertAction actionWithTitle:@"No Handler"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Default"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              ++self.alertDefaultActionCount;
                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                             ++self.alertCancelActionCount;
                                                         }];
    UIAlertAction *destroyAction = [UIAlertAction actionWithTitle:@"Destroy"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action) {
                                                              ++self.alertDestroyActionCount;
                                                          }];
    [alertController addAction:actionWithoutHandler];
    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
    [alertController addAction:destroyAction];
    alertController.preferredAction = defaultAction;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"presentModal"])
    {
        StoryboardNextViewController *nextVC = segue.destinationViewController;
        nextVC.backgroundColor = UIColor.greenColor;
        nextVC.hideToolbar = NO;
    }
    else if ([segue.identifier isEqualToString:@"show"])
    {
        StoryboardNextViewController *nextVC = segue.destinationViewController;
        nextVC.backgroundColor = UIColor.redColor;
        nextVC.hideToolbar = YES;
    }
}

- (IBAction)showModal
{
    UIViewController *nextVC = [[CodeNextViewController alloc] initWithBackgroundColor:UIColor.purpleColor];
    [self presentViewController:nextVC animated:YES completion:self.viewControllerPresentedCompletion];
}

- (void)presentNonAlert
{
    [self presentViewController:[[UIViewController alloc] init] animated:NO completion:nil];
}

@end
