//
//  MobiCartStart.h
//  MobicartApp
//
//  Created by Mobicart on 12/2/11.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "MobicartAppAppDelegate.h"

@class MobiCartWebView;
@class MobicartAppAppDelegate;

int controllersCount;
BOOL isNewsSection;

@interface MobiCartStart : UIViewController <UITabBarControllerDelegate,UINavigationControllerDelegate>
{
	NSString *PAYPAL_SANDBOX_TOKEN_ID, *PAYPAL_LIVE_TOKEN_ID, *MOBICART_MERCHANT_EMAIL;
	
	
	BOOL hideMobicartCopyrightLogo;
    UIImage *imgFooter;

	
	MobiCartWebView *objMobiWebView;
    
}
@property (nonatomic, retain) NSString *PAYPAL_SANDBOX_TOKEN_ID;

@property (nonatomic, retain) NSString *PAYPAL_LIVE_TOKEN_ID;

@property (nonatomic, retain) NSString *MOBICART_MERCHANT_EMAIL;
@property(nonatomic,retain)    UIImage *imgFooter;


// !!!: ********** USE THIS METHOD TO START APP ********* :!!!
+ (id)sharedApplication;

- (id) startMobicartOnMainWindow:(UIWindow *) _window withMerchantEmail:(NSString *)_merchantEmail  Paypal_Live_Token_ID:(NSString *) paypal_Token_Received_From_Paypal ENV_CHECK:(NSString *)ISTOKENENV Merchant_Secret_Key_Of_Store:(NSString*)strMerchant_Secret_Key;


// METHOD TO HANDLE MOBICART BRANDING ON MORE TAB
- (void)poweredMobicart;

- (void)removeMobicart;

@end
