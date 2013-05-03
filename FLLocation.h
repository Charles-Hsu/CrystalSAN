//
//  FLLocation.h
//  HelloMapKitWorld
//
//  Created by Hunter Hillegas on 5/30/11.
//  Copyright (c) 2011 Hunter Hillegas. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
//#import <CoreData/CoreData.h>

//@interface FLLocation : NSManagedObject <MKAnnotation> {
@interface FLLocation : NSObject <MKAnnotation> {
@private
}

@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSNumber * longitude;
@property (nonatomic, strong) NSString * name;

@property (nonatomic, assign) NSString *locationType;



- (id)initWihtName:(NSString *)_name lat:(float)_latitude lon:(float)_longitude;

//+ (void)batchUpdateOrCreateWithArray:(NSArray *)contents inContext:(NSManagedObjectContext *)context;

//+ (FLLocation *)locationForName:(NSString *)aName inContext:(NSManagedObjectContext *)context;

@end
