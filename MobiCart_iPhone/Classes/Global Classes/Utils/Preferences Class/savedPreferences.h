//
//  savedPreferences.h
//  MobiCart
//
//  Created by Mobicart on 21/07/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface savedPreferences : NSObject 
{
	// Titles on View Controllers
	NSString *strTitleHome, *strTitleStore, *strTitleMyAccount, *strTitleNews, *strTitleAboutUs, *strTitleContactUs, *strTitleFaq, *strTitleShoppingCart, *strTitleTerms_Conditions, *strTitlePrivacy, *strTitlePage1, *strTitlePage2, *strHexadecimalColor, *strPriceBackground;
	
	// Color Schemes of Controls
	UIColor *bgColor, *searchBgColor, *headerColor, *priceBackgroundColor, *tableCellTextColor, *navigationColor, *tableCellColor,* subHeaderColor;
	
	// Gradient Colors
	UIColor *bgColor_Gradient, *fgColor_Gradient, *btmScrollColor_Gradient, *priceBackgroundColor_Gradient, *tableCellTextColor_Gradient, *navigationColor_Gradient, *tableCellColor_Gradient;
	
	// App Details
	UIImage *imgLogo;
	NSInteger _iCurrentAppId, _iCurrentStoreId, _iCurrentMerchantId;
	
	// Store data
	NSInteger _iCurrentDeptId, _iCurrentCategoryId,_iCurrentProductId;
	
	// Shopping cart details
	NSInteger iCartItems;
	
	NSString *strCurrency, *strCurrencySymbol;
}

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
@property (nonatomic, retain) NSString *strHexadecimalColor;
@property (nonatomic, retain) NSString *strPriceBackground;

@property (nonatomic, retain) UIColor *bgColor;
@property (nonatomic, retain) UIColor *subHeaderColor;
@property (nonatomic, retain) UIColor *searchBgColor;
@property (nonatomic, retain) UIColor *headerColor;
@property (nonatomic, retain) UIColor *priceBackgroundColor;
@property (nonatomic, retain) UIColor *labelColor;
@property (nonatomic, retain) UIColor *navigationColor;
@property (nonatomic, retain) UIColor *tableCellColor;

@property (nonatomic, retain) UIColor *bgColor_Gradient;
@property (nonatomic, retain) UIColor *fgColor_Gradient;
@property (nonatomic, retain) UIColor *btmScrollColor_Gradient;
@property (nonatomic, retain) UIColor *priceBackgroundColor_Gradient;
@property (nonatomic, retain) UIColor *tableCellTextColor_Gradient;
@property (nonatomic, retain) UIColor *navigationColor_Gradient;
@property (nonatomic, retain) UIColor *tableCellColor_Gradient;

@property (nonatomic, retain) UIImage *imgLogo;

@property (nonatomic, readwrite) NSInteger _iCurrentAppId;
@property (nonatomic, readwrite) NSInteger _iCurrentStoreId;
@property (nonatomic, readwrite) NSInteger _iCurrentMerchantId;

@property (nonatomic, readwrite) NSInteger _iCurrentDeptId;
@property (nonatomic, readwrite) NSInteger _iCurrentCategoryId;
@property (nonatomic, readwrite) NSInteger _iCurrentProductId;

// Shopping cart items
@property(nonatomic, readwrite) NSInteger iCartItems;




@end
