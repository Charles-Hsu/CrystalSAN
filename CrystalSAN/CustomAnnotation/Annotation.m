//
//  Annotation.m
//  CustomAnnotation
//
//  Created by akshay on 8/14/12.
//  Copyright (c) 2012 raw engineering, inc. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

@synthesize coordinate;
@synthesize name;
@synthesize subtitle;
@synthesize locationType;



- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate; 
}

- (NSString *)title {
	return name;
}

- (NSString *)subtitle {
    NSLog(@"%@", [NSString stringWithFormat:@"Lat: %f, Long: %f", coordinate.latitude, coordinate.longitude]);
	return [NSString stringWithFormat:@"Lat: %f, Long: %f", coordinate.latitude, coordinate.longitude];
}

@end
