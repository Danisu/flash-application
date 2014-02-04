//
//  Card.h
//  FlashFun
//
//  This is generated from FlashFun.xcdatamodel. It provides the schema
//  of Card entries for the Core Data database.
//

#import <CoreData/CoreData.h>

@class Deck;

@interface Card :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSNumber * timesSeen;
@property (nonatomic, retain) NSString * hint;
@property (nonatomic, retain) NSNumber * timesCorrect;
@property (nonatomic, retain) Deck * deck;

@end



