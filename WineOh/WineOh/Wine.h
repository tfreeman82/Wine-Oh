//
//  Wine.h
//
//  Created by Tristan Freeman on 8/28/15.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Wine : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSNumber * volume;
@property (nonatomic, retain) NSString * retailer;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * rating;

@end
