//
//  MobicartAppAppDelegate.h
//  MobicartApp
//
//  Created by Mobicart on 14/09/10.
//  Copyright Mobicart 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class MobicartAppViewController;

@interface MobicartAppAppDelegate : NSObject <UIApplicationDelegate,CLLocationManagerDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate> 
{
    UIWindow *window;
    MobicartAppViewController *viewController;
	UITabBarController *tabController;
	NSArray *arrAllData;
	CLLocationManager *userLocation;
	UIActivityIndicatorView *loadingIndicator;
	UIImageView *backgroundImage;
	CLLocationCoordinate2D tempLocation;
    
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MobicartAppViewController *viewController;
@property (nonatomic, retain) UITabBarController *tabController;
@property (nonatomic, retain) NSArray *arrAllData;
@property (nonatomic, retain) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) UIImageView *backgroundImage;


@end

