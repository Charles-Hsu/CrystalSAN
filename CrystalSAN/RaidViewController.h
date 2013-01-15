//
//  RaidViewController.h
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface RaidViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

// data
@property (strong,nonatomic) NSMutableArray *totalItems;
@property (strong,nonatomic) NSMutableArray *activeItems;

@property (strong, nonatomic) NSMutableArray *animals;
@property (strong, nonatomic) NSMutableArray *descriptions;



// view
@property (strong,nonatomic) iCarousel *carousel;

// event
- (IBAction)onHome:(id)sender;
- (IBAction)onBack:(id)sender;

- (IBAction)buttonConfigPressed:(id)sender;


@property (nonatomic, retain) IBOutlet UISlider *arcSlider;
@property (nonatomic, retain) IBOutlet UISlider *radiusSlider;
@property (nonatomic, retain) IBOutlet UISlider *spacingSlider;

@property (nonatomic, retain) IBOutlet UILabel *arcValue;
@property (nonatomic, retain) IBOutlet UILabel *radiusValue;
@property (nonatomic, retain) IBOutlet UILabel *spacingValue;

@property (nonatomic, retain) IBOutlet UILabel *currentItemIndex;
@property (nonatomic, retain) IBOutlet UILabel *totalItemCount;

- (IBAction)reloadCarousel;
- (IBAction)updateValue:(id)sender;

@end
