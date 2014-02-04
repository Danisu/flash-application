//
//  FlashFunAppDelegate.h
//  FlashFun
//
//  Delegate file sets up the core data and is the ultimate owner of core data
//
//
//  Note: Much of this code is credited to Dudney's and Adamson's iPhone SDK Development book
//  Particularly the CoreData stuff
//

#import <UIKit/UIKit.h>

@interface FlashFunAppDelegate : NSObject <UIApplicationDelegate> {
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	NSString *sqliteDB;
    
    UIWindow *window;
    UINavigationController *navigationController;
	
	// various settings for different areas of app
	BOOL queryEnabled;
	BOOL hintsEnabled;
	BOOL soundEnabled;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain) NSString *sqliteDB;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, assign) BOOL queryEnabled;
@property (nonatomic, assign) BOOL hintsEnabled;
@property (nonatomic, assign) BOOL soundEnabled;

- (IBAction) saveAction: sender;

@end

