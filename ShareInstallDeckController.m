//
//  ShareInstallDeckController.m
//  FlashFun
//
//  Download and install the given deck id from website
//
//  Known bugs:
//   - Use of the strings "|||" or "^^^" in deck or cards will break parsing
//   - Likely will not work with some character encodings
//
//

#import "ShareInstallDeckController.h"
#import "Deck.h"
#import "HelpViewController.h"

@implementation ShareInstallDeckController

@synthesize data,
deckID,
deckName,
deckDesc,
downloadLabel,
installLabel,
cardsData,
managedObjectContext,
helpController,
fetchedResultsController,
helpReturn;

/**
 Start downloading and installing cards when appearing
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// whether we have been in help or not; do no download if we were
	if (helpReturn) {
		helpReturn = FALSE;
		return;
	}
	
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
	
	[self getCards];
	
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
	helpReturn = TRUE;
	self.helpController.descText = @"Ascertain whether downloading and installation of deck from website completes successfully.";
	self.helpController.title = @"Install Help";
	[self.navigationController pushViewController: self.helpController animated: YES];
}

/**
 Fetch the cards with the specified deck id
 */
- (void) getCards {
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"http://irc.summercat.com:65420/~ttb/ttb-cmpt275/website/download.php?id=%@", self.deckID]];
	NSURLRequest *request = [NSURLRequest requestWithURL: url
											 cachePolicy: NSURLRequestUseProtocolCachePolicy
										 timeoutInterval: 60.0];
	// start connection
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest: request delegate: self];
	if (connection) {
		data = [[NSMutableData data] retain];
	}
	else {
		// could not download
	}
}

/**
 NSURLConnection delegate function resets data storage every time response received
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[data setLength: 0];
}

/**
 NSURLConnection delegate function stores data as it is downloaded
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)recvData {
	[data appendData: recvData];
	//NSLog(@"downloading");
}

/**
 NSURLConnection delegate called when any error is found
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[connection release];
	[data release];
}

/**
 NSURLConnection delegate function is called when download is completed
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	downloadLabel.text = @"Done!";
	//NSLog(@"Received %d bytes of data", [data length]);
	NSString *content = [[NSString alloc] initWithBytes: [data bytes]
												 length: [data length] encoding: NSUTF8StringEncoding];
	
	cardsData = [[content componentsSeparatedByString: @"^^^"] retain];
	
	[self installDeck: cardsData];
	
	// debug
	/*
	NSLog(@"%i", [cardsData count]);
	for (int i = 0; i < [cardsData count]; i++) {
		NSLog(@":%@", [cardsData objectAtIndex: i]);
	}
	 */
	
	[connection release];
	[data release];
}

/**
 install given deck to database
 */
- (void) installDeck: (NSArray *) cardsArray {
	// debug
	/*
	NSLog(@"deck name: %@ desc: %@", self.deckName, self.deckDesc);
	for (int i = 0; i < [cardsArray count]-1; i++) {
		NSArray *content = [[cardsArray objectAtIndex: i] componentsSeparatedByString: @"|||"];
		NSLog(@"#%i q: %@ a: %@ h: %@", i, [content objectAtIndex: 0], [content objectAtIndex: 1], [content objectAtIndex: 2]);
	}
	 */
	
	NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
	NSEntityDescription *entity = [self.fetchedResultsController.fetchRequest entity];
	Deck *deck = [NSEntityDescription insertNewObjectForEntityForName: [entity name]
											   inManagedObjectContext: context];
	
	[deck setValue: self.deckName forKey:@"name"];
	[deck setValue: self.deckDesc forKey:@"desc"];
	[deck setValue: 0 forKey: @"timesSeen"];
	
	// add the cards
	NSManagedObjectContext *cardContext = deck.managedObjectContext;
	
	for (int i = 0; i < [cardsArray count]-1; i++) {
		NSArray *content = [[cardsArray objectAtIndex: i] componentsSeparatedByString: @"|||"];
		Card *card = [NSEntityDescription insertNewObjectForEntityForName: @"Card" 
												   inManagedObjectContext: cardContext];
	
		[card setValue: [content objectAtIndex: 0]  forKey: @"question"];
		[card setValue: [content objectAtIndex: 1] forKey: @"answer"];
		[card setValue: [content objectAtIndex: 2] forKey: @"hint"];

		[card setValue: 0 forKey: @"timesSeen"];
		[card setValue: 0 forKey: @"timesCorrect"];
	
		[deck addCardsObject:card];
	}
	
	NSError *error = nil;
	if (![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
	
	installLabel.text = @"Done!";
}

/**
 Get the fetched object controller for interaction with db
 */
- (NSFetchedResultsController *)fetchedResultsController {
	if (fetchedResultsController != nil) {
		return fetchedResultsController;
	}
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = 
	[NSEntityDescription entityForName:@"Deck"
				inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
										initWithKey:@"name" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	NSFetchedResultsController *aFetchedResultsController = 
	[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
										managedObjectContext:managedObjectContext
										  sectionNameKeyPath:nil
												   cacheName:@"Root"];
	aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	[aFetchedResultsController release];
	[fetchRequest release];
	[sortDescriptor release];
	
	return fetchedResultsController;
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Installing Deck";
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
	[cardsData release];
    [super dealloc];
}


@end
