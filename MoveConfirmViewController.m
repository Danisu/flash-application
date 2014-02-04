//
//  MoveConfirmViewController.m
//  FlashFun
//
//  Confirm dialogue for moving card to another deck
//
//

#import "MoveConfirmViewController.h"
#import "Card.h"
#import "Deck.h"
#import "HelpViewController.h"

@implementation MoveConfirmViewController

@synthesize toDeck,
fromDeck,
controller,
card,
helpController,
label;

/**
 User wants to move the card
 Remove reference in original deck to card and add it to
 the new deck
 */
- (IBAction) confirm {
	[self.fromDeck removeCardsObject: self.card];
	[self.toDeck addCardsObject: self.card];
	[self.navigationController popToViewController: self.controller animated: YES];
}

/**
 User changes mind about moving card
 */
- (IBAction) deny {
	[self.navigationController popToViewController: self.controller animated: YES];
}

/**
 Update title & label every time as we are reusing the same
 view controller for multiple cards/decks
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.title = @"Move Card";
	
	// make the label
	NSString *labelText = [@"Move card from: " stringByAppendingString: self.fromDeck.name];
	labelText = [labelText stringByAppendingString: @" to "];
	labelText = [labelText stringByAppendingString: self.toDeck.name];
	labelText = [labelText stringByAppendingString: @"?"];
	
	label.text = labelText;
	labelText = nil;
	
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
	self.helpController.descText = @"Confirm whether you wish to move the card to the selected deck or not.";
	self.helpController.title = @"Move Help";
	[self.navigationController pushViewController: self.helpController animated: YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

- (void)dealloc {
    [super dealloc];
}


@end
