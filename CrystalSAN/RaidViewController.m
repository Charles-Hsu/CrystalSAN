//
//  RaidViewController.m
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Charles Hsu. All rights reserved.
//

#import "RaidViewController.h"
#import "RaidViewConfigController.h"
#import "AppDelegate.h"


#define ITEM_BUTTON_START_TAG_RAIDVIEW 300

@interface RaidViewController ()
{
    NSString *currentDeviceName;
    
    NSUInteger currentItemIndex;
    NSUInteger currentCollectionCount;
    NSUInteger totalCount;

    
    AppDelegate *theDelegate;

}
@end

@implementation RaidViewController

@synthesize animals, descriptions;
@synthesize carousel;

@synthesize arcSlider, radiusSlider, spacingSlider, sizingSlider;
@synthesize arcValue, radiusValue, spacingValue, sizingValue;
@synthesize arcLabel, radiusLabel, spacingLabel, sizingLabel;


@synthesize searchBar;
@synthesize itemIndexCountsAndTotalLabel;

@synthesize searchConnectionButton, searchNameButton, searchStatusButton;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"%s", __func__);

    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //set up carousel data
        carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 110, 1024, 460)];
        //carousel.backgroundColor = [UIColor cyanColor];
        
        self.animals = [NSMutableArray arrayWithObjects:@"Bear.png",
                        @"Zebra.png",
                        @"Tiger.png",
                        @"Goat.png",
                        @"Birds.png",
                        @"Giraffe.png",
                        @"Chimp.png",
                        @"Bear.png",
                        @"Zebra.png",
                        @"Tiger.png",
                        @"Goat.png",
                        @"Birds.png",
                        nil];
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"RAID-X3-1",@"RAID-X3-2",@"RAID-X3-1-1",@"RAID-X3-2-1",
                             @"RAID-X3-3",@"RAID-X3-4",@"RAID-X3-3-1",@"RAID-X3-4-1",
                             @"RAID-X3-5",@"RAID-X3-6",@"RAID-X3-5-1",@"RAID-X3-6-1",
                             @"RAID-X3-7",@"RAID-X3-8",@"RAID-X3-7-1",@"RAID-X3-8-1",
                             @"RAID-X3-9",@"RAID-X3-10",@"RAID-X3-9-1",@"RAID-X3-10-1",
                             @"RAID-X3-11",@"RAID-X3-11-1",@"RAID-X3-12",@"RAID-X3-12-1",
                             @"RAID-Low2-1",@"RAID-Low2-1-1",@"RAID-Low2-2",@"RAID-Low2-2-1",
                             @"RAID-Low2-3",@"RAID-Low2-3-1",@"RAID-Low2-4",@"RAID-Low2-4-1",
                             @"RAID-Low2-5",@"RAID-Low2-5-1",@"RAID-Low2-6",@"RAID-Low2-6-1",
                             @"RAID-Low2-M",@"RAID-X4-M-1",@"RAID-Low2-M-1",@"RAID-X4-M-1",@"RAID-X4-M",@"RAID-X3-M-1",@"RAID-X3-M",
                             @"RAID-X4-1",@"RAID-X4-1-1",@"RAID-X4-2",@"RAID-X4-2-1",@"RAID-X4-3",@"RAID-X4-3-1",
                             @"RAID-X4-4",@"RAID-X4-4-1",
                             @"RAID-X4-5",@"RAID-X4-6",@"RAID-X4-5-1",@"RAID-X4-6-1",
                             @"RAID-X4-7",@"RAID-X4-7-1",@"RAID-X4-8",@"RAID-X4-8-1",
                             @"RAID-X4-9",@"RAID-X4-10",@"RAID-X4-9-1",@"RAID-X4-10-1",
                             @"RAID-37",@"RAID-38",@"RAID-37-1",@"RAID-38-1",
                             @"RAID-X4-11",@"RAID-X4-12",@"RAID-X4-11-1",@"RAID-X4-12-1",
                             @"RAID-X4-13",@"RAID-X4-14",@"RAID-X4-13-1",@"RAID-X4-14-1",
                             nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //get data
    theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //self.totalItems = theDelegate.totalItems;
    //self.activeItems = theDelegate.activeItems;
    
    //init/add carouse view
    carousel.delegate = self;
    carousel.dataSource = self;
    [self.view addSubview:carousel];
    //self.iCarouselView.currentItemIndex = self.totalItems.count/2;
    
    carousel.type = iCarouselTypeRotary; //0 - -0.01;
    //self.iCarouselView.type = iCarouselTypeLinear;
    
    carousel.contentOffset = CGSizeMake(0, -250);
    carousel.viewpointOffset = CGSizeMake(0, -330);
    carousel.decelerationRate = 0.9;
    
    currentDeviceName = [descriptions objectAtIndex:0];
    
    //totalItemCount.text = [NSString stringWithFormat:@"%u", [descriptions count]];
    //currentItemIndex.text = @"1";
    
    NSUInteger count = [descriptions count];
    
    currentItemIndex = 0;
    currentCollectionCount =  count;
    totalCount = count;

    [theDelegate updateItemIndexCountsAndTotalLabel:currentItemIndex count:currentCollectionCount total:totalCount forUILabel:itemIndexCountsAndTotalLabel];

    [theDelegate customizedArcSlider: arcSlider radiusSlider:radiusSlider spacingSlider:spacingSlider sizingSlider:sizingSlider inView:self.view];
    
    [theDelegate customizedSearchArea:searchBar statusButton:searchStatusButton nameButton:searchNameButton connectionButton:searchConnectionButton inView:self.view];
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    carousel.delegate = nil;
    carousel.dataSource = nil;
    carousel = nil;
    self.totalItems = nil;
    self.activeItems = nil;
}


- (IBAction)onHome:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)reloadCarousel
{
    NSLog(@"%s", __func__);
    [carousel reloadData];
}

/*
- (IBAction)updateValue:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    NSLog(@"%s %@ %@", __func__, sender, [sender restorationIdentifier]);
    NSString *identifier = [sender restorationIdentifier];
    if ([identifier isEqualToString:@"arcSlider"]) {
        arcValue.text = [NSString stringWithFormat:@"%1.2f", slider.value];
    } else if ([identifier isEqualToString:@"radiusSlider"]) {
        radiusValue.text = [NSString stringWithFormat:@"%1.2f", slider.value];
    } else if ([identifier isEqualToString:@"spacingSlider"]) {
        spacingValue.text = [NSString stringWithFormat:@"%1.2f", slider.value];
    } //else if ([identifier isEqualToString:@"contentSlider"]) {
    //    contentValue.text = [NSString stringWithFormat:@"%1.2f", slider.value];
    //} else if ([identifier isEqualToString:@"viewpointSlider"]) {
    //    viewpointValue.text = [NSString stringWithFormat:@"%1.2f", slider.value];
    //    carousel.viewpointOffset = CGSizeMake(0, 100*slider.value);
    //}
    
}
*/

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


#pragma mark - event handler
- (void)onItemPress:(id)sender
{
    UIButton *theButon = (UIButton *)sender;
    
    NSLog(@"onItemPress: tag=%d",theButon.tag);
    
    /*
    if (theButon.tag == 201) { // RaidViewController
        [self presentViewController:self.raidViewController animated:YES completion:nil];
    } else if (theButon.tag == 202) { // MirrorViewController
        [self presentViewController:self.mirrorViewController animated:YES completion:nil];
    } else if (theButon.tag == 203) { // VolumeViewController
        [self presentViewController:self.volumeViewController animated:YES completion:nil];
    }
     */
}

- (IBAction)buttonConfigPressed:(id)sender
{
    NSLog(@"%s", __func__);
    [self performSegueWithIdentifier:@"RaidViewConfigSegue" sender:sender];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    //NSString *segueId = [segue identifier];
    NSLog(@"%s %@ currentDeviceName=%@", __func__, [segue identifier], currentDeviceName);
    
    if ([[segue identifier] isEqualToString:@"RaidViewConfigSegue"])
    {
        RaidViewConfigController *vc = [segue destinationViewController];
        [vc setDeviceName:currentDeviceName];
    }
    
}


#pragma mark -
#pragma mark iCarousel methods

#pragma mark - iCarousel datasource and delegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [descriptions count];
}

/*
- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    return 3;
    return [animals count];
}
 */


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    /*
    NSLog(@"%s index=%u %@ %@", __func__, index, [animals objectAtIndex:index], [descriptions objectAtIndex:index]);
    
    UIButton *theButton;
    UIView *theView;
    theView.backgroundColor = [UIColor redColor];
    
    //UIImage *theItemImage = [UIImage imageNamed:[animals objectAtIndex:index]];
    UIImage *theItemImage = [UIImage imageNamed:@"item-RAIDView"];
    //Item-RAIDView
    
    
    UILabel *theLabel = [[UILabel alloc] init];
    theLabel.text = [descriptions objectAtIndex:index];
    theLabel.numberOfLines = 0;
    theLabel.textColor = [UIColor darkGrayColor];
    
	//create new view if no view is available for recycling
	if (view == nil)
	{
        theView = [[UIView alloc] init];
        //UITableView *tableView = [[[UITableView alloc] init] autorelease];
        //[theView addSubview:tableView];
        
        float itemWidth, itemHeight;
        
        
        if (index == [descriptions count]-1) // the last one, item image
        {
            theView.alpha = 0.6; // set transparnet to 80%
        }

        //button size
        //if(self.iCarouselView.type == iCarouselTypeTimeMachine)
        //{
        //    itemWidth = theItemImage.size.width ;
        //    itemHeight = theItemImage.size.height ;
        //}
        //else if(self.iCarouselView.type == iCarouselTypeInvertedCylinder)
        //{
        //    itemWidth = theItemImage.size.width / 2 ;
        //    itemHeight = theItemImage.size.height  / 2 ;
        //}
        //else
        //{
        itemWidth = theItemImage.size.width / 2 ;
        itemHeight = theItemImage.size.height / 2 ;
        //}
        
        theButton = [UIButton buttonWithType:UIButtonTypeCustom];
        theButton.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        //theButton.tag = ITEM_BUTTON_START_TAG + index;
        [theButton addTarget:self action:@selector(onItemPress:) forControlEvents:UIControlEventTouchUpInside];
        
        theLabel.frame = CGRectMake(0, itemHeight-52, itemWidth, 40);
        //theLabel.alpha = 0.5;
        theLabel.backgroundColor = [UIColor clearColor];
        //theLabel.backgroundColor = [UIColor yellowColor];
        theLabel.textAlignment = NSTextAlignmentCenter;
        
        NSLog(@"theButton.tag=%u", theButton.tag);
        
        theView.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        [theView addSubview:theButton];
        [theView addSubview:theLabel];
    }
    else
	{
		//theButton = (UIButton *)view;
        theView = view;
	}
	
    //define button handler
    [theButton setImage:theItemImage forState:UIControlStateNormal];
    
	return theView;//theButton;
     */
    
    NSLog(@"%s index=%u %@", __func__, index, [descriptions objectAtIndex:index]);
    UILabel *theLabel = nil;
	//create new view if no view is available for recycling
	if (view == nil)
	{
        UIButton *theButton;
        //UIView *theView;
        view = [[UIView alloc] init];
        //view.backgroundColor = [UIColor redColor];
        
        //UIImage *theItemImage = [UIImage imageNamed:[animals objectAtIndex:index]];
        UIImage *theItemImage = [UIImage imageNamed:@"Device-Raid-healthy"];
        //Item-RAIDView
        
        theLabel = [[UILabel alloc] init];
        
        theLabel.numberOfLines = 0;
        theLabel.textColor = [UIColor darkGrayColor];
        
        //UITableView *tableView = [[[UITableView alloc] init] autorelease];
        //[theView addSubview:tableView];
        
        if (index == [descriptions count]-1) // the last one, item image
        {
            //view.alpha = 0.5; // set transparnet to 80%
        }
        
        float itemWidth, itemHeight;
        
        //button size
        //if(self.iCarouselView.type == iCarouselTypeTimeMachine)
        //{
        //    itemWidth = theItemImage.size.width ;
        //    itemHeight = theItemImage.size.height ;
        //}
        //else if(self.iCarouselView.type == iCarouselTypeInvertedCylinder)
        //{
        //    itemWidth = theItemImage.size.width / 2 ;
        //    itemHeight = theItemImage.size.height  / 2 ;
        //}
        //else
        //{
        itemWidth = theItemImage.size.width;
        itemHeight = theItemImage.size.height;
        //}
        
        theButton = [UIButton buttonWithType:UIButtonTypeCustom];
        theButton.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        //theButton.tag = ITEM_BUTTON_START_TAG + index;
        [theButton addTarget:self action:@selector(onItemPress:) forControlEvents:UIControlEventTouchUpInside];
        
        theLabel.frame = CGRectMake(0, itemHeight-23, itemWidth, 40);
        //theLabel.alpha = 0.5;
        theLabel.backgroundColor = [UIColor clearColor];
        //theLabel.backgroundColor = [UIColor yellowColor];
        theLabel.textAlignment = NSTextAlignmentCenter;
        theLabel.tag = 1;
        
        NSLog(@"theButton.tag=%u", theButton.tag);
        
        view.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        [view addSubview:theButton];
        [view addSubview:theLabel];
        //define button handler
        [theButton setImage:theItemImage forState:UIControlStateNormal];
    }
    else
	{
		//theButton = (UIButton *)view;
        //theView = view;
        theLabel = (UILabel *)[view viewWithTag:1];
	}
    
    theLabel.text = [descriptions objectAtIndex:index];
	
    
	return view;//theButton;

}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)_carousel
{
    NSInteger index = _carousel.currentItemIndex;
    //NSLog(@"%s: current index=%u '%@'", __func__, index, [descriptions objectAtIndex:index]);
    //currentItemIndex.text = [NSString stringWithFormat:@"%u", index+1];
    currentDeviceName = [descriptions objectAtIndex:index];
}


//- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
//{
    //NSLog(@"carousel:didSelectItemAtIndex:  %d",index);
    //currentDeviceName = [[descriptions objectAtIndex:index] stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    //currentDeviceName = [descriptions objectAtIndex:index];
    //NSLog(@"current device name = %@", currentDeviceName);
//}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //float wrap = 0;
    switch (option)
    {
            //case iCarouselOptionWrap:
            //{
            //    return 1;
            //}
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
            //NSLog(@"iCarouselOptionArc=%f", arcSlider.value);
            return 2 * M_PI * arcSlider.value;
            //return 2 * M_PI * 0.28;
            //return 2 * M_PI * 0.1;
        }
        case iCarouselOptionRadius:
        {
            //NSLog(@"iCarouselOptionRadius=%f", radiusSlider.value);
            return value * radiusSlider.value;
            //return value * 1.695;
        }
            //case iCarouselOptionTilt:
            //{
            //    return tiltSlider.value;
            //}
        case iCarouselOptionSpacing:
        {
            //NSLog(@"iCarouselOptionSpacing=%f", spacingSlider.value);
            return value * spacingSlider.value;
            //return value * 0.75;
        }
        default:
        {
            return value;
        }
    }
}



@end
