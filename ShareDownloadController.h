//
//  ShareDownloadController.h
//  FlashFun
//
//  Parse public decks from website and allow user to
//  select one for download
//
//

#import <UIKit/UIKit.h>

@class ShareInstallDeckController;
@class HelpViewController;

@interface ShareDownloadController : UITableViewController {
	NSArray *decks;
	NSManagedObjectContext *managedObjectContext;
	
	ShareInstallDeckController *installController;
	HelpViewController *helpController;
}

@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSArray *decks;
@property(nonatomic, retain) IBOutlet ShareInstallDeckController *installController;
@property(nonatomic, retain) IBOutlet HelpViewController *helpController;

@end
