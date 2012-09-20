//
//  ServerAPI.h
//  ServerAPI
//
//  Created by Mobicart on 06/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>//"
#import "SBJSON.h"

@interface ServerAPI : NSObject
{
    
}
//***********************App Seetings*********************************//
+(NSDictionary*)fetchLanguagePreferences:(NSInteger)iCurrentMerchantId;
+(BOOL)isLangUpdated:(NSString *)strTimeStamp:(NSInteger)iCurrentMerchantId;
+(NSDictionary*)getAppStoreUserDetails:(NSString*)merchantemail;     //gives initial details of user and store
+(NSDictionary*)fetchAppFeatures:(NSInteger)iCurrentAppId;   //includes tab bar prefernces also
+(NSDictionary*)fetchAppColorScheme:(NSInteger)iCurrentAppId;       //returns app color seetings
+(NSDictionary*)fetchAppVitals:(NSInteger)iCurrentAppId;           //returns  app vitials
+(NSDictionary*)fetchStaticPages:(NSInteger)iCurrentStoreId;        //return details of static pages in more tab
+(NSDictionary*)fetchMerchantAddress:(NSString*)merchantemail;

//***********************HOME PAGE*********************************//
+(NSDictionary*)fetchSettings:(NSInteger)iCurrentStoreId;     //general app settings
+(NSDictionary*)fetchGallaryImages:(NSInteger)iCurrentStoreId;    //return gallary images(bannred images)
+(NSDictionary*)fetchFeaturedproducts:(int)countryID:(int)stateID:(NSInteger)iCurrentAppId;      //return featured products. pass country and state id to get get tax specific to a country or state
+(NSData *)fetchBannerImage:(NSString *)string;

//***********************store*********************************//
//+(NSDictionary*)fetchAllProductsInStore;         //returns all the products in store irrespective of departments and sub departments
+(NSDictionary*)fetchAllProductsInStore:(int)_countryID stateID:(int)_stateID:(NSInteger)iCurrentStoreId;
+(NSDictionary*)fetchGlobalSearchProducts:(NSString *)productName:(NSInteger)iCurrentAppId;

//***********************News and Twitter*********************************//
+(NSDictionary*)fetchNewsAndTwitter:(NSInteger)iCurrentAppId;
+(NSDictionary *)fetchNewsFromServer:(NSString *)strURL;
+(NSString*)getImageUrl;
+(NSDictionary*)fetchTweets:(NSInteger)iCurrentStoreId;

//***********************Fetch Data from server*********************************//
+(NSDictionary *)fetchDataFromServer:(NSString *)strURL;
+(NSString *) checkoutSendData:(NSURL *)_url withData:(NSString *)strDataToPost;
+(NSString*)product_order_ItemSaveURLSend:(NSString*)strDataToPost;
+(NSString*)product_orderSaveURLSend:(NSString*)strDataToPost;
+(NSString*)product_order_NotifyURLSend:(NSString*)strDataToPost:(int)iCurrentOrderId;
+(NSDictionary*)fetchProductDetails:(int)productId:(int)iCurrentAppId:(int)stateID;
+(NSString*)SQLServerAPI:(NSString*)urlData:(NSString*)strDataToPost;
+(NSString*)postReviewRatings:(NSString*)strDataToPost;
+(NSDictionary*)fetchTaxShippingDetails:(int)countryID:(int)stateID:(NSInteger)iCurrentStoreId;
+(NSData*)fetchBannerImage:(NSString *)strImage;
+(NSDictionary *)fetchDataFromServer:(NSString *)strURL;
+(NSURLRequest *)createTweetImageRequest:(NSString *)url;
+(NSString *)getProductsUrl:(NSInteger)_iCurrentProductId:(NSInteger)iCurrentStoreId:(NSInteger)iCurrentDepartmentId;
+(NSString *)getproductsWithoutCatogeriesUrl:(NSInteger)_iCurrentDepartmentId:(NSInteger)iCurrentStoreId;
+(NSDictionary *)fetchProductsWithCategories:(int)catID:(int)CountryID:(int)StateID:(NSInteger)iCurrentStoreId:(NSInteger)iCurrentDepartmentId;
+(NSDictionary *)fetchProductsWithoutCategories:(int)deptID:(int)CountryID:(int)StateID:(NSInteger)iCurrentStoreId;
+(NSString *)getCategoriesUrl:(NSInteger)_iCurrentDepartmentId:(NSInteger)iCurrentStoreId;
+(NSString *)getDepartmentUrl:(NSInteger)iCurrentStoreId;
+(NSDictionary *)fetchDepartments:(NSInteger)iCurrentStoreId;
+(NSDictionary *)fetchSubDepartments : (NSInteger)deptID:(NSInteger)iCurrentStoreId;
+(UIImage*)setLogoImage:(NSString *)logoUrl:(BOOL)isNull;
+(NSDictionary*)fetchDetailsOfProductWithID:(int)_productID;
+(NSDictionary*) fetchnextfeatureProduct :(int)depId countryId:(int)countryId stateId:(int)stateId:(NSInteger)iCurrentStoreId;
+(NSDictionary*) fetchnextfeatureProductwithcategory :(int)depId catId:(int)Catid countryId:(int)countryId stateId:(int)stateId:(NSInteger)iCurrentStoreId;
+(NSDictionary*)fetchDetailsOfProductWithID:(int)_productID;
+(NSDictionary*)fetchDetailsOfProductWithID:(int)_productID countryID:(int)_country stateID:(int)_state;
+ (NSString *)secureRequest:(NSURL *)url;
+(NSDictionary*)fetchOrderDetails:(NSString *)_userEmail:(NSInteger)iCurrentAppId:(NSInteger)iCurrentStoreId;
+(NSDictionary*)fetchTabbarPreferences:(NSInteger)iCurrentAppId;
+(NSDictionary*)fetchStatesOfCountryWithID:(int)_countryID;
+(void)fetchProductAnalytics:(NSString *)sProductId;
+(NSDictionary*)fetchStatesOfAcountryURL:(NSInteger)_iCountryCode;
+(void)pushNotifications:(NSString*)strLatitude:(NSString*)strLongitude:(NSString*)tokenString:(NSInteger)iCurrentAppId;
+(void)sendDataToServer:(NSString*)_url;
+(UIImage *)fetchFooterLogo;




@end
