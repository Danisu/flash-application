//
//  DeckEditingViewController.m
//  FlashFun
//
//  Allow the user to edit the deck name and description
//  Also provide for deleting the deck and viewing cards
//
//
//  Note: Much of this code is credited to Dudney and Adamson's iPhone SDK Development book
//  Particularly the CoreData stuff
//

#import "DeckEditingViewController.h"
#import "Deck.h"
#import "CardsViewController.h"
#import "DeleteDeckViewController.h"
#import "HelpViewController.h"

@implementation DeckEditingViewController

@synthesize nameField,
descField,
selectedDeck,
cardsVC,
deleteVC,
managedObjectContext,
fetchedResultsController,
editController,
helpController,
statsLabel,
flag;



/** HELP FUNCTIONS START HERE
 Note: Some files probably have viewDidAppear() already so the contents here
 will need to be added to the bottom of them
 (with the exception of [super viewDidAppear...]
 */

/**
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
	self.helpController.descText = @"Enter in a name into the 'Deck Name' field and enter in a description of the deck into the 'Deck Description field. To view the cards in the deck or to add more cards to the deck, select 'View or Add Cards'. To delete the deck press 'Delete Deck'.";
	self.helpController.title = @"Edit Deck Help";
	[self.navigationController pushViewController: self.helpController animated: YES];
}

/** END HELP FUNCTIONS **/



/**
 Delete deck button action.
 */
- (IBAction) deleteDeck {
	self.deleteVC.selectedDeck = self.selectedDeck;
	self.deleteVC.managedObjectContext = self.managedObjectContext;
	self.deleteVC.fetchedResultsController = self.fetchedResultsController;
	self.deleteVC.editController = self.editController;
	[self.navigationController pushViewController: self.deleteVC animated: YES];
}

/**
 View cards button
 */
- (IBAction) viewCards {
	self.cardsVC.selectedDeck = self.selectedDeck;
	self.cardsVC.deckFetchedResultsController = self.fetchedResultsController;
	self.cardsVC.deckManagedObjectContext = self.managedObjectContext;
	cardsVC.flag = flag;
	[self.navigationController pushViewController: self.cardsVC animated: YES];
}

/**
 Reset deck statistics to 0
 */
- (IBAction) resetStats {
	self.selectedDeck.timesSeen = [NSNumber numberWithInt: 0];
	self.statsLabel.text = [NSString stringWithFormat: @"%i", [self.selectedDeck.timesSeen intValue]];
}

/**
 Setup the done button which returns to the main deck view
 */
- (void)viewDidLoad {
	[super viewDidLoad];
}

/**
 Update fields and title every time as we reuse the same controller
 for multiple decks
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	if(flag){
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"In this view, If you'd like to modify the name and description of your deck, input them in the text field and press Deck button.\nPress Delete Deck to delete this deck.\nPress View or Add Cards to add and new cards in this deck."
							  message:nil
							  delegate:self
							  cancelButtonTitle:@"Next Step"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}

	self.nameField.text = self.selectedDeck.name;
	self.descField.text = self.selectedDeck.desc;
	self.statsLabel.text = [NSString stringWithFormat: @"%i", [self.selectedDeck.timesSeen intValue]];
	self.title = self.selectedDeck.name;
}

/**
 Save database when view disappears
 */
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	NSError *error = nil;
	if (![self.selectedDeck.managedObjectContext save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
}

- (void)didReceiveMemoryWarning {
	// if the view's window is nil then the view is not displayed
	if(nil == self.view.window) {
		self.nameField = nil;
		self.descField = nil;
	}
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.nameField = nil;
	self.descField = nil;
}

/**
 Make keyboard disappear when user selects return
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

/**
 When textfield has been edited updated the object
 */
- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (textField == self.nameField) {
		self.selectedDeck.name = textField.text;
	}
	else {
		self.selectedDeck.desc = textField.text;
	}
}

- (void)dealloc {
	self.nameField = nil;
	self.descField = nil;
	self.selectedDeck = nil;
	[super dealloc];
}


@end