//
//  HAApplianceConnectionViewController.m
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Charles Hsu. All rights reserved.
//

#import "HAApplianceConnectionViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"

#import "MBProgressHUD.h"


#define ITEM_BUTTON_START_TAG_RAIDVIEW 300

@interface HAApplianceConnectionViewController () {

    NSMutableArray *statusArray;
    NSInteger totalItemInCarousel;
    NSInteger currentCollectionNumber;
    
    NSUInteger currentItemIndex;
    NSUInteger currentCollectionCount;
    NSUInteger totalCount;
    
    AppDelegate *theDelegate;
    
    MBProgressHUD *hud;
    
    BOOL isHUDshowing;
    
    NSDictionary *engine00Vpd;
    NSDictionary *engine01Vpd;
    
    NSDictionary *engine00Mirror;
    NSDictionary *engine01Mirror;
}
@end

@implementation HAApplianceConnectionViewController

@synthesize deviceName;
@synthesize carousel;
@synthesize descriptions;
@synthesize sanDatabase;

@synthesize arcValue, radiusValue, spacingValue, sizingValue;
@synthesize arcLabel, radiusLabel, spacingLabel, sizingLabel;
@synthesize arcSlider, radiusSlider, spacingSlider, sizingSlider;

@synthesize lun00Button, lun01Button, lun02Button, lun03Button, lun04Button, lun05Button;
@synthesize lun00Label, lun01Label, lun02Label, lun03Label, lun04Label, lun05Label;


@synthesize lun00_0_Label, lun00_1_Label, lun01_0_Label, lun01_1_Label, lun02_0_Label, lun02_1_Label, lun03_0_Label, lun03_1_Label, lun04_0_Label, lun04_1_Label, lun05_0_Label, lun05_1_Label;

@synthesize engineLeft, engineRight;

@synthesize haApplianceName;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"%s", __func__);

    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //set up carousel data
        carousel = [[iCarousel alloc] initWithFrame:CGRectMake(80, 128, 864, 80)];
        //carousel.backgroundColor = [UIColor cyanColor];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"deviceName=%@", deviceName);
    deviceName = [deviceName stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    
    [haApplianceName setText:[NSString stringWithFormat:@"%@", deviceName]];
    //deviceLabel.numberOfLines = 0;
    
    theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //theDelegate.currentSegueID = @"RaidViewConfigID";
    //theDelegate.currentDeviceName = deviceName;
    
    //get data
    theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    sanDatabase = theDelegate.sanDatabase;
    
    descriptions = [sanDatabase getVmirrorListByKey:@""];
    //NSLog(@"description count = %u", [descriptions count]);
    
    //init/add carouse view
    carousel.delegate = self;
    carousel.dataSource = self;
    [self.view addSubview:carousel];
    //self.iCarouselView.currentItemIndex = self.totalItems.count/2;
    
    //carousel.type = iCarouselTypeRotary; //0 - -0.01;
    //carousel.type = iCarouselTypeLinear;//
    carousel.type = iCarouselTypeInvertedCylinder;
    //carousel.type = iCarouselTypeCylinder;
    
    
    carousel.contentOffset = CGSizeMake(0, -60);
    carousel.viewpointOffset = CGSizeMake(0, -50);
    carousel.decelerationRate = 0.9;
    
    
    totalItemInCarousel = [descriptions count];
    NSUInteger count = [descriptions count];
    
    currentItemIndex = 0;
    currentCollectionCount =  count;
    totalCount = count;
    
    //[theDelegate updateItemIndexCountsAndTotalLabel:currentItemIndex count:currentCollectionCount total:totalCount forUILabel:itemIndexCountsAndTotalLabel];
    
    //[carousel reloadData];
    
    [theDelegate customizedArcSlider: arcSlider radiusSlider:radiusSlider spacingSlider:spacingSlider sizingSlider:sizingSlider inView:self.view];
    
    //[theDelegate customizedSearchArea:searchBar statusButton:searchStatusButton nameButton:searchNameButton connectionButton:searchConnectionButton inView:self.view];

    self.hbaViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HbaViewControllerID"];
    self.hbaViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    [self.view bringSubviewToFront:lun00Button];
    [self.view bringSubviewToFront:lun01Button];
    [self.view bringSubviewToFront:lun02Button];
    [self.view bringSubviewToFront:lun03Button];
    [self.view bringSubviewToFront:lun04Button];
    [self.view bringSubviewToFront:lun05Button];
    
    self.haApplianceName.text = theDelegate.currentDeviceName;
    
    NSLog(@"%s deviceName=%@", __func__, theDelegate.currentDeviceName);
    
    //
    // How to add a touch event to a UIView?
    //
    // http://stackoverflow.com/questions/4660371/how-to-add-a-touch-event-to-a-uiview
    // by Nathan Eror http://stackoverflow.com/users/100039/nathan-eror
    //
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];

    
}

// The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self hideHud];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%s", __func__);
    self.haApplianceName.text = theDelegate.currentDeviceName;
    //NSLog(@"%@", [deviceArray objectAtIndex:currentItemIndex]);
    
    NSArray *engines = [theDelegate.sanDatabase getEnginesByHaApplianceName:(self.haApplianceName.text)];
    NSLog(@"%s %@", __func__, engines);
    
    if ([engines count] == 2) {
        theDelegate.currentEngineLeftSerial = [engines objectAtIndex:0];
        theDelegate.currentEngineRightSerial = [engines objectAtIndex:1];
        engine00Vpd = [theDelegate.sanDatabase getVpdBySerial:theDelegate.currentEngineLeftSerial];
        engine01Vpd = [theDelegate.sanDatabase getVpdBySerial:theDelegate.currentEngineRightSerial];
        engine00Mirror = [theDelegate.sanDatabase getEngineCliMirrorDictBySerial:theDelegate.currentEngineLeftSerial];
        engine01Mirror = [theDelegate.sanDatabase getEngineCliMirrorDictBySerial:theDelegate.currentEngineRightSerial];
        
        
        NSDictionary *dict = engine00Mirror;
        
        //NSString *mirror_0_member_0_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_member_0_id"]];
        //NSString *mirror_0_member_0_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_member_0_sts"]];
        //NSString *mirror_0_member_1_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_member_1_id"]];
        //NSString *mirror_0_member_1_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_member_1_sts"]];
        
        self.lun00_0_Label.text = [dict valueForKey:@"mirror_0_member_0_id"];
        self.lun00_1_Label.text = [dict valueForKey:@"mirror_0_member_1_id"];
        self.lun01_0_Label.text = [dict valueForKey:@"mirror_1_member_0_id"];
        self.lun01_1_Label.text = [dict valueForKey:@"mirror_1_member_1_id"];
        self.lun02_0_Label.text = [dict valueForKey:@"mirror_2_member_0_id"];
        self.lun02_1_Label.text = [dict valueForKey:@"mirror_2_member_1_id"];
        self.lun03_0_Label.text = [dict valueForKey:@"mirror_3_member_0_id"];
        self.lun03_1_Label.text = [dict valueForKey:@"mirror_3_member_1_id"];
        
        self.lun00Label.text = [dict valueForKey:@"mirror_0_id"];
        self.lun01Label.text = [dict valueForKey:@"mirror_1_id"];
        self.lun02Label.text = [dict valueForKey:@"mirror_2_id"];
        self.lun03Label.text = [dict valueForKey:@"mirror_3_id"];
        
        if ([[dict valueForKey:@"mirror_3_id"] length] == 0) {
            self.lun03Label.hidden = TRUE;
            self.lun03Button.hidden = TRUE;
            self.lun03_0_Button.hidden = TRUE;
            self.lun03_1_Button.hidden = TRUE;
            self.lun03_MirroredLUN.hidden = TRUE;
        } else {
            self.lun03Label.hidden = FALSE;
            self.lun03Button.hidden = FALSE;
            self.lun03_0_Button.hidden = FALSE;
            self.lun03_1_Button.hidden = FALSE;
            self.lun03_MirroredLUN.hidden = FALSE;
        }
        
        //NSLog(@"%s '%@'", __func__, [dict valueForKey:@"mirror_3_id"]);
        
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    //carousel.delegate = nil;
    //carousel.dataSource = nil;
    //carousel = nil;
    //self.totalItems = nil;
    //self.activeItems = nil;
}


- (IBAction)onHome:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    //[self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
    //NSLog(@"%s", __func__);
    
    //UIViewController *prevVC = [self.navigationController.viewControllers objectAtIndex:0];
    //[self.navigationController popToViewController:prevVC animated:YES];
    
    //alloc new view controller
	//MainViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewControllerID"];
    
	//present new view controller
	//[self presentViewController:mainVC animated:YES completion:nil];
}

- (IBAction)onBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (NSString *)getEngineVpdShortString:(NSString *)serial
- (NSString *)getEngineVpdShortString:(NSDictionary *)vpd
{
    //NSDictionary *vpd = [theDelegate.sanDatabase getVpdBySerial:serial];
    
    /*
     "a1_wwpn" = "2100-006022-0928f2";
     "a2_wwpn" = "2200-006022-0928f2";
     alert = None;
     "b1_wwpn" = "2300-006022-0928f2";
     "b2_wwpn" = "2400-006022-0928f2";
     "engine_name" = "engine_212";
     "fw_data" = "Sep 17 2012 16:56:07";
     "fw_version" = "15.1.10";
     ip = "10.100.5.212";
     mac = "0.60.22.9.28.F2";
     pcb = 00600306;
     "product_type" = FCE4400;
     redboot = "0.2.0.6";
     seconds = 1363746626;
     serial = 00600306;
     "site_name" = "";
     time = "Wednesday 3/20/2013 11:29:11";
     uid = "00000060-220928F2";
     uptime = "164d 04:02:40";
     */
    
    //NSString *uid = [vpd valueForKey:@"uid"];
    NSString *productType = [vpd valueForKey:@"product_type"];
    NSString *pcb = [vpd valueForKey:@"pcb"];
    NSString *mac = [vpd valueForKey:@"mac"];
    NSString *ip = [vpd valueForKey:@"ip"];
    NSString *uptime = [vpd valueForKey:@"uptime"];
    NSString *alert = [vpd valueForKey:@"alert"];
    NSString *time = [vpd valueForKey:@"time"];
    NSString *a1_wwnn = [vpd valueForKey:@"a1_wwnn"];
    NSString *a1_wwpn = [vpd valueForKey:@"a1_wwpn"];
    NSString *a2_wwnn = [vpd valueForKey:@"a2_wwnn"];
    NSString *a2_wwpn = [vpd valueForKey:@"a2_wwpn"];
    NSString *b1_wwnn = [vpd valueForKey:@"b1_wwnn"];
    NSString *b1_wwpn = [vpd valueForKey:@"b1_wwpn"];
    NSString *b2_wwnn = [vpd valueForKey:@"b2_wwnn"];
    NSString *b2_wwpn = [vpd valueForKey:@"b2_wwpn"];
    
    //
    // http://stackoverflow.com/questions/7633664/declare-a-nsstring-in-multiple-lines
    // Declare a NSString in multiple lines
    //
    
    if ([productType isEqualToString:@"FCE4400"]) {
        NSString *vpdString = [NSString stringWithFormat:
                               @"PCB Number         : %@\n"
                               "MAC address        : %@\n"
                               "IP address         : %@\n"
                               "Uptime             : %@\n"
                               "Alert: %@\n"
                               "%@\n"
                               "Port  Node Name           Port Name\n"
                               "A1    %@  %@\n"
                               "A2    %@  %@\n"
                               "B1    %@  %@\n"
                               "B2    %@  %@\n",
                               pcb,
                               mac,
                               ip,
                               uptime,
                               alert,
                               time,
                               a1_wwnn,
                               a1_wwpn,
                               a2_wwnn,
                               a2_wwpn,
                               b1_wwnn,
                               b1_wwpn,
                               b2_wwnn,
                               b2_wwpn                     ];
        
        return vpdString;

    } else if ([productType isEqualToString:@"FC"]) {
        NSString *vpdString = [NSString stringWithFormat:
                               @"PCB Number         : %@\n"
                               "MAC address        : %@\n"
                               "IP address         : %@\n"
                               "Uptime             : %@\n"
                               "Alert: %@\n"
                               "Port  Node Name           Port Name\n"
                               "A    %@  %@\n"
                               "B    %@  %@\n",
                               pcb,
                               mac,
                               ip,
                               uptime,
                               alert,
                               a1_wwnn,
                               a1_wwpn,
                               b1_wwnn,
                               b1_wwpn  ];
        
        return vpdString;
        
    }
    
    return nil;
}


- (void)hideHud {
    NSLog(@"%s", __func__);
    
    if (isHUDshowing) {
        NSInteger delaySec = 0.1;
        [hud hide:YES afterDelay:delaySec];
        isHUDshowing = NO;
    }
}

//- (NSString *)getMirrorShortString:(NSString *)serial byLunNum:(NSString *)lunNumStr {
- (NSString *)getMirrorShortString:(NSDictionary *)dict {
    
    //Mirror(hex)    state       Map         Capacity  Members
    //33537(0x8301) Operational   0      13672091475  0 (OK )  2 (OK )
    
    //NSDictionary *dict = [theDelegate.sanDatabase getEngineCliMirrorDictBySerial:theDelegate.currentEngineLeftSerial];
    
    NSString *mirror_0_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_id"]];
    NSString *mirror_0_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_sts"]];
    NSString *mirror_0_map = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_map"]];
    NSString *mirror_0_capacity = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_capacity"]];
    NSString *mirror_0_member_0_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_member_0_id"]];
    NSString *mirror_0_member_0_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_member_0_sts"]];
    NSString *mirror_0_member_1_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_member_1_id"]];
    NSString *mirror_0_member_1_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_0_member_1_sts"]];
    
    NSString *mirror_1_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_1_id"]];
    NSString *mirror_1_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_1_sts"]];
    NSString *mirror_1_map = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_1_map"]];
    NSString *mirror_1_capacity = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_1_capacity"]];
    NSString *mirror_1_member_0_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_1_member_0_id"]];
    NSString *mirror_1_member_0_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_1_member_0_sts"]];
    NSString *mirror_1_member_1_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_1_member_1_id"]];
    NSString *mirror_1_member_1_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_1_member_1_sts"]];
    
    NSString *mirror_2_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_2_id"]];
    NSString *mirror_2_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_2_sts"]];
    NSString *mirror_2_map = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_2_map"]];
    NSString *mirror_2_capacity = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_2_capacity"]];
    NSString *mirror_2_member_0_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_2_member_0_id"]];
    NSString *mirror_2_member_0_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_2_member_0_sts"]];
    NSString *mirror_2_member_1_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_2_member_1_id"]];
    NSString *mirror_2_member_1_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_2_member_1_sts"]];
    
    NSString *mirror_3_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_3_id"]];
    NSString *mirror_3_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_3_sts"]];
    NSString *mirror_3_map = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_3_map"]];
    NSString *mirror_3_capacity = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_3_capacity"]];
    NSString *mirror_3_member_0_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_3_member_0_id"]];
    NSString *mirror_3_member_0_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_3_member_0_sts"]];
    NSString *mirror_3_member_1_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_3_member_1_id"]];
    NSString *mirror_3_member_1_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_3_member_1_sts"]];
    
    /*
    NSString *mirror_4_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_4_id"]];
    NSString *mirror_4_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_4_sts"]];
    NSString *mirror_4_map = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_4_map"]];
    NSString *mirror_4_capacity = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_4_capacity"]];
    NSString *mirror_4_member_0_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_4_member_0_id"]];
    NSString *mirror_4_member_0_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_4_member_0_sts"]];
    NSString *mirror_4_member_1_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_4_member_1_id"]];
    NSString *mirror_4_member_1_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_4_member_1_sts"]];
    
    NSString *mirror_5_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_5_id"]];
    NSString *mirror_5_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_5_sts"]];
    NSString *mirror_5_map = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_5_map"]];
    NSString *mirror_5_capacity = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_5_capacity"]];
    NSString *mirror_5_member_0_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_5_member_0_id"]];
    NSString *mirror_5_member_0_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_5_member_0_sts"]];
    NSString *mirror_5_member_1_id = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_5_member_1_id"]];
    NSString *mirror_5_member_1_sts = [NSString stringWithFormat:@"%@", [dict valueForKey:@"mirror_5_member_1_sts"]];
    */
    
    //NSString *mirrorStr = [NSString str]
    
    NSString *mirror = [NSString stringWithFormat:
                        @""
                        "Mirror state Map Capacity     Members\n"
                        "%-6s %-5s %-3s %-12s %-2s %-5s %-2s %-5s\n"
                        "%-6s %-5s %-3s %-12s %-2s %-5s %-2s %-5s\n"
                        "%-6s %-5s %-3s %-12s %-2s %-5s %-2s %-5s\n"
                        "%-6s %-5s %-3s %-12s %-2s %-5s %-2s %-5s\n",
                        /*
                        "%-6s %-5s %-3s %-12s %-2s %-5s %-2s %-5s\n"
                        "%-6s %-5s %-3s %-12s %-2s %-5s %-2s %-5s",*/
                        
    //NSString *mirror = [NSString stringWithFormat:
    //                    @"Mirror\tstate\tMap\tCapacity\t\tMembers \n"
    //                     "%s  %s  %s  %s  %s %s  %s %s",
                        
                        [mirror_0_id UTF8String],
                        [mirror_0_sts UTF8String],
                        [mirror_0_map UTF8String],
                        [mirror_0_capacity UTF8String],
                        [mirror_0_member_0_id UTF8String],
                        [mirror_0_member_0_sts UTF8String],
                        [mirror_0_member_1_id UTF8String],
                        [mirror_0_member_1_sts UTF8String] ,
                        
                        [mirror_1_id UTF8String],
                        [mirror_1_sts UTF8String],
                        [mirror_1_map UTF8String],
                        [mirror_1_capacity UTF8String],
                        [mirror_1_member_0_id UTF8String],
                        [mirror_1_member_0_sts UTF8String],
                        [mirror_1_member_1_id UTF8String],
                        [mirror_1_member_1_sts UTF8String],
                        
                        [mirror_2_id UTF8String],
                        [mirror_2_sts UTF8String],
                        [mirror_2_map UTF8String],
                        [mirror_2_capacity UTF8String],
                        [mirror_2_member_0_id UTF8String],
                        [mirror_2_member_0_sts UTF8String],
                        [mirror_2_member_1_id UTF8String],
                        [mirror_2_member_1_sts UTF8String],
                        
                        [mirror_3_id UTF8String],
                        [mirror_3_sts UTF8String],
                        [mirror_3_map UTF8String],
                        [mirror_3_capacity UTF8String],
                        [mirror_3_member_0_id UTF8String],
                        [mirror_3_member_0_sts UTF8String],
                        [mirror_3_member_1_id UTF8String],
                        [mirror_3_member_1_sts UTF8String]  /*,
                        
                        [mirror_4_id UTF8String],
                        [mirror_4_sts UTF8String],
                        [mirror_4_map UTF8String],
                        [mirror_4_capacity UTF8String],
                        [mirror_4_member_0_id UTF8String],
                        [mirror_4_member_0_sts UTF8String],
                        [mirror_4_member_1_id UTF8String],
                        [mirror_4_member_1_sts UTF8String],
                        
                        [mirror_5_id UTF8String],
                        [mirror_5_sts UTF8String],
                        [mirror_5_map UTF8String],
                        [mirror_5_capacity UTF8String],
                        [mirror_5_member_0_id UTF8String],
                        [mirror_5_member_0_sts UTF8String],
                        [mirror_5_member_1_id UTF8String],
                        [mirror_5_member_1_sts UTF8String]*/
                        ];
    
    NSLog(@"%@", mirror);
    
    return mirror;

 }

- (IBAction)showMirrorInfo:(id)sender {
    NSLog(@"%s", __func__);
    
    //NSString *lunNumStr = [sender restorationIdentifier];

    //NSString *mirrorShortInfo = [self getMirrorShortString:theDelegate.currentEngineLeftSerial byLunNum:lunNumStr];
    NSString *mirrorShortInfo = [self getMirrorShortString:engine00Mirror];
    
    hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //hud.hidden = FALSE;
    
    hud.frame = CGRectMake(0, 0, 10, 10);
    
    
    //[sender addTarget:self action:@selector(hideHud:) forControlEvents:UIControlEventTouchUpInside];
    
    //[sender addTarget:self action:@selector(hideHud:) forControlEvents:UIControlEventTouchUpInside];
    //UIView *customView = hud.customView;
    
    
    //UIControlEventTouchDown
    
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    NSString *strloadingText = [NSString stringWithFormat:@"%@-%@", theDelegate.currentEngineLeftSerial, theDelegate.currentEngineRightSerial];
    NSString *strloadingText2 = [NSString stringWithFormat:@"%@", mirrorShortInfo];// ;//] @" Please Wait.\r 1-2 Minutes"];
    
    //NSLog(@"the loading text will be %@",strloadingText);
    hud.labelText = strloadingText;
    hud.detailsLabelText=strloadingText2;
    
    NSLog(@"%s %@ %@", __func__, theDelegate.currentEngineLeftSerial, theDelegate.currentEngineRightSerial);
    
	hud.mode = MBProgressHUDModeText;
    //hud.mode = MBProgressHUDModeCustomView;
	//hud.labelText = @"Some message..Some message...";
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
    hud.backgroundColor = [UIColor clearColor];
    hud.labelFont = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];//[UIFont systemFontOfSize:25.0];
    //engine0mirror.font = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];
    
    hud.detailsLabelFont = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];//[UIFont systemFontOfSize:20.0];
    
    
    isHUDshowing = YES;
    //hud.l
    
    //NSInteger delaySec = 3.0;
    
    
	//[hud hide:YES afterDelay:delaySec];
    

}

/*
- (IBAction)hideMirrorInfo:(id)sender {
    NSLog(@"%s", __func__);
    NSLog(@"%s", __func__);
    NSInteger delaySec = 3;
	//[hud hide:YES afterDelay:delaySec];
}
 */


/*
- (IBAction)hideEngineInfo:(id)sender {
    NSLog(@"%s", __func__);
    NSInteger delaySec = 3;
	//[hud hide:YES afterDelay:delaySec];
    
	//[hud hide:YES afterDelay:delaySec];
    //hud.hidden = true;

}
 */

- (IBAction)showEngineInfo:(id)sender {
    NSLog(@"%s", __func__);
    
    NSString *engineSerial = nil;
    
    //UIButton *uiButton = (UIButton *)sender;
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:uiButton animated:YES];
    
    NSDictionary *vpd = nil;
    
    if ([[sender restorationIdentifier] isEqualToString:@"leftEngine"]) {
        engineSerial = theDelegate.currentEngineLeftSerial;
        vpd = engine00Vpd;
    } else {
        engineSerial = theDelegate.currentEngineRightSerial;
        vpd = engine01Vpd;
    }
    
    NSString *vpdInfo = [self getEngineVpdShortString:vpd];
    
    hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //hud.hidden = FALSE;
    
    
    hud.frame = CGRectMake(0, 0, 120, 143);
    
    
    //[sender addTarget:self action:@selector(hideHud:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    NSString *strloadingText = [NSString stringWithFormat:@"%@", engineSerial];
    NSString *strloadingText2 = [NSString stringWithFormat:@"%@", vpdInfo];// ;//] @" Please Wait.\r 1-2 Minutes"];
    
    NSLog(@"the loading text will be %@",strloadingText);
    hud.labelText = strloadingText;
    hud.detailsLabelText=strloadingText2;

    NSLog(@"%s %@ %@", __func__, theDelegate.currentEngineLeftSerial, theDelegate.currentEngineRightSerial);
    
	hud.mode = MBProgressHUDModeText;
    //hud.mode = MBProgressHUDModeCustomView;
	//hud.labelText = @"Some message..Some message...";
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
    hud.backgroundColor = [UIColor clearColor];
    hud.labelFont = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];//[UIFont systemFontOfSize:25.0];
    hud.detailsLabelFont = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];//[UIFont systemFontOfSize:20.0];
    
    
    isHUDshowing = YES;
    //hud.l
    
    //NSInteger delaySec = 3.0;
    
    
	//[hud hide:YES afterDelay:delaySec];

}

/*
- (IBAction)popover:(id)sender
{
    NSLog(@"%s %@, calss=%@", __func__, sender, [sender class]);
    
    UIButton *uiButton = (UIButton *)sender;
    
    
    //NSString *buttonTitle = uiButton.currentTitle;
    //NSLog(@"%s %@", __func__, buttonTitle);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:uiButton animated:YES];
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:button animated:YES];
    
	// Configure for text only and offset down
    //hud.mode = MBProgressHUDModeDeterminate;
	hud.mode = MBProgressHUDModeText;
    //hud.mode = MBProgressHUDModeCustomView;
	hud.labelText = @"Some message..Some message...";
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
    
    NSInteger delaySec = 3.0;
    
	[hud hide:YES afterDelay:delaySec];
    
    //int parameter1 = 12;
    //float parameter2 = 144.1;
    
    //NSLog(@"endf of %s %@", __func__, sender);

}
 */


- (void)onItemPress:(id)sender
{
    UIButton *theButon = (UIButton *)sender;
    
    NSLog(@"%s onItemPress: tag=%d", __func__, theButon.tag);
    
    /*
     if (theButon.tag == 201) { // RaidViewController
     [self presentViewController:self.raidViewController animated:YES completion:nil];
     } else if (theButon.tag == 202) { // MirrorViewController
     [self presentViewController:self.mirrorViewController animated:YES completion:nil];
     } else if (theButon.tag == 203) { // VolumeViewController
     [self presentViewController:self.volumeViewController animated:YES completion:nil];
     }
     */
    //HbaViewControllerID
    [self presentViewController:self.hbaViewController animated:YES completion:nil];
}

- (IBAction)reloadCarousel
{
    NSLog(@"%s", __func__);
    
    //[myNSMutableArray replaceObjectAtIndex:0 withObject:@\"object4.png\"];
    //NSInteger ok = 0;
    //NSInteger degarded = 1;
    //NSInteger died = 2;
    
    //NSNumber *okStatus = [NSNumber numberWithInt:ok];
    //NSNumber *degardedStatus = [NSNumber numberWithInt:degarded];
    //NSNumber *diedStatus = [NSNumber numberWithInt:died];
    
    //[statusArray replaceObjectAtIndex:10 withObject:degardedStatus];
    
    [carousel reloadData];
}

- (IBAction)updateValue:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    NSLog(@"%s %@ %@", __func__, sender, [sender restorationIdentifier]);
    
    NSString *identifier = [sender restorationIdentifier];
    
    if ([identifier isEqualToString:@"arcSlider"])
        arcValue.text = [NSString stringWithFormat:@"%1.2f", slider.value];
    else if ([identifier isEqualToString:@"radiusSlider"])
        radiusValue.text = [NSString stringWithFormat:@"%1.2f", slider.value];
    else if ([identifier isEqualToString:@"spacingSlider"])
        spacingValue.text = [NSString stringWithFormat:@"%1.2f", slider.value];
    else if ([identifier isEqualToString:@"sizingSlider"])
        sizingValue.text = [NSString stringWithFormat:@"%1.2f", slider.value];
}

- (IBAction)hideSlider:(id)sender
{
    [theDelegate hideShowSliders:self.view];
}


#pragma mark -
#pragma mark iCarousel methods

#pragma mark - iCarousel datasource and delegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSLog(@"%s count=%d", __func__, [descriptions count]);
    return [descriptions count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    NSLog(@"%s index=%u %@", __func__, index, [descriptions objectAtIndex:index]);
    UILabel *theLabel = nil;
    //NSInteger status = [[statusArray objectAtIndex:index] integerValue];
    
	//create new view if no view is available for recycling
	if (view == nil)
	{
        UIButton *theButton;
        view = [[UIView alloc] init];
        //view.backgroundColor = [UIColor redColor];
        
        UIImage *theItemImage = nil;
        
        theItemImage = [UIImage imageNamed:@"Device-PC.png"];
        
        /*
        switch (status) {
            case 0: // healthy
                theItemImage = [UIImage imageNamed:@"Device-HA-Appliance-healthy"];
                break;
            case 1: // degarded
                theItemImage = [UIImage imageNamed:@"HA-item-orange"];
                break;
            case 2: // died
                theItemImage = [UIImage imageNamed:@"HA-item-blackwhite"];
                break;
            default:
                break;
        }
         */
        
        theLabel = [[UILabel alloc] init];
        theLabel.numberOfLines = 0;
        theLabel.textColor = [UIColor darkGrayColor];
        
        float itemWidth, itemHeight;
        
        itemWidth = theItemImage.size.width; // 250px
        itemHeight = theItemImage.size.height;
        
        theButton = [UIButton buttonWithType:UIButtonTypeCustom];
        theButton.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        //theButton.tag = ITEM_BUTTON_START_TAG + index;
        [theButton addTarget:self action:@selector(onItemPress:) forControlEvents:UIControlEventTouchUpInside];
        
        theLabel.frame = CGRectMake(0, itemHeight, itemWidth, 40);
        //theLabel.alpha = 0.5;
        theLabel.backgroundColor = [UIColor clearColor];
        //theLabel.backgroundColor = [UIColor yellowColor];
        theLabel.textAlignment = NSTextAlignmentCenter;
        theLabel.tag = 1;
        
        //NSLog(@"theButton.tag=%u", theButton.tag);
        
        view.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        [view addSubview:theButton];
        [view addSubview:theLabel];
        //define button handler
        [theButton setImage:theItemImage forState:UIControlStateNormal];
    }
    else
	{
        theLabel = (UILabel *)[view viewWithTag:1];
	}
    
    //theLabel.text = [descriptions objectAtIndex:index];
    
	return view;
}



- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"carousel:didSelectItemAtIndex:  %d",index);
    
    [self presentViewController:self.hbaViewController animated:YES completion:nil];

}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)_carousel
{
    //currentItemIndex = _carousel.currentItemIndex;
    
    //[theDelegate updateItemIndexCountsAndTotalLabel:currentItemIndex count:currentCollectionCount total:totalCount forUILabel:itemIndexCountsAndTotalLabel];
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //NSLog(@"%s %f", __func__, value);
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return TRUE;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionArc:
        {
            return 2 * M_PI * arcSlider.value;
        }
        case iCarouselOptionRadius:
        {
            return value * radiusSlider.value;
        }
        case iCarouselOptionSpacing:
        {
            //NSLog(@"iCarouselOptionSpacing=%f", spacingSlider.value);
            return value * spacingSlider.value;
        }
        default:
        {
            return value;
        }
    }
}



@end
