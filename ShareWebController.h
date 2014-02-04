//
//  ShareWebController.h
//  FlashFun
//
//  Share and download decks through the website
//
//

#import <UIKit/UIKit.h>

@class HelpViewController;

@interface ShareWebController : UIViewController <UIWebViewDelegate> {
	UIWebView *webView;
	HelpViewController *helpController;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet HelpViewController *helpController;

@end
