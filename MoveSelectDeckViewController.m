//
//  MoveSelectDeckViewController.m
//  FlashFun
//
//  Give the user a list of decks which a card may be
//  moved to
//

#import "MoveSelectDeckViewController.h"
#import "Deck.h"
#import "MoveConfirmViewController.h"
#import "Card.h"
#import "HelpViewController.h"

@implementation MoveSelectDeckViewController

@synthesize cardsController,
fetchedResultsController,
managedObjectContext,
selectedDeck,
selectedCard,
helpController,
confirmVC;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear {
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
}

/**
 Update title every appearance as we are using same controller for
 multiple decks
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.title = @"Choose Target Deck";
	[self.tableView reloadData];
	
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
	self.helpController.descText = @"Select the target deck\nIn the next view, press \"Move card\" to confirm your operation, or press \"Cancel\" to discard.";
	self.helpController.title = @"Move Help";
	[self.navigationController pushViewController: self.helpController animated: YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.fetchedResultsController = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[fetchedResultsController sections] count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[fetchedResultsController sections] objectAtIndex:section]
			numberOfObjects];
}

// Setup table cells with deck info
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell	
	Deck *deck = [fetchedResultsController objectAtIndexPath: indexPath];
	cell.textLabel.text = deck.name;
    return cell;
}

/**
 Disallow selection of original deck as target deck. Notify the user this occurs
 Not really an ideal solution, but would be a big hack to not add originating deck.
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Deck *deck = [fetchedResultsController objectAtIndexPath: indexPath];
	if (deck == self.selectedDeck) {
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
		cell.detailTextLabel.text = @"This is the originating deck!";
		cell = nil;
		return nil;
	}
	else {
		return indexPath;
	}
}

/**
 Bring up confirm dialogue when a deck has been selected
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.confirmVC.fromDeck = self.selectedDeck;
	self.confirmVC.card = self.selectedCard;
	self.confirmVC.controller = self.cardsController;
	self.confirmVC.toDeck = [fetchedResultsController objectAtIndexPath: indexPath];
	[self.navigationController pushViewController: self.confirmVC animated: YES];
}

/**
 We don't want table to be editable as we have no way of order of data
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if (self = [super initWithStyle:style]) {
 }
 return self;
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
	[fetchedResultsController release];
	[managedObjectContext release];
	
    [super dealloc];
}


@end

