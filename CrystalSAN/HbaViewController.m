//
//  MirrorViewController.m
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Charles Hsu. All rights reserved.
//

#import "HbaViewController.h"
#import "AppDelegate.h"


@interface HbaViewController () {
    
    NSMutableArray *statusArray;
    NSInteger totalItemInCarousel;
    
    NSUInteger currentItemIndex;
    NSUInteger currentCollectionCount;
    NSUInteger totalCount;
    
    AppDelegate *theDelegate;
    
    NSArray *deviceArray;

}
@end


@implementation HbaViewController

@synthesize carousel;
//@synthesize descriptions;

@synthesize arcValue, radiusValue, spacingValue, sizingValue;
@synthesize arcLabel, radiusLabel, spacingLabel, sizingLabel;
@synthesize arcSlider, radiusSlider, spacingSlider, sizingSlider;

@synthesize totalItem;
@synthesize totalItemCount;

@synthesize names;
@synthesize searchBar;

@synthesize searchConnectionButton, searchNameButton, searchStatusButton;
@synthesize itemIndexCountsAndTotalLabel;

@synthesize sanDatabase;
//@synthesize currentItemIndex;

@synthesize haApplianceName;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    //NSLog(@"%s", __func__);
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //set up carousel data
        carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 110, 1024, 460)];
        //carousel.backgroundColor = [UIColor cyanColor];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    //get data
    theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    sanDatabase = theDelegate.sanDatabase;
    
    NSLog(@"%s %@", __func__, theDelegate.currentDeviceName); 

    

    //NSLog(@"%s %@", __func__, deviceArray);
    
    //descriptions = [sanDatabase getVmirrorListByKey:@""];
    //NSLog(@"description count = %u", [descriptions count]);

    //init/add carouse view
    carousel.delegate = self;
    carousel.dataSource = self;
    [self.view addSubview:carousel];
    //self.iCarouselView.currentItemIndex = self.totalItems.count/2;
    
    carousel.type = iCarouselTypeRotary; //0 - -0.01;
    
    carousel.contentOffset = CGSizeMake(0, -250);
    carousel.viewpointOffset = CGSizeMake(0, -330);
    carousel.decelerationRate = 0.9;
        
    [theDelegate customizedArcSlider: arcSlider radiusSlider:radiusSlider spacingSlider:spacingSlider sizingSlider:sizingSlider inView:self.view];
    
    [theDelegate customizedSearchArea:searchBar statusButton:searchStatusButton nameButton:searchNameButton connectionButton:searchConnectionButton inView:self.view];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%s", __func__);
    //theDelegate.currentDeviceName = [deviceArray objectAtIndex:currentItemIndex];
    
    if ([theDelegate.currentDeviceName length] == 0) {
        haApplianceName.hidden = YES;
    }
    else {
        haApplianceName.hidden = NO;
    }
    
    // currentDeviceName in theDelegate is a HA-Cluster-Name
    
    NSLog(@"%s currentDeviceName %@", __func__, theDelegate.currentDeviceName);

    deviceArray = [sanDatabase getInitiatorListByEngineSerial:theDelegate.currentDeviceName];
    
    if (carousel.currentItemIndex > [deviceArray count]) {
        carousel.currentItemIndex = 0;
    }
 
    currentItemIndex = carousel.currentItemIndex;

    currentCollectionCount = [deviceArray count];
    totalCount = [deviceArray count];
    NSLog(@"%s %u %u %u",__func__, currentItemIndex, currentCollectionCount, totalCount);
    
    [theDelegate updateItemIndexCountsAndTotalLabel:currentItemIndex count:currentCollectionCount total:totalCount forUILabel:itemIndexCountsAndTotalLabel];
    
    NSLog(@"%s size of diskArray %u", __func__, [deviceArray count]);
    NSLog(@"%@", [deviceArray objectAtIndex:currentItemIndex]);

    
    totalItemInCarousel = [deviceArray count];
    
    [carousel reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event handler

- (void)onItemPress:(id)sender
{
    //UIButton *theButon = (UIButton *)sender;
    //NSInteger index = carousel.currentItemIndex;
    
    //NSLog(@"onItemPress: tag=%d, current index=%u %@",theButon.tag, index, [descriptions objectAtIndex:index]);
}

- (IBAction)onHome:(id)sender
{
    //get data
    //AppDelegate *theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [theDelegate getSanVmirrorLists];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBack:(id)sender
{
    //get data
    //AppDelegate *theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[theDelegate getSanVmirrorLists];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)refreshStatus
{
    
}

- (IBAction)reloadCarousel
{
    NSLog(@"%s", __func__);
    
    //[myNSMutableArray replaceObjectAtIndex:0 withObject:@\"object4.png\"];
    //NSInteger ok = 0;
    NSInteger degarded = 1;
    //NSInteger died = 2;
    
    //NSNumber *okStatus = [NSNumber numberWithInt:ok];
    NSNumber *degardedStatus = [NSNumber numberWithInt:degarded];
    //NSNumber *diedStatus = [NSNumber numberWithInt:died];
    
    [statusArray replaceObjectAtIndex:10 withObject:degardedStatus];
    
    [carousel reloadData];
}

- (IBAction)updateValue:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    NSLog(@"%s %@ %@", __func__, sender, [sender restorationIdentifier]);
    
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
    else if ([identifier isEqualToString:@"sizingSlider"])
    {
        sizingValue.text = [NSString stringWithFormat:@"%1.2f", slider.value];
    }
}


- (IBAction)showHideSliders:(id)sender
{
    [theDelegate hideShowSliders:self.view];
}


#pragma mark -
#pragma mark Custom Methods 
- (void)resetSearch
{
    /*
    self.names = [self.allNames mutableDeepCopy];
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    [keyArray addObjectsFromArray:[[[self.allNames allKeys] sortedArrayUsingSelector:@selector(compare:)]];
     self.keys = keyArray;
     */
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    //NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
    [self resetSearch];
    /*
    for (NSString *key in self.keys) {
        NSMutableArray *array = [names valueForKey:key];
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        for (NSString *name in array) {
            if ([name rangeOfString:searchTerm
                            options:NSCaseInsensitiveSearch].location == NSNotFound) [toRemove addObject:name];
        }
        if ([array count] == [toRemove count])
            [sectionsToRemove addObject:key];
        [array removeObjectsInArray:toRemove]; 
     }
     */
    //[self.keys removeObjectsInArray:sectionsToRemove];
    [carousel reloadData];
}

/*
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%s", __func__);
    //if ([keys count] == 0) return 0;
    //NSString *key = [keys objectAtIndex:section];
    //NSArray *nameSection = [names objectForKey:key];
    //return [nameSection count];
    return 0;
}
 */

#pragma mark -
#pragma mark Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"%s", __func__);
    //NSString *searchTerm = [searchBar text];
    //[self handleSearchForTerm:searchTerm];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm
{
    NSLog(@"%s searchTerm=%@", __func__, searchTerm);
    
    //descriptions = [sanDatabase getVmirrorListByKey:searchTerm];
    
    //deviceArray = [theDelegate.sanDatabase ]
    //[theDelegate.sanDatabase getInitiatorListByEngineSerial:theDelegate.currentDeviceName]
    
    [carousel reloadData];

    //[carousel scrollToItemAtIndex:0 animated:TRUE];
    if ([carousel numberOfItems] > 0) {
        //NSInteger index = carousel.currentItemIndex;
        //NSLog(@"%s: current index=%u '%@'", __func__, index, [descriptions objectAtIndex:index]);
        //currentItemIndex.text = [NSString stringWithFormat:@"%u", index+1];
    } else {
        //currentItemIndex.text = [NSString stringWithFormat:@"%u", 0];
    }
        
    //if ([searchTerm length] == 0) {
    //    [self resetSearch];
    //    [carousel reloadData];
    //    return;
    //}
    //[self handleSearchForTerm:searchTerm];
}

#pragma mark -
#pragma mark iCarousel methods

#pragma mark - iCarousel datasource and delegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSLog(@"%s count=%d", __func__, [deviceArray count]);
    return [deviceArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    NSLog(@"%s index=%u %@", __func__, index, [deviceArray objectAtIndex:index]);
    UILabel *theLabel = nil;
    //NSInteger status = [[statusArray objectAtIndex:index] integerValue];
    
    NSDictionary *dict = [deviceArray objectAtIndex:index];
    NSString *wwpn = [dict valueForKey:@"wwpn"];
    NSString *status = [dict valueForKey:@"status"];
    
	//create new view if no view is available for recycling
	if (view == nil)
	{
        UIButton *theButton;
        view = [[UIView alloc] init];
        //view.backgroundColor = [UIColor grayColor];
        view.contentMode = UIViewContentModeScaleAspectFit;
        
        UIImage *theItemImage = [UIImage imageNamed:@"Device-HBA-healthy"];
        
        if ([status isEqualToString:@"I"]) {
            theItemImage = [UIImage imageNamed:@"Device-HBA-disappeared"];
        }
        
        /*
        switch (status) {
            case 0: // healthy
                theItemImage = [UIImage imageNamed:@"Device-HBA-healthy"];
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
        
        itemWidth = theItemImage.size.width;
        itemHeight = theItemImage.size.height;
        
        theButton = [UIButton buttonWithType:UIButtonTypeCustom];
        theButton.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        
        //theButton.
        //theButton.tag = ITEM_BUTTON_START_TAG + index;
        [theButton addTarget:self action:@selector(onItemPress:) forControlEvents:UIControlEventTouchUpInside];
        
        theLabel.frame = CGRectMake(0, itemHeight-25, itemWidth, 40);
        //theLabel.alpha = 0.5;
        theLabel.backgroundColor = [UIColor clearColor];
        //theLabel.backgroundColor = [UIColor yellowColor];
        theLabel.textAlignment = NSTextAlignmentCenter;
        theLabel.tag = 1;
        
        //NSLog(@"theButton.tag=%u", theButton.tag);
        
        view.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        view.contentMode = UIViewContentModeScaleAspectFit;
        
        [view addSubview:theButton];
        [view addSubview:theLabel];
        //define button handler
        [theButton setImage:theItemImage forState:UIControlStateNormal];
        //theButton.contentMode = UIViewContentModeScaleAspectFit;
    }
    else
	{
        theLabel = (UILabel *)[view viewWithTag:1];
	}
    
    theLabel.text = [NSString stringWithFormat:@"%@(%@)", wwpn, status];

	return view;
}



- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    currentItemIndex = index;
    currentCollectionCount = [deviceArray count];
    totalCount = [deviceArray count];
    NSLog(@"%s %u %u %u",__func__, currentItemIndex, currentCollectionCount, totalCount);
    [theDelegate updateItemIndexCountsAndTotalLabel:currentItemIndex count:currentCollectionCount total:totalCount forUILabel:itemIndexCountsAndTotalLabel];

}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)_carousel
{
    //NSInteger index = _carousel.currentItemIndex;
    //NSLog(@"%s: current index=%u '%@'", __func__, index, [descriptions objectAtIndex:index]);
    //currentItemIndex.text = [NSString stringWithFormat:@"%u", index+1];
    currentItemIndex = _carousel.currentItemIndex;
    currentCollectionCount = [deviceArray count];
    totalCount = [deviceArray count];
    NSLog(@"%s %u %u %u",__func__, currentItemIndex, currentCollectionCount, totalCount);
    [theDelegate updateItemIndexCountsAndTotalLabel:currentItemIndex count:currentCollectionCount total:totalCount forUILabel:itemIndexCountsAndTotalLabel];
    

    
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
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
            return value * spacingSlider.value;
        }
        default:
        {
            return value;
        }
    }
}



@end
