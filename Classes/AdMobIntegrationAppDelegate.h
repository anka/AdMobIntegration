//
//  AdMobIntegrationAppDelegate.h
//  AdMobIntegration
//
//  Created by Andreas Katzian on 06.03.11.
//

#import <UIKit/UIKit.h>
#import "AdMobDelegateProtocol.h"
#import "AdMobView.h"

@class AdMobIntegrationViewController;

@interface AdMobIntegrationAppDelegate : NSObject <UIApplicationDelegate, AdMobDelegate> {
    UIWindow *window;
    AdMobIntegrationViewController *viewController;
	BOOL adMobVisible;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AdMobIntegrationViewController *viewController;

- (void) addAdmobView;
- (void) hideAdMobView:(AdMobView*)adView;
- (void) showAdMobView:(AdMobView*)adView;

@end

