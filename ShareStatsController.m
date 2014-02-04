//
//  ShareStatsController.m
//  FlashFun
//
//  Access website statistics
//
//

#import "ShareStatsController.h"
#import "HelpViewController.h"

@implementation ShareStatsController

@synthesize helpController,
webView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Statistics";
}

- (void)viewDidAppear:(BOOL) animated {
	[super viewDidAppear: animated];
	
	NSURL *url = [[NSURL alloc] initWithString: @"http://irc.summercat.com:65420/~ttb/ttb-cmpt275/website/stats.php"];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	[webView loadRequest: request];
	[request release];
	[url release];	
}

- (void)viewWillAppear:(BOOL) animated {
	[super viewWillAppear: animated];
	
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
	self.helpController.descText = @"View statistics of the website.";
	self.helpController.title = @"Statistics Help";
	[self.navigationController pushViewController: self.helpController animated: YES];
}

// loading indication
- (void)webViewDidStartLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// stop loading indication
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
