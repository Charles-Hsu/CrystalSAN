//
//  RaidViewConfigController.h
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "iCarousel.h"

@interface LoginViewController : UIViewController //<iCarouselDataSource, iCarouselDelegate>
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
- (IBAction)onCancel:(id)sender;
- (IBAction)onConfirm:(id)sender;

@property (nonatomic, weak) IBOutlet UILabel *siteNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *passwordLabel;

@property (nonatomic, weak) IBOutlet UITextField *siteName;
@property (nonatomic, weak) IBOutlet UITextField *userName;
@property (nonatomic, weak) IBOutlet UITextField *password;

@property (nonatomic, weak) IBOutlet UIButton *cancel;
@property (nonatomic, weak) IBOutlet UIButton *confirm;

@property (nonatomic, strong) UIScrollView *scrollView;




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
