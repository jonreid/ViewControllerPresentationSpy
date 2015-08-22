//  MockUIAlertController by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import <UIKit/UIKit.h>

#import "QCOMockPopoverPresentationController.h"    // Convenience import instead of @class


/**
    Captures mocked UIAlertController arguments.
 */
@interface QCOMockAlertVerifier : NSObject

@property (nonatomic, assign) NSUInteger presentedCount;
@property (nonatomic, strong) NSNumber *animated;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) UIAlertControllerStyle preferredStyle;
@property (nonatomic, readonly) NSArray *actionTitles;
@property (nonatomic, strong) QCOMockPopoverPresentationController *popover;

- (UIAlertActionStyle)styleForButtonWithTitle:(NSString *)title;
- (void)executeActionForButtonWithTitle:(NSString *)title;

@end
