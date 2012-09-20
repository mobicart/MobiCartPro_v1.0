//
//  MobicartAppAppDelegate.m
//  MobicartApp
//
//  Created by Mobicart on 14/09/10.
//  Copyright Mobicart 2010. All rights reserved.

#import "MobicartAppAppDelegate.h"
#import "MobicartAppViewController.h"
#import "MobiCartStart.h"
#import "UserDetails.h"
#import "SqlQuery.h"
@implementation MobicartAppAppDelegate
@synthesize window;  
@synthesize viewController,tabController,arrAllData,loadingIndicator,backgroundImage;
 

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
   	NSString *strMobicartEmail = [NSString stringWithFormat:@"%@",merchant_email];
	NSString *strPaypalToken = [NSString stringWithFormat:@"%@",merchant_zooz_token];
	NSString *strIsTokenLive = [NSString stringWithFormat:@"%@",ISTOKENLIVE];
	NSString *strSecretKey = [NSString stringWithFormat:@"%@",merchant_secret_key];
	
	if([strPaypalToken isEqualToString:@"nil"])
	{
		strPaypalToken=nil;
	}
	
	
	if (![strIsTokenLive length]>0) 
	{
		strIsTokenLive=nil;
	}
		
	[[MobiCartStart sharedApplication] startMobicartOnMainWindow:window withMerchantEmail:strMobicartEmail  Paypal_Live_Token_ID:strPaypalToken ENV_CHECK:strIsTokenLive Merchant_Secret_Key_Of_Store:strSecretKey];
	
 
	// For getting geo coordinates of user location
	userLocation = [[CLLocationManager alloc] init];
	userLocation.delegate = self;
    
	const CLLocationAccuracy * ptr = &kCLLocationAccuracyBestForNavigation;
	BOOL frameworkSupports = (ptr != NULL);
	
    if(frameworkSupports)
    {
        userLocation.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
	else
    {
        userLocation.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstTime"]==nil)
    {
        
        [[NSUserDefaults standardUserDefaults]setValue:@"Not First Time" forKey:@"isFirstTime"];
        
        [[SqlQuery shared]setTblAccountDetails:@"demo" :@"demo@123.com" :@"demo123" :@"St123" :@"city" :@"United Kingdom" :@"NewCastle" :@"1" :@"" :@"" :@"" :@"" :@""];    
    }
    

	[userLocation startUpdatingLocation];
	[window makeKeyAndVisible];
	
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	tempLocation = newLocation.coordinate;
	[manager setDelegate:nil];
	
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Error in Location Services. Error: %@", error);
}

#pragma mark Push Notification Delegation methods
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken 
{   
	NSString* tempToken = [[NSString stringWithFormat:@"%@",devToken] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSString *tempToken1 = [tempToken stringByReplacingOccurrencesOfString:@">" withString:@"" ];
	NSString *tokenString= [tempToken1 stringByReplacingOccurrencesOfString:@"<" withString:@"" ];
	NSData*	deviceToken = [[NSData alloc]initWithData:devToken];
	
	NSString *strLatitude=[NSString stringWithFormat:@"%lf",tempLocation.latitude];
	NSString *strLongitude=[NSString stringWithFormat:@"%lf",tempLocation.longitude];
	
	[ServerAPI pushNotifications:strLatitude:strLongitude:tokenString:iCurrentAppId];	
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err 
{
	NSLog(@"Error in registration. Error: %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:[[userInfo valueForKey:@"aps"]valueForKey:@"alert"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
     [alertView show];
	 [alertView release];
}

#pragma mark -
#pragma mark Memory management
- (void)dealloc 
{
    [viewController release];
    [window release];
	
	if(loadingIndicator)
    {
        [loadingIndicator release];
    }
	
	if(backgroundImage)
    {
        [backgroundImage release];
    }
	if(userLocation)
		[userLocation release];
	
	
    [super dealloc];
}


@end
