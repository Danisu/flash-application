//
//  ShareSelectDeckController.h
//  FlashFun
//
//  Allows user to select which deck will be uploaded to website
//
//

#import <UIKit/UIKit.h>

@class ShareSendController;
@class HelpViewController;

@interface ShareSelectDeckController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	ShareSendController *sendController;
	HelpViewController *helpController;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet ShareSendController *sendController;
@property (nonatomic, retain) IBOutlet HelpViewController *helpController;

- (void) configureCell: (UITableViewCell *) cell
			  withDeck: (NSManagedObject *) model;

@end
