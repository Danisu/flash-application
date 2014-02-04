//
//  MenuViewController.h
//  FlashFun
//
//  Provides a main menu
//
//

#import <UIKit/UIKit.h>

@class EditController;
@class ShareController;
@class GameController;
@class ConfigController;
@class HelpViewController;

@interface MenuViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSManagedObjectContext *managedObjectContext;
	EditController *editController;
	ShareController *shareController;
	GameController *gameController;
	ConfigController *configController;
	HelpViewController *helpController;
	UIViewController *controller;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet EditController *editController;
@property (nonatomic, retain) IBOutlet ShareController *shareController;
@property (nonatomic, retain) IBOutlet GameController *gameController;
@property (nonatomic, retain) IBOutlet ConfigController *configController;
@property (nonatomic, retain) IBOutlet HelpViewController *helpController;
@property (nonatomic, retain) UIViewController *controller;

@end
