//
//  ShareSendReceiveController.h
//  FlashFun
//
//  Holds a web view for displaying the result of deck
//  upload
//
//

#import <UIKit/UIKit.h>

@class HelpViewController;

@interface ShareSendReceiveController : UIViewController <UIWebViewDelegate> {
	NSURLRequest *request;
	UIWebView *webView;
	HelpViewController *helpController;
}

@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet HelpViewController *helpController;

@end
