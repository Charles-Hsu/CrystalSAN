//
//  HAApplianceViewClusterController.m
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Charles Hsu. All rights reserved.
//

#import "HAApplianceClusterViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"


#define ITEM_BUTTON_START_TAG_RAIDVIEW 300

@interface HAApplianceClusterViewController () {

    AppDelegate *theDelegate;
}

@end

@implementation HAApplianceClusterViewController

@synthesize haApplianceName;

@synthesize engine0Serial, engine0Vpd;
@synthesize engine1Serial, engine1Vpd;

//@synthesize deviceName, deviceLabel;

/*
- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"%s", __func__);

    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //set up carousel data
        //carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 110, 1024, 460)];
        //carousel.backgroundColor = [UIColor cyanColor];
        
    }
    return self;
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //NSLog(@"deviceName=%@", deviceName);
    //deviceName = [deviceName stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    
    //[deviceLabel setText:[NSString stringWithFormat:@"%@", deviceName]];
    //deviceLabel.numberOfLines = 0;
    
    theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //theDelegate.currentSegueID = @"RaidViewConfigID";
    //theDelegate.currentDeviceName = deviceName;
    
    self.haApplianceName.text = theDelegate.currentDeviceName;
    NSArray *engines = [theDelegate.sanDatabase getEnginesByHaApplianceName:(self.haApplianceName.text)];
    NSLog(@"%s %@", __func__, engines);
    
    if ([engines count] == 2) {
        self.engine0Serial.text = [engines objectAtIndex:0];
        self.engine1Serial.text = [engines objectAtIndex:1];
        
        theDelegate.currentEngineLeftSerial = [engines objectAtIndex:0];
        theDelegate.currentEngineRightSerial = [engines objectAtIndex:1];

    }
    
    //[self displayEngine00VpdInformation:[engines objectAtIndex:0]];
    //[self displayEngine01VpdInformation:[engines objectAtIndex:1]];
    
    engine0Vpd.text = [self getVpdInformationBySerial:[engines objectAtIndex:0]];
    engine1Vpd.text = [self getVpdInformationBySerial:[engines objectAtIndex:1]];
    engine0Vpd.font = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];
    engine1Vpd.font = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];

    
    
    //NSDictionary *engine01Mirror = [theDelegate.sanDatabase getEngineCliMirrorDictBySerial:theDelegate.currentEngineRightSerial];
    

}

- (NSString *)getDriveArraryString:(NSArray *)dictArray {
    NSMutableString *strings = [[NSMutableString alloc] init];
    [strings appendFormat:@"%@\n",[theDelegate.sanDatabase getEngineDriveShortStringtTitle]];
    for (int i=0; i < [dictArray count]; i++) {
        [strings appendFormat:@"%@\n", [theDelegate.sanDatabase getEngineDriveShortString:[dictArray objectAtIndex:i]]];
    }
    return strings;
}

- (NSString *)getVpdInformationBySerial:(NSString *)serial
{
    /*
     Product Type : FCE4400
     
     Apple Release
     128 HBA support
     All active/passive drives are assumed to be FastT compatible.
     Firmware V15.1.10	VCMSVMIR Official Release
     Revision Data : Vicom(release), Sep 17 2012 16:56:07
     (C) 1995-2012 Vicom Systems, Inc. All Rights Reserved.
     Redboot(tm) version: 0.2.0.5
     
     Unique ID          : 00000060-22092836
     Unit Serial Number : 00600118
     PCB Number         : 00600118
     MAC address        : 0.60.22.9.28.36
     IP address         : 10.100.5.227
     
     Uptime             : 106d 20:04:03
     
     Alert: None
     Wednesday, 1/30/2013, 04:54:20
     
     Port  Node Name           Port Name
     A1    2000-006022-092836  2100-006022-092836
     A2    2000-006022-092836  2200-006022-092836
     B1    2000-006022-092836  2300-006022-092836
     B2    2000-006022-092836  2400-006022-092836
     */
    
    
    NSDictionary *vpd = [theDelegate.sanDatabase getVpdBySerial:serial];
    NSString *isMaster = [theDelegate.sanDatabase isMasterEngine:serial];
    NSDictionary *mirrorDict = [theDelegate.sanDatabase getEngineCliMirrorDictBySerial:serial];
    
    NSArray *driveArray = [theDelegate.sanDatabase getConmgrDriveStatusByEngineSerial:serial];

    
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
    
    
    NSString *productType = [vpd valueForKey:@"product_type"];
    NSString *firmware = [vpd valueForKey:@"fw_version"];
    NSString *revision = [vpd valueForKey:@"fw_date"];
    NSString *redboot = [vpd valueForKey:@"redboot"];
    NSString *uid = [vpd valueForKey:@"uid"];
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
                               @"Product Type : %@ \n"
                               @"Engine       : %@\n"
                               " \n"
                               //"Apple Release\n"
                               //"128 HBA support\n"
                               //"All active/passive drives are assumed to be FastT compatible.\n"
                               "Firmware V%@	VCMSVMIR Official Release\n"
                               "Revision Data : Vicom(release), %@\n"
                               //"(C) 1995-2012 Vicom Systems, Inc. All Rights Reserved.\n"
                               "Redboot(tm) version: %@\n"
                               " \n"
                               "Unique ID          : %@\n"
                               "Unit Serial Number : %@\n"
                               "PCB Number         : %@\n"
                               "MAC address        : %@\n"
                               "IP address         : %@\n"
                               //" \n"
                               "Uptime             : %@\n"
                               //" \n"
                               "Alert: %@\n"
                               "%@\n"
                               " \n"
                               "Port  Node Name           Port Name\n"
                               "A1    %@  %@\n"
                               "A2    %@  %@\n"
                               "B1    %@  %@\n"
                               "B2    %@  %@\n"
                               "\n"
                               "%@\n"
                               "%@",
                               productType,
                               isMaster,
                               firmware,
                               revision,
                               redboot,
                               uid,
                               serial,
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
                               b2_wwpn,
                               [theDelegate.sanDatabase getEngineMirrorShortString:mirrorDict],
                               [self getDriveArraryString:driveArray]];
        
        return vpdString;

    } else if ([productType isEqualToString:@"FC"]) {
        
        /*
         
         ****** Storage Mirroring Engine VPD ******
         
         Product Type : FC-FC-5 SVE H - DX4
         SAN Mirror Release
         128 HBA support
         All active/passive drives are assumed to be FastT compatible.
         FC-FC-5 SVE H Firmware Revision : 11.1.2.9	VCMSSVME Official Release
         Revision Data : Vicom(release), Feb 28 2011 16:38:20
         (C) 1995-2010 Vicom Systems, Inc. All Rights Reserved.
         Redboot(tm) version: 0.1.9.1
         
         Unique ID          : 00000060-2207A24D
         Unit Serial Number : 00500301
         PCB Number         : 00500301
         MAC address        : 0.60.22.7.A2.4D
         IP address         : 10.100.5.216
         
         Uptime             : 156d 02:36:25
         
         Alert: None
         
         Port  Node Name           Port Name
         B    2000-006022-07a24d  2100-006022-07a24d
         A    2000-006022-07a24c  2200-006022-07a24d
         
         */

        
        NSString *vpdString = [NSString stringWithFormat:
                               @"Product Type : %@ \n"
                               @"Engine       : %@\n\n"
                               //"SAN Mirror Release\n"
                               //"128 HBA support\n"
                               //"All active/passive drives are assumed to be FastT compatible.\n"
                               "%@ Firmware Revision : 11.1.2.9 VCMSVMIR Official Release\n"
                               "Revision Data : Vicom(release), %@\n"
                               //"(C) 1995-2010 Vicom Systems, Inc. All Rights Reserved.\n"
                               "Redboot(tm) version: %@\n"
                               " \n"
                               "Unique ID          : %@\n"
                               "Unit Serial Number : %@\n"
                               "PCB Number         : %@\n"
                               "MAC address        : %@\n"
                               "IP address         : %@\n"
                               //" \n"
                               "Uptime             : %@\n"
                               //" \n"
                               "Alert: %@\n"
                               "\n"
                               "Port  Node Name           Port Name\n"
                               "A     %@  %@\n"
                               "B     %@  %@\n",
                               productType,
                               isMaster,
                               firmware,
                               revision,
                               redboot,
                               uid,
                               serial,
                               pcb,
                               mac,
                               ip,
                               uptime,
                               alert,
                               a1_wwnn,
                               a1_wwpn,
                               b1_wwnn,
                               b1_wwpn];
        
        return vpdString;

    }
    
    return nil;
    
    
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
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
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




@end
