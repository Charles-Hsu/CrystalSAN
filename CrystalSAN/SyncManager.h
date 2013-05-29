//
//  SyncManager.h
//  CrystalSAN
//
//  Created by Charles Hsu on 5/13/13.
//  Copyright (c) 2013 Charles Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncManager : NSObject {
}

@property (nonatomic, strong) NSArray *haArray;

- (void)syncEngineWithSerial:(NSString *)serial;
//- (void)syncEngineWithHAApplianceName:(NSString *)haApplianceName;
- (void)syncEngineWithHAApplianceNameAndAddedtoSyncedArray:(NSString *)haApplianceName;


- (void)updateEngineVpdInfo:(NSString *)haApplianceName;
- (void)syncHAAppliancesOfSite:(NSString *)siteName;

@end
