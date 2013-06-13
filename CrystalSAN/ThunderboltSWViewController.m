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

/*
@interface  UIScrollView <UIScrollViewDelegate>
{
    bool canStopScrolling;
    float prevOffset;
    float deltaOffset; //remembered for debug purposes
    NSTimeInterval prevTime;
    NSTimeInterval deltaTime; //remembered for debug purposes
    float currentSpeed;
}
 */

@interface ThunderboltSWViewController () {
    AppDelegate *theDelegate;
    MBProgressHUD *hud;
    BOOL isHUDshowing;
    int currentHostIndex;
}

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIPopoverController *popOver;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) NSMutableArray *host1LUNArray;
@property (nonatomic, strong) NSMutableArray *host2LUNArray;
@property (nonatomic, strong) NSMutableArray *host3LUNArray;
@property (nonatomic, strong) NSMutableArray *host4LUNArray;
@property (nonatomic, strong) NSMutableArray *host5LUNArray;
@property (nonatomic, strong) NSMutableArray *host6LUNArray;
@property (nonatomic, strong) NSMutableArray *host7LUNArray;


@property (nonatomic, strong) NSMutableArray *hostArrayForLUNArray;


@end

@implementation ThunderboltSWViewController {
    BOOL isFrontView;
    UITapGestureRecognizer *singleFingerTap;
    UITapGestureRecognizer *doubleTapGestureRecognizer;
    //UITapGestureRecognizer *singleTapGestureRecognizerOnHost;
}

@synthesize carousel;
@synthesize carouselDriver;

@synthesize descriptions;

@synthesize arcValue, radiusValue, spacingValue, sizingValue;
@synthesize arcLabel, radiusLabel, spacingLabel, sizingLabel;
@synthesize arcSlider, radiusSlider, spacingSlider, sizingSlider;

@synthesize lun0_0, lun0_1, lun0_2, lun0_3;
@synthesize lun1_0, lun1_1, lun1_2, lun1_3;
@synthesize lun2_0, lun2_1, lun2_2, lun2_3;
@synthesize lun3_0, lun3_1, lun3_2, lun3_3;

@synthesize thunderboltSWButton;

- (IBAction)logout:(id)sender {
    [theDelegate setCurrentSiteLogout];
    theDelegate.syncManager = nil;
    [self onHome:sender];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"%s", __func__);

    self = [super initWithCoder:aDecoder];
    
    if (self) {
        theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //set up carousel data
        //carousel = [[iCarousel alloc] initWithFrame:CGRectMake(80, 128, 864, 80)];
        //carousel.backgroundColor = [UIColor cyanColor];
    }
    return self;
}


- (void)showHostInformationOnHUD:(id)sender {
    NSLog(@"%s %@", __func__, sender);
    
    const char* className = class_getName([sender class]);
    NSLog(@"class name of sender = %s", className);
    
    if(!isHUDshowing) {
        isHUDshowing = YES;
        
        CGRect mainFrame = self.view.bounds;
        //CGRect hudFrame = CGRectMake(0, 0, mainFrame.size.width/2, mainFrame.size.height/2);
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 600, mainFrame.size.height/2)];
        scrollView.delegate = self;
        
        scrollView.pagingEnabled = YES;
        int pages = 7;
        scrollView.contentSize = CGSizeMake(600 * pages, mainFrame.size.height/2);
        int width = 600;
        int height = mainFrame.size.height/2;
        
        for (int i=0; i<pages; i++) {
            CGRect hudFrame = CGRectMake(width*i, 0, width, height);
            
            //scrollView.alwaysBounceVertical = YES;
            //scrollView.alwaysBounceHorizontal = YES;
            
            UITextView *textView = [[UITextView alloc] initWithFrame:hudFrame];
            textView.editable = FALSE;
            
            textView.text = [NSString stringWithFormat:@"%d", i+1];
            textView.textColor = [UIColor whiteColor];
            textView.backgroundColor = [UIColor clearColor];
            textView.textAlignment = NSTextAlignmentCenter;
            
            textView.font = [UIFont fontWithName:@"SourceCodePro-Bold" size:30.0];
            
            [scrollView addSubview:textView];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self
                       action:@selector(aMethod:)
             forControlEvents:UIControlEventTouchDown];
            [button setTitle:@"Photo Library" forState:UIControlStateNormal];
            button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
            
            [scrollView addSubview:button];
            

        }
        
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
        
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * currentHostIndex;
        frame.origin.y = 0;
        [scrollView scrollRectToVisible:frame animated:NO];
        
    }
}

- (void)insertDEMOdata
{
    NSLog(@"%s", __func__);
    // host0
    [[self.hostArrayForLUNArray objectAtIndex:0] addObject:[[NSArray alloc] initWithObjects:self.lun0_0, @"RW", nil]];
    [[self.hostArrayForLUNArray objectAtIndex:0] addObject:[[NSArray alloc] initWithObjects:self.lun3_0, @"RW", nil]];
    // host1
    [[self.hostArrayForLUNArray objectAtIndex:1] addObject:[[NSArray alloc] initWithObjects:self.lun1_0, @"RW", nil]];
    // host2
    [[self.hostArrayForLUNArray objectAtIndex:2] addObject:[[NSArray alloc] initWithObjects:self.lun2_0, @"RW", nil]];
    [[self.hostArrayForLUNArray objectAtIndex:3] addObject:[[NSArray alloc] initWithObjects:self.lun2_0, @"RW", nil]];
    [[self.hostArrayForLUNArray objectAtIndex:4] addObject:[[NSArray alloc] initWithObjects:self.lun2_0, @"RW", nil]];
    [[self.hostArrayForLUNArray objectAtIndex:5] addObject:[[NSArray alloc] initWithObjects:self.lun2_0, @"RW", nil]];
    [[self.hostArrayForLUNArray objectAtIndex:6] addObject:[[NSArray alloc] initWithObjects:self.lun2_0, @"RW", nil]];
    //[[self.hostArrayForLUNArray objectAtIndex:7] addObject:[[NSArray alloc] initWithObjects:self.lun2_0, @"RW", nil]];
    
    //[carousel reloadData];
    
}

- (IBAction)aMethod:(id)sender {
    NSLog(@"%s %@", __func__, sender);
    UIButton *button = (UIButton *)sender;
    NSLog(@"'%@' '%@' '%@'", button.description, button.currentTitle, button.restorationIdentifier);
    NSLog(@"carousel.currentItemIndex=%d", carousel.currentItemIndex);
    NSMutableArray *lunForHost = [self.hostArrayForLUNArray objectAtIndex:carousel.currentItemIndex];
    //[lunForHost addObject:[[NSArray alloc] initWithObjects:sender, @"RW", nil]];
    //NSLog(@"%s [lunForHost count]=%d", __func__, [lunForHost count]);
    
    UIButton *foundBtn = nil;
    NSString *authority = nil;
    int lunIndex = 0;
    BOOL found=NO;
    for (int i=0; i<[lunForHost count] && !found; i++) {
        UIButton *btn = [[lunForHost objectAtIndex:i] objectAtIndex:0];
        authority = [[lunForHost objectAtIndex:i] objectAtIndex:1];
        NSLog(@"%d. btn = %@", i, btn.currentTitle);
        NSLog(@"%d. sender = %@", i, button.currentTitle);
        if (btn==sender) {
            found = YES;
            foundBtn = sender;
            lunIndex = i;
        }
    }
    
    NSLog(@"%s %@", __func__, found?@"Found":@"Not found");
    if (found) {
        if ([authority isEqualToString:@"R"]) {
            [lunForHost replaceObjectAtIndex:lunIndex withObject:[[NSArray alloc] initWithObjects:sender, @"RW", nil]];
        } else { //if ([authority isEqualToString:@"RW"]) {
            [lunForHost removeObjectAtIndex:lunIndex];
        }
    } else {
        [lunForHost addObject:[[NSArray alloc] initWithObjects:sender, @"R", nil]];
    }
    NSLog(@"%s [lunForHost count]=%d", __func__, [lunForHost count]);
    //[lunForHost replaceObjectAtIndex:<#(NSUInteger)#> withObject:<#(id)#>]
    
    //UIButton *btn = [[[self.hostArrayForLUNArray objectAtIndex:carousel.currentItemIndex] objectAtIndex:0] objectAtIndex:0];
    //UIButton *btn = class_getName([[[self.hostArrayForLUNArray objectAtIndex:index] objectAtIndex:0] class]) ;
    //int index=carousel.currentItemIndex;
    //NSLog(@"%s %@", __func__, [btn currentTitle]);

    
    //self.selectedImageView = self.imageView;
    //[self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [carousel reloadData];
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    //if (self.imageView.isAnimating)
    //{
    //    [self.imageView stopAnimating];
    //}
    
    //if (self.capturedImages.count > 0)
    //{
    //    [self.capturedImages removeAllObjects];
    //}
    
    //UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    //imagePickerController.sourceType = sourceType;
    //imagePickerController.delegate = self;
    
    
    
    

    
    // We are using an iPad
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
    [popover presentPopoverFromRect:self.view.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.popOver = popover;

    
    //imagePickerController.delegate = self;
    //UIPopoverController *popoverController=[[UIPopoverController alloc] initWithContentViewController:imagePickerController];
    //popoverController.delegate=self;
    //[popoverController presentPopoverFromRect:((UIButton *)sender).bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    //if (sourceType == UIImagePickerControllerSourceTypeCamera)
    //{
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        //imagePickerController.showsCameraControls = NO;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        //[[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
        //self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
        //imagePickerController.cameraOverlayView = self.overlayView;
        //self.overlayView = nil;
    //}
    
    //self.imagePickerController = imagePickerController;
    //[self presentViewController:self.imagePickerController animated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%s %@", __func__, info);
    self.selectedImageView.image = info[UIImagePickerControllerOriginalImage];
    self.selectedImageView = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    //NSLog(@"%s %@", __func__, sender);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //ensure that the end of scroll is fired.
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:sender afterDelay:0.3];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"%s %@", __func__, scrollView);
    int index = scrollView.contentOffset.x/600;
    carousel.currentItemIndex = index;
    [carousel reloadData];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    NSLog(@"%s %@", __func__, scrollView);
}



- (void)showEngineinfoInHud:(NSString *)engineSerial vpdInfo:(NSDictionary *)vpd {
    /*
    NSString *vpdInfo = [theDelegate.sanDatabase getEngineVpdShortString:vpd];
    
    hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 0, 120, 143);
    
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    NSString *strloadingText = [NSString stringWithFormat:@"%@", engineSerial];
    NSString *strloadingText2 = [NSString stringWithFormat:@"Engine             : %@\n%@", isMaster, vpdInfo];// ;//] @" Please Wait.\r 1-2 Minutes"];
    
    //NSLog(@"the loading text will be %@",strloadingText);
    hud.labelText = strloadingText;
    hud.detailsLabelText=strloadingText2;
    
    //NSLog(@"%s %@ %@", __func__, theDelegate.currentEngineLeftSerial, theDelegate.currentEngineRightSerial);
    
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

/*
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
        //CGRect hudFrame1 = CGRectMake(600, 0, 600, mainFrame.size.height/2);
        
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
 */





- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    isFrontView = TRUE;
    
    NSLog(@"deviceName=%@", deviceName);
    deviceName = [deviceName stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
        
    //get data
    theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //self.host1LUNArray = [[NSMutableArray alloc] init];
    //self.host2LUNArray = [[NSMutableArray alloc] init];
    //self.host3LUNArray = [[NSMutableArray alloc] init];
    //self.host4LUNArray = [[NSMutableArray alloc] init];
    //self.host5LUNArray = [[NSMutableArray alloc] init];
    //self.host6LUNArray = [[NSMutableArray alloc] init];
    //self.host7LUNArray = [[NSMutableArray alloc] init];
    
    self.hostArrayForLUNArray = [[NSMutableArray alloc] init];
    [self.hostArrayForLUNArray addObject:[[NSMutableArray alloc] init]];
    [self.hostArrayForLUNArray addObject:[[NSMutableArray alloc] init]];
    [self.hostArrayForLUNArray addObject:[[NSMutableArray alloc] init]];
    [self.hostArrayForLUNArray addObject:[[NSMutableArray alloc] init]];
    [self.hostArrayForLUNArray addObject:[[NSMutableArray alloc] init]];
    [self.hostArrayForLUNArray addObject:[[NSMutableArray alloc] init]];
    [self.hostArrayForLUNArray addObject:[[NSMutableArray alloc] init]];
    [self insertDEMOdata];
    
    //init/add carouse view
    //carousel.delegate = self;
    //carousel.dataSource = self;
    //[self.view addSubview:carousel];
    
    //carouselDriver.delegate = self;
    //carouselDriver.dataSource = self;
    //[self.view addSubview:carouselDriver];
    //carouselDriver.stopAtItemBoundary = NO;
    //carouselDriver.scrollToItemBoundary = NO;
    //carouselDriver.scrollEnabled = NO;
    
    //carousel.type = iCarouselTypeInvertedCylinder;
    carousel.type = iCarouselTypeRotary;
    //carousel.type = iCarouselTypeInvertedRotary;// Rotary;
    //carousel.contentOffset = CGSizeMake(0, -60);
    //carousel.viewpointOffset = CGSizeMake(0, -50);
    carousel.decelerationRate = 0.9;
    
    [theDelegate customizedArcSlider: arcSlider radiusSlider:radiusSlider spacingSlider:spacingSlider sizingSlider:sizingSlider inView:self.view];
    
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
    //[theDelegate hideShowSliders:self.view];
    doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSWSide:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    //[self.thunderboltSW addGestureRecognizer:doubleTapGestureRecognizer];
    
    //[self.test addGestureRecognizer:doubleTapGestureRecognizer];
    [thunderboltSWButton addGestureRecognizer:doubleTapGestureRecognizer];
    
    
    //singleTapGestureRecognizerOnHost = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHostInformationOnHUD:)];
    //singleTapGestureRecognizerOnHost.numberOfTouchesRequired = 1;
    //singleTapGestureRecognizerOnHost.numberOfTapsRequired = 1;
    //[carousel addGestureRecognizer:singleTapGestureRecognizerOnHost];
    
    [lun0_0 addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    [lun0_1 addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    [lun0_2 addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    [lun0_3 addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    [lun1_0 addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    [lun1_1 addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    [lun1_2 addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    [lun1_3 addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    [lun2_0 addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    [lun2_1 addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    [lun2_2 addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    [lun2_3 addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    [lun3_0 addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    [lun3_1 addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    [lun3_2 addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    [lun3_3 addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [lun0_0 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [lun0_0 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];

    [lun0_1 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [lun0_1 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];

    [lun0_2 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [lun0_2 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];

    [lun0_3 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [lun0_3 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];


    [lun1_0 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [lun1_0 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    
    [lun1_1 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [lun1_1 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    
    [lun1_2 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [lun1_2 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    
    [lun1_3 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [lun1_3 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];


    [lun2_0 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [lun2_0 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    
    [lun2_1 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [lun2_1 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    
    [lun2_2 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [lun2_2 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    
    [lun2_3 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [lun2_3 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];

    [lun3_0 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [lun3_0 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    
    [lun3_1 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [lun3_1 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    
    [lun3_2 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [lun3_2 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    
    [lun3_3 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [lun3_3 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];

}


- (IBAction)imageMoved:(id) sender withEvent:(UIEvent *) event
{
    NSLog(@"%s %@ %@", __func__, sender, event);
    UIControl *control = sender;
    
    UITouch *t = [[event allTouches] anyObject];
    CGPoint pPrev = [t previousLocationInView:control];
    CGPoint p = [t locationInView:control];
    
    CGPoint center = control.center;
    center.x += p.x - pPrev.x;
    center.y += p.y - pPrev.y;
    control.center = center;
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
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%s", __func__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //carousel.delegate = nil;
    //carousel.dataSource = nil;
    //carousel = nil;
    //self.totalItems = nil;
    //self.activeItems = nil;
    self.host1LUNArray = nil;
    self.host2LUNArray = nil;
    self.host3LUNArray = nil;
    self.host4LUNArray = nil;
    self.host5LUNArray = nil;
    self.host6LUNArray = nil;
    self.host7LUNArray = nil;
}

- (void)changeSWSide:(id)sender {
    
    NSLog(@"%s", __func__);
    //UIButton *theButton = (UIButton *)sender;
    if (isFrontView) {
        [thunderboltSWButton setImage:[UIImage imageNamed:@"swBackView"] forState:UIControlStateNormal];
        isFrontView = FALSE;
    } else {
        [thunderboltSWButton setImage:[UIImage imageNamed:@"swFrontView"] forState:UIControlStateNormal];
        isFrontView = TRUE;
    }
}

- (IBAction)onHome:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideHud {
    NSLog(@"%s", __func__);
    if (isHUDshowing) {
        NSInteger delaySec = 0.1;
        [hud hide:YES afterDelay:delaySec];
        isHUDshowing = NO;
    }
}

- (void)onItemPress:(id)sender {
    UIButton *theButon = (UIButton *)sender;
    NSLog(@"%s onItemPress: tag=%d", __func__, theButon.tag);
    [self showHostInformationOnHUD:sender];
    //[self presentViewController:self.hbaViewController animated:YES completion:nil];
}

- (IBAction)reloadCarousel {
    NSLog(@"%s", __func__);
    [carousel reloadData];
}

- (IBAction)updateValue:(id)sender {
    UISlider *slider = (UISlider*)sender;
    //NSLog(@"%s %@ %@", __func__, sender, [sender restorationIdentifier]);
    
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

#pragma mark -
#pragma mark iCarousel methods

#pragma mark - iCarousel datasource and delegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)_carousel {
    if (_carousel == carousel) {
        return 7;
    }
    return 4;
}

- (UIView *)carousel:(iCarousel *)_carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    
    //class_getName([sender class]
    //id obj = [[self.hostArrayForLUNArray objectAtIndex:index] objectAtIndex:0];
    //UIButton *btn = class_getName([[[self.hostArrayForLUNArray objectAtIndex:index] objectAtIndex:0] class]) ;
    NSLog(@"%s index=%d", __func__, index);
    
    
    
    UILabel *theLabel = nil;
	if (view == nil) {
        UIButton *theButton;
        view = [[UIView alloc] init];
        //view.backgroundColor = [UIColor redColor];
        UIImage *theItemImage = nil;
        if (_carousel == self.carousel) {
            theItemImage = [UIImage imageNamed:@"macbookpro_blank.png"];
        } else {
            theItemImage = [UIImage imageNamed:@"storage.png"];
        }

        theLabel = [[UILabel alloc] init];
        theLabel.numberOfLines = 0;
        theLabel.textColor = [UIColor darkGrayColor];
        
        float itemWidth, itemHeight;
        
        itemWidth = theItemImage.size.width; // 250px
        itemHeight = theItemImage.size.height;
        
        theButton = [UIButton buttonWithType:UIButtonTypeCustom];
        theButton.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        theButton.backgroundColor = [UIColor redColor];
        //theButton.tag = ITEM_BUTTON_START_TAG + index;
        [theButton addTarget:self action:@selector(onItemPress:) forControlEvents:UIControlEventTouchUpInside];
        if (_carousel == self.carousel) {
            theLabel.frame = CGRectMake(0, itemHeight-10, itemWidth, 40);
            theLabel.font = [UIFont boldSystemFontOfSize:30.0];
        } else {
            theLabel.frame = CGRectMake(0, itemHeight-70, itemWidth, 40);
            [theLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:20.0]];
        }

        //theLabel.alpha = 0.5;
        theLabel.backgroundColor = [UIColor clearColor];
        theLabel.backgroundColor = [UIColor yellowColor];
        theLabel.textAlignment = NSTextAlignmentCenter;
        theLabel.tag = 1;
        
        [theButton setImage:theItemImage forState:UIControlStateNormal];

        view.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        [view addSubview:theButton];
        [view addSubview:theLabel];
        
        
        UITextView *theTextView = [[UITextView alloc] init];
        theTextView.text = @"Example of non-editable UITextView";
        theTextView.backgroundColor = [UIColor greenColor];
        theTextView.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        theTextView.editable = NO;
        
        [view addSubview:theTextView];

        NSMutableArray *lunForHost = [self.hostArrayForLUNArray objectAtIndex:index];
        //[lunForHost addObject:[[NSArray alloc] initWithObjects:sender, @"RW", nil]];
        //NSLog(@"%s [lunForHost count]=%d", __func__, [lunForHost count]);
        
        NSMutableString *mutableString = [[NSMutableString alloc] init];
        for (int i=0; i<[lunForHost count]; i++) {
            UIButton *btn = [[lunForHost objectAtIndex:i] objectAtIndex:0];
            NSString *authority = [[lunForHost objectAtIndex:i] objectAtIndex:1];
            NSLog(@"%d. btn = %@ (%@)", i, btn.currentTitle, authority);
            [mutableString appendString:[NSString stringWithFormat:@"%@(%@)\n", btn.currentTitle, authority]];
            if ([authority isEqualToString:@"R"]) {
                //[lunForHost replaceObjectAtIndex:lunIndex withObject:[[NSArray alloc] initWithObjects:sender, @"RW", nil]];
            } else { //if ([authority isEqualToString:@"RW"]) {
                //[lunForHost removeObjectAtIndex:lunIndex];
            }
        }
        theTextView.text = mutableString;
 
        
        //define button handler
     }
    else {
        theLabel = (UILabel *)[view viewWithTag:1];
	}
    if (_carousel == self.carousel) {
        theLabel.text = [NSString stringWithFormat:@"%d", index+1];
    } else {
        theLabel.text = [NSString stringWithFormat:@"RAID %d", index+1];
    }
	return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"%s index=%d",__func__, index);
    currentHostIndex = index;
    //[self presentViewController:self.hbaViewController animated:YES completion:nil];
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)_carousel {
    NSLog(@"%s %d",__func__, _carousel.currentItemIndex);
    NSMutableArray *lunForHost = [self.hostArrayForLUNArray objectAtIndex:carousel.currentItemIndex];
    //[lunForHost addObject:[[NSArray alloc] initWithObjects:sender, @"RW", nil]];
    //NSLog(@"%s [lunForHost count]=%d", __func__, [lunForHost count]);
    
    for (int i=0; i<[lunForHost count]; i++) {
        UIButton *btn = [[lunForHost objectAtIndex:i] objectAtIndex:0];
        NSLog(@"%@", btn.currentTitle);
    }
    //[_carousel reloadData];
    //currentItemIndex = _carousel.currentItemIndex;
    //[theDelegate updateItemIndexCountsAndTotalLabel:currentItemIndex count:currentCollectionCount total:totalCount forUILabel:itemIndexCountsAndTotalLabel];
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            if (_carousel == self.carousel) {
                return TRUE;
            }
            return FALSE;
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
            if (_carousel == self.carousel) {
                return value * spacingSlider.value;
            }
            return 0.9;
        }
        default:
        {
            return value;
        }
    }
}



@end
