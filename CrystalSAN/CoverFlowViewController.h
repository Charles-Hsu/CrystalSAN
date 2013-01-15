//
//  CoverFlowViewController.h
//  CrystalSAN
//
//  Created by Charles Hsu on 12/25/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"


@interface CoverFlowViewController : UIViewController<iCarouselDataSource, iCarouselDelegate>

//data
@property(strong,nonatomic) NSMutableArray *totalItems;
@property(strong,nonatomic) NSMutableArray *activeItems;

// view
@property(strong,nonatomic) iCarousel *iCarouselView;

- (IBAction)onHome:(id)sender;
@end
