@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *showAlertButton;
@property (nonatomic, strong) IBOutlet UIButton *showActionSheetButton;
@property (nonatomic, strong) IBOutlet UIButton *seguePresentModalButton;
@property (nonatomic, strong) IBOutlet UIButton *segueShowButton;
@property (nonatomic, strong) IBOutlet UIButton *codePresentModalButton;

@property (nonatomic, assign) NSUInteger alertDefaultActionCount;
@property (nonatomic, assign) NSUInteger alertCancelActionCount;
@property (nonatomic, assign) NSUInteger alertDestroyActionCount;
@property (nonatomic, copy, nullable) void (^alertPresentedCompletion)(void);
@property (nonatomic, copy, nullable) void (^viewControllerPresentedCompletion)(void);

- (void)presentNonAlert;

@end

NS_ASSUME_NONNULL_END
