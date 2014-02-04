//
//  CardsViewController.h
//  FlashFun
//
// Tableview controller which displays cards in a specific deck.
// Allows the user to view specific detail of cards by selecting them.
//
//

#import <UIKit/UIKit.h>

@class Deck;
@class CardEditingViewController;
@class HelpViewController;

@interface CardsViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	Deck *selectedDeck;
	CardEditingViewController *cardEditingVC;
	NSIndexPath *selectedIndexPath;
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *deckManagedObjectContext;
	BOOL firstInsert;
	BOOL flag;
	HelpViewController *helpController;
	
	// Store fetchedresultscontroller to be passed to deeper controllers for further use
	NSFetchedResultsController *deckFetchedResultsController;
}

@property (nonatomic, retain) Deck *selectedDeck;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, retain) IBOutlet CardEditingViewController *cardEditingVC;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *deckFetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *deckManagedObjectContext;
@property (nonatomic, assign) BOOL firstInsert;
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, retain) IBOutlet HelpViewController *helpController;

- (void) configureCell: (UITableViewCell *) cell
		   withCard: (NSManagedObject *) model;

@end
