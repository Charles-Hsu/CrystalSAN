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

#import "Annotation.h"
#import "CustomAnnotationView.h"



@interface MapViewController () {
    
    AppDelegate *theDelegate;
    
    NSArray *sites;
    NSMutableArray *locations;
    //NSArray *zoomLevels;
    
    BOOL regionWillChangeAnimatedCalled;// = YES;
    BOOL regionChangedBecauseAnnotationSelected; // = NO;
    
    NSInteger currentLocationIndex;
    
    UITapGestureRecognizer *singleTapGestureRecognizer;
    UITapGestureRecognizer *doubleTapGestureRecognizer;
    UITapGestureRecognizer *tripleTapGestureRecognizer;
    
    FLLocation *currentLocation;

}

- (void)panMapToCurrentSiteLocation;
- (void)zoomInCurrentLocation;


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
@synthesize crystalSAN;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"%s", __func__);
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //set up carousel data
        carousel = [[iCarousel alloc] initWithFrame:CGRectMake(480, 380, 500, 360)];
        //carousel = [[iCarousel alloc] initWithFrame:CGRectMake(80, 128, 864, 80)];

        //carousel.backgroundColor = [UIColor cyanColor];
        //singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        //singleTapGestureRecognizer.numberOfTapsRequired = 1;
        
        doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSite:)];
        doubleTapGestureRecognizer.numberOfTapsRequired = 2;
        
        tripleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTripleTap:)];
        tripleTapGestureRecognizer.numberOfTapsRequired = 3;
        
        //theDelegate.storyboard = self.storyboard;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate; 
    NSLog(@"%s", __func__);
    
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

    //FLLocation *locationTaipei = [[FLLocation alloc] initWihtName:@"Taipei" lat:25.044 lon:121.526];
    //FLLocation *locationSouthKorea = [[FLLocation alloc] initWihtName:@"South Korea" lat:37.000 lon:127.5];
    
    //insert into site_info values ('South Korea','KBS','13, Yeouigongwon-ro, Yeongdeungpo-gu, Seoul', 127.5,37.000, 'Loxoll','administrator','vicom123');
    
    //FLLocation *locationBaltimore = [[FLLocation alloc] initWihtName:@"Baltimore" lat:39.290458 lon:-76.612365];
    //FLLocation *locationLasVegas = [[FLLocation alloc] initWihtName:@"Las Vegas" lat:36.175 lon:-115.13639];
    //FLLocation *locationSiliconValley = [[FLLocation alloc] initWihtName:@"Silicon Valley" lat:37.362570 lon:-122.034760];
    //FLLocation *locationParis = [[FLLocation alloc] initWihtName:@"Paris" lat:48.85676 lon:2.35099];
    //FLLocation *locationBeijing = [[FLLocation alloc] initWihtName:@"Beijing" lat:39.904459 lon:116.406847];
    //FLLocation *locationTokyo = [[FLLocation alloc] initWihtName:@"Tokyo" lat:35.68994 lon:139.69170];
    //FLLocation *locationLondon = [[FLLocation alloc] initWihtName:@"London" lat:51.500622 lon:-0.126662];
    
    //locations = [[NSMutableArray alloc] initWithObjects:locationTaipei, locationSouthKorea, locationBaltimore, locationLasVegas, locationSiliconValley, locationParis, locationBeijing, locationTokyo, locationLondon, nil];
    
        /*
    {
        label = Accusys;
        latitude = "25.044";
        location = Jhubei;
        longitude = "121.526";
    },
    {
        label = KBS;
        latitude = "37.0";
        location = "South Korea";
        longitude = "127.5";
    }
         */

    
    locations = [[NSMutableArray alloc] init];
    NSLog(@"%s [theDelegate.siteInfoArray count]=%d", __func__, [theDelegate.siteInfoArray count]);
    for (int i=0; i<[theDelegate.siteInfoArray count]; i++) {
        NSDictionary *dict = [theDelegate.siteInfoArray objectAtIndex:i];
        FLLocation *location = [[FLLocation alloc] initWihtName:[dict objectForKey:@"location"] lat:[[dict objectForKey:@"latitude"] floatValue] lon:[[dict objectForKey:@"longitude"] floatValue]];
        [locations addObject:location];
    }
    
    [_mapView addAnnotations:locations];
    
    //Annotation *ann = [[Annotation alloc]initWithLocation:CLLocationCoordinate2DMake(25.044,121.526)];
    //[_mapView addAnnotation:ann];
    //ann.name = @"Taipei";
    //ann.locationType = @"airport";

    
    //get data
    theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    //init/add carouse view
    carousel.delegate = self;
    carousel.dataSource = self;
    
    //carousel.type = iCarouselTypeCylinder;
    carousel.type = iCarouselTypeRotary;
    
    carousel.contentOffset = CGSizeMake(0, -280);
    carousel.viewpointOffset = CGSizeMake(0, -350);
    carousel.decelerationRate = 0.9;

    [self.view addSubview:carousel];
    
    [theDelegate customizedArcSlider: arcSlider radiusSlider:radiusSlider spacingSlider:spacingSlider sizingSlider:sizingSlider inView:self.view];
    
    [self.view bringSubviewToFront:homeButton];
    
     //_mapView.transform=CGAffineTransformMakeRotation(-M_PI/2);
    
    self.MainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewControllerID"];
    self.mainViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    //[self.view addGestureRecognizer:doubleTapGestureRecognizer];

    //[self onItemPress:nil];
    
    currentLocationIndex = 0;
    
    //[self panMapToCurrentSiteLocation];
    
    //theDelegate.loadSiteViewTimes = 0;
    /*
    
    //tapGestureRecognizer.delegate = self;
    
    [self.crystalSAN addGestureRecognizer:doubleTapGestureRecognizer];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    
    [singleTapGestureRecognizer requireGestureRecognizerToFail: doubleTapGestureRecognizer];
    //tapGestureRecognizer.delegate = self;
    
    [self.crystalSAN addGestureRecognizer:singleTapGestureRecognizer];
     */
    //UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];

    //[self.viewForToggleSliders addGestureRecognizer:doubleTapGestureRecognizer];
    [self.viewForToggleSliders addGestureRecognizer:tripleTapGestureRecognizer];
    //[self.crystalSAN addGestureRecognizer:doubleTapGestureRecognizer];
    
    [self hideShowSliders:nil];
    
    NSLog(@"end of %s", __func__);

}


- (void)handleTripleTap:(id)sender {
    NSLog(@"%s", __func__);
    [self hideShowSliders:sender];
}

- (void)handleDoubleTap:(id)sender {
    NSLog(@"%s", __func__);
}


- (void)handleSingleTap:(id)sender {
    NSLog(@"%s %@", __func__, sender);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    //NSLog(@"%s", __func__);
    // Dispose of any resources that can be recreated.
    
}

// iOS6 MKMapView using a ton of memory, to the point of crashing the app, anyone else notice this?
// http://stackoverflow.com/questions/12641658/ios6-mkmapview-using-a-ton-of-memory-to-the-point-of-crashing-the-app-anyone-e
// source code by http://stackoverflow.com/users/1165401/wirsing
- (void)applyMapViewMemoryHotFix{
    //NSLog(@"%s", __func__);
    
    switch (self._mapView.mapType) {
        case MKMapTypeHybrid:
        {
            self._mapView.mapType = MKMapTypeStandard;
        }
            
            break;
        case MKMapTypeStandard:
        {
            self._mapView.mapType = MKMapTypeHybrid;
        }
            
            break;
        default:
            break;
    }
    
    [self._mapView removeFromSuperview];
    self._mapView = nil;
}


- (void)viewDidDisappear:(BOOL)animated {
    //NSLog(@"%s", __func__);
    [self applyMapViewMemoryHotFix];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //NSLog(@"%s", __func__);
    
    carousel.currentItemIndex = theDelegate.currentSiteIndex;
    theDelegate.loadSiteViewTimes = [NSNumber numberWithInt:([theDelegate.loadSiteViewTimes integerValue]+ 1)];
    //NSLog(@"%s mapView loaded times = %@", __func__, theDelegate.loadSiteViewTimes);
    
    
    [self panMapToCurrentSiteLocation];
   
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

- (IBAction)hideShowSliders:(id)sender
{
    [theDelegate hideShowSliders:self.view];
}


- (void)gotoSite:(id)sender
{
    //NSLog(@"%s", __func__);
    
    theDelegate.currentSiteIndex = carousel.currentItemIndex;
    
    //currentLocation = [locations objectAtIndex:carousel.currentItemIndex];
    NSDictionary *dict = [theDelegate.siteInfoArray objectAtIndex:carousel.currentItemIndex];
    NSLog(@"%s %@", __func__, dict);
    
    //FLLocation *location = [[FLLocation alloc] initWihtName:[dict objectForKey:@"location"] lat:[[dict objectForKey:@"latitude"] floatValue] lon:[[dict objectForKey:@"longitude"] floatValue]];
    //NSLog(@"%s %@ %d", __func__, currentLocation.title, carousel.currentItemIndex);
    
    theDelegate.siteName = [dict objectForKey:@"name"];
    
    [self presentViewController:self.mainViewController animated:YES completion:nil];

}

/*
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[Annotation class]]) {
        
        // Try to dequeue an existing pin view first.
        CustomAnnotationView* pinView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView){
            // If an existing pin view was not available, create one.
            pinView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                       reuseIdentifier:@"CustomPinAnnotationView"];
            //[pinView setPinColor:MKPinAnnotationColorGreen];
            [pinView setImage:[UIImage imageNamed:@"coordinate.png"]];
            [pinView setAnimatesDrop:YES];
            [pinView setCanShowCallout:YES];
            [pinView setDraggable:YES];
        }
        else
            pinView.annotation = annotation;
        
        return pinView;

    
    }
    
    
    
    return nil;
}
*/


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSLog(@"%s %@", __func__, [annotation title]);
    MKAnnotationView *pinView = nil;
    
    //pinView.contentHeight = height;
    //pinView.titleHeight = 25;
    
    pinView.backgroundColor = [UIColor redColor];
    
    
    //if(annotation != mapView.userLocation)
    //{
    static NSString *defaultPinID = @"com.loxoll.pin";
    pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    NSLog(@"%s pinView=%@", __func__, pinView);
    if ( pinView == nil ) 
        pinView = [[MKAnnotationView alloc]
                   initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        //pinView.pinColor = MKPinAnnotationColorGreen;
        //pinView.canShowCallout = YES;
        //pinView.animatesDrop = YES;
        pinView.image = [UIImage imageNamed:@"coordinate.png"];    //as suggested by Squatch
        
        //NSLog(@"pinView %@ add singleTapGestureRecognizer", pinView);
        //[pinView addGestureRecognizer:singleTapGestureRecognizer];
        //NSLog(@"pinView %@ add doubleTapGestureRecognizer", pinView);
        //[pinView addGestureRecognizer:doubleTapGestureRecognizer];
    
    
    //}
    //else {
    //    [mapView.userLocation setTitle:@"I am here"];
    //}
    
    
    //UIButton *infoButton = [[UIButton alloc] init];
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[infoButton imageView] = [UIImage imageNamed:@"CalloutButton"];
    [infoButton setImage:[UIImage imageNamed:@"CalloutButton.png"]
                        forState:UIControlStateNormal];
    //[infoButton setFrame:CGRectMake(100, 100, 100, 100)];
    
    pinView.rightCalloutAccessoryView = infoButton;
    //pinView.leftCalloutAccessoryView = infoButton;
    
    [pinView sizeToFit];
    
	[infoButton addTarget:self action:@selector(gotoSite:) forControlEvents:UIControlEventTouchUpInside];
    //[infoButton addGestureRecognizer:<#(UIGestureRecognizer *)#>]
    
    return pinView;
}


-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    //NSLog(@"%s", __func__);
    regionWillChangeAnimatedCalled = YES;
    regionChangedBecauseAnnotationSelected = NO;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //NSLog(@"%s", __func__);//, (unsigned long)[mapView zoomLevel]);
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    //NSLog(@"%s", __func__);//, (unsigned long)[mapView zoomLevel]);
    //NSLog(@"%s mapView loaded times = %@", __func__, theDelegate.loadSiteViewTimes);
   // NSLog(@"%s -------------------------------------", __func__);
}


- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"%s %@", __func__, [[view annotation] title]);
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"%s %@", __func__, [[view annotation] title]);
    regionChangedBecauseAnnotationSelected = regionWillChangeAnimatedCalled;
    
    NSString *selectedAnnotationTitle = [[view annotation] title];
    
    int selectedInex = 0;
    
    for(int i=0; i<[locations count]; i++) {
        FLLocation *location = [locations objectAtIndex:i];
        //NSLog(@"%s %d %@", __func__, i, [location title]);
        //NSLog(@"curentLocation = %@ %@", currentLocation, currentLocation.title);
        //NSLog(@"location %d = %@ %@", i, location, location.title);
        if ([location.title isEqualToString:selectedAnnotationTitle]) {
            NSLog(@"selected i=%d", i);
            selectedInex = i;
        }
        
    }
    
    NSLog(@"selected index=%d", selectedInex);
    carousel.currentItemIndex = selectedInex;
    [carousel scrollToItemAtIndex:carousel.currentItemIndex animated:TRUE];
    
    /*
    NSLog(@"%d", carousel.currentItemIndex);
    
    int i=carousel.currentItemIndex;
    i++;
    NSLog(@"ScrollSpeed %f", carousel.scrollSpeed);
    //carousel setScrollSpeed:<#(CGFloat)#>
    [carousel setScrollSpeed:0.1];
    carousel.currentItemIndex = i % carousel.numberOfItems;
    //[carousel scrollToItemAtIndex:carousel.currentItemIndex animated:TRUE];
    [carousel scrollToItemAtIndex:carousel.currentItemIndex duration:1];
    //carousel setScrollSpeed:<#(CGFloat)#>
    
    NSLog(@"ScrollSpeed %f", carousel.scrollSpeed);
    
    NSLog(@"%d", carousel.currentItemIndex);
     */
    
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

- (void)panMapToCurrentSiteLocation
{
    //NSLog(@"%s zoom level %lu", __func__, (unsigned long)[_mapView zoomLevel]);
    
    [self zoomOutCurrentLocation];
    
    if (carousel.currentItemIndex < [locations count]) {
        
        NSInteger index = carousel.currentItemIndex;
        FLLocation *location = [locations objectAtIndex:index];
        CLLocationCoordinate2D coord;
        
        coord.latitude = [location.latitude floatValue];
        coord.longitude= [location.longitude floatValue];
        
        //NSLog(@"%s %f %f", __func__, coord.latitude, coord.longitude);
        
        //NSInteger zoomLevel = [[zoomLevels objectAtIndex:carousel.currentItemIndex] integerValue];
        NSInteger zoomLevel = 6;
        
        [self moveToLocation:coord zoomLevel:zoomLevel];
        
    }
    
    [self performSelector:@selector(zoomInCurrentLocation) withObject:nil afterDelay:3];
    
    
    //[self zoomInCurrentLocation];
    
    
}

- (void)zoomInCurrentLocation
{
    //NSLog(@"%s zoom level %lu", __func__, (unsigned long)[_mapView zoomLevel]);
    
    if (carousel.currentItemIndex < [locations count]) {
        
        NSInteger index = carousel.currentItemIndex;
        FLLocation *location = [locations objectAtIndex:index];
        
        currentLocation = location;
        
        CLLocationCoordinate2D coord;
        
        coord.latitude = [location.latitude floatValue];
        coord.longitude= [location.longitude floatValue];
        
        //NSLog(@"%s %f %f", __func__, coord.latitude, coord.longitude);
        
        //NSInteger zoomLevel = [[zoomLevels objectAtIndex:carousel.currentItemIndex] integerValue];
        NSInteger zoomLevel = 3;
        
        [self moveToLocation:coord zoomLevel:zoomLevel];
        
    }
}

- (void)zoomOutCurrentLocation
{
    //NSLog(@"%s zoom level %lu", __func__, (unsigned long)[_mapView zoomLevel]);
    
    if (carousel.currentItemIndex < [locations count]) {
        
        NSInteger index = carousel.currentItemIndex;
        FLLocation *location = [locations objectAtIndex:index];
        CLLocationCoordinate2D coord;
        
        coord.latitude = [location.latitude floatValue];
        coord.longitude= [location.longitude floatValue];
        
        //NSLog(@"%s %f %f", __func__, coord.latitude, coord.longitude);
        
        //NSInteger zoomLevel = [[zoomLevels objectAtIndex:carousel.currentItemIndex] integerValue];
        NSInteger zoomLevel = 3;
        
        [self moveToLocation:coord zoomLevel:zoomLevel];
        
    }
}


- (void)moveToLocation:(CLLocationCoordinate2D)location zoomLevel:(NSInteger)zoomLevel
{
    //NSLog(@"%s", __func__);
    [_mapView setCenterCoordinate:location zoomLevel:zoomLevel animated:YES];
}


#pragma mark - event handler

- (void)onItemPress:(id)sender {
    [self gotoSite:sender];
}

- (IBAction)updateValue:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    //NSLog(@"%s %@ %@", __func__, sender, [sender restorationIdentifier]);
    
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
    NSLog(@"%s count=%d", __func__, [locations count]);
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
        
        theItemImage = [UIImage imageNamed:@"Item-Site"];
                
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
        
        theLabel.frame = CGRectMake(0, itemHeight-43, itemWidth, 40);
        //theLabel.alpha = 0.5;
        theLabel.backgroundColor = [UIColor clearColor];
        //theLabel.backgroundColor = [UIColor redColor];
        //theLabel.alpha = 0.5;
        theLabel.textAlignment = NSTextAlignmentCenter;
        theLabel.tag = 1;
        theLabel.font = [UIFont boldSystemFontOfSize:20.0];
        theLabel.textColor = [UIColor darkGrayColor];
        
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



- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    [self panMapToCurrentSiteLocation];
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)_carousel {
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
