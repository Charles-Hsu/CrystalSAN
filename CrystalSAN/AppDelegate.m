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
@synthesize currentSiteIndex;

@synthesize currentEngineLeftSerial, currentEngineRightSerial;
@synthesize loadSiteViewTimes;

@synthesize siteName, userName, password;
@synthesize isLogin;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //init psudo data's image
    self.totalItems  = [NSMutableArray arrayWithCapacity:PSUDO_ITEM_NUMBER];
    
    for(int i=0; i<PSUDO_ITEM_NUMBER; i++)
    {
        switch (i) {
            case ITEM_BUTTON_VIEW_RAID_TAG:
                [self.totalItems addObject:@"Home-Button-RaidView"];
                break;
            case ITEM_BUTTON_VIEW_MIRROR_TAG:
                [self.totalItems addObject:@"Home-Button-HAApplianceView"];
                break;
            case ITEM_BUTTON_VIEW_VOLUME_TAG:
                [self.totalItems addObject:@"Home-Button-VolumeView"];
                break;
            case ITEM_BUTTON_VIEW_DRIVE_TAG:
                [self.totalItems addObject:@"Home-Button-DriveView"];
                break;
            case ITEM_BUTTON_VIEW_HBA_TAG:
                [self.totalItems addObject:@"Home-Button-HBAView"];
                break;
            default:
                [self.totalItems addObject:@"Hexagonal"];
                break;
        }
    }
    
    //NSLog(@"Fonts: %@", [UIFont familyNames]);
    //NSLog(@"Fonts: %@", [UIFont fontNamesForFamilyName:@"Source Code Pro"]); // "SourceCodePro-Regular"
    
    //NSLog(@"%s %@", __func__, self.totalItems);
    
    self.activeItems = [NSMutableArray array];
    sanDatabase = [[SanDatabase alloc] init];
    //[sanDatabase getVmirrorListByKey:@"vi"];
    //if ([[sanDatabase getVmirrorListByKey:@""] count] == 0) {
    //    [sanDatabase insertDemoDevices];
    //}
    
    /*
    [sanDatabase getPasswordBySiteName:@"KBS" siteID:@"123456" userName:@"admin"];
    
    [sanDatabase syncWithServerDb:@"KBS"];
    
    [sanDatabase getEngineCliVpdBySerial:@"00600118"];
    [sanDatabase getEngineCliMirrorBySerial:@"00600120"];
    
    [sanDatabase getEngineCliConmgrInitiatorStatusBySerial:@"00600120"];
    [sanDatabase getEngineCliConmgrInitiatorStatusDetailBySerial:@"00600120"];
    
    [sanDatabase getEngineCliConmgrEngineStatusBySerial:@"00600120"];
    [sanDatabase getEngineCliConmgrDriveStatusBySerial:@"00600120"];
    
    [sanDatabase getEngineCliConmgrDriveStatusDetailBySerial:@"00600120"];
     */
    
    self.currentDeviceName = nil;
    self.currentSiteIndex = 0;
    
    self.loadSiteViewTimes = 0;

    self.isLogin = FALSE;
    
    return YES;
}

- (void)hideSizingSlider:(UIView *)view
{
    //[theDelegate hideShowSliders:self.view.subviews];
    
    for (UIView *subview in view.subviews) {
        NSString *identification = subview.restorationIdentifier;
        NSRange range = [identification rangeOfString:@"sizingSlider"];
        if (range.length != 0) {
            //if (subview.isHidden)
            //    [subview setHidden:FALSE];
            //else
            [subview setHidden:TRUE];
        }
    }
}


- (void)customizedArcSlider:(UISlider *)arcSlider radiusSlider:(UISlider *)radiusSlider spacingSlider:(UISlider *)spacingSlider sizingSlider:(UISlider *)sizingSlider inView:(UIView *)view
{
    // Customizing UISlider in iPhone
    // http://jasonlawton.com/blog/customizing-uislider-in-iphone/
    //
    UIImage *sliderThumb = [UIImage imageNamed:@"uislider-thumb.png"];
    UIImage *sliderMinimum = [[UIImage imageNamed:@"uislider-left.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
    UIImage *sliderMaximum = [[UIImage imageNamed:@"uislider-right.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
    
    [arcSlider setThumbImage:sliderThumb forState:UIControlStateNormal];
    [arcSlider setThumbImage:sliderThumb forState:UIControlStateHighlighted];
    [arcSlider setMinimumTrackImage:sliderMinimum forState:UIControlStateNormal];
    [arcSlider setMaximumTrackImage:sliderMaximum forState:UIControlStateNormal];
    
    [radiusSlider setThumbImage:sliderThumb forState:UIControlStateNormal];
    [radiusSlider setThumbImage:sliderThumb forState:UIControlStateHighlighted];
    [radiusSlider setMinimumTrackImage:sliderMinimum forState:UIControlStateNormal];
    [radiusSlider setMaximumTrackImage:sliderMaximum forState:UIControlStateNormal];
    
    [spacingSlider setThumbImage:sliderThumb forState:UIControlStateNormal];
    [spacingSlider setThumbImage:sliderThumb forState:UIControlStateHighlighted];
    [spacingSlider setMinimumTrackImage:sliderMinimum forState:UIControlStateNormal];
    [spacingSlider setMaximumTrackImage:sliderMaximum forState:UIControlStateNormal];
    
    [sizingSlider setThumbImage:sliderThumb forState:UIControlStateNormal];
    [sizingSlider setThumbImage:sliderThumb forState:UIControlStateHighlighted];
    [sizingSlider setMinimumTrackImage:sliderMinimum forState:UIControlStateNormal];
    [sizingSlider setMaximumTrackImage:sliderMaximum forState:UIControlStateNormal];
    
    [view bringSubviewToFront:arcSlider];
    [view bringSubviewToFront:radiusSlider];
    [view bringSubviewToFront:spacingSlider];
    [view bringSubviewToFront:sizingSlider];
    
    [self hideSizingSlider:view];
    //sizingSlider.hidden = TRUE;

}

- (void)customizedSearchArea:(UISearchBar *)searchBar statusButton:(UIButton *)statusButton nameButton:(UIButton *)nameButton connectionButton:(UIButton *)connectionButton inView:(UIView *)view
{
    // change the background to clearColor
    // http://stackoverflow.com/questions/8999322/how-to-change-search-bar-background-color-in-ipad
    for (UIView *subview in searchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    // change the size of searchBar
    // http://stackoverflow.com/questions/556814/changing-the-size-of-the-uisearchbar-textfield
    
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"Search-Bar.png"] forState:UIControlStateNormal];
    
    [view bringSubviewToFront:statusButton];
    [view bringSubviewToFront:nameButton];
    [view bringSubviewToFront:connectionButton];

}

- (void)updateItemIndexCountsAndTotalLabel:(NSUInteger )currentIndex count:(NSUInteger)count total:(NSUInteger)total forUILabel:(UILabel *)itemIndexCountsAndTotalLabel
{
    
    NSString *label = [NSString stringWithFormat:@" /%u /%u", count, total];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:label];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, [label length])];
    
    NSDictionary *boldSystemFontOfSize30Dict = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:30.0] forKey:NSFontAttributeName];
    NSMutableAttributedString *indexString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%3u", currentIndex+1] attributes:boldSystemFontOfSize30Dict];
    [indexString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:87.0/255.0 green:175.0/255.0 blue:235.0/255.0 alpha:1] range:NSMakeRange(0, [indexString length])];
    
    [attrString insertAttributedString:indexString atIndex:0];
    
    itemIndexCountsAndTotalLabel.attributedText = attrString;
    itemIndexCountsAndTotalLabel.textAlignment = UITextAlignmentRight;
    
}

- (void)hideShowSliders:(UIView *)view
{
    //[theDelegate hideShowSliders:self.view.subviews];
    
    for (UIView *subview in view.subviews) {
        NSString *identification = subview.restorationIdentifier;
        NSRange range = [identification rangeOfString:@"Slider"];
        if ([identification rangeOfString:@"sizing"].length == 0) { // ignore sizing element
            if (range.length != 0) {
                if (subview.isHidden)
                    [subview setHidden:FALSE];
                else
                    [subview setHidden:TRUE];
            }
        }
    }
}


- (void)insertInto:(NSString *)table values:(NSDictionary *)dict
{
    
    NSLog(@"%s %@ %@", __func__, table, dict);
    
    NSMutableString *keys = [[NSMutableString alloc] init];
    NSMutableString *values = [[NSMutableString alloc] init];
    NSUInteger count = [[dict allKeys] count];
    
    for (int i=0; i<count; i++) {
        [keys appendString:[[dict allKeys] objectAtIndex:i]];
        if (i < count-1)
            [keys appendString:@","];
    }
 
    for (int i=0; i<count; i++) {
        [values appendFormat:@"'%@'", [[dict allValues] objectAtIndex:i]];
        if (i < count-1)
            [values appendString:@","];
    }

    if ([table isEqualToString:@"ha_cluster"]) {
        [sanDatabase insertUpdateHaCluster: dict];
    }
    else {
        [sanDatabase insertUpdate:table record: dict];
    }
    
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
