//
//  DeleteDeckViewController.h
//  FlashFun
//
//  Confirmation dialogue when user asks for deck deletion
//
//

#import <UIKit/UIKit.h>

@class Deck;
@class HelpViewController;

@interface DeleteDeckViewController : UIViewController <NSFetchedResultsControllerDelegate> {
	Deck *selectedDeck;
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	UILabel *deckLabel;
	UIViewController *editController;
	HelpViewController *helpController;
}

@property(nonatomic, retain) Deck *selectedDeck;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) IBOutlet UILabel *deckLabel;
@property(nonatomic, retain) UIViewController *editController;
@property (nonatomic, retain) IBOutlet HelpViewController *helpController;



- (IBAction) confirm;
- (IBAction) deny;

@end
