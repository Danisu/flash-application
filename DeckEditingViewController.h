//
//  DeckEditingViewController.h
//  FlashFun
//
//  Allow the user to edit the deck name and description
//  Also provide for deleting the deck and viewing cards
//
//
//  Note: Much of this code is credited to Dudney and Adamson's iPhone SDK Development book
//  Particularly the CoreData stuff
//

#import <UIKit/UIKit.h>

@class Deck;
@class CardsViewController;
@class DeleteDeckViewController;
@class HelpViewController;

@interface DeckEditingViewController : UIViewController <UITextFieldDelegate, NSFetchedResultsControllerDelegate> {
	UITextField *nameField;
	UITextField *descField;
	UILabel *statsLabel;
	
	Deck *selectedDeck;
	CardsViewController *cardsVC;
	DeleteDeckViewController *deleteVC;
	
	HelpViewController *helpController;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	UIViewController *editController;
	BOOL flag;
}

@property(nonatomic, retain) IBOutlet UITextField *nameField;
@property(nonatomic, retain) IBOutlet UITextField *descField;
@property(nonatomic, retain) IBOutlet UILabel *statsLabel;

@property(nonatomic, retain) Deck *selectedDeck;
@property(nonatomic, retain) IBOutlet CardsViewController *cardsVC;
@property(nonatomic, retain) IBOutlet DeleteDeckViewController *deleteVC;

@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) UIViewController *editController;

@property (nonatomic, retain) IBOutlet HelpViewController *helpController;
@property (nonatomic, assign) BOOL flag;

- (IBAction) deleteDeck;
- (IBAction) viewCards;
- (IBAction) resetStats;

@end
