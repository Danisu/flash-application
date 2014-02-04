//
//  ShareController.m
//  FlashFun
//
//  Provide sub menu for sharing decks
//
//  Known bugs:
//   - Use of the strings "|||" or "^^^" in deck or cards will break parsing
//   - Likely will not work with some character encodings
//
//

#import "ShareController.h"
#import "ShareWebController.h"
#import "ShareSelectDeckController.h"
#import "HelpViewController.h";
#import "ShareDownloadController.h";
#import "ShareStatsController.h";

@implementation ShareController

@synthesize webController,
decks,
finished,
helpController,
selectController,
downloadController,
managedObjectContext,
statsController,
data;

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
	self.helpController.descText = @"From the Share Decks screen you may\n- Select Access Website to manage your use account\n- Select Upload Decks to upload a deck to the website";
	self.helpController.title = @"Share Decks Help";
	[self.navigationController pushViewController: self.helpController animated: YES];
}

/** END HELP FUNCTIONS **/

/**
 Initiate connection to get the public decks available to download
 */
- (void) getPublicDecks {
	NSURL *url = [NSURL URLWithString: @"http://irc.summercat.com:65420/~ttb/ttb-cmpt275/website/download.php"];
	NSURLRequest *request = [NSURLRequest requestWithURL: url
											 cachePolicy: NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:60.0];
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
	
	self.finished = TRUE;
}

/**
 NSURLConnection delegate function is called when download is completed
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	//NSLog(@"Received %d bytes of data", [data length]);
	NSString *content = [[NSString alloc] initWithBytes: [data bytes]
												 length: [data length] encoding: NSUTF8StringEncoding];
	
	decks = [[content componentsSeparatedByString: @"\n"] retain];
	
	// debug
	//NSLog(@"%i", [decks count]);
	//for (int i = 0; i < [decks count]; i++) {
		//NSLog(@":%@", [decks objectAtIndex: i]);
	//}
	
	[connection release];
	[data release];
	
	self.finished = TRUE;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Share Decks";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	self.finished = FALSE;
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"Access Website";
			cell.detailTextLabel.text = @"Register user and View Decks";
			break;
			
		case 1:
			cell.textLabel.text = @"Download Decks";
			break;
			
		case 2:
			cell.textLabel.text = @"Upload Decks";
			break;
			
		case 3:
			cell.textLabel.text = @"Statistics";
			cell.detailTextLabel.text = @"View statistics of website";
			break;
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	if (indexPath.row == 0) {
		[self.navigationController pushViewController: self.webController animated: YES];
	}
	else if (indexPath.row == 1) {
		[self getPublicDecks];
		
		// allow deck list to populate since it is fetched from webserver
		if (!self.finished) {
			UIAlertView *waitAlert = [[UIAlertView alloc]
									  initWithTitle:@"Fetching deck list is not complete. Please try again."
									  message:nil
									  delegate:self
									  cancelButtonTitle:nil
									  otherButtonTitles:@"OK", nil];
			[waitAlert show];
			[waitAlert release];
		}
		else {
			self.downloadController.decks = self.decks;
			self.downloadController.managedObjectContext = self.managedObjectContext;
			[self.navigationController pushViewController: self.downloadController animated: YES];
		}
	}
	else if (indexPath.row == 2) {
		self.selectController.managedObjectContext = self.managedObjectContext;
		[self.navigationController pushViewController: self.selectController animated: YES];
	}
	else if (indexPath.row == 3) {
		[self.navigationController pushViewController: self.statsController animated: YES];
	}
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[decks release];
    [super dealloc];
}


@end

