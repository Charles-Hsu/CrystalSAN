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
- (NSArray *)getEngineCliVpdBySerial:(NSString *)serial;
- (NSArray *)getEngineCliMirrorBySerial:(NSString *)serial;


// new methods
- (void)httpGetHAClusterDictionaryBySiteName:(NSString *)siteName;

- (void)httpGetEngineCliVpdBySiteName:(NSString *)siteName serial:(NSString *)serial;

- (void)httpGetEngineDriveInformationBySiteName:(NSString *)siteName serial:(NSString *)serial;
- (void)httpGetEngineCliEngineStatusBySiteName:(NSString *)siteName serial:(NSString *)serial;
- (void)httpGetEngineCliMirrorBySiteName:(NSString *)siteName serial:(NSString *)serial;
- (void)httpGetEngineCliDmepropBySiteName:(NSString *)siteName serial:(NSString *)serial;
- (void)httpGetEngineInitiatorInformationBySiteName:(NSString *)siteName serial:(NSString *)serial;
- (void)httpGetWwpnDataBySiteName:(NSString *)siteName;
- (void)httpGetSiteInfoByAppSiteName:(NSString *)siteName appUserName:(NSString *)userName appPassword:(NSString *)password;
- (NSArray *)getSiteInfoArray;



// old methods
- (NSArray *)httpGetEngineCliConmgrInitiatorStatusBySerial:(NSString *)serial;
- (NSArray *)httpGetEngineCliConmgrInitiatorStatusDetailBySerial:(NSString *)serial;
- (NSArray *)httpGetEngineCliConmgrEngineStatusBySerial:(NSString *)serial;
- (NSArray *)httpGetEngineCliConmgrDriveStatusBySerial:(NSString *)serial;
- (NSArray *)httpGetEngineCliConmgrDriveStatusDetailBySerial:(NSString *)serial;
         
- (NSArray *)getEnginesByHaApplianceName:(NSString *)haApplianceName;

- (void)insertUpdateHaCluster:(NSDictionary *)dict;
- (void)insertUpdate:(NSString *)table record:(NSDictionary *)dict;
- (void)insertCache:(NSString *)table record:(NSDictionary *)dict;

- (void)syncWithServerDb:(NSString *)siteName;

- (NSMutableArray *)getHaApplianceNameListBySiteName:(NSString *)siteName;
- (NSMutableArray *)getHaApplianceNameListBySiteName:(NSString *)siteName andKey:(NSString *)key;
- (NSDictionary *)getVpdBySerial:(NSString *)serial;
- (NSDictionary *)getEngineCliMirrorDictBySerial:(NSString *)serial;

- (NSArray *)getConmgrDriveStatusByEngineSerial:(NSString *)serial;
- (NSDictionary *)getConmgrDriveStatusByEngineSerial:(NSString *)serial
                                           targetNum:(NSInteger)driveID;
- (NSString *)getConmgrDriveStatusStringByEngineSerial:(NSString *)serial;

- (NSArray *)getInitiatorListByEngineSerial:(NSString *)serial;
- (NSArray *)getDriveListByEngineSerial:(NSString *)serial;
//- (NSArray *)getDriveArrayByEnginesSerial:(NSArray *)serials;
- (NSArray *)getDriveArrayByEnginesSerial:(NSArray *)serials andSearchKey:(NSString *)searchTerm;


- (NSDictionary *)getEngineCliDmepropDictBySerial:(NSString *)serial;

- (NSString *)isMasterEngine:(NSString *)serial;



- (NSString *)getEngineVpdShortString:(NSDictionary *)vpd;
- (NSString *)getEngineVpdString:(NSString *)serial isShort:(BOOL)isShort;


- (NSString *)getEngineMirrorShortString:(NSDictionary *)dict;
- (NSString *)getEngineDriveShortString:(NSDictionary *)dict;
//- (NSString *)getEngineDriveShortStringtTitle;
- (NSString *)getCompanyNameByWWPN:(NSString *)wwpn;

- (void)updateUserAuthInfo:(NSString *)siteName user:(NSString *)userName password:(NSString *)password;
- (BOOL)checkUserAuthInfo:(NSString *)siteName user:(NSString *)userName password:(NSString *)password;

- (NSString *)hostURLPathWithPHP:(NSString *)php;

- (void)loadUserPreference;

@end
