#import "CodeNextViewController.h"

@implementation CodeNextViewController

- (instancetype)initWithBackgroundColor:(UIColor *)backgroundColor
{
    self = [super init];
    if (self)
    {
        _backgroundColor = backgroundColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = self.backgroundColor;
}

@end
