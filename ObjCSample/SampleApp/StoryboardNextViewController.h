@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface StoryboardNextViewController : UIViewController
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) BOOL hideToolbar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, copy, nullable) void (^viewControllerDismissedCompletion)(void);
@end

NS_ASSUME_NONNULL_END
