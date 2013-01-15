//
//  MirrorViewController.h
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"


@interface MirrorViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (strong, nonatomic) NSMutableArray *descriptions;

// view
@property (strong,nonatomic) iCarousel *carousel;

- (IBAction)onHome:(id)sender;
- (IBAction)onBack:(id)sender;

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
