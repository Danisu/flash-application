//
//  DeleteDeckViewController.m
//  FlashFun
//
//  Confirmation dialogue when user asks for deck deletion
//
//

#import "DeleteDeckViewController.h"
#import "Deck.h"
#import "HelpViewController.h"

@implementation DeleteDeckViewController

@synthesize selectedDeck,
managedObjectContext,
fetchedResultsController,
editController,
helpController,
deckLabel;

// HELP FUNCTIONS START HERE

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
	self.helpController.descText = @"Click 'Delete Deck' to permanently delete the entire deck. Click 'Cancel' to return to the previous screen.";
	self.helpController.title = @"Delete Help";
	[self.navigationController pushViewController: self.helpController animated: YES];
}

/** END HELP FUNCTIONS **/




/**
 User wants deck deleted
 */
- (IBAction) confirm {
	NSManagedObjectContext *context = 
		[fetchedResultsController managedObjectContext];
	[context deleteObject: self.selectedDeck];
	
	// Save the context.
	NSError *error;
	if (![context save:&error]) {
		// Handle the error...
	}
	
	[self.navigationController popToViewController: editController animated:YES];
}

/**
 User does not want deck deleted
 */
- (IBAction) deny {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 Update title and label each time view appears as we are reusing the controller
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.title = self.selectedDeck.name;

	// setup the label
	NSString *label = [@"Delete " stringByAppendingString: selectedDeck.name];
	label = [label stringByAppendingString: @"?"];
	deckLabel.text = label;
	label = nil;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {

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
