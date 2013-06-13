//
//  HAApplianceConnectionViewController.h
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "SanDatabase.h"
#import "HbaViewController.h"
#import "UILogoutButton.h"


@interface ThunderboltSWViewController : UIViewController <iCarouselDataSource, iCarouselDelegate, UIScrollViewDelegate, UIPopoverControllerDelegate,UIImagePickerControllerDelegate>
//UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSString *deviceName;
}

// data
//@property (strong,nonatomic) NSMutableArray *totalItems;
//@property (strong,nonatomic) NSMutableArray *activeItems;

//@property (strong, nonatomic) NSString *haApplianceName;

//@property (strong, nonatomic) NSMutableArray *animals;
@property (strong, nonatomic) NSMutableArray *descriptions;

@property (strong, nonatomic) HbaViewController *hbaViewController;


// view
@property (strong,nonatomic) IBOutlet iCarousel *carousel;
@property (strong,nonatomic) IBOutlet iCarousel *carouselDriver;

@property (nonatomic, retain) IBOutlet UISlider *arcSlider;
@property (nonatomic, retain) IBOutlet UISlider *radiusSlider;
@property (nonatomic, retain) IBOutlet UISlider *spacingSlider;
@property (nonatomic, retain) IBOutlet UISlider *sizingSlider;

@property (nonatomic, retain) IBOutlet UILabel *arcLabel;
@property (nonatomic, retain) IBOutlet UILabel *radiusLabel;
@property (nonatomic, retain) IBOutlet UILabel *spacingLabel;
@property (nonatomic, retain) IBOutlet UILabel *sizingLabel;

@property (nonatomic, retain) IBOutlet UILabel *arcValue;
@property (nonatomic, retain) IBOutlet UILabel *radiusValue;
@property (nonatomic, retain) IBOutlet UILabel *spacingValue;
@property (nonatomic, retain) IBOutlet UILabel *sizingValue;

@property (nonatomic, retain) IBOutlet UIButton *thunderboltSWButton;

@property (nonatomic, strong) IBOutlet UILogoutButton *logoutButton;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) IBOutlet UIButton *pc1;
@property (nonatomic, retain) IBOutlet UIButton *pc2;
@property (nonatomic, retain) IBOutlet UIButton *pc3;
@property (nonatomic, retain) IBOutlet UIButton *pc4;
@property (nonatomic, retain) IBOutlet UIButton *pc5;
@property (nonatomic, retain) IBOutlet UIButton *pc6;
@property (nonatomic, retain) IBOutlet UIButton *pc7;


@property (nonatomic, retain) IBOutlet UIButton *lun0_0;
@property (nonatomic, retain) IBOutlet UIButton *lun0_1;
@property (nonatomic, retain) IBOutlet UIButton *lun0_2;
@property (nonatomic, retain) IBOutlet UIButton *lun0_3;

@property (nonatomic, retain) IBOutlet UIButton *lun1_0;
@property (nonatomic, retain) IBOutlet UIButton *lun1_1;
@property (nonatomic, retain) IBOutlet UIButton *lun1_2;
@property (nonatomic, retain) IBOutlet UIButton *lun1_3;

@property (nonatomic, retain) IBOutlet UIButton *lun2_0;
@property (nonatomic, retain) IBOutlet UIButton *lun2_1;
@property (nonatomic, retain) IBOutlet UIButton *lun2_2;
@property (nonatomic, retain) IBOutlet UIButton *lun2_3;

@property (nonatomic, retain) IBOutlet UIButton *lun3_0;
@property (nonatomic, retain) IBOutlet UIButton *lun3_1;
@property (nonatomic, retain) IBOutlet UIButton *lun3_2;
@property (nonatomic, retain) IBOutlet UIButton *lun3_3;


// event
//- (IBAction)onHome:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)updateValue:(id)sender;

- (IBAction)aMethod:(id)sender;


- (IBAction)changeSWSide:(id)sender;


/*

@property (nonatomic, retain) IBOutlet UISlider *arcSlider;
@property (nonatomic, retain) IBOutlet UISlider *radiusSlider;
@property (nonatomic, retain) IBOutlet UISlider *spacingSlider;


@property (nonatomic, retain) IBOutlet UILabel *radiusValue;
@property (nonatomic, retain) IBOutlet UILabel *spacingValue;

- (IBAction)reloadCarousel;

 */

@end
