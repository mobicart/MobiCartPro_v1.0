//
//  savedPreferences.m
//  MobiCart
//
//  Created by Mobicart on 21/07/10.
//  Copyright Mobicart. All rights reserved.
//

#import "savedPreferences.h"


@implementation savedPreferences

@synthesize strTitleHome,hexcolor,hexHeadingcolor,hexLabelcolor,strTitleStore,strTitleMyAccount,strTitleNews,strTitleAboutUs,strTitleContactUs,strTitleFaq,strTitleShoppingCart,strTitleTerms_Conditions,strTitlePrivacy,strTitlePage1,strTitlePage2;
@synthesize strCurrency,strCurrencySymbol;

//Color Schemes
@synthesize bgColor, fgColor, textheadingColor,txtLabelColor;

//App and Merchant Details
@synthesize _iCurrentAppId, _iCurrentStoreId, _iCurrentMerchantId, imgLogo;

//Store Details
@synthesize _iCurrentDeptId,_iCurrentCategoryId,_iCurrentProductId,_iNextDeptId;

//Shopping Cart details
@synthesize iCartItems;


-(void)dealloc
{
	[self.hexcolor release];
	[self.hexLabelcolor release];
	[self.hexHeadingcolor release];
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
	
	[self.bgColor release];
	[self.fgColor release];
	[self.textheadingColor release];
	[self.txtLabelColor release];
	[self.imgLogo release];
	[super dealloc];
}

@end
