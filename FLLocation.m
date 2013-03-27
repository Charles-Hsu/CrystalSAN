//
//  FLLocation.m
//  HelloMapKitWorld
//
//  Created by Hunter Hillegas on 5/30/11.
//  Copyright (c) 2011 Hunter Hillegas. All rights reserved.
//

#import "FLLocation.h"

@implementation FLLocation

//@dynamic latitude;
//@dynamic longitude;
//@dynamic name;

@synthesize name;
@synthesize latitude, longitude;

#pragma mark Annotation Stuff

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinateOnMap;
	coordinateOnMap.latitude = [self.latitude doubleValue];
	coordinateOnMap.longitude = [self.longitude doubleValue];
	
	return coordinateOnMap;
}

- (id)initWihtName:(NSString *)_name lat:(float)_latitude lon:(float)_longitude {
    self = [super init];
	
    self.name = _name;
    self.latitude = [NSNumber numberWithFloat:_latitude];
    self.longitude = [NSNumber numberWithFloat:_longitude];
    
	return self;
}

- (NSString *)title {
	return self.name;
}

- (NSString *)subtitle {
	return [NSString stringWithFormat:@"Lat: %@, Long: %@", self.latitude, self.longitude];
}

//- (NSString *)description {
//    return [NSString stringWithFormat:@"%@", self.name];
//}

#pragma mark Core Data Stuff

/*
+ (void)batchUpdateOrCreateWithArray:(NSArray *)contents inContext:(NSManagedObjectContext *)context {
    NSError *error;
	
	for (NSDictionary *values in contents) {
		FLLocation *locationItem = [FLLocation locationForName:[values valueForKey:@"name"] inContext:context];
		if (!locationItem) { //we are saying the names must be unique in this app
			locationItem = (FLLocation *)[NSEntityDescription insertNewObjectForEntityForName:@"FLLocation" inManagedObjectContext:context];
		}
		
        locationItem.name = [values valueForKey:@"name"];
		locationItem.latitude = [NSNumber numberWithFloat:[[values valueForKey:@"latitude"] floatValue]];
        locationItem.longitude = [NSNumber numberWithFloat:[[values valueForKey:@"longitude"] floatValue]];
        
        NSLog(@"Location: %@", locationItem);
	}
    
	if (![context save:&error])
		NSLog(@"Save Failed: %@", error);
}

+ (FLLocation *)locationForName:(NSString *)aName inContext:(NSManagedObjectContext *)context {
	NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init]; 
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"FLLocation" inManagedObjectContext:context]; 
	[fetchRequest setEntity:entity]; 
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name = %@", aName]];
	NSArray *existingItems = [context executeFetchRequest:fetchRequest error:&error]; 
    
    return [existingItems lastObject];
}
 */

@end
