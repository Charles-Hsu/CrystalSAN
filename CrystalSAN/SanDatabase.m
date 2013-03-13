//
//  SanDatabase.m
//  CrystalSAN
//
//  Created by Charles Hsu on 2/2/13.
//  Copyright (c) 2013 Charles Hsu. All rights reserved.
//

#import "SanDatabase.h"

@interface SanDatabase ()
    - (NSString *)getServerDbForDemonstration;
@end

@implementation SanDatabase
@synthesize sanDatabase;


- (id)init
{
    self = [super init];
    if (self) {
        // Finding a file in the iPhone sandbox
        // http://stackoverflow.com/questions/5652329/finding-a-file-in-the-iphone-sandbox
        //NSString *home = NSHomeDirectory();
        //NSString *documentsPath = [home stringByAppendingPathComponent:@"Documents"];
        // Get the full path to our file.
        //NSString *databasePath = [documentsPath stringByAppendingPathComponent:@"sandatabase.sqlite"];
        NSString *databasePath = [self getServerDbForDemonstration];
        NSLog(@"%s %@", __func__, databasePath);
        
        sanDatabase = [FMDatabase databaseWithPath:databasePath];
        [sanDatabase executeUpdate:@"PRAGMA auto_vacuum = 2"];
        
        if (![sanDatabase open])
        {
            NSLog(@"Could not open db.");
            //return nil;
        }
        //return db;
    }
    return self;
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

- (NSString *)getHAClusterXMLBySiteName:(NSString *)siteName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/get_ha_cluster_all.php?site_name=%@", hostname, siteName];
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

- (NSArray *)getEngineCliVpdBySerial:(NSString *)serial
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/get_engine_cli_vpd_all.php?serial=%@", hostname, serial];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //NSURL *url = [NSURL URLWithString:@"http://mac-mini.local/sanserver/san_site_name.php"];
    NSError *error = nil;
    NSString *apiResponse = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"--");
    NSLog(@"%@", urlString);
    NSLog(@"nsurl response = %@", apiResponse);
    NSLog(@"--");
    
    return nil;
}

- (NSArray *)getEngineCliMirrorBySerial:(NSString *)serial
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/get_engine_cli_mirror_all.php?serial=%@", hostname, serial];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //NSURL *url = [NSURL URLWithString:@"http://mac-mini.local/sanserver/san_site_name.php"];
    NSError *error = nil;
    NSString *apiResponse = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"--");
    NSLog(@"%@", urlString);
    NSLog(@"nsurl response = %@", apiResponse);
    NSLog(@"--");
    
    return nil;
}

- (NSArray *)getEngineCliConmgrInitiatorStatusBySerial:(NSString *)serial
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/get_engine_cli_conmgr_initiator_status.php?serial=%@", hostname, serial];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //NSURL *url = [NSURL URLWithString:@"http://mac-mini.local/sanserver/san_site_name.php"];
    NSError *error = nil;
    NSString *apiResponse = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"--");
    NSLog(@"%@", urlString);
    NSLog(@"nsurl response = %@", apiResponse);
    NSLog(@"--");
    
    return nil;
}


- (NSArray *)getEngineCliConmgrInitiatorStatusDetailBySerial:(NSString *)serial
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/get_engine_cli_conmgr_initiator_status_detail.php?serial=%@", hostname, serial];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //NSURL *url = [NSURL URLWithString:@"http://mac-mini.local/sanserver/san_site_name.php"];
    NSError *error = nil;
    NSString *apiResponse = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"--");
    NSLog(@"%@", urlString);
    NSLog(@"nsurl response = %@", apiResponse);
    NSLog(@"--");
    
    return nil;
}

- (NSArray *)getEngineCliConmgrEngineStatusBySerial:(NSString *)serial
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/get_engine_cli_conmgr_engine_status.php?serial=%@", hostname, serial];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //NSURL *url = [NSURL URLWithString:@"http://mac-mini.local/sanserver/san_site_name.php"];
    NSError *error = nil;
    NSString *apiResponse = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"--");
    NSLog(@"%@", urlString);
    NSLog(@"nsurl response = %@", apiResponse);
    NSLog(@"--");
    
    return nil;
}

-(NSArray *)getEngineCliConmgrDriveStatusBySerial:(NSString *)serial
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/get_engine_cli_conmgr_drive_status.php?serial=%@", hostname, serial];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //NSURL *url = [NSURL URLWithString:@"http://mac-mini.local/sanserver/san_site_name.php"];
    NSError *error = nil;
    NSString *apiResponse = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"--");
    NSLog(@"%@", urlString);
    NSLog(@"nsurl response = %@", apiResponse);
    NSLog(@"--");
    
    return nil;
}

-(NSArray *)getEngineCliConmgrDriveStatusDetailBySerial:(NSString *)serial
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/get_engine_cli_conmgr_drive_status_detail.php?serial=%@", hostname, serial];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //NSURL *url = [NSURL URLWithString:@"http://mac-mini.local/sanserver/san_site_name.php"];
    NSError *error = nil;
    NSString *apiResponse = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"--");
    NSLog(@"%@", urlString);
    NSLog(@"nsurl response = %@", apiResponse);
    NSLog(@"--");
    
    return nil;
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


- (NSString *)getServerDbForDemonstration
{
    // IOS: copy a file in documents folder
    // http://stackoverflow.com/questions/6545180/ios-copy-a-file-in-documents-folder
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:@"server.db"];
    
    //if ([fileManager fileExistsAtPath:txtPath] == NO) {
    //    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"db"];
    //    [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
    //}
    
    // If you want to overwrite every time then try this:
    if ([fileManager fileExistsAtPath:txtPath] == YES) {
        [fileManager removeItemAtPath:txtPath error:&error];
    }
    
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

    [sanDatabase beginTransaction];
    [sanDatabase executeUpdate:@"CREATE TABLE ha_appliance_device_list (name TEXT PRIMARY KEY)"];
    for (int i=0; i<[descriptions count]; i++) {
        NSLog(@"description=%@", [descriptions objectAtIndex:i]);
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO ha_appliance_device_list VALUES ('%@');", [descriptions objectAtIndex:i]];
        NSLog(@"sql=%@", sql);
        [sanDatabase executeUpdate:sql];
    }
    [sanDatabase commit];
    
    //[self getVmirrorListByKey:@""];
}

- (NSMutableArray *)getVmirrorListByKey:(NSString *)key
{
    NSString *sql = [NSString stringWithFormat:@"SELECT name FROM ha_appliance_device_list WHERE name LIKE '%%%@%%'", key];
    NSMutableArray *devices = [[NSMutableArray alloc] init];
    FMResultSet *rs = [sanDatabase executeQuery:sql];
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
