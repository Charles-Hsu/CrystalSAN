//
//  MirrorViewController.h
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "SanDatabase.h"


@interface DriveViewController : UIViewController <iCarouselDataSource, iCarouselDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *descriptions;

// view
@property (strong, nonatomic) iCarousel *carousel;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

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

@property (strong, nonatomic) IBOutlet UIButton *searchStatusButton;
@property (strong, nonatomic) IBOutlet UIButton *searchNameButton;
@property (strong, nonatomic) IBOutlet UIButton *searchConnectionButton;

@property (nonatomic, retain) IBOutlet UILabel *itemIndexCountsAndTotalLabel;

@property (nonatomic, strong) IBOutlet UILabel *haApplianceName;

// data
@property (strong, nonatomic) NSDictionary *allNames;
@property (strong, nonatomic) NSMutableDictionary *names;

@property (strong, nonatomic) SanDatabase *sanDatabase;
@property (nonatomic, strong) IBOutlet UILabel *siteNameLabel;


- (IBAction)reloadCarousel;
- (IBAction)updateValue:(id)sender;

- (IBAction)onHome:(id)sender;
- (IBAction)onBack:(id)sender;

- (IBAction)hideShowSliders:(id)sender;


@end
