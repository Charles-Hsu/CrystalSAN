//
//  MainViewController.h
//  CrystalSAN
//
//  Created by Charles Hsu on 12/25/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "iCarousel.h"
//#import "SanDatabase.h"

#define METERS_PER_MILE 1609.344


@interface MapViewController : UIViewController <MKMapViewDelegate, iCarouselDataSource, iCarouselDelegate>{
    
    BOOL _doneInitialZoom;
    
}

// view

@property (weak, nonatomic) IBOutlet MKMapView *_mapView;//This was auto-added by Xcode :]
@property (strong,nonatomic) iCarousel *carousel;


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

- (IBAction)onHome:(id)sender;
- (IBAction)onBack:(id)sender;

- (IBAction)moveToTaipei:(id)sender;

- (IBAction)updateValue:(id)sender;


@end
