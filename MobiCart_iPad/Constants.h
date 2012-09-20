/*
 *  Constants.h
 *  Mobicart
 *
 *  Created by Mobicart on 05/03/11.
 *  Copyright Mobicart. All rights reserved.
 *
 */

#import "MobicartAppDelegate.h"
#import "SBJSON.h"
#import "GlobalPrefrences.h"
#import "savedPreferences.h"


#import "View1.h"
#import "View2.h"
#import "View3.h"
#import "UserDetails.h"
#import "HomeViewController.h"
#import "StoreViewController.h"
#import "MyAccountViewController.h"
#import "NewsViewController.h"
#import "AboutUsViewController.h"
#import "ContactUsViewController.h"
#import "TermsViewController.h"
#import "ProductDetails.h"
#import "ShoppingCartViewController.h"
#import "StockCalculation.h"
#import "CheckoutViewController.h"
#import "TableViewCell_Common.h"
#import "GlobalPrefrences.h"
#import "PrivacyViewController.h"
#import "Page1ViewController.h"
#import "Page2ViewController.h"
#import "SegmentControl_Customized.h"
#import "SqlQuery.h"
#import "MobiCartWebView.h"
#import "ServerAPI.h"

#define iNumOfItemsInShoppingCart _savedPreferences.iCartItems

savedPreferences *_savedPreferences;
//**********Global Preferences ***********/
#pragma mark Global Preferences 
#define iCurrentAppId _savedPreferences._iCurrentAppId 
#define iCurrentStoreId _savedPreferences._iCurrentStoreId 
#define iCurrentMerchantId _savedPreferences._iCurrentMerchantId 


#pragma mark Store
#define iCurrentCategoryId _savedPreferences._iCurrentCategoryId
#define iCurrentDepartmentId _savedPreferences._iCurrentDeptId
#define iCurrentProductId _savedPreferences._iCurrentProductId


#define jsonDepartments_FileName @"/departments.json"
#define jsonCategories_FileName @"/categories.json"
#define jsonProducts_FileName @"/products.json"
#define jsonDetails_FileName @"/details.json"


#define urlAppFeatures @"app" 
#define urlAppColorPreferences @"encolorscheme.json"
#define urlStore @"store"
#define urlAnalyticsForProductViews @"product"
#pragma mark Color Preferences


#define backGroundColor _savedPreferences.bgColor

#define headingColor _savedPreferences.textheadingColor
#define labelColor _savedPreferences.txtLabelColor
#define subHeadingColor _savedPreferences.fgColor
#define btnTextColor _savedPreferences.fgColor
#define HexVAlueForsubHeadingColor  _savedPreferences.hexcolor
#define HexVAlueForHeadingColor  _savedPreferences.hexHeadingcolor
#define HexVAlueForLabelColor  _savedPreferences.hexLabelcolor


