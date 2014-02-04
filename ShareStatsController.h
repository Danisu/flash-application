//
//  ShareStatsController.h
//  FlashFun
//
//  Access website statistics
//
//

#import <UIKit/UIKit.h>

@class HelpViewController;

@interface ShareStatsController : UIViewController <UIWebViewDelegate> {
	UIWebView *webView;
	HelpViewController *helpController;
}

@property(nonatomic, retain) IBOutlet UIWebView *webView;
@property(nonatomic, retain) IBOutlet HelpViewController *helpController;

@end
