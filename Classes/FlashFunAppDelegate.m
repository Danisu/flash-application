//
//  FlashFunAppDelegate.m
//  FlashFun
//
//  Delegate file sets up the core data and is the ultimate owner of core data
//
//  NOTE!: These settings are only saved if you exit the app cleanly, i.e. by
//  clicking the button at the bottom of the simulator. We could save every time
//  but that's not a very good practice for real usage, I think.
//
//
//  Note: Much of this code is credited to Dudney and Adamson's iPhone SDK Development book
//  Particularly the CoreData stuff
//
//  Some of the NSUserDefaults stuff from https://developer.apple.com/iphone/library/samplecode/DrillDownSave/index.html
//

#import "FlashFunAppDelegate.h"
#import "RootViewController.h"

@implementation FlashFunAppDelegate

@synthesize window,
navigationController,
queryEnabled,
hintsEnabled,
soundEnabled,
sqliteDB;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// setup rootview with db context
	RootViewController *rootViewController = (RootViewController *) [navigationController topViewController];
	rootViewController.managedObjectContext = self.managedObjectContext;
	
	// get data from userdefaults
	self.queryEnabled = [[NSUserDefaults standardUserDefaults] boolForKey: @"FFquery"];
	self.hintsEnabled = [[NSUserDefaults standardUserDefaults] boolForKey: @"FFhints"];
	self.soundEnabled = [[NSUserDefaults standardUserDefaults] boolForKey: @"FFsound"];
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}

/**
 Attempt to save any changed data before quitting
 - core data database
 - userdefaults configuration settings
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	// save core data stuff
	NSError *error;
	if (managedObjectContext != nil) {
		if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);
		}
	}
	
	// save userdefaults
	[[NSUserDefaults standardUserDefaults] setBool: self.queryEnabled forKey: @"FFquery"];
	[[NSUserDefaults standardUserDefaults] setBool: self.hintsEnabled forKey: @"FFhints"];
	[[NSUserDefaults standardUserDefaults] setBool: self.soundEnabled forKey: @"FFsound"];
}

/**
 Perform save
 */
- (IBAction) saveAction: (id) sender {
	NSError *error = nil;
	if (![[self managedObjectContext] save: &error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}
}

/**
 Return manageObjectContext. create if needed
 */
- (NSManagedObjectContext *) managedObjectContext {
	if (managedObjectContext != nil) {
		return managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator: coordinator];
	}

	return managedObjectContext;
}

/**
 Return managed object model
 Create from merging all models (?) in app bundle if it doesn't exist
 */
- (NSManagedObjectModel *) managedObjectModel {
	if (managedObjectModel != nil) {
		return managedObjectModel;
	}
	
	managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles: nil] retain];
	return managedObjectModel;
}

/**
 Return persistent store coordinator
 Create if it doesn't exist
 */
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
	if (persistentStoreCoordinator != nil) {
		return persistentStoreCoordinator;
	}
	
	// setup file to save to
	NSURL *storeURL = [NSURL fileURLWithPath:
						[[self applicationDocumentsDirectory]
						 stringByAppendingPathComponent: @"FlashFun.sqlite"]];
	self.sqliteDB = [NSString stringWithFormat: @"%@/%@", [self applicationDocumentsDirectory], @"FlashFun.sqlite"];
	
	NSError *error = nil;
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
								  initWithManagedObjectModel: [self managedObjectModel]];
	if (![persistentStoreCoordinator addPersistentStoreWithType: NSSQLiteStoreType
			configuration: nil
			URL: storeURL
			options: nil
			error: &error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
	
	return persistentStoreCoordinator;
}

/**
 Get path to app's doc directory
 */
- (NSString *) applicationDocumentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask,
														 YES);
	NSString *basePath = nil;
	if ([paths count] > 0) {
		basePath = [paths objectAtIndex: 0];
	}
	return basePath;
}

- (void)dealloc {
	[managedObjectContext release];
	[managedObjectModel release];
	[persistentStoreCoordinator release];
	
	[navigationController release];
	[window release];
	[super dealloc];
}


@end
