//
//  SyncManager.m
//  CrystalSAN
//
//  Created by Charles Hsu on 5/13/13.
//  Copyright (c) 2013 Charles Hsu. All rights reserved.
//

#import "SyncManager.h"
#import "AppDelegate.h"
#import "SanDatabase.h"

@interface SyncManager () {
    AppDelegate *theDelegate;
    SanDatabase *sanDatabase;
    NSString *siteName;
    NSMutableArray  *haArray;
}
@end

@implementation SyncManager
@synthesize haArray;

- (id)init
{
    self = [super init];
    if (self) {
        theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        sanDatabase = theDelegate.sanDatabase;
        siteName = theDelegate.siteName;
        //haArray = [sanDatabase getHaApplianceNameListBySiteName:siteName];
        haArray = [[NSMutableArray alloc] init];
        NSLog(@"%s %@", __func__, haArray);
        
        [sanDatabase httpGetHAClusterDictionaryBySiteName:theDelegate.siteName];
    }
    return self;
}

- (id)initWithHAApplianceArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        self.haArray = array;
    }
    return self;
}




- (void)syncEngineWithSerial:(NSString *)serial {
    
    NSLog(@"%s serial=%@", __func__, serial);
    
    siteName = theDelegate.siteName;
    
    /*
    if (theDelegate.isHostReachable) {
        [sanDatabase httpGetEngineCliDmepropBySiteName:siteName serial:serial];
        [sanDatabase httpGetEngineCliEngineStatusBySiteName:siteName serial:serial];
        [sanDatabase httpGetEngineCliMirrorBySiteName:siteName serial:serial];
        [sanDatabase httpGetEngineCliVpdBySiteName:siteName serial:serial];
        [sanDatabase httpGetEngineDriveInformationBySiteName:siteName serial:serial];
        [sanDatabase httpGetEngineInitiatorInformationBySiteName:siteName serial:serial];
    } else {
        // user current local client.db
    }
     */
    
}


- (void)syncHAAppliancesOfSite:(NSString *)siteName {
    
}

- (void)syncEngineWithHAApplianceNameAndAddedtoSyncedArray:(NSString *)haApplianceName {
    NSLog(@"%s haApplianceName=%@", __func__, haApplianceName);
    BOOL notExisted = TRUE;
    for (int i=0; i<[haArray count] && notExisted; i++) {
        if ([[haArray objectAtIndex:i] isEqualToString:haApplianceName]) {
            notExisted = FALSE;
        }
    }
    NSLog(@"%s %@", __func__, haArray);
    if (notExisted) {
        [haArray  addObject:haApplianceName];
        NSArray *engines = [sanDatabase getEnginesByHaApplianceName:haApplianceName];
        NSLog(@"%s %@", __func__, engines);
        for (int i=0; i<[engines count]; i++) {
            /*
            NSString *serial = [engines objectAtIndex:i];
            [sanDatabase httpGetEngineCliDmepropBySiteName:siteName serial:serial];
            [sanDatabase httpGetEngineCliEngineStatusBySiteName:siteName serial:serial];
            [sanDatabase httpGetEngineCliMirrorBySiteName:siteName serial:serial];
            [sanDatabase httpGetEngineCliVpdBySiteName:siteName serial:serial];
            [sanDatabase httpGetEngineDriveInformationBySiteName:siteName serial:serial];
            [sanDatabase httpGetEngineInitiatorInformationBySiteName:siteName serial:serial];
             */
        }
    }
}


- (void)updateEngineVpdInfo:(NSString *)haApplianceName {
    NSArray *engines = [sanDatabase getEnginesByHaApplianceName:haApplianceName];
    NSLog(@"%s %@", __func__, engines);
    for (int i=0; i<[engines count]; i++) {
        NSString *serial = [engines objectAtIndex:i];
        [sanDatabase httpGetEngineCliVpdBySiteName:siteName serial:serial];
    }
}


@end
