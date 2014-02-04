//
//  NormalGameModeController.m
//  FlashFun
//
//  This file allows the user to play the actual study game
//  through a tab bar interface.
//
//
//  Note: A lot of the core data code is credited to Dudney and Adamson's iPhone SDK Development book

#import "NormalGameModeController.h"
#import "CardEditingViewController.h"
#import "Deck.h"
#import "Card.h"
#import "HelpViewController.h"
#import "FlashFunAppDelegate.h"

@implementation NormalGameModeController

@synthesize selectedDeck,
selectedCard,
helpController,
selectedIndexPath,
cardEditingVC,
fetchedResultsController,
firstInsert, //bool for first insert
tabBarController,
data,
statsCounter,
cardsArray, //array of cards
i,//index for data array
segment,
gameLabel, // text view for questions, answers and hints
indexCounter, //indexcounter for display
indexCounterCards, // number of cards in the deck
normalGameModeDisplay,
reverseMode,
alert,
right;

/**
 Setup the display page
 */
- (void)viewDidLoad {
	[super viewDidLoad];
	i = 0;

	[self.data removeAllObjects];
	[self.data autorelease];
	data = [[NSMutableArray alloc] init];
	[self.cardsArray removeAllObjects];
	[self.cardsArray autorelease];
	cardsArray = [[NSMutableArray alloc] init];
	self.title = @"Play";
	segment.selectedSegmentIndex = 0;
	[self.tableView reloadData];
}

/**
 configure selected cell when appears
 */
- (void)viewDidAppear:(BOOL)animated {
	// help button
	[super viewDidAppear:animated];
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle: @"Help"
															   style: UIBarButtonItemStyleBordered
															  target: self
															  action: @selector(help)];
	NSArray *barItems = [NSArray arrayWithObject: button];
	[self setToolbarItems: barItems animated: FALSE];
	[button release];
	//end of help button
	[super viewDidAppear:animated];
	i = 0;
	if(nil != self.selectedIndexPath) {
		[self configureCell:[self.tableView cellForRowAtIndexPath:self.selectedIndexPath]
				   withCard:[self.fetchedResultsController objectAtIndexPath:self.selectedIndexPath]];
	}
}


/**
 Call up help screen with data
 */
- (void) help {
	self.helpController.descText = @"The \"Question\", \"Answer\" and \"Hint\" tab seperately demonstrates the question, answer and hint of a card.\nPress \"Previous\" or \"Next\" to see another card.If users choose Normal Mode, they must see the answer before entering the next card.\nIf Reverse Mode is chosen, users should see qusteion before pressing Next";
	self.helpController.title = @"Game Help";
	[self.navigationController pushViewController: self.helpController animated: YES];
}

/** END HELP FUNCTIONS **/


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView == alert){
		reverseMode = NO;
		if(buttonIndex == 0) {
			//segment.selectedSegmentIndex = 1;
			[self change];
		} else if (buttonIndex == 1) {
			reverseMode = YES;
			//segment.selectedSegmentIndex = 2;
			[self change];
		}
	}
	else if(alertView == right){
		//For updating card stats
		selectedCard = [cardsArray objectAtIndex:statsCounter];
		int timesCorrect = [self.selectedCard.timesCorrect intValue];
		int timesSeen = [self.selectedCard.timesSeen intValue];
		timesSeen ++;
		if(buttonIndex == 0){
			timesCorrect ++;
		}
		
		NSNumber *timesSeenNSNum = [[NSNumber alloc] initWithInt: timesSeen];
		NSNumber *timesCorrectNSNum = [[NSNumber alloc] initWithInt: timesCorrect];
		//NSLog(@"h:%d ns:%d", timesSeen, [timesSeenNSNum intValue]);
		
		selectedCard.timesSeen = timesSeenNSNum;
		selectedCard.timesCorrect = timesCorrectNSNum;

		
		[timesSeenNSNum release];
		[timesCorrectNSNum release];
		/*
		if(selectedCard == nil) {
			NSLog(@"nil");
		}
		NSLog(@"%@", selectedCard.question);
		 */
		
		NSError *error = nil;
		if (![selectedCard.managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		}
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	NSError *error = nil;
	if (![self.selectedCard.managedObjectContext save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
}

/**
 Reload the table if differing deck
 */
- (void)setSelectedDeck:(Deck *)deck {
	if(deck != selectedDeck){
		[selectedDeck release];
		selectedDeck = [deck retain];
		self.fetchedResultsController = nil;
		[self.tableView reloadData];
	}
	//For updating deck stats
	int count = [self.selectedDeck.timesSeen intValue];
	count++;
	self.selectedDeck.timesSeen = [NSNumber numberWithInt: count];
	//end updating deck stats
	self.selectedIndexPath = nil;
	gameLabel.text = @"Choose the game mode";
	/****  Choose Game Mode Alert  ******/
	alert = [[UIAlertView alloc]
			 initWithTitle:@"Choose Game Mode"
			 message:nil
			 delegate:self
			 cancelButtonTitle:nil
			 otherButtonTitles:@"Normal Mode", @"Reverse Mode", nil];
	[alert show];
	[alert release];
	/***** End Alert *****/
	
	//For reloading and refreshing data
	segment.selectedSegmentIndex = 0;
	indexCounter = 0; indexCounterCards = 0;
	[self.data removeAllObjects];
	[self.data autorelease];
	data = [[NSMutableArray alloc] init];
	[self.cardsArray removeAllObjects];
	[self.cardsArray autorelease];
	cardsArray = [[NSMutableArray alloc] init];
	[self.tableView reloadData];
}

/**
 Sections in table is managed by the database.
 In this implementation should always be 1
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.fetchedResultsController.sections.count;
}

/**
 Number of rows in table dependent upon cards in deck
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id info = [self.fetchedResultsController.sections objectAtIndex:section];
	return [info numberOfObjects];
}

/**
 Setup the array values from card
 */
- (void)configureCell:(UITableViewCell *)cell withCard:(NSManagedObject *)model {
	NSString *questionAsk = [model valueForKey:@"question"];
	NSString *answerTell = [model valueForKey:@"answer"];
	NSString *hint = @"";
	FlashFunAppDelegate *appDelegate = (FlashFunAppDelegate *)[[UIApplication sharedApplication] delegate];
	if(appDelegate.hintsEnabled){
		hint = [model valueForKey:@"hint"];
	}else {
		hint = @"Hints disabled! To see hints:- Go to configuration and enable them.";
	}
	[data addObject:questionAsk];
	[data addObject: answerTell];
	[data addObject: hint];
	/*NSLog(@"----------------");
	NSLog([NSString stringWithFormat:@"%d", i]);
	if (i == 0) {
		NSLog([data objectAtIndex:i]);
		NSLog([data objectAtIndex:i+1]);
	}else{
	NSLog([data objectAtIndex:i*3]);
	NSLog([data objectAtIndex:(i*3)+1]);
	NSLog([data objectAtIndex:(i*3)+2]);
	}
	NSLog(@"----------------");*/
	indexCounterCards++;
	i++;
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
	[self configureCell:cell withCard:[self.fetchedResultsController objectAtIndexPath:indexPath]];
	[cardsArray addObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
	return cell;
}

/**
Segement buttons are pressed - It will display the  respective value
 */
- (IBAction) change {
	NSString *equate = @"";
	//NSLog([NSString stringWithFormat:@"%d", indexCounter]);
	//NSLog([NSString stringWithFormat:@"%d", indexCounterCards]);
	if (indexCounterCards == 0 && indexCounter == 0) {
		if (segment.selectedSegmentIndex == 0 || segment.selectedSegmentIndex == 1 || segment.selectedSegmentIndex == 2
		   || segment.selectedSegmentIndex == 3 || segment.selectedSegmentIndex == 4) {
			segment.selectedSegmentIndex = 0;
			[self.data removeAllObjects];
			[self.data autorelease];
			data = [[NSMutableArray alloc] init];
			[self.tableView reloadData];
			gameLabel.text = @"No cards in deck";
		}
	} else if (indexCounter == 0) {
		if (segment.selectedSegmentIndex == 0) { //Previous
			if (reverseMode == YES) {
				equate = [NSString stringWithFormat:@"%@%@", @"Answer: ", [data objectAtIndex:indexCounter+1]];
				gameLabel.text = equate;
			} else {
				equate = [NSString stringWithFormat:@"%@%@", @"Question: ", [data objectAtIndex:indexCounter]];
				gameLabel.text = equate;
			}
		} else if (segment.selectedSegmentIndex == 1) { //Question
			equate = [NSString stringWithFormat:@"%@%@", @"Question: ", [data objectAtIndex:indexCounter]];
			gameLabel.text = equate;
		} else if (segment.selectedSegmentIndex == 2) { //Answer
			equate = [NSString stringWithFormat:@"%@%@", @"Answer: ", [data objectAtIndex:indexCounter+1]];
			gameLabel.text = equate;
		} else if (segment.selectedSegmentIndex ==3) { //Hint
			//gameLabel.text = [data objectAtIndex:indexCounter+2];
			if (reverseMode == YES) {
				gameLabel.text = [self makeHint: [data objectAtIndex: indexCounter]
									   withHint: [data objectAtIndex: indexCounter+2]];
			}
			else {
				gameLabel.text = [self makeHint: [data objectAtIndex: indexCounter+1]
									   withHint: [data objectAtIndex: indexCounter+2]];
			}
		} else if (segment.selectedSegmentIndex == 4) {
			if ((indexCounter+3) < (indexCounterCards*3)) { //Next
				statsCounter = indexCounter;
				[self yesOrNo];
				[self playSound];
				if (reverseMode == YES) {
					equate = [NSString stringWithFormat:@"%@%@", @"Answer: ", [data objectAtIndex:indexCounter+4]];
					gameLabel.text = equate;
				} else {
					equate = [NSString stringWithFormat:@"%@%@", @"Question: ", [data objectAtIndex:indexCounter+3]];
					gameLabel.text = equate;
				}
				indexCounter++;
			}else {
				gameLabel.text = @"Game Over";
			}
		}
	} else if (indexCounter > 0 && indexCounter < indexCounterCards) {
		if (segment.selectedSegmentIndex == 0) { //Previous
			if (reverseMode == YES) {
				equate = [NSString stringWithFormat:@"%@%@", @"Answer: ", [data objectAtIndex:(indexCounter*3)-2]];
				gameLabel.text = equate;				
			} else {
				equate = [NSString stringWithFormat:@"%@%@", @"Question: ", [data objectAtIndex:(indexCounter*3)-3]];
				gameLabel.text = equate;
			}
			indexCounter--;
		} else if (segment.selectedSegmentIndex == 1) { //Question
			equate = [NSString stringWithFormat:@"%@%@", @"Question: ", [data objectAtIndex:(indexCounter*3)]];
			gameLabel.text = equate;
		} else if (segment.selectedSegmentIndex == 2) { //Answer
			equate = [NSString stringWithFormat:@"%@%@", @"Answer: ", [data objectAtIndex:(indexCounter*3)+1]];
			gameLabel.text = equate;
		} else if (segment.selectedSegmentIndex ==3) { //Hint
			//gameLabel.text = [data objectAtIndex:(indexCounter*3)+2];
			if (reverseMode == YES) {
				gameLabel.text = [self makeHint: [data objectAtIndex: (indexCounter*3)]
									   withHint: [data objectAtIndex:(indexCounter*3)+2]];
			}
			else {
				gameLabel.text = [self makeHint: [data objectAtIndex: (indexCounter*3+1)]
									   withHint: [data objectAtIndex:(indexCounter*3)+2]];
			}
		} else if (segment.selectedSegmentIndex ==4) { //Next
			statsCounter = indexCounter;
			[self yesOrNo];
			[self playSound];
			if ((indexCounter+1) == [cardsArray count]) {
				indexCounter = 0;
				if (reverseMode == YES) {
					equate = [NSString stringWithFormat:@"%@%@", @"Answer: ", [data objectAtIndex:indexCounter+1]];
					gameLabel.text = equate;
				} else {
					equate = [NSString stringWithFormat:@"%@%@", @"Question: ", [data objectAtIndex:indexCounter]];
					gameLabel.text = equate;
				}
			} else {
				if (reverseMode == YES) {
					equate = [NSString stringWithFormat:@"%@%@", @"Answer: ", [data objectAtIndex:(indexCounter*3)+4]];
					gameLabel.text = equate;					
				}
				else {
					equate = [NSString stringWithFormat:@"%@%@", @"Question: ", [data objectAtIndex:(indexCounter*3)+3]];
					gameLabel.text = equate;
				}
				indexCounter++;
			}
		}
	}
}

/**
 Take the hint and the answer
 Return correct hint based on whether user hints enabled or not
 */
- (NSString *) makeHint:(NSString *)answer withHint:(NSString *) cardHint {
	// debug
	//NSLog(@"Given answer: %@, Given hint: %@", answer, cardHint);
	
	FlashFunAppDelegate *appDelegate = (FlashFunAppDelegate *)[[UIApplication sharedApplication] delegate];
	// User hints are enabled so use the set card hint
	if(appDelegate.hintsEnabled) {
		return cardHint;
	}
	
	// Otherwise make a hangman style hint from given answer
	NSString *hint = @"";
	for (int k = 0; k < [answer length]; k++) {
		if ([answer characterAtIndex: k] == ' ') {
			hint = [hint stringByAppendingString: @" "];
		}
		else {
			hint = [hint stringByAppendingString: @"_"];
		}
	}
	return hint;
}


/**
 Play a sound of paper rustling
 */
- (void) playSound {
	FlashFunAppDelegate *appDelegate = (FlashFunAppDelegate *)[[UIApplication sharedApplication] delegate];
	if(!appDelegate.soundEnabled) {
		return;
	}
	/* old way to play sound
	 NSString *path = [[NSBundle mainBundle] pathForResource: @"rustle" ofType: @"mp3"];
	 NSURL *url = [NSURL fileURLWithPath: path];
	 AVAudioPlayer *audio = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: NULL];
	 audio.delegate = self;
	 [audio prepareToPlay];
	 [audio play];
	 [audio release];
	 */
	NSString *path = [[NSBundle mainBundle] pathForResource: @"rustle" ofType: @"mp3"];
	NSURL *url = [NSURL fileURLWithPath: path];
	SystemSoundID soundID;
	AudioServicesCreateSystemSoundID((CFURLRef) url, &soundID);
	AudioServicesPlaySystemSound(soundID);
}

/**
 When row is selected, change to a more detailed card view.
 Pass various data needed by further viewcontrollers
 */
- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedIndexPath = indexPath;
	Card *card = [self.fetchedResultsController 
				  objectAtIndexPath:indexPath];
	[cardsArray addObject:card];
	self.cardEditingVC.selectedCard = card;
	self.cardEditingVC.title = card.question;
	[self.navigationController pushViewController:self.cardEditingVC animated:YES];
}

/**
 If we want to add further functionality to the game modes then we can even access single cards property
 throught editing style
 */
- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		Card *card = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[self.selectedDeck removeCardsObject:card];
		NSManagedObjectContext *context = self.selectedDeck.managedObjectContext;
		[context deleteObject:card];
		// Save the context. 
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		}
	}   
}

/**
 Create and return a fetched results controller for working with db
 */
- (NSFetchedResultsController *)fetchedResultsController {
	if (nil == fetchedResultsController) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSManagedObjectContext *context = self.selectedDeck.managedObjectContext;
		NSEntityDescription *entity = 
		[NSEntityDescription entityForName:@"Card"
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
	
	if(NSFetchedResultsChangeUpdate == type) {
		[self configureCell:[self.tableView cellForRowAtIndexPath:indexPath]
				   withCard:anObject];
	} else if(NSFetchedResultsChangeMove == type) {
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
		 withRowAnimation:UITableViewRowAnimationFade];
	} else if(NSFetchedResultsChangeInsert == type) {
		if(!self.firstInsert) {
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
			 withRowAnimation:UITableViewRowAnimationRight];
		} else {
			[self.tableView insertSections:[[NSIndexSet alloc] initWithIndex:0] 
			 withRowAnimation:UITableViewRowAnimationRight];
		}
	} else if(NSFetchedResultsChangeDelete == type) {
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
		 withRowAnimation:UITableViewRowAnimationFade];
	}
}

/**
 Finish updating table
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}

/**
 Query whether user got the card right
 */
-(void) yesOrNo{
	FlashFunAppDelegate *appDelegate = (FlashFunAppDelegate *)[[UIApplication sharedApplication] delegate];
	if(appDelegate.queryEnabled){
		right = [[UIAlertView alloc]
				 initWithTitle:@"Did you get the card right?"
				 message:nil
				 delegate:self
				 cancelButtonTitle:nil
				 otherButtonTitles:@"Yes", @"No", nil];
		[right show];
		[right release];
		
		
	}
}

- (void)dealloc {
	self.selectedDeck = nil;
	self.fetchedResultsController = nil;
	self.selectedIndexPath = nil;
	[self.data removeAllObjects];
	[self.cardsArray removeAllObjects];
	[self.data autorelease];
	[self.cardsArray autorelease];
	[fetchedResultsController release];
	[super dealloc];
}


@end