#import "StoryboardNextViewController.h"

@interface StoryboardNextViewController ()
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@end

@implementation StoryboardNextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = self.backgroundColor;
    self.toolbar.hidden = self.hideToolbar;
}

- (IBAction)cancel
{
    [self dismissViewControllerAnimated:YES completion:self.viewControllerDismissedCompletion];
}

@end
