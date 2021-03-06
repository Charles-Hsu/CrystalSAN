//
//  MapViewController.h
//  CrystalSAN
//
//  Created by Charles Hsu on 12/25/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import <MapKit/MapKit.h>

#import "MKMapView+ZoomLevel.h"
#import "iCarousel.h"
//#import "SanDatabase.h"

#import "MainViewController.h"

#define METERS_PER_MILE 1609.344


@interface MapViewController : UIViewController <MKMapViewDelegate, iCarouselDataSource, iCarouselDelegate> {
    
    BOOL _doneInitialZoom;
    
}

// view

@property (strong, nonatomic) IBOutlet MKMapView *_mapView;//This was auto-added by Xcode :]
@property (strong,nonatomic) iCarousel *carousel;

@property (strong, nonatomic) MainViewController *mainViewController;


@property (nonatomic, retain) IBOutlet UISlider *arcSlider;
@property (nonatomic, retain) IBOutlet UISlider *radiusSlider;
@property (nonatomic, retain) IBOutlet UISlider *spacingSlider;
@property (nonatomic, retain) IBOutlet UISlider *sizingSlider;

@property (nonatomic, retain) IBOutlet UILabel *arcValue;
@property (nonatomic, retain) IBOutlet UILabel *radiusValue;
@property (nonatomic, retain) IBOutlet UILabel *spacingValue;
@property (nonatomic, retain) IBOutlet UILabel *sizingValue;

@property (nonatomic, retain) IBOutlet UILabel *arcLabel;
@property (nonatomic, retain) IBOutlet UILabel *radiusLabel;
@property (nonatomic, retain) IBOutlet UILabel *spacingLabel;
@property (nonatomic, retain) IBOutlet UILabel *sizingLabel;

@property (nonatomic, strong) IBOutlet UIImageView *sliderBackground;


@property (nonatomic, strong) IBOutlet UIImageView *crystalSAN;

@property (nonatomic, strong) IBOutlet UIView *viewForToggleSliders;


@property (nonatomic, retain) IBOutlet UIButton *homeButton;

- (IBAction)moveToTaipei:(id)sender;

- (IBAction)updateValue:(id)sender;

- (void)handleDoubleTap:(id)sender;


@end
