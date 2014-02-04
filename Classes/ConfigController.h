//
//  ConfigController.h
//  FlashFun
//
//  Control various settings of the application
//
//

#import <UIKit/UIKit.h>

@class HelpViewController;

@interface ConfigController : UIViewController {
	UISwitch *querySwitch;
	UISwitch *hintSwitch;
	UISwitch *soundSwitch;
	HelpViewController *helpController;
}

@property (nonatomic, retain) IBOutlet UISwitch *querySwitch;
@property (nonatomic, retain) IBOutlet UISwitch *hintSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *soundSwitch;
@property (nonatomic, retain) IBOutlet HelpViewController *helpController;

- (IBAction) change;

@end
