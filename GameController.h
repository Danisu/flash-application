//
//  GameController.h
//  FlashFun
//
//  Queries the user for which deck to play in the game.
//  In future will query for which mode first.
//
//

#import <UIKit/UIKit.h>

@class DeckEditingViewController;
@class NormalGameModeController;
@class HelpViewController;

@interface GameController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	DeckEditingViewController *deckEditingVC;
	NormalGameModeController *normalVC;
	HelpViewController *helpController;
	BOOL firstInsert;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet DeckEditingViewController *deckEditingVC;
@property (nonatomic, retain) IBOutlet NormalGameModeController *normalVC;
@property (nonatomic, retain) IBOutlet HelpViewController *helpController;
@property (nonatomic, assign) BOOL firstInsert;

- (void) configureCell: (UITableViewCell *) cell
			  withDeck: (NSManagedObject *) model;

@end
