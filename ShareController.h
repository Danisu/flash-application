//
//  ShareController.h
//  FlashFun
//
//  Provide sub menu for sharing decks
//
//

#import <UIKit/UIKit.h>

@class ShareWebController;
@class ShareSelectDeckController;
@class HelpViewController;
@class ShareDownloadController;
@class ShareStatsController;

@interface ShareController : UITableViewController {
	NSMutableData *data;
	NSArray *decks;
	
	NSManagedObjectContext *managedObjectContext;
	
	ShareDownloadController *downloadController;
	ShareWebController *webController;
	ShareSelectDeckController *selectController;
	HelpViewController *helpController;
	ShareStatsController *statsController;
	
	// Flag for whether we are finished downloading
	BOOL finished;
}

@property(nonatomic, retain) NSMutableData *data;
@property(nonatomic, retain) NSArray *decks;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) IBOutlet ShareDownloadController *downloadController;
@property(nonatomic, retain) IBOutlet ShareWebController *webController;
@property(nonatomic, retain) IBOutlet ShareSelectDeckController *selectController;
@property(nonatomic, retain) IBOutlet HelpViewController *helpController;
@property(nonatomic, retain) IBOutlet ShareStatsController *statsController;
@property(nonatomic, assign) BOOL finished;

- (void) getPublicDecks;

@end
