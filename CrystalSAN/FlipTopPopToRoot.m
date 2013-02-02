//
//  FlipTopPopToRoot.m
//  CrystalSAN
//
//  Created by Charles Hsu on 1/17/13.
//  Copyright (c) 2013 Charles Hsu. All rights reserved.
//

#import "FlipTopPopToRoot.h"

@implementation FlipTopPopToRoot


- (void)perform {
    
    // Creating Custom Segues, source cdoe from Apple developer's site
    // http://developer.apple.com/library/ios/#featuredarticles/ViewControllerPGforiPhoneOS/CreatingCustomSegues/CreatingCustomSegues.html
    // Add your own animation code here.
    
    [[self sourceViewController] presentModalViewController:[self destinationViewController] animated:NO];
    
    /*
    UIViewController *src = (UIViewController *) self.sourceViewController;
    [UIView transitionWithView:src.navigationController.view duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromTop
                    animations:^{
                        [src.navigationController popToViewController:[src.navigationController.viewControllers objectAtIndex:0] animated:NO];;
                    }
                    completion:NULL];
     */
}

/*
-(void)perform{
    UIView *sourceView = [[self sourceViewController] view];
    UIView *destinationView = [[self destinationViewController] view];
    
    UIImageView *sourceImageView;
    //sourceImageView = [[UIImageView alloc] initWithImage:[sourceView pw_imageSnapshot]];
    
    // force the destination to be in landscape before screenshot
    destinationView.frame = CGRectMake(0, 0, 1024, 748);
    CGRect originalFrame = destinationView.frame;
    CGRect offsetFrame = CGRectOffset(originalFrame, originalFrame.size.width, 0);
    
    
    UIImageView *destinationImageView;
    //destinationImageView = [[UIImageView alloc] initWithImage:[destinationView pw_imageSnapshot]];
    
    destinationImageView.frame = offsetFrame;
    [self.sourceViewController presentModalViewController:self.destinationViewController animated:NO];
    
    [destinationView addSubview:sourceImageView];
    [destinationView addSubview:destinationImageView];
    
    void (^animations)(void) = ^ {
        [destinationImageView setFrame:originalFrame];
        
    };
    
    void (^completion)(BOOL) = ^(BOOL finished) {
        if (finished) {
            
            [sourceImageView removeFromSuperview];
            [destinationImageView removeFromSuperview];
            
        }
    };
    
    //[UIView animateWithDuration:kAnimationDuration delay:.0 options:UIViewAnimationOptionCurveEaseOut animations:animations completion:completion];
}
*/

@end
