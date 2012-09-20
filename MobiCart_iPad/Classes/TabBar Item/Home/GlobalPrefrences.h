//
//  GlobalPrefrences.h
//  Mobicart
//
//  Created by Mobicart on 05/03/11.
//  Copyright Mobicart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Reachability.h"
NSOperationQueue *queue;
@class Reachability;
Reachability* internetReach;
BOOL isLoggedInStatuschanged;

@interface GlobalPrefrences : NSObject {
}
#pragma mark ----- Fetch data From server

#pragma mark TabBar Prefernces
+(void)setBackgroundTheme_OnView:(UIView*)setInView;
+(void)setTabbarControllers_SelectedByUser:(NSDictionary *)dictFeatures;
+(void)setTabbarItemTitles:(NSArray *)arrSelected_Titles;
+(NSArray *)tabBarControllers_SelectedByUser;
+(NSArray *)getAllNavigationTitles;
+(NSDictionary *) getAppVitals;
+(void)setGlobalPreferences;
#pragma mark - NSOperationQueue Handler
+(void)addToOpertaionQueue:(NSInvocationOperation *) _opertion;
+(void)setUserDefault_Preferences:(NSString *)value :(NSString *)key;
+(NSString *)getUserDefault_Preferences:(NSString *)forKey;
+ (BOOL) validateEmail: (NSString *) candidate;

#pragma mark Nav Bar Logo
+(void)setColorScheme_SelectedByUser:(NSDictionary *)dictFeatures;
+(void)setPersonLoginStatus:(BOOL)_status;
+(BOOL)getPersonLoginStatus;

#pragma mark - Loading Bar At Bottom
+(void)addLoadingBar_AtBottom:(UIView *)showInView withTextToDisplay:(NSString *)strText;
+(void)dismissLoadingBar_AtBottom;

#pragma mark ----- Store
+(void)setCurrentDepartmentId:(NSInteger )_iCurrentDepartmentId;
+(void)setCurrentCategoryId:(NSInteger )_iCurrentCategoryId;
+(void)setCurrentProductId:(NSInteger )_iCurrentProductId;
+(void)setNextProductDetails:(NSDictionary *)_dictTemp;
+(void) setPaypal_TOKEN_CHECK:(NSString *)_paypalToken;
+(NSString *) getPaypal_TOKEN_CHECK;
+(void) setMerchant_Secret_Key:(NSString *)_secretKey;
+(NSString *) getMerchant_Secret_Key;



+(void)setAppVitalsAndCountries:(NSDictionary*)_dicVitals;
+(void)setCurrentFeaturedProductDetails:(NSDictionary *)_dictTemp;
+(void)setCurrentProductDetails:(NSDictionary *)_dictTemp;


#pragma mark Home
+(BOOL)canPopToRootViewController;
+(void)setIsClickedOnFeaturedImage:(BOOL)_isClicked;
+(BOOL) isClickedOnFeaturedProductFromHomeTab;
+(void)setCanPopToRootViewController:(BOOL) _canPop;


+(void)setCurrentNavigationController: (UINavigationController *)_navigationController;
+(UINavigationController *)getCurrentNavigationController;

/******* SHOPPING CART *******/

+(void)setUserCountryAndStateForTax_country:(NSString*)_country countryID:(int)countryID;
+(NSString*)getUserCountryFortax;
+(int)getUserCountryID;
+(void)addLoadingBar_AtWindow:(UIView *)showInView withTextToDisplay:(NSString *)strText;

+(void)setPersonLoginStatus:(BOOL)_status;
+(BOOL)getPersonLoginStatus;



+(NSDictionary *) getCurrentFeaturedDetails;
+(NSDictionary *) getNextFeaturedProductDetails;
//**********User setting Details **************
+(void)setSettingsOfUserAndOtherDetails:(NSDictionary *)dictSettings;
+(NSDictionary *)getSettingsOfUserAndOtherDetails;
+(void)setCurrencySymbol;

+(void)setCurrentItemsInCart:(BOOL)added;
+(NSInteger)getCurrenItemsInCart;

+(void) setCurrentShoppingCartNum:(NSInteger)_num;
+(NSInteger) getCurrentShoppingCartNum;

+(float) getRoundedOffValue:(float)_num;
#pragma mark - Language Labels
+(void)setLanguageLabels:(NSDictionary *)_dictTemp;
+(NSDictionary *) getLangaugeLabels;

#pragma mark - API Settings
+(void) setMerchantEmailID:(NSString *)_merchantEmail;
+(NSString *)getMerchantEmailId;
#pragma mark - ZoozPaypal Live Token 
+(void) setPaypal_Live_Token:(NSString *)_paypalToken;
+(NSString *) getPaypalLiveToken;

#pragma mark - ZoozPaypal Sandbox Account
+(void) setPaypal_Sandbox_Recipient_Email:(NSString *)_sandBoxEmailAccount;
+(NSString *) getPaypal_Sandbox_Recipient_Email;
//*********************App Vitals**********
+(BOOL)isInternetAvailable;
+(BOOL) updateInterfaceWithReachability: (Reachability*) curReach;
//***********************Department data Home********************
+(void)setDepartmentsDataHomes:(NSArray*)arrDepts;
+(NSArray*)getDepartmentsDataHomes;
+(void)setDepartmentNamesHomes:(NSString*)nameStr;
+(NSString*)getLastDepartmentNameHomes;

//***********************Department data Store********************
+(void)setDepartmentsDataStore:(NSArray*)arrDepts;
+(NSArray*)getDepartmentsDataStore;
+(void)setDepartmentNamesStore:(NSString*)nameStr;
+(NSString*)getLastDepartmentNameStore;

+(void)removeLocalData;
@end
