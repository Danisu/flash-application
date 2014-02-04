//
//  NormalGameModeController.h
//  FlashFun
//
//  This file allows the user to play the actual study game
//  through a tab bar interface.
//
//

#import <UIKit/UIKit.h>

@class Deck;
@class Card;
@class CardEditingViewController;
@class HelpViewController;

@interface NormalGameModeController : UITableViewController <NSFetchedResultsControllerDelegate> {
	Deck *selectedDeck;
	Card *selectedCard;
	NSIndexPath *selectedIndexPath;
	CardEditingViewController *cardEditingVC;
	NSFetchedResultsController *fetchedResultsController;
	UITabBarController  *tabBarController;
	BOOL firstInsert;
	NSMutableArray *data;
	NSMutableArray *cardsArray;
	NSInteger i;
	NSInteger indexCounter;
	NSInteger indexCounterCards;
	NSInteger statsCounter;
	UISegmentedControl *segment;
	UITextView *gameLabel;
	UITableViewController *normalGameModeDisplay;
	HelpViewController *helpController;
	BOOL reverseMode;
	UIAlertView *alert;
	UIAlertView *right;
}

@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) Deck *selectedDeck;
@property (nonatomic, retain) Card *selectedCard;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, retain) IBOutlet CardEditingViewController *cardEditingVC;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) BOOL firstInsert;
@property (nonatomic, assign) BOOL reverseMode;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSMutableArray *cardsArray;
@property (nonatomic, assign) NSInteger i;
@property (nonatomic, assign) NSInteger indexCounter;
@property (nonatomic, assign) NSInteger indexCounterCards;
@property (nonatomic, assign) NSInteger statsCounter;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segment;
@property (nonatomic, retain) IBOutlet UITextView *gameLabel;
@property (nonatomic, retain) IBOutlet UITableViewController *normalGameModeDisplay;
@property (nonatomic, retain) IBOutlet HelpViewController *helpController;
@property (nonatomic, retain) IBOutlet UIAlertView *alert;

@property (nonatomic, retain) IBOutlet UIAlertView *right;

- (void) configureCell: (UITableViewCell *) cell
			  withCard: (NSManagedObject *) model;
- (void) yesOrNo;
- (IBAction) change;
- (void) playSound;
- (NSString *) makeHint:(NSString *)answer withHint:(NSString *) cardHint;

@end

