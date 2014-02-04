//
//  MoveConfirmViewController.h
//  FlashFun
//
//  Confirm dialogue for moving card to another deck
//
//

#import <UIKit/UIKit.h>

@class Deck;
@class Card;
@class HelpViewController;

@interface MoveConfirmViewController : UIViewController {
	Deck *toDeck;
	Deck *fromDeck;
	Card *card;
	UIViewController *controller;
	UILabel *label;
	HelpViewController *helpController;
}

@property(nonatomic, retain) Deck *toDeck;
@property(nonatomic, retain) Deck *fromDeck;
@property(nonatomic, retain) Card *card;
@property(nonatomic, retain) IBOutlet UIViewController *controller;
@property(nonatomic, retain) IBOutlet UILabel *label;
@property(nonatomic, retain) IBOutlet HelpViewController *helpController;

- (IBAction) confirm;
- (IBAction) deny;

@end
