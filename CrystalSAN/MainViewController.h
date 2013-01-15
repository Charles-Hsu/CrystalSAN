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
#import "MirrorViewController.h"
#import "VolumeViewController.h"

@interface MainViewController : UIViewController<iCarouselDataSource, iCarouselDelegate>

// data
@property (strong, nonatomic) NSMutableArray *totalItems;
@property (strong, nonatomic) NSMutableArray *activeItems;

// view
@property (strong, nonatomic) iCarousel *carousel;

@property (strong, nonatomic) RaidViewController *raidViewController;
@property (strong, nonatomic) MirrorViewController *mirrorViewController;
@property (strong, nonatomic) VolumeViewController *volumeViewController;

@property (strong, nonatomic) NSMutableArray *descriptions;

@property (nonatomic, retain) IBOutlet UISlider *arcSlider;
@property (nonatomic, retain) IBOutlet UISlider *radiusSlider;
@property (nonatomic, retain) IBOutlet UISlider *spacingSlider;

@property (nonatomic, retain) IBOutlet UILabel *arcValue;
@property (nonatomic, retain) IBOutlet UILabel *radiusValue;
@property (nonatomic, retain) IBOutlet UILabel *spacingValue;

- (IBAction)reloadCarousel;
- (IBAction)updateValue:(id)sender;

@end
