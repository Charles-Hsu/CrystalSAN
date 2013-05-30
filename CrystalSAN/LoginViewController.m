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
    AppDelegate *theDelegate;
    
    UIViewController *parrentVC;
}

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

- (void)viewDidLoad {
    
    //self.view.superview.bounds = CGRectMake(0, 0, 200, 100);
    
    //_realBounds = self.view.bounds;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    
    NSLog(@"%s deviceName=%@", __func__, deviceName);
    deviceName = [deviceName stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    
    //[deviceLabel setText:[NSString stringWithFormat:@"%@", deviceName]];
    //deviceLabel.numberOfLines = 0;
    
    //theDelegate.currentSegueID = @"RaidViewConfigID";
    //theDelegate.currentDeviceName = deviceName;
    
    //self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    //self.siteName.text = [self getDefaultSiteName];
    self.siteName.text = theDelegate.siteName;
    self.password.keyboardType = UIKeyboardTypeNumberPad;
    
    // UITextField focus
    // http://stackoverflow.com/questions/1014999/uitextfield-focus
    [self.userName becomeFirstResponder];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.view.superview.bounds = _realBounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //carousel.delegate = nil;
    //carousel.dataSource = nil;
    //carousel = nil;
    //self.totalItems = nil;
    //self.activeItems = nil;
}


- (IBAction)onCancel:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    //[self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    //UIViewController *prevVC = [self.navigationController.viewControllers objectAtIndex:0];
    //[self.navigationController popToViewController:prevVC animated:YES];
    
    //alloc new view controller
	//MainViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewControllerID"];
    
	//present new view controller
	//[self presentViewController:mainVC animated:YES completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)onConfirm:(id)sender {
    
    NSString *userName = self.userName.text;
    NSString *siteName = self.siteName.text;
    NSString *password = self.password.text;
    
    NSLog(@"%s %@ %@ %@", __func__, userName, siteName, password);
    
    NSString *urlString = [theDelegate.sanDatabase hostURLPathWithPHP:@"http-check-auth.php"];
    
    NSString *urlStringWithItems = [urlString stringByAppendingFormat:@"?site=%@&user=%@&password=%@", siteName, userName, password];
    NSURL *url = [NSURL URLWithString:urlStringWithItems];
    NSError *error = nil;
    NSString *apiResponse = nil;
    
    NSLog(@"%s %@", __func__, url);
    
    NSLog(@"%s url %@ isReachable", __func__, url);
    
    apiResponse = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"--");
    NSLog(@"%@", urlStringWithItems);
    NSLog(@"nsurl response = %@", apiResponse);
    NSLog(@"nsurl error = %@", error);
    NSLog(@"--");
    
    NSLog(@"%s %@", __func__, theDelegate.siteInfoArray);
    
    if ([apiResponse isEqualToString:@"1"]) {
        theDelegate.siteName = siteName;
        [theDelegate.sanDatabase httpGetHAClusterDictionaryBySiteName:theDelegate.siteName];
        [theDelegate setCurrentSiteLogin];
    }
    
    NSLog(@"%s %@", __func__, theDelegate.siteInfoArray);
    
    theDelegate.isHostReachable = TRUE;
    
    if ([theDelegate IsCurrentSiteLogin]) {
        theDelegate.userName = self.userName.text;
        theDelegate.siteName = self.siteName.text;
        theDelegate.password = self.password.text;
        
        if (theDelegate.siteName != nil) {
            if (theDelegate.syncManager == nil) {
                theDelegate.syncManager = [[SyncManager alloc] init];
            }
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"presentNextViewControllerNotification" object:nil];
        }];
    } else {
        [self shakeView:self.view];
    }

    
}

- (NSString *)getDefaultSiteName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    NSLog(@"%s %@", __func__, defaults);
    
    NSString *siteName = [defaults objectForKey:@"site_name"];
    return siteName;
}

// Shake visual effect on iPhone (NOT shaking the device)
// http://stackoverflow.com/questions/1632364/shake-visual-effect-on-iphone-not-shaking-the-device

- (void)shakeView:(UIView *)viewToShake {
    CGFloat t = 2.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    viewToShake.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}


@end
