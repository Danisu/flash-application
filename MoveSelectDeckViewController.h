//
//  MoveSelectDeckViewController.h
//  FlashFun
//
//  Give the user a list of decks which a card may be
//  moved to
//
//

#import <UIKit/UIKit.h>

@class Deck;
@class Card;
@class MoveConfirmViewController;
@class HelpViewController;

@interface MoveSelectDeckViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	UIViewController *cardsController;
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	Deck *selectedDeck;
	Card *selectedCard;
	MoveConfirmViewController *confirmVC;
	HelpViewController *helpController;}

@property(nonatomic, retain) IBOutlet UIViewController *cardsController;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) IBOutlet MoveConfirmViewController *confirmVC;
@property(nonatomic, retain) Deck *selectedDeck;
@property(nonatomic, retain) Card *selectedCard;
@property (nonatomic, retain) IBOutlet HelpViewController *helpController;

@end
