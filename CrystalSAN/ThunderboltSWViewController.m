//
//  HAApplianceConnectionViewController.m
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Charles Hsu. All rights reserved.
//

#import "HAApplianceConnectionViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"

#import "MBProgressHUD.h"
#import <objc/runtime.h>

#define ITEM_BUTTON_START_TAG_RAIDVIEW 300

/*
@interface  UIScrollView <UIScrollViewDelegate>
{
    bool canStopScrolling;
    float prevOffset;
    float deltaOffset; //remembered for debug purposes
    NSTimeInterval prevTime;
    NSTimeInterval deltaTime; //remembered for debug purposes
    float currentSpeed;
}
 */

@interface ThunderboltSWViewController () {
    AppDelegate *theDelegate;
    MBProgressHUD *hud;
    BOOL isHUDshowing;
    //int currentHostIndex;
}

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIPopoverController *popOver;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) NSMutableArray *host1LUNArray;
@property (nonatomic, strong) NSMutableArray *host2LUNArray;
@property (nonatomic, strong) NSMutableArray *host3LUNArray;
@property (nonatomic, strong) NSMutableArray *host4LUNArray;
@property (nonatomic, strong) NSMutableArray *host5LUNArray;
@property (nonatomic, strong) NSMutableArray *host6LUNArray;
@property (nonatomic, strong) NSMutableArray *host7LUNArray;


@property (nonatomic, strong) NSMutableArray *hostArrayForLUNArray;


@end

@implementation ThunderboltSWViewController {
    BOOL isFrontView;
    UITapGestureRecognizer *singleFingerTap;
    UITapGestureRecognizer *doubleTapGestureRecognizer;
    //UITapGestureRecognizer *singleTapGestureRecognizerOnHost;
    
    UITextField *currentHostTextField;
    //NSArray *hostSelectedStatus;
    
    char hostSelectedStatus[8];// = {1,23,17,4,-5,100};
}

@synthesize carousel;
@synthesize carouselDriver;

@synthesize descriptions;

@synthesize arcValue, radiusValue, spacingValue, sizingValue;
@synthesize arcLabel, radiusLabel, spacingLabel, sizingLabel;
@synthesize arcSlider, radiusSlider, spacingSlider, sizingSlider;

@synthesize lun0_0, lun0_1, lun0_2, lun0_3;
@synthesize lun1_0, lun1_1, lun1_2, lun1_3;
@synthesize lun2_0, lun2_1, lun2_2, lun2_3;
@synthesize lun3_0, lun3_1, lun3_2, lun3_3;

@synthesize thunderboltSWButton;
@synthesize templateforraids;
@synthesize templateForHosts;

- (IBAction)logout:(id)sender {
    [theDelegate setCurrentSiteLogout];
    theDelegate.syncManager = nil;
    [self onHome:sender];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"%s", __func__);

    self = [super initWithCoder:aDecoder];
    
    if (self) {
        theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //set up carousel data
        carousel = [[iCarousel alloc] initWithFrame:CGRectMake(80, 88, 864, 80)];
        //carousel.backgroundColor = [UIColor cyanColor];
        
        carouselDriver = [[iCarousel alloc] initWithFrame:CGRectMake(80, 500, 864, 180)];
        //carouselDriver.backgroundColor = [UIColor cyanColor];
        //carousel.type = iCarouselTypeInvertedCylinder;
        carouselDriver.type = iCarouselTypeRotary;
        //carousel.type = iCarouselTypeInvertedRotary;// Rotary;
        carouselDriver.contentOffset = CGSizeMake(0, -100);
        carouselDriver.viewpointOffset = CGSizeMake(0, -150);
        //carousel.decelerationRate = 0.9;
    }
    return self;
}



- (void)insertDEMOdata
{
    NSLog(@"%s", __func__);
    // host0
    [[self.hostArrayForLUNArray objectAtIndex:0] addObject:[[NSArray alloc] initWithObjects:self.lun0_0, @"R", nil]];
    [[self.hostArrayForLUNArray objectAtIndex:0] addObject:[[NSArray alloc] initWithObjects:self.lun3_0, @"RW", nil]];
    // host1
    [[self.hostArrayForLUNArray objectAtIndex:1] addObject:[[NSArray alloc] initWithObjects:self.lun1_0, @"R", nil]];
    // host2
    [[self.hostArrayForLUNArray objectAtIndex:2] addObject:[[NSArray alloc] initWithObjects:self.lun2_0, @"R", nil]];
    [[self.hostArrayForLUNArray objectAtIndex:3] addObject:[[NSArray alloc] initWithObjects:self.lun3_1, @"R", nil]];
    [[self.hostArrayForLUNArray objectAtIndex:4] addObject:[[NSArray alloc] initWithObjects:self.lun3_2, @"R", nil]];
    [[self.hostArrayForLUNArray objectAtIndex:5] addObject:[[NSArray alloc] initWithObjects:self.lun0_2, @"RW", nil]];
    [[self.hostArrayForLUNArray objectAtIndex:6] addObject:[[NSArray alloc] initWithObjects:self.lun0_1, @"R", nil]];
    //[[self.hostArrayForLUNArray objectAtIndex:7] addObject:[[NSArray alloc] initWithObjects:self.lun2_0, @"RW", nil]];
    
    //[carousel reloadData];
    
}


- (void)onLunPress:(id)sender {
    NSLog(@"%s %@", __func__, sender);
    UIButton *button = (UIButton *)sender;
    NSLog(@"%s %@, borderWidth=%f", __func__, button.currentTitle, button.layer.borderWidth);
    
    for (UIView *subview in self.view.subviews) { //self.view.subviews
        if (subview.tag >= 100 && subview.tag < 140) {
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)subview;
                NSLog(@"%s %@", __func__, btn.currentTitle);
                if ([button.currentTitle isEqualToString:btn.currentTitle]) {
                    btn.layer.borderWidth = 3.0;
                    btn.layer.borderColor = [UIColor yellowColor].CGColor;
                }
            }
        }
    }

    
    
    
}

- (void)onLunPressCancel:(id)sender {
    NSLog(@"%s %@", __func__, sender);
    UIButton *button = (UIButton *)sender;

    for (UIView *subview in self.view.subviews) { //self.view.subviews
        if (subview.tag >= 100 && subview.tag < 140) {
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)subview;
                NSLog(@"%s %@", __func__, btn.currentTitle);
                if ([button.currentTitle isEqualToString:btn.currentTitle]) {
                    btn.layer.borderWidth = 0.0;
                    btn.layer.borderColor = [UIColor blackColor].CGColor;
                }
            }
        }
    }
}


- (void)drawRaidLayout:(NSString *)lunString {
    
}


- (void)drawHostsLayout {
    NSLog(@"%s", __func__);
    
    
    
    
    
    
    
    
    
    
    for (UIView *subview in self.view.subviews) { //self.view.subviews
        NSRange range = [subview.restorationIdentifier rangeOfString:@"host"];
        if (range.location != NSNotFound) {
            if ([subview isKindOfClass:[UITextField class]]) {
                
                
                UITextField *textField = (UITextField *)subview;
                CGRect frame = textField.frame;
                CGSize size = frame.size;
                //NSLog(@"(w,h)=(%f,%f), prefered width=%f", size.height, size.width, size.width/13.0);
                NSString *hostName = subview.restorationIdentifier;
                NSInteger hostNo = [[hostName substringFromIndex:(range.location+range.length)] integerValue];
                //NSLog(@"%@ hostNo=%d", subview.restorationIdentifier, hostNo);
                //UITextField *text = (UITextField *)subview;
                //text.text = @"Hello";
                NSMutableArray *lunForHost = [self.hostArrayForLUNArray objectAtIndex:(hostNo-1)];
                //NSLog(@"[lunForHost count] = %d", [lunForHost count]);
                for (int i=0; i<[lunForHost count]; i++) {
                    UIButton *btn = [[lunForHost objectAtIndex:i] objectAtIndex:0];
                    NSString *auth = [[lunForHost objectAtIndex:i] objectAtIndex:1];
                    //NSLog(@"%d %@ %@", i, btn.currentTitle, auth);
                    //btn.frame = CGRectMake(0, 0, size.width/13.0, itemHeight);
                }
                
                for (UIView *subview in textField.subviews) {
                    //NSLog(@"subview=%@", subview);
                    [subview removeFromSuperview];
                }
                
                NSArray *raidsForLuns = [[NSArray alloc] initWithObjects:
                                         [[NSMutableArray alloc] init],
                                         [[NSMutableArray alloc] init],
                                         [[NSMutableArray alloc] init],
                                         [[NSMutableArray alloc] init], nil];
                UIButton *btn = nil;
                for (int i=0; i<[lunForHost count]; i++) {
                    btn = [[lunForHost objectAtIndex:i] objectAtIndex:0];
                    NSString *authority = [[lunForHost objectAtIndex:i] objectAtIndex:1];
                    //NSLog(@"%d. btn = %@ (%@)", i, btn.currentTitle, authority);
                    if ([btn.currentTitle rangeOfString:@"LUN0-"].location != NSNotFound) {
                        [[raidsForLuns objectAtIndex:0] addObject:[lunForHost objectAtIndex:i]];
                    } else if ([btn.currentTitle rangeOfString:@"LUN1-"].location != NSNotFound) {
                        [[raidsForLuns objectAtIndex:1] addObject:[lunForHost objectAtIndex:i]];
                    } else if ([btn.currentTitle rangeOfString:@"LUN2-"].location != NSNotFound) {
                        [[raidsForLuns objectAtIndex:2] addObject:[lunForHost objectAtIndex:i]];
                    } else if ([btn.currentTitle rangeOfString:@"LUN3-"].location != NSNotFound) {
                        [[raidsForLuns objectAtIndex:3] addObject:[lunForHost objectAtIndex:i]];
                    }
                }
                

                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                int currentRaid = 0;
                for (int j=0; j<4; j++) {
                    NSMutableArray *raid_luns_org = [raidsForLuns objectAtIndex:j];
                    //NSLog(@"[raid_luns=%p]", raid_luns);
                    //[raid_luns sortUsingSelector:@selector(compareLUNs:)];
                    
                    NSArray *raid_luns = [raid_luns_org sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                        //NSString *label1 = ((UIButton*)obj1).currentTitle;
                        //NSString *label2 = ((UIButton*)obj2).currentTitle;
                        //NSNumber *second = [(Request*)b priorityID];
                        //NSLog(@"obj1 %p %s@ count=%d", obj1, class_getName([obj1 class]), [obj1 count]);
                        //NSLog(@"obj1 0 =%s", class_getName([[obj1 objectAtIndex:0] class]));
                        //NSLog(@"obj1 1 =%s", class_getName([[obj1 objectAtIndex:1] class]));
                        //NSLog(@"obj2 %p %s@ count=%d", obj2, class_getName([obj2 class]), [obj2 count]);
                        //NSLog(@"obj1=%@,obj2=%@", ((UIButton*)[obj1 objectAtIndex:0]).currentTitle, ((UIButton*)[obj2 objectAtIndex:0]).currentTitle);
                        NSComparisonResult result = [((UIButton*)[obj2 objectAtIndex:0]).currentTitle compare:((UIButton*)[obj1 objectAtIndex:0]).currentTitle];
                        //NSLog(@"compare result = %d", result);
                        
                        //return NSOrderedAscending;//[first compare:second];
                        return result;
                    }];
                    
                    /*
                     sortedArray = [self.selectedReqArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                     NSNumber *first = [(Request*)a priorityID];
                     NSNumber *second = [(Request*)b priorityID];
                     return [first compare:second];
                     }];
                     */
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    [button addTarget:self
                               action:@selector(aMethod:)
                     forControlEvents:UIControlEventTouchDown];
                    [button setTitle:@"Photo Library" forState:UIControlStateNormal];
                    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
                    
                    float cubicWidth = size.width/13.0;
                    float cubicHeight = size.height/4.8;
                    
                    //NSLog(@"raid#= %d -> %p [raid_luns count]=%d,x_offset=%f", j, raid_luns, [raid_luns count], x_offset);
                    if ([raid_luns count]) {
                        //if ([raid_luns count]<=2) {
                        //    x_offset = (itemWidth-labelWidth*([raid_luns count]))/2;
                        //}
                        //NSLog(@"raid#= %d -> %p [raid_luns count]=%d,x_offset=%f", j, raid_luns, [raid_luns count]);
                        for (int i=0; i<[raid_luns count]; i++) {
                            //NSLog(@"LUN#=%d, raid count=%d",i,[raid_luns count]);
                            UIButton *btn = [[raid_luns objectAtIndex:i] objectAtIndex:0];
                            NSString *auth = [[raid_luns objectAtIndex:i] objectAtIndex:1];
                            float x = cubicWidth * (j + 2*(j+1) -0.8) ;//x_offset + currentRaid * labelWidth;//(itemWidth - labelWidth)/2;
                            float y = size.height - (i+1) * cubicHeight;//-y_offset + itemHeight - labelHeight*(i+1);
                            //NSLog(@"currentRaid #%d (x,y)=(%f,%f)", currentRaid, x, y);
                            //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(currentRaid*labelWidth, i*labelHeight, labelWidth, labelHeight)];
                            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];//[[UIButton alloc] initWithFrame:CGRectMake(x, y, labelWidth, labelHeight)];
                            b.backgroundColor = btn.backgroundColor;
                            b.layer.cornerRadius = 3.0f;
                            [b setTitle:[NSString stringWithFormat:@"%@", btn.currentTitle] forState:UIControlStateNormal];
                            [b setFrame:CGRectMake(x, y, 2*size.width/13.0, 20)];
                            [b addTarget:self action:@selector(onLunPress:) forControlEvents:UIControlEventTouchDown];
                            [b addTarget:self action:@selector(onLunPressCancel:) forControlEvents:UIControlEventTouchUpInside];
                            if ([auth isEqualToString:@"RW"]) {
                                [b.layer setBorderColor:[UIColor blackColor].CGColor];
                                [b.layer setBorderWidth:3.0f];
                            }
                            
                            [textField addSubview:b];
                        }
                        currentRaid++;
                    }
                    
                }

                
                
                
                
                
                
                
                
                
                
                
            }
        }
    }
}



- (IBAction)toggleReadMode:(id)sender
{
    int currentHostIndex = NSNotFound;
    for (int i=0; i<sizeof(hostSelectedStatus) && currentHostIndex == NSNotFound; i++) {
        //NSLog(@"%s [host]%d = %d", __func__, i, hostSelectedStatus[i]);
        if (hostSelectedStatus[i] == 1) {
            currentHostIndex = i;
            //NSLog(@"%s xxxxi=%d, [currentHostIndex]=%d", __func__, i, currentHostIndex);
        }
    }
    
    //NSLog(@"%s [currentHostIndex]=%d", __func__, currentHostIndex);
    
    
    if (currentHostIndex != NSNotFound) {
        //NSLog(@"%s %@", __func__, sender);
        UIButton *button = (UIButton *)sender;
        //NSLog(@"'%@' '%@', currentHostIndex=%d", button.description, button.currentTitle, currentHostIndex);
        NSMutableArray *lunForHost = [self.hostArrayForLUNArray objectAtIndex:currentHostIndex];
        //NSLog(@"%s lunForHost=%@", __func__, lunForHost);
        UIButton *foundBtn = nil;
        NSString *authority = nil;
        int lunIndex = 0;
        BOOL found=NO;
        for (int i=0; i<[lunForHost count] && !found; i++) {
            UIButton *btn = [[lunForHost objectAtIndex:i] objectAtIndex:0];
            authority = [[lunForHost objectAtIndex:i] objectAtIndex:1];
            //NSLog(@"%d. btn = %@", i, btn.currentTitle);
            //NSLog(@"%d. sender = %@", i, button.currentTitle);
            if (btn==sender) {
                found = YES;
                foundBtn = sender;
                lunIndex = i;
            }
        }
        
        //NSLog(@"%s %@", __func__, found?@"Found":@"Not found");
        
        if (!found) {
            [lunForHost addObject:[[NSArray alloc] initWithObjects:sender, @"R", nil]];
        } else {
            if ([authority isEqualToString:@"R"]) {
                [lunForHost removeObjectAtIndex:lunIndex];
            }
        }
        //NSLog(@"%s [lunForHost count]=%d", __func__, [lunForHost count]);
        
        [self drawHostsLayout];
    }
}



- (IBAction)toggleReadWriteMode:(UIGestureRecognizer *)doubleTaps
{
    int currentHostIndex = NSNotFound;
    for (int i=0; i<sizeof(hostSelectedStatus) && currentHostIndex == NSNotFound; i++) {
        //NSLog(@"host%d = %d", i, hostSelectedStatus[i]);
        if (hostSelectedStatus[i] == 1) {
            currentHostIndex = i;
        }
    }

    if (currentHostIndex != NSNotFound) {
        UIView *view = doubleTaps.view;
        //NSLog(@"%s %@ view.tag=%d", __func__, doubleTaps, view.tag);
        if (view.tag >= 100 && view.tag < 140) {
            //NSLog(@"%s view.tag=%d (%s)", __func__, view.tag, class_getName(([view class])));
            int raidNo = (view.tag-100)/10;
            int lunNo = (view.tag-100)-raidNo*10;
            //NSLog(@"raid%d-%d", raidNo, lunNo);
            
            
            
            
            NSMutableArray *lunForHost = [self.hostArrayForLUNArray objectAtIndex:currentHostIndex];
            
            BOOL found=NO;
            UIButton *foundBtn = nil;
            NSString *authority = nil;
            int lunIndex = 0;
            
            
            NSInteger removeFromHostIndex = NSNotFound;
            //NSInteger removeFromHostLunIndex = NSNotFound;
            
            for (UIView *subview in self.view.subviews) { //self.view.subviews
                NSRange range = [subview.restorationIdentifier rangeOfString:@"host"];
                if (range.location != NSNotFound) {
                    if ([subview isKindOfClass:[UITextField class]]) {
                        NSString *hostName = subview.restorationIdentifier;
                        NSInteger hostNo = [[hostName substringFromIndex:(range.location+range.length)] integerValue];
                        //NSLog(@"%@ hostNo=%d", subview.restorationIdentifier, hostNo);
                        //UITextField *text = (UITextField *)subview;
                        //text.text = @"Hello";
                        NSMutableArray *lunForHost = [self.hostArrayForLUNArray objectAtIndex:(hostNo-1)];
                        //NSLog(@"[lunForHost count] = %d", [lunForHost count]);
                        for (int i=0; i<[lunForHost count] && !found; i++) {
                            UIButton *btn = [[lunForHost objectAtIndex:i] objectAtIndex:0];
                            authority = [[lunForHost objectAtIndex:i] objectAtIndex:1];
                            //NSLog(@"%d. btn = %@", i, btn.currentTitle);
                            //NSLog(@"%d. sender = %@", i, ((UIButton *)view).currentTitle);
                            if (btn==view && [authority isEqualToString:@"RW"]) {
                                found = YES;
                                foundBtn = (UIButton *)view;
                                lunIndex = i;
                                [lunForHost removeObjectAtIndex:lunIndex];
                                
                                removeFromHostIndex = (hostNo-1);
                                //removeFromHostLunIndex = i;
                                
                                
                                break;
                            }
                        }
                    }
                }
            }
            
            if (currentHostIndex != removeFromHostIndex) {
                lunIndex = 0;
                found=NO;
                for (int i=0; i<[lunForHost count] && !found; i++) {
                    UIButton *btn = [[lunForHost objectAtIndex:i] objectAtIndex:0];
                    authority = [[lunForHost objectAtIndex:i] objectAtIndex:1];
                    //NSLog(@"%d. btn = %@", i, btn.currentTitle);
                    //NSLog(@"%d. sender = %@", i, ((UIButton *)view).currentTitle);
                    if (btn==view) {
                        found = YES;
                        foundBtn = (UIButton *)view;
                        lunIndex = i;
                    }
                }
                
                //NSLog(@"%s %@", __func__, found?@"Found":@"Not found");
                if (!found) {
                    [lunForHost addObject:[[NSArray alloc] initWithObjects:(UIButton *)view, @"RW", nil]];
                } else {
                    if ([authority isEqualToString:@"R"]) {
                        [lunForHost replaceObjectAtIndex:lunIndex withObject:[[NSArray alloc] initWithObjects:view, @"RW", nil]];
                    } else {
                        [lunForHost removeObjectAtIndex:lunIndex];
                    }
                }
                
            }
            
            
            
            
            
            //NSLog(@"%s [lunForHost count]=%d", __func__, [lunForHost count]);
            [self drawHostsLayout];
            
        }
    }

}

- (IBAction)aMethod:(id)sender {
    NSLog(@"%s %@", __func__, sender);
    UIButton *button = (UIButton *)sender;
    NSLog(@"'%@' '%@' '%@'", button.description, button.currentTitle, button.restorationIdentifier);
    NSLog(@"carousel.currentItemIndex=%d", carousel.currentItemIndex);
    NSMutableArray *lunForHost = [self.hostArrayForLUNArray objectAtIndex:carousel.currentItemIndex];
    //[lunForHost addObject:[[NSArray alloc] initWithObjects:sender, @"RW", nil]];
    //NSLog(@"%s [lunForHost count]=%d", __func__, [lunForHost count]);
    
    UIButton *foundBtn = nil;
    NSString *authority = nil;
    int lunIndex = 0;
    BOOL found=NO;
    for (int i=0; i<[lunForHost count] && !found; i++) {
        UIButton *btn = [[lunForHost objectAtIndex:i] objectAtIndex:0];
        authority = [[lunForHost objectAtIndex:i] objectAtIndex:1];
        NSLog(@"%d. btn = %@", i, btn.currentTitle);
        NSLog(@"%d. sender = %@", i, button.currentTitle);
        if (btn==sender) {
            found = YES;
            foundBtn = sender;
            lunIndex = i;
        }
    }
    
    NSLog(@"%s %@", __func__, found?@"Found":@"Not found");
    if (found) {
        if ([authority isEqualToString:@"R"]) {
            [lunForHost replaceObjectAtIndex:lunIndex withObject:[[NSArray alloc] initWithObjects:sender, @"RW", nil]];
        } else { //if ([authority isEqualToString:@"RW"]) {
            [lunForHost removeObjectAtIndex:lunIndex];
        }
    } else {
        [lunForHost addObject:[[NSArray alloc] initWithObjects:sender, @"R", nil]];
    }
    NSLog(@"%s [lunForHost count]=%d", __func__, [lunForHost count]);
    //[lunForHost replaceObjectAtIndex:<#(NSUInteger)#> withObject:<#(id)#>]
    
    //UIButton *btn = [[[self.hostArrayForLUNArray objectAtIndex:carousel.currentItemIndex] objectAtIndex:0] objectAtIndex:0];
    //UIButton *btn = class_getName([[[self.hostArrayForLUNArray objectAtIndex:index] objectAtIndex:0] class]) ;
    //int index=carousel.currentItemIndex;
    //NSLog(@"%s %@", __func__, [btn currentTitle]);

    
    //self.selectedImageView = self.imageView;
    //[self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [carousel reloadData];
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    //if (self.imageView.isAnimating)
    //{
    //    [self.imageView stopAnimating];
    //}
    
    //if (self.capturedImages.count > 0)
    //{
    //    [self.capturedImages removeAllObjects];
    //}
    
    //UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    //imagePickerController.sourceType = sourceType;
    //imagePickerController.delegate = self;
    
    
    
    

    
    // We are using an iPad
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
    [popover presentPopoverFromRect:self.view.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.popOver = popover;

    
    //imagePickerController.delegate = self;
    //UIPopoverController *popoverController=[[UIPopoverController alloc] initWithContentViewController:imagePickerController];
    //popoverController.delegate=self;
    //[popoverController presentPopoverFromRect:((UIButton *)sender).bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    //if (sourceType == UIImagePickerControllerSourceTypeCamera)
    //{
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        //imagePickerController.showsCameraControls = NO;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        //[[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
        //self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
        //imagePickerController.cameraOverlayView = self.overlayView;
        //self.overlayView = nil;
    //}
    
    //self.imagePickerController = imagePickerController;
    //[self presentViewController:self.imagePickerController animated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%s %@", __func__, info);
    self.selectedImageView.image = info[UIImagePickerControllerOriginalImage];
    self.selectedImageView = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    //NSLog(@"%s %@", __func__, sender);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //ensure that the end of scroll is fired.
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:sender afterDelay:0.3];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"%s %@", __func__, scrollView);
    int index = scrollView.contentOffset.x/600;
    carousel.currentItemIndex = index;
    [carousel reloadData];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    NSLog(@"%s %@", __func__, scrollView);
}



- (void)showEngineinfoInHud:(NSString *)engineSerial vpdInfo:(NSDictionary *)vpd {
    /*
    NSString *vpdInfo = [theDelegate.sanDatabase getEngineVpdShortString:vpd];
    
    hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 0, 120, 143);
    
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    NSString *strloadingText = [NSString stringWithFormat:@"%@", engineSerial];
    NSString *strloadingText2 = [NSString stringWithFormat:@"Engine             : %@\n%@", isMaster, vpdInfo];// ;//] @" Please Wait.\r 1-2 Minutes"];
    
    //NSLog(@"the loading text will be %@",strloadingText);
    hud.labelText = strloadingText;
    hud.detailsLabelText=strloadingText2;
    
    //NSLog(@"%s %@ %@", __func__, theDelegate.currentEngineLeftSerial, theDelegate.currentEngineRightSerial);
    
    hud.mode = MBProgressHUDModeText;
    //hud.mode = MBProgressHUDModeCustomView;
    //hud.labelText = @"Some message..Some message...";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.backgroundColor = [UIColor clearColor];
    hud.labelFont = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];//[UIFont systemFontOfSize:25.0];
    hud.detailsLabelFont = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];//[UIFont systemFontOfSize:20.0];
     */
}

/*
- (void)oneFingerTouch:(id)sender {

    NSLog(@"%s %@", __func__, sender);
    const char* className = class_getName([sender class]);
    NSLog(@"class name of sender = %s", className);
    CGPoint point = [singleTapGestureRecognizer locationInView:testTwoFingersTap];
    CGRect rect = testTwoFingersTap.frame;
    NSLog(@"(%f,%f)", point.x, point.y);
    NSLog(@"w=%f h=%f", rect.size.width, rect.size.height);

    if(!isHUDshowing) {
        isHUDshowing = YES;
        CGRect mainFrame = self.view.bounds;
        CGRect hudFrame = CGRectMake(0, 0, 600, mainFrame.size.height/2);
        //CGRect hudFrame1 = CGRectMake(600, 0, 600, mainFrame.size.height/2);
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:hudFrame];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(600 * 2, mainFrame.size.height/2);
        
        UITextView *textView = [[UITextView alloc] initWithFrame:hudFrame];
        textView.editable = FALSE;
        
        NSString *engineSerial = theDelegate.currentEngineLeftSerial;
        NSString *vpdInfo = [self getEngineVpdShortString:engine00Vpd];
        NSString *isMaster = [self isMaster:engineSerial];
        
        hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //hud.frame = CGRectMake(0, 0, 120, 143);
        
        //hud.mode = MBProgressHUDModeAnnularDeterminate;
        //NSString *strloadingText = [NSString stringWithFormat:@"%@", engineSerial];
        NSString *strloadingText2 = [NSString stringWithFormat:@"Engine             : %@\n%@", isMaster, vpdInfo];// ;//] @" Please Wait.\r 1-2 Minutes"];
        textView.text = strloadingText2;
        textView.textColor = [UIColor whiteColor];
        textView.backgroundColor = [UIColor clearColor];
        textView.font = [UIFont fontWithName:@"SourceCodePro-Bold" size:14.0];

        [scrollView addSubview:textView];
        
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = nil;
        hud.detailsLabelText = nil;
        
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        hud.backgroundColor = [UIColor clearColor];
        
        hud.customView = scrollView;
    }
}
 */



- (void)setHost:(UIButton *)button isSelected:(BOOL)selected {
    NSLog(@"%s", __func__);
    
    //int currentHostIndex = NSNotFound;
    if (selected) {
        //currentHostTextField = textField;
        /*
        NSString *hostLabel = button.restorationIdentifier;
        hostLabel = [hostLabel stringByReplacingOccurrencesOfString:@"pc" withString:@""];
        int hostNo = [hostLabel intValue]-1;
        NSLog(@"pc# = %d", hostNo);
        NSLog(@"===================");
        for (int i=0; i<8; i++) {
            NSLog(@"xxxxHost%d=%d", i, hostSelectedStatus[i]);
        }
        NSLog(@"-------------------");
        hostSelectedStatus[hostNo] = 1;
        for (int i=0; i<8; i++) {
            NSLog(@"xxxxHost%d=%d", i, hostSelectedStatus[i]);
        }
        NSLog(@"===================");
        
        //currentHostIndex = [hostLabel integerValue]-1;
        
        //NSRange range = [lunLabel rangeOfString:@"LUN"];
        //NSLog(@"location=%d length=%d", range.location, range.length);
        //NSLog(@"lun#=%@", [lunLabel substringFromIndex:range.location]);
        
        //button.restorationIdentifier
         */
        [[button layer] setBorderWidth:5.0f];
        [[button layer] setBorderColor:[UIColor greenColor].CGColor];
        
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    isFrontView = TRUE;
    
    NSLog(@"deviceName=%@", deviceName);
    deviceName = [deviceName stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
        
    //get data
    theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //self.host1LUNArray = [[NSMutableArray alloc] init];
    //self.host2LUNArray = [[NSMutableArray alloc] init];
    //self.host3LUNArray = [[NSMutableArray alloc] init];
    //self.host4LUNArray = [[NSMutableArray alloc] init];
    //self.host5LUNArray = [[NSMutableArray alloc] init];
    //self.host6LUNArray = [[NSMutableArray alloc] init];
    //self.host7LUNArray = [[NSMutableArray alloc] init];
    
    self.hostArrayForLUNArray = [[NSMutableArray alloc] init];
    [self.hostArrayForLUNArray addObject:[[NSMutableArray alloc] init]];
    [self.hostArrayForLUNArray addObject:[[NSMutableArray alloc] init]];
    [self.hostArrayForLUNArray addObject:[[NSMutableArray alloc] init]];
    [self.hostArrayForLUNArray addObject:[[NSMutableArray alloc] init]];
    [self.hostArrayForLUNArray addObject:[[NSMutableArray alloc] init]];
    [self.hostArrayForLUNArray addObject:[[NSMutableArray alloc] init]];
    [self.hostArrayForLUNArray addObject:[[NSMutableArray alloc] init]];
    [self.hostArrayForLUNArray addObject:[[NSMutableArray alloc] init]];
    [self insertDEMOdata];
    
    //init/add carouse view
    carousel.delegate = self;
    carousel.dataSource = self;
    carousel.type = iCarouselTypeInvertedCylinder;
    carousel.contentOffset = CGSizeMake(0, -60);
    carousel.viewpointOffset = CGSizeMake(0, -50);

    [self.view addSubview:carousel];
    
    carouselDriver.delegate = self;
    carouselDriver.dataSource = self;
    //carouselDriver.type = iCarouselTypeInvertedCylinder;
    //carouselDriver.contentOffset = CGSizeMake(0, -60);
    //carouselDriver.viewpointOffset = CGSizeMake(0, -50);

    [self.view addSubview:carouselDriver];
    //carouselDriver.stopAtItemBoundary = NO;
    //carouselDriver.scrollToItemBoundary = NO;
    //carouselDriver.scrollEnabled = NO;
    
    //carousel.type = iCarouselTypeInvertedCylinder;
    //carousel.type = iCarouselTypeRotary;
    //carousel.type = iCarouselTypeInvertedRotary;// Rotary;
    //carousel.contentOffset = CGSizeMake(0, -60);
    //carousel.viewpointOffset = CGSizeMake(0, -50);
    //carousel.decelerationRate = 0.9;
    
    [theDelegate customizedArcSlider: arcSlider radiusSlider:radiusSlider spacingSlider:spacingSlider sizingSlider:sizingSlider inView:self.view];
    
    //singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    //[self.view addGestureRecognizer:singleFingerTap];
    
    
    //[self.test addGestureRecognizer:doubleTapGestureRecognizer];
    //[thunderboltSWButton addGestureRecognizer:doubleTapGestureRecognizer];
    
    
    //singleTapGestureRecognizerOnHost = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHostInformationOnHUD:)];
    //singleTapGestureRecognizerOnHost.numberOfTouchesRequired = 1;
    //singleTapGestureRecognizerOnHost.numberOfTapsRequired = 1;
    //[carousel addGestureRecognizer:singleTapGestureRecognizerOnHost];
    
    [lun0_0 addTarget:self action:@selector(toggleReadMode:) forControlEvents:UIControlEventTouchUpInside];
    [lun0_1 addTarget:self action:@selector(toggleReadMode:) forControlEvents:UIControlEventTouchUpInside];
    [lun0_2 addTarget:self action:@selector(toggleReadMode:) forControlEvents:UIControlEventTouchUpInside];
    [lun0_3 addTarget:self action:@selector(toggleReadMode:) forControlEvents:UIControlEventTouchUpInside];
    [lun1_0 addTarget:self action:@selector(toggleReadMode:) forControlEvents:UIControlEventTouchUpInside];
    [lun1_1 addTarget:self action:@selector(toggleReadMode:) forControlEvents:UIControlEventTouchUpInside];
    [lun1_2 addTarget:self action:@selector(toggleReadMode:) forControlEvents:UIControlEventTouchUpInside];
    [lun1_3 addTarget:self action:@selector(toggleReadMode:) forControlEvents:UIControlEventTouchUpInside];
    [lun2_0 addTarget:self action:@selector(toggleReadMode:) forControlEvents:UIControlEventTouchUpInside];
    [lun2_1 addTarget:self action:@selector(toggleReadMode:) forControlEvents:UIControlEventTouchUpInside];
    [lun2_2 addTarget:self action:@selector(toggleReadMode:) forControlEvents:UIControlEventTouchUpInside];
    [lun2_3 addTarget:self action:@selector(toggleReadMode:) forControlEvents:UIControlEventTouchUpInside];
    [lun3_0 addTarget:self action:@selector(toggleReadMode:) forControlEvents:UIControlEventTouchUpInside];
    [lun3_1 addTarget:self action:@selector(toggleReadMode:) forControlEvents:UIControlEventTouchUpInside];
    [lun3_2 addTarget:self action:@selector(toggleReadMode:) forControlEvents:UIControlEventTouchUpInside];
    [lun3_3 addTarget:self action:@selector(toggleReadMode:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //[theDelegate hideShowSliders:self.view];
    //doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleReadWriteMode:)];
    //doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    //[self.thunderboltSW addGestureRecognizer:doubleTapGestureRecognizer];
    //[self.view addGestureRecognizer:doubleTapGestureRecognizer];
    
    [self.view bringSubviewToFront:self.templateforraids];
    //[self.view bringSubviewToFront:self.templateForHosts];
    
    for (UIView *subview in self.view.subviews) { //self.view.subviews
        //NSLog(@"%s %@", __func__, subview.restorationIdentifier);
        if ([subview.restorationIdentifier rangeOfString:@"host"].location != NSNotFound) {
            if ([subview isKindOfClass:[UITextField class]]) {
                //NSLog(@"%@", subview);
                UITextField *text = (UITextField *)subview;
                [[text layer] setBorderWidth:0.0f];
                [[text layer] setBorderColor:[UIColor clearColor].CGColor];
                text.borderStyle=UITextBorderStyleNone;
                text.layer.cornerRadius=8.0f;
                text.layer.masksToBounds=YES;
                text.backgroundColor = [UIColor lightTextColor];
                //[[text layer] setBorderWidth:1.0f];
                //[[text layer] setBorderColor:[UIColor grayColor].CGColor];
                
                //text.enabled = YES
                //text setInputView:<#(UIView *)#>;
                text.delegate = self;
                //text.
                [self.view bringSubviewToFront:text];

            }
        }
        if ([subview.restorationIdentifier rangeOfString:@"pc0"].location != NSNotFound) {
            //NSLog(@"%s %@", __func__, subview.restorationIdentifier);
            if (subview.restorationIdentifier) {
                if ([subview isKindOfClass:[UIButton class]]) {
                    //NSLog(@"ooooooooooooo");
                    UIButton *button = (UIButton *)subview;
                    [[button layer] setBorderWidth:1.0f];
                    [[button layer] setBorderColor:[UIColor grayColor].CGColor];
                    //text.borderStyle=UITextBorderStyleNone;
                    button.layer.cornerRadius=8.0f;
                    button.layer.masksToBounds=YES;
                    //button.backgroundColor = [UIColor lightTextColor];
                }
            }
        }

        if (subview.tag >= 100 && subview.tag < 140) {
            [self.view bringSubviewToFront:subview];
            UITapGestureRecognizer *gesRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleReadWriteMode:)];
            gesRecognizer.numberOfTapsRequired = 2;
            [subview addGestureRecognizer:gesRecognizer];
            UIButton *lun = (UIButton *)subview;
            lun.layer.cornerRadius=3.0f;
        }
    }
    
    //if ([subview.restorationIdentifier rangeOfString:@"01"].location != NSNotFound && [subview isKindOfClass:[UITextField class]]) {
    //    [self setHost:(UITextField *)subview];
    //}

    
    [self.view bringSubviewToFront:self.homeButton];
    [self.view bringSubviewToFront:self.pc1];
    [self.view bringSubviewToFront:self.pc2];
    [self.view bringSubviewToFront:self.pc3];
    [self.view bringSubviewToFront:self.pc4];
    [self.view bringSubviewToFront:self.pc5];
    [self.view bringSubviewToFront:self.pc6];
    [self.view bringSubviewToFront:self.pc7];
    [self.view bringSubviewToFront:self.pc8];
    [self drawHostsLayout];

}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //UITextField *text = sender;
    NSLog(@"%s %@", __func__, textField.restorationIdentifier);
    return NO;
}

/*
-(void)textFieldDidEndEditing:(UITextField*) textField{
    NSLog(@"%s %@", __func__, textField.restorationIdentifier);
    //return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSLog(@"%s %@", __func__, textField.restorationIdentifier);
    return YES;
}
 */

- (IBAction)hostAuthorityLUNsSelected:(id)sender {
    UITextField *text = sender;
    NSLog(@"%s %@ %@", __func__, sender, text.restorationIdentifier);
    NSRange range = [text.restorationIdentifier rangeOfString:@"pc0"];
    NSLog(@"location=%d, length=%d", range.location, range.length);
    NSString *hostNoStr = [text.restorationIdentifier substringFromIndex:(range.location+range.length)];
    int hostIndex = [hostNoStr intValue]-1;
    NSLog(@"%s Host%@, hostIndex = %d", __func__, hostNoStr, hostIndex);

    for (UIView *subview in self.view.subviews) { //self.view.subviews
        if (subview.tag >= 100 && subview.tag < 140) {
            UIButton *button = (UIButton *)subview;
            button.alpha = 0.1;
            //CGRect frame = button.frame;
            //UILabel *label = [[UILabel alloc] initWithFrame:frame];
            //label.backgroundColor = [UIColor lightTextColor];
            //label.tag = NSNotFound;
            //[self.view addSubview:label];
        }
    }
    
    NSMutableArray *lunForHost = [self.hostArrayForLUNArray objectAtIndex:hostIndex];
    //NSLog(@"[lunForHost count] = %d", [lunForHost count]);
    for (int i=0; i<[lunForHost count]; i++) {
        UIButton *btn = [[lunForHost objectAtIndex:i] objectAtIndex:0];
        btn.alpha = 1.0;
        NSString *authority = [[lunForHost objectAtIndex:i] objectAtIndex:1];
        //NSLog(@"%d. btn = %@", i, btn.currentTitle);
        //NSLog(@"%d. sender = %@", i, ((UIButton *)view).currentTitle);
        //if (btn==view && [authority isEqualToString:@"RW"]) {
        NSLog(@"%@ authority=%@", btn.currentTitle, authority);
        if ([authority isEqualToString:@"RW"]) {
            btn.layer.borderWidth = 3.0;
        }
        CGRect frame = btn.frame;
        NSLog(@"(x,y)=(%f,%f),(w,h)=(%f,%f)", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    }

    
}

- (IBAction)hostAuthorityLUNsDiselected:(id)sender {
    //UITextField *text = sender;
    //NSLog(@"%s %@ %@", __func__, sender, text.restorationIdentifier);
    //for (UIView *subview in self.view.subviews) { //self.view.subviews
        //NSLog(@"tag=%d", subview.tag);
    //    if (subview.tag == NSNotFound) {
    //        [subview removeFromSuperview];
    //    }
    //}
    for (UIView *subview in self.view.subviews) { //self.view.subviews
        if (subview.tag >= 100 && subview.tag < 140) {
            UIButton *button = (UIButton *)subview;
            button.alpha = 1.0;
            button.layer.borderWidth = 0.0;
        }
    }

}


- (IBAction)selectHost:(id)sender {
    UIButton *button = sender;
    NSLog(@"%s %@", __func__, button.restorationIdentifier);
    
    NSString *hostName = button.restorationIdentifier;
    NSRange range = [hostName rangeOfString:@"pc"];
    int hostNo = [[hostName substringFromIndex:range.location+range.length] intValue]-1;
    //NSLog(@"hostName=%@", [hostName substringFromIndex:[hostName rangeOfString:@"pc"].location+1]);
    //NSLog(@"sizeof = %ld", sizeof(hostSelectedStatus));
    //NSLog(@"hostNo = %d", hostNo);
    
    //for (int i=0; i<sizeof(hostSelectedStatus); i++) {
    //    NSLog(@"%s host%d = %d", __func__, i, hostSelectedStatus[i]);
    //}
    
    BOOL selected = hostSelectedStatus[hostNo]==1?YES:NO;
    
    //NSLog(@"hostSelectedStatus[%d]=%d, selected=%@",hostNo,hostSelectedStatus[hostNo],selected?@"YES":@"NO");
    
    
    for (int i=0; i<sizeof(hostSelectedStatus); i++) {
        hostSelectedStatus[i] = 0;
    }

    
    
    if (selected) {
        //hostSelectedStatus[hostNo] = 0;
        selected = NO;
    } else {
        hostSelectedStatus[hostNo] = 1;
        selected = YES;
    }
    
    //NSLog(@"hostNo=%d", hostNo);
    //hostSelectedStatus[hostNo] = 1;
    
    //for (int i=0; i<sizeof(hostSelectedStatus); i++) {
    //    NSLog(@"%s host%d = %d", __func__, i, hostSelectedStatus[i]);
    //}
    
    //NSLog(@"hostSelectedStatus[%d]=%d, selected=%@",hostNo,hostSelectedStatus[hostNo],selected?@"YES":@"NO");


    
    //button.restorationIdentifier
    for (UIView *subview in self.view.subviews) { //self.view.subviews
        //NSLog(@"%s %@", __func__, subview.restorationIdentifier);
        if (subview.restorationIdentifier) {
            if ([subview.restorationIdentifier rangeOfString:@"pc0"].location != NSNotFound) {
                //NSLog(@"location = %d", [subview.restorationIdentifier rangeOfString:@"pc0"].location);
                if ([subview isKindOfClass:[UIButton class]]) {
                    //NSLog(@"%@", subview);
                    UIButton *button = (UIButton *)subview;
                    //button.borderStyle=UITextBorderStyleNone;
                    button.layer.cornerRadius=8.0f;
                    button.layer.masksToBounds=YES;
                    
                    [[button layer] setBorderWidth:1.0f];
                    [[button layer] setBorderColor:[UIColor grayColor].CGColor];
                }
            }
        }
    }
    [self setHost:button isSelected:selected];
}

- (IBAction)imageMoved:(id) sender withEvent:(UIEvent *) event
{
    NSLog(@"%s %@ %@", __func__, sender, event);
    UIControl *control = sender;
    
    UITouch *t = [[event allTouches] anyObject];
    CGPoint pPrev = [t previousLocationInView:control];
    CGPoint p = [t locationInView:control];
    
    CGPoint center = control.center;
    center.x += p.x - pPrev.x;
    center.y += p.y - pPrev.y;
    control.center = center;
}



// The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self hideHud];
}

- (void)loadEngineCliInformation:(NSString *)serial {
    //[sanDatabase httpGetEngineCliVpdBySiteName:theDelegate.siteName serial:serial];
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%s", __func__);
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%s", __func__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //carousel.delegate = nil;
    //carousel.dataSource = nil;
    //carousel = nil;
    //self.totalItems = nil;
    //self.activeItems = nil;
    self.host1LUNArray = nil;
    self.host2LUNArray = nil;
    self.host3LUNArray = nil;
    self.host4LUNArray = nil;
    self.host5LUNArray = nil;
    self.host6LUNArray = nil;
    self.host7LUNArray = nil;
}

- (void)changeSWSide:(id)sender {
    
    NSLog(@"%s", __func__);
    //UIButton *theButton = (UIButton *)sender;
    if (isFrontView) {
        [thunderboltSWButton setImage:[UIImage imageNamed:@"swBackView"] forState:UIControlStateNormal];
        isFrontView = FALSE;
    } else {
        [thunderboltSWButton setImage:[UIImage imageNamed:@"swFrontView"] forState:UIControlStateNormal];
        isFrontView = TRUE;
    }
}

- (IBAction)onHome:(id)sender
{
    NSLog(@"%s", __func__);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideHud {
    NSLog(@"%s", __func__);
    if (isHUDshowing) {
        NSInteger delaySec = 0.1;
        [hud hide:YES afterDelay:delaySec];
        isHUDshowing = NO;
    }
}

- (void)onItemPress:(id)sender {
    UIButton *theButon = (UIButton *)sender;
    NSLog(@"%s onItemPress: tag=%d", __func__, theButon.tag);
    //[self showHostInformationOnHUD:sender];
    //[self presentViewController:self.hbaViewController animated:YES completion:nil];
}

- (IBAction)reloadCarousel {
    NSLog(@"%s", __func__);
    [carousel reloadData];
}

- (IBAction)updateValue:(id)sender {
    UISlider *slider = (UISlider*)sender;
    //NSLog(@"%s %@ %@", __func__, sender, [sender restorationIdentifier]);
    
    NSString *identifier = [sender restorationIdentifier];
    
    if ([identifier isEqualToString:@"arcSlider"])
        arcValue.text = [NSString stringWithFormat:@"%1.2f", slider.value];
    else if ([identifier isEqualToString:@"radiusSlider"])
        radiusValue.text = [NSString stringWithFormat:@"%1.2f", slider.value];
    else if ([identifier isEqualToString:@"spacingSlider"])
        spacingValue.text = [NSString stringWithFormat:@"%1.2f", slider.value];
    else if ([identifier isEqualToString:@"sizingSlider"])
        sizingValue.text = [NSString stringWithFormat:@"%1.2f", slider.value];
}

-(NSComparisonResult) compareLUNs:(id)element {
    NSLog(@"%s %@", __func__, element);
    return NSOrderedAscending; //NSOrderedSame, NSOrderedDescending
}

#pragma mark -
#pragma mark iCarousel methods

#pragma mark - iCarousel datasource and delegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)_carousel {
    if (_carousel == carousel) {
        return 12;
    }
    return 12;
}

- (UIView *)carousel:(iCarousel *)_carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    
    //class_getName([sender class]
    //id obj = [[self.hostArrayForLUNArray objectAtIndex:index] objectAtIndex:0];
    //UIButton *btn = class_getName([[[self.hostArrayForLUNArray objectAtIndex:index] objectAtIndex:0] class]) ;
    //NSLog(@"%s index=%d", __func__, index);
    
    UILabel *theLabel = nil;
	if (view == nil) {
        view = [[UIView alloc] init];
        //view.backgroundColor = [UIColor redColor];
        UIImage *theItemImage = nil;
        float itemWidth, itemHeight;

        if (_carousel == self.carouselDriver) {
            theItemImage = [UIImage imageNamed:@"drive.png"];
        } else {
            theItemImage = [UIImage imageNamed:@"Device-PC.png"];
        }
        theLabel = [[UILabel alloc] init];
        theLabel.numberOfLines = 0;
        theLabel.textColor = [UIColor darkGrayColor];
        
        itemWidth = theItemImage.size.width; // 250px
        itemHeight = theItemImage.size.height;
        
        //NSLog(@"%s image.width=%f, %f", __func__, itemWidth, itemHeight);

        UIButton *theButton = [UIButton buttonWithType:UIButtonTypeCustom];;
        theButton.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        [theButton setImage:theItemImage forState:UIControlStateNormal];

        //theButton.backgroundColor = [UIColor redColor];
        //theButton.tag = ITEM_BUTTON_START_TAG + index;
        //[theButton addTarget:self action:@selector(onItemPress:) forControlEvents:UIControlEventTouchUpInside];
        if (_carousel == self.carousel) {
            theLabel.frame = CGRectMake(0, itemHeight-10, itemWidth, 40);
            theLabel.font = [UIFont boldSystemFontOfSize:30.0];
            
            //theLabel.alpha = 0.5;
            theLabel.backgroundColor = [UIColor clearColor];
            //theLabel.backgroundColor = [UIColor yellowColor];
            theLabel.textAlignment = NSTextAlignmentCenter;
            theLabel.tag = 1;
            //[view addSubview:theLabel];
            
            
        } else {
            theLabel.frame = CGRectMake(0, itemHeight-70, itemWidth, 40);
            [theLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:20.0]];
        }
        
        view.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        [view addSubview:theButton];
        

        
    } else {
        theLabel = (UILabel *)[view viewWithTag:1];
	}
    //theLabel.text = [NSString stringWithFormat:@"%d", index+1];
	return view;
}


- (UIView *)carousel:(iCarousel *)_carousel viewForItemAtIndexXXX:(NSUInteger)index reusingView:(UIView *)view {
    
    //class_getName([sender class]
    //id obj = [[self.hostArrayForLUNArray objectAtIndex:index] objectAtIndex:0];
    //UIButton *btn = class_getName([[[self.hostArrayForLUNArray objectAtIndex:index] objectAtIndex:0] class]) ;
    NSLog(@"%s index=%d", __func__, index);
    
    UILabel *theLabel = nil;
	if (view == nil) {
        UIButton *theButton;
        view = [[UIView alloc] init];
        //view.backgroundColor = [UIColor redColor];
        UIImage *theItemImage = [UIImage imageNamed:@"macbookpro_blank.png"];
        if (_carousel == self.carouselDriver) {
            theItemImage = [UIImage imageNamed:@"drive.png"];
        }
        theLabel = [[UILabel alloc] init];
        theLabel.numberOfLines = 0;
        theLabel.textColor = [UIColor darkGrayColor];
        
        float itemWidth, itemHeight;
        
        itemWidth = theItemImage.size.width; // 250px
        itemHeight = theItemImage.size.height;
        
        theButton = [UIButton buttonWithType:UIButtonTypeCustom];
        theButton.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        //theButton.backgroundColor = [UIColor redColor];
        //theButton.tag = ITEM_BUTTON_START_TAG + index;
        //[theButton addTarget:self action:@selector(onItemPress:) forControlEvents:UIControlEventTouchUpInside];
        if (_carousel == self.carousel) {
            theLabel.frame = CGRectMake(0, itemHeight-10, itemWidth, 40);
            theLabel.font = [UIFont boldSystemFontOfSize:30.0];
            
            //theLabel.alpha = 0.5;
            theLabel.backgroundColor = [UIColor clearColor];
            //theLabel.backgroundColor = [UIColor yellowColor];
            theLabel.textAlignment = NSTextAlignmentCenter;
            theLabel.tag = 1;
            
            [theButton setImage:theItemImage forState:UIControlStateNormal];
            
            view.frame = CGRectMake(0, 0, itemWidth, itemHeight);
            [view addSubview:theButton];
            [view addSubview:theLabel];
            
            /*
             UITextView *theTextView = [[UITextView alloc] init];
             theTextView.text = @"Example of non-editable UITextView";
             //theTextView.backgroundColor = [UIColor greenColor];
             theTextView.backgroundColor = [UIColor clearColor];
             theTextView.frame = CGRectMake(0, 0, itemWidth, itemHeight);
             theTextView.editable = NO;
             
             //[view addSubview:theTextView];
             
             //[lunForHost addObject:[[NSArray alloc] initWithObjects:sender, @"RW", nil]];
             //NSLog(@"%s [lunForHost count]=%d", __func__, [lunForHost count]);
             
             NSMutableString *mutableString = [[NSMutableString alloc] init];
             for (int i=0; i<[lunForHost count]; i++) {
             UIButton *btn = [[lunForHost objectAtIndex:i] objectAtIndex:0];
             NSString *authority = [[lunForHost objectAtIndex:i] objectAtIndex:1];
             NSLog(@"%d. btn = %@ (%@)", i, btn.currentTitle, authority);
             [mutableString appendString:[NSString stringWithFormat:@"%@(%@)\n", btn.currentTitle, authority]];
             //if ([authority isEqualToString:@"R"]) {
             //[lunForHost replaceObjectAtIndex:lunIndex withObject:[[NSArray alloc] initWithObjects:sender, @"RW", nil]];
             //} else { //if ([authority isEqualToString:@"RW"]) {
             //[lunForHost removeObjectAtIndex:lunIndex];
             //}
             }
             theTextView.text = mutableString;
             */
            
            NSMutableArray *lunForHost = [self.hostArrayForLUNArray objectAtIndex:index];
            UIView *theViewContainer = [[UITextView alloc] init];
            
            theViewContainer.frame = CGRectMake(0, 0, itemWidth, itemHeight);
            theViewContainer.backgroundColor = [UIColor clearColor];
            
            [view addSubview:theViewContainer];
            NSArray *raidsForLuns = [[NSArray alloc] initWithObjects:
                                     [[NSMutableArray alloc] init],
                                     [[NSMutableArray alloc] init],
                                     [[NSMutableArray alloc] init],
                                     [[NSMutableArray alloc] init], nil];
            UIButton *btn = nil;
            for (int i=0; i<[lunForHost count]; i++) {
                btn = [[lunForHost objectAtIndex:i] objectAtIndex:0];
                NSString *authority = [[lunForHost objectAtIndex:i] objectAtIndex:1];
                NSLog(@"%d. btn = %@ (%@)", i, btn.currentTitle, authority);
                if ([btn.currentTitle rangeOfString:@"LUN0-"].location != NSNotFound) {
                    [[raidsForLuns objectAtIndex:0] addObject:[lunForHost objectAtIndex:i]];
                } else if ([btn.currentTitle rangeOfString:@"LUN1-"].location != NSNotFound) {
                    [[raidsForLuns objectAtIndex:1] addObject:[lunForHost objectAtIndex:i]];
                } else if ([btn.currentTitle rangeOfString:@"LUN2-"].location != NSNotFound) {
                    [[raidsForLuns objectAtIndex:2] addObject:[lunForHost objectAtIndex:i]];
                } else if ([btn.currentTitle rangeOfString:@"LUN3-"].location != NSNotFound) {
                    [[raidsForLuns objectAtIndex:3] addObject:[lunForHost objectAtIndex:i]];
                }
            }
            int howManyRaids = 0;
            if ([[raidsForLuns objectAtIndex:0] count]) {
                howManyRaids++;
            }
            if ([[raidsForLuns objectAtIndex:1] count]) {
                howManyRaids++;
            }
            if ([[raidsForLuns objectAtIndex:2] count]) {
                howManyRaids++;
            }
            if ([[raidsForLuns objectAtIndex:3] count]) {
                howManyRaids++;
            }
            
            NSLog(@"how many raids %d", howManyRaids);
            
            NSInteger labelWidth = 0;
            NSInteger labelHeight = 0;
            float x_offset = 0;
            float y_offset = 5;
            
            float percent = 1.0;
            if (btn != nil) {
                if (howManyRaids == 1) {
                    labelWidth = btn.frame.size.width;
                    labelHeight = btn.frame.size.height;
                    x_offset = (itemWidth-labelWidth)/2;
                } else if (howManyRaids == 2) {
                    labelWidth = btn.frame.size.width;
                    labelHeight = btn.frame.size.height;
                    x_offset = (itemWidth-labelWidth*2)/2;
                } else if (howManyRaids == 3) {
                    labelWidth = itemWidth / howManyRaids;
                    percent = labelWidth / btn.frame.size.width;
                    labelHeight = btn.frame.size.height * percent;
                    x_offset = 0;
                } else if (howManyRaids == 4) {
                    labelWidth = itemWidth / howManyRaids;
                    percent = labelWidth / btn.frame.size.width;
                    labelHeight = btn.frame.size.height * percent;
                    x_offset = 0;
                }
            }
            int currentRaid = 0;
            for (int j=0; j<4; j++) {
                NSMutableArray *raid_luns_org = [raidsForLuns objectAtIndex:j];
                //NSLog(@"[raid_luns=%p]", raid_luns);
                //[raid_luns sortUsingSelector:@selector(compareLUNs:)];
                
                NSArray *raid_luns = [raid_luns_org sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    //NSString *label1 = ((UIButton*)obj1).currentTitle;
                    //NSString *label2 = ((UIButton*)obj2).currentTitle;
                    //NSNumber *second = [(Request*)b priorityID];
                    NSLog(@"obj1 %p %s@ count=%d", obj1, class_getName([obj1 class]), [obj1 count]);
                    NSLog(@"obj1 0 =%s", class_getName([[obj1 objectAtIndex:0] class]));
                    NSLog(@"obj1 1 =%s", class_getName([[obj1 objectAtIndex:1] class]));
                    NSLog(@"obj2 %p %s@ count=%d", obj2, class_getName([obj2 class]), [obj2 count]);
                    NSLog(@"obj1=%@,obj2=%@", ((UIButton*)[obj1 objectAtIndex:0]).currentTitle, ((UIButton*)[obj2 objectAtIndex:0]).currentTitle);
                    NSComparisonResult result = [((UIButton*)[obj1 objectAtIndex:0]).currentTitle compare:((UIButton*)[obj2 objectAtIndex:0]).currentTitle];
                    NSLog(@"compare result = %d", result);
                    
                    //return NSOrderedAscending;//[first compare:second];
                    return [((UIButton*)[obj2 objectAtIndex:0]).currentTitle compare:((UIButton*)[obj1 objectAtIndex:0]).currentTitle];
                }];
                
                /*
                 sortedArray = [self.selectedReqArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                 NSNumber *first = [(Request*)a priorityID];
                 NSNumber *second = [(Request*)b priorityID];
                 return [first compare:second];
                 }];
                 */
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button addTarget:self
                           action:@selector(aMethod:)
                 forControlEvents:UIControlEventTouchDown];
                [button setTitle:@"Photo Library" forState:UIControlStateNormal];
                button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
                
                
                
                NSLog(@"raid#= %d -> %p [raid_luns count]=%d,x_offset=%f", j, raid_luns, [raid_luns count], x_offset);
                if ([raid_luns count]) {
                    //if ([raid_luns count]<=2) {
                    //    x_offset = (itemWidth-labelWidth*([raid_luns count]))/2;
                    //}
                    NSLog(@"raid#= %d -> %p [raid_luns count]=%d,x_offset=%f", j, raid_luns, [raid_luns count], x_offset);
                    for (int i=0; i<[raid_luns count]; i++) {
                        NSLog(@"LUN#=%d, raid count=%d",i,[raid_luns count]);
                        UIButton *btn = [[raid_luns objectAtIndex:i] objectAtIndex:0];
                        NSString *auth = [[raid_luns objectAtIndex:i] objectAtIndex:1];
                        float x = x_offset + currentRaid * labelWidth;//(itemWidth - labelWidth)/2;
                        float y = -y_offset + itemHeight - labelHeight*(i+1);
                        NSLog(@"currentRaid #%d (x,y)=(%f,%f)", currentRaid, x, y);
                        //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(currentRaid*labelWidth, i*labelHeight, labelWidth, labelHeight)];
                        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];//[[UIButton alloc] initWithFrame:CGRectMake(x, y, labelWidth, labelHeight)];
                        b.backgroundColor = btn.backgroundColor;
                        [b setTitle:[NSString stringWithFormat:@"%@", btn.currentTitle] forState:UIControlStateNormal];
                        [b setFrame:CGRectMake(x, y, labelWidth, labelHeight)];
                        [b addTarget:self action:@selector(onItemPress:) forControlEvents:UIControlEventTouchUpInside];
                        
                        //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, labelWidth, labelHeight)];
                        //UILabel *label = b.titleLabel;
                        //label.text = [NSString stringWithFormat:@"%@", btn.currentTitle];
                        //label.textAlignment = UITextAlignmentCenter;
                        //label.backgroundColor = btn.backgroundColor;
                        //label.font = [UIFont systemFontOfSize:15.0*percent];
                        //if ([auth isEqualToString:@"RW"]) {
                        //    label.layer.borderColor = [UIColor blackColor].CGColor;
                        //    label.layer.borderWidth = 2.0;
                        //    label.font = [UIFont boldSystemFontOfSize:15.0*percent];
                        //}
                        [theViewContainer addSubview:b];
                    }
                    currentRaid++;
                }
                
            }

            
            
        } else {
            theLabel.frame = CGRectMake(0, itemHeight-70, itemWidth, 40);
            [theLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:20.0]];
        }

     }
    else {
        theLabel = (UILabel *)[view viewWithTag:1];
	}
    theLabel.text = [NSString stringWithFormat:@"%d", index+1];
	return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"%s index=%d",__func__, index);
    //currentHostIndex = index;
    //[self presentViewController:self.hbaViewController animated:YES completion:nil];
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)_carousel {
    NSLog(@"%s %d",__func__, _carousel.currentItemIndex);
    //NSMutableArray *lunForHost = [self.hostArrayForLUNArray objectAtIndex:carousel.currentItemIndex];
    //[lunForHost addObject:[[NSArray alloc] initWithObjects:sender, @"RW", nil]];
    //NSLog(@"%s [lunForHost count]=%d", __func__, [lunForHost count]);
    
    //for (int i=0; i<[lunForHost count]; i++) {
    //    UIButton *btn = [[lunForHost objectAtIndex:i] objectAtIndex:0];
    //    NSLog(@"%@", btn.currentTitle);
    //}
    //[_carousel reloadData];
    //currentItemIndex = _carousel.currentItemIndex;
    //[theDelegate updateItemIndexCountsAndTotalLabel:currentItemIndex count:currentCollectionCount total:totalCount forUILabel:itemIndexCountsAndTotalLabel];
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            if (_carousel == self.carousel) {
                return TRUE;
            }
            return TRUE;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionArc:
        {
            if (_carousel == self.carousel) {
            return 2 * M_PI * arcSlider.value;
            }
        }
        case iCarouselOptionRadius:
        {
            if (_carousel == self.carousel) {
            return value * radiusSlider.value;
            }
        }
        case iCarouselOptionSpacing:
        {
            if (_carousel == self.carousel) {
                return value * spacingSlider.value;
            } else {
                return 1.5 * value;
            }
            
        }
        default:
        {
            return value;
        }
    }
}



@end
