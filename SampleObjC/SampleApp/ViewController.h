@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *showAlertButton;
@property (nonatomic, strong) IBOutlet UIButton *showActionSheetButton;
@property (nonatomic, strong) IBOutlet UIButton *seguePresentModalButton;
@property (nonatomic, strong) IBOutlet UIButton *segueShowButton;
@property (nonatomic, strong) IBOutlet UIButton *codeModalButton;

@property (nonatomic, assign) BOOL alertDefaultActionExecuted;
@property (nonatomic, assign) BOOL alertCancelActionExecuted;
@property (nonatomic, assign) BOOL alertDestroyActionExecuted;

- (void)presentNonAlert;

@end

NS_ASSUME_NONNULL_END
