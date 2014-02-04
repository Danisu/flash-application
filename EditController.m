//
//  EditController.m
//  FlashFun
//
//  Main deck view controller. Lists all decks currently
//  in the database & allows user to add more or view more
//  detailed information about each deck.
//
//
//  Note: Much of this code is credited to Dudney and Adamson's iPhone SDK Development book
//  Particularly the CoreData stuff
//

#import "EditController.h"
#import "DeckEditingViewController.h"
#import "Deck.h"
#import "HelpViewController.h"

@implementation EditController

@synthesize fetchedResultsController,
managedObjectContext,
deckEditingVC,
firstInsert,
helpController,
flag;

/**
 Setup the add button which creates a new deck when pressed
 */
- (void)viewDidLoad {
	[super viewDidLoad];
	
	// add button
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
								  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
								  target:self
								  action:@selector(insertDeck)];
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
	
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
	self.title = @"Decks";
}


/** HELP FUNCTIONS START HERE
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
	self.helpController.descText = @"This is the Deck viewing screen. \n \nTo view the Cards in a Deck, select the Deck.  \n \nYou can add a new deck by pressing \"+\" and a new deck labelled \"Deck\" will appear. Select the new deck to give it a name, description and to add cards.";
	self.helpController.title = @"Deck Help";
	[self.navigationController pushViewController: self.helpController animated: YES];
}

-(void)viewWillAppear:(BOOL)animated{
	if(flag){
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Welcome to Tutorial!\nThis tutorial will aquaint you with the whole process of creating and editing your own Flash Cards.\nLet's begin!\nFirstly, press + button to add a new deck.\nThen click the deck to edit and add new cards."
							  message:nil
							  delegate:self
							  cancelButtonTitle:@"Next Step"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	
}

/**
 Create and add a new deck to the database.
 Called by the add button
 */
- (void)insertDeck {
	// Check whether this is the first insert or not
	self.firstInsert = [self.fetchedResultsController.sections count] == 0;
	
	NSManagedObjectContext *context = 
		[self.fetchedResultsController managedObjectContext];
	NSEntityDescription *entity = 
		[self.fetchedResultsController.fetchRequest entity];
	Deck *deck = [NSEntityDescription insertNewObjectForEntityForName:[entity name]
											   inManagedObjectContext:context];
	
	[deck setValue:@"Deck" forKey:@"name"];
	[deck setValue:@"" forKey:@"desc"];
	[deck setValue:0 forKey: @"timesSeen"];
	
	NSError *error = nil;
	if (![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
}

- (void)viewDidUnload {
	self.fetchedResultsController = nil;
}

/**
 Number of sections depends on sections found in db.
 Should always be 1 in our case, but...
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// below code courtesy of the apple API
	NSUInteger count = [[self.fetchedResultsController sections] count];
    if (count == 0) {
        count = 1;
    }
    return count;	
}

/**
 Number of rows = number of decks in database
 */
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	// below code courtesy of apple API
	NSArray *sections = [self.fetchedResultsController sections];
    NSUInteger count = 0;
    if ([sections count]) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        count = [sectionInfo numberOfObjects];
    }
    return count;
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
	
	self.deckEditingVC.selectedDeck = deck;
	self.deckEditingVC.managedObjectContext = self.managedObjectContext;
	self.deckEditingVC.fetchedResultsController = self.fetchedResultsController;
	self.deckEditingVC.editController = self;
	self.deckEditingVC.flag = flag;
	[self.navigationController pushViewController: self.deckEditingVC animated: YES];
}

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

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

/**
 Perform various updates when fetched controller delegate sends
 events
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}

- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
	self.deckEditingVC = nil;
	
	[super dealloc];
}


@end