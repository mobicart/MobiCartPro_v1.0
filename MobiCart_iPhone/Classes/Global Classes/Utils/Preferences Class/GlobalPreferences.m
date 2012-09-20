//
//  GlobalPreferences.m
//  MobiCart
//
//  Created by Mobicart on 7/7/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import "GlobalPreferences.h"
#import "Constants.h"

@implementation GlobalPreferences
@synthesize navigationBarColor;


static GlobalPreferences *shared;

- (id)init 
{
	if (shared) 
    {
        [self autorelease];
        return shared;
    }
	
	if (![super init])
    {
        return nil;   
    }
	
	shared = self;
	return self;
}

+ (id)shared 
{
    if (!shared) 
    {
        [[GlobalPreferences alloc] init];
    }
    return shared;
}

+(void)setPersonLoginStatus:(BOOL)_status
{
	isLoggedInStatuschanged=_status;   //Yes, if person is logged in else no;
}

+(BOOL)getPersonLoginStatus
{
	return isLoggedInStatuschanged;
}

NSString *strDeviceToken;
#pragma mark Device Token
+(void)setDeviceTokenForNotification:(NSString*)_token
{
	if (!strDeviceToken)
    {
        strDeviceToken=[[NSString alloc]init];
    }	
	strDeviceToken=_token;
}

+(NSString*)getDeviceToken
{
	return strDeviceToken;
}

#pragma mark ----Reachibility Check 
+(BOOL) updateInterfaceWithReachability: (Reachability*) curReach
{
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired= [curReach connectionRequired];
	BOOL connectionStatus = NO;
	
    switch (netStatus)
    {
        case NotReachable:
        {
            connectionRequired = NO;  
			connectionStatus = NO;
            break;
        }
            
        case ReachableViaWWAN:
        {
			connectionStatus = YES;
			break;
        }
        case ReachableViaWiFi:
        {
			connectionStatus = YES;
			break;
		}
    }
	
	return connectionStatus;
}

+(BOOL)isInternetAvailable
{ 
	return ([self updateInterfaceWithReachability:internetReach]);
}
#pragma mark -

SBJSON *_JSONParser;

#pragma mark - Global Initializers
+(void)initializeGlobalControllers
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    // Initializing JSON handler
	if (!_JSONParser)
    {
        _JSONParser = [[SBJSON alloc]init];
    }
			
	// Initializing savedPreferences object
	if (!_savedPreferences) 
    {
        _savedPreferences = [[savedPreferences alloc] init];
    }
			
	// NSOperationQueue for handling Various threads
	if (!queue)
    {
        queue = [[NSOperationQueue alloc] init];
    }
	
	iNumOfItemsInShoppingCart =  [[[SqlQuery shared]getShoppingCartProductIDs:YES] count];
	[pool release];
}


# pragma mark LANGUAGE PREFERENCES
NSDictionary *dictLanguageLabels;

+(void)setLanguageLabels:(NSDictionary *)_dictTemp
{
	
	if (!dictLanguageLabels)
	{
		dictLanguageLabels = [[NSDictionary alloc] init];
	}
	
	dictLanguageLabels = _dictTemp;
	[dictLanguageLabels retain];
}
+(NSDictionary *) getLangaugeLabels
{
	return dictLanguageLabels;
}

#pragma mark -
#pragma mark Tabbar Settings
NSMutableArray *arrSelectedTabs;
NSMutableArray *arrSelectedTitles;

+(void)setTabbarControllers_SelectedByUser:(NSDictionary *)dictFeatures
{
	if (!arrSelectedTabs)
    {
		arrSelectedTabs = [[NSMutableArray alloc] init];
	}
    
	if (!arrSelectedTitles) 
    {
		arrSelectedTitles = [[NSMutableArray alloc] init];
	}
    
	NSArray *arrTemp  = [dictFeatures objectForKey:@"features"];
	for (NSDictionary *dictData in arrTemp)
    {
		[arrSelectedTabs addObject:[dictData objectForKey:@"sIphoneHandle"]];
		[arrSelectedTitles addObject:[dictData objectForKey:@"sName"]];
	}
    
	if ([arrSelectedTitles count]>0)
    {
        [GlobalPreferences setTabbarItemTitles:arrSelectedTitles];
    }
}

+(NSArray *)tabBarControllers_SelectedByUser
{
	// Return ordering of tabbar items, as selected by user from the server
	if ([arrSelectedTabs count]>0)
    {
        return arrSelectedTabs;
    }
	return nil;
}


+(void)setTabbarItemTitles:(NSArray *)arrSelected_Titles
{
	_savedPreferences.strTitleHome = @"";
	_savedPreferences.strTitleStore = @"";
	_savedPreferences.strTitleNews = @"";
	_savedPreferences.strTitleMyAccount = @"";
	_savedPreferences.strTitleAboutUs = @"";
	_savedPreferences.strTitleContactUs = @"";
	_savedPreferences.strTitleFaq = @"";
	_savedPreferences.strTitleShoppingCart = @"";
	_savedPreferences.strTitleTerms_Conditions = @"";
	_savedPreferences.strTitlePrivacy = @"";
	_savedPreferences.strTitlePage1 = @"";
	_savedPreferences.strTitlePage2 = @"";
	
	if ([arrSelected_Titles count]>0) 
    {
		for (int i=0; i<[arrSelected_Titles count]; i++) 
        {
			if ([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"Home"]])
            {
                _savedPreferences.strTitleHome = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.tabbar.home"];
            }
			else if ([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"Store"]])
            {
               _savedPreferences.strTitleStore = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.tabbar.store"];
            }
			else if ([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"News"]])
            {
                 _savedPreferences.strTitleNews = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.tabbar.news"];
            }
			else if ([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"My Account"]])
            {
                _savedPreferences.strTitleMyAccount = @"My Account";
            }
			else if ([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"About Us"]])
            {
                _savedPreferences.strTitleAboutUs = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.more.aboutus"];
            }
			else if ([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"Contact Us"]])
            {
                 _savedPreferences.strTitleContactUs = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.more.contactus"];
            }
			else if ([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"Shopping Cart"]])
            {
                _savedPreferences.strTitleShoppingCart = @"Shopping Cart";
            }
			else if ([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"Terms"]])
            {
                 _savedPreferences.strTitleTerms_Conditions = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.more.tandc"];
            }
			else if ([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"Privacy"]])
            {
				_savedPreferences.strTitlePrivacy = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.more.privacy"];                
            }
			else if ([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"Page 1"]])
            {
                _savedPreferences.strTitlePage1 = @"Page 1";
            }
			else if ([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"Page 2"]])
            {
                _savedPreferences.strTitlePage2 = @"Page 2";
            }
		}
	}
}

+(NSArray *)getAllNavigationTitles
{

	NSArray *arrAllData = [[ServerAPI fetchTabbarPreferences :iCurrentAppId]objectForKey:@"features"];	
    
	// Set Title of "Privacy View Controller"	
	if (![arrAllData isKindOfClass:[NSNull class]])
	{

		for (int i=0;i<[arrAllData count]; i++) 
        {
			NSDictionary *dictTemp = [arrAllData objectAtIndex:i];
			if ([[dictTemp objectForKey:@"sIphoneHandle"]isEqualToString:@"Page1ViewController"])
            {
                _savedPreferences.strTitlePage1 = [dictTemp objectForKey:@"tabTitle"];
            }
            
			if ([[dictTemp objectForKey:@"sIphoneHandle"]isEqualToString:@"Page2ViewController"])
            {
                _savedPreferences.strTitlePage2 = [dictTemp objectForKey:@"tabTitle"];
            }			
		}
		
		if ([arrAllData count] >8) 
		{
			NSDictionary *dictTemp = [arrAllData objectAtIndex:8];
			if ((![[dictTemp objectForKey:@"sTitle"] isEqualToString:@""]) && (![[dictTemp objectForKey:@"sTitle"] isEqual:[NSNull null]]))
			{
				if ([[dictTemp objectForKey:@"sIphoneHandle"]isEqualToString:@"Page1ViewController"])
				{
                    if (!([[dictTemp objectForKey:@"tabTitle"] isEqual:[NSNull null]]))
                    {
                        if (!([[dictTemp objectForKey:@"tabTitle"] isEqualToString:@""]))
                        {
                            _savedPreferences.strTitlePage1 = [dictTemp objectForKey:@"tabTitle"];
                        }
                        else
                        {
                            _savedPreferences.strTitlePage1 = [dictTemp objectForKey:@"sName"];
                        }
                    }
					else
                    {
                        _savedPreferences.strTitlePage1 = [dictTemp objectForKey:@"sName"];
                    }
				}
			}
		}
        
		
		if ([arrAllData count] >9) 
		{
			NSDictionary *dictTemp = [arrAllData objectAtIndex:9];
			if ((![[dictTemp objectForKey:@"sName"] isEqualToString:@""]) && (![[dictTemp objectForKey:@"sName"] isEqual:[NSNull null]]))
			{
				if ([[dictTemp objectForKey:@"sIphoneHandle"]isEqualToString:@"Page2ViewController"])
				{
					if (!([[dictTemp objectForKey:@"tabTitle"] isEqual:[NSNull null]]))
                    {
						if (!([[dictTemp objectForKey:@"tabTitle"] isEqualToString:@""]))
						{
							_savedPreferences.strTitlePage2 = [dictTemp objectForKey:@"tabTitle"];
						}   
						else
						{
							_savedPreferences.strTitlePage2 = [dictTemp objectForKey:@"sName"];
						}
					}
					else
                    {
                        _savedPreferences.strTitlePage2 = [dictTemp objectForKey:@"sName"];
                    }
				}
			}
		}
		
	}
	return ([NSArray arrayWithObjects:_savedPreferences.strTitleHome,_savedPreferences.strTitleStore,_savedPreferences.strTitleNews,_savedPreferences.strTitleMyAccount,_savedPreferences.strTitleAboutUs,_savedPreferences.strTitleContactUs,_savedPreferences.strTitleTerms_Conditions, _savedPreferences.strTitleShoppingCart, _savedPreferences.strTitlePrivacy, _savedPreferences.strTitlePage1, _savedPreferences.strTitlePage2, nil]);
}


#pragma mark - Color Schemes

// This method converts any hexadevmal string into RGB colors
+ (UIColor *) colorWithHexString: (NSString *)stringToConvert  
{  
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];  
	
    // String should be 6 or 8 characters  
    if ([cString length] < 6) return [UIColor redColor];  
	
    // strip 0X if it appears  
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];  
	
    if ([cString length] != 6) return [UIColor redColor];  
	
    // Separate into r, g, b substrings  
    NSRange range;  
    range.location = 0;  
    range.length = 2;  
    NSString *rString = [cString substringWithRange:range];  
	
    range.location = 2;  
    NSString *gString = [cString substringWithRange:range];  
	
    range.location = 4;  
    NSString *bString = [cString substringWithRange:range];  
	
    // Scan values  
    unsigned int r, g, b;  
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  
    [[NSScanner scannerWithString:gString] scanHexInt:&g];  
    [[NSScanner scannerWithString:bString] scanHexInt:&b];  
	
    return [UIColor colorWithRed:((float) r / 255.0f)  
                           green:((float) g / 255.0f)  
                            blue:((float) b / 255.0f)  
                           alpha:1.0f];  
} 

+ (UIColor *) lightColorWithHexString: (NSString *)stringToConvert  
{  
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];  
	
    // String should be 6 or 8 characters  
    if ([cString length] < 6) return [UIColor redColor];  
	
    // strip 0X if it appears  
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];  
	
    if ([cString length] != 6) return [UIColor redColor];  
	
    // Separate into r, g, b substrings  
    NSRange range;  
    range.location = 0;  
    range.length = 2;  
    NSString *rString = [cString substringWithRange:range];  
	
    range.location = 2;  
    NSString *gString = [cString substringWithRange:range];  
	
    range.location = 4;  
    NSString *bString = [cString substringWithRange:range];  
	
    // Scan values  
    unsigned int r, g, b;  
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  
    [[NSScanner scannerWithString:gString] scanHexInt:&g];  
    [[NSScanner scannerWithString:bString] scanHexInt:&b];  
	
    return [UIColor colorWithRed:((float) r / 255.0f)  
                           green:((float) g / 255.0f)  
                            blue:((float) b / 255.0f)  
                           alpha:0.5f];  
} 



+(void)setColorScheme_SelectedByUser:(NSDictionary *)dictFeatures
{
	
    #define colorDict [dictFeatures objectForKey:@"colorscheme"]
	if (![colorDict isEqual:[NSNull null]])
	{
		if ([colorDict objectForKey:@"theme_color"])
		{
			UIColor *bgColor = [GlobalPreferences colorWithHexString:[[dictFeatures objectForKey:@"colorscheme"]objectForKey:@"theme_color"]];
			
			_savedPreferences.bgColor = bgColor;
			navBarColor = _savedPreferences.bgColor;
			
		}
		
		if ([colorDict objectForKey:@"search_bar_bg_color"])
		{			
			if (!([[colorDict objectForKey:@"search_bar_bg_color"] isKindOfClass:[NSNull class]]||[[colorDict objectForKey:@"search_bar_bg_color"] isEqualToString:@""]))
			{
				UIColor *searchBgColor = [GlobalPreferences colorWithHexString:[[dictFeatures objectForKey:@"colorscheme"]objectForKey:@"search_bar_bg_color"]];
				_savedPreferences.searchBgColor = searchBgColor;
				_savedPreferences.strPriceBackground = @"value";
			}
			else {
				_savedPreferences.strPriceBackground = @"null";
			}
		}
        if ([colorDict objectForKey:@"header_color"])
		{
			UIColor *bgColor = [GlobalPreferences colorWithHexString:[[dictFeatures objectForKey:@"colorscheme"]objectForKey:@"header_color"]];
			
			_savedPreferences.headerColor = bgColor;
		}
        
        if ([colorDict objectForKey:@"sub_header_color"])
		{
			//UIColor *bgColor = [GlobalPreferences colorWithHexString:[[dictFeatures objectForKey:@"colorscheme"]objectForKey:@"sub_header_color"]];
			
			_savedPreferences.subHeaderColor = [[dictFeatures objectForKey:@"colorscheme"]objectForKey:@"sub_header_color"];
            
            
            
		}
		if ([colorDict objectForKey:@"label_color"])
		{
			UIColor *bgColor = [GlobalPreferences colorWithHexString:[[dictFeatures objectForKey:@"colorscheme"]objectForKey:@"label_color"]];
			
			_savedPreferences.labelColor = bgColor;
			_savedPreferences.strHexadecimalColor = [[dictFeatures objectForKey:@"colorscheme"]objectForKey:@"label_color"];
		}
	
       
		if (![[colorDict objectForKey:@"sPriceTagBgColor"] isEqual:[NSNull null]])
		{   
            UIColor *priceBackcolor=[GlobalPreferences colorWithHexString:[[dictFeatures objectForKey:@"colorscheme"]objectForKey:@"sPriceTagBgColor"]];
			_savedPreferences.priceBackgroundColor = priceBackcolor;
		}
	
	}
	
}


#pragma mark Gradient Effect
+(void)setGradientEffectOnView:(UIView *)view:(UIColor *)mainColor:(UIColor *)secondaryColor
{ 
	CAGradientLayer *gradient = [CAGradientLayer layer];
	if (([view isKindOfClass:[UITableViewCell class]]) || ([view isKindOfClass:[UILabel class]]))
    {
        gradient.frame = CGRectMake(0, 0, view.frame.size.width, 100);
    }
		
	else 
    {
		gradient.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
	}
	
	gradient.colors = [NSArray arrayWithObjects:(id)[mainColor CGColor], (id)[secondaryColor CGColor],(id)[secondaryColor CGColor], nil];
	view.layer.masksToBounds = YES;
	[view.layer insertSublayer:gradient atIndex:0];
	
}

#pragma mark -
int userCountryID=0;
int userStateID=0;

#pragma mark Search Bar Default Settings
+(void)setSearchBarDefaultSettings:(UISearchBar *)_searchBar
{
	if ([_savedPreferences.strPriceBackground isEqualToString:@"null"]) {
		[_searchBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"searchback.png"]]];
	}
	else {
		[_searchBar setBackgroundColor:_savedPreferences.searchBgColor];
	}

  
	NSString *str = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.common.search"];
	[_searchBar setPlaceholder:str];
	[_searchBar setTranslucent:YES];
   	[[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
    
  
    
}

#pragma mark -
UINavigationController *moreNavBar;
+(void)setMoreViewController: (UINavigationController *)_navBar
{
	moreNavBar = _navBar;
}

+(UINavigationController *)getMoreNavBar
{
	return moreNavBar;
}


// Set current navigation controll

UINavigationController *currentNavigationController;
+(void)setCurrentNavigationController: (UINavigationController *)_navigationController
{
	currentNavigationController = _navigationController;
}

+(UINavigationController *)getCurrentNavigationController
{
	return currentNavigationController;
}


#pragma mark ----- Home ------

BOOL isClickedOnFeaturedImage;
+(void)setIsClickedOnFeaturedImage:(BOOL)_isClicked
{
	isClickedOnFeaturedImage = _isClicked;
	
}
+(BOOL) isClickedOnFeaturedProductFromHomeTab
{
	return isClickedOnFeaturedImage;
}

BOOL _canPopToRootViewController;
+(BOOL)canPopToRootViewController
{
	return (_canPopToRootViewController);
}


+(void)setCanPopToRootViewController:(BOOL) _canPop
{
	_canPopToRootViewController = _canPop;
}
#pragma mark ----- Store -----

// ******** Setters ********
+(void)setCurrentDepartmentId:(NSInteger )_iCurrentDepartmentId
{
	_savedPreferences._iCurrentDeptId = _iCurrentDepartmentId;
}

+(void)setCurrentCategoryId:(NSInteger )_iCurrentCategoryId
{
	_savedPreferences._iCurrentCategoryId = _iCurrentCategoryId;
}

+(void)setCurrentProductId:(NSInteger )_iCurrentProductId
{
	_savedPreferences._iCurrentProductId = _iCurrentProductId;
}


// Selected for Featured product

NSDictionary *dictCurrentFeaturedProduct;
NSDictionary *dicAppVitals;

+(void)setAppVitalsAndCountries:(NSDictionary*)_dicVitals
{
	if (!dicAppVitals)
	{
		dicAppVitals = [[NSDictionary alloc] init];
	}
	
	dicAppVitals = _dicVitals;
	[dicAppVitals retain];
}

+(void)setCurrentFeaturedProductDetails:(NSDictionary *)_dictTemp
{
	
	if (!dictCurrentFeaturedProduct)
	{
		dictCurrentFeaturedProduct = [[NSDictionary alloc] init];
	}
	
	dictCurrentFeaturedProduct = _dictTemp;
	[dictCurrentFeaturedProduct retain];
}

// Current Selected Product Details

NSDictionary *dictCurrentProduct;

+(void)setCurrentProductDetails:(NSDictionary *)_dictTemp
{
	if (!dictCurrentProduct)
	{
		dictCurrentProduct = [[NSDictionary alloc] init];
	}
	dictCurrentProduct = _dictTemp;
}

// Return details of current selected Featured product
+(NSDictionary *) getCurrentFeaturedDetails
{
	return dictCurrentFeaturedProduct;
}

+(NSDictionary *) getAppVitals
{
	return dicAppVitals;
}

// Return details of current selected product
+(NSDictionary *) getCurrentProductDetails
{
	return dictCurrentProduct;
}

#pragma mark ------ Shopping Cart -----
+(float) getRoundedOffValue:(float)_num
{
	NSDecimalNumber *testNumber = [NSDecimalNumber numberWithFloat:_num];
	NSDecimalNumberHandler *roundingStyle = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
	NSDecimalNumber *roundedNumber = [testNumber decimalNumberByRoundingAccordingToBehavior:roundingStyle];
	NSString *stringValue = [roundedNumber descriptionWithLocale:[NSLocale currentLocale]];
	float finalValue=[stringValue floatValue];
	return finalValue;
}

+(BOOL) validateEmail: (NSString *) candidate 
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:candidate];
}

+(void)setCurrentItemsInCart:(BOOL)added
{
	if (added)
    {
        iNumOfItemsInShoppingCart += 1;
    }
	else
	{
		if (iNumOfItemsInShoppingCart>0)
        {
            iNumOfItemsInShoppingCart -=1;
        }
		
		
		
	}
}

+(NSInteger)getCurrenItemsInCart
{
	return iNumOfItemsInShoppingCart;
}

+(void)setUserDefault_Preferences:(NSString *)value :(NSString *)key
{
	[[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
}

+(NSString *)getUserDefault_Preferences:(NSString *)forKey
{
	return [[NSUserDefaults standardUserDefaults] valueForKey:forKey];
}

// Navigate to the Shopping cart
+(void)goToShoppingCart:(UINavigationController *)_currentNavController
{
	ShoppingCartViewController *_shopping = [[ShoppingCartViewController alloc] init];
	[_currentNavController pushViewController:_shopping animated:YES];
	[_shopping release];
}

+(void)setShadowOnView:(UIView *)_view:(UIColor *)_shadowColor:(BOOL)_includeGradient:(UIColor *)mainColor:(UIColor *)secondaryColor
{
	if (_includeGradient) 
    {
		CAGradientLayer *gradient = [CAGradientLayer layer];
		if (([_view isKindOfClass:[UITableViewCell class]]) || ([_view isKindOfClass:[UILabel class]]))
        {
            gradient.frame = CGRectMake(0, 0, _view.frame.size.width, 70);
        }
		else 
        {
			gradient.frame = CGRectMake(0, 0, _view.frame.size.width, _view.frame.size.height);
        }
		
		gradient.colors = [NSArray arrayWithObjects:(id)[mainColor CGColor], (id)[secondaryColor CGColor], nil];
		
		if ([GlobalPreferences getCurrentDevice4])
		{
			gradient.shadowColor = _shadowColor.CGColor;
			gradient.shadowOpacity = 2.0;
			gradient.shadowRadius = 3.0;
			gradient.shadowOffset = CGSizeMake(0, 3);
		}
		[_view.layer insertSublayer:gradient atIndex:0];
	}
	else
	{
		if ([GlobalPreferences getCurrentDevice4])
		{
			_view.layer.shadowColor = _shadowColor.CGColor;
			_view.layer.shadowOpacity = 2.0;
			_view.layer.shadowRadius = 3.0;
			_view.layer.shadowOffset = CGSizeMake(0, 3);
		}
	}
}

#pragma mark -  Logo Nav Bar
+ (UIImageView*)createLogoImage
{
	UIImageView *imgViewLogo=[[UIImageView alloc]initWithFrame:CGRectMake(104, 7, 110, 30)];
	[imgViewLogo setImage:_savedPreferences.imgLogo];
	[imgViewLogo setContentMode:UIViewContentModeScaleAspectFit];
	return imgViewLogo;
}


#pragma mark User Settings And Tax Details 
NSDictionary *dictUserSettings;

// Set the dictionary of the setting (like Country's tax type, ta charges, user email address, currency type, shopping list details, etc)
+(void)setSettingsOfUserAndOtherDetails:(NSDictionary *)_dictSettings
{
	if (!dictUserSettings)
    {
        dictUserSettings = [[NSDictionary alloc] init];
    }
		if(_dictSettings==nil)
            _dictSettings=[ServerAPI fetchSettings:iCurrentStoreId];
	dictUserSettings = _dictSettings;
	
	[dictUserSettings retain];
	
	_savedPreferences.strCurrency = [[dictUserSettings valueForKey:@"store"] valueForKey:@"sCurrency"];
    [_savedPreferences.strCurrency retain];

	if ((_savedPreferences.strCurrency==nil)||([_savedPreferences.strCurrency isKindOfClass:[NSNull class]]))
	{	
		_savedPreferences.strCurrency=@"";
	}
	
	if (!_dictSettings)
    {
        _savedPreferences.strCurrency=@"";
    }
	
	[GlobalPreferences setCurrencySymbol];
}

NSString *strMerchantCountry;
int iMerchantCountryID;

+ (void)setUserCountryAndStateForTax_country:(NSString*)_country countryID:(int)countryID
{
	if (!strMerchantCountry)
    {
        strMerchantCountry=[[NSString alloc]init];
    }
	strMerchantCountry=_country;
	iMerchantCountryID=countryID;
}

+ (NSString*)getUserCountryFortax
{
	return strMerchantCountry;
}

+ (int)getUserCountryID
{
	return iMerchantCountryID;
}

+ (NSDictionary *)getSettingsOfUserAndOtherDetails
{
	return dictUserSettings;
}

+ (void)setCurrencySymbol
{
    
	NSString *strCode =@"";
  
	if ([_savedPreferences.strCurrency length]>=3)
    {
        strCode=  [_savedPreferences.strCurrency substringFromIndex:3];
    }
		
	if ([strCode isEqualToString:@"USD"])
    {
        _savedPreferences.strCurrencySymbol = @"$";
    }
	else if ([strCode isEqualToString:@"EUR"])
    {
        _savedPreferences.strCurrencySymbol = @"€";
    }
	else if ([strCode isEqualToString:@"GBP"])
    {
        _savedPreferences.strCurrencySymbol = @"£";
    }
	else
	{
		if (strCode==nil)
        {
            _savedPreferences.strCurrencySymbol = @"";
        }
		else
        {
            _savedPreferences.strCurrencySymbol = strCode;
        }
	}	
	if (!strCode)
    {
        _savedPreferences.strCurrencySymbol=@"";
    }
}

#pragma mark - NSOperationQueue Handler

+ (void)addToOpertaionQueue:(NSInvocationOperation *) _opertion
{
	if (!queue)
    {
        queue = [[NSOperationQueue alloc] init];
    }
	
	[queue addOperation:_opertion];	
}

CustomLoadingIndicator *_loadingIndicator;

#pragma mark - Loading Indicator
+ (void)addLoadingIndicator_OnView:(UIView *)_view
{
	// Shared object of Loading Indicator
	_loadingIndicator = [[CustomLoadingIndicator shared] initLoadingIndicator_WithFrame:CGRectMake(210, 2, 20, 20) onView:_view];
	
	if (isNewsSection)
    {
        _loadingIndicator.frame = CGRectMake(150, 200, 20, 20);
    }
	else
    {
        _loadingIndicator.frame = CGRectMake(160, 2, 20, 20);
    }
}

+ (void)stopLoadingIndicator
{
	if (_loadingIndicator)
    {
		if ([_loadingIndicator isAnimating])
        {
            [_loadingIndicator stopLoadingIndicator];
        }
	}
}

+ (void) startLoadingIndicator
{
	if (_loadingIndicator)
    {
		if (![_loadingIndicator isAnimating])
        {
            [_loadingIndicator startLoadingIndicator];
        }
	}
}

UIActionSheet *loadingActionSheet;

#pragma mark - Loading Bar At Bottom

+(void)addLoadingBar_AtBottom:(UIView *)showInView withTextToDisplay:(NSString *)strText
{
	if (loadingActionSheet) 
	{
		[loadingActionSheet release];
		loadingActionSheet = nil;
	}
	loadingActionSheet = [[UIActionSheet alloc] initWithTitle:strText delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	[loadingActionSheet showInView:showInView];
}

+(void)dismissLoadingBar_AtBottom
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if (loadingActionSheet)
    {
      [loadingActionSheet dismissWithClickedButtonIndex:0 animated:YES];
     }
		
	[pool release];
}

#pragma mark - Current Shopping Cart Num 
NSInteger iCurrentShoppingCartNum;
+(void) setCurrentShoppingCartNum:(NSInteger)_num
{
	iCurrentShoppingCartNum = _num;
}

+(NSInteger) getCurrentShoppingCartNum
{
	return iCurrentShoppingCartNum;
}

#pragma mark - Current Device Version

BOOL isDevice4;
+(void) setCurrentDevice4:(BOOL) _device4
{
	isDevice4 = _device4;
}

+(BOOL) getCurrentDevice4
{
	return isDevice4;
}

#pragma mark - More Navigation Controller Settings

BOOL isFooterLogoDisplaying;
+(void) setMoreNavigationConroller_Footer:(BOOL)isShowing
{
	isFooterLogoDisplaying = isShowing;
}
+(BOOL) isShowingFooterLogo_OnMoreNavigationController
{
	return isFooterLogoDisplaying;
	
}

#pragma mark - For Public APIs
NSString *strMerchantEmailID = nil;
+(void) setMerchantEmailID:(NSString *)_merchantEmail
{
	strMerchantEmailID = _merchantEmail;
	[strMerchantEmailID retain];
}
+(NSString *) getMerchantEmailId
{
	return strMerchantEmailID;
}

NSString *PAYPAL_LIVE_TOKEN_ID = nil;

+(void) setPaypal_Live_Token:(NSString *)_paypalToken
{
	PAYPAL_LIVE_TOKEN_ID = _paypalToken;
    [PAYPAL_LIVE_TOKEN_ID retain];
}
+(NSString *) getPaypalLiveToken
{
	return PAYPAL_LIVE_TOKEN_ID;
}

NSString *PAYPAL_SANDBOX_Email = nil;

+(void) setPaypal_Sandbox_Recipient_Email:(NSString *)_sandBoxEmailAccount
{
	PAYPAL_SANDBOX_Email = [_sandBoxEmailAccount copy];
}
+(NSString *) getPaypal_Sandbox_Recipient_Email
{
	return PAYPAL_SANDBOX_Email;
}

NSString *ISAPPTOKENLIVE;

+(void) setPaypal_TOKEN_CHECK:(NSString *)_paypalToken
{
	ISAPPTOKENLIVE = [_paypalToken copy];
}
+(NSString *) getPaypal_TOKEN_CHECK
{
  	return ISAPPTOKENLIVE;
}

NSString *SECRETKEY;

+(void) setMerchant_Secret_Key:(NSString *)_secretKey
{
	SECRETKEY = [_secretKey copy];
}
+(NSString *) getMerchant_Secret_Key
{
	return SECRETKEY;
}

@end