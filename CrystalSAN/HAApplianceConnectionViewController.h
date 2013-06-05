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


@interface HAApplianceConnectionViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>
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
@property (strong,nonatomic) iCarousel *carousel;

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

@property (nonatomic, retain) IBOutlet UIButton *lun00Button;
@property (nonatomic, retain) IBOutlet UILabel *lun00_0_Label;
@property (nonatomic, retain) IBOutlet UILabel *lun00_1_Label;


@property (nonatomic, retain) IBOutlet UIButton *lun01Button;
@property (nonatomic, retain) IBOutlet UILabel *lun01_0_Label;
@property (nonatomic, retain) IBOutlet UILabel *lun01_1_Label;

@property (nonatomic, retain) IBOutlet UIButton *lun02Button;
@property (nonatomic, retain) IBOutlet UIButton *lun02_0_Button;
@property (nonatomic, retain) IBOutlet UIButton *lun02_1_Button;
@property (nonatomic, retain) IBOutlet UILabel *lun02_MirroredLUN;
@property (nonatomic, retain) IBOutlet UILabel *lun02_0_Label;
@property (nonatomic, retain) IBOutlet UILabel *lun02_1_Label;

@property (nonatomic, retain) IBOutlet UIButton *lun03Button;
@property (nonatomic, retain) IBOutlet UIButton *lun03_0_Button;
@property (nonatomic, retain) IBOutlet UIButton *lun03_1_Button;
@property (nonatomic, retain) IBOutlet UILabel *lun03_MirroredLUN;
@property (nonatomic, retain) IBOutlet UILabel *lun03_0_Label;
@property (nonatomic, retain) IBOutlet UILabel *lun03_1_Label;

@property (nonatomic, retain) IBOutlet UIButton *lun04Button;
@property (nonatomic, retain) IBOutlet UILabel *lun04_0_Label;
@property (nonatomic, retain) IBOutlet UILabel *lun04_1_Label;

@property (nonatomic, retain) IBOutlet UIButton *lun05Button;
@property (nonatomic, retain) IBOutlet UILabel *lun05_0_Label;
@property (nonatomic, retain) IBOutlet UILabel *lun05_1_Label;


@property (nonatomic, retain) IBOutlet UILabel *lun00Label;
@property (nonatomic, retain) IBOutlet UILabel *lun01Label;
@property (nonatomic, retain) IBOutlet UILabel *lun02Label;
@property (nonatomic, retain) IBOutlet UILabel *lun03Label;
@property (nonatomic, retain) IBOutlet UILabel *lun04Label;
@property (nonatomic, retain) IBOutlet UILabel *lun05Label;

@property (nonatomic, retain) IBOutlet UIButton *engineLeft;
@property (nonatomic, retain) IBOutlet UIButton *engineRight;

@property (nonatomic, retain) IBOutlet UILabel *raid00_0_Label;
@property (nonatomic, retain) IBOutlet UILabel *raid00_1_Label;
@property (nonatomic, retain) IBOutlet UILabel *raid01_0_Label;
@property (nonatomic, retain) IBOutlet UILabel *raid01_1_Label;
@property (nonatomic, retain) IBOutlet UILabel *raid02_0_Label;
@property (nonatomic, retain) IBOutlet UILabel *raid02_1_Label;
@property (nonatomic, retain) IBOutlet UILabel *raid03_0_Label;
@property (nonatomic, retain) IBOutlet UILabel *raid03_1_Label;
@property (nonatomic, retain) IBOutlet UILabel *raid04_0_Label;
@property (nonatomic, retain) IBOutlet UILabel *raid04_1_Label;
@property (nonatomic, retain) IBOutlet UILabel *raid05_0_Label;
@property (nonatomic, retain) IBOutlet UILabel *raid05_1_Label;

@property (nonatomic, retain) IBOutlet UIButton *raid00_0_Button;
@property (nonatomic, retain) IBOutlet UIButton *raid00_1_Button;
@property (nonatomic, retain) IBOutlet UIButton *raid01_0_Button;
@property (nonatomic, retain) IBOutlet UIButton *raid01_1_Button;
@property (nonatomic, retain) IBOutlet UIButton *raid02_0_Button;
@property (nonatomic, retain) IBOutlet UIButton *raid02_1_Button;
@property (nonatomic, retain) IBOutlet UIButton *raid03_0_Button;
@property (nonatomic, retain) IBOutlet UIButton *raid03_1_Button;
@property (nonatomic, retain) IBOutlet UIButton *raid04_0_Button;
@property (nonatomic, retain) IBOutlet UIButton *raid04_1_Button;
@property (nonatomic, retain) IBOutlet UIButton *raid05_0_Button;
@property (nonatomic, retain) IBOutlet UIButton *raid05_1_Button;



@property (nonatomic, retain) IBOutlet UIButton *testTwoFingersTap;

@property (nonatomic, strong) IBOutlet UILabel *siteNameLabel;
@property (nonatomic, strong) IBOutlet UILogoutButton *logoutButton;



// event
//- (IBAction)onHome:(id)sender;
- (IBAction)onBack:(id)sender;

//@property (nonatomic, weak) IBOutlet UILabel *deviceLabel;
@property (nonatomic, strong) IBOutlet UILabel *haApplianceName;


@property (nonatomic, retain) NSString *deviceName;


@property (strong, nonatomic) SanDatabase *sanDatabase;


- (IBAction)updateValue:(id)sender;
//- (IBAction)hideSlider:(id)sender;

//- (IBAction)logout:(id)sender;

//- (IBAction)showEngineInfo:(id)sender;
//- (IBAction)hideEngineInfo:(id)sender;

- (IBAction)showMirrorInfo:(id)sender;
//- (IBAction)hideMirrorInfo:(id)sender;

- (IBAction)showDriveStatus:(id)sender;

- (void)hideHud;

/*

@property (nonatomic, retain) IBOutlet UISlider *arcSlider;
@property (nonatomic, retain) IBOutlet UISlider *radiusSlider;
@property (nonatomic, retain) IBOutlet UISlider *spacingSlider;


@property (nonatomic, retain) IBOutlet UILabel *radiusValue;
@property (nonatomic, retain) IBOutlet UILabel *spacingValue;

- (IBAction)reloadCarousel;

 */

@end
