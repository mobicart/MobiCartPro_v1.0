//
//  savedPreferences.h
//  MobiCart
//
//  Created by Mobicart on 21/07/10.
//  Copyright Mobicart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface savedPreferences : NSObject {
	
	//Titles on View Controllers
	NSString *strTitleHome,*hexcolor,*hexHeadingcolor, *strTitleStore, *strTitleMyAccount, *strTitleNews, *strTitleAboutUs, *strTitleContactUs, *strTitleFaq, *strTitleShoppingCart, *strTitleTerms_Conditions, *strTitlePrivacy, *strTitlePage1, *strTitlePage2;
	
	//Color Schemes of Controls
	UIColor *bgColor, *fgColor, *textheadingColor,*txtLabelColor;
	
	//Gradient Colors

	
	//App Details
	UIImage *imgLogo;
	NSInteger _iCurrentAppId, _iCurrentStoreId, _iCurrentMerchantId;
	
	
	//Store data
	NSInteger _iCurrentDeptId, _iCurrentCategoryId,_iCurrentProductId,_iNextDeptId;
	
	
	//Shopping cart details
	NSInteger iCartItems;
	
	NSString *strCurrency, *strCurrencySymbol;
	
}
@property (nonatomic, retain) NSString *hexcolor;
@property (nonatomic, retain) NSString *hexHeadingcolor;
@property (nonatomic, retain) NSString *hexLabelcolor;
@property (nonatomic, retain) NSString *strTitleHome;
@property (nonatomic, retain) NSString *strTitleStore;
@property (nonatomic, retain) NSString *strTitleMyAccount;
@property (nonatomic, retain) NSString *strTitleNews;
@property (nonatomic, retain) NSString *strTitleAboutUs;
@property (nonatomic, retain) NSString *strTitleContactUs;
@property (nonatomic, retain) NSString *strTitleFaq;
@property (nonatomic, retain) NSString *strTitleShoppingCart;
@property (nonatomic, retain) NSString *strTitleTerms_Conditions;
@property (nonatomic, retain) NSString *strTitlePrivacy;
@property (nonatomic, retain) NSString *strTitlePage1;
@property (nonatomic, retain) NSString *strTitlePage2;
@property (nonatomic, retain) NSString *strCurrency;
@property (nonatomic, retain) NSString *strCurrencySymbol;

@property (nonatomic, retain) UIColor *bgColor;
@property (nonatomic, retain) UIColor *fgColor;
@property (nonatomic, retain) UIColor *txtLabelColor;
@property (nonatomic, retain) UIColor *textheadingColor;

@property (nonatomic, retain) UIImage *imgLogo;

@property (nonatomic, readwrite) NSInteger _iCurrentAppId;
@property (nonatomic, readwrite) NSInteger _iCurrentStoreId;
@property (nonatomic, readwrite) NSInteger _iCurrentMerchantId;

@property (nonatomic, readwrite) NSInteger _iCurrentDeptId;
@property (nonatomic, readwrite) NSInteger _iCurrentCategoryId;
@property (nonatomic, readwrite) NSInteger _iCurrentProductId;

@property (nonatomic, readwrite) NSInteger _iNextDeptId;

//Shopping cart items
@property(nonatomic, readwrite) NSInteger iCartItems;




@end
