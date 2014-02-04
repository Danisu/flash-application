//
//  ConfigController.m
//  FlashFun
//
//  Control various settings of the application
//

#import "ConfigController.h"
#import "FlashFunAppDelegate.h"
#import "HelpViewController.h"

@implementation ConfigController

@synthesize querySwitch,
helpController,
hintSwitch,
soundSwitch;

/**
 Get state of switches from app delegate
 */
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear: animated];
	self.title = @"Configuration";
	
	/** HELP FUNCTIONS START HERE
	 Setup toolbar and help button
	 */

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
	self.helpController.descText = @"There are two options that may be configured by users.\nTurning on \"Record card response\" enables recording the times that a card has been seen and answered correctly.\nTurning on \"User Hints\" changes whether hints displayed are user set or are \"hangman style\" if off.";
	self.helpController.title = @"Configuration Help";
	[self.navigationController pushViewController: self.helpController animated: YES];
}

/** END HELP FUNCTIONS **/

/**
 Update variables in appDelegate when user changes a setting
 */
- (IBAction) change {
	FlashFunAppDelegate *appDelegate = (FlashFunAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.queryEnabled = querySwitch.on;
	appDelegate.hintsEnabled = hintSwitch.on;
	appDelegate.soundEnabled = soundSwitch.on;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	FlashFunAppDelegate *appDelegate = (FlashFunAppDelegate *)[[UIApplication sharedApplication] delegate];
	[querySwitch setOn: appDelegate.queryEnabled animated: NO];
	[hintSwitch setOn: appDelegate.hintsEnabled animated: NO];
	[soundSwitch setOn: appDelegate.soundEnabled animated: NO];
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
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
