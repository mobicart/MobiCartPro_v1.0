//
//  MobicartAppDelegate.m
//  Mobicart
//
//  Created by Mobicart on 05/03/11.
//  Copyright Mobicart. All rights reserved.
//


#import "MobicartAppDelegate.h"
#import "MobicartViewController.h"
#import "MobicartStart.h"
#import "UserDetails.h"
#import "Constants.h"


@implementation MobicartAppDelegate

@synthesize window;
@synthesize viewController,tabController,arrAllData,loadingIndicator,backgroundImage,imgloadView;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    //Override point for customization after app launch. 
    [viewController showSplash];
    [viewController hideSplash];

	  [self performSelector:@selector(loading) withObject:nil];  
   	 [self.window makeKeyAndVisible];
    
	return YES;
}

-(void)loading
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
    NSString *strMobicartEmail=[NSString stringWithFormat:@"%@",merchant_email];
    NSString *strPaypalToken=[NSString stringWithFormat:@"%@",merchant_zooz_token];
	NSString *strIsTokenLive=[NSString stringWithFormat:@"%@",ISTOKENLIVE];
	
    NSString *strSecretKey = [NSString stringWithFormat:@"%@",merchant_secret_key];
    
	if([strPaypalToken isEqualToString:@"nil"])
		strPaypalToken=nil;
	
    
	if (![strIsTokenLive length]>0) 
		strIsTokenLive=nil;
	
	
	[[MobicartStart sharedApplication] startMobicartOnMainWindow:window withMerchantEmail:strMobicartEmail  Paypal_Live_Token_ID:strPaypalToken ENV_CHECK:strIsTokenLive Merchant_Secret_Key_Of_Store:strSecretKey];
	
	// For getting geo coordinates of user location
	CLLocationManager *userLocation = [[CLLocationManager alloc] init];
	userLocation.delegate = self;
    
	const CLLocationAccuracy * ptr = &kCLLocationAccuracyBestForNavigation;
	BOOL frameworkSupports = (ptr != NULL);
	
    if (frameworkSupports)
    {
        userLocation.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
	else
    {
        userLocation.desiredAccuracy = kCLLocationAccuracyBest;
    }
	
	[userLocation startUpdatingLocation];
	if([[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstTime"]==nil)
    {
        
        [[NSUserDefaults standardUserDefaults]setValue:@"Not First Time" forKey:@"isFirstTime"];
        [[SqlQuery shared]setTblAccountDetails:@"demo" :@"demo@123.com" :@"demo123" :@"St123" :@"city" :@"United Kingdom" :@"NewCastle" :@"1" :@"" :@"" :@"" :@"" :@""];        
    }
    [pool release];

}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	tempLocation = newLocation.coordinate;
	
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Error in Location Services. Error:-- %@", error);
}
     




#pragma mark Push Notification Delegation methods
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken 
{
	NSString* tempToken = [[NSString stringWithFormat:@"%@",devToken] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSString *tempToken1 = [tempToken stringByReplacingOccurrencesOfString:@">" withString:@"" ];
	NSString *tokenString= [tempToken1 stringByReplacingOccurrencesOfString:@"<" withString:@"" ];
	
	NSData*	deviceToken = [[NSData alloc]initWithData:devToken];
	NSLog(@"device token is: %@",deviceToken);
	
	NSString *strLatitude=[NSString stringWithFormat:@"%lf",tempLocation.latitude];
	NSString *strLongitude=[NSString stringWithFormat:@"%lf",tempLocation.longitude];
	[ServerAPI pushNotifications:strLatitude :strLongitude :tokenString:iCurrentAppId];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err 
{
	//NSLog(@"Error in registration. Error: %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:[[userInfo valueForKey:@"aps"]valueForKey:@"alert"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


@end
