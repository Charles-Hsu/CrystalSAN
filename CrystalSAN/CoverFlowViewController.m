//
//  CoverFlowViewController.m
//  CrystalSAN
//
//  Created by Charles Hsu on 12/25/12.
//  Copyright (c) 2012 Loxoll, inc. All rights reserved.
//

#import "CoverFlowViewController.h"
#import "AppDelegate.h"


@interface CoverFlowViewController ()

@end

@implementation CoverFlowViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        self.iCarouselView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 50, 1024, 500)];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //get data
    AppDelegate *theDelegate = (ALAppDelegate *)[UIApplication sharedApplication].delegate;
    self.totalItems = theDelegate.totalItems;
    //self.activeItems = theDelegate.activeItems;
    
    //init/add carouse view
    self.iCarouselView.delegate = self;
    self.iCarouselView.dataSource = self;
    [self.view addSubview:self.iCarouselView];
    //self.iCarouselView.currentItemIndex = self.totalItems.count / 2;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.iCarouselView.delegate = nil;
    self.iCarouselView.dataSource = nil;
    self.iCarouselView = nil;
    //self.totalItems = nil;
    //self.activeItems = nil;
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}



#pragma mark - event handler
-(void)onItemPress:(id)sender{
    
    UIButton *theButon = (UIButton *)sender;

    NSLog(@"onItemPress:, tag=%d",theButon.tag);
    
}


- (IBAction)onHome:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - iCarousel datasource and delegate
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.totalItems count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIButton *theButton;
    
    UIImage *theItemImage = [UIImage imageNamed:self.totalItems[index]];
    float itemWidth,itemHeight;
    
    //button size
    if(self.iCarouselView.type == iCarouselTypeTimeMachine)
    {
        itemWidth = theItemImage.size.width ;
        itemHeight = theItemImage.size.height ;
    }else if(self.iCarouselView.type == iCarouselTypeInvertedCylinder){
        itemWidth = theItemImage.size.width / 2 ;
        itemHeight = theItemImage.size.height  / 2 ;
    }else{
        itemWidth = theItemImage.size.width * 2 / 3 ;
        itemHeight = theItemImage.size.height  * 2 / 3 ;
    }
    
	//create new view if no view is available for recycling
	if (view == nil)
	{
        theButton= [UIButton buttonWithType:UIButtonTypeCustom];
        theButton.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        theButton.tag = ITEM_BUTTON_START_TAG + index;
        [theButton addTarget:self action:@selector(onItemPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
	{
		theButton = (UIButton *)view;
	}
	
    //define button handler
    [theButton setImage:theItemImage forState:UIControlStateNormal];
    	
	return theButton;
}


- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"carousel:didSelectItemAtIndex:  %d",index);
    
}






@end
