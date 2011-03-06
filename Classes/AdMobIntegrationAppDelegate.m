//
//  AdMobIntegrationAppDelegate.m
//  AdMobIntegration
//
//  Created by Andreas Katzian on 06.03.11.
//

#import "AdMobIntegrationAppDelegate.h"
#import "AdMobIntegrationViewController.h"

@implementation AdMobIntegrationAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

	// Set the view controller as the window's root view controller and display.
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

	
	[self addAdmobView];
	
    return YES;
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}




#pragma mark -
#pragma mark ADMOB INTEGRATION


#pragma mark -
#pragma mark ADMOB VIEW METHODS

// Add a new AdMob banner view to the current view
- (void) addAdmobView
{
	// Create a new AdMobView for iPhone portrait mode
	// At this point you can check your device and environment and
	// provide the correct sized ad banner.
	AdMobView *adMobView = [AdMobView requestAdOfSize:ADMOB_SIZE_320x48 withDelegate:self];
	
	// Set position to the top but hide it
	CGRect frame	= adMobView.frame;
	frame.origin	= CGPointMake(0, -adMobView.frame.size.height);
	adMobView.frame = frame;

	// Add Banner to current view
	[viewController.view addSubview:adMobView];
	adMobVisible = NO;
}

// Hide the given AdMob banner with animation
- (void) hideAdMobView:(AdMobView*)adView
{
	@synchronized(self)
	{
		if (adMobVisible == YES)
		{
			[UIView beginAnimations:@"animateBannerOff" context:NULL];
			// Assumes the banner view is placed at the top of the screen.
			adView.frame = CGRectOffset(adView.frame, 0, -adView.frame.size.height);
			[UIView commitAnimations];
			
			// Update view status
			adMobVisible = NO;
		}
	}
}

// Show the given AdMob banner with animation
- (void) showAdMobView:(AdMobView*)adView
{
	@synchronized(self)
	{
		if (adMobVisible == NO)
		{
			[UIView beginAnimations:@"animateBannerOn" context:NULL];
			// Assumes the banner view is just off the top of the screen.
			adView.frame = CGRectOffset(adView.frame, 0, adView.frame.size.height);
			[UIView commitAnimations];
			
			// Update view status
			adMobVisible = YES;
		}
	}
}



#pragma mark -
#pragma mark ADMOB CONFIGURATION PARAMETERS


// Use this to provide a publisher id for an ad request. Get a publisher id
// from http://www.admob.com.  adView will be nil for interstitial requests.
- (NSString *)publisherIdForAd:(AdMobView *)adView
{
	return @"YOUR_ADMOB_APP_ID";
}

// Return the current view controller (AdMobView should be part of its view hierarchy).
// Make sure to return the root view controller (e.g. a UINavigationController, not
// the UIViewController attached to it) .
- (UIViewController *)currentViewControllerForAd:(AdMobView *)adView
{
	return viewController;
}

#pragma mark -
#pragma mark optional notification methods

// Sent when an ad request loaded an ad; this is a good opportunity to add
// this view to the hierachy, if it has not yet been added.
// Note that this will only ever be sent once per AdMobView, regardless of whether
// new ads are subsequently requested in the same AdMobView.
- (void)didReceiveAd:(AdMobView *)adView
{
	[self showAdMobView:adView];
}

// Sent when a AdMobView successfully makes a subsequent ad request (via requestFreshAd).
// For example an AdView object that shows three ads in its lifetime will see the following
// methods called:  didReceiveAd:, didReceiveRefreshedAd:, and didReceiveRefreshedAd:.
- (void)didReceiveRefreshedAd:(AdMobView *)adView;
{
	[self showAdMobView:adView];
}

// Sent when an ad request failed to load an ad.
// Note that this will only ever be sent once per AdMobView, regardless of whether
// new ads are subsequently requested in the same AdMobView.
- (void)didFailToReceiveAd:(AdMobView *)adView;
{
	[self hideAdMobView:adView];
}

// Sent when subsequent AdMobView ad requests fail (via requestFreshAd).
- (void)didFailToReceiveRefreshedAd:(AdMobView *)adView;
{
	[self hideAdMobView:adView];
}

// Sent just before presenting the user a full screen view, such as a canvas page or an embedded webview,
// in response to clicking on an ad. Use this opportunity to stop animations, time sensitive interactions, etc.
//- (void)willPresentFullScreenModalFromAd:(AdMobView *)adView

// Sent just after presenting the user a full screen view, such as a canvas page or an embedded webview,
// in response to clicking on an ad.
//- (void)didPresentFullScreenModalFromAd:(AdMobView *)adView;

// Sent just before dismissing a full screen view.
//- (void)willDismissFullScreenModalFromAd:(AdMobView *)adView;

// Sent just after dismissing a full screen view. Use this opportunity to
// restart anything you may have stopped as part of -willPresentFullScreenModal:.
//- (void)didDismissFullScreenModalFromAd:(AdMobView *)adView

// Send just before the application will close because the user clicked on an ad.
// Clicking on any ad will either call this or willPresentFullScreenModal.
// The normal UIApplication applicationWillTerminate: delegate method will be called
// after this.
//- (void)applicationWillTerminateFromAd:(AdMobView *)adView;


#pragma mark optional test ad methods

// Test ads are returned to these devices.  Device identifiers are the same used to register
// as a development device with Apple.  To obtain a value open the Organizer 
// (Window -> Organizer from Xcode), control-click or right-click on the device's name, and
// choose "Copy Device Identifier".  Alternatively you can obtain it through code using
// [UIDevice currentDevice].uniqueIdentifier.

- (NSArray *)testDevices
{
	return [NSArray arrayWithObjects:ADMOB_SIMULATOR_ID, nil];
}

// If implemented, lets you specify the action type of the test ad. Defaults to @"url" (web page).
// Does nothing if testDevices is not implemented or does not map to the current device.
// Acceptable values are @"url", @"app", @"movie", @"call", @"canvas".  For interstitials
// use "video_int".
//
// Normally, the adservers restricts ads appropriately (e.g. no click to call ads for iPod touches).
// However, for your testing convenience, they will return any type requested for test ads.
//- (NSString *)testAdActionForAd:(AdMobView *)adView
//{
//	return @"app";
//}



@end
