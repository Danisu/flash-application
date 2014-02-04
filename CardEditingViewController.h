//
//  CardEditingViewController.h
//  FlashFun
//
//  Provide more detailed card view for editing & moving

//

#import <UIKit/UIKit.h>

@class Card;
@class Deck;
@class DeleteCardViewController;
@class MoveSelectDeckViewController;
@class HelpViewController;


@interface CardEditingViewController : UIViewController <NSFetchedResultsControllerDelegate> {
	UITextField *questionField;
	UITextField *answerField;
	UITextField *hintField;
	UILabel *statSeenLabel;
	UILabel *statCorrectLabel;
	UILabel *statMasteryLabel;
	BOOL flag;
	
	Card *selectedCard;
	Deck *selectedDeck;

	DeleteCardViewController *deleteVC;
	MoveSelectDeckViewController *moveVC;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	UIViewController *cardsController;
	HelpViewController *helpController;
}

@property (nonatomic, retain) IBOutlet UITextField *questionField;
@property (nonatomic, retain) IBOutlet UITextField *answerField;
@property (nonatomic, retain) IBOutlet UITextField *hintField;
@property (nonatomic, retain) IBOutlet UILabel *statSeenLabel;
@property (nonatomic, retain) IBOutlet UILabel *statCorrectLabel;
@property (nonatomic, retain) IBOutlet UILabel *statMasteryLabel;

@property (nonatomic, retain) Card *selectedCard;
@property (nonatomic, retain) Deck *selectedDeck;

@property (nonatomic, retain) IBOutlet DeleteCardViewController *deleteVC;
@property (nonatomic, retain) IBOutlet MoveSelectDeckViewController *moveVC;
@property (nonatomic, retain) IBOutlet HelpViewController *helpController;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UIViewController *cardsController;
@property (nonatomic, assign) BOOL flag;

- (IBAction) deleteCard;
- (IBAction) moveCard;
- (IBAction) resetStats;

- (void) setupStatsLabel;

@end
