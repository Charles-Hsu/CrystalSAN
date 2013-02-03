//
//  MirrorViewController.m
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Charles Hsu. All rights reserved.
//

#import "MirrorViewController.h"

@interface MirrorViewController ()

@end

@implementation MirrorViewController

@synthesize carousel;
@synthesize descriptions;

@synthesize arcValue;
@synthesize radiusValue;
@synthesize spacingValue;

@synthesize arcSlider;
@synthesize radiusSlider;
@synthesize spacingSlider;

@synthesize totalItemCount;
@synthesize currentItemIndex;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"%s", __func__);
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //set up carousel data
        carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 110, 1024, 460)];
        //carousel.backgroundColor = [UIColor cyanColor];
        
        descriptions = [NSMutableArray arrayWithObjects:
                        @"Engine_227",
                        @"Engine_229",
                        @"Engine_231",@"Engine_233",@"Engine_235",@"Engine_237",@"Engine_239",
                        @"Engine_241",@"Engine_243",@"Engine_245",@"Engine_247",@"Engine_249",
                        @"Engine_251",
                        @"VicomM01",@"VicomM02",@"VicomM03",@"VicomM04",
                        //@"",
                        nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
    
    totalItemCount.text = [NSString stringWithFormat:@"%u", [descriptions count]];
    currentItemIndex.text = @"1";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event handler

- (void)onItemPress:(id)sender
{
    UIButton *theButon = (UIButton *)sender;
    NSInteger index = carousel.currentItemIndex;
    
    NSLog(@"onItemPress: tag=%d, current index=%u %@",theButon.tag, index, [descriptions objectAtIndex:index]);
    
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
    NSLog(@"%s count=%d", __func__, [descriptions count]);
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
        UIImage *theItemImage = [UIImage imageNamed:@"item-MirrorView"];
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
        itemWidth = theItemImage.size.width / 2 ;
        itemHeight = theItemImage.size.height / 2 ;
        //}
        
        theButton = [UIButton buttonWithType:UIButtonTypeCustom];
        theButton.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        //theButton.tag = ITEM_BUTTON_START_TAG + index;
        [theButton addTarget:self action:@selector(onItemPress:) forControlEvents:UIControlEventTouchUpInside];
        
        theLabel.frame = CGRectMake(0, itemHeight-35, itemWidth, 40);
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



- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"carousel:didSelectItemAtIndex:  %d",index);
    //currentDeviceName = [[descriptions objectAtIndex:index] stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    //currentDeviceName = [descriptions objectAtIndex:index];
    //NSLog(@"current device name = %@", currentDeviceName);
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)_carousel
{
    NSInteger index = _carousel.currentItemIndex;
    NSLog(@"%s: current index=%u '%@'", __func__, index, [descriptions objectAtIndex:index]);
    currentItemIndex.text = [NSString stringWithFormat:@"%u", index+1];
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //NSLog(@"%s", __func__);
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
