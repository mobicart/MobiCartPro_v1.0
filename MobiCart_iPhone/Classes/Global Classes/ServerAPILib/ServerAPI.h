//
//  ServerAPI.h
//  ServerAPI
//
//  Created by MobiCart on 05/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>//"
#import "SBJSON.h"

//*********** REPLACE THIS TO CHANGE SERVER ADDRESS ***********//

@interface ServerAPI : NSObject{
    
}
//********************************Store Products Methods Declaration************************//

+ (NSDictionary*)fetchLanguagePreferences:(int)iCurrentMerchantId;

+ (BOOL)isLangUpdated:(NSString *)strTimeStamp:(int)iCurrentMerchantId;

+ (NSDictionary *)fetchProductsWithCategories:(int)deptID:(int)catID:(int)CountryID:(int)StateID:(NSInteger)iCurrentStoreId;

+ (NSDictionary *)fetchProductsWithoutCategories:(int)deptID:(int)CountryID:(int)StateID:(NSInteger)iCurrentStoreId;

+ (NSURLRequest *)createImageURLConnection:(NSString *)strImage;

+ (NSURLRequest *)createTweetImageRequest:(NSString *)url;

+ (NSData *)fetchBannerImage:(NSString *)strImage;

+ (void)pushNotifications:(NSString*)strLatitude:(NSString*)strLongitude:(NSString*)tokenString:(NSInteger)iCurrentAppId;

+ (NSString *)getDepartmentUrl:(NSInteger)iCurrentStoreId;

+ (UIImage*)setLogoImage:(NSString *)logoUrl:(BOOL)isNull;

+ (NSString *)getproductsWithoutCatogeriesUrl:(NSInteger)_iCurrentDepartmentId:(NSInteger)iCurrentStoreId;

+ (NSString *)getCategoriesUrl:(NSInteger)_iCurrentDepartmentId:(NSInteger)iCurrentStoreId;

+ (NSDictionary*)fetchStatesOfAcountryURL:(NSInteger)_iCountryCode;

+ (NSDictionary*)fetchSearchProducts:(NSString*)sProductName:(int)countrId:(int)stateId:(NSInteger)iCurrentAppId;

+ (void)fetchProductAnalytics:(NSString *)sProductId;

+ (NSDictionary*)fetchProductsWithCategoriesAndSubCategories_departmentID:(int)deptID categoryID:(int)catID countyID:(int)_country stateID:(int)_state:(NSInteger)iCurrentStoreId;

+ (NSDictionary*)fetchProductsWithoutCategories_departmentID:(int)departmentID countryID:(int)_country stateID:(int)_state:(NSInteger)iCurrentStoreId;

+ (NSDictionary*)fetchAllDepartments:(NSInteger)iCurrentStoreId;

+ (NSDictionary*)fetchAllCatogeries:(NSInteger)iCurrentDepartmentId:(NSInteger)iCurrentStoreId;
+(NSDictionary *)fetchSubCategories:(int)categoryId:(NSInteger)iCurrentStoreId;

+ (NSDictionary*)fetchDetailsOfProductWithID:(int)_productID;

+ (NSDictionary*)fetchDetailsOfProductWithID:(int)_productID countryID:(int)_country stateID:(int)_state;

+ (NSDictionary*)fetchOrderDetails:(NSString *)_userEmail:(NSInteger)iCurrentAppId:(NSInteger)iCurrentStoreId;

+(void)pushNotifications:(NSString*)strLatitude:(NSString*)strLongitude:(NSString*)tokenString;
+(NSDictionary*)fetchTwitterFeedFor;

+ (NSDictionary*)fetchNewsItem:(NSInteger)iCurrentStoreId;

+ (NSDictionary*)fetchTwitterFeedFor:(NSInteger)iCurrentStoreId;

+ (NSDictionary*)fetchStatesOfCountryWithID:(int)_countryID;

+ (NSDictionary*)fetchAddressOfMerchant:(NSString*)merchant_email;

+ (NSDictionary*)fetchTaxShippingDetails:(int)countryID:(int)stateID:(NSInteger)iCurrentStoreId;

+ (NSDictionary*)fetchProductDetails:(int)productId:(int)lcountryID:(int)stateID;

//************************************Home user Methods Declaration **************************//
+ (NSDictionary*)getAppStoreUserDetails:(NSString*)merchantEmailId;

+ (NSDictionary*)fetchTabbarPreferences:(NSInteger)iCurrentAppId;

+ (NSDictionary*)fetchColorScheme:(NSInteger)iCurrentAppId;

+ (NSDictionary*)fetchAppVitals:(NSInteger)iCurrentAppId;

+ (NSDictionary*)fetchStaticPages:(NSInteger)iCurrentAppId;

+ (NSDictionary*)fetchBannerProducts:(NSInteger)iCurrentStoreId;

+ (NSDictionary*)fetchFeaturedproducts:(int)countryID:(int)stateID:(NSInteger)iCurrentAppId;

+ (NSDictionary*)fetchSettings:(NSInteger)iCurrentStoreId;

#pragma mark fetchDataFromServer
+ (NSDictionary *)fetchDataFromServer:(NSString *)strURL;

#pragma mark sendDataToServer
+ (void)sendDataToServer:(NSString*)_url;

+ (NSString *) checkoutSendData:(NSURL *)_url withData:(NSString *)strDataToPost;

+ (NSString*)product_orderSaveURLSend:(NSString*)strDataToPost;

+ (NSString*)product_order_ItemSaveURLSend:(NSString*)strDataToPost;

+ (NSString*)product_order_NotifyURLSend:(NSString*)strDataToPost:(int)iCurrentOrderId;

+ (NSString*)postReviewRatings:(NSString*)strDataToPost;

+ (NSString*)SQLServerAPI:(NSString*)urlData:(NSString*)strDataToPost;

+(UIImage *)fetchFooterLogo;

+(NSString*)getImageUrl;



@end
