//
//  MobicartAppDelegate.h
//  Mobicart
//
//  Created by Mobicart on 05/03/11.
//  Copyright Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class MobicartViewController;

@interface MobicartAppDelegate : NSObject <UIApplicationDelegate,CLLocationManagerDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate> {
    UIWindow *window;
    MobicartViewController *viewController;
	UITabBarController *tabController;
	NSArray *arrAllData;
	UIImageView *backgroundImage;
	UIActivityIndicatorView *loadingIndicator;
	CLLocationCoordinate2D tempLocation;
    UIView *imgloadView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MobicartViewController *viewController;
@property (nonatomic, retain) UITabBarController *tabController;
@property (nonatomic, retain) NSArray *arrAllData;
@property (nonatomic, retain) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) UIImageView *backgroundImage;
@property (nonatomic, retain) UIView *imgloadView;

@end

