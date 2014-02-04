//
//  GameController.m
//  FlashFun
//
//  Queries the user for which deck to play in the game.
//  In future will query for which mode first.
//
//
//  Note: Much of this code is credited to Dudney and Adamson's iPhone SDK Development book
//  Particularly the CoreData stuff
//

#import "GameController.h"
#import "DeckEditingViewController.h"
#import "NormalGameModeController.h"
#import "Deck.h"
#import "HelpViewController.h"

@implementation GameController

@synthesize fetchedResultsController,
managedObjectContext,
deckEditingVC,
normalVC,
helpController,
firstInsert;

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
	self.helpController.descText = @"From the Deck Select screen you are expected to choose which deck to play a study game with";
	self.helpController.title = @"Deck Select Help";
	[self.navigationController pushViewController: self.helpController animated: YES];
}

/** END HELP FUNCTIONS **/

/**
 Setup the display page
 */
- (void)viewDidLoad {
	[super viewDidLoad];
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
	self.title = @"Choose Deck";
}

- (void)viewDidUnload {
	self.fetchedResultsController = nil;
}

/**
 Number of sections depends on sections found in db.
 Should always be 1 in our case, but...
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[fetchedResultsController sections] count];
}

/**
 Loads sections to the table
 */
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
	return [[[fetchedResultsController sections] objectAtIndex:section]
			numberOfObjects];
}

/**
 Set a given cell to data from a deck object
 */
- (void)configureCell:(UITableViewCell *)cell withDeck:(Deck *)deck {
	cell.textLabel.text = deck.name;
	cell.detailTextLabel.text = deck.desc;
}

/**
 Setup each cell as a deck
 */
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell =
	[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
									   reuseIdentifier:CellIdentifier] autorelease];
	}
	
	Deck *deck = [fetchedResultsController objectAtIndexPath:indexPath];
	[self configureCell:cell withDeck:deck];
	
	return cell;
}

/**
 When user selects a deck, bring up a view where the user may edit the said deck
 */
- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Deck *deck = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	self.normalVC.selectedDeck = deck;
	self.normalVC.title = deck.name;
	[self.navigationController pushViewController:self.normalVC animated:YES];
}

/**
 Can be used to initialize single cell for game modes
 */
- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSManagedObjectContext *context = 
		[fetchedResultsController managedObjectContext];
		Deck *deck = [fetchedResultsController objectAtIndexPath:indexPath];
		[context deleteObject:deck];
		
		// Save the context.
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		}
	}
}

/**
Access single row of the table and can use indexPath for rows to navigate to specific view controller
 */
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	// The table view should not be re-orderable.
	// because the fetch order is defined in the fetch results controller
	// and moving the rows would not be possible persistently
	return NO;
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

/**
 Updates the content of the table
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

/**
 Update table based on various possible events from fetchcontrollerdelegate
 */
- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject 
       atIndexPath:(NSIndexPath *)indexPath 
     forChangeType:(NSFetchedResultsChangeType)type 
      newIndexPath:(NSIndexPath *)newIndexPath {
	
	if(NSFetchedResultsChangeUpdate == type) {
		[self configureCell:[self.tableView cellForRowAtIndexPath:indexPath]
				   withDeck:anObject];
	}
	else if(NSFetchedResultsChangeMove == type) {
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
		 withRowAnimation:UITableViewRowAnimationFade];
	}
	else if(NSFetchedResultsChangeInsert == type) {
		if(!self.firstInsert) {
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
			 withRowAnimation:UITableViewRowAnimationRight];
		}
		else {
			[self.tableView insertSections:[[NSIndexSet alloc] initWithIndex:0] 
			 withRowAnimation:UITableViewRowAnimationRight];
		}
	}
	else if(NSFetchedResultsChangeDelete == type) {
		NSInteger sectionCount = [[fetchedResultsController sections] count];
		if(0 == sectionCount) {
			NSIndexSet *indexes = [NSIndexSet indexSetWithIndex:indexPath.section];
			[self.tableView deleteSections:indexes
			 withRowAnimation:UITableViewRowAnimationFade];
		}
		else {
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
			 withRowAnimation:UITableViewRowAnimationFade];
		}
	}
}

/**
 Finish updating table
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}

- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
	self.deckEditingVC = nil;
	self.normalVC = nil;
	[super dealloc];
}


@end

