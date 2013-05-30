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
#import <objc/runtime.h>


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
    
    UITapGestureRecognizer *doubleTapGestureRecognizer;
    UITapGestureRecognizer *singleTapGestureRecognizer;
    
    //UITextView *textViewInHud;
    
    //NSInteger currentEngineIndex;
    
    
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

@synthesize raid00_0_Label, raid00_1_Label, raid01_0_Label, raid01_1_Label, raid02_0_Label, raid02_1_Label, raid03_0_Label, raid03_1_Label, raid04_0_Label, raid04_1_Label, raid05_0_Label, raid05_1_Label;

@synthesize raid00_0_Button, raid00_1_Button, raid01_0_Button, raid01_1_Button, raid02_0_Button, raid02_1_Button, raid03_0_Button, raid03_1_Button, raid04_0_Button, raid04_1_Button, raid05_0_Button, raid05_1_Button;

@synthesize engineLeft, engineRight;

@synthesize haApplianceName;
@synthesize siteNameLabel;


@synthesize testTwoFingersTap;

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

/*
- (void)handleSwipeFrom:(id)sender {
    NSLog(@"%s %@ currentEngineIndex=%d", __func__, sender, currentEngineIndex);
    UISwipeGestureRecognizer *recognizer = (UISwipeGestureRecognizer *)sender;
    
    if (currentEngineIndex == 0) { // left engine, only accept left swipe to right engine
        if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
            //textViewInHud.text = @"hi, already the left most engine";
            currentEngineIndex = 1;
            NSString *engineSerial = theDelegate.currentEngineRightSerial;
            NSString *vpdInfo = [theDelegate.sanDatabase getEngineVpdString:engineSerial isShort:FALSE];
            NSDictionary *mirrorDict = [theDelegate.sanDatabase getEngineCliMirrorDictBySerial:engineSerial];
            
            NSString *vpdString = [NSString stringWithFormat:
                                   @"%@\n%@\n%@", vpdInfo,
                                   [theDelegate.sanDatabase getEngineMirrorShortString:mirrorDict],
                                   [theDelegate.sanDatabase getConmgrDriveStatusStringByEngineSerial:engineSerial]];
            
            textViewInHud.text = vpdString;
        } 
    } else { // currentEngineIndex == 1, right engine
        if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
            //textViewInHud.text = @"hi, already the left most engine";
            currentEngineIndex = 0;
            NSString *engineSerial = theDelegate.currentEngineLeftSerial;
            NSString *vpdInfo = [theDelegate.sanDatabase getEngineVpdString:engineSerial isShort:FALSE];
            NSDictionary *mirrorDict = [theDelegate.sanDatabase getEngineCliMirrorDictBySerial:engineSerial];
            
            NSString *vpdString = [NSString stringWithFormat:
                                   @"%@\n%@\n%@", vpdInfo,
                                   [theDelegate.sanDatabase getEngineMirrorShortString:mirrorDict],
                                   [theDelegate.sanDatabase getConmgrDriveStatusStringByEngineSerial:engineSerial]];
            
            textViewInHud.text = vpdString;

        }
    }
}
 */

- (void)twoFingersTouch:(id)sender {
    NSLog(@"%s %@", __func__, sender);
    
    
    const char* className = class_getName([sender class]);
    NSLog(@"class name of sender = %s", className);
    
    //- (CGPoint)locationInView:(UIView*)view;
    //CGPoint point = [doubleTapGestureRecognizer locationInView:testTwoFingersTap];
    //NSLog(@"(%f,%f)", point.x, point.y);
    
    
    //CGRect rect = testTwoFingersTap.frame;
    //NSLog(@"(%f,%f)", point.x, point.y);
    //NSLog(@"w=%f h=%f", rect.size.width, rect.size.height);
    
    if(!isHUDshowing) {
        isHUDshowing = YES;
        NSString *engineSerial = nil;
        //NSDictionary *vpd = nil;
        
        CGRect mainFrame = self.view.bounds;
        //CGRect hudFrame = CGRectMake(0, 0, mainFrame.size.width/2, mainFrame.size.height/2);
        CGRect hudFrame = CGRectMake(0, 0, 600, mainFrame.size.height/2);
        CGRect hudFrame1 = CGRectMake(600, 0, 600, mainFrame.size.height/2);
        
        //UITableView *tableView = [[UITableView alloc] initWithFrame:hudFrame];
        //tableView.backgroundColor = [UIColor clearColor];
        //tableView.editing = FALSE;
        //tableView.isEditing = FALSE;
        //tableView.delegate = self;
        //tableView.dataSource = self;
        
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:hudFrame];
        
        //scrollView.alwaysBounceVertical = YES;
        //scrollView.alwaysBounceHorizontal = YES;
        scrollView.pagingEnabled = YES;
        //scrollView.contentSize = CGSizeMake(imageSize.width * images.count, imageSize.height);
        scrollView.contentSize = CGSizeMake(600 * 2, mainFrame.size.height/2);
        
        UITextView *textView = [[UITextView alloc] initWithFrame:hudFrame];
        textView.editable = FALSE;
        //textViewInHud = textView;

        //engineSerial = theDelegate.currentEngineRightSerial;
        /*
        NSLog(@"scrollView.alwaysBounceVertical=%@", scrollView.alwaysBounceVertical?@"YES":@"NO");
        NSLog(@"scrollView.alwaysBounceHorizontal=%@", scrollView.alwaysBounceHorizontal?@"YES":@"NO");

        if (point.x > rect.size.width/2) {
            NSLog(@"%f > %f, right engine", point.x, rect.size.width/2);
            engineSerial = theDelegate.currentEngineRightSerial;
            vpd = engine01Vpd;
            currentEngineIndex = 1;
        } else {
            NSLog(@"%f <= %f, left engine", point.x, rect.size.width/2);
            engineSerial = theDelegate.currentEngineLeftSerial;
            vpd = engine00Vpd;
            currentEngineIndex = 0;
        }
         */
        
        engineSerial = theDelegate.currentEngineLeftSerial;
        NSString *vpdInfo = [theDelegate.sanDatabase getEngineVpdString:engineSerial isShort:FALSE];
        NSDictionary *mirrorDict = [theDelegate.sanDatabase getEngineCliMirrorDictBySerial:engineSerial];
        
        NSString *vpdString = [NSString stringWithFormat:
                               @"%@\n%@\n%@", vpdInfo,
                               [theDelegate.sanDatabase getEngineMirrorShortString:mirrorDict],
                               [theDelegate.sanDatabase getConmgrDriveStatusStringByEngineSerial:engineSerial]];
        
        textView.text = vpdString;
        textView.textColor = [UIColor whiteColor];
        textView.backgroundColor = [UIColor clearColor];
        
        textView.font = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];

        [scrollView addSubview:textView];
        
        
        /////////////
        //UILabel *label = [[UILabel alloc] initWithFrame:hudFrame1];
        //label.text = @"hello world";
        //label.textColor = [UIColor redColor];
        //label.backgroundColor = [UIColor yellowColor];
        //[scrollView addSubview:label];
        /////////////

        engineSerial = theDelegate.currentEngineRightSerial;
        vpdInfo = [theDelegate.sanDatabase getEngineVpdString:engineSerial isShort:FALSE];
        mirrorDict = [theDelegate.sanDatabase getEngineCliMirrorDictBySerial:engineSerial];
        
        vpdString = [NSString stringWithFormat:
                               @"%@\n%@\n%@", vpdInfo,
                               [theDelegate.sanDatabase getEngineMirrorShortString:mirrorDict],
                               [theDelegate.sanDatabase getConmgrDriveStatusStringByEngineSerial:engineSerial]];
        
        UITextView *textView1 = [[UITextView alloc] initWithFrame:hudFrame1];
        textView1.editable = FALSE;
        textView1.text = vpdString;
        textView1.textColor = [UIColor whiteColor];
        textView1.backgroundColor = [UIColor clearColor];
        
        textView1.font = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];
        [scrollView addSubview:textView1];
        
        //[tableView addSubview:scrollView];
        hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 0, 120, 143);
        
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = nil;
        hud.detailsLabelText = nil;
        
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        hud.backgroundColor = [UIColor clearColor];
        
        hud.customView = scrollView;//customView;
        //hud.customView = tableView;
        
        /*
        UISwipeGestureRecognizer *leftRecognizer;
        leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        
        UISwipeGestureRecognizer *rightRecognizer;
        rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
         */

        //[scrollView addGestureRecognizer:leftRecognizer];
        //[scrollView addGestureRecognizer:rightRecognizer];

    }

    
    /*
    
    if(!isHUDshowing) {
        isHUDshowing = YES;
        
        //loadingHUD.mode = MBProgressHUDModeCustomView;
        //loadingHUD.labelText = nil;
        //loadingHUD.detailsLabelText = nil;
        //UIView *customView = [[UIView alloc] initWithFrame:self.view.bounds]; // Set a size
        
        
        CGRect mainFrame = self.view.bounds;
        //CGRect hudFrame = CGRectMake(0, 0, mainFrame.size.width/2, mainFrame.size.height/2);
        CGRect hudFrame = CGRectMake(0, 0, 600, mainFrame.size.height/2);

        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:hudFrame];
        UITextView *textView = [[UITextView alloc] initWithFrame:hudFrame];
        
        //vpd = engine00Vpd;
        NSString *vpdInfo = [self getEngineVpdShortString:engine00Vpd];
        
        NSString *doubleForTest = [NSString stringWithFormat:@"%@ %@ %@", vpdInfo, vpdInfo, vpdInfo];
        vpdInfo = doubleForTest;
        
        textView.text = vpdInfo;
        textView.textColor = [UIColor whiteColor];
        textView.backgroundColor = [UIColor clearColor];
        
        textView.font = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];
        
        
        //hud.labelFont = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];//[UIFont systemFontOfSize:25.0];
        //hud.detailsLabelFont = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];//[UIFont systemFontOfSize:20.0];

        
        // Add stuff to view here
        //loadingHUD.customView = customView;
        //[HUD show:YES];
        
        
        hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 0, 120, 143);
        
        //hud.mode = MBProgressHUDModeAnnularDeterminate;
        //NSString *strloadingText = [NSString stringWithFormat:@"%@", engineSerial];
        //NSString *strloadingText2 = [NSString stringWithFormat:@"Engine             : %@\n%@", isMaster, vpdInfo];// ;//] @" Please Wait.\r 1-2 Minutes"];
        
        //NSLog(@"the loading text will be %@",strloadingText);
        //hud.labelText = strloadingText;
        //hud.detailsLabelText=strloadingText2;
        
        //NSLog(@"%s %@ %@", __func__, theDelegate.currentEngineLeftSerial, theDelegate.currentEngineRightSerial);
        
        hud.mode = MBProgressHUDModeCustomView;

        hud.labelText = nil;
        hud.detailsLabelText = nil;
        
        //hud.mode = MBProgressHUDModeCustomView;
        //hud.labelText = @"Some message..Some message...";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        hud.backgroundColor = [UIColor clearColor];
        //hud.labelFont = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];//[UIFont systemFontOfSize:25.0];
        //hud.detailsLabelFont = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];//[UIFont systemFontOfSize:20.0];
        
        
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
        label.text = @"hello world";
        label.textColor = [UIColor redColor];
        label.backgroundColor = [UIColor yellowColor];
        
        
        //[textView addSubview:label];
        [scrollView addSubview:textView];
        //[testTwoFingersTap addSubview:label];
        
        hud.customView = scrollView;//customView;
        //hud.customView = textView;
        //hud.customView = label;
    }
     */
    
}


#pragma mark -
#pragma mark Table View Data Source Methods
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%s", __func__);
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    
    NSString *engineSerial = nil;
    NSDictionary *vpd = nil;
    
    
    CGPoint point = [doubleTapGestureRecognizer locationInView:testTwoFingersTap];
    CGRect rect = testTwoFingersTap.frame;

    
    CGRect mainFrame = self.view.bounds;
    //CGRect hudFrame = CGRectMake(0, 0, mainFrame.size.width/2, mainFrame.size.height/2);
    CGRect hudFrame = CGRectMake(0, 0, 600, mainFrame.size.height/2);

    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:hudFrame];
    
    scrollView.alwaysBounceVertical = YES;
    scrollView.alwaysBounceHorizontal = YES;
    
    NSLog(@"scrollView.alwaysBounceVertical=%@", scrollView.alwaysBounceVertical?@"YES":@"NO");
    NSLog(@"scrollView.alwaysBounceHorizontal=%@", scrollView.alwaysBounceHorizontal?@"YES":@"NO");
    
    UITextView *textView = [[UITextView alloc] initWithFrame:hudFrame];
    
    if (point.x > rect.size.width/2) {
        NSLog(@"%f > %f, right engine", point.x, rect.size.width/2);
        engineSerial = theDelegate.currentEngineRightSerial;
        vpd = engine01Vpd;
    } else {
        NSLog(@"%f <= %f, left engine", point.x, rect.size.width/2);
        engineSerial = theDelegate.currentEngineLeftSerial;
        vpd = engine00Vpd;
    }
    
    NSString *vpdInfo = [theDelegate.sanDatabase getEngineVpdString:engineSerial isShort:FALSE];
    NSDictionary *mirrorDict = [theDelegate.sanDatabase getEngineCliMirrorDictBySerial:engineSerial];
    
    NSString *vpdString = [NSString stringWithFormat:
                           @"%@\n%@\n%@", vpdInfo,
                           [theDelegate.sanDatabase getEngineMirrorShortString:mirrorDict],
                           [theDelegate.sanDatabase getConmgrDriveStatusStringByEngineSerial:engineSerial]];
    
    textView.text = vpdString;
    textView.textColor = [UIColor whiteColor];
    textView.backgroundColor = [UIColor clearColor];
    
    textView.font = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];
    
    hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 0, 120, 143);
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = nil;
    hud.detailsLabelText = nil;
    
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.backgroundColor = [UIColor clearColor];
    
    [scrollView addSubview:textView];
    [tableView addSubview:scrollView];
    //hud.customView = scrollView;//customView;
    hud.customView = tableView;
    
    UISwipeGestureRecognizer *leftRecognizer;
    leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    //[[self view] addGestureRecognizer:leftRecognizer];
    //[leftRecognizer release];
    
    UISwipeGestureRecognizer *rightRecognizer;
    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    //[[self view] addGestureRecognizer:rightRecognizer];
    //[rightRecognizer release];
    
    //UISwipeGestureRecognizer *swipeRecognizer;
    //swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(helloSwipe:)];
    //swipeRecognizer.UISwipeGestureRecognizerDirection = UISwipeGestureRecognizerDirectionRight; // UISwipeGestureRecognizerDirectionLeft
    
    //swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
    
    
    //UISwipeGestureRecognizerDirectionRight = 1 << 0,
    //UISwipeGestureRecognizerDirectionLeft  = 1 << 1,
    
    //[scrollView addGestureRecognizer:swipeRecognizer];
    [scrollView addGestureRecognizer:leftRecognizer];
    [scrollView addGestureRecognizer:rightRecognizer];

    
    
    //NSUInteger row = [indexPath row];
    NSLog(@"%s", __func__);
    [cell.contentView addSubview:scrollView];
    return cell;
}
 */

- (void)showEngineinfoInHud:(NSString *)engineSerial vpdInfo:(NSDictionary *)vpd {
    NSString *vpdInfo = [self getEngineVpdShortString:vpd];
    NSString *isMaster = [self isMaster:engineSerial];
    
    hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 0, 120, 143);
    
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    NSString *strloadingText = [NSString stringWithFormat:@"%@", engineSerial];
    NSString *strloadingText2 = [NSString stringWithFormat:@"Engine             : %@\n%@", isMaster, vpdInfo];// ;//] @" Please Wait.\r 1-2 Minutes"];
    
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
}


- (void)oneFingerTouch:(id)sender {

    NSLog(@"%s %@", __func__, sender);
    const char* className = class_getName([sender class]);
    NSLog(@"class name of sender = %s", className);
    CGPoint point = [singleTapGestureRecognizer locationInView:testTwoFingersTap];
    CGRect rect = testTwoFingersTap.frame;
    NSLog(@"(%f,%f)", point.x, point.y);
    NSLog(@"w=%f h=%f", rect.size.width, rect.size.height);

    if(!isHUDshowing) {
        isHUDshowing = YES;
        CGRect mainFrame = self.view.bounds;
        CGRect hudFrame = CGRectMake(0, 0, 600, mainFrame.size.height/2);
        CGRect hudFrame1 = CGRectMake(600, 0, 600, mainFrame.size.height/2);
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:hudFrame];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(600 * 2, mainFrame.size.height/2);
        
        UITextView *textView = [[UITextView alloc] initWithFrame:hudFrame];
        textView.editable = FALSE;
        
        NSString *engineSerial = theDelegate.currentEngineLeftSerial;
        NSString *vpdInfo = [self getEngineVpdShortString:engine00Vpd];
        NSString *isMaster = [self isMaster:engineSerial];
        
        hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //hud.frame = CGRectMake(0, 0, 120, 143);
        
        //hud.mode = MBProgressHUDModeAnnularDeterminate;
        //NSString *strloadingText = [NSString stringWithFormat:@"%@", engineSerial];
        NSString *strloadingText2 = [NSString stringWithFormat:@"Engine             : %@\n%@", isMaster, vpdInfo];// ;//] @" Please Wait.\r 1-2 Minutes"];
        textView.text = strloadingText2;
        textView.textColor = [UIColor whiteColor];
        textView.backgroundColor = [UIColor clearColor];
        textView.font = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];

        [scrollView addSubview:textView];
        
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = nil;
        hud.detailsLabelText = nil;
        
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        hud.backgroundColor = [UIColor clearColor];
        
        hud.customView = scrollView;
        

    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"deviceName=%@", deviceName);
    deviceName = [deviceName stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    
    doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingersTouch:)];
    doubleTapGestureRecognizer.numberOfTouchesRequired = 2;

    singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingersTouch:)];
    singleTapGestureRecognizer.numberOfTouchesRequired = 1;
    singleTapGestureRecognizer.numberOfTapsRequired = 1;

    [testTwoFingersTap addGestureRecognizer:doubleTapGestureRecognizer];
    [testTwoFingersTap addGestureRecognizer:singleTapGestureRecognizer];
    
    
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
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
    [theDelegate hideShowSliders:self.view];
    
}

// The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self hideHud];
}

- (void)loadEngineCliInformation:(NSString *)serial {
    
    //[sanDatabase httpGetEngineCliVpdBySiteName:theDelegate.siteName serial:serial];
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%s", __func__);
    
    self.haApplianceName.text = theDelegate.currentDeviceName;
    self.siteNameLabel.text = theDelegate.siteName;
    
    [theDelegate.syncManager syncEngineWithHAApplianceNameAndAddedtoSyncedArray:theDelegate.currentHAApplianceName];
    
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
        
        NSLog(@"%s %@", __func__, dict);
                
        self.lun00_0_Label.text = [self stringForKey:dict key:@"m0_mb0_id"];
        self.lun00_1_Label.text = [self stringForKey:dict key:@"m0_mb1_id"];
        self.lun01_0_Label.text = [self stringForKey:dict key:@"m1_mb0_id"];
        self.lun01_1_Label.text = [self stringForKey:dict key:@"m1_mb1_id"];
        self.lun02_0_Label.text = [self stringForKey:dict key:@"m2_mb0_id"];
        self.lun02_1_Label.text = [self stringForKey:dict key:@"m2_mb1_id"];
        self.lun03_0_Label.text = [self stringForKey:dict key:@"m3_mb0_id"];
        self.lun03_1_Label.text = [self stringForKey:dict key:@"m3_mb1_id"];
        
        self.raid00_0_Label.text = self.lun00_0_Label.text;
        self.raid00_1_Label.text = self.lun01_0_Label.text;
        self.raid01_0_Label.text = self.lun02_0_Label.text;
        self.raid01_1_Label.text = self.lun03_0_Label.text;
        self.raid02_0_Label.text = self.lun00_1_Label.text;
        self.raid02_1_Label.text = self.lun01_1_Label.text;
        self.raid03_0_Label.text = self.lun02_1_Label.text;
        self.raid03_1_Label.text = self.lun03_1_Label.text;
        
        
        
        self.lun00Label.text = [self stringForKey:dict key:@"m0_id"];
        self.lun01Label.text = [self stringForKey:dict key:@"m1_id"];
        self.lun02Label.text = [self stringForKey:dict key:@"m2_id"];
        self.lun03Label.text = [self stringForKey:dict key:@"m3_id"];
        
        
        if ([[self stringForKey:dict key:@"m2_id"] length] == 0) {
            self.lun02Label.hidden = TRUE;
            self.lun02Button.hidden = TRUE;
            self.lun02_0_Button.hidden = TRUE;
            self.lun02_1_Button.hidden = TRUE;
            self.lun02_MirroredLUN.hidden = TRUE;
            
            self.raid01_0_Button.hidden = TRUE;
            self.raid01_1_Button.hidden = TRUE;
            
            
        } else {
            self.lun02Label.hidden = FALSE;
            self.lun02Button.hidden = FALSE;
            self.lun02_0_Button.hidden = FALSE;
            self.lun02_1_Button.hidden = FALSE;
            self.lun02_MirroredLUN.hidden = FALSE;
            
            self.raid01_0_Button.hidden = FALSE;
            self.raid01_1_Button.hidden = FALSE;

        }
        
        if ([[self stringForKey:dict key:@"m3_id"] length] == 0) {
            self.lun03Label.hidden = TRUE;
            self.lun03Button.hidden = TRUE;
            self.lun03_0_Button.hidden = TRUE;
            self.lun03_1_Button.hidden = TRUE;
            self.lun03_MirroredLUN.hidden = TRUE;
            
            self.raid03_0_Button.hidden = TRUE;
            self.raid03_1_Button.hidden = TRUE;

        } else {
            self.lun03Label.hidden = FALSE;
            self.lun03Button.hidden = FALSE;
            self.lun03_0_Button.hidden = FALSE;
            self.lun03_1_Button.hidden = FALSE;
            self.lun03_MirroredLUN.hidden = FALSE;
            
            self.raid03_0_Button.hidden = FALSE;
            self.raid03_1_Button.hidden = FALSE;

        }
        
    }

        
}

- (NSString *)stringForKey:(NSDictionary *)dict key:(NSString *)_key {
    NSString *string = [dict valueForKey:_key];
    NSLog(@"%s %@", __func__, string);
    if (string != (id)[NSNull null]) {
        NSLog(@"%@ length=%d", string, [string length]);
        return string;
    }
    return @"";
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%s", __func__);
    self.haApplianceName.text = theDelegate.currentDeviceName;
    //NSLog(@"%@", [deviceArray objectAtIndex:currentItemIndex]);
    
    NSArray *engines = [theDelegate.sanDatabase getEnginesByHaApplianceName:(self.haApplianceName.text)];
    NSLog(@"%s %@", __func__, engines);

}

#define RAID_DRIVE_0_0 1000
#define RAID_DRIVE_0_1 1001
#define RAID_DRIVE_1_0 1002
#define RAID_DRIVE_1_1 1003
#define RAID_DRIVE_2_0 1004
#define RAID_DRIVE_2_1 1005
#define RAID_DRIVE_3_0 1006
#define RAID_DRIVE_3_1 1007


- (NSString *)driveShortInformation:(NSDictionary *)dict0 slave:(NSDictionary *)dict1 {
    /*
     conmgr drive status
     
     8 Drives
     ==========
     tnum port wwpn               lun               status                  RE-stat
     0 B1   5006-022ad0-457000 0000-000000000000 A                       A
     1 B1   5006-022ad0-49a000 0000-000000000000 A                       A
     2 B2   5006-022ad0-48b000 0000-000000000000 A                       A
     3 B2   5006-022ad0-42f000 0000-000000000000 A                       A
     4 B1   5006-022ad0-457002 0000-000000000000 A                       A
     5 B1   5006-022ad0-49a002 0000-000000000000 A                       A
     6 B2   5006-022ad0-48b002 0000-000000000000 A                       A
     7 B2   5006-022ad0-42f002 0000-000000000000 A                       A
     
     */
    /*
     -[SanDatabase getConmgrDriveStatusByEngineSerial:targetNum:] {
     "drive_id" = 5;
     "drive_status" = A;
     "path_0_id" = 1;
     "path_0_lun" = 0000;
     "path_0_port" = B1;
     "path_0_pstatus" = A;
     "path_0_wwpn" = "6000-393000-01a99f";
     "path_1_id" = "";
     "path_1_lun" = "";
     "path_1_port" = "";
     "path_1_pstatus" = "";
     "path_1_wwpn" = "";
     seconds = 1363746626;
     serial = 00600306;
     }
     */
    /*
     Target	status	port	Storage WWPN	   LUN	status
     5      A       B1      6000-393000-01a99f 0000 A
     */
    
    const NSString *EngineDriveShortStringtTitle = @"Serial   Target status port Storage WWPN       LUN  status";
    NSString *info = [NSString stringWithFormat:@""
        //"Serial    Target status port Storage WWPN       LUN  status\n"
        "%@\n"
        "%-8d %@\n"
        "%-8d %@",
                      EngineDriveShortStringtTitle,
                      [[dict0 objectForKey:@"serial"] integerValue],
                      [theDelegate.sanDatabase getEngineDriveShortString:dict0],
                      [[dict1 objectForKey:@"serial"] integerValue],
                      [theDelegate.sanDatabase getEngineDriveShortString:dict1]
                      ];
    return info;
}

- (IBAction)showDriveStatus:(id)sender {
    
    NSLog(@"%s sender.tag = %d", __func__, [sender tag]);
    
    if(!isHUDshowing) {
        
        isHUDshowing = YES;

        NSInteger targetNum = 0;
        
        switch ([sender tag]) {
            case RAID_DRIVE_0_0:
                targetNum = [raid00_0_Label.text integerValue];
                break;
            case RAID_DRIVE_0_1:
                targetNum = [raid00_1_Label.text integerValue];
                break;
            case RAID_DRIVE_1_0:
                targetNum = [raid01_0_Label.text integerValue];
                break;
            case RAID_DRIVE_1_1:
                targetNum = [raid01_1_Label.text integerValue];
                break;
            case RAID_DRIVE_2_0:
                targetNum = [raid02_0_Label.text integerValue];
                break;
            case RAID_DRIVE_2_1:
                targetNum = [raid02_1_Label.text integerValue];
                break;
            case RAID_DRIVE_3_0:
                targetNum = [raid03_0_Label.text integerValue];
                break;
            case RAID_DRIVE_3_1:
                targetNum = [raid03_1_Label.text integerValue];
                break;
            default:
                break;
        }
        
        NSLog(@"target num = %d", targetNum);
        
        NSDictionary *dict0 = [theDelegate.sanDatabase getConmgrDriveStatusByEngineSerial:theDelegate.currentEngineLeftSerial
                                                                                targetNum:targetNum];
        //NSLog(@"%@", [self raidShortInformation:dict0]);
        
        NSDictionary *dict1 = [theDelegate.sanDatabase getConmgrDriveStatusByEngineSerial:theDelegate.currentEngineRightSerial
                                                                                targetNum:targetNum];
        //NSLog(@"%@", [self raidShortInformation:dict1]);
        
        NSString *info = [self driveShortInformation:dict0 slave:dict1];
        
        hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.frame = CGRectMake(0, 0, 10, 10);
        
        NSString *strloadingText = [NSString stringWithFormat:@"%@-%@", theDelegate.currentEngineLeftSerial, theDelegate.currentEngineRightSerial];
        NSString *strloadingText2 = [NSString stringWithFormat:@"%@", info];// ;//] @" Please Wait.\r 1-2 Minutes"];
        
        hud.labelText = strloadingText;
        hud.detailsLabelText=strloadingText2;
        
        //NSLog(@"%s %@ %@", __func__, theDelegate.currentEngineLeftSerial, theDelegate.currentEngineRightSerial);
        
        hud.mode = MBProgressHUDModeText;
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        hud.backgroundColor = [UIColor clearColor];
        hud.labelFont = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];//[UIFont systemFontOfSize:25.0];
        hud.detailsLabelFont = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];//[UIFont systemFontOfSize:20.0];
        
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

- (NSString *)getEngineVpdShortString:(NSDictionary *)vpd {
    return [theDelegate.sanDatabase getEngineVpdShortString:vpd];
}

- (NSString *)getMirrorShortString:(NSDictionary *)dict {
    return [theDelegate.sanDatabase getEngineMirrorShortString:dict];
}


- (void)hideHud {
    NSLog(@"%s", __func__);
    
    if (isHUDshowing) {
        NSInteger delaySec = 0.1;
        [hud hide:YES afterDelay:delaySec];
        isHUDshowing = NO;
    }
}


- (IBAction)showMirrorInfo:(id)sender {
    NSLog(@"%s", __func__);
    
    if(!isHUDshowing) {
        //NSString *lunNumStr = [sender restorationIdentifier];
        
        //NSString *mirrorShortInfo = [self getMirrorShortString:theDelegate.currentEngineLeftSerial byLunNum:lunNumStr];
        NSLog(@"%s %@", __func__, engine00Mirror);
        NSString *mirrorShortInfo = [self getMirrorShortString:engine00Mirror];
        
        hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.frame = CGRectMake(0, 0, 10, 10);
        
        
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
    }
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


- (NSString *)isMaster:(NSString *)serial {
    NSDictionary *dict = [theDelegate.sanDatabase getEngineCliDmepropDictBySerial:serial];
    
    NSInteger myId = [[dict valueForKey:@"my_id"] intValue];
    BOOL isMaster = NO;
    
    NSLog(@"%s %@", __func__, dict);
    
    switch (myId) {
        case 1:
            if ([[dict valueForKey:@"cluster_0_is_master"] isEqualToString:@"Yes"]) {
                isMaster = YES;
            }
            break;
        case 2:
            if ([[dict valueForKey:@"cluster_1_is_master"] isEqualToString:@"Yes"]) {
                isMaster = YES;
            }
            break;
        default:
            break;
    }
    return isMaster?@"Master":@"Follower";
}

- (IBAction)showEngineInfo:(id)sender {
    NSLog(@"%s", __func__);
    
    if(!isHUDshowing) {
        isHUDshowing = YES;
        NSString *engineSerial = nil;
        NSDictionary *vpd = nil;
        
        if ([[sender restorationIdentifier] isEqualToString:@"leftEngine"]) {
            engineSerial = theDelegate.currentEngineLeftSerial;
            vpd = engine00Vpd;
        } else {
            engineSerial = theDelegate.currentEngineRightSerial;
            vpd = engine01Vpd;
        }
        
        [self showEngineinfoInHud:engineSerial vpdInfo:vpd];
        /*
        NSString *vpdInfo = [self getEngineVpdShortString:vpd];
        
        NSString *isMaster = [self isMaster:engineSerial];
        
        hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 0, 120, 143);
        
        //hud.mode = MBProgressHUDModeAnnularDeterminate;
        NSString *strloadingText = [NSString stringWithFormat:@"%@", engineSerial];
        NSString *strloadingText2 = [NSString stringWithFormat:@"Engine             : %@\n%@", isMaster, vpdInfo];// ;//] @" Please Wait.\r 1-2 Minutes"];
        
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
         */
    }
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
