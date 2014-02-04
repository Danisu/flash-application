//
//  CardsViewController.m
//  FlashFun
//
// Tableview controller which displays cards in a specific deck.
// Allows the user to view specific detail of cards by selecting them.
//
//
//  Note: Much of this code is credited to Dudney and Adamson's iPhone SDK Development book
//  Particularly the CoreData stuff
//

#import "CardsViewController.h"
#import "CardEditingViewController.h"
#import "Deck.h"
#import "Card.h"
#import "HelpViewController.h"

@implementation CardsViewController

@synthesize selectedDeck,
selectedIndexPath,
cardEditingVC,
fetchedResultsController,
firstInsert,
deckManagedObjectContext,
helpController,
deckFetchedResultsController,
flag;

/**
 Setup the add button which inserts a card when screen has loaded
 */
- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
								  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
								  target:self
								  action:@selector(insertCard)];
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
}

/**
 Update title each time screen appears as same controller is used for
 many disparate decks
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.title = self.selectedDeck.name;
	if(flag){
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"At this stage, press + button to add new cards into your selected deck.\nClick a card to edit it or move it to another deck."
							  message:nil
							  delegate:self
							  cancelButtonTitle:@"Next Step"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

/**
 configure selected cell when appears
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
	
	// If we delete or move to 0 cards, don't try to reconfigure selected cell
	// or we will have a coredata fault/out of array bounds
	if ([self.selectedDeck.cards count] == 0)
		return;
	
	if(nil != self.selectedIndexPath) {
		[self configureCell:[self.tableView cellForRowAtIndexPath:self.selectedIndexPath]
				   withCard:[self.fetchedResultsController objectAtIndexPath:self.selectedIndexPath]];
	}
	self.selectedIndexPath = nil;
}

- (void) help {
	self.helpController.descText = @"This page lists all the cards in the selected deck, demonstrating the their questions and answers.\npress + button to add new cards into your selected deck.\nClick a card to edit it or move it to another deck.";
	self.helpController.title = @"Menu Help";
	[self.navigationController pushViewController: self.helpController animated: YES];
}

/**
 Called when add button is pressed. Add a new card to the database and save
 */
- (void)insertCard {
	// Check whether this is the first insert or not
	self.firstInsert = [self.fetchedResultsController.sections count] == 0;

	// Create a new card managed by the fetched results controller
	NSManagedObjectContext *context = self.selectedDeck.managedObjectContext;
	Card *card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" 
											   inManagedObjectContext:context];
	
	// Setup the new card and add it
	[card setValue: @"Question" forKey: @"question"]; //deleted "Question" so that the field is now blank
	[card setValue: @"" forKey: @"answer"]; //deleted text "This is a good answer"
	[card setValue: 0 forKey: @"timesSeen"];
	[card setValue: 0 forKey: @"timesCorrect"];
	[card setValue: @"" forKey: @"hint"];
	
	[self.selectedDeck addCardsObject:card];
	
	// Save the database
	NSError *error = nil;
	if (![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
}

/**
 Reload the table if differing deck
 */
- (void)setSelectedDeck:(Deck *)deck {
	if(deck != selectedDeck) {
		[selectedDeck release];
		selectedDeck = [deck retain];
		self.fetchedResultsController = nil;
		[self.tableView reloadData];
	}
}

/**
 Sections in table is managed by the database.
 In this implementation should always be 1
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
 Number of rows in table dependent upon cards in deck
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
 Setup the given cell with values from card
 */
- (void)configureCell:(UITableViewCell *)cell withCard:(NSManagedObject *)model {
	cell.textLabel.text = [model valueForKey:@"question"];
	cell.detailTextLabel.text = [model valueForKey:@"answer"];
}

/**
 Configure each cell with card data
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	[self configureCell:cell
			   withCard:[self.fetchedResultsController objectAtIndexPath:indexPath]];
	
	return cell;
}

/**
 When row is selected, change to a more detailed card view.
 Pass various data needed by further viewcontrollers
 */
- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedIndexPath = indexPath;
	Card *card = [self.fetchedResultsController objectAtIndexPath:indexPath];
	self.cardEditingVC.selectedCard = card;
	self.cardEditingVC.selectedDeck = self.selectedDeck;
	self.cardEditingVC.cardsController = self;
	self.cardEditingVC.managedObjectContext = self.deckManagedObjectContext;
	self.cardEditingVC.fetchedResultsController = self.deckFetchedResultsController;
	self.cardEditingVC.flag = flag;
	[self.navigationController pushViewController:self.cardEditingVC 
	 animated:YES];
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

/**
 Start updating. Controlled by NSFetchControllerDelegate
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

	// If database data changed
	if(NSFetchedResultsChangeUpdate == type) {
		[self configureCell:[self.tableView cellForRowAtIndexPath:indexPath]
				   withCard:anObject];
	}
	
	// Data moved
	else if(NSFetchedResultsChangeMove == type) {
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
		 withRowAnimation:UITableViewRowAnimationFade];
	}
	
	// new object inserted
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
	
	// object deleted
	else if(NSFetchedResultsChangeDelete == type) {
		NSInteger sectionCount = [[self.fetchedResultsController sections] count];
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
	self.selectedDeck = nil;
	self.fetchedResultsController = nil;
	self.selectedIndexPath = nil;
	[super dealloc];
}


@end
