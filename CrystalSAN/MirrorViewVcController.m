//
//  RaidViewController.m
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Charles Hsu. All rights reserved.
//

#import "MirrorViewVcController.h"
#import "AppDelegate.h"
#import "MainViewController.h"


#define ITEM_BUTTON_START_TAG_RAIDVIEW 300

@interface MirrorViewVcController () {

    NSMutableArray *statusArray;
    NSInteger totalItemInCarousel;
    NSInteger currentCollectionNumber;
    
    NSUInteger currentItemIndex;
    NSUInteger currentCollectionCount;
    NSUInteger totalCount;
    
    AppDelegate *theDelegate;
}
@end

@implementation MirrorViewVcController

@synthesize deviceName, deviceLabel;
@synthesize carousel;
@synthesize descriptions;
@synthesize sanDatabase;

@synthesize arcValue, radiusValue, spacingValue, sizingValue;
@synthesize arcLabel, radiusLabel, spacingLabel, sizingLabel;
@synthesize arcSlider, radiusSlider, spacingSlider, sizingSlider;

@synthesize lun00Button, lun01Button, lun02Button, lun03Button, lun04Button, lun05Button;
@synthesize lun00Label, lun01Label, lun02Label, lun03Label, lun04Label, lun05Label;

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
    
    [deviceLabel setText:[NSString stringWithFormat:@"%@", deviceName]];
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
    
    self.deviceLabel.text = theDelegate.currentDeviceName;
    
    NSLog(@"%s deviceName=%@", __func__, theDelegate.currentDeviceName);

}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%s", __func__);
    self.deviceLabel.text = theDelegate.currentDeviceName;
    //NSLog(@"%@", [deviceArray objectAtIndex:currentItemIndex]);
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
