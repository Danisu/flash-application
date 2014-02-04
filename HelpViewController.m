//
//  HelpViewController.m
//  FlashFun
//
//  Template help file. Actual contents are updated by calling controller
//
//

#import "HelpViewController.h"

@implementation HelpViewController

@synthesize textView,
descText;

/**
 Return to the main menu when button clicked
 */
- (void) returnToRoot {
	[self.navigationController popViewControllerAnimated: YES];
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

/**
 Make sure textview isn't editable after loading
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.textView.editable = FALSE;
}

- (void)viewDidAppear:(BOOL)animated {
	self.textView.text = self.descText;
}

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
