//
//  VolumeViewController.h
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface VolumeViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

// view
@property (strong,nonatomic) iCarousel *carousel;

// data
@property (strong,nonatomic) NSMutableArray *totalItems;
@property (strong,nonatomic) NSMutableArray *activeItems;

@property (strong, nonatomic) NSMutableArray *descriptions;


@property (nonatomic, retain) IBOutlet UISlider *arcSlider;
@property (nonatomic, retain) IBOutlet UISlider *radiusSlider;
@property (nonatomic, retain) IBOutlet UISlider *spacingSlider;
@property (nonatomic, retain) IBOutlet UISlider *sizingSlider;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, retain) IBOutlet UILabel *arcLabel;
@property (nonatomic, retain) IBOutlet UILabel *radiusLabel;
@property (nonatomic, retain) IBOutlet UILabel *spacingLabel;
@property (nonatomic, retain) IBOutlet UILabel *sizingLabel;

@property (nonatomic, retain) IBOutlet UILabel *arcValue;
@property (nonatomic, retain) IBOutlet UILabel *radiusValue;
@property (nonatomic, retain) IBOutlet UILabel *spacingValue;
@property (nonatomic, retain) IBOutlet UILabel *sizingValue;

@property (strong, nonatomic) IBOutlet UIButton *searchStatusButton;
@property (strong, nonatomic) IBOutlet UIButton *searchNameButton;
@property (strong, nonatomic) IBOutlet UIButton *searchConnectionButton;

@property (nonatomic, retain) IBOutlet UILabel *itemIndexCountsAndTotalLabel;


- (IBAction)onHome:(id)sender;
- (IBAction)onBack:(id)sender;

- (IBAction)reloadCarousel;
- (IBAction)updateValue:(id)sender;

- (IBAction)hideShowSlider:(id)sender;

@end
