//
//  MainViewController.m
//  CrystalSAN
//
//  Created by Charles Hsu on 12/25/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"

//#import "MainViewController.h"

#import "FLLocation.h"


@interface MapViewController () {
    
    AppDelegate *theDelegate;
    
    NSArray *sites;
    NSMutableArray *locations;
    //NSArray *zoomLevels;
    
    BOOL regionWillChangeAnimatedCalled;// = YES;
    BOOL regionChangedBecauseAnnotationSelected; // = NO;

}

@end

/*
#define MERCATOR_RADIUS 85445659.44705395
#define MAX_GOOGLE_LEVELS 20
//
// Setting the zoom level for a MKMapView
// http://stackoverflow.com/questions/4189621/setting-the-zoom-level-for-a-mkmapview
//
// how to find current zoom level of MKMapView
// http://stackoverflow.com/questions/7594827/how-to-find-current-zoom-level-of-mkmapview
//
// 
@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

- (double)getZoomLevel;

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

- (double)getZoomLevel
{
    CLLocationDegrees longitudeDelta = self.region.span.longitudeDelta;
    CGFloat mapWidthInPixels = self.bounds.size.width;
    double zoomScale = longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * mapWidthInPixels);
    double zoomer = MAX_GOOGLE_LEVELS - log2( zoomScale );
    if ( zoomer < 0 ) zoomer = 0;
    //  zoomer = round(zoomer);
    return zoomer;
}

@end
 */


@implementation MapViewController

@synthesize _mapView;
@synthesize carousel;

@synthesize arcSlider, radiusSlider, spacingSlider, sizingSlider;
@synthesize arcValue, radiusValue, spacingValue, sizingValue;
@synthesize arcLabel, radiusLabel, spacingLabel, sizingLabel;

@synthesize homeButton;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    //NSLog(@"%s", __func__);
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //set up carousel data
        carousel = [[iCarousel alloc] initWithFrame:CGRectMake(80, 450, 864, 260)];
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
             @"US",@"Baltimore",@"Las Vegas",@"Silicon Valley",@"Paris, France",
             @"Beijing, China", @"Tokyo, Japan",@"Shanghai, China",@"London, England",@"Wasington, DC",
             @"Engine_251",
             @"VicomM01",@"VicomM02",@"VicomM03",@"VicomM04",
             //@"",
             nil];
    
    // The latitude and longitude of Las Vegas, Nevada
    // 36° 10' 30" N / 115° 8' 11" W
    // 36.175 / 115.1363888888889
    
    // GPS Coordinates Of Silicon Valley, California - Latitude And Longitude Of Silicon Valley, California
    // http://www.thegpscoordinates.com/california/silicon-valley/
    // Decimal (WGS84) : 37.362570, -122.034760, Degrees Minutes Seconds : N 37° 21' 45.2514", W 122° 2' 5.136"

    //locations = [[NSMutableArray alloc] init];

    FLLocation *locationTaipei = [[FLLocation alloc] initWihtName:@"Taipei" lat:25.044 lon:121.526];
    FLLocation *locationSouthKorea = [[FLLocation alloc] initWihtName:@"South Korea" lat:37.000 lon:127.5];
    FLLocation *locationBaltimore = [[FLLocation alloc] initWihtName:@"Baltimore" lat:39.290458 lon:-76.612365];
    FLLocation *locationLasVegas = [[FLLocation alloc] initWihtName:@"Las Vegas" lat:36.175 lon:-115.13639];
    FLLocation *locationSiliconValley = [[FLLocation alloc] initWihtName:@"Silicon Valley" lat:37.362570 lon:-122.034760];
    FLLocation *locationParis = [[FLLocation alloc] initWihtName:@"Paris" lat:48.85676 lon:2.35099];
    FLLocation *locationBeijing = [[FLLocation alloc] initWihtName:@"Beijing" lat:39.904459 lon:116.406847];
    FLLocation *locationTokyo = [[FLLocation alloc] initWihtName:@"Tokyo" lat:35.68994 lon:139.69170];
    FLLocation *locationLondon = [[FLLocation alloc] initWihtName:@"London" lat:51.500622 lon:-0.126662];
    //FLLocation *locationWasington = [[FLLocation alloc] initWihtName:@"Wasington" lat:38.89578 lon:-77.03650];
    
    locations = [[NSMutableArray alloc] initWithObjects:locationTaipei, locationSouthKorea, locationBaltimore, locationLasVegas, locationSiliconValley, locationParis, locationBeijing, locationTokyo, locationLondon, nil];
    
    
    [_mapView addAnnotations:locations];
    
    //[locations addObject:locationTaipei];
    //[locations addObject:locationTaipei];
    //[locations addObject:locationTaipei];
    //[locations addObject:locationTaipei];
    //[locations addObject:locationTaipei];
    //[locations addObject:locationTaipei];
    

    /*
    CLLocation *Taipei = [[CLLocation alloc] initWithLatitude:25.044 longitude:121.526];
    CLLocation *SouthKorea = [[CLLocation alloc] initWithLatitude:37.000 longitude:127.5];
    CLLocation *US = [[CLLocation alloc] initWithLatitude:38.0000 longitude:-97.0000];
    CLLocation *Baltimore = [[CLLocation alloc] initWithLatitude:39.290458 longitude:-76.612365];
    CLLocation *LasVegas = [[CLLocation alloc] initWithLatitude:36.175 longitude:-115.13639];
    CLLocation *SiliconValley = [[CLLocation alloc] initWithLatitude:37.362570 longitude:-122.034760];
    // GPS Coordinates Of Paris, France - Latitude And Longitude Of Paris, France
    // Decimal (WGS84) : 48.85676, 2.35099
    CLLocation *Paris = [[CLLocation alloc] initWithLatitude:48.85676 longitude:2.35099];
    // Beijing, China, Decimal (WGS84) : 39.904459, 116.406847
    CLLocation *Beijing = [[CLLocation alloc] initWithLatitude:39.904459 longitude:116.406847];
    CLLocation *Tokyo = [[CLLocation alloc] initWithLatitude:35.68994 longitude:139.69170];
    CLLocation *Shanghai = [[CLLocation alloc] initWithLatitude:31.230431 longitude:121.474956];
    CLLocation *London = [[CLLocation alloc] initWithLatitude:51.500622 longitude:-0.126662];
    CLLocation *Wasington = [[CLLocation alloc] initWithLatitude:38.89578 longitude:-77.03650];
   */
    
    //locations = [NSArray arrayWithObjects:Taipei, SouthKorea, US, Baltimore, LasVegas, SiliconValley, Paris, Beijing, Tokyo, Shanghai, London, Wasington, nil];
    
    
    //NSDictionary *locations = [NSDictionary dictionaryWithObjectsAndKeys:<#(id), ...#>, nil]
    
    // Seoul of South Korea
    //      latitude 37.000
    //      longitude 127.5
    
    //CLLocation *towerLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    // http://dev.maxmind.com/geoip/codes/country_latlon
    // Average Latitude and Longitude for Countries
    
    //get data
    theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    //init/add carouse view
    carousel.delegate = self;
    carousel.dataSource = self;
    
    carousel.type = iCarouselTypeCylinder;
    //carousel.type = iCarouselTypeRotary;
    
    carousel.contentOffset = CGSizeMake(0, -120);
    carousel.viewpointOffset = CGSizeMake(0, -150);
    carousel.decelerationRate = 0.9;


    [self.view addSubview:carousel];
    
    [theDelegate customizedArcSlider: arcSlider radiusSlider:radiusSlider spacingSlider:spacingSlider sizingSlider:sizingSlider inView:self.view];
    
    [self.view bringSubviewToFront:homeButton];
    
     //_mapView.transform=CGAffineTransformMakeRotation(-M_PI/2);
    
    self.MainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewControllerID"];
    self.mainViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    

    [self onItemPress:nil];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%s", __func__);
   
    /*
    // Baltimore
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
    [_mapView setCenterCoordinate:zoomLocation zoomLevel:3 animated:YES];
     */
    
}

- (void)gotoSite:(id)sender
{
    NSLog(@"%s", __func__);
    
    [self presentViewController:self.mainViewController animated:YES completion:nil];


}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    NSLog(@"%s", __func__);//, (unsigned long)[mapView zoomLevel]);
	if (annotation == mapView.userLocation) { //returning nil means 'use built in location view'
		return nil;
	}
	
	MKPinAnnotationView *pinAnnotation = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
	if (pinAnnotation == nil) {
		pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
	} else {
		pinAnnotation.annotation = annotation;
	}
	
    pinAnnotation.canShowCallout = YES;
	pinAnnotation.pinColor = MKPinAnnotationColorRed;
	pinAnnotation.animatesDrop = YES;
    
    //instatiate a detail-disclosure button and set it to appear on right side of annotation
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pinAnnotation.rightCalloutAccessoryView = infoButton;
	
    [infoButton addTarget:self action:@selector(gotoSite:) forControlEvents:UIControlEventTouchUpInside];

	return pinAnnotation;
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"%s", __func__);//, (unsigned long)[mapView zoomLevel]);
    // Constrain zoom level to 8.
    if( [mapView zoomLevel] > 2 )
    {
        [mapView setCenterCoordinate:mapView.centerCoordinate
                           zoomLevel:2
                            animated:YES];
    }
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    NSLog(@"%s", __func__);//, (unsigned long)[mapView zoomLevel]);
}



-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"%s", __func__);
    regionWillChangeAnimatedCalled = YES;
    regionChangedBecauseAnnotationSelected = NO;
}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    NSLog(@"%s", __func__);
    regionChangedBecauseAnnotationSelected = regionWillChangeAnimatedCalled;
}



//-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
/*
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"%s", __func__);//, (unsigned long)[mapView zoomLevel]);

    if (!regionChangedBecauseAnnotationSelected) //note "!" in front
    {
        //reload (add/remove) annotations here...
    }
    
    //reset flags...
    regionWillChangeAnimatedCalled = NO;
    regionChangedBecauseAnnotationSelected = NO;
}
*/

- (void)moveToLocation:(CLLocationCoordinate2D)location zoomLevel:(NSInteger)zoomLevel
{
    //To get the CLLocationCoordinate struct back from CLLocation, call coordinate on the object.
    
    //CLLocationCoordinate2D coord = [[locations objectAtIndex:carousel.currentItemIndex] coordinate];
    //NSLog(@"%s %f %f", __func__, coord.latitude, coord.longitude);
    

    //typedef struct {
    //    CLLocationDegrees latitude;
    //    CLLocationDegrees longitude;
    //} CLLocationCoordinate2D;
    
    //CLLocationCoordinate2D location = (CLLocationCoordinate2D){.latitude = latitude, .longitude = longitude};
    // Seoul of South Korea
    //      latitude 37.000
    //      longitude 127.5
    
    
    NSLog(@"%s", __func__);
    
    
    //[self setMapRegionLongitude:Y andLatitude:X withLongitudeSpan:0.05 andLatitudeSpan:0.05];
    [_mapView setCenterCoordinate:location zoomLevel:zoomLevel animated:YES];
}


#pragma mark - event handler

- (void)onItemPress:(id)sender
{
    //UIButton *theButon = (UIButton *)sender;
    //NSInteger index = carousel.currentItemIndex;
    
    NSLog(@"%s", __func__);
    
    
    if (carousel.currentItemIndex < [locations count]) {
        
        NSInteger index = carousel.currentItemIndex;
        FLLocation *location = [locations objectAtIndex:index];
        CLLocationCoordinate2D coord;
        
        coord.latitude = [location.latitude floatValue];
        coord.longitude= [location.longitude floatValue];

        NSLog(@"%s %f %f", __func__, coord.latitude, coord.longitude);
        
        //NSInteger zoomLevel = [[zoomLevels objectAtIndex:carousel.currentItemIndex] integerValue];
        NSInteger zoomLevel = 3;
        
        [self moveToLocation:coord zoomLevel:zoomLevel];

    }
    
    
    //NSLog(@"onItemPress: tag=%d, current index=%u %@",theButon.tag, index, [deviceArray objectAtIndex:index]);
    
    //currentItemIndex = _carousel.currentItemIndex;
    
    //theDelegate.currentDeviceName = [deviceArray objectAtIndex:currentItemIndex];;
    
    //self.mirrorViewVcController.haApplianceName = [deviceArray objectAtIndex:currentItemIndex];
    //self.mirrorViewVcController.deviceLabel.text = self.mirrorViewVcController.haApplianceName;
    //[self presentViewController:self.mirrorViewVcController animated:YES completion:nil];
    
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
    // Seoul of South Korea
    //      latitude 37.000
    //      longitude 127.5
    
    
    
   //[self setMapRegionLongitude:Y andLatitude:X withLongitudeSpan:0.05 andLatitudeSpan:0.05];
    [_mapView setCenterCoordinate:location zoomLevel:8 animated:YES];
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
    //NSLog(@"%s count=%d", __func__, [sites count]);
    //return [sites count];
    return [locations count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //NSLog(@"%s index=%u %@", __func__, index, [sites objectAtIndex:index]);
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
                
        theLabel = [[UILabel alloc] init];
        theLabel.numberOfLines = 0;
        //theLabel.textColor = [UIColor darkGrayColor];
        
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
        //theLabel.backgroundColor = [UIColor redColor];
        //theLabel.alpha = 0.5;
        theLabel.textAlignment = NSTextAlignmentCenter;
        theLabel.tag = 1;
        theLabel.font = [UIFont boldSystemFontOfSize:25.0];
        
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
    
    //theLabel.text = [sites objectAtIndex:index];
    
    FLLocation *location = [locations objectAtIndex:index];
    NSLog(@"%s %u %@", __func__, index, location);
    
    theLabel.text = [location title];
    
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
    
    NSLog(@"%s zoom level %lu", __func__, (unsigned long)[_mapView zoomLevel]);
    
    [self onItemPress:nil];

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
