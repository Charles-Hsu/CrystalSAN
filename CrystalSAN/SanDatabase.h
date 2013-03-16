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
@property (nonatomic, strong) FMDatabase *sanDatabase;

- (NSMutableArray *)getVmirrorListByKey:(NSString *)key;
- (void)insertDemoDevices;

- (NSString *)getPasswordBySiteName:(NSString *)siteName siteID:(NSString *)siteID userName:(NSString *)userName;
- (NSDictionary *)getHAClusterDictionaryBySiteName:(NSString *)siteName;
- (NSArray *)getEngineCliVpdBySerial:(NSString *)serial;
- (NSArray *)getEngineCliMirrorBySerial:(NSString *)serial;

- (NSArray *)getEngineCliConmgrInitiatorStatusBySerial:(NSString *)serial;
- (NSArray *)getEngineCliConmgrInitiatorStatusDetailBySerial:(NSString *)serial;

- (NSArray *)getEngineCliConmgrEngineStatusBySerial:(NSString *)serial;

- (NSArray *)getEngineCliConmgrDriveStatusBySerial:(NSString *)serial;
- (NSArray *)getEngineCliConmgrDriveStatusDetailBySerial:(NSString *)serial;

@end
