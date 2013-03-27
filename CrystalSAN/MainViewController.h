//
//  MainViewController.h
//  CrystalSAN
//
//  Created by Charles Hsu on 12/25/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iCarousel.h"
#import "RaidViewController.h"
#import "HAApplianceViewController.h"
#import "VolumeViewController.h"
#import "DriveViewController.h"
#import "HbaViewController.h"

@interface MainViewController : UIViewController<iCarouselDataSource, iCarouselDelegate>

// data
@property (strong, nonatomic) NSMutableArray *totalItems;
@property (strong, nonatomic) NSMutableArray *activeItems;

// view
@property (strong, nonatomic) iCarousel *carousel;

@property (strong, nonatomic) RaidViewController *raidViewController;
@property (strong, nonatomic) HAApplianceViewController *haApplianceViewController;
@property (strong, nonatomic) VolumeViewController *volumeViewController;

@property (strong, nonatomic) DriveViewController *driveViewController;
@property (strong, nonatomic) HbaViewController *hbaViewController;

@property (strong, nonatomic) NSMutableArray *descriptions;

@property (nonatomic, retain) IBOutlet UISlider *arcSlider;
@property (nonatomic, retain) IBOutlet UISlider *radiusSlider;
@property (nonatomic, retain) IBOutlet UISlider *spacingSlider;
@property (strong, nonatomic) IBOutlet UISlider *sizingSlider;

@property (nonatomic, retain) IBOutlet UILabel *arcValue;
@property (nonatomic, retain) IBOutlet UILabel *radiusValue;
@property (nonatomic, retain) IBOutlet UILabel *spacingValue;
@property (nonatomic, retain) IBOutlet UILabel *sizingValue;

@property (nonatomic, retain) IBOutlet UILabel *arcLabel;
@property (nonatomic, retain) IBOutlet UILabel *radiusLabel;
@property (nonatomic, retain) IBOutlet UILabel *spacingLabel;
@property (nonatomic, retain) IBOutlet UILabel *sizingLabel;



- (IBAction)reloadCarousel;
- (IBAction)updateValue:(id)sender;

- (IBAction)hideShowSlider:(id)sender;


@end
