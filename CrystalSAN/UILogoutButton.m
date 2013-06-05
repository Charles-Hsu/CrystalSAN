//
//  UILogoutButton.m
//  CrystalSAN
//
//  Created by Charles Hsu on 6/2/13.
//  Copyright (c) 2013 Charles Hsu. All rights reserved.
//

#import "UILogoutButton.h"
#import "AppDelegate.h"
#import "MainViewController.h"


@interface UILogoutButton () {
    
    AppDelegate *theDelegate;
}

@end


@implementation UILogoutButton


- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"%s", __func__);
    self = [super initWithCoder:aDecoder];
    if (self) {
        theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    NSLog(@"%s", __func__);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s %@ %@", __func__, touches, event);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s %@ %@", __func__, touches, event);
    //alloc new view controller
	//MainViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewControllerID"];
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    
    //NSLog(@"%s mainStoryboard=%@", __func__, theDelegate.storyboard);
    
    //MainViewController *controller = (MainViewController*)[theDelegate.storyboard
    //                                                   instantiateViewControllerWithIdentifier: @"MainViewControllerID"];
    
	//present new view controller
	//[theDelegate.currentViewController presentViewController:controller animated:YES completion:nil];
    [theDelegate logout];
}


@end
