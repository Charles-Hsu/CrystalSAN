//
//  RaidViewController.m
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Charles Hsu. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"


#define ITEM_BUTTON_START_TAG_RAIDVIEW 300

@interface LoginViewController ()


@end

@implementation LoginViewController {
    CGRect _realBounds;
}

@synthesize deviceName, deviceLabel;

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
    
    //self.view.superview.bounds = CGRectMake(0, 0, 200, 100);
    
    //_realBounds = self.view.bounds;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"deviceName=%@", deviceName);
    deviceName = [deviceName stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    
    [deviceLabel setText:[NSString stringWithFormat:@"%@", deviceName]];
    //deviceLabel.numberOfLines = 0;
    
    AppDelegate *theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    theDelegate.currentSegueID = @"RaidViewConfigID";
    theDelegate.currentDeviceName = deviceName;
    
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.view.superview.bounds = _realBounds;
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
