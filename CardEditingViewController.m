//
//  CardEditingViewController.m
//  FlashFun
//
//  Provide more detailed card view for editing & moving
//
//
//  Note: Much of this code is credited to Dudney and Adamson's iPhone SDK Development book
//  Particularly the CoreData stuff
//

#import "CardEditingViewController.h"
#import "Card.h"
#import "Deck.h"
#import "DeleteCardViewController.h"
#import "MoveSelectDeckViewController.h"
#import "HelpViewController.h"


@implementation CardEditingViewController

@synthesize selectedCard,
questionField,
selectedDeck,
cardsController,
deleteVC,
answerField,
moveVC,
fetchedResultsController,
managedObjectContext,
statSeenLabel,
statCorrectLabel,
helpController,
statMasteryLabel,
hintField,
flag;

/**
 Bring up dialogue to delete card
 */
- (IBAction) deleteCard {
	self.deleteVC.selectedCard = self.selectedCard;
	self.deleteVC.selectedDeck = self.selectedDeck;
	self.deleteVC.cardsController = self.cardsController;
	[self.navigationController pushViewController: self.deleteVC animated: YES];
}

/**
 Bring dialogue to move cards between decks
 */
- (IBAction) moveCard {
	self.moveVC.selectedCard = self.selectedCard;
	self.moveVC.selectedDeck = self.selectedDeck;
	self.moveVC.cardsController = self.cardsController;
	self.moveVC.managedObjectContext = self.managedObjectContext;
	self.moveVC.fetchedResultsController = self.fetchedResultsController;
	[self.navigationController pushViewController: self.moveVC animated: YES];
}

/**
 Reset card statistics
 */
- (IBAction) resetStats {
	self.selectedCard.timesSeen = [NSNumber numberWithInt: 0];
	self.selectedCard.timesCorrect = [NSNumber numberWithInt: 0];
	[self setupStatsLabel];
}

/**
 Add done button which returns to the card view
 */
- (void)viewDidLoad {
	[super viewDidLoad];
}



/** HELP FUNCTIONS START HERE
 Setup toolbar and help button
 */
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	// create help button and add to toolbar
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle: @"Help"
															   style: UIBarButtonItemStyleBordered
															  target: self
															  action: @selector(help)];
	NSArray *barItems = [NSArray arrayWithObject: button];
	[self setToolbarItems: barItems animated: FALSE];
	[button release];
}

/**
 Call up help screen with data
 */
- (void) help {
	self.helpController.descText = @"Inputing the question and answer of the card will modify these two attribute of a card.\nPress Delete Card to delete this card.\nTo move cards press Move Card to Another Deck, and select the destination deck in the next view.\nThe statistical information such as times played, time correct and card mastery are shown below.";
	self.helpController.title = @"Menu Help";
	[self.navigationController pushViewController: self.helpController animated: YES];
}

/** END HELP FUNCTIONS **/


/**
 Update the textfields & title for every appearance as we
 are using same controller for multiple cards
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	if(flag){
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Like decks, the question and answer of the card can be modified in the same way.\nPress Delete Card to delete this card.\nTo move cards press Move Card to Another Deck, and select the destination deck in the next view.\nYou can also check its statistics blow."
							  message:nil
							  delegate:self
							  cancelButtonTitle:@"Next Step"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	self.title = self.selectedCard.question;
	
	self.questionField.text = self.selectedCard.question;
	self.answerField.text = self.selectedCard.answer;
	self.hintField.text = self.selectedCard.hint;

	[self setupStatsLabel];
}

/**
 Refresh stats labels and mastery
 */
- (void) setupStatsLabel {
	NSString *seenString = [NSString stringWithFormat: @"%i", [self.selectedCard.timesSeen intValue]];
	self.statSeenLabel.text = seenString;
	NSString *correctString = [NSString stringWithFormat: @"%i", [self.selectedCard.timesCorrect intValue]];
	self.statCorrectLabel.text = correctString;
	
	// calculation of mastery is (timesCorrect / timesSeen) * 100
	double timesCorrect = [self.selectedCard.timesCorrect doubleValue];
	double timesSeen = [self.selectedCard.timesSeen doubleValue];
	double mastery;
	
	// avoid divide by zero error
	if (timesSeen != 0)
		mastery = (timesCorrect / timesSeen) * 100;
	else
		mastery = 0;
	
	self.statMasteryLabel.text = [NSString stringWithFormat: @"%f%%", mastery];
}

/**
 Save database when screen disappears
 */
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	NSError *error = nil;
	if (![self.selectedCard.managedObjectContext save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
}

/**
 So keyboard disappears, resign the responder
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

/**
 Depending on which textfield was updated, update the corresponding
 data in the card
 */
- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (textField == self.questionField) {
		self.selectedCard.question = textField.text;
	}
	else if (textField == self.answerField) {
		self.selectedCard.answer = textField.text;
	}
	else {
		self.selectedCard.hint = textField.text;
	}
}

- (void)dealloc {
	self.selectedCard = nil;
	self.questionField = nil;
	self.answerField = nil;
	self.hintField = nil;
	[super dealloc];
}


@end
