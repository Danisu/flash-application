//
//  DisplayGameModesController.h
//  FlashFun
//
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NormalGameModeController;

@interface DisplayGameModesController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	NormalGameModeController *displayGAmePage;
}
@property (nonatomic, retain) IBOutlet NormalGameModeController *displayGAmePage;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@end
