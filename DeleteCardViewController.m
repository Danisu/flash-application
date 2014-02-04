//
//  DeleteCardViewController.m
//  FlashFun
//
//  Prompt the user to confirm whether they wish to delete
//  a card or not.
//
//

#import "DeleteCardViewController.h"
#import "Card.h"
#import "Deck.h"
#import "HelpViewController.h"

@implementation DeleteCardViewController

@synthesize cardLabel,
cardsController,
helpController,
selectedCard,
selectedDeck;

/**
 User wants deck deleted
 */
- (IBAction) confirm {
	[self.selectedDeck removeCardsObject: self.selectedCard];
	NSManagedObjectContext *context = self.selectedDeck.managedObjectContext;
	[context deleteObject: self.selectedCard];
	// Save the context.
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
	
	[self.navigationController popToViewController: self.cardsController animated:YES];
}

/**
 User does not want card deleted
 */
- (IBAction) deny {
	[self.navigationController popViewControllerAnimated:YES];
}

/**
 Update label and title every appearance as we are using the same
 controller for multiple cards
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.title = selectedCard.question;
	
	// setup label
	NSString *label = [@"Delete card: " stringByAppendingString: selectedCard.question];
	label = [label stringByAppendingString: @"?"];
	cardLabel.text = label;
	label = nil;
	
	// create help button and add to toolbar
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle: @"Help"
															   style: UIBarButtonItemStyleBordered
															  target: self
															  action: @selector(help)];
	NSArray *barItems = [NSArray arrayWithObject: button];
	[self setToolbarItems: barItems animated: FALSE];
	[button release];
}

- (void) help {
	self.helpController.descText = @"Confirm whether you wish to delete the selected card from the database or not.";
	self.helpController.title = @"Delete Help";
	[self.navigationController pushViewController: self.helpController animated: YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)dealloc {
    [super dealloc];
}


@end
