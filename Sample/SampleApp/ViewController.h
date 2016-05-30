@import UIKit;


@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *showAlertButton;
@property (nonatomic, strong) IBOutlet UIButton *showActionSheetButton;
@property (nonatomic, assign) BOOL alertDefaultActionExecuted;
@property (nonatomic, assign) BOOL alertCancelActionExecuted;
@property (nonatomic, assign) BOOL alertDestroyActionExecuted;

- (IBAction)showAlert:(id)sender;
- (IBAction)showActionSheet:(id)sender;
- (IBAction)showModalController:(id)sender;

@end
