//
//  ShareWebController.m
//  FlashFun
//
//  Share and download decks through the website
//
//
//  Note: URL stuff credited to iPhone SDK Development (2009) by Dudney and Adamson
//

#import "ShareWebController.h"
#import "HelpViewController.h"

@implementation ShareWebController

@synthesize webView,
helpController;

/**
 Function which loads the request to the webview. Hardcoded url as we
 don't ever want to start from anywhere else
 */
- (void) loadURL {
	NSURL *url = [[NSURL alloc] initWithString: @"http://irc.summercat.com:65420/~ttb/ttb-cmpt275/website"];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	[webView loadRequest: request];
	[request release];
	[url release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Share Decks";
}

// loading indication
- (void)webViewDidStartLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// stop loading indication
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

// load up the website when screen appears
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear: animated];
	[self loadURL];
	
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
	self.helpController.descText = @"In Access Website the Flash Fun website is accessible. From the website you may accomplish such actions as:\n- Registering an account on the website\n- Viewing your uploaded decks from the Home control panel";
	self.helpController.title = @"Access Website Help";
	[self.navigationController pushViewController: self.helpController animated: YES];
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
