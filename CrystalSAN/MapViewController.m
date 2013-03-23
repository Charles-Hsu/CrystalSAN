//
//  MainViewController.m
//  CrystalSAN
//
//  Created by Charles Hsu on 12/25/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"


@interface MapViewController () {
    
    AppDelegate *theDelegate;
    NSArray *sites;

}

@end

//
// Setting the zoom level for a MKMapView
// code snip from http://stackoverflow.com/questions/4189621/setting-the-zoom-level-for-a-mkmapview
//
@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end

@implementation MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated
{
    NSLog(@"%s %f %f", __func__, self.region.span.latitudeDelta, self.region.span.longitudeDelta);
    //self.region
    MKCoordinateSpan span = MKCoordinateSpanMake(0, 360/pow(2, zoomLevel)*self.frame.size.width/256);
    [self setRegion:MKCoordinateRegionMake(centerCoordinate, span) animated:animated];
}

@end


@implementation MapViewController

@synthesize _mapView;
@synthesize carousel;

@synthesize arcSlider, radiusSlider, spacingSlider, sizingSlider;
@synthesize arcValue, radiusValue, spacingValue, sizingValue;
@synthesize arcLabel, radiusLabel, spacingLabel, sizingLabel;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    //NSLog(@"%s", __func__);
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //set up carousel data
        carousel = [[iCarousel alloc] initWithFrame:CGRectMake(80, 400, 864, 260)];
        //carousel = [[iCarousel alloc] initWithFrame:CGRectMake(80, 128, 864, 80)];

        //carousel.backgroundColor = [UIColor cyanColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    sites = [NSArray arrayWithObjects:
             @"China TV, Taiwan",
             @"KBS, Korea",
             @"Engine_231_232",@"Engine_233_234",@"Engine_235",@"Engine_237",@"Engine_239",
             @"Engine_241",@"Engine_243",@"Engine_245",@"Engine_247",@"Engine_249",
             @"Engine_251",
             @"VicomM01",@"VicomM02",@"VicomM03",@"VicomM04",
             //@"",
             nil];
    
    //get data
    theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    //init/add carouse view
    carousel.delegate = self;
    carousel.dataSource = self;
    
    //carousel.type = iCarouselTypeCylinder;
    carousel.type = iCarouselTypeRotary;
    
    carousel.contentOffset = CGSizeMake(0, -120);
    carousel.viewpointOffset = CGSizeMake(0, -150);
    carousel.decelerationRate = 0.9;


    [self.view addSubview:carousel];
    
    [theDelegate customizedArcSlider: arcSlider radiusSlider:radiusSlider spacingSlider:spacingSlider sizingSlider:sizingSlider inView:self.view];
    
 
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 39.281516;
    zoomLocation.longitude= -76.580806;
    
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    // 3
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    // 4
    [_mapView setRegion:adjustedRegion animated:YES];
    [_mapView setCenterCoordinate:zoomLocation zoomLevel:2 animated:YES];
    
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
    [theDelegate getSanVmirrorLists];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    [carousel reloadData];

}

- (IBAction)moveToTaipei:(id)sender
{
    //台北市的地理中心位置:
    //內湖區環山路和內湖路一段跟基湖路口
    //經緯度位置
    //東經121.33.55.79
    //北緯25.04.49.55
    double latitude = 25.044; //map.userLocation.location.coordinate.latitude;
    double longitude = 121.526; //map.userLocation.location.coordinate.longitude;
    
    //MKCoordinateRegion region;
    //region.center.latitude = 25.044;
    //region.center.longitude = 121.526;
    //X =
    
    //typedef struct {
    //    CLLocationDegrees latitude;
    //    CLLocationDegrees longitude;
    //} CLLocationCoordinate2D;

    CLLocationCoordinate2D location = (CLLocationCoordinate2D){.latitude = latitude, .longitude = longitude};
    
   //[self setMapRegionLongitude:Y andLatitude:X withLongitudeSpan:0.05 andLatitudeSpan:0.05];
    [_mapView setCenterCoordinate:location zoomLevel:2 animated:YES];
}


//自行定義的設定地圖函式
// http://furnacedigital.blogspot.tw/2010/12/mapkit.html
- (void)setMapRegionLongitude:(double)Y andLatitude:(double)X withLongitudeSpan:(double)SY andLatitudeSpan:(double)SX {
    
    //設定經緯度
    CLLocationCoordinate2D mapCenter;
    mapCenter.latitude = X;
    mapCenter.longitude = Y;
    
    //Map Zoom設定
    MKCoordinateSpan mapSpan;
    mapSpan.latitudeDelta = SX;
    mapSpan.longitudeDelta = SY;
    
    //設定地圖顯示位置
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapCenter;
    mapRegion.span = mapSpan;
    
    //前往顯示位置
    [_mapView setRegion:mapRegion];
    [_mapView regionThatFits:mapRegion];
}

#pragma mark -
#pragma mark iCarousel methods

#pragma mark - iCarousel datasource and delegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSLog(@"%s count=%d", __func__, [sites count]);
    return [sites count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    NSLog(@"%s index=%u %@", __func__, index, [sites objectAtIndex:index]);
    UILabel *theLabel = nil;
    //NSInteger status = [[statusArray objectAtIndex:index] integerValue];
    
	//create new view if no view is available for recycling
	if (view == nil)
	{
        UIButton *theButton;
        view = [[UIView alloc] init];
        //view.backgroundColor = [UIColor redColor];
        
        UIImage *theItemImage = nil;
        
        theItemImage = [UIImage imageNamed:@"Device-Site"];
        
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
    
    theLabel.text = [sites objectAtIndex:index];
    
	return view;
}



- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"carousel:didSelectItemAtIndex:  %d",index);
    
    //[self presentViewController:self.hbaViewController animated:YES completion:nil];
    
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
            //return 2 * M_PI * 1.49;
        }
        case iCarouselOptionRadius:
        {
            return value * radiusSlider.value;
            //return value * 0.54;
        }
        case iCarouselOptionSpacing:
        {
            //NSLog(@"iCarouselOptionSpacing=%f", spacingSlider.value);
            return value * spacingSlider.value;
            //return value * 2.5;
        }
        default:
        {
            return value;
        }
    }
}



@end
