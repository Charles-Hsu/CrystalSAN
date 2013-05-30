//
//  HAViewController.m
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Charles Hsu. All rights reserved.
//

#import "HAApplianceViewController.h"
#import "AppDelegate.h"
#import "XMLCacheParser.h"
#import "SyncManager.h"
#import <objc/runtime.h>


@interface HAApplianceViewController () {
    NSMutableArray *statusArray;
    NSInteger totalItemInCarousel;
    NSInteger currentCollectionNumber;
    
    NSUInteger currentItemIndex;
    NSUInteger currentCollectionCount;
    NSUInteger totalCount;
    
    AppDelegate *theDelegate;
    
    NSString *siteName;
    
    const NSMutableString *className;
    UITapGestureRecognizer *tripleTapGestureRecognizer;
    
}

//- (void)updateItemIndexCountsAndTotalLabel:(NSUInteger )curentIndex count:(NSUInteger)count total:(NSUInteger)total;

@end

@implementation HAApplianceViewController

@synthesize carousel;
@synthesize deviceArray;

@synthesize arcValue, radiusValue, spacingValue, sizingValue;
@synthesize arcLabel, radiusLabel, spacingLabel, sizingLabel;
@synthesize arcSlider, radiusSlider, spacingSlider, sizingSlider;

@synthesize names;
@synthesize searchBar;

@synthesize sanDatabase;
@synthesize itemIndexCountsAndTotalLabel;

@synthesize searchConnectionButton, searchNameButton, searchStatusButton;
@synthesize siteNameLabel;


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //set up carousel data
        //carousel = [[iCarousel alloc] initWithFrame:CGRectMake(50, 150, 924, 400)];
        carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 110, 1024, 460)];
        //carousel.backgroundColor = [UIColor cyanColor];

        tripleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTripleTap:)];
        tripleTapGestureRecognizer.numberOfTapsRequired = 3;

    }
    
    //className = class_getName([self class]);
    className = [NSMutableString stringWithUTF8String:class_getName([self class])];
    [className replaceOccurrencesOfString:@"Controller" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [className length])];
    NSLog(@"yourObject is a: %@", className);
    
    return self;
}

- (void)handleTripleTap:(id)sender {
    NSLog(@"%s", __func__);
    [theDelegate hideShowSliders:self.view];
    //[self hideShowSliders:sender];
}


- (void)loadHaClusterArray {
    //SyncManager
    //[sanDatabase httpGetHAClusterDictionaryBySiteName:theDelegate.siteName];
    deviceArray = [sanDatabase getHaApplianceNameListBySiteName:theDelegate.siteName];
    NSLog(@"%s site %@,  count = %u", __func__, theDelegate.siteName, [deviceArray count]);
    totalItemInCarousel = [deviceArray count];
    NSUInteger count = [deviceArray count];
    currentItemIndex = 0;
    currentCollectionCount =  count;
    totalCount = count;
    [theDelegate updateItemIndexCountsAndTotalLabel:currentItemIndex count:currentCollectionCount total:totalCount forUILabel:itemIndexCountsAndTotalLabel];
    [carousel reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //NSLog(@"%s", __func__);
    //get data
    theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    sanDatabase = theDelegate.sanDatabase;
    
    siteName = theDelegate.siteName;
    self.siteNameLabel.text = theDelegate.siteName;
    
    //init/add carouse view
    carousel.delegate = self;
    carousel.dataSource = self;
    [self.view addSubview:carousel];
    
    carousel.type = iCarouselTypeRotary; //0 - -0.01;
    
    carousel.contentOffset = CGSizeMake(0, -250);
    carousel.viewpointOffset = CGSizeMake(0, -330);
    carousel.decelerationRate = 0.9;
    
    self.haApplianceConnectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HAApplianceConnectionViewControllerID"];
    self.haApplianceConnectionViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [theDelegate customizedArcSlider: arcSlider radiusSlider:radiusSlider spacingSlider:spacingSlider sizingSlider:sizingSlider inView:self.view];
    
    [theDelegate customizedSearchArea:searchBar statusButton:searchStatusButton nameButton:searchNameButton connectionButton:searchConnectionButton inView:self.view];
    
    currentItemIndex = carousel.currentItemIndex;
    
    [self.viewForToggleSliders addGestureRecognizer:tripleTapGestureRecognizer];
    [theDelegate hideShowSliders:self.view];

    //[theDelegate.sanDatabase httpGetHAClusterDictionaryBySiteName:theDelegate.siteName];
}

- (void)viewWillAppear:(BOOL)animated {
    //NSLog(@"%s", __func__);
    //NSString *php = [NSString stringWithFormat:@"http-get_%@.php", className];
    //siteName = theDelegate.siteName;
    
    //NSString *urlString = [self hostURLPathWithPHP:php];
    //NSString *urlStringWithItems = [urlString stringByAppendingFormat:@"?site=%@", siteName];
    
    //NSLog(@"url=%@", urlStringWithItems);
    //[self httpGetAndParseURL:urlStringWithItems];
    //NSLog(@"%s siteName in current class = %@, siteName in delegate = %@", __func__, siteName, theDelegate.siteName);
    //
    //if(![siteName isEqualToString:theDelegate.siteName]) {
    //    siteName = theDelegate.siteName;
    //    [self loadHaClusterArray];
    //    [carousel reloadData];
    //    currentItemIndex = carousel.currentItemIndex;
    //    theDelegate.currentDeviceName = [deviceArray objectAtIndex:currentItemIndex];;
    //}
    [self loadHaClusterArray];
    
    currentItemIndex = carousel.currentItemIndex;
    theDelegate.currentDeviceName = [deviceArray objectAtIndex:currentItemIndex];
    theDelegate.currentHAApplianceName = [deviceArray objectAtIndex:currentItemIndex];
    
    self.siteNameLabel.text = theDelegate.siteName;



}

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"%s", __func__);
    currentItemIndex = carousel.currentItemIndex;
    theDelegate.currentDeviceName = [deviceArray objectAtIndex:currentItemIndex];
    //NSLog(@"%@", [deviceArray objectAtIndex:currentItemIndex]);
}

- (void)updateItemIndexCountsAndTotalLabel:(NSUInteger )currentIndex count:(NSUInteger)count total:(NSUInteger)total
{
        
    NSString *label = [NSString stringWithFormat:@" /%u /%u", count, total];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:label];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, [label length])];
    
    NSDictionary *boldSystemFontOfSize30Dict = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:30.0] forKey:NSFontAttributeName];
    NSAttributedString *indexString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%u", currentIndex+1] attributes:boldSystemFontOfSize30Dict];
    [attrString insertAttributedString:indexString atIndex:0];
    
    itemIndexCountsAndTotalLabel.attributedText = attrString;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event handler

- (void)onItemPress:(id)sender
{
    
    //NSLog(@"%s %@", __func__, [deviceArray objectAtIndex:currentItemIndex]);
    
    
    UIButton *theButon = (UIButton *)sender;
    NSInteger index = carousel.currentItemIndex;
    NSLog(@"onItemPress: tag=%d, current index=%u %@",theButon.tag, index, [deviceArray objectAtIndex:index]);
    
    currentItemIndex = carousel.currentItemIndex;

    theDelegate.currentDeviceName = [deviceArray objectAtIndex:currentItemIndex];
    theDelegate.currentHAApplianceName = [deviceArray objectAtIndex:currentItemIndex];
    
    //self.mirrorViewVcController.haApplianceName = [deviceArray objectAtIndex:currentItemIndex];
    //self.mirrorViewVcController.deviceLabel.text = self.mirrorViewVcController.haApplianceName;
    [self presentViewController:self.haApplianceConnectionViewController animated:YES completion:nil];
    
    //NSLog(@"end of %s, current ha: %@, %@-%@", __func__, theDelegate.currentDeviceName, theDelegate.currentEngineLeftSerial, theDelegate.currentEngineRightSerial);
    
    
}

- (IBAction)onHome:(id)sender
{
    //get data
    //AppDelegate *theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[theDelegate getSanVmirrorLists];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBack:(id)sender
{
    //get data
    //AppDelegate *theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [theDelegate getSanVmirrorLists];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logout:(id)sender {
    [theDelegate setCurrentSiteLogout];
    theDelegate.syncManager = nil;
    [self onHome:sender];
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
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm
{
    //descriptions = [sanDatabase getVmirrorListByKey:searchTerm];
    
    deviceArray = [sanDatabase getHaApplianceNameListBySiteName:@"" andKey:searchTerm];
    
    currentCollectionCount = [deviceArray count];
    [carousel scrollToItemAtIndex:0 animated:TRUE];
    currentItemIndex = carousel.currentItemIndex;
    
    [theDelegate updateItemIndexCountsAndTotalLabel:currentItemIndex count:currentCollectionCount total:totalCount forUILabel:itemIndexCountsAndTotalLabel];
    [carousel reloadData];
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
    //NSLog(@"%s index=%u %@", __func__, index, [deviceArray objectAtIndex:index]);
    UILabel *theLabel = nil;
    NSInteger status = [[statusArray objectAtIndex:index] integerValue];
    
	//create new view if no view is available for recycling
	if (view == nil)
	{
        UIButton *theButton;
        view = [[UIView alloc] init];
        //view.backgroundColor = [UIColor redColor];
        
        UIImage *theItemImage = nil;
        
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
        
        theLabel.frame = CGRectMake(0, itemHeight-20, itemWidth, 40);
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
    
    theLabel.text = [deviceArray objectAtIndex:index];
    
	return view;
}



- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"carousel:didSelectItemAtIndex:  %d",index);
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)_carousel
{
    currentItemIndex = _carousel.currentItemIndex;
    
    theDelegate.currentDeviceName = [deviceArray objectAtIndex:currentItemIndex];
    theDelegate.currentHAApplianceName = [deviceArray objectAtIndex:currentItemIndex];

    
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
