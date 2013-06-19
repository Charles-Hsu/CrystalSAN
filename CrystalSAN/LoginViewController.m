//
//  RaidViewController.m
//  CrystalSAN
//
//  Created by Charles Hsu on 12/27/12.
//  Copyright (c) 2012 Charles Hsu. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"


#define ITEM_BUTTON_START_TAG_RAIDVIEW 300

@interface LoginViewController ()


@end

@interface LoginViewController () <UITextFieldDelegate, UITextViewDelegate> {
    /*
    UIEdgeInsets    _priorInset;
    BOOL            _priorInsetSaved;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
    CGSize          _originalContentSize;
    */
    
    CGRect _realBounds;
    AppDelegate *theDelegate;
    CGFloat animatedDistance;
    
    BOOL keyboardIsShown;

    
}
/*
- (UIView*)findFirstResponderBeneathView:(UIView*)view;
- (UIEdgeInsets)contentInsetForKeyboard;
- (CGFloat)idealOffsetForView:(UIView *)view withSpace:(CGFloat)space;
- (CGRect)keyboardRect;
 */
@end


@implementation LoginViewController {
    //CGRect _realBounds;
    //AppDelegate *theDelegate;
    //CGFloat animatedDistance;
}

@synthesize siteName;
@synthesize userName;
@synthesize password;

@synthesize scrollView;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

#define kTabBarHeight 100
#define kKeyboardAnimationDuration 1.0


/*
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}
*/

/*
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}
 */

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%s %@", __func__, textField);
    [textField resignFirstResponder];
    [self onConfirm:nil];
    return YES;
}

/*
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    
     if (textField == usernameField) {
     [passwordField becomeFirstResponder];
     } else if (textField == passwordField) {
     //HERE THE LOGIN CODE
     [textField resignFirstResponder];
     }
    
    return YES;
}
 */


- (void)keyboardActionBegin:(NSNotification *)n
{
    //NSLog(@"%s %@", __func__, [[n userInfo] valueForKey:@"UIKeyboardFrameChangedByUserInteraction"]);
    NSLog(@"%s %@", __func__, [n userInfo]);
}

- (void)keyboardActionEnd:(NSNotification *)n
{
    //NSLog(@"%s %@", __func__, [[n userInfo] valueForKey:@"UIKeyboardFrameChangedByUserInteraction"]);
    NSLog(@"%s %@", __func__, [n userInfo]);
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    scrollView = [[UIScrollView alloc] init];
    
    theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.siteName.text = theDelegate.siteName;
    [self.siteName setEnabled: NO];
    //self.siteName.editable = NO;
    //siteN
    self.password.keyboardType = UIKeyboardTypeNumberPad;
    
    // UITextField focus
    // http://stackoverflow.com/questions/1014999/uitextfield-focus
    [self.userName becomeFirstResponder];
    
    //self.siteName.delegate = self;
    self.userName.delegate = self;
    self.password.delegate = self;
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardActionBegin:)
                                                 name:UIKeyboardFrameBeginUserInfoKey
                                               object:self.view.window];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardActionEnd:)
                                                 name:UIKeyboardFrameEndUserInfoKey
                                               object:self.view.window];
     */
    
    
    keyboardIsShown = NO;
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
    CGSize scrollContentSize = CGSizeMake(320, 345);
    scrollView.contentSize = scrollContentSize;
    

}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.view.superview.bounds = _realBounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onConfirm:(id)sender {
    //NSString *loginForSiteName = nil;
    //if ([siteName.text isEqualToString:@"Loxoll"]) {
    //    loginForSiteName = @"Accusys";
    //} else {
    //    loginForSiteName = siteName.text;
    //}
    NSString *urlString = [theDelegate.sanDatabase hostURLPathWithPHP:@"http-check-auth.php"];
    NSString *urlStringWithItems = [urlString stringByAppendingFormat:@"?site=%@&user=%@&password=%@", siteName.text, userName.text, password.text];
    NSURL *url = [NSURL URLWithString:urlStringWithItems];
    NSError *error = nil;
    NSString *apiResponse = nil;
    
    NSLog(@"%s %@", __func__, url);
    
    NSLog(@"%s url %@ isReachable", __func__, url);
    
    apiResponse = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"--");
    NSLog(@"%@", urlStringWithItems);
    NSLog(@"nsurl response = %@", apiResponse);
    NSLog(@"nsurl error = %@", error);
    NSLog(@"--");
    
    NSLog(@"%s %@", __func__, theDelegate.siteInfoArray);
    
    if ([apiResponse isEqualToString:@"1"]) {
        theDelegate.siteName = siteName.text;
        //[theDelegate.sanDatabase httpGetHAClusterDictionaryBySiteName:theDelegate.siteName];
        [theDelegate setCurrentSiteLogin];
    }
    
    NSLog(@"%s %@", __func__, theDelegate.siteInfoArray);
    
    theDelegate.isHostReachable = TRUE;
    
    if ([theDelegate IsCurrentSiteLogin]) {
        theDelegate.userName = self.userName.text;
        theDelegate.siteName = self.siteName.text;
        theDelegate.password = self.password.text;
        
        if (theDelegate.siteName != nil) {
            if (theDelegate.syncManager == nil) {
                theDelegate.syncManager = [[SyncManager alloc] init];
            }
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"presentNextViewControllerNotification" object:nil];
        }];
    } else {
        [self shakeView:self.view];
    }

    
}


- (void)keyboardWillHide:(NSNotification *)n
{
    //NSLog(@"%s %@", __func__, [[n userInfo] valueForKey:@"UIKeyboardFrameChangedByUserInteraction"]);
    NSLog(@"%s %@", __func__, [n userInfo]);

    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the scrollview
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height += (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    // The kKeyboardAnimationDuration I am using is 0.3
    [UIView setAnimationDuration:kKeyboardAnimationDuration];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    
    //NSLog(@"%s %@", __func__, [[n userInfo] valueForKey:@"UIKeyboardFrameChangedByUserInteraction"]);
    NSLog(@"%s %@", __func__, [n userInfo]);
    
    if (keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height -= (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    // The kKeyboardAnimationDuration I am using is 0.3
    [UIView setAnimationDuration:kKeyboardAnimationDuration];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardIsShown = YES;
}

- (NSString *)getDefaultSiteName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    NSLog(@"%s %@", __func__, defaults);
    
    return (NSString *)[defaults objectForKey:@"site_name"];
}

// Shake visual effect on iPhone (NOT shaking the device)
// http://stackoverflow.com/questions/1632364/shake-visual-effect-on-iphone-not-shaking-the-device

- (void)shakeView:(UIView *)viewToShake {
    CGFloat t = 2.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    viewToShake.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

/*
// Called when UIKeyboardWillShowNotification is sent
- (void)keyboardWillShow:(NSNotification*)notification
{
    // if we have no view or are not visible in any window, we don't care
    if (!self.isViewLoaded || !self.view.window) {
        return;
    }
    
    NSDictionary *userInfo = [notification userInfo];
    
    CGRect keyboardFrameInWindow;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrameInWindow];
    
    // the keyboard frame is specified in window-level coordinates. this calculates the frame as if it were a subview of our view, making it a sibling of the scroll view
    CGRect keyboardFrameInView = [self.view convertRect:keyboardFrameInWindow fromView:nil];
    
    CGRect scrollViewKeyboardIntersection = CGRectIntersection(_scrollView.frame, keyboardFrameInView);
    UIEdgeInsets newContentInsets = UIEdgeInsetsMake(0, 0, scrollViewKeyboardIntersection.size.height, 0);
    
    // this is an old animation method, but the only one that retains compaitiblity between parameters (duration, curve) and the values contained in the userInfo-Dictionary.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    
    _scrollView.contentInset = newContentInsets;
    _scrollView.scrollIndicatorInsets = newContentInsets;
    
    //
    // Depending on visual layout, _focusedControl should either be the input field (UITextField,..) or another element
    // that should be visible, e.g. a purchase button below an amount text field
    // it makes sense to set _focusedControl in delegates like -textFieldShouldBeginEditing: if you have multiple input fields
    //
    if (_focusedControl) {
        CGRect controlFrameInScrollView = [_scrollView convertRect:_focusedControl.bounds fromView:_focusedControl]; // if the control is a deep in the hierarchy below the scroll view, this will calculate the frame as if it were a direct subview
        controlFrameInScrollView = CGRectInset(controlFrameInScrollView, 0, -10); // replace 10 with any nice visual offset between control and keyboard or control and top of the scroll view.
        
        CGFloat controlVisualOffsetToTopOfScrollview = controlFrameInScrollView.origin.y - _scrollView.contentOffset.y;
        CGFloat controlVisualBottom = controlVisualOffsetToTopOfScrollview + controlFrameInScrollView.size.height;
        
        // this is the visible part of the scroll view that is not hidden by the keyboard
        CGFloat scrollViewVisibleHeight = _scrollView.frame.size.height - scrollViewKeyboardIntersection.size.height;
        
        if (controlVisualBottom > scrollViewVisibleHeight) { // check if the keyboard will hide the control in question
            // scroll up until the control is in place
            CGPoint newContentOffset = _scrollView.contentOffset;
            newContentOffset.y += (controlVisualBottom - scrollViewVisibleHeight);
            
            // make sure we don't set an impossible offset caused by the "nice visual offset"
            // if a control is at the bottom of the scroll view, it will end up just above the keyboard to eliminate scrolling inconsistencies
            newContentOffset.y = MIN(newContentOffset.y, _scrollView.contentSize.height - scrollViewVisibleHeight);
            
            [_scrollView setContentOffset:newContentOffset animated:NO]; // animated:NO because we have created our own animation context around this code
        } else if (controlFrameInScrollView.origin.y < _scrollView.contentOffset.y) {
            // if the control is not fully visible, make it so (useful if the user taps on a partially visible input field
            CGPoint newContentOffset = _scrollView.contentOffset;
            newContentOffset.y = controlFrameInScrollView.origin.y;
            
            [_scrollView setContentOffset:newContentOffset animated:NO]; // animated:NO because we have created our own animation context around this code
        }
    }
    
    [UIView commitAnimations];
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillHide:(NSNotification*)notification
{
    // if we have no view or are not visible in any window, we don't care
    if (!self.isViewLoaded || !self.view.window) {
        return;
    }
    
    NSDictionary *userInfo = notification.userInfo;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    
    // undo all that keyboardWillShow-magic
    // the scroll view will adjust its contentOffset apropriately
    _scrollView.contentInset = UIEdgeInsetsZero;
    _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
    [UIView commitAnimations];
}
*/

@end
