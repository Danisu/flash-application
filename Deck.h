//
//  Deck.h
//  FlashFun
//
//  This is generated from FlashFun.xcdatamodel. It provides the schema
//  of Deck entries for the Core Data database.
//
//

#import <CoreData/CoreData.h>

@class Card;

@interface Deck :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * timesSeen;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* cards;

@end


@interface Deck (CoreDataGeneratedAccessors)
- (void)addCardsObject:(Card *)value;
- (void)removeCardsObject:(Card *)value;
- (void)addCards:(NSSet *)value;
- (void)removeCards:(NSSet *)value;

@end

