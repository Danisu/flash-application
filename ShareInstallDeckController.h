//
//  ShareInstallDeckController.h
//  FlashFun
//
//  Download and install the given deck id from website
//
//

#import <UIKit/UIKit.h>

@class HelpViewController;

@interface ShareInstallDeckController : UIViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	NSMutableData *data;
	NSString *deckID;
	NSString *deckName;
	NSString *deckDesc;
	NSArray *cardsData;
	
	UILabel *downloadLabel;
	UILabel *installLabel;
	
	HelpViewController *helpController;
	
	// keep track of whether we are coming out of help - to avoid double downloads
	BOOL helpReturn;
}

@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSMutableData *data;
@property(nonatomic, retain) NSString *deckID;
@property(nonatomic, retain) NSString *deckName;
@property(nonatomic, retain) NSString *deckDesc;
@property(nonatomic, retain) NSArray *cardsData;
@property(nonatomic, retain) IBOutlet UILabel *downloadLabel;
@property(nonatomic, retain) IBOutlet UILabel *installLabel;
@property(nonatomic, retain) IBOutlet HelpViewController *helpController;
@property(nonatomic, assign) BOOL helpReturn;

- (void) installDeck: (NSArray *) deckData;
- (void) getCards;

@end
