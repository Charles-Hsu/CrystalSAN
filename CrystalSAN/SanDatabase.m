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
    - (NSArray *)getSanInformation:(NSString *)phpURL bySerial:(NSString *)serial;
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
    
    NSString *primaryKey = [dict valueForKey:@"site_name"];
    FMResultSet *rs = [db executeQuery:@"select count(*) from ha_cluster where site_name = '?'", primaryKey];
    
    while ([rs next])
    {
        if ([rs intForColumnIndex:0] == 0) {
            [db beginTransaction];
            [db executeUpdate:@"insert into ha_cluster values (?, ?, ?, ?, ?, ?, ?)" ,
                [dict objectForKey:@"site_name" ],
                [dict objectForKey:@"ha_appliance_name" ],
                [dict objectForKey:@"engine00" ],
                [dict objectForKey:@"engine01" ],
                [dict objectForKey:@"engine02" ],
                [dict objectForKey:@"engine03" ],
                [dict objectForKey:@"engine04" ]];
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

- (NSDictionary *)getHAClusterDictionaryBySiteName:(NSString *)siteName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/CrystalSANServer/get_ha_cluster_all.php?site_name=%@", hostname, siteName]];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    //Initialize the delegate.
    XMLParser *parser = [[XMLParser alloc] initXMLParser];
    
    //Set delegate
    [xmlParser setDelegate:(id <NSXMLParserDelegate>)parser];
    
    //Start parsing the XML file.
    BOOL success = [xmlParser parse];
    NSLog(@"get_ha_cluster_all.php parses %@", success?@"successfully":@"failed");
        
    return nil;
}

- (NSArray *)getSanInformation:(NSString *)phpURL bySerial:(NSString *)serial
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
    return [self getSanInformation:phpURL bySerial:serial];
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
    return [self getSanInformation:phpURL bySerial:serial];

}

- (NSArray *)getEngineCliConmgrInitiatorStatusBySerial:(NSString *)serial
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
    return [self getSanInformation:phpURL bySerial:serial];

}


- (NSArray *)getEngineCliConmgrInitiatorStatusDetailBySerial:(NSString *)serial
{
    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/get_engine_cli_conmgr_initiator_status_detail.php?serial=%@", hostname, serial];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    //Initialize the delegate.
    XMLParser *parser = [[XMLParser alloc] initXMLParser];
    
    //Set delegate
    [xmlParser setDelegate:(id <NSXMLParserDelegate>)parser];
    
    //Start parsing the XML file.
    BOOL success = [xmlParser parse];
    NSLog(@"get_engine_cli_conmgr_initiator_status_detail.php parses %@", success?@"successfully":@"failed");
    
    return nil;
    */
    
    NSString *phpURL = @"get_engine_cli_conmgr_initiator_status_detail.php";
    return [self getSanInformation:phpURL bySerial:serial];

}

- (NSArray *)getEngineCliConmgrEngineStatusBySerial:(NSString *)serial
{
    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/get_engine_cli_conmgr_engine_status.php?serial=%@", hostname, serial];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    //Initialize the delegate.
    XMLParser *parser = [[XMLParser alloc] initXMLParser];
    
    //Set delegate
    [xmlParser setDelegate:(id <NSXMLParserDelegate>)parser];
    
    //Start parsing the XML file.
    BOOL success = [xmlParser parse];
    NSLog(@"get_engine_cli_conmgr_engine_status.php parses %@", success?@"successfully":@"failed");
    
    return nil;
    */
    NSString *phpURL = @"get_engine_cli_conmgr_engine_status.php";
    return [self getSanInformation:phpURL bySerial:serial];

}

-(NSArray *)getEngineCliConmgrDriveStatusBySerial:(NSString *)serial
{
    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/get_engine_cli_conmgr_drive_status.php?serial=%@", hostname, serial];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    //Initialize the delegate.
    XMLParser *parser = [[XMLParser alloc] initXMLParser];
    
    //Set delegate
    [xmlParser setDelegate:(id <NSXMLParserDelegate>)parser];
    
    //Start parsing the XML file.
    BOOL success = [xmlParser parse];
    NSLog(@"get_engine_cli_conmgr_drive_status.php parses %@", success?@"successfully":@"failed");
    
    return nil;
    */
    
    NSString *phpURL = @"get_engine_cli_conmgr_drive_status.php";
    return [self getSanInformation:phpURL bySerial:serial];

}

-(NSArray *)getEngineCliConmgrDriveStatusDetailBySerial:(NSString *)serial
{
    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/get_engine_cli_conmgr_drive_status_detail.php?serial=%@", hostname, serial];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    //Initialize the delegate.
    XMLParser *parser = [[XMLParser alloc] initXMLParser];
    
    //Set delegate
    [xmlParser setDelegate:(id <NSXMLParserDelegate>)parser];
    
    //Start parsing the XML file.
    BOOL success = [xmlParser parse];
    NSLog(@"get_engine_cli_conmgr_drive_status.php parses %@", success?@"successfully":@"failed");
    
    return nil;
    */
    
    NSString *phpURL = @"get_engine_cli_conmgr_drive_status_detail.php";
    return [self getSanInformation:phpURL bySerial:serial];

}

- (void)syncRemoteServerDatabaseBySiteName:(NSString *)siteName
{
    
}


- (void)loadUserPreference
{
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

- (void)insertDemoDevices
{
    NSArray *descriptions = [NSArray arrayWithObjects:
                    @"Engine_227_228",
                    @"Engine_229_230",
                    @"Engine_231_232",@"Engine_233_234",@"Engine_235_236",@"Engine_237_238",@"Engine_239_240",
                    @"Engine_241_242",@"Engine_243_244",@"Engine_245_246",@"Engine_247_248",@"Engine_249_250",
                    @"Engine_251_252",
                    @"VicomM01",@"VicomM02",@"VicomM03",@"VicomM04",
                    //@"",
                    nil];

    [db beginTransaction];
    [db executeUpdate:@"CREATE TABLE ha_appliance_device_list (name TEXT PRIMARY KEY)"];
    for (int i=0; i<[descriptions count]; i++) {
        //NSLog(@"description=%@", [descriptions objectAtIndex:i]);
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO ha_appliance_device_list VALUES ('%@');", [descriptions objectAtIndex:i]];
        //NSLog(@"sql=%@", sql);
        [db executeUpdate:sql];
    }
    [db commit];
    
    //[self getVmirrorListByKey:@""];
}

- (NSMutableArray *)getHaApplianceNameListBySiteName:(NSString *)siteName
{
    NSString *sql = [NSString stringWithFormat:@"SELECT ha_appliance_name FROM ha_cluster WHERE site_name = '%@'", siteName];
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

- (NSArray *)getEnginesByHaApplianceName:(NSString *)haApplianceName
{
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

- (NSDictionary *)getVpdBySerial:(NSString *)serial
{
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
    if ([rs next])
    {
        dict = [rs resultDictionary];
        NSLog(@"%s %@", __func__, dict);
        //[devices addObject:[rs stringForColumnIndex:0]];
        //[devices addObject:[rs stringForColumnIndex:1]];
    }
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [rs close];
    return dict;
}

- (NSDictionary *)getEngineCliMirrorDictBySerial:(NSString *)serial
{
    NSDictionary *dict = nil;
    //
    // CREATE TABLE engine_cli_vpd (serial text primary key, seconds integer, site_name text, engine_name text, product_type text, fw_version text, fw_data text, redboot text, uid text, pcb text, mac text, ip text, uptime text, alert text, time text, a1_wwpn, a2_wwpn, b1_wwpn, b2_wwpn);
    //
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM engine_cli_mirror WHERE serial='%@' ORDER BY seconds LIMIT 1", serial];
    
    NSLog(@"%s %@", __func__, sql);
    FMResultSet *rs = [db executeQuery:sql];
    //FMResultSet *rs = [db executeQuery:sql];
    //NSString *sql = [NSString stringWithFormat:@"SELECT * FROM ha_cluster WHERE ha_appliance_name = '%@'", haApplianceName];
    //NSMutableArray *devices = [[NSMutableArray alloc] init];
    //NSLog(@"%s %@", __func__, sql);
    if ([rs next])
    {
        dict = [rs resultDictionary];
        NSLog(@"%s %@", __func__, dict);
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
        sql = [NSString stringWithFormat:@"select * from engine_cli_conmgr_initiator_status_detail"];
    }
    else {
        sql = [NSString stringWithFormat:@"select * from engine_cli_conmgr_initiator_status_detail where serial='%@'", serial];
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
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [rs close];
    return devices;
}

@end
