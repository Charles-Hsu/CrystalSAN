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

//- (void)syncEngineWithSerial:(NSString *)serial;
//- (void)syncEngineWithHAApplianceName:(NSString *)haApplianceName;
//- (void)syncEngineWithHAApplianceNameAndAddedtoSyncedArray:(NSString *)haApplianceName;

//- (void)getApplianceAllInformation:(NSString *)serial part:(int)partNo;
//- (void)updateEngineVpdInfo:(NSString *)haApplianceName;
- (void)syncEngineWithHAApplianceNameAndAddedtoSyncedArray:(NSString *)haApplianceName part:(int)partNo;
//- (void)syncHAAppliancesOfSite:(NSString *)siteName;

@end
