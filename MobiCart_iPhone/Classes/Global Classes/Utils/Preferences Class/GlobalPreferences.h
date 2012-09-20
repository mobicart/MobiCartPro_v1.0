//
//  GlobalPreferences.h
//  MobiCart
//
//  Created by Mobicart on 7/7/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <Foundation/NSString.h>
#import "SBJSON.h"

extern BOOL isNewsSection;

@class Reachability;
Reachability* internetReach;
BOOL isLoggedInStatuschanged;

// The queue to run "ParseOperation"
NSOperationQueue *queue;

@interface GlobalPreferences:NSObject 
{
	UIColor *navigationBarColor;
}

@property (nonatomic, retain) UIColor *navigationBarColor;



+(BOOL)isInternetAvailable;


#pragma mark -
+(void)initializeGlobalControllers;
//+(NSDictionary *)fetchDataFromServer:(NSString *)strURL;
//+(void)sendDataToServer:(NSString*)_url;



#pragma mark -
+(void)setCurrencySymbol;
+(void)setPersonLoginStatus:(BOOL)_status;
+(BOOL)getPersonLoginStatus;

+(void)setLanguageLabels:(NSDictionary *)_dictTemp;
+(NSDictionary *) getLangaugeLabels;

#pragma mark Tabbar Settings
+(void)setTabbarControllers_SelectedByUser:(NSDictionary *)dictFeatures;
+(NSArray *)tabBarControllers_SelectedByUser;

+(void)setTabbarItemTitles:(NSArray *)arrSelected_Titles;
+(NSArray *)getAllNavigationTitles;

#pragma mark - Search Bar Default Settings
+(void)setSearchBarDefaultSettings:(UISearchBar *)_searchBar;


#pragma mark - Home 
+(BOOL)canPopToRootViewController;
+(void)setCanPopToRootViewController:(BOOL) _canPop;


+(void)setCurrentNavigationController: (UINavigationController *)_navigationController;

+(UINavigationController *)getCurrentNavigationController;


+(UIImageView*)createLogoImage;
+(void)setColorScheme_SelectedByUser:(NSDictionary *)dictFeatures;

// Set gradient effect on the view
+(void)setGradientEffectOnView:(UIView *)view:(UIColor *)mainColor:(UIColor *)secondaryColor;

#pragma mark ----- Store
+(void)setCurrentDepartmentId:(NSInteger )_iCurrentDepartmentId;
+(void)setCurrentCategoryId:(NSInteger )_iCurrentCategoryId;
+(void)setCurrentProductId:(NSInteger )_iCurrentProductId;

+(void)setCurrentFeaturedProductDetails:(NSDictionary *)_dictTemp;
+(void)setIsClickedOnFeaturedImage:(BOOL)_isClicked;


//+(NSString *)getDepartmentUrl;
//+(NSString *)getCategoriesUrl:(NSInteger)_iCurrentDepartmentId;

//+(NSString *)getProductsUrl:(NSInteger)_iCurrentProductId;
+(NSDictionary *) getCurrentFeaturedDetails;
+(void)setCurrentProductDetails:(NSDictionary *)_dictTemp;
+(NSDictionary *) getCurrentProductDetails;

+(BOOL) isClickedOnFeaturedProductFromHomeTab;


+ (UIColor *) colorWithHexString: (NSString *)stringToConvert;



#pragma mark ------ Shopping Cart -------

/******* SHOPPING CART *******/

// Label on the navigation bar
+(float) getRoundedOffValue:(float)_num;

+(void)setCurrentItemsInCart:(BOOL)added;

+(NSInteger)getCurrenItemsInCart;
+ (BOOL) validateEmail: (NSString *) candidate;
+(void)setUserDefault_Preferences:(NSString *)value :(NSString *)key;
+(NSString *)getUserDefault_Preferences:(NSString *)forKey;
+(void)setUserCountryAndStateForTax_country:(NSString*)_country countryID:(int)countryID;
+(NSString*)getUserCountryFortax;
+(int)getUserCountryID;


//**********User setting Details **************
+(void)setSettingsOfUserAndOtherDetails:(NSDictionary *)dictSettings;
+(NSDictionary *)getSettingsOfUserAndOtherDetails;

//*********************App Vitals**********

+(void)setAppVitalsAndCountries:(NSDictionary*)_dicVitals;
+(NSDictionary *) getAppVitals;
//+(NSString*)fetchStatesOfAcountryURL:(NSInteger)_iCountryCode;

//*************************************
+(void)goToShoppingCart:(UIViewController *)_currentViewController;

+(void)setShadowOnView:(UIView *)_view:(UIColor *)_shadowColor:(BOOL)_includeGradient:(UIColor *)mainColor:(UIColor *)secondaryColor;

#pragma mark - NSOperationQueue Handler

+(void)addToOpertaionQueue:(NSInvocationOperation *) _opertion;


#pragma mark - Loading Indicator
+(void) addLoadingIndicator_OnView:(UIView *)_view;
+(void) stopLoadingIndicator;
+(void) startLoadingIndicator;

#pragma mark - Loading Bar At Bottom
+(void)addLoadingBar_AtBottom:(UIView *)showInView withTextToDisplay:(NSString *)strText;
+(void)dismissLoadingBar_AtBottom;


+(void) setCurrentShoppingCartNum:(NSInteger) _num;
+(NSInteger) getCurrentShoppingCartNum;

#pragma mark - Current Device

+(void) setCurrentDevice4:(BOOL) _device4;
+(BOOL) getCurrentDevice4;

#pragma mark - More Navigation Controller Settings
+(void) setMoreNavigationConroller_Footer:(BOOL)isShowing;
+(BOOL) isShowingFooterLogo_OnMoreNavigationController;


#pragma mark - API Settings
+(void) setMerchantEmailID:(NSString *)_merchantEmail;
+(NSString *)getMerchantEmailId;
#pragma mark - Paypal/Zooz Live Token 
+(void) setPaypal_Live_Token:(NSString *)_paypalToken;
+(NSString *) getPaypalLiveToken;

#pragma mark - Paypal/Zooz Sandbox Account
+(void) setPaypal_Sandbox_Recipient_Email:(NSString *)_sandBoxEmailAccount;
+(NSString *) getPaypal_Sandbox_Recipient_Email;

#pragma mark Device Token
+(void)setDeviceTokenForNotification:(NSString*)_token;
+(NSString*)getDeviceToken;

+(void) setPaypal_TOKEN_CHECK:(NSString *)_paypalToken;
+(NSString *) getPaypal_TOKEN_CHECK;

+(void) setMerchant_Secret_Key:(NSString *)_secretKey;
+(NSString *) getMerchant_Secret_Key;
+(void)setAllNavigationTitles;

@end





