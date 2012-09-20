//
//  Constants.h
//  MobiCart
//
//  Created by Mobicart on 7/7/10.
//  Copyright 2010 Mobicart. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "NewsDetail.h"
#import "MobicartAppAppDelegate.h"
#import "HomeViewController.h"
#import "StoreViewController.h"
#import "MyAccountViewController.h"
#import "NewsViewController.h"
#import "AboutUsViewController.h"
#import "ContactUsViewController.h"
#import "TermsViewController.h"
#import "ShoppingCartViewController.h"
#import "ShoppingCartViewController.h"
#import "CategoryViewController.h"
#import "ProductViewController.h"
#import "ProductDetailsViewController.h"
#import "DetailsViewController.h"
#import "CheckoutViewController.h"
#import "TableViewCell_Common.h"
#import "GlobalPreferences.h"
#import "savedPreferences.h"
#import "SingletonLocation.h"


#import "PrivacyViewController.h"
#import "Page1ViewController.h"
#import "Page2ViewController.h"

#import "CustomSegmentControl.h"


#import "CustomLoadingIndicator.h"
#import "MobiCartWebView.h"
#import "TwitterDetail.h"

#import "ReadReviewsViewController.h"
#import "PostReviewsViewController.h"


#import "MobiCartStart.h"
#import "SqlQuery.h"
#import "ServerAPI.h"

//Inbuilt Frameworks' classes
#import <QuartzCore/QuartzCore.h>

//JSON 
#import "SBJSON.h"

//For Global Serach
#import "GlobalSearchViewController.h"

//MultiColor String 
#import "FontLabel.h"
#import "FontLabelStringDrawing.h"
#import "FontManager.h"

//XML Parser 
#import "CustomMobicartParser.h"
savedPreferences *_savedPreferences;
@protocol Constants



#define merchantEmailId [GlobalPreferences getMerchantEmailId]

#define urlAppFeatures @"app"  
//#define urlAppColorPreferences @"colorscheme.json" 

//**********Global Preferences ***********/
#pragma mark Global Preferences 
#define iCurrentAppId _savedPreferences._iCurrentAppId 
#define iCurrentStoreId _savedPreferences._iCurrentStoreId 
#define iCurrentMerchantId _savedPreferences._iCurrentMerchantId 

//********** Color Preferences ***********/
#pragma mark Color Preferences 
#define navBarColor _savedPreferences.navigationColor

#define lblColor [UIColor blueColor]

#define cellTextColor _savedPreferences.;

#define cellBackColor [UIColor clearColor];

#define lblFont [UIFont fontWithName:@"Arial" size:18];

#define iNumOfItemsInShoppingCart _savedPreferences.iCartItems

#define UISegment_OnColor [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1]

#define UISegment_OffColor [UIColor colorWithRed:(136/255.0) green:(136/255.0) blue:(136/255.0) alpha:1]

//*******Store *********
#pragma mark Store
#define iCurrentCategoryId _savedPreferences._iCurrentCategoryId
#define iCurrentDepartmentId _savedPreferences._iCurrentDeptId
#define iCurrentProductId _savedPreferences._iCurrentProductId

#define jsonDepartments_FileName @"/departments.json"
#define jsonCategories_FileName @"/categories.json"
#define jsonProducts_FileName @"/products.json"
#define jsonDetails_FileName @"/details.json"

#define urlStore @"store"

#define urlAnalyticsForProductViews @"product"

#pragma mark ------ Shopping Cart 

#define iNumOfItemsInShoppingCart _savedPreferences.iCartItems

@end





