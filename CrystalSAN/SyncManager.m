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

@implementation SyncManager {
    AppDelegate *theDelegate;
    SanDatabase *sanDatabase;
    NSString *_siteName;
    NSMutableArray  *_haArray;
    NSMutableArray  *_haArray1;
}

- (id)init
{
    self = [super init];
    if (self) {
        theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        sanDatabase = theDelegate.sanDatabase;
        _siteName = theDelegate.siteName;
        _haArray = [[NSMutableArray alloc] init];
        _haArray1 = [[NSMutableArray alloc] init];
        [sanDatabase httpGetHAClusterDictionaryBySiteName:_siteName];
    }
    return self;
}

- (void)syncEngineWithHAApplianceNameAndAddedtoSyncedArray:(NSString *)haApplianceName part:(int)partNo
{
    NSLog(@"%s haApplianceName=%@", __func__, haApplianceName);
    BOOL notExisted = TRUE;
    if (partNo == 1) {
        for (int i=0; i<[_haArray count] && notExisted; i++) {
            if ([[_haArray objectAtIndex:i] isEqualToString:haApplianceName]) {
                notExisted = FALSE;
            }
        }
        if (notExisted) {
            NSLog(@"%s %@ %@", __func__, haApplianceName, notExisted?@"not existed":@"existed");
            [_haArray addObject:haApplianceName];
            [sanDatabase httpGetApplianceAllInfoPart1:haApplianceName siteName:_siteName];
        }
    } else if (partNo == 2) {
        for (int i=0; i<[_haArray1 count] && notExisted; i++) {
            if ([[_haArray1 objectAtIndex:i] isEqualToString:haApplianceName]) {
                notExisted = FALSE;
            }
        }
        if (notExisted) {
            NSLog(@"%s %@ %@", __func__, haApplianceName, notExisted?@"not existed":@"existed");
            [_haArray1 addObject:haApplianceName];
            [sanDatabase httpGetApplianceAllInfoPart2:haApplianceName siteName:_siteName];
        }
    }
    NSLog(@"%s haArray(%p)%@", __func__, &_haArray, _haArray);
    NSLog(@"%s haArray1(%p)%@", __func__, &_haArray1, _haArray1);
}


@end
