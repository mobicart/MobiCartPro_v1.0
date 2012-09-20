//
//  GlobalPrefrences.m
//  Mobicart
//
//  Created by Mobicart on 05/03/11.
//  Copyright Mobicart. All rights reserved.
//

#import "GlobalPrefrences.h"
#import "Constants.h"

@implementation GlobalPrefrences
static GlobalPrefrences *shared;

- (id)init {
	if (shared) {
        [self autorelease];
        return shared;
    }
	
	if (![super init]) return nil;
	
	shared = self;
	return self;
}

+ (id)shared {
    if (!shared) {
        [[GlobalPrefrences alloc] init];
    }
    return shared;
}

SBJSON *_JSONParser;


+(void)setPersonLoginStatus:(BOOL)_status
{
	isLoggedInStatuschanged=_status;   //Yes, if person is logged in else no;
}
+(BOOL)getPersonLoginStatus
{
	return isLoggedInStatuschanged;
}




#pragma mark Initilize GlobalPrefrences
+(void)initializeGlobalControllers
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//initializing JSON handler
	if(!_JSONParser)
		_JSONParser = [[SBJSON alloc]init];
	
	//initializing savedPreferences object
	if (!_savedPreferences) 
		_savedPreferences = [[savedPreferences alloc] init];
	
	if(!queue)
		queue = [[NSOperationQueue alloc] init] ;
	iNumOfItemsInShoppingCart =  [[[SqlQuery shared]getShoppingCartProductIDs:YES] count];
	[pool release];
}
+(void)setGlobalPreferences
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	//fetch the number of items in the shopping cart, and then set it on the global accesors
	iNumOfItemsInShoppingCart = [[[SqlQuery shared]getShoppingCartProductIDs:YES] count];
	
	[pool release];
}

#pragma mark Tabbar Settings
NSMutableArray *arrSelectedTabs;
NSMutableArray *arrSelectedTitles;

+(void)setBackgroundTheme_OnView:(UIView*)setInView
{
	UIImageView	*bookBackGround=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 699)];
	[bookBackGround setImage:[UIImage imageNamed:@"book.png"]];
	bookBackGround.backgroundColor = backGroundColor;
	[setInView addSubview:bookBackGround];
}




+(void)setTabbarControllers_SelectedByUser:(NSDictionary *)dictFeatures
{
	if (!arrSelectedTabs) {
		arrSelectedTabs = [[NSMutableArray alloc] init];
	}
	if (!arrSelectedTitles) {
		arrSelectedTitles = [[NSMutableArray alloc] init];
	}
	NSArray *arrTemp  = [dictFeatures objectForKey:@"features"];
	for (NSDictionary *dictData in arrTemp) {
		[arrSelectedTabs addObject:[dictData objectForKey:@"sIphoneHandle"]];
		[arrSelectedTitles addObject:[dictData objectForKey:@"sName"]];
	}
	if([arrSelectedTitles count]>0) 
		[GlobalPrefrences setTabbarItemTitles:arrSelectedTitles];
}
+(void)setTabbarItemTitles:(NSArray *)arrSelected_Titles
{
	_savedPreferences.strTitleHome = @"";
	_savedPreferences.strTitleStore= @"";
	_savedPreferences.strTitleNews = @"";
	_savedPreferences.strTitleMyAccount = @"";
	_savedPreferences.strTitleAboutUs = @"";
	_savedPreferences.strTitleContactUs = @"";
	_savedPreferences.strTitleFaq=@"";
	_savedPreferences.strTitleShoppingCart=@"";
	_savedPreferences.strTitleTerms_Conditions=@"";
	_savedPreferences.strTitlePrivacy=@"";
	_savedPreferences.strTitlePage1=@"";
	_savedPreferences.strTitlePage2=@"";
    
	
	if ([arrSelected_Titles count]>0) {
		
		for (int i=0; i<[arrSelected_Titles count]; i++) {
			
			if([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"Home"]])
			{
				_savedPreferences.strTitleHome = [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.tabbar.home"];
			}
			else if([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"Store"]])
			{
				_savedPreferences.strTitleStore = [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.tabbar.store"];
			}
			else if([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"News"]])
			{
				_savedPreferences.strTitleNews = [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.tabbar.news"];
			}
			else if([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"My Account"]])
			{
				_savedPreferences.strTitleMyAccount = @"My Account";
			}
			else if([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"About Us"]])
			{
				_savedPreferences.strTitleAboutUs = [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.more.aboutus"];
			}
			else if([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"Contact Us"]])
			{
				 _savedPreferences.strTitleContactUs = [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.more.contactus"];
			}
			else if([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"Shopping Cart"]])
			{
				_savedPreferences.strTitleShoppingCart = @"Shopping Cart";
			}
			else if([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"Terms"]])
			{
				 _savedPreferences.strTitleTerms_Conditions = [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.more.tandc"];
			}
			else if([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"Privacy"]])
			{
				_savedPreferences.strTitlePrivacy = [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.more.privacy"];
			}
			else if([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"Page 1"]])
			{
				_savedPreferences.strTitlePage1 = @"Page 1";
			}
			else if([[arrSelected_Titles objectAtIndex:i] isEqual:[NSString stringWithString:@"Page 2"]])
			{
				_savedPreferences.strTitlePage2 = @"Page 2";
			}
			
		}
	}
	
}
+(NSArray *)tabBarControllers_SelectedByUser
{
	//return ordering of tabbar items, as selected by user from the server
	if([arrSelectedTabs count]>0)
		return arrSelectedTabs;
	return nil;
}
+(NSArray *)getAllNavigationTitles
{
	
	NSArray *arrAllData = [[ServerAPI fetchTabbarPreferences:iCurrentAppId]objectForKey:@"features"];
	
	//Set title of "Privacy View Controller"	
	
	if(![arrAllData isKindOfClass:[NSNull class]])
	{
				
		for (int i=0;i<[arrAllData count]; i++) {
			NSDictionary *dictTemp = [arrAllData objectAtIndex:i];
			if([[dictTemp objectForKey:@"sIphoneHandle"]isEqualToString:@"Page1ViewController"])
				_savedPreferences.strTitlePage1 = [dictTemp objectForKey:@"tabTitle"];
            
			if([[dictTemp objectForKey:@"sIphoneHandle"]isEqualToString:@"Page2ViewController"])
				_savedPreferences.strTitlePage2 = [dictTemp objectForKey:@"tabTitle"];
			
		}
		
		
		//Set title of "Page 1 View Controller"	
		
 
		if ([arrAllData count] >8) 
		{
			NSDictionary *dictTemp = [arrAllData objectAtIndex:8];
			if ((![[dictTemp objectForKey:@"sTitle"] isEqualToString:@""]) && (![[dictTemp objectForKey:@"sTitle"] isEqual:[NSNull null]]))
			{
				if([[dictTemp objectForKey:@"sIphoneHandle"]isEqualToString:@"Page1ViewController"])
				{
					if ((![[dictTemp objectForKey:@"tabTitle"] isEqual:[NSNull null]]))
					{
						if (![[dictTemp objectForKey:@"tabTitle"] isEqualToString:@""])
						{
						_savedPreferences.strTitlePage1 = [dictTemp objectForKey:@"tabTitle"];
						}
						else
							_savedPreferences.strTitlePage1 = [dictTemp objectForKey:@"sName"];
					}
					else
				        _savedPreferences.strTitlePage1 = [dictTemp objectForKey:@"sName"];
				}
			}
		}
		//Set title of "Page 2 View Controller"	
		
		if ([arrAllData count] >9) 
		{
			NSDictionary *dictTemp = [arrAllData objectAtIndex:9];
			if ((![[dictTemp objectForKey:@"sName"] isEqualToString:@""]) && (![[dictTemp objectForKey:@"sName"] isEqual:[NSNull null]]))
			{
				if([[dictTemp objectForKey:@"sIphoneHandle"]isEqualToString:@"Page2ViewController"])
				{
					if (![[dictTemp objectForKey:@"tabTitle"] isEqual:[NSNull null]])
						{
							if(![[dictTemp objectForKey:@"tabTitle"] isEqualToString:@""])
							{
						
						     _savedPreferences.strTitlePage2 = [dictTemp objectForKey:@"tabTitle"];
							}
							else
								_savedPreferences.strTitlePage2 = [dictTemp objectForKey:@"sName"];
						}
					else
				        _savedPreferences.strTitlePage2 = [dictTemp objectForKey:@"sName"];
				}
			}
		}
		
	}
	return ([NSArray arrayWithObjects:_savedPreferences.strTitleHome,_savedPreferences.strTitleStore,_savedPreferences.strTitleNews,_savedPreferences.strTitleMyAccount,_savedPreferences.strTitleAboutUs,_savedPreferences.strTitleContactUs,_savedPreferences.strTitleTerms_Conditions, _savedPreferences.strTitleShoppingCart, _savedPreferences.strTitlePrivacy, _savedPreferences.strTitlePage1, _savedPreferences.strTitlePage2, nil]);
}

#pragma mark - NSOperationQueue Handler

+(void)addToOpertaionQueue:(NSInvocationOperation *) _opertion
{
	
	if(!queue)
		queue = [[NSOperationQueue alloc] init];
	
	[queue addOperation:_opertion];	
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

+(void)setColorScheme_SelectedByUser:(NSDictionary *)dictFeatures
{
	
#define colorDict [dictFeatures objectForKey:@"colorscheme"]
	
	if(![colorDict isEqual:[NSNull null]])
	{
		if(![[colorDict objectForKey:@"theme_color"] isEqual:[NSNull null]])
		{
			UIColor *bgColor = [GlobalPrefrences colorWithHexString:[[dictFeatures objectForKey:@"colorscheme"]objectForKey:@"theme_color"]];
			
			_savedPreferences.bgColor = bgColor;
			backGroundColor = _savedPreferences.bgColor;
		}		
		
		if(![[colorDict objectForKey:@"sub_header_color"] isEqual:[NSNull null]])
		{
			UIColor *fgColor = [GlobalPrefrences colorWithHexString:[[dictFeatures objectForKey:@"colorscheme"]objectForKey:@"sub_header_color"]];
			_savedPreferences.fgColor = fgColor;
			subHeadingColor=_savedPreferences.fgColor;
			_savedPreferences.hexcolor = [[dictFeatures objectForKey:@"colorscheme"]objectForKey:@"sub_header_color"];
			HexVAlueForsubHeadingColor = _savedPreferences.hexcolor;
		}
		
		if(![[colorDict objectForKey:@"header_color"] isEqual:[NSNull null]])
		{
			UIColor *textColor = [GlobalPrefrences colorWithHexString:[[dictFeatures objectForKey:@"colorscheme"]objectForKey:@"header_color"]];
			_savedPreferences.textheadingColor = textColor;
			headingColor=_savedPreferences.textheadingColor;
			_savedPreferences.hexHeadingcolor = [[dictFeatures objectForKey:@"colorscheme"]objectForKey:@"header_color"];
			HexVAlueForHeadingColor = _savedPreferences.hexHeadingcolor;
		}
		
		if(![[colorDict objectForKey:@"label_color"] isEqual:[NSNull null]])
		{
			UIColor *textColor = [GlobalPrefrences colorWithHexString:[[dictFeatures objectForKey:@"colorscheme"]objectForKey:@"label_color"]];
			_savedPreferences.txtLabelColor=textColor;
           labelColor=_savedPreferences.txtLabelColor;
			_savedPreferences.hexLabelcolor = [[dictFeatures objectForKey:@"colorscheme"]objectForKey:@"label_color"];
			HexVAlueForLabelColor = _savedPreferences.hexLabelcolor;
		}
		
	}
	
}


#pragma mark LANGUAGE PREFERENCES
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



#pragma mark ----- Store -----

// ******** Setters ********

+(void)setNextDepartmentId:(NSInteger )_iNextDepartmentId
{
	_savedPreferences._iNextDeptId = _iNextDepartmentId;
}


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



#pragma mark HOME
BOOL _canPopToRootViewController;
+(BOOL)canPopToRootViewController
{
	return (_canPopToRootViewController);
	
}
BOOL isClickedOnFeaturedImage;
+(void)setIsClickedOnFeaturedImage:(BOOL)_isClicked
{
	isClickedOnFeaturedImage = _isClicked;
	
}
+(BOOL) isClickedOnFeaturedProductFromHomeTab
{
	return isClickedOnFeaturedImage;
}


+(void)setCanPopToRootViewController:(BOOL) _canPop
{
	_canPopToRootViewController = _canPop;
	
}


//Selected for Featured product

#pragma mark -
//Set current navigation controll
UINavigationController *currentNavigationController;
+(void)setCurrentNavigationController: (UINavigationController *)_navigationController
{
	currentNavigationController = _navigationController;
}

+(UINavigationController *)getCurrentNavigationController
{
	return currentNavigationController;
}
NSDictionary *dictCurrentFeaturedProduct;

NSDictionary *dictNextFeaturedProduct;
NSDictionary *dicAppVitals;


+(void)setAppVitalsAndCountries:(NSDictionary*)_dicVitals
{
	if(!dicAppVitals)
	{
		dicAppVitals = [[NSDictionary alloc] init];
	}
	
	dicAppVitals = _dicVitals;
	[dicAppVitals retain];
	
}

+(void)setCurrentFeaturedProductDetails:(NSDictionary *)_dictTemp
{
	
	if(!dictCurrentFeaturedProduct)
	{
		dictCurrentFeaturedProduct = [[NSDictionary alloc] init];
	}
	
	dictCurrentFeaturedProduct = _dictTemp;
	[dictCurrentFeaturedProduct retain];
}

+(void)setNextProductDetails:(NSDictionary *)_dictTemp
{
	
	if(!dictNextFeaturedProduct)
	{
		dictNextFeaturedProduct = [[NSDictionary alloc] init];
	}
	
	dictNextFeaturedProduct = _dictTemp;
	[dictNextFeaturedProduct retain];
}

+(void)setCurrentItemsInCart:(BOOL)added
{
	if(added)
		iNumOfItemsInShoppingCart += 1;
	else
	{
		if (iNumOfItemsInShoppingCart>0) 
			iNumOfItemsInShoppingCart -=1;
	}
}


+(NSInteger)getCurrenItemsInCart
{
	return iNumOfItemsInShoppingCart;
}


//Current Selected Product Details

NSDictionary *dictCurrentProduct;

+(void)setCurrentProductDetails:(NSDictionary *)_dictTemp
{
	
	if(!dictCurrentProduct)
	{
		dictCurrentProduct = [[NSDictionary alloc] init];
	}
	
	dictCurrentProduct = _dictTemp;
}

UILabel *lblLoading;
UIView *viewLoading;

#pragma mark - Loading Bar At Bottom
UIView *loadingView;
+(void)addLoadingBar_AtBottom:(UIView *)showInView withTextToDisplay:(NSString *)strText
{
	loadingView = showInView;
	[loadingView setUserInteractionEnabled:NO];
	
    viewLoading = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [viewLoading setBackgroundColor:[UIColor blackColor]];
    [viewLoading setAlpha:0.4];
    [loadingView addSubview:viewLoading];
	
    lblLoading = [[UILabel alloc] initWithFrame:CGRectMake(0, 720, 1024, 45)];
    [lblLoading setBackgroundColor:[UIColor whiteColor]];
    [lblLoading setText:strText];
    [lblLoading setAlpha:0.7];
    lblLoading.textAlignment = UITextAlignmentCenter;
    [lblLoading setFont:[UIFont boldSystemFontOfSize:25]];
    [loadingView addSubview:lblLoading];
	[loadingView bringSubviewToFront:lblLoading];
	
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
}


+(void)addLoadingBar_AtWindow:(UIView *)showInView withTextToDisplay:(NSString *)strText
{
	loadingView = showInView;
	[loadingView setUserInteractionEnabled:NO];
	
    viewLoading = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
    [viewLoading setBackgroundColor:[UIColor blackColor]];
    [viewLoading setAlpha:0.4];
    [loadingView addSubview:viewLoading];
	
		
		
    lblLoading = [[UILabel alloc] initWithFrame:CGRectMake(-486, 491, 1024, 44)];
    [lblLoading setBackgroundColor:[UIColor whiteColor]];
    [lblLoading setText:strText];
    [lblLoading setAlpha:0.7];
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if(orientation == UIDeviceOrientationLandscapeLeft)
	{
		[lblLoading setFrame:CGRectMake(-486, 491, 1024, 44)];
		[lblLoading setTransform:CGAffineTransformMakeRotation(3.14/2)];
	}
	
	else
	{
		[lblLoading setFrame:CGRectMake(230, 491, 1024, 44)];
		[lblLoading setTransform:CGAffineTransformMakeRotation(-3.14/2)];
        

	}
    lblLoading.textAlignment = UITextAlignmentCenter;
    [lblLoading setFont:[UIFont boldSystemFontOfSize:25]];
    [loadingView addSubview:lblLoading];
	[loadingView bringSubviewToFront:lblLoading];
	
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
}




+(void)dismissLoadingBar_AtBottom
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [viewLoading removeFromSuperview];
    [lblLoading removeFromSuperview];
	
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	[loadingView setUserInteractionEnabled:YES];
	
	[pool release];
	
}



#pragma mark User Settings And Tax Details 
NSDictionary *dictUserSettings;
//Set the dictionary of the setting (like Country's tax type, ta charges, user email address, currency type, shopping list details, etc)
+(void)setSettingsOfUserAndOtherDetails:(NSDictionary *)_dictSettings
{
	if(!dictUserSettings)
		dictUserSettings = [[NSDictionary alloc] init];
	dictUserSettings = _dictSettings;
	
	[dictUserSettings retain];
	
	
	_savedPreferences.strCurrency = [[dictUserSettings valueForKey:@"store"] valueForKey:@"sCurrency"];
	NSLog(@"Currency is: %@",_savedPreferences.strCurrency);
	
	if((_savedPreferences.strCurrency==nil)||([_savedPreferences.strCurrency isKindOfClass:[NSNull class]]))
	{	
		_savedPreferences.strCurrency=@"";
	}
	
	if(!_dictSettings)
		_savedPreferences.strCurrency=@"";
	
	[GlobalPrefrences setCurrencySymbol];
}
NSString *strMerchantCountry;
int iMerchantCountryID;
+(void)setUserCountryAndStateForTax_country:(NSString*)_country countryID:(int)countryID
{
	if(!strMerchantCountry)
		strMerchantCountry=[[NSString alloc]init];
	strMerchantCountry=_country;
	iMerchantCountryID=countryID;
}
+(NSDictionary *) getAppVitals
{
	return dicAppVitals;
}

+(NSString*)getUserCountryFortax
{
	return strMerchantCountry;
}
+(int)getUserCountryID
{
	return iMerchantCountryID;
}




+(NSDictionary *)getSettingsOfUserAndOtherDetails
{
	return dictUserSettings;
}

+(void)setCurrencySymbol
{
	
	NSString *strCode =@"";
	if([_savedPreferences.strCurrency length]>=3)
		strCode=  [_savedPreferences.strCurrency substringFromIndex:3];
	if([strCode isEqualToString:@"USD"])
		_savedPreferences.strCurrencySymbol = @"$";
	else if([strCode isEqualToString:@"EUR"])
		_savedPreferences.strCurrencySymbol = @"€";
	else if([strCode isEqualToString:@"GBP"])
		_savedPreferences.strCurrencySymbol = @"£";
	else
	{
		if(strCode==nil)
			_savedPreferences.strCurrencySymbol = @"";
		else
		    _savedPreferences.strCurrencySymbol = strCode;
	}	
	if(!strCode)
	    _savedPreferences.strCurrencySymbol=@"";
}



+(float) getRoundedOffValue:(float)_num
{
	NSDecimalNumber *testNumber = [NSDecimalNumber numberWithFloat:_num];
	NSDecimalNumberHandler *roundingStyle = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
	NSDecimalNumber *roundedNumber = [testNumber decimalNumberByRoundingAccordingToBehavior:roundingStyle];
	NSString *stringValue = [roundedNumber descriptionWithLocale:[NSLocale currentLocale]];
	NSLog(@"numberString  %@", stringValue);
	float finalValue=[stringValue floatValue];
	return finalValue;
}


+(void)setUserDefault_Preferences:(NSString *)value :(NSString *)key
{
	[[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
}
+(NSString *)getUserDefault_Preferences:(NSString *)forKey
{
	return [[NSUserDefaults standardUserDefaults] valueForKey:forKey];
}

NSInteger iCurrentShoppingCartNum;
+(void) setCurrentShoppingCartNum:(NSInteger)_num
{
	iCurrentShoppingCartNum = _num;
}

+(NSInteger) getCurrentShoppingCartNum
{
	return iCurrentShoppingCartNum;
}

//********* Getters ********
//return details of current selected Featured product


+(NSDictionary *) getCurrentFeaturedDetails
{
	return dictCurrentFeaturedProduct;
}
+(NSDictionary *) getNextFeaturedProductDetails
{
	return dictNextFeaturedProduct;
}


+(BOOL) validateEmail: (NSString *) candidate {
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:candidate];
}

#pragma mark - For Public APIs
NSString *strMerchantEmailID = nil;
+(void) setMerchantEmailID:(NSString *)_merchantEmail
{
	strMerchantEmailID = _merchantEmail;
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


NSString *ISAPPTOKENLIVE;

+(void) setPaypal_TOKEN_CHECK:(NSString *)_paypalToken
{
	ISAPPTOKENLIVE = [_paypalToken copy];
}
+(NSString *) getPaypal_TOKEN_CHECK
{
	return ISAPPTOKENLIVE;
}


NSMutableArray* arrDeptDataHomes;
+(void)setDepartmentsDataHomes:(NSArray*)arrDepts
{
	if (!arrDeptDataHomes) {
		arrDeptDataHomes = [[NSMutableArray alloc] init];
    }
    [arrDeptDataHomes addObject:arrDepts];
  
}

+(NSArray*)getDepartmentsDataHomes
{
    if([arrDeptDataHomes count])
    {
        NSArray *arr=[[[NSArray alloc] initWithArray:[arrDeptDataHomes lastObject]] autorelease];
        if([arrDeptDataHomes count]==1)
            return arr;
        else
        {
        [arrDeptDataHomes removeLastObject];
        return arr;
        }
    }
}

NSMutableArray* arrDeptNameHome;
+(void)setDepartmentNamesHomes:(NSString*)nameStr
{
  	if (!arrDeptNameHome) {
		arrDeptNameHome = [[NSMutableArray alloc] init];
    }
    [arrDeptNameHome addObject:nameStr];
   // [arrDeptName retain];  
}
+(NSString*)getLastDepartmentNameHomes
{
    if([arrDeptNameHome count])
    {
        NSString* str=[[[NSString alloc] initWithString:[arrDeptNameHome lastObject]] autorelease];
        [arrDeptNameHome removeLastObject];
        return str;
    }
}

NSMutableArray* arrDeptDataStore;
+(void)setDepartmentsDataStore:(NSArray*)arrDepts
{
	if (!arrDeptDataStore) {
		arrDeptDataStore = [[NSMutableArray alloc] init];
    }
    [arrDeptDataStore addObject:arrDepts];   
}

+(NSArray*)getDepartmentsDataStore
{
    if([arrDeptDataStore count])
    {
        NSArray *arr=[[[NSArray alloc] initWithArray:[arrDeptDataStore lastObject]] autorelease];
        if([arrDeptDataStore count]==1)
            return arr;
        else
        {
            [arrDeptDataStore removeLastObject];
            return arr;
        }
    }
}

NSMutableArray* arrDeptNameStore;
+(void)setDepartmentNamesStore:(NSString*)nameStr
{
  	if (!arrDeptNameStore) {
		arrDeptNameStore = [[NSMutableArray alloc] init];
    }
    [arrDeptNameStore addObject:nameStr];
  
}
+(NSString*)getLastDepartmentNameStore
{
    if([arrDeptNameStore count])
    {
        NSString* str=[[[NSString alloc] initWithString:[arrDeptNameStore lastObject]] autorelease];
        [arrDeptNameStore removeLastObject];
        return str;
    }
}

+(void)removeLocalData
{
    if([arrDeptDataStore count]>0)
        [arrDeptDataStore removeAllObjects];
    if([arrDeptNameStore count]>0)
        [arrDeptNameStore removeAllObjects];
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
