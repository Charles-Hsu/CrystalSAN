//
//  SanDatabase.m
//  CrystalSAN
//
//  Created by Charles Hsu on 2/2/13.
//  Copyright (c) 2013 Charles Hsu. All rights reserved.
//

#import "SanDatabase.h"
#import "XMLParser.h"

@interface SanDatabase ()
    - (NSString *)copyServerDbFromResource;
    - (NSArray *)httpGetSanInformation:(NSString *)phpURL bySerial:(NSString *)serial;
    - (NSArray *)getDriveArrayByEnginesSerial:(NSArray *)serials;
@end

@implementation SanDatabase

@synthesize db;


- (id)init
{
    self = [super init];
    if (self) {
    
        // Finding a file in the iPhone sandbox
        // http://stackoverflow.com/questions/5652329/finding-a-file-in-the-iphone-sandbox
    
        NSString *databasePath = [self copyServerDbFromResource];
        NSLog(@"%s %@", __func__, databasePath);
        
        db = [FMDatabase databaseWithPath:databasePath];
        [db executeUpdate:@"PRAGMA auto_vacuum = 2"];
        
        if (![db open])
        {
            NSLog(@"Could not open db.");
            //return nil;
        }
        //return db;
        
    }
    return self;
}

- (void)syncWithServerDb:(NSString *)siteName
{
    NSString *sql = [NSString stringWithFormat:@"select engine01,engine02,engine03,engine04 from ha_cluster where site_name = '%@'", siteName];
    FMResultSet *rs = [db executeQuery:sql];
    while ([rs next]) {
        NSLog(@"%@", [rs stringForColumnIndex:0]);
        NSLog(@"%@", [rs stringForColumnIndex:1]);
        NSLog(@"%@", [rs stringForColumnIndex:2]);
        NSLog(@"%@", [rs stringForColumnIndex:3]);
    }
}

- (void)insertUpdateHaCluster:(NSDictionary *)dict
{
    // CREATE TABLE ha_cluster (
    //      site_name text,
    //      ha_appliance_name text,
    //      engine00 text primary key,
    //      engine01 text,
    //      engine02 text,
    //      engine03 text,
    //      engine04 text);
    
    NSString *primaryKey = [dict valueForKey:@"engine00"];
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM ha_cluster WHERE engine00 = '%@'", primaryKey];
    NSLog(@"%s %@", __func__, sql);
    
    FMResultSet *rs = [db executeQuery:sql];
    
    if ([rs next])
    {
        [db beginTransaction];
        
        NSLog(@"%s intForColumnIndex=%d", __func__,  [rs intForColumnIndex:0]);
        
        if ([rs intForColumnIndex:0] == 0) {
            [db executeUpdate:@"insert into ha_cluster values (?, ?, ?, ?, ?, ?, ?)" ,
                [dict objectForKey:@"site_name"],
                [dict objectForKey:@"ha_appliance_name"],
                [dict objectForKey:@"engine00"],
                [dict objectForKey:@"engine01"],
                [dict objectForKey:@"engine02"],
                [dict objectForKey:@"engine03"],
                [dict objectForKey:@"engine04"]];
        }
        else {
            [db executeUpdate:@"UPDATE ha_cluster SET engine01=?, engine02=?, engine03=?, engine03=?" ,
             [dict objectForKey:@"engine01"],
             [dict objectForKey:@"engine02"],
             [dict objectForKey:@"engine03"],
             [dict objectForKey:@"engine04"]];
        }
        [db commit];
    }
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [rs close];
    
}

- (void)insertUpdate:(NSString *)table record:(NSDictionary *)dict
{
    // for example:
    // CREATE TABLE engine_cli_conmgr_drive_status (
    //      serial TEXT PRIMARY KEY, seconds INTEGER, active INTEGER, inactive INTEGER);
    
    NSString *primaryKey = [dict valueForKey:@"serial"];
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where serial = '%@'", table, primaryKey];
    NSLog(@"%@", sql);
    FMResultSet *rs = [db executeQuery:sql];
    
    
    while ([rs next])
    {
        NSLog(@"table %@ serial %@ count(*) %u", table, primaryKey, [rs intForColumnIndex:0]);
        
        if ([rs intForColumnIndex:0] == 0) {
            
            NSArray *allKeys = [dict allKeys];
            NSArray *allValues = [dict allValues];
            
            NSString *allKeysString = [allKeys objectAtIndex:0];
            NSString *allValuesString = [NSString stringWithFormat:@"'%@'", [allValues objectAtIndex:0]];

            for (int i=1; i < [allKeys count]; i++) {
                //if (i < [allKeys count]-1) {
                    allKeysString = [NSString stringWithFormat:@"%@,", allKeysString];
                    allValuesString = [NSString stringWithFormat:@"%@,", allValuesString];
                //}
                allKeysString = [NSString stringWithFormat:@"%@ %@", allKeysString, [allKeys objectAtIndex:i]];
                allValuesString = [NSString stringWithFormat:@"%@ '%@'", allValuesString, [allValues objectAtIndex:i]];
            }
            
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)", table, allKeysString, allValuesString];
            NSLog(@"%@", sql);
            
            [db beginTransaction];
            BOOL updateSuccessfully = [db executeUpdate:sql];
            if (!updateSuccessfully) {
                NSLog(@"update %@", updateSuccessfully ? @"successfully!" : @"failed");
            }
            [db commit];
        }
        else {
            
        }
    }
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [rs close];
}


- (void)updateUserAuthInfo:(NSString *)siteName user:(NSString *)userName password:(NSString *)password {
    
}

- (BOOL)checkUserAuthInfo:(NSString *)siteName user:(NSString *)userName password:(NSString *)password {
    return TRUE;
}


- (NSString *)getPasswordBySiteName:(NSString *)siteName siteID:(NSString *)siteID userName:(NSString *)userName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/get_account.php?site_name=%@&site_id=%@&user_name=%@", hostname, siteName, siteID, userName];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //NSURL *url = [NSURL URLWithString:@"http://mac-mini.local/sanserver/san_site_name.php"];
    NSError *error = nil;
    NSString *apiResponse = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"--");
    NSLog(@"%@", urlString);
    NSLog(@"nsurl response = %@", apiResponse);
    NSLog(@"--");
    
    return apiResponse;
}

- (NSString *)hostURLPathWithPHP:(NSString *)phpFile {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *hostPath = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"server_ip_hostname"]];
    
    if (![hostPath hasPrefix:@"http://"]) {
        hostPath = [NSString stringWithFormat:@"http://%@", hostPath];
    }
    NSString *urlString = [hostPath stringByAppendingPathComponent:phpFile];
    return urlString;
}

- (void)httpGetHAClusterDictionaryBySiteName:(NSString *)siteName
{
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //[defaults synchronize];
    
    //NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSString *php = @"http-get-ha_cluster.php";
    NSString *urlString = [self hostURLPathWithPHP:php];
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSString *hostPath = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"server_ip_hostname"]];
    //if (![hostPath hasPrefix:@"http://"]) {
    //    hostPath = [NSString stringWithFormat:@"http://%@", hostPath];
    //}
    
    NSString *urlStringWithItems = [urlString stringByAppendingFormat:@"?site=%@", siteName];
    NSURL *url = [NSURL URLWithString:urlStringWithItems];
    
    NSError *error = nil;
    NSString *apiResponse = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"--");
    NSLog(@"%@", urlStringWithItems);
    NSLog(@"nsurl response = %@", apiResponse);
    NSLog(@"nsurl error = %@", error);
    NSLog(@"--");


    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    //Initialize the delegate.
    XMLParser *parser = [[XMLParser alloc] initXMLParser];
    
    //Set delegate
    [xmlParser setDelegate:(id <NSXMLParserDelegate>)parser];
    
    //Start parsing the XML file.
    BOOL success = [xmlParser parse];
    
    NSLog(@"%s %@ parses %@", __func__, php, success ? @"successfully" : @"failed");
        
}



- (void)httpGetEngineCliVpdBySerial:(NSString *)serial siteName:(NSString *)siteName {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT seconds FROM engine_cli_vpd WHERE serial='%@'", serial];
    NSLog(@"%s %@", __func__, sql);
    
    NSString *seconds = nil;
    
    FMResultSet *rs = [db executeQuery:sql];
    while ([rs next])
    {
        seconds = [rs stringForColumnIndex:0];
        NSLog(@"seconds:%@", seconds);
    }
    
    NSString *php = @"http-get-engine_cli_vpd.php";
    NSString *urlString = [self hostURLPathWithPHP:php];
    
    NSString *urlStringWithItems = [urlString stringByAppendingFormat:@"?site=%@&serial=%@", siteName, serial];
    
    if (seconds) {
        urlStringWithItems = [NSString stringWithFormat:@"%@&seconds=%@", urlStringWithItems, seconds];
    }

    NSURL *url = [NSURL URLWithString:urlStringWithItems];
    
    NSError *error = nil;
    NSString *apiResponse = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"--");
    NSLog(@"%@", urlStringWithItems);
    NSLog(@"nsurl response = %@", apiResponse);
    NSLog(@"nsurl error = %@", error);
    NSLog(@"--");
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    //Initialize the delegate.
    XMLParser *parser = [[XMLParser alloc] initXMLParser];
    
    //Set delegate
    [xmlParser setDelegate:(id <NSXMLParserDelegate>)parser];
    
    //Start parsing the XML file.
    BOOL success = [xmlParser parse];
    
    NSLog(@"%s %@ parses %@", __func__, php, success ? @"successfully" : @"failed");
    
}


- (void)httpGetEngineDriveInformation:(NSString *)serial siteName:(NSString *)siteName {
    
    NSInteger seconds = 0;

    if ([serial length] > 0) {
        NSString *sql = [NSString stringWithFormat:@"SELECT seconds FROM engine_cli_conmgr_drive_status WHERE serial='%@'", serial];
        NSLog(@"%s %@", __func__, sql);
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            seconds = [rs intForColumnIndex:0];
        }
    }
    NSLog(@"seconds:%d", seconds);
    
    NSString *php = @"http-get-engine_cli_conmgr_drive_status.php"; // http-get-engine_cli_conmgr_drive_status.php?site=Accusys&serial=11340292
    NSString *urlString = [self hostURLPathWithPHP:php];
    
    NSString *urlStringWithItems = [urlString stringByAppendingFormat:@"?site=%@&serial=%@", siteName, serial];
    
    if (seconds>0) {
        urlStringWithItems = [NSString stringWithFormat:@"%@&seconds=%d", urlStringWithItems, seconds];
    }
    
    NSURL *url = [NSURL URLWithString:urlStringWithItems];
    
    NSError *error = nil;
    NSString *apiResponse = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"--");
    NSLog(@"%@", urlStringWithItems);
    NSLog(@"nsurl response = %@", apiResponse);
    NSLog(@"nsurl error = %@", error);
    NSLog(@"--");
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    //Initialize the delegate.
    XMLParser *parser = [[XMLParser alloc] initXMLParser];
    
    //Set delegate
    [xmlParser setDelegate:(id <NSXMLParserDelegate>)parser];
    
    //Start parsing the XML file.
    BOOL success = [xmlParser parse];
    
    NSLog(@"%s %@ parses %@", __func__, php, success ? @"successfully" : @"failed");

}

- (NSArray *)httpGetSanInformation:(NSString *)phpURL bySerial:(NSString *)serial
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    
    // for example, phpURL = get_engine_cli_vpd_all.php
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/%@?serial=%@", hostname, phpURL, serial];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    //Initialize the delegate.
    XMLParser *parser = [[XMLParser alloc] initXMLParser];
    
    //Set delegate
    [xmlParser setDelegate:(id <NSXMLParserDelegate>)parser];
    
    //Start parsing the XML file.
    BOOL success = [xmlParser parse];
    NSLog(@"%@ parses %@", phpURL, success?@"successfully":@"failed");
    
    return nil;
}

- (NSArray *)getEngineCliVpdBySerial:(NSString *)serial
{
    NSString *phpURL = @"get_engine_cli_vpd_all.php";
    return [self httpGetSanInformation:phpURL bySerial:serial];
}

- (NSArray *)getEngineCliMirrorBySerial:(NSString *)serial
{
    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/get_engine_cli_mirror_all.php?serial=%@", hostname, serial];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    //Initialize the delegate.
    XMLParser *parser = [[XMLParser alloc] initXMLParser];
    
    //Set delegate
    [xmlParser setDelegate:(id <NSXMLParserDelegate>)parser];
    
    //Start parsing the XML file.
    BOOL success = [xmlParser parse];
    NSLog(@"get_engine_cli_mirror_all.php parses %@", success?@"successfully":@"failed");
    
    return nil;
    */
    
    NSString *phpURL = @"get_engine_cli_mirror_all.php";
    return [self httpGetSanInformation:phpURL bySerial:serial];

}

- (NSArray *)httpGetEngineCliConmgrInitiatorStatusBySerial:(NSString *)serial
{
    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/get_engine_cli_conmgr_initiator_status.php?serial=%@", hostname, serial];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    //Initialize the delegate.
    XMLParser *parser = [[XMLParser alloc] initXMLParser];
    
    //Set delegate
    [xmlParser setDelegate:(id <NSXMLParserDelegate>)parser];
    
    //Start parsing the XML file.
    BOOL success = [xmlParser parse];
    NSLog(@"get_engine_cli_conmgr_initiator_status.php parses %@", success?@"successfully":@"failed");
    
    return nil;
    */
    
    NSString *phpURL = @"get_engine_cli_conmgr_initiator_status.php";
    return [self httpGetSanInformation:phpURL bySerial:serial];

}


- (NSArray *)httpGetEngineCliConmgrInitiatorStatusDetailBySerial:(NSString *)serial {
    NSString *phpURL = @"get_engine_cli_conmgr_initiator_status_detail.php";
    return [self httpGetSanInformation:phpURL bySerial:serial];
}

- (NSArray *)httpGetEngineCliConmgrEngineStatusBySerial:(NSString *)serial {
    NSString *phpURL = @"get_engine_cli_conmgr_engine_status.php";
    return [self httpGetSanInformation:phpURL bySerial:serial];
}

-(NSArray *)httpGetEngineCliConmgrDriveStatusBySerial:(NSString *)serial {    
    NSString *phpURL = @"get_engine_cli_conmgr_drive_status.php";
    return [self httpGetSanInformation:phpURL bySerial:serial];

}

-(NSArray *)httpGetEngineCliConmgrDriveStatusDetailBySerial:(NSString *)serial {
    NSString *phpURL = @"get_engine_cli_conmgr_drive_status_detail.php";
    return [self httpGetSanInformation:phpURL bySerial:serial];

}

- (void)syncRemoteServerDatabaseBySiteName:(NSString *)siteName {
    
}


- (void)loadUserPreference {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //DDLogInfo(@"%s", __func__, defaults);
    if ([defaults objectForKey:@"port"] == nil) {
        
        //Get the bundle path
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *settingsPath = [bundlePath stringByAppendingPathComponent:@"Settings.bundle"];
        NSString *plistFile = [settingsPath stringByAppendingPathComponent:@"Root.plist"];
        //DDLogVerbose(@"%@", plistFile);
        
        //Get the Preferences Array from the dictionary
        NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
        NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
        
        //Loop through the array
        NSDictionary *item;
        for(item in preferencesArray)
        {
            //Get the key of the item.
            NSString *keyValue = [item objectForKey:@"Key"];
            
            //Get the default value specified in the plist file.
            id defaultValue = [item objectForKey:@"DefaultValue"];
            
            if (keyValue != nil) {
                //DDLogVerbose(@"[key:%@, value:%@]", keyValue, defaultValue);
                [defaults setObject:defaultValue forKey:keyValue];
            }
        }
    }
    [defaults synchronize];
}


- (NSString *)copyServerDbFromResource
{
    // IOS: copy a file in documents folder
    // http://stackoverflow.com/questions/6545180/ios-copy-a-file-in-documents-folder
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:@"client.db"];
    
    if ([fileManager fileExistsAtPath:txtPath] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"db"];
        [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
    }
    
    // If you want to overwrite every time then try this:
    //if ([fileManager fileExistsAtPath:txtPath] == YES) {
    //    [fileManager removeItemAtPath:txtPath error:&error];
    //}
    
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"db"];
    [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
    
    return txtPath;
}


- (NSMutableArray *)getHaApplianceNameListBySiteName:(NSString *)siteName {
    NSString *sql = [NSString stringWithFormat:@"SELECT ha_appliance_name FROM ha_cluster WHERE site_name = '%@'", siteName];
    NSMutableArray *devices = [[NSMutableArray alloc] init];
    //NSLog(@"%s %@", __func__, sql);
    FMResultSet *rs = [db executeQuery:sql];
    while ([rs next])
    {
        NSString *name = [rs stringForColumnIndex:0];
        //NSLog(@"name:%@", name);
        [devices addObject:name];
    }
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [rs close];
    return devices;
}

- (NSArray *)getEnginesByHaApplianceName:(NSString *)haApplianceName {
    NSString *sql = [NSString stringWithFormat:@"SELECT engine01,engine02 FROM ha_cluster WHERE ha_appliance_name = '%@'", haApplianceName];
    NSMutableArray *devices = [[NSMutableArray alloc] init];
    NSLog(@"%s %@", __func__, sql);
    FMResultSet *rs = [db executeQuery:sql];
    if ([rs next])
    {
        [devices addObject:[rs stringForColumnIndex:0]];
        [devices addObject:[rs stringForColumnIndex:1]];
    }
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [rs close];
    return devices;
}


- (NSString *)isMasterEngine:(NSString *)serial {
    NSDictionary *dict = [self getEngineCliDmepropDictBySerial:serial];
    //NSDictionary *dict = [theDelegate.sanDatabase getEngineCliDmepropDictBySerial:serial];
    
    NSInteger myId = [[dict valueForKey:@"my_id"] intValue];
    BOOL isMaster = NO;
    
    switch (myId) {
        case 1:
            if ([[dict valueForKey:@"cluster_0_is_master"] isEqualToString:@"Yes"]) {
                isMaster = YES;
            }
            break;
        case 2:
            if ([[dict valueForKey:@"cluster_1_is_master"] isEqualToString:@"Yes"]) {
                isMaster = YES;
            }
            break;
        default:
            break;
    }
    return isMaster?@"Master":@"Follower";

}

- (NSDictionary *)getEngineCliDmepropDictBySerial:(NSString *)serial {
    NSLog(@"%s", __func__);
    NSDictionary *dict = [[NSDictionary alloc] init];
    //
    // CREATE TABLE engine_cli_dmeprop (serial TEXT PRIMARY KEY, seconds INTEGER, cluster_0_id, cluster_0_status,  cluster_0_is_master, cluster_1_id, cluster_1_status,  cluster_1_is_master, my_id);
    //
    NSString *tableName = @"engine_cli_dmeprop";
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE serial='%@'", tableName, serial];
    FMResultSet *rs = [db executeQuery:sql];
    NSLog(@"%s %@", __func__, sql);
    if ([rs next])
    {
        dict = [rs resultDictionary];
    }
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [rs close];
    return dict;
}

- (NSDictionary *)getVpdBySerial:(NSString *)serial {
    NSLog(@"%s", __func__);
    NSDictionary *dict = [[NSDictionary alloc] init];
    //
    // CREATE TABLE engine_cli_vpd (serial text primary key, seconds integer, site_name text, engine_name text, product_type text, fw_version text, fw_data text, redboot text, uid text, pcb text, mac text, ip text, uptime text, alert text, time text, a1_wwpn, a2_wwpn, b1_wwpn, b2_wwpn);
    //
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM engine_cli_vpd WHERE serial='%@' ORDER BY seconds LIMIT 1", serial];
    FMResultSet *rs = [db executeQuery:sql];
    //FMResultSet *rs = [db executeQuery:sql];
    //NSString *sql = [NSString stringWithFormat:@"SELECT * FROM ha_cluster WHERE ha_appliance_name = '%@'", haApplianceName];
    //NSMutableArray *devices = [[NSMutableArray alloc] init];
    NSLog(@"%s %@", __func__, sql);
    if ([rs next]) {
        dict = [rs resultDictionary];
        //NSLog(@"%s %@", __func__, dict);
        //[devices addObject:[rs stringForColumnIndex:0]];
        //[devices addObject:[rs stringForColumnIndex:1]];
    }
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [rs close];
    return dict;
}


- (NSDictionary *)getConmgrDriveStatusByEngineSerial:(NSString *)serial
                                           targetNum:(NSInteger)driveID {
    
    //NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDictionary *dict = nil;
    
    NSString *sql = [NSString stringWithFormat:
                     @"SELECT * FROM engine_cli_conmgr_drive_status_detail WHERE serial='%@' AND drive_id='%d'",
                     serial, driveID];
    NSLog(@"%s %@", __func__, sql);
    FMResultSet *rs = [db executeQuery:sql];
    int i=0;
    if ([rs next]) {
        i++;
        dict = [rs resultDictionary];
        NSLog(@"%s %d %@", __func__, i, dict);
        //[array addObject:dict];
    }
    [rs close];
    return dict;

}

- (NSArray *)getConmgrDriveStatusByEngineSerial:(NSString *)serial {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDictionary *dict = nil;
    
    NSString *sql = [NSString stringWithFormat:
                     @"SELECT * FROM engine_cli_conmgr_drive_status_detail WHERE serial='%@'",
                     serial];
    NSLog(@"%s %@", __func__, sql);
    FMResultSet *rs = [db executeQuery:sql];
    while ([rs next])
    {
        dict = [rs resultDictionary];
        [array addObject:dict];
        //NSLog(@"%s %@", __func__, dict);
    }
    [rs close];
    return array;
    
}


- (NSDictionary *)getEngineCliMirrorDictBySerial:(NSString *)serial
{
    NSDictionary *dict = nil;
    //
    // CREATE TABLE engine_cli_vpd (serial text primary key, seconds integer, site_name text, engine_name text, product_type text, fw_version text, fw_data text, redboot text, uid text, pcb text, mac text, ip text, uptime text, alert text, time text, a1_wwpn, a2_wwpn, b1_wwpn, b2_wwpn);
    //
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM engine_cli_mirror WHERE serial='%@' ORDER BY seconds LIMIT 1", serial];
    
    //NSLog(@"%s %@", __func__, sql);
    FMResultSet *rs = [db executeQuery:sql];
    //FMResultSet *rs = [db executeQuery:sql];
    //NSString *sql = [NSString stringWithFormat:@"SELECT * FROM ha_cluster WHERE ha_appliance_name = '%@'", haApplianceName];
    //NSMutableArray *devices = [[NSMutableArray alloc] init];
    //NSLog(@"%s %@", __func__, sql);
    if ([rs next])
    {
        dict = [rs resultDictionary];
        //NSLog(@"%s %@", __func__, dict);
        //[devices addObject:[rs stringForColumnIndex:0]];
        //[devices addObject:[rs stringForColumnIndex:1]];
    }
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [rs close];
    return dict;
}


- (NSArray *)getInitiatorListByEngineSerial:(NSString *)serial
{
    NSMutableArray *initiators = [[NSMutableArray alloc] init];
    //
    // CREATE TABLE engine_cli_vpd (serial text primary key, seconds integer, site_name text, engine_name text, product_type text, fw_version text, fw_data text, redboot text, uid text, pcb text, mac text, ip text, uptime text, alert text, time text, a1_wwpn, a2_wwpn, b1_wwpn, b2_wwpn);
    //
    
    NSString *sql = nil;
    if (serial.length == 0) {
        sql = [NSString stringWithFormat:@"SELECT * FROM engine_cli_conmgr_initiator_status_detail"];
    }
    else {
        sql = [NSString stringWithFormat:@"SELECT * FROM engine_cli_conmgr_initiator_status_detail WHERE serial='%@'", serial];
    }
    
    FMResultSet *rs = [db executeQuery:sql];

    /*
     sqlite> select * from engine_cli_conmgr_initiator_status_detail limit 10;
     serial      seconds     initiator_id  port        wwpn                status
     ----------  ----------  ------------  ----------  ------------------  ----------
     00600118    1359489267  0             A2          1000-0000c9-60b612  I
     00600118    1359489267  1             A1          1000-00062b-16ef20  A
     00600118    1359489267  2             A2          1000-0000c9-6b645c  I
     00600118    1359489267  3             A2          1000-0000c9-62ae81  I
     00600118    1359489267  4             A2          1000-0000c9-7eb686  I
     00600118    1359489267  5             A1          1000-0000c9-7eb697  A
     00600118    1359489267  6             A2          1000-0000c9-7eb690  I
     00600118    1359489267  7             A2          1000-00062b-16d868  A
     00600118    1359489267  8             A2          1000-00062b-16be70  A
     00600118    1359489267  9             A1          1000-0000c9-7eb5c2  A
     
     */
    
    while ([rs next])
    {
        //NSLog(@"%s %@", __func__, [rs resultDictionary]);
        [initiators addObject:[rs resultDictionary]];
    }
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [rs close];
    
    return initiators;
}


- (NSArray *)getDriveListByEngineSerial:(NSString *)serial
{
    NSMutableArray *initiators = [[NSMutableArray alloc] init];
    //
    // CREATE TABLE engine_cli_vpd (serial text primary key, seconds integer, site_name text, engine_name text, product_type text, fw_version text, fw_data text, redboot text, uid text, pcb text, mac text, ip text, uptime text, alert text, time text, a1_wwpn, a2_wwpn, b1_wwpn, b2_wwpn);
    //
    
    NSString *sql = nil;
    if (serial.length == 0) {
        sql = [NSString stringWithFormat:@"select * from engine_cli_conmgr_drive_status_detail"];
    }
    else {
        sql = [NSString stringWithFormat:@"select * from engine_cli_conmgr_drive_status_detail where serial='%@'", serial];
    }
    
    FMResultSet *rs = [db executeQuery:sql];
    
    /*
     select * from engine_cli_conmgr_drive_status_detail where serial='00600118' or serial='00600120' order by drive_id;
     serial      seconds     drive_id    drive_status  path_0_id   path_0_port  path_0_wwpn         path_0_lun  path_0_pstatus  path_1_id   path_1_port  path_1_wwpn  path_1_lun  path_1_pstatus
     ----------  ----------  ----------  ------------  ----------  -----------  ------------------  ----------  --------------  ----------  -----------  -----------  ----------  --------------
     00600118    1363746628  0           A             1           B1           5000-612032-f02000  0000        A
     00600120    1363746628  0           A             1           B1           5000-612032-f02000  0000        A
     00600118    1363746628  1           A             1           B1           5000-612032-f18000  0000        A
     00600120    1363746628  1           A             1           B1           5000-612032-f18000  0000        A
     00600118    1363746628  2           A             1           B2           5000-612032-c0c000  0000        A
     00600120    1363746628  2           A             1           B2           5000-612032-c0c000  0000        A
     00600118    1363746628  3           A             1           B2           5000-612032-ef2010  0000        A
     00600120    1363746628  3           A             1           B2           5000-612032-ef2010  0000        A
     00600118    1363746628  4           A             1           B1           5000-612032-f02010  0000        A
     00600120    1363746628  4           A             1           B1           5000-612032-f02010  0000        A
     00600118    1363746628  5           A             1           B1           5000-612032-f18010  0000        A
     00600120    1363746628  5           A             1           B1           5000-612032-f18010  0000        A
     00600118    1363746628  6           A             1           B2           5000-612032-c0c010  0000        A
     00600120    1363746628  6           A             1           B2           5000-612032-c0c010  0000        A
     00600118    1363746628  7           A             1           B2           5000-612032-ef2000  0000        A
     00600120    1363746628  7           A             1           B2           5000-612032-ef2000  0000        A
     */
    
    while ([rs next])
    {
        [initiators addObject:[rs resultDictionary]];
    }
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [rs close];
    return initiators;
}


- (NSMutableArray *)getHaApplianceNameListBySiteName:(NSString *)siteName andKey:(NSString *)key
{
    NSString *sql = [NSString stringWithFormat:@"SELECT ha_appliance_name FROM ha_cluster WHERE site_name = '%@' AND ha_appliance_name LIKE '%%%@%%'", siteName, key];
    NSMutableArray *devices = [[NSMutableArray alloc] init];
    NSLog(@"%s %@", __func__, sql);
    FMResultSet *rs = [db executeQuery:sql];
    while ([rs next])
    {
        NSString *name = [rs stringForColumnIndex:0];
        NSLog(@"name:%@", name);
        [devices addObject:name];
    }
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [rs close];
    return devices;
}


- (NSMutableArray *)getVmirrorListByKey:(NSString *)key
{
    NSString *sql = [NSString stringWithFormat:@"SELECT name FROM ha_appliance_device_list WHERE name LIKE '%%%@%%'", key];
    NSMutableArray *devices = [[NSMutableArray alloc] init];
    FMResultSet *rs = [db executeQuery:sql];
    while ([rs next])
    {
        NSString *name = [rs stringForColumn:@"name"];
        NSLog(@"name:%@", name);
        [devices addObject:name];
    }
    
    [devices addObject:@""];
    [devices addObject:@""];
    [devices addObject:@""];
    [devices addObject:@""];
    [devices addObject:@""];
    [devices addObject:@""];
    [devices addObject:@""];
    [devices addObject:@""];
    [devices addObject:@""];
    [devices addObject:@""];
    [devices addObject:@""];
    [devices addObject:@""];
    [devices addObject:@""];
    [devices addObject:@""];
    
    
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [rs close];
    return devices;
}


- (NSString *)getEngineVpdShortString:(NSDictionary *)vpd {
    //NSDictionary *vpd = [theDelegate.sanDatabase getVpdBySerial:serial];
    
    /*
     "a1_wwpn" = "2100-006022-0928f2";
     "a2_wwpn" = "2200-006022-0928f2";
     alert = None;
     "b1_wwpn" = "2300-006022-0928f2";
     "b2_wwpn" = "2400-006022-0928f2";
     "engine_name" = "engine_212";
     "fw_data" = "Sep 17 2012 16:56:07";
     "fw_version" = "15.1.10";
     ip = "10.100.5.212";
     mac = "0.60.22.9.28.F2";
     pcb = 00600306;
     "product_type" = FCE4400;
     redboot = "0.2.0.6";
     seconds = 1363746626;
     serial = 00600306;
     "site_name" = "";
     time = "Wednesday 3/20/2013 11:29:11";
     uid = "00000060-220928F2";
     uptime = "164d 04:02:40";
     */
    
    //NSString *uid = [vpd valueForKey:@"uid"];
    NSString *productType = [vpd valueForKey:@"product_type"];
    NSString *pcb = [vpd valueForKey:@"pcb"];
    NSString *mac = [vpd valueForKey:@"mac"];
    NSString *ip = [vpd valueForKey:@"ip"];
    NSString *uptime = [vpd valueForKey:@"uptime"];
    NSString *alert = [vpd valueForKey:@"alert"];
    NSString *time = [vpd valueForKey:@"time"];
    NSString *a1_wwnn = [vpd valueForKey:@"a1_wwnn"];
    NSString *a1_wwpn = [vpd valueForKey:@"a1_wwpn"];
    NSString *a2_wwnn = [vpd valueForKey:@"a2_wwnn"];
    NSString *a2_wwpn = [vpd valueForKey:@"a2_wwpn"];
    NSString *b1_wwnn = [vpd valueForKey:@"b1_wwnn"];
    NSString *b1_wwpn = [vpd valueForKey:@"b1_wwpn"];
    NSString *b2_wwnn = [vpd valueForKey:@"b2_wwnn"];
    NSString *b2_wwpn = [vpd valueForKey:@"b2_wwpn"];
    
    //
    // http://stackoverflow.com/questions/7633664/declare-a-nsstring-in-multiple-lines
    // Declare a NSString in multiple lines
    //
    
    if ([productType isEqualToString:@"FCE4400"]) {
        NSString *vpdString = [NSString stringWithFormat:
                               @"PCB Number         : %@\n"
                               "MAC address        : %@\n"
                               "IP address         : %@\n"
                               "Uptime             : %@\n"
                               "Alert: %@\n"
                               "%@\n"
                               "Port  Node Name           Port Name\n"
                               "A1    %@  %@\n"
                               "A2    %@  %@\n"
                               "B1    %@  %@\n"
                               "B2    %@  %@\n",
                               pcb,
                               mac,
                               ip,
                               uptime,
                               alert,
                               time,
                               a1_wwnn,
                               a1_wwpn,
                               a2_wwnn,
                               a2_wwpn,
                               b1_wwnn,
                               b1_wwpn,
                               b2_wwnn,
                               b2_wwpn                     ];
        
        return vpdString;
        
    } else if ([productType isEqualToString:@"FC"]) {
        NSString *vpdString = [NSString stringWithFormat:
                               @"PCB Number         : %@\n"
                               "MAC address        : %@\n"
                               "IP address         : %@\n"
                               "Uptime             : %@\n"
                               "Alert: %@\n"
                               "Port  Node Name           Port Name\n"
                               "A    %@  %@\n"
                               "B    %@  %@\n",
                               pcb,
                               mac,
                               ip,
                               uptime,
                               alert,
                               a1_wwnn,
                               a1_wwpn,
                               b1_wwnn,
                               b1_wwpn  ];
        
        return vpdString;
        
    }
    
    return nil;
}


- (NSString *)getEngineMirrorShortString:(NSDictionary *)dict {
    
    //Mirror(hex)    state       Map         Capacity  Members
    //33537(0x8301) Operational   0      13672091475  0 (OK )  2 (OK )
    
    //NSDictionary *dict = [theDelegate.sanDatabase getEngineCliMirrorDictBySerial:theDelegate.currentEngineLeftSerial];
    
    NSString *mirror_0_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_id"]];
    NSString *mirror_0_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_sts"]];
    NSString *mirror_0_map = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_map"]];
    NSString *mirror_0_capacity = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_capacity"]];
    NSString *mirror_0_member_0_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_member_0_id"]];
    NSString *mirror_0_member_0_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_member_0_sts"]];
    NSString *mirror_0_member_1_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_member_1_id"]];
    NSString *mirror_0_member_1_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_member_1_sts"]];
    
    NSString *mirror_1_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_1_id"]];
    NSString *mirror_1_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_1_sts"]];
    NSString *mirror_1_map = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_1_map"]];
    NSString *mirror_1_capacity = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_1_capacity"]];
    NSString *mirror_1_member_0_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_1_member_0_id"]];
    NSString *mirror_1_member_0_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_1_member_0_sts"]];
    NSString *mirror_1_member_1_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_1_member_1_id"]];
    NSString *mirror_1_member_1_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_1_member_1_sts"]];
    
    NSString *mirror_2_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_2_id"]];
    NSString *mirror_2_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_2_sts"]];
    NSString *mirror_2_map = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_2_map"]];
    NSString *mirror_2_capacity = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_2_capacity"]];
    NSString *mirror_2_member_0_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_2_member_0_id"]];
    NSString *mirror_2_member_0_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_2_member_0_sts"]];
    NSString *mirror_2_member_1_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_2_member_1_id"]];
    NSString *mirror_2_member_1_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_2_member_1_sts"]];
    
    NSString *mirror_3_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_3_id"]];
    NSString *mirror_3_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_3_sts"]];
    NSString *mirror_3_map = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_3_map"]];
    NSString *mirror_3_capacity = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_3_capacity"]];
    NSString *mirror_3_member_0_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_3_member_0_id"]];
    NSString *mirror_3_member_0_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_3_member_0_sts"]];
    NSString *mirror_3_member_1_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_3_member_1_id"]];
    NSString *mirror_3_member_1_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_3_member_1_sts"]];
    
    /*
     NSString *mirror_4_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_4_id"]];
     NSString *mirror_4_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_4_sts"]];
     NSString *mirror_4_map = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_4_map"]];
     NSString *mirror_4_capacity = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_4_capacity"]];
     NSString *mirror_4_member_0_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_4_member_0_id"]];
     NSString *mirror_4_member_0_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_4_member_0_sts"]];
     NSString *mirror_4_member_1_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_4_member_1_id"]];
     NSString *mirror_4_member_1_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_4_member_1_sts"]];
     
     NSString *mirror_5_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_5_id"]];
     NSString *mirror_5_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_5_sts"]];
     NSString *mirror_5_map = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_5_map"]];
     NSString *mirror_5_capacity = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_5_capacity"]];
     NSString *mirror_5_member_0_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_5_member_0_id"]];
     NSString *mirror_5_member_0_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_5_member_0_sts"]];
     NSString *mirror_5_member_1_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_5_member_1_id"]];
     NSString *mirror_5_member_1_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_5_member_1_sts"]];
     */
    
    //NSString *mirrorStr = [NSString str]
    
    NSString *mirror = [NSString stringWithFormat:
                        @""
                        "Mirror state Map Capacity     Members\n"
                        "%-6s %-5s %-3s %-12s %-2s %-5s %-2s %-5s\n"
                        "%-6s %-5s %-3s %-12s %-2s %-5s %-2s %-5s\n"
                        "%-6s %-5s %-3s %-12s %-2s %-5s %-2s %-5s\n"
                        "%-6s %-5s %-3s %-12s %-2s %-5s %-2s %-5s\n",
                        /*
                         "%-6s %-5s %-3s %-12s %-2s %-5s %-2s %-5s\n"
                         "%-6s %-5s %-3s %-12s %-2s %-5s %-2s %-5s",*/
                        
                        //NSString *mirror = [NSString stringWithFormat:
                        //                    @"Mirror\tstate\tMap\tCapacity\t\tMembers \n"
                        //                     "%s  %s  %s  %s  %s %s  %s %s",
                        
                        [mirror_0_id UTF8String],
                        [mirror_0_sts UTF8String],
                        [mirror_0_map UTF8String],
                        [mirror_0_capacity UTF8String],
                        [mirror_0_member_0_id UTF8String],
                        [mirror_0_member_0_sts UTF8String],
                        [mirror_0_member_1_id UTF8String],
                        [mirror_0_member_1_sts UTF8String] ,
                        
                        [mirror_1_id UTF8String],
                        [mirror_1_sts UTF8String],
                        [mirror_1_map UTF8String],
                        [mirror_1_capacity UTF8String],
                        [mirror_1_member_0_id UTF8String],
                        [mirror_1_member_0_sts UTF8String],
                        [mirror_1_member_1_id UTF8String],
                        [mirror_1_member_1_sts UTF8String],
                        
                        [mirror_2_id UTF8String],
                        [mirror_2_sts UTF8String],
                        [mirror_2_map UTF8String],
                        [mirror_2_capacity UTF8String],
                        [mirror_2_member_0_id UTF8String],
                        [mirror_2_member_0_sts UTF8String],
                        [mirror_2_member_1_id UTF8String],
                        [mirror_2_member_1_sts UTF8String],
                        
                        [mirror_3_id UTF8String],
                        [mirror_3_sts UTF8String],
                        [mirror_3_map UTF8String],
                        [mirror_3_capacity UTF8String],
                        [mirror_3_member_0_id UTF8String],
                        [mirror_3_member_0_sts UTF8String],
                        [mirror_3_member_1_id UTF8String],
                        [mirror_3_member_1_sts UTF8String]  /*,
                                                             
                                                             [mirror_4_id UTF8String],
                                                             [mirror_4_sts UTF8String],
                                                             [mirror_4_map UTF8String],
                                                             [mirror_4_capacity UTF8String],
                                                             [mirror_4_member_0_id UTF8String],
                                                             [mirror_4_member_0_sts UTF8String],
                                                             [mirror_4_member_1_id UTF8String],
                                                             [mirror_4_member_1_sts UTF8String],
                                                             
                                                             [mirror_5_id UTF8String],
                                                             [mirror_5_sts UTF8String],
                                                             [mirror_5_map UTF8String],
                                                             [mirror_5_capacity UTF8String],
                                                             [mirror_5_member_0_id UTF8String],
                                                             [mirror_5_member_0_sts UTF8String],
                                                             [mirror_5_member_1_id UTF8String],
                                                             [mirror_5_member_1_sts UTF8String]*/
                        ];
    
    NSLog(@"%@", mirror);
    
    return mirror;
    
}

- (NSString *)getEngineDriveShortStringtTitle {
    return [NSString stringWithFormat:@"Target status port Storage WWPN       LUN  status"];
}

- (NSString *)getEngineDriveShortString:(NSDictionary *)dict {
    //"Serial    Target status port Storage WWPN       LUN  status\n"
    NSString *info = [NSString stringWithFormat:@""
                      "%-6d %-6s %-4s %-18s %-4s %-s",
                      [[dict objectForKey:@"drive_id"] intValue],
                      [[dict objectForKey:@"drive_status"] UTF8String],
                      [[dict objectForKey:@"path_0_port"] UTF8String],
                      [[dict objectForKey:@"path_0_wwpn"] UTF8String],
                      [[dict objectForKey:@"path_0_lun"] UTF8String],
                      [[dict objectForKey:@"path_0_pstatus"] UTF8String]
                      ];
    return info;
}

- (NSString *)getCompanyNameByWWPN:(NSString *)wwpn {
    NSString *sql = [NSString stringWithFormat:@"SELECT company_name,oui FROM wwpn_data WHERE wwpn = '%@'", wwpn];
    FMResultSet *rs = [db executeQuery:sql];
    NSString *companyName = @"";
    //NSString *oui = @"";
    if ([rs next])
    {
        companyName = [rs stringForColumnIndex:0];
        if ([companyName length] == 0) {
            companyName = [rs stringForColumnIndex:1];
        }
    }
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [rs close];
    return companyName;
}

- (NSArray *)getDriveArrayByEnginesSerial:(NSArray *)serials {
    NSMutableArray *drivers = [[NSMutableArray alloc] init];
    for (int i=0; i<[serials count]; i++) {
        NSString *serial = [serials objectAtIndex:i];
        //if ([serial length] != 0) {
            NSString *whereClause = ([serial length]==0 ? @"" : [NSString stringWithFormat:@"WHERE serial='%@'", serial]);
            //NSString *sql = [NSString stringWithFormat:@"SELECT serial, drive_id,drive_status,path_0_id,path_0_port,path_0_wwpn,path_0_lun,path_0_pstatus FROM engine_cli_conmgr_drive_status_detail %@", whereClause];
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM engine_cli_conmgr_drive_status_detail %@", whereClause];
            NSLog(@"%s %@", __func__, sql);
            FMResultSet *rs = [db executeQuery:sql];
            
            /*
             select * from engine_cli_conmgr_drive_status_detail where serial='00600118' or serial='00600120' order by drive_id;
             serial      seconds     drive_id    drive_status  path_0_id   path_0_port  path_0_wwpn         path_0_lun  path_0_pstatus  path_1_id   path_1_port  path_1_wwpn  path_1_lun  path_1_pstatus
             ----------  ----------  ----------  ------------  ----------  -----------  ------------------  ----------  --------------  ----------  -----------  -----------  ----------  --------------
             00600118    1363746628  0           A             1           B1           5000-612032-f02000  0000        A
             00600120    1363746628  0           A             1           B1           5000-612032-f02000  0000        A
             00600118    1363746628  1           A             1           B1           5000-612032-f18000  0000        A
             */
        
        /*
        select * from engine_cli_conmgr_drive_status_detail;
        serial      seconds     id          status      path_0_id   path_0_port  path_0_wwpn         path_0_lun  path_0_pstatus  path_1_id   path_1_port  path_1_wwpn  path_1_lun  path_1_pstatus
        ----------  ----------  ----------  ----------  ----------  -----------  ------------------  ----------  --------------  ----------  -----------  -----------  ----------  --------------
        11340292    1367391044  0           A           1           B2           5006-022ad0-485000  0000        A
        11340292    1367391044  1           A           1           B2           5006-022ad0-485000  0001        A
         */
            
            while ([rs next])
            {
                [drivers addObject:[rs resultDictionary]];
            }
            [rs close];
        //}
    }
    return drivers;
}

- (NSArray *)getDriveArrayByEnginesSerial:(NSArray *)serials andSearchKey:(NSString *)searchTerm {
    NSArray *drivers = [self getDriveArrayByEnginesSerial:serials];
    
    NSLog(@"%s %@ searchTerm=%@", __func__, serials, searchTerm);
    
    if ([searchTerm length] != 0) {
        NSMutableArray *matched = [[NSMutableArray alloc] init];
        NSInteger count = 0;
        for (int i=0; i<[drivers count]; i++) {
            NSString *serial = [[drivers objectAtIndex:i] valueForKey:@"serial"];
            NSRange range = [serial rangeOfString:searchTerm];
            if (range.location != NSNotFound && range.length == [searchTerm length]) {
                //NSLog(@"%s %@ %@ location:%d length:%d, count=%u", __func__, serial, searchTerm, range.location, range.length, count+1);
                count++;
                [matched addObject:[drivers objectAtIndex:i]];
            }
            
            
            
            //if (serial && [serial caseInsensitiveCompare:searchTerm] == NSOrderedSame) {
            //    NSLog(@"NSOrderedSame %s %@ %@", __func__, serial, searchTerm);
            //}
        }
        return matched;
    }
    return drivers;
}

@end
