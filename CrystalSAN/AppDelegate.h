//
//  AppDelegate.h
//  CrystalSAN
//
//  Created by Charles Hsu on 12/25/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ITEM_BUTTON_START_TAG       201

#define ITEM_BUTTON_VIEW_RAID_TAG   0
#define ITEM_BUTTON_VIEW_MIRROR_TAG 1
#define ITEM_BUTTON_VIEW_VOLUME_TAG 2


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//psudo data item
@property (strong,nonatomic) NSMutableArray *totalItems;
@property (strong,nonatomic) NSMutableArray *activeItems;

@property (strong,nonatomic) NSString *currentSegueID;
@property (strong,nonatomic) NSString *currentDeviceName;

@end
