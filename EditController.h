//
//  EditController.h
//  FlashFun
//
//  Main deck view controller. Lists all decks currently
//  in the database & allows user to add more or view more
//  detailed information about each deck.
//
//
//  Note: Much of this code is credited to Dudney and Adamson's iPhone SDK Development book
//  Particularly the CoreData stuff
//

#import <UIKit/UIKit.h>

@class DeckEditingViewController;
@class HelpViewController;

@interface EditController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	DeckEditingViewController *deckEditingVC;
	HelpViewController *helpController;
	BOOL firstInsert;
	BOOL flag;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet DeckEditingViewController *deckEditingVC;
@property (nonatomic, assign) BOOL firstInsert;
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, retain) IBOutlet HelpViewController *helpController;


- (void) configureCell: (UITableViewCell *) cell
			  withDeck: (NSManagedObject *) model;

@end
