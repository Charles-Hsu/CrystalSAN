//
//  RaidViewConfigController.h
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "iCarousel.h"

@interface MirrorViewRController : UIViewController //<iCarouselDataSource, iCarouselDelegate>
{
    NSString *deviceName;
}

// data
//@property (strong,nonatomic) NSMutableArray *totalItems;
//@property (strong,nonatomic) NSMutableArray *activeItems;

//@property (strong, nonatomic) NSMutableArray *animals;
//@property (strong, nonatomic) NSMutableArray *descriptions;



// view
//@property (strong,nonatomic) iCarousel *carousel;

// event
- (IBAction)onHome:(id)sender;
- (IBAction)onBack:(id)sender;

@property (nonatomic, weak) IBOutlet UILabel *deviceLabel;
@property (nonatomic, retain) NSString *deviceName;


/*

@property (nonatomic, retain) IBOutlet UISlider *arcSlider;
@property (nonatomic, retain) IBOutlet UISlider *radiusSlider;
@property (nonatomic, retain) IBOutlet UISlider *spacingSlider;


@property (nonatomic, retain) IBOutlet UILabel *radiusValue;
@property (nonatomic, retain) IBOutlet UILabel *spacingValue;

- (IBAction)reloadCarousel;
- (IBAction)updateValue:(id)sender;

 */

@end
