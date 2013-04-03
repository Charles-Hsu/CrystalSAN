//
//  HAApplianceMirrorViewController.m
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Charles Hsu. All rights reserved.
//

#import "HAApplianceMirrorViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"


#define ITEM_BUTTON_START_TAG_RAIDVIEW 300

@interface HAApplianceMirrorViewController () {
    AppDelegate *theDelegate;
}

@end

@implementation HAApplianceMirrorViewController

@synthesize engine0Serial, engine0mirror;
@synthesize engine1Serial, engine1mirror;
@synthesize haApplianceName;


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
    }
    
    [self displayEngine00MirrorInformation:[engines objectAtIndex:0]];
    [self displayEngine01MirrorInformation:[engines objectAtIndex:1]];
    
    engine0mirror.text = [self getEngineMirrorString:[engines objectAtIndex:0]];
    engine1mirror.text = [self getEngineMirrorString:[engines objectAtIndex:1]];
    
    engine0mirror.font = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];
    engine1mirror.font = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];
    

}

- (NSString *)getEngineMirrorString:(NSString *)serial
{
    /*
     Mirror(hex)    state       Map         Capacity  Members
     33537(0x8301) Operational   0      13672091475  0 (OK )  2 (OK )
     33538(0x8302) Operational   1      13672091475  3 (OK )  1 (OK )
     33539(0x8303) Operational   2      13672091475  4 (OK )  6 (OK )
     33540(0x8304) Operational   3      13672091475  7 (OK )  5 (OK )     */
    
    //
    // http://stackoverflow.com/questions/7633664/declare-a-nsstring-in-multiple-lines
    // Declare a NSString in multiple lines
    //
    
    NSDictionary *dict = [theDelegate.sanDatabase getEngineCliMirrorDictBySerial:serial];
    
    /*
     
     "mirror_0_capacity" = 976748544;
     "mirror_0_id" = 33537;
     "mirror_0_map" = 0;
     "mirror_0_member_0_id" = 5;
     "mirror_0_member_0_sts" = OK;
     "mirror_0_member_1_id" = 4;
     "mirror_0_member_1_sts" = OK;
     "mirror_0_sts" = Good;
     "mirror_1_capacity" = 976748544;
     "mirror_1_id" = 33538;
     "mirror_1_map" = 1;
     "mirror_1_member_0_id" = 9;
     "mirror_1_member_0_sts" = OK;
     "mirror_1_member_1_id" = 8;
     "mirror_1_member_1_sts" = OK;
     "mirror_1_sts" = Good;
     "mirror_2_capacity" = 876952832;
     "mirror_2_id" = 33539;
     "mirror_2_map" = 2;
     "mirror_2_member_0_id" = 1;
     "mirror_2_member_0_sts" = OK;
     "mirror_2_member_1_id" = 0;
     "mirror_2_member_1_sts" = OK;
     "mirror_2_sts" = Good;
     "mirror_3_capacity" = 876952832;
     "mirror_3_id" = 33540;
     "mirror_3_map" = 3;
     "mirror_3_member_0_id" = 3;
     "mirror_3_member_0_sts" = OK;
     "mirror_3_member_1_id" = 2;
     "mirror_3_member_1_sts" = OK;
     "mirror_3_sts" = Good;
     "mirror_4_capacity" = "";
     "mirror_4_id" = "";
     "mirror_4_map" = "";
     "mirror_4_member_0_id" = "";
     "mirror_4_member_0_sts" = "";
     "mirror_4_member_1_id" = "";
     "mirror_4_member_1_sts" = "";
     "mirror_4_sts" = "";
     "mirror_5_capacity" = "";
     "mirror_5_id" = "";
     "mirror_5_map" = "";
     "mirror_5_member_0_id" = "";
     "mirror_5_member_0_sts" = "";
     "mirror_5_member_1_id" = "";
     "mirror_5_member_1_sts" = "";
     "mirror_5_sts" = "";
     "mirror_degraded" = 0;
     "mirror_failed" = 0;
     "mirror_ok" = 4;
     seconds = 1363746626;
     serial = 00600474;

     */
    NSString *mirror_0_id = [dict valueForKey:@"mirror_0_id"];
    NSString *mirror_0_sts = [dict valueForKey:@"mirror_0_sts"];
    NSString *mirror_0_map = [dict valueForKey:@"mirror_0_map"];
    NSString *mirror_0_capacity = [dict valueForKey:@"mirror_0_capacity"];
    NSString *mirror_0_member_0_id = [dict valueForKey:@"mirror_0_member_0_id"];
    NSString *mirror_0_member_0_sts = [dict valueForKey:@"mirror_0_member_0_sts"];
    NSString *mirror_0_member_1_id = [dict valueForKey:@"mirror_0_member_1_id"];
    NSString *mirror_0_member_1_sts = [dict valueForKey:@"mirror_0_member_1_sts"];
    
    NSString *mirror_1_id = [dict valueForKey:@"mirror_1_id"];
    NSString *mirror_1_sts = [dict valueForKey:@"mirror_1_sts"];
    NSString *mirror_1_map = [dict valueForKey:@"mirror_1_map"];
    NSString *mirror_1_capacity = [dict valueForKey:@"mirror_1_capacity"];
    NSString *mirror_1_member_0_id = [dict valueForKey:@"mirror_1_member_0_id"];
    NSString *mirror_1_member_0_sts = [dict valueForKey:@"mirror_1_member_0_sts"];
    NSString *mirror_1_member_1_id = [dict valueForKey:@"mirror_1_member_1_id"];
    NSString *mirror_1_member_1_sts = [dict valueForKey:@"mirror_1_member_1_sts"];
    
    NSString *mirror_2_id = [dict valueForKey:@"mirror_2_id"];
    NSString *mirror_2_sts = [dict valueForKey:@"mirror_2_sts"];
    NSString *mirror_2_map = [dict valueForKey:@"mirror_2_map"];
    NSString *mirror_2_capacity = [dict valueForKey:@"mirror_2_capacity"];
    NSString *mirror_2_member_0_id = [dict valueForKey:@"mirror_2_member_0_id"];
    NSString *mirror_2_member_0_sts = [dict valueForKey:@"mirror_2_member_0_sts"];
    NSString *mirror_2_member_1_id = [dict valueForKey:@"mirror_2_member_1_id"];
    NSString *mirror_2_member_1_sts = [dict valueForKey:@"mirror_2_member_1_sts"];
    
    NSString *mirror_3_id = [dict valueForKey:@"mirror_3_id"];
    NSString *mirror_3_sts = [dict valueForKey:@"mirror_3_sts"];
    NSString *mirror_3_map = [dict valueForKey:@"mirror_3_map"];
    NSString *mirror_3_capacity = [dict valueForKey:@"mirror_3_capacity"];
    NSString *mirror_3_member_0_id = [dict valueForKey:@"mirror_3_member_0_id"];
    NSString *mirror_3_member_0_sts = [dict valueForKey:@"mirror_3_member_0_sts"];
    NSString *mirror_3_member_1_id = [dict valueForKey:@"mirror_3_member_1_id"];
    NSString *mirror_3_member_1_sts = [dict valueForKey:@"mirror_3_member_1_sts"];
    
    NSString *mirror_4_id = [dict valueForKey:@"mirror_4_id"];
    NSString *mirror_4_sts = [dict valueForKey:@"mirror_4_sts"];
    NSString *mirror_4_map = [dict valueForKey:@"mirror_4_map"];
    NSString *mirror_4_capacity = [dict valueForKey:@"mirror_4_capacity"];
    NSString *mirror_4_member_0_id = [dict valueForKey:@"mirror_4_member_0_id"];
    NSString *mirror_4_member_0_sts = [dict valueForKey:@"mirror_4_member_0_sts"];
    NSString *mirror_4_member_1_id = [dict valueForKey:@"mirror_4_member_1_id"];
    NSString *mirror_4_member_1_sts = [dict valueForKey:@"mirror_4_member_1_sts"];
    
    NSString *mirror_5_id = [dict valueForKey:@"mirror_5_id"];
    NSString *mirror_5_sts = [dict valueForKey:@"mirror_5_sts"];
    NSString *mirror_5_map = [dict valueForKey:@"mirror_5_map"];
    NSString *mirror_5_capacity = [dict valueForKey:@"mirror_5_capacity"];
    NSString *mirror_5_member_0_id = [dict valueForKey:@"mirror_5_member_0_id"];
    NSString *mirror_5_member_0_sts = [dict valueForKey:@"mirror_5_member_0_sts"];
    NSString *mirror_5_member_1_id = [dict valueForKey:@"mirror_5_member_1_id"];
    NSString *mirror_5_member_1_sts = [dict valueForKey:@"mirror_5_member_1_sts"];
    
    NSString *mirror = [NSString stringWithFormat:
                        @"Mirror\tstate\tMap\tCapacity\tMembers \n"
                        "%@\t%@\t%@\t%@\t%@ %@\t%@ %@\n"
                        "%@\t%@\t%@\t%@\t%@ %@\t%@ %@\n"
                        "%@\t%@\t%@\t%@\t%@ %@\t%@ %@\n"
                        "%@\t%@\t%@\t%@\t%@ %@\t%@ %@\n"
                        "%@\t%@\t%@\t%@\t%@ %@\t%@ %@\n"
                        "%@\t%@\t%@\t%@\t%@ %@\t%@ %@\n",
                        
                        mirror_0_id,
                        mirror_0_sts,
                        mirror_0_map,
                        mirror_0_capacity,
                        mirror_0_member_0_id,
                        mirror_0_member_0_sts,
                        mirror_0_member_1_id,
                        mirror_0_member_1_sts,
                        
                        mirror_1_id,
                        mirror_1_sts,
                        mirror_1_map,
                        mirror_1_capacity,
                        mirror_1_member_0_id,
                        mirror_1_member_0_sts,
                        mirror_1_member_1_id,
                        mirror_1_member_1_sts,
                        
                        mirror_2_id,
                        mirror_2_sts,
                        mirror_2_map,
                        mirror_2_capacity,
                        mirror_2_member_0_id,
                        mirror_2_member_0_sts,
                        mirror_2_member_1_id,
                        mirror_2_member_1_sts,
                        
                        mirror_3_id,
                        mirror_3_sts,
                        mirror_3_map,
                        mirror_3_capacity,
                        mirror_3_member_0_id,
                        mirror_3_member_0_sts,
                        mirror_3_member_1_id,
                        mirror_3_member_1_sts,
                        
                        mirror_4_id,
                        mirror_4_sts,
                        mirror_4_map,
                        mirror_4_capacity,
                        mirror_4_member_0_id,
                        mirror_4_member_0_sts,
                        mirror_4_member_1_id,
                        mirror_4_member_1_sts,
                        
                        mirror_5_id,
                        mirror_5_sts,
                        mirror_5_map,
                        mirror_5_capacity,
                        mirror_5_member_0_id,
                        mirror_5_member_0_sts,
                        mirror_5_member_1_id,
                        mirror_5_member_1_sts
                        ];
    
    return mirror;
}

- (void)displayEngine00MirrorInformation:(NSString *)serial
{
    /*
     Mirror(hex)    state       Map         Capacity  Members
     33537(0x8301) Operational   0      13672091475  0 (OK )  2 (OK )
     33538(0x8302) Operational   1      13672091475  3 (OK )  1 (OK )
     33539(0x8303) Operational   2      13672091475  4 (OK )  6 (OK )
     33540(0x8304) Operational   3      13672091475  7 (OK )  5 (OK )
     
     */
    
    //
    // http://stackoverflow.com/questions/7633664/declare-a-nsstring-in-multiple-lines
    // Declare a NSString in multiple lines
    //
    
    NSString *mirror_0_id = @"33537";
    NSString *mirror_0_sts = @"Good";
    NSString *mirror_0_map = @"0";
    NSString *mirror_0_capacity = @"976748544";
    NSString *mirror_0_member_0_id = @"5";
    NSString *mirror_0_member_0_sts = @"OK";
    NSString *mirror_0_member_1_id = @"4";
    NSString *mirror_0_member_1_sts = @"OK";

    NSString *mirror_1_id = @"33537";
    NSString *mirror_1_sts = @"Good";
    NSString *mirror_1_map = @"0";
    NSString *mirror_1_capacity = @"976748544";
    NSString *mirror_1_member_0_id = @"5";
    NSString *mirror_1_member_0_sts = @"OK";
    NSString *mirror_1_member_1_id = @"4";
    NSString *mirror_1_member_1_sts = @"OK";

    NSString *mirror_2_id = @"33537";
    NSString *mirror_2_sts = @"Good";
    NSString *mirror_2_map = @"0";
    NSString *mirror_2_capacity = @"976748544";
    NSString *mirror_2_member_0_id = @"5";
    NSString *mirror_2_member_0_sts = @"OK";
    NSString *mirror_2_member_1_id = @"4";
    NSString *mirror_2_member_1_sts = @"OK";

    NSString *mirror_3_id = @"33537";
    NSString *mirror_3_sts = @"Good";
    NSString *mirror_3_map = @"0";
    NSString *mirror_3_capacity = @"976748544";
    NSString *mirror_3_member_0_id = @"5";
    NSString *mirror_3_member_0_sts = @"OK";
    NSString *mirror_3_member_1_id = @"4";
    NSString *mirror_3_member_1_sts = @"OK";

    NSString *mirror_4_id = @"33537";
    NSString *mirror_4_sts = @"Good";
    NSString *mirror_4_map = @"0";
    NSString *mirror_4_capacity = @"976748544";
    NSString *mirror_4_member_0_id = @"5";
    NSString *mirror_4_member_0_sts = @"OK";
    NSString *mirror_4_member_1_id = @"4";
    NSString *mirror_4_member_1_sts = @"OK";

    NSString *mirror_5_id = @"33537";
    NSString *mirror_5_sts = @"Good";
    NSString *mirror_5_map = @"0";
    NSString *mirror_5_capacity = @"976748544";
    NSString *mirror_5_member_0_id = @"5";
    NSString *mirror_5_member_0_sts = @"OK";
    NSString *mirror_5_member_1_id = @"4";
    NSString *mirror_5_member_1_sts = @"OK";

    NSString *mirror = [NSString stringWithFormat:
                        @"Mirror\tState\t\tMap\tCapacity\t\tMembers \n"
                        "%@\t%@\t%@\t%@\t%@ (%@)\t%@ (%@)\n"
                        "%@\t%@\t%@\t%@\t%@ (%@)\t%@ (%@)\n"
                        "%@\t%@\t%@\t%@\t%@ (%@)\t%@ (%@)\n"
                        "%@\t%@\t%@\t%@\t%@ (%@)\t%@ (%@)\n"
                        "%@\t%@\t%@\t%@\t%@ (%@)\t%@ (%@)\n"
                        "%@\t%@\t%@\t%@\t%@ (%@)\t%@ (%@)\n",
                        
                        mirror_0_id,
                        mirror_0_sts,
                        mirror_0_map,
                        mirror_0_capacity,
                        mirror_0_member_0_id,
                        mirror_0_member_0_sts,
                        mirror_0_member_1_id,
                        mirror_0_member_1_sts,

                        mirror_1_id,
                        mirror_1_sts,
                        mirror_1_map,
                        mirror_1_capacity,
                        mirror_1_member_0_id,
                        mirror_1_member_0_sts,
                        mirror_1_member_1_id,
                        mirror_1_member_1_sts,
                        
                        mirror_2_id,
                        mirror_2_sts,
                        mirror_2_map,
                        mirror_2_capacity,
                        mirror_2_member_0_id,
                        mirror_2_member_0_sts,
                        mirror_2_member_1_id,
                        mirror_2_member_1_sts,
                        
                        mirror_3_id,
                        mirror_3_sts,
                        mirror_3_map,
                        mirror_3_capacity,
                        mirror_3_member_0_id,
                        mirror_3_member_0_sts,
                        mirror_3_member_1_id,
                        mirror_3_member_1_sts,
                        
                        mirror_4_id,
                        mirror_4_sts,
                        mirror_4_map,
                        mirror_4_capacity,
                        mirror_4_member_0_id,
                        mirror_4_member_0_sts,
                        mirror_4_member_1_id,
                        mirror_4_member_1_sts,
                       
                        mirror_5_id,
                        mirror_5_sts,
                        mirror_5_map,
                        mirror_5_capacity,
                        mirror_5_member_0_id,
                        mirror_5_member_0_sts,
                        mirror_5_member_1_id,
                        mirror_5_member_1_sts
                                          ];
    
    engine0mirror.text = mirror;
    
}

- (void)displayEngine01MirrorInformation:(NSString *)serial
{
    /*
     Mirror(hex)    state       Map         Capacity  Members
     33537(0x8301) Operational   0      13672091475  0 (OK )  2 (OK )
     33538(0x8302) Operational   1      13672091475  3 (OK )  1 (OK )
     33539(0x8303) Operational   2      13672091475  4 (OK )  6 (OK )
     33540(0x8304) Operational   3      13672091475  7 (OK )  5 (OK )
     
     */
    
    //
    // http://stackoverflow.com/questions/7633664/declare-a-nsstring-in-multiple-lines
    // Declare a NSString in multiple lines
    //
    
    NSString *mirror_0_id = @"33537";
    NSString *mirror_0_sts = @"Good";
    NSString *mirror_0_map = @"0";
    NSString *mirror_0_capacity = @"976748544";
    NSString *mirror_0_member_0_id = @"5";
    NSString *mirror_0_member_0_sts = @"OK";
    NSString *mirror_0_member_1_id = @"4";
    NSString *mirror_0_member_1_sts = @"OK";
    
    NSString *mirror_1_id = @"33537";
    NSString *mirror_1_sts = @"Good";
    NSString *mirror_1_map = @"0";
    NSString *mirror_1_capacity = @"976748544";
    NSString *mirror_1_member_0_id = @"5";
    NSString *mirror_1_member_0_sts = @"OK";
    NSString *mirror_1_member_1_id = @"4";
    NSString *mirror_1_member_1_sts = @"OK";
    
    NSString *mirror_2_id = @"33537";
    NSString *mirror_2_sts = @"Good";
    NSString *mirror_2_map = @"0";
    NSString *mirror_2_capacity = @"976748544";
    NSString *mirror_2_member_0_id = @"5";
    NSString *mirror_2_member_0_sts = @"OK";
    NSString *mirror_2_member_1_id = @"4";
    NSString *mirror_2_member_1_sts = @"OK";
    
    NSString *mirror_3_id = @"33537";
    NSString *mirror_3_sts = @"Good";
    NSString *mirror_3_map = @"0";
    NSString *mirror_3_capacity = @"976748544";
    NSString *mirror_3_member_0_id = @"5";
    NSString *mirror_3_member_0_sts = @"OK";
    NSString *mirror_3_member_1_id = @"4";
    NSString *mirror_3_member_1_sts = @"OK";
    
    NSString *mirror_4_id = @"33537";
    NSString *mirror_4_sts = @"Good";
    NSString *mirror_4_map = @"0";
    NSString *mirror_4_capacity = @"976748544";
    NSString *mirror_4_member_0_id = @"5";
    NSString *mirror_4_member_0_sts = @"OK";
    NSString *mirror_4_member_1_id = @"4";
    NSString *mirror_4_member_1_sts = @"OK";
    
    NSString *mirror_5_id = @"33537";
    NSString *mirror_5_sts = @"Good";
    NSString *mirror_5_map = @"0";
    NSString *mirror_5_capacity = @"976748544";
    NSString *mirror_5_member_0_id = @"5";
    NSString *mirror_5_member_0_sts = @"OK";
    NSString *mirror_5_member_1_id = @"4";
    NSString *mirror_5_member_1_sts = @"OK";
    
    NSString *mirror = [NSString stringWithFormat:
                        @"Mirror\tstate\tMap\tCapacity\t\tMembers \n"
                        "%@\t%@\t%@\t%@\t%@ (%@)\t%@ (%@)\n"
                        "%@\t%@\t%@\t%@\t%@ (%@)\t%@ (%@)\n"
                        "%@\t%@\t%@\t%@\t%@ (%@)\t%@ (%@)\n"
                        "%@\t%@\t%@\t%@\t%@ (%@)\t%@ (%@)\n"
                        "%@\t%@\t%@\t%@\t%@ (%@)\t%@ (%@)\n"
                        "%@\t%@\t%@\t%@\t%@ (%@)\t%@ (%@)\n",
                        
                        mirror_0_id,
                        mirror_0_sts,
                        mirror_0_map,
                        mirror_0_capacity,
                        mirror_0_member_0_id,
                        mirror_0_member_0_sts,
                        mirror_0_member_1_id,
                        mirror_0_member_1_sts,
                        
                        mirror_1_id,
                        mirror_1_sts,
                        mirror_1_map,
                        mirror_1_capacity,
                        mirror_1_member_0_id,
                        mirror_1_member_0_sts,
                        mirror_1_member_1_id,
                        mirror_1_member_1_sts,
                        
                        mirror_2_id,
                        mirror_2_sts,
                        mirror_2_map,
                        mirror_2_capacity,
                        mirror_2_member_0_id,
                        mirror_2_member_0_sts,
                        mirror_2_member_1_id,
                        mirror_2_member_1_sts,
                        
                        mirror_3_id,
                        mirror_3_sts,
                        mirror_3_map,
                        mirror_3_capacity,
                        mirror_3_member_0_id,
                        mirror_3_member_0_sts,
                        mirror_3_member_1_id,
                        mirror_3_member_1_sts,
                        
                        mirror_4_id,
                        mirror_4_sts,
                        mirror_4_map,
                        mirror_4_capacity,
                        mirror_4_member_0_id,
                        mirror_4_member_0_sts,
                        mirror_4_member_1_id,
                        mirror_4_member_1_sts,
                        
                        mirror_5_id,
                        mirror_5_sts,
                        mirror_5_map,
                        mirror_5_capacity,
                        mirror_5_member_0_id,
                        mirror_5_member_0_sts,
                        mirror_5_member_1_id,
                        mirror_5_member_1_sts
                        ];
    
    engine1mirror.text = mirror;
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
