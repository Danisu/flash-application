//
//  DeleteCardViewController.h
//  FlashFun
//
//  Prompt the user to confirm whether they wish to delete
//  a card or not.
//
//

#import <UIKit/UIKit.h>

@class Card;
@class Deck;
@class HelpViewController;

@interface DeleteCardViewController : UIViewController <NSFetchedResultsControllerDelegate> {
	Card *selectedCard;
	Deck *selectedDeck;
	UILabel *cardLabel;
	UIViewController *cardsController;
	HelpViewController *helpController;
}

@property(nonatomic, retain) Card *selectedCard;
@property(nonatomic, retain) Deck *selectedDeck;
@property(nonatomic, retain) IBOutlet UILabel *cardLabel;
@property(nonatomic, retain) IBOutlet HelpViewController *helpController;
@property(nonatomic, retain) UIViewController *cardsController;

- (IBAction) confirm;
- (IBAction) deny;

@end
