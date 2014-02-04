//
//  RootViewController.h
//  FlashFun
//
//  Provide a welcome screen to display app name and team name
//
//

#import <UIKit/UIKit.h>

@class MenuViewController;

@interface RootViewController : UIViewController {
	NSManagedObjectContext *managedObjectContext;
	UITextView *textView;
	MenuViewController *menuViewController;
}

- (IBAction) continue;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet MenuViewController *menuViewController;
@property (nonatomic, retain) IBOutlet UITextView *textView;

@end
