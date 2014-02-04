//
//  HelpViewController.h
//  FlashFun
//
//  Template help file. Actual contents are updated by calling controller
//
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController {
	UITextView *textView;
	NSString *descText;
}

- (IBAction) returnToRoot;

@property(nonatomic, retain) IBOutlet UITextView *textView;
@property(nonatomic, retain) NSString *descText;

@end
