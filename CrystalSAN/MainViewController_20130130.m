//
//  MainViewController.m
//  CrystalSAN
//
//  Created by Charles Hsu on 12/25/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"


@interface MainViewController ()

@end

@implementation MainViewController

@synthesize carousel;
@synthesize arcValue;
@synthesize radiusValue;
@synthesize spacingValue;

@synthesize arcSlider;
@synthesize radiusSlider;
@synthesize spacingSlider;


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        //carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 120, 1024, 480)];
        carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 130, 1024, 460)];
        //carousel.backgroundColor = [UIColor cyanColor];
        
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"RAID View",
                             @"HA Appliance View",
                             @"Volume View",
                             @"Datacenter View",
                             @"Rack View",
                             @"Connection View",
                             @"Data Flow View",
                             @"Switch View",
                             @"Host View",
                             @"Maintenance View",
                             @"Provisioning Wizard",
                             @"",
                             nil];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //get data
    AppDelegate *theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.totalItems = theDelegate.totalItems;
    self.activeItems = theDelegate.activeItems;
    
    //init/add carouse view
    carousel.delegate = self;
    carousel.dataSource = self;
    [self.view addSubview:carousel];
    
    carousel.type = iCarouselTypeRotary; //0 - -0.01;
    
    carousel.contentOffset = CGSizeMake(0, -250);
    carousel.viewpointOffset = CGSizeMake(0, -330);
    carousel.decelerationRate = 0.9;
    
    NSLog(@"viewpointOffset=(%f,%f)", carousel.viewpointOffset.width, carousel.viewpointOffset.height);
    NSLog(@"contentOffset=(%f,%f)", carousel.contentOffset.width, carousel.contentOffset.height);

    [carousel scrollToItemAtIndex:2 animated:TRUE];
    
    // Here does not use the method
    // -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender defined in storyboard,
    // So delete the connection between the class 'MainViewController' and other three class,
    // ie, RaidViewController, MirrorViewController and VolumeViewController,
    // otherwise the trnasition behaviour will follow the defined in storyboard
    
    self.raidViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RaidViewControllerID"];
    //self.raidViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    self.mirrorViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MirrorViewControllerID"];
    self.mirrorViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    self.volumeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VolumeViewControllerID"];
    self.volumeViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

/*
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"%s: %@",__func__, sender);
}
 */

#pragma mark - event handler
- (void)onItemPress:(id)sender
{
    NSLog(@"%s: %@",__func__, sender);
          
    UIButton *theButon = (UIButton *)sender;
    if (theButon.tag == 201) // RaidViewController
    { 
        [self presentViewController:self.raidViewController animated:YES completion:nil];
        //[self performSegueWithIdentifier:<#(NSString *)#> sender:<#(id)#>]
        //[self performSegueWithIdentifier:@"PushPhotoBrowser" sender:self];
    }
    else if (theButon.tag == 202) // MirrorViewController
    { 
        [self presentViewController:self.mirrorViewController animated:YES completion:nil];
    }
    else if (theButon.tag == 203) // VolumeViewController
    { 
        [self presentViewController:self.volumeViewController animated:YES completion:nil];
    }
}

- (IBAction)reloadCarousel
{
    [carousel reloadData];
}

- (IBAction)updateValue:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    NSString *identifier = [sender restorationIdentifier];
    
    if ([identifier isEqualToString:@"arcSlider"])
    {
        arcValue.text = [NSString stringWithFormat:@"%1.2f", slider.value];
    }
    else if ([identifier isEqualToString:@"radiusSlider"])
    {
        radiusValue.text = [NSString stringWithFormat:@"%1.2f", slider.value];
    }
    else if ([identifier isEqualToString:@"spacingSlider"])
    {
        spacingValue.text = [NSString stringWithFormat:@"%1.2f", slider.value];
    } 
}

#pragma mark - iCarousel datasource and delegate
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.descriptions count];
    //return [self.totalItems count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    NSLog(@"%s index=%u %@", __func__, index, self.totalItems[index]);
    
    UIButton *theButton;
    UIView *theView;
    
    UIImage *theItemImage = [UIImage imageNamed:self.totalItems[index]];
    UILabel *theLabel = [[UILabel alloc] init];
    //theLabel.text = [NSString stringWithFormat:@"%u %@", index, [self.descriptions objectAtIndex:index]];
    theLabel.text = [NSString stringWithFormat:@"%@", [self.descriptions objectAtIndex:index]];
    theLabel.textColor = [UIColor darkGrayColor];

	//create new view if no view is available for recycling
	if (view == nil)
	{
        theView = [[[UIView alloc] init] autorelease];
        
        float itemWidth = theItemImage.size.width /4 * 3;
        float itemHeight = theItemImage.size.height /4 * 3;
       
        theButton = [UIButton buttonWithType:UIButtonTypeCustom];
        theButton.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        theButton.tag = ITEM_BUTTON_START_TAG + index;
        
        if (index == [self.totalItems count]-1) // the last one, item image
        {
            theView.alpha = 0.6; // set transparnet to 80%
        }
        
        [theButton addTarget:self action:@selector(onItemPress:) forControlEvents:UIControlEventTouchUpInside];
        //[theButton addTarget:self action:@selector(performSegueWithIdentifier:) forControlEvents:UIControlEventTouchUpInside];
        //performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
        
        float x = 0;
        float y = 0;
        float w = itemWidth/3*2;
        float h = 80;
        float centerx = itemWidth/2;
        float centery = (itemHeight-90)/2;
        
        UIColor *textColor = [UIColor whiteColor];
        
        if (index < 3) // lower the center with 50 points
        {
            centery = centery + 50;
            textColor = [UIColor darkGrayColor];
        }
        
        theLabel.frame = CGRectMake(x, y, w, h);

        CGPoint center = CGPointMake(centerx, centery);
        theLabel.center = center; // should do after frame has been assigned
        
        theLabel.backgroundColor = [UIColor clearColor];
        //theLabel.backgroundColor = [UIColor blackColor];
        theLabel.textAlignment = NSTextAlignmentCenter;
        theLabel.textColor = textColor;
        theLabel.font = [UIFont boldSystemFontOfSize:20.0];
        theLabel.lineBreakMode = UILineBreakModeWordWrap;
        theLabel.numberOfLines = 0;

        NSLog(@"theButton.tag=%u", theButton.tag);
        
        theView.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        [theView addSubview:theButton];
        [theView addSubview:theLabel];
    }
    else
	{
        theView = view;
	}
	
    //define button handler
    [theButton setImage:theItemImage forState:UIControlStateNormal];
    
	return theView;
}


- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"carousel:didSelectItemAtIndex:  %d",index);
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    float wrap = 1;
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return wrap;
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
        //case iCarouselOptionTilt:
        //{
        //    return tiltSlider.value;
        //}
        case iCarouselOptionSpacing:
        {
            return value * spacingSlider.value;
        }
        default:
        {
            return value;
        }
    }
}



@end
