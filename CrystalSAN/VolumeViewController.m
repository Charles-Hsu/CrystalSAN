//
//  VolumeViewController.m
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Charles Hsu. All rights reserved.
//

#import "VolumeViewController.h"

@interface VolumeViewController ()

@end

@implementation VolumeViewController
@synthesize descriptions;
@synthesize carousel;

@synthesize radiusValue;
@synthesize spacingValue;
@synthesize arcValue;

@synthesize arcSlider;
@synthesize radiusSlider;
@synthesize spacingSlider;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"%s", __func__);
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //set up carousel data
        carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 110, 1024, 460)];
        //carousel.backgroundColor = [UIColor cyanColor];
        
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"Volume-1",@"Volume-2",@"Volume-3",@"Volume-2-1",
                             @"Volume-X3-3",@"Volume-X3-4",@"Volume-X3-3-1",@"Volume-X3-4-1",
                             @"Volume-X3-5",@"Volume-X3-6",@"Volume-X3-5-1",@"Volume-X3-6-1",
                             //@"Volume-X3-7",@"Volume-X3-8",@"Volume-X3-7-1",@"Volume-X3-8-1",
                             nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //get data
    //AppDelegate *theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
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
    
    //currentDeviceName = [descriptions objectAtIndex:0];
    
    //totalItemCount.text = [NSString stringWithFormat:@"%u", [descriptions count]];
    //currentItemIndex.text = @"1";
    
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

#pragma mark - event handler
- (void)onItemPress:(id)sender
{
    UIButton *theButon = (UIButton *)sender;
    
    NSLog(@"onItemPress: tag=%d",theButon.tag);
    
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

#pragma mark -
#pragma mark iCarousel methods

#pragma mark - iCarousel datasource and delegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSLog(@"%s %u", __func__, [descriptions count]);
    return [descriptions count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
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
        UIImage *theItemImage = [UIImage imageNamed:@"item-VolumeView"];
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
        
        itemWidth = theItemImage.size.width * 0.4 ;
        itemHeight = theItemImage.size.height * 0.4 ;
        
        theButton = [UIButton buttonWithType:UIButtonTypeCustom];
        theButton.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        //theButton.tag = ITEM_BUTTON_START_TAG + index;
        [theButton addTarget:self action:@selector(onItemPress:) forControlEvents:UIControlEventTouchUpInside];
        
        theLabel.frame = CGRectMake(0, itemHeight-25, itemWidth, 40);
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
    NSLog(@"%s: current index=%u '%@'", __func__, index, [descriptions objectAtIndex:index]);
    //currentItemIndex.text = [NSString stringWithFormat:@"%u", index+1];
    //currentDeviceName = [descriptions objectAtIndex:index];
}


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
