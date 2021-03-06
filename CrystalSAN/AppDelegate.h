//
//  AppDelegate.h
//  CrystalSAN
//
//  Created by Charles Hsu on 12/25/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SanDatabase.h"
#import "SyncManager.h"

#define ITEM_BUTTON_START_TAG       201

#define ITEM_BUTTON_VIEW_RAID_TAG   0
#define ITEM_BUTTON_VIEW_MIRROR_TAG 1
#define ITEM_BUTTON_VIEW_VOLUME_TAG 2

#define ITEM_BUTTON_VIEW_DRIVE_TAG    10
#define ITEM_BUTTON_VIEW_HBA_TAG    11



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//psudo data item
@property (strong,nonatomic) NSMutableArray *totalItems;
@property (strong,nonatomic) NSMutableArray *activeItems;

@property (strong,nonatomic) NSString *currentSegueID;
@property (strong,nonatomic) NSString *currentDeviceName;
@property (strong,nonatomic) NSString *currentHAApplianceName;

@property (strong,nonatomic) NSString *currentEngineLeftSerial;
@property (strong,nonatomic) NSString *currentEngineRightSerial;

@property (strong,nonatomic) SanDatabase *sanDatabase;
@property (strong,nonatomic) SyncManager *syncManager;

@property int currentSiteIndex;

@property (strong, nonatomic) NSNumber *loadSiteViewTimes;

@property (strong,nonatomic) NSString *siteName;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *password;

//@property (strong,nonatomic) NSString *phpSiteName;

//@property BOOL isLogin;
@property (weak, nonatomic) UIViewController *nextViewController;

@property BOOL isHostReachable;

@property (strong,nonatomic) NSArray *siteInfoArray;

@property (strong,nonatomic) UIViewController *currentViewController;
//@property (strong,nonatomic) UIStoryboard *storyboard;


- (NSString *)getSanVmirrorLists;


- (void)customizedArcSlider:(UISlider *)arcSlider radiusSlider:(UISlider *)radiusSlider spacingSlider:(UISlider *)spacingSlider sizingSlider:(UISlider *)sizingSlider inView:(UIView *)view;
- (void)customizedSearchArea:(UISearchBar *)searchBar statusButton:(UIButton *)statusButton nameButton:(UIButton *)nameButton connectionButton:(UIButton *)connectionButton inView:(UIView *)view;
- (void)updateItemIndexCountsAndTotalLabel:(NSUInteger )currentIndex count:(NSUInteger)count total:(NSUInteger)total forUILabel:(UILabel *)itemIndexCountsAndTotalLabel;

- (void)hideShowSliders:(UIView *)view;

- (void)insertInto:(NSString *)table values:(NSDictionary *)dict;
- (void)insertIntoCache:(NSString *)table values:(NSDictionary *)dict;

- (BOOL)IsCurrentSiteLogin;
- (void)setCurrentSiteLogin;
- (void)setCurrentSiteLogout;

- (void)logout;



//- (void)hideSlider:(id)sender;

@end
