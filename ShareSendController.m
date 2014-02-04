//
//  ShareSendController.m
//  FlashFun
//
//  Allow user to upload decks to website
//
//  Known Bugs:
//   - Does not do much checking for whether the phone is connected to the
//    internet. Tries to connect regardless
//
//

#import "ShareSendController.h"
#import "FlashFunAppDelegate.h"
#import "HelpViewController.h"
#import "ShareSendReceiveController.h"
#import "Deck.h"

@implementation ShareSendController

@synthesize usernameField,
passwordField,
helpController,
receiveController,
selectedDeck,
fetchedResultsController,
managedObjectContext,
privateSwitch;

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
	
	 NSError *error = nil;
	 if (![self.fetchedResultsController performFetch:&error]) {
	 NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	 }
}

/**
 Call up help screen with data
 */
- (void) help {
	self.helpController.descText = @"In order to upload a deck you must enter your username and password credentials which correspond to your Flash Fun website credentials.\nAs well as this, you are required to enter a name for your deck which will identify the deck on the website.";
	self.helpController.title = @"Upload Deck Help";
	[self.navigationController pushViewController: self.helpController animated: YES];
}

/** END HELP FUNCTIONS **/

/**
 Attempt to submit database to website using specified username/password
 
 Much of this code is credited to Todd Ditchendorf: http://lists.apple.com/archives/web-dev/2007/Dec/msg00017.html
 */
- (void) submit {
	// hide keyboard
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
	
	// XXX to read from file
	// get path to stored database
	//FlashFunAppDelegate *appDelegate = (FlashFunAppDelegate *)[[UIApplication sharedApplication] delegate];
	//NSString *filename = appDelegate.sqliteDB;
	//NSData *data = [NSData dataWithContentsOfFile: filename options: 0 error: nil];
	
	// debug
	//NSLog(@"%@", filename);
	
	// We use boundary for some formatting of request
	NSString *boundary = @"----FOO";
	
	// create the URL
	// debug url
	//NSString *baseURL = @"http://irc.summercat.com:65420/~ttb/work/upload.php";
	NSString *baseURL = @"http://irc.summercat.com:65420/~ttb/ttb-cmpt275/website/upload.php";
	NSString *fullURL = [NSString stringWithFormat: @"%@?username=%@&password=%@", baseURL, usernameField.text, passwordField.text];
	NSURL *url = [NSURL URLWithString: fullURL];
	
	// Set up the request
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
	[request setHTTPMethod: @"POST"];
	
	NSString *contentType = [NSString stringWithFormat: @"multipart/form-data, boundary=%@", boundary];
	[request setValue: contentType forHTTPHeaderField: @"Content-Type"];
	
	// setup the body
	NSMutableData *postBody = [NSMutableData data];
	
	// db_file input: file
	/*
	[postBody appendData: [[NSString stringWithFormat: @"--%@\r\n", boundary] dataUsingEncoding: NSUTF8StringEncoding]];
	[postBody appendData: [[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"db_file\"; filename=\"%@\"\r\n", @"FlashFun.sqlite"]
	   dataUsingEncoding: NSUTF8StringEncoding]];
	[postBody appendData: [@"Content-Type: text/plain\r\n\r\n" dataUsingEncoding: NSUTF8StringEncoding]];
	[postBody appendData: data];
	[postBody appendData: [[NSString stringWithFormat: @"\r\n--%@\r\n", boundary] dataUsingEncoding: NSUTF8StringEncoding]];
	*/
	
	// card_data input: text
	[postBody appendData: [[NSString stringWithFormat: @"--%@\r\n", boundary] dataUsingEncoding: NSUTF8StringEncoding]];
	[postBody appendData: [[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"card_data\"\r\n\r\n"] dataUsingEncoding: NSUTF8StringEncoding]];
	[postBody appendData: [[NSString stringWithFormat: @"%@", [self cardsData]] dataUsingEncoding: NSUTF8StringEncoding]];
	[postBody appendData: [[NSString stringWithFormat: @"\r\n--%@\r\n", boundary] dataUsingEncoding: NSUTF8StringEncoding]];	
	
	// add the rest of fields data to POST
	[self postField: postBody field: @"deck_name"
			content: selectedDeck.name boundary: boundary];
	
	[self postField: postBody field: @"numcards"
			content: [NSString stringWithFormat: @"%i", [self numCards]] boundary: boundary];
	
	NSString *private = @"0";
	if (privateSwitch.on) {
		private = @"1";
	}
	[self postField: postBody field: @"private"
			content: private boundary: boundary];
	
	[self postField: postBody field: @"deckdesc"
			content: selectedDeck.desc boundary: boundary];
	
	// end POST format
	[postBody appendData: [[NSString stringWithFormat: @"--\r\n", boundary] dataUsingEncoding: NSUTF8StringEncoding]];
	
	[request setHTTPBody: postBody];
	
	self.receiveController.request = request;
	[self.navigationController pushViewController: self.receiveController animated: YES];
}

/**
 Format a text field for POSTing
 
 Append by reference to postBody
 */
- (void) postField: (NSMutableData *) postBody
				   field: (NSString *) field
				 content: (NSString *) content
				boundary: (NSString *) boundary {
	[postBody appendData: [[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", field] dataUsingEncoding: NSUTF8StringEncoding]];
	[postBody appendData: [[NSString stringWithFormat: @"%@", content] dataUsingEncoding: NSUTF8StringEncoding]];
	[postBody appendData: [[NSString stringWithFormat: @"\r\n--%@\r\n", boundary] dataUsingEncoding: NSUTF8StringEncoding]];
	//NSLog(@"postfield: field: %@ content: %@", field, content);
}

/**
 Return number of cards in selectedDeck
 */
- (int) numCards {
	NSArray *sections = [self.fetchedResultsController sections];
	NSUInteger count = 0;
	if ([sections count]) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex: 0];
		count = [sectionInfo numberOfObjects];
	}
	return count;
}

/**
 Extract cards from selected deck to a string
 */
- (NSString *) cardsData {
	int count = [self numCards];
	//NSLog(@"We have %i cards", count);
	
	NSString *data = @"";
	// get card data into a string
	for (int i = 0; i < count; i++) {
		NSIndexPath *path = [NSIndexPath indexPathForRow: i inSection: 0];
		NSManagedObject *card = [self.fetchedResultsController objectAtIndexPath: path];
		
		NSString *answer = [card valueForKey: @"answer"];
		NSString *question = [card valueForKey: @"question"];
		NSString *hint = [card valueForKey: @"hint"];
		
		data = [data stringByAppendingString: question];
		data = [data stringByAppendingString: @"|||"];
		data = [data stringByAppendingString: answer];
		data = [data stringByAppendingString: @"|||"];
		data = [data stringByAppendingString: hint];
		data = [data stringByAppendingString: @"^^^"];
		
		//NSLog(@"full: %@", data);
	}
	
	//NSManagedObjectID *oid = [self.selectedDeck objectID];
	//	int pk = [[self.selectedDeck valueForKey: @"_PK"] intValue];
	//	NSLog(@"%d", pk);
	//NSLog(@"%@", [[oid URIRepresentation] absoluteURL]);
	
	// reset fetched controller to account for switchin decks
	self.fetchedResultsController = nil;
	
	return data;
}

/**
 Make keyboard disappear when user selects return
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
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
	
	self.title = @"Upload Decks";
	self.passwordField.secureTextEntry = TRUE;
}

/**
 Create and return a fetched results controller for working with db
 */
- (NSFetchedResultsController *)fetchedResultsController {
	if (nil == fetchedResultsController) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		// context is similar to a database
		NSManagedObjectContext *context = self.selectedDeck.managedObjectContext;
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Card"
												  inManagedObjectContext:context];
		[fetchRequest setEntity:entity];
		
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"deck = %@",
							 self.selectedDeck];
		[fetchRequest setPredicate:pred];
		
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
											initWithKey:@"question" ascending:YES];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		
		NSFetchedResultsController *aFetchedResultsController = 
		[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
											managedObjectContext:context
											  sectionNameKeyPath:nil
													   cacheName:@"Cards"];
		aFetchedResultsController.delegate = self;
		self.fetchedResultsController = aFetchedResultsController;
		NSError *error = nil;
		if (![self.fetchedResultsController performFetch:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		}
		[aFetchedResultsController release];
		[fetchRequest release];
		[sortDescriptor release];
	}	
	return fetchedResultsController;
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
