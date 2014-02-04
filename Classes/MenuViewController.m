//
//  MenuViewController.m
//  FlashFun
//
//  Provides a main menu
//
//

#import "MenuViewController.h"
#import "FlashFunAppDelegate.h"
#import "EditController.h"
#import "ShareController.h"
#import "GameController.h"
#import "ConfigController.h"
#import "HelpViewController.h"

@implementation MenuViewController

@synthesize managedObjectContext,
editController,
shareController,
gameController,
configController,
helpController,
controller;

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
	self.helpController.descText = @"Welcome to Flash Fun, which is substituent of paper-based flash cards.\nPress \"Create/Edit Cards and Decks\" to create your own flash cards.\n\"Share Decks\" enables users to connect to the Internet to share cards with others.\nPress \"Configuration\" to change the system option.\nPress \"Study Game\" to start a flash card game.\nIf you are a new comer to this system, \"Tutorial\" will help you be familiar with it.";
	self.helpController.title = @"Menu Help";
	[self.navigationController pushViewController: self.helpController animated: YES];
}

/** END HELP FUNCTIONS **/

 - (void)viewWillAppear:(BOOL)animated {
	 [super viewWillAppear:animated];
	 
	 // bring up toolbar
	 [self.navigationController setToolbarHidden: FALSE];
}


/**
 Setup menu upon first load
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Flash Fun";
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }

    // Set up the cell...
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"Study Game";
			UIImage *gameIcon = [UIImage imageNamed: @"cards.png"];
			cell.imageView.image = gameIcon;
			break;

		case 1:
			cell.textLabel.text = @"Create/Edit Cards and Decks";
			UIImage *editIcon = [UIImage imageNamed: @"edit.png"];
			cell.imageView.image = editIcon;
			break;
			
		case 2:
			cell.textLabel.text = @"Configuration";
			UIImage *configIcon = [UIImage imageNamed: @"configure.png"];
			cell.imageView.image = configIcon;
			break;
			
		case 3:
			cell.textLabel.text = @"Share Decks";
			UIImage *shareIcon = [UIImage imageNamed: @"share.png"];
			cell.imageView.image = shareIcon;
			break;
			
		case 4:
			cell.textLabel.text = @"Tutorial";
			UIImage *tutIcon = [UIImage imageNamed: @"tutorial.png"];
			cell.imageView.image = tutIcon;
			break;
			
		default:
			break;
	}

    return cell;
}

/*
 * Find which view to bring when user taps on main menu
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		self.gameController.managedObjectContext = self.managedObjectContext;
		self.controller = self.gameController;
	}
	else if (indexPath.row == 1) {
		self.editController.managedObjectContext = self.managedObjectContext;
		self.controller = self.editController;
		editController.flag = NO;
	}
	else if (indexPath.row == 2) {
		self.controller = configController;
	}
	else if (indexPath.row == 3) {
		self.shareController.managedObjectContext = self.managedObjectContext;
		self.controller = shareController;
	}
	else if (indexPath.row == 4) {
		self.editController.managedObjectContext = self.managedObjectContext;
		self.controller = self.editController;
		editController.flag = YES;
	}
	
	// put next view on stack and go to it
	[self.navigationController pushViewController: self.controller animated: YES];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


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

- (void)dealloc {
    [super dealloc];
}


@end

