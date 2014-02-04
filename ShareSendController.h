//
//  ShareSendController.h
//  FlashFun
//
//  Allow user to upload decks to website
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>

@class HelpViewController;
@class ShareSendReceiveController;
@class Deck;

@interface ShareSendController : UIViewController <UITextFieldDelegate, NSFetchedResultsControllerDelegate> {
	UITextField *usernameField;
	UITextField *passwordField;
	UISwitch *privateSwitch;
	
	Deck *selectedDeck;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	HelpViewController *helpController;
	ShareSendReceiveController *receiveController;
}

@property(nonatomic, retain) Deck *selectedDeck;
@property(nonatomic, retain) IBOutlet UISwitch *privateSwitch;
@property(nonatomic, retain) IBOutlet UITextField *usernameField;
@property(nonatomic, retain) IBOutlet UITextField *passwordField;

@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) IBOutlet HelpViewController *helpController;
@property(nonatomic, retain) IBOutlet ShareSendReceiveController *receiveController;

- (IBAction) submit;

- (NSString *) cardsData;
- (void) postField: (NSMutableData *) postBody
			 field: (NSString *) field
		   content: (NSString *) content
		  boundary: (NSString *) boundary;
- (int) numCards;

@end
