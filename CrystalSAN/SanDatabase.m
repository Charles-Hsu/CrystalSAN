//
//  SanDatabase.m
//  CrystalSAN
//
//  Created by Charles Hsu on 2/2/13.
//  Copyright (c) 2013 Charles Hsu. All rights reserved.
//

#import "SanDatabase.h"
//#import "SMXMLDocument.h"
#import "XMLParser.h"

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

- (NSDictionary *)getHAClusterDictionaryBySiteName:(NSString *)siteName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    NSString *hostname = [defaults objectForKey:@"server_ip_hostname"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/get_ha_cluster_all.php?site_name=%@", hostname, siteName];
    
    //NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/samplexml.php", hostname];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //NSURL *url = [NSURL URLWithString:@"http://mac-mini.local/sanserver/san_site_name.php"];
    //NSError *error = nil;
    //NSString *xml = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    //NSString *xml = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"xml"];

    NSLog(@"--");
    NSLog(@"%@", urlString);
    //NSLog(@"nsurl response = %@", xml);
    NSLog(@"--");
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    //Initialize the delegate.
    XMLParser *parser = [[XMLParser alloc] initXMLParser];
    
    //Set delegate
    [xmlParser setDelegate:(id <NSXMLParserDelegate>)parser];
    
    //Start parsing the XML file.
    BOOL success = [xmlParser parse];
    

    
    
	// find "sample.xml" in our bundle resources
	//	NSData *data = [NSData dataWithContentsOfFile:xml];
	
	// create a new SMXMLDocument with the contents of sample.xml
	//SMXMLDocument *document = [SMXMLDocument documentWithData:data error:&error];
    
    //NSLog(@"XML:\n %@", xml);

    // check for errors
    //if (error) {
    //    NSLog(@"Error while parsing the document: %@", error);
    //    return nil;
    //}
    
	// demonstrate -description of document/element classes
    //	NSLog(@"Document:\n %@", document);
	
	// Pull out the <books> node
	//SMXMLElement *books = [document.root childNamed:@"books"];
	
	// Look through <books> children of type <book>
	//for (SMXMLElement *book in [books childrenNamed:@"book"]) {
		
		// demonstrate common cases of extracting XML data
        /*
		NSString *site_name = [cluster attributeNamed:@"site_name"]; // XML attribute
		NSString *ha_appliance_name = [cluster valueWithPath:@"ha_appliance_name"]; // child node value
		NSString *engine00 = [cluster valueWithPath:@"engine00"]; // child node value
        NSString *engine01 = [cluster valueWithPath:@"engine01"]; // child node value
        NSString *engine02 = [cluster valueWithPath:@"engine02"]; // child node value
		//float price = [[book valueWithPath:@"price"] floatValue]; // child node value (converted)
		
		// show off some KVC magic
		//NSArray *authors = [[book childNamed:@"authors"].children valueForKey:@"value"];
		
		NSLog(@"Found a cluster!\n site_name: %@ \n ha_appliance_name: %@ \n engine01: %@ \n engine02: %@", site_name, ha_appliance_name, engine01, engine02);
         */
        
        // demonstrate common cases of extracting XML data
	//	NSString *isbn = [book attributeNamed:@"isbn"]; // XML attribute
	//	NSString *title = [book valueWithPath:@"title"]; // child node value
	//	float price = [[book valueWithPath:@"price"] floatValue]; // child node value (converted)
		
		// show off some KVC magic
	//	NSArray *authors = [[book childNamed:@"authors"].children valueForKey:@"value"];
		
	//	NSLog(@"Found a book!\n ISBN: %@ \n Title: %@ \n Price: %f \n Authors: %@", isbn, title, price, authors);

	//}
    
    return nil;
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
