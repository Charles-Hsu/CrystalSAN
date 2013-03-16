//
//  AppDelegate.m
//  CrystalSAN
//
//  Created by Charles Hsu on 12/25/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//


#import "AppDelegate.h"
#import "XMLParser.h"

#define PSUDO_ITEM_NUMBER   12

@implementation AppDelegate

@synthesize sanDatabase;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //init psudo data's image
    self.totalItems  = [NSMutableArray arrayWithCapacity:PSUDO_ITEM_NUMBER];
    
    for(int i=0; i<PSUDO_ITEM_NUMBER; i++)
    {
        switch (i) {
            case ITEM_BUTTON_VIEW_RAID_TAG:
                [self.totalItems addObject:@"button-item-RAID-view"];
                break;
            case ITEM_BUTTON_VIEW_MIRROR_TAG:
                [self.totalItems addObject:@"button-item-Mirror-view"];
                break;
            case ITEM_BUTTON_VIEW_VOLUME_TAG:
                [self.totalItems addObject:@"button-item-Volume-view"];
                break;
            case ITEM_BUTTON_VIEW_DRIVE_TAG:
            case ITEM_BUTTON_VIEW_HBA_TAG:
                [self.totalItems addObject:@"Hexagonal-orange"];
                break;
            default:
                [self.totalItems addObject:@"Hexagonal"];
                break;
        }
    }
    
    NSLog(@"%@", self.totalItems);
    
    self.activeItems = [NSMutableArray array];
    sanDatabase = [[SanDatabase alloc] init];
    //[sanDatabase getVmirrorListByKey:@"vi"];
    if ([[sanDatabase getVmirrorListByKey:@""] count] == 0) {
        [sanDatabase insertDemoDevices];
    }
    
    [sanDatabase getPasswordBySiteName:@"KBS" siteID:@"123456" userName:@"admin"];
    
    NSDictionary *dict = [sanDatabase getHAClusterDictionaryBySiteName:@"KBS"];
    NSLog(@"%@", dict);
    
    /*
    [sanDatabase getEngineCliVpdBySerial:@"00600118"];
    [sanDatabase getEngineCliMirrorBySerial:@"00600120"];
    
    [sanDatabase getEngineCliConmgrInitiatorStatusBySerial:@"00600120"];
    [sanDatabase getEngineCliConmgrInitiatorStatusDetailBySerial:@"00600120"];
    
    [sanDatabase getEngineCliConmgrEngineStatusBySerial:@"00600120"];
    [sanDatabase getEngineCliConmgrDriveStatusBySerial:@"00600120"];
    
    [sanDatabase getEngineCliConmgrDriveStatusDetailBySerial:@"00600120"];
     */
    
    /*
    NSString *hostname = @"localhost";
    NSString *urlString = [NSString stringWithFormat:@"http://%@/CrystalSANServer/samplexml.php", hostname];
    NSURL *url = [NSURL URLWithString:urlString];

    //NSURL *url = [[NSURL alloc] initWithString:@"http://www.edumobile.org/blog/uploads/XML-parsing-data/Data.xml"];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	
	//Initialize the delegate.
	XMLParser *parser = [[XMLParser alloc] initXMLParser];

	//Set delegate
	[xmlParser setDelegate:(id)parser];
	
	//Start parsing the XML file.
	BOOL success = [xmlParser parse];
     */
    return YES;
}

- (NSString *)getSanVmirrorLists
{
    //NSURL *url = [NSURL URLWithString:@"http://mac-mini.local/sanserver/san_site_name.php"];
    //NSError *error = nil;
    //NSString *apiResponse = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    //NSLog(@"--");
    //NSLog(@"nsurl response = %@", apiResponse);
    //NSLog(@"--");
    
    return @"";//apiResponse;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
