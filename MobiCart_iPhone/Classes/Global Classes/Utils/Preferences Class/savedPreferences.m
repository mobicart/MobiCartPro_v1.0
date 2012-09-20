//
//  savedPreferences.m
//  MobiCart
//
//  Created by Mobicart on 21/07/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import "savedPreferences.h"


@implementation savedPreferences

@synthesize strTitleHome,strTitleStore,strTitleMyAccount,strTitleNews,strTitleAboutUs,strTitleContactUs,strTitleFaq,strTitleShoppingCart,strTitleTerms_Conditions,strTitlePrivacy,strTitlePage1,strTitlePage2,strHexadecimalColor,strPriceBackground;
@synthesize strCurrency,strCurrencySymbol;

// Color Schemes
@synthesize bgColor, searchBgColor, headerColor,subHeaderColor, priceBackgroundColor, labelColor,navigationColor,tableCellColor;
@synthesize bgColor_Gradient, fgColor_Gradient, btmScrollColor_Gradient, priceBackgroundColor_Gradient, tableCellTextColor_Gradient,navigationColor_Gradient,tableCellColor_Gradient;

// App and Merchant Details
@synthesize _iCurrentAppId, _iCurrentStoreId, _iCurrentMerchantId, imgLogo;

// Store Details
@synthesize _iCurrentDeptId,_iCurrentCategoryId,_iCurrentProductId;

// Shopping Cart details
@synthesize iCartItems;


- (void)dealloc
{
	[self.strTitleHome release];
	[self.strTitleStore release];
	[self.strTitleMyAccount release];
	[self.strTitleNews release];
	[self.strTitleAboutUs release];
	[self.strTitleContactUs release];
	[self.strTitleFaq release];
	[self.strTitleShoppingCart release];
	[self.strTitlePrivacy release];
	[self.strTitlePage1 release];
	[self.strTitlePage2 release];
	[self.strCurrency release];
	[self.strCurrencySymbol release];
	[self.strPriceBackground release];
	
	[self.bgColor release];
	[self.searchBgColor release];
	[self.headerColor release];
	[self.priceBackgroundColor release];
	[self.labelColor release];
	[self.navigationColor release];
	[self.tableCellColor release];
	[self.imgLogo release];
	[super dealloc];
}

@end
