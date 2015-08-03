//  MockAlerts by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import <UIKit/UIKit.h>


extern NSString *const QCOMockAlertControllerPresentedNotification;


/**
    Inject this class in place of the UIAlertController class.
    Instantiate a QCOMockAlertVerifier before the execution phase of your test.
 */
@interface QCOMockAlertController : UIAlertController

@property (nonatomic, assign) UIAlertControllerStyle preferredAlertStyle;

@end
