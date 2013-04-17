//
//  SanDatabase.h
//  CrystalSAN
//
//  Created by Charles Hsu on 2/2/13.
//  Copyright (c) 2013 Charles Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface SanDatabase : NSObject
@property (nonatomic, strong) FMDatabase *db;

- (NSMutableArray *)getVmirrorListByKey:(NSString *)key;
//- (void)insertDemoDevices;

- (NSString *)getPasswordBySiteName:(NSString *)siteName siteID:(NSString *)siteID userName:(NSString *)userName;
- (NSDictionary *)httpGetHAClusterDictionaryBySiteName:(NSString *)siteName;
- (NSArray *)getEngineCliVpdBySerial:(NSString *)serial;
- (NSArray *)getEngineCliMirrorBySerial:(NSString *)serial;

- (NSArray *)httpGetEngineCliConmgrInitiatorStatusBySerial:(NSString *)serial;
- (NSArray *)httpGetEngineCliConmgrInitiatorStatusDetailBySerial:(NSString *)serial;
- (NSArray *)httpGetEngineCliConmgrEngineStatusBySerial:(NSString *)serial;
- (NSArray *)httpGetEngineCliConmgrDriveStatusBySerial:(NSString *)serial;
- (NSArray *)httpGetEngineCliConmgrDriveStatusDetailBySerial:(NSString *)serial;
         
- (NSArray *)getEnginesByHaApplianceName:(NSString *)haApplianceName;

- (void)insertUpdateHaCluster:(NSDictionary *)dict;
- (void)insertUpdate:(NSString *)table record:(NSDictionary *)dict;

- (void)syncWithServerDb:(NSString *)siteName;

- (NSMutableArray *)getHaApplianceNameListBySiteName:(NSString *)siteName;
- (NSMutableArray *)getHaApplianceNameListBySiteName:(NSString *)siteName andKey:(NSString *)key;
- (NSDictionary *)getVpdBySerial:(NSString *)serial;
- (NSDictionary *)getEngineCliMirrorDictBySerial:(NSString *)serial;

- (NSArray *)getConmgrDriveStatusByEngineSerial:(NSString *)serial;
- (NSDictionary *)getConmgrDriveStatusByEngineSerial:(NSString *)serial
                                           targetNum:(NSInteger)driveID;

- (NSArray *)getInitiatorListByEngineSerial:(NSString *)serial;
- (NSArray *)getDriveListByEngineSerial:(NSString *)serial;
//- (NSArray *)getDriveArrayByEnginesSerial:(NSArray *)serials;
- (NSArray *)getDriveArrayByEnginesSerial:(NSArray *)serials andSearchKey:(NSString *)searchTerm;


- (NSDictionary *)getEngineCliDmepropDictBySerial:(NSString *)serial;

- (NSString *)isMasterEngine:(NSString *)serial;


- (NSString *)getEngineVpdShortString:(NSDictionary *)vpd;
- (NSString *)getEngineMirrorShortString:(NSDictionary *)dict;
- (NSString *)getEngineDriveShortString:(NSDictionary *)dict;
- (NSString *)getEngineDriveShortStringtTitle;
- (NSString *)getCompanyNameByWWPN:(NSString *)wwpn;


@end
