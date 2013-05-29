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
@synthesize siteNameLabel;


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
    [theDelegate.syncManager updateEngineVpdInfo:theDelegate.currentHAApplianceName];

    //theDelegate.currentSegueID = @"RaidViewConfigID";
    //theDelegate.currentDeviceName = deviceName;
    
    /*
    self.haApplianceName.text = theDelegate.currentHAApplianceName;
    
    NSLog(@"%s %@", __func__, self.haApplianceName.text);
    
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
    
    [theDelegate.sanDatabase httpGetEngineCliVpdBySiteName:theDelegate.siteName serial:[engines objectAtIndex:0]];
    [theDelegate.sanDatabase httpGetEngineCliVpdBySiteName:theDelegate.siteName serial:[engines objectAtIndex:1]];
    
    engine0Vpd.text = [self getVpdInformationBySerial:[engines objectAtIndex:0]];
    engine1Vpd.text = [self getVpdInformationBySerial:[engines objectAtIndex:1]];
    engine0Vpd.font = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];
    engine1Vpd.font = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];
    
    
    //NSDictionary *engine01Mirror = [theDelegate.sanDatabase getEngineCliMirrorDictBySerial:theDelegate.currentEngineRightSerial];
    
     */
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%s", __func__);
    self.haApplianceName.text = theDelegate.currentHAApplianceName;
    
    NSLog(@"%s %@", __func__, self.haApplianceName.text);
    
    NSArray *engines = [theDelegate.sanDatabase getEnginesByHaApplianceName:(self.haApplianceName.text)];
    NSLog(@"%s %@", __func__, engines);
    
    if ([engines count] == 2) {
        self.engine0Serial.text = [engines objectAtIndex:0];
        self.engine1Serial.text = [engines objectAtIndex:1];
        
        theDelegate.currentEngineLeftSerial = [engines objectAtIndex:0];
        theDelegate.currentEngineRightSerial = [engines objectAtIndex:1];
        
    }
    //[theDelegate.sanDatabase httpGetEngineCliVpdBySiteName:theDelegate.siteName serial:[engines objectAtIndex:0]];
    //[theDelegate.sanDatabase httpGetEngineCliVpdBySiteName:theDelegate.siteName serial:[engines objectAtIndex:1]];
    
    //[theDelegate.syncManager checkForUpdate:];
    
    engine0Vpd.text = [self getVpdInformationBySerial:[engines objectAtIndex:0]];
    engine1Vpd.text = [self getVpdInformationBySerial:[engines objectAtIndex:1]];
    engine0Vpd.font = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];
    engine1Vpd.font = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];
    
    self.siteNameLabel.text = theDelegate.siteName;
    


}





- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%s", __func__);
}

- (NSString *)getDriveArraryString:(NSArray *)dictArray {
    NSMutableString *strings = [[NSMutableString alloc] init];
    [strings appendFormat:@"%@\n",@"Target status port Storage WWPN       LUN  status"];
    for (int i=0; i < [dictArray count]; i++) {
        [strings appendFormat:@"%@\n", [theDelegate.sanDatabase getEngineDriveShortString:[dictArray objectAtIndex:i]]];
    }
    return strings;
}

- (NSString *)getVpdInformationBySerial:(NSString *)serial
{
    NSDictionary *mirrorDict = [theDelegate.sanDatabase getEngineCliMirrorDictBySerial:serial];
    NSArray *driveArray = [theDelegate.sanDatabase getConmgrDriveStatusByEngineSerial:serial];
    NSString *vpdString = [NSString stringWithFormat:
                           @"%@\n\n%@\n%@",
                           [theDelegate.sanDatabase getEngineVpdString:serial isShort:FALSE],
                           [theDelegate.sanDatabase getEngineMirrorShortString:mirrorDict],
                           [self getDriveArraryString:driveArray]];
    return vpdString;
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
