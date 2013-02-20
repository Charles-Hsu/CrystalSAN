//
//  SanDatabase.m
//  CrystalSAN
//
//  Created by Charles Hsu on 2/2/13.
//  Copyright (c) 2013 Charles Hsu. All rights reserved.
//

#import "SanDatabase.h"

@implementation SanDatabase
@synthesize sanDatabase;


- (id)init
{
    self = [super init];
    if (self) {
        // Finding a file in the iPhone sandbox
        // http://stackoverflow.com/questions/5652329/finding-a-file-in-the-iphone-sandbox
        NSString *home = NSHomeDirectory();
        NSString *documentsPath = [home stringByAppendingPathComponent:@"Documents"];
        // Get the full path to our file.
        NSString *databasePath = [documentsPath stringByAppendingPathComponent:@"sandatabase.sqlite"];
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
    
    [self getVmirrorListByKey:@""];
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
