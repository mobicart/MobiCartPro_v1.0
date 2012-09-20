
//
//  MobicartStart.m
//  Mobicart
//
//  Created by Mobicart on 05/03/11.
//  Copyright mobicart. All rights reserved.
//
   
#import "MobicartStart.h"
#import "MoreTableViewDataSource.h"
#import "ShoppingCartViewController.h"
#import "Constants.h"
MobicartAppDelegate *_objMobicartAppDelegate;
static MobicartStart *shared;
@interface MobicartStart (Private)

-(void)initialSetup;

-(void)fetchDataFromServer;
-(void)fetchData;

-(void)createTabbarContorllers;
+(id)currentViewControllerObject:(id)objViewController;

#pragma mark - Loading indicator setup
-(void)setupLoadingIndicator; 
-(void)show_LoadingIndicator;
-(void)hide_LoadingIndicator;

@end
@implementation MobicartStart
@synthesize imgFooter;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/
- (id)init {
	
	if (shared) {
        [self autorelease];
        return shared;
    }
	
	
    if (self = [super init]) {
		shared = self;
		
    }
    return self;
}
#pragma mark - Helper Methods
+ (id)sharedApplication {
    if (!shared) {
        [[MobicartStart alloc] init];
    }
    return shared;
}
- (id) startMobicartOnMainWindow:(UIWindow *) _window withMerchantEmail:(NSString *)_merchantEmail  Paypal_Live_Token_ID:(NSString *) paypal_Token_Received_From_Paypal ENV_CHECK:(NSString *)ISTOKENENV Merchant_Secret_Key_Of_Store:(NSString*)strMerchant_Secret_Key
{
	self=[super init];
    if (self)
    {	
        _objMobicartAppDelegate = [[MobicartAppDelegate alloc] init];
        
        // Custom initialization.
        if(_merchantEmail)
            [GlobalPrefrences setMerchantEmailID:_merchantEmail];
        else {
            NSAssert(_merchantEmail,@"ERROR...! PLEASE ENTER MERCHANT EMAIL ID");
        }
        
        if([paypal_Token_Received_From_Paypal length] >0)
            [GlobalPrefrences setPaypal_Live_Token:paypal_Token_Received_From_Paypal];
        
        if (ISTOKENENV) {
            [GlobalPrefrences setPaypal_TOKEN_CHECK:ISTOKENENV];
        }
        
        if (strMerchant_Secret_Key) 
        {
            [GlobalPrefrences setMerchant_Secret_Key:strMerchant_Secret_Key];
        }
        
        
        _objMobicartAppDelegate.window = _window;
        
        [self performSelector:@selector(initialSetup) withObject:nil];       
		[self performSelector:@selector(createTabbarContorllers) withObject:nil ];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(poweredMobicart) name:@"poweredByMobicart" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeMobicart) name:@"removedPoweredByMobicart" object:nil];
        
    }
	return self;

}

-(void)initialSetup
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
	internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[UIApplication sharedApplication].applicationIconBadgeNumber=0;
	if (![GlobalPrefrences isInternetAvailable])
	{
		NSString* errorString = [NSString string];
		NSString* titleString = [NSString string];
		NSString* cancelString = [NSString string];
		
		if ([[[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.text"] length]>0 && [[[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.title"] length]>0 && [[[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.cancelbutton"] length]>0) 
		{
			errorString = [[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.text"];
			
			titleString = [[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.title"];
			
			cancelString = [[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.cancelbutton"];
		}
		else 
		{
			errorString = @"No Internet Connection. This Application requires Internet access to update its information";
			
			titleString = @"Alert";
			
			cancelString = @"OK";
		}
		
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:titleString message:errorString delegate:self cancelButtonTitle:nil otherButtonTitles:cancelString, nil];
		
		[errorAlert show];
		
		[errorAlert release];
	}
	else 
	{
		// Setup and start Loading indicator
		[self performSelectorInBackground:@selector(setupLoadingIndicator) withObject:nil];
		
		// Initialising global objects
		[NSThread detachNewThreadSelector:@selector(initializeGlobalControllers) toTarget:[GlobalPrefrences class] withObject:nil];
		
		// Before diplaying the data, fetch user preferneces from the server
		 [self performSelector:@selector(fetchDataFromServer) withObject:nil];
		
		[NSThread detachNewThreadSelector:@selector(setGlobalPreferences) toTarget:[GlobalPrefrences class] withObject:nil];
	}
	
	[pool release];
}
// Fetch AppID, MerchantID, StoreID, Color-schemes, Tabbar Preferences and AppVitals
-(void)fetchDataFromServer
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
	if (![GlobalPrefrences isInternetAvailable])
	{
		
		NSString* errorString = [NSString string];
		NSString* titleString = [NSString string];
		NSString* cancelString = [NSString string];
		
		if ([[[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.text"] length]>0 && [[[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.title"] length]>0 && [[[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.cancelbutton"] length]>0) 
		{
			errorString = [[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.text"];
			
			titleString = [[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.title"];
			
			cancelString = [[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.cancelbutton"];
		}
		else 
		{
			errorString = @"No Internet Connection. This Application requires Internet access to update its information";
			
			titleString = @"Alert";
			
			cancelString = @"OK";
		}
		
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:titleString message:errorString delegate:self cancelButtonTitle:nil otherButtonTitles:cancelString, nil];
		
		[errorAlert show];
		
		[errorAlert release];
		
	}
	else 
	{
	// Fetch App and Merchant Details from the server
		NSDictionary *dictAppDetails;
		dictAppDetails =[ServerAPI getAppStoreUserDetails:[GlobalPrefrences getMerchantEmailId]];
		if(!dictAppDetails)
		{
			dictAppDetails =[ServerAPI getAppStoreUserDetails:[GlobalPrefrences getMerchantEmailId]];
		}
		if (dictAppDetails)
		{
			iCurrentAppId = [[[dictAppDetails objectForKey:@"app-store-user"] objectForKey:@"appId"] intValue];
			iCurrentMerchantId = [[[dictAppDetails objectForKey:@"app-store-user"]objectForKey:@"userId"] intValue];
			iCurrentStoreId = [[[dictAppDetails objectForKey:@"app-store-user"] objectForKey:@"storeId"] intValue];
			BOOL hitLangService ;
			NSString *strTimeStamp = [NSString stringWithFormat:@"%@",[[SqlQuery shared]getTimeStamp]];
			NSLog(@"%d",[strTimeStamp length]);
			
			if ([strTimeStamp length]>0 || strTimeStamp != nil || ![strTimeStamp isEqualToString:@""] || ![strTimeStamp isEqualToString:@" "])
			{
				hitLangService  = [ServerAPI isLangUpdated:strTimeStamp:iCurrentMerchantId];	
			}
			else 
			{
				hitLangService = FALSE;
			}
			
			// Fetch Language Pack Values for Labels 
			
			NSDictionary *dictLabels = [[NSDictionary alloc] init];
			
			if (!hitLangService) 
			{
				dictLabels = [ServerAPI fetchLanguagePreferences:iCurrentMerchantId];	
			}
			
			
			
			//fetch tabbar preferences from server
			NSDictionary *dictFeatures =[ServerAPI fetchAppFeatures:iCurrentAppId];
			// Fetch Logo Image
			NSDictionary *dictColorSchemes=[ServerAPI fetchAppColorScheme:iCurrentAppId];
			
			NSDictionary *dictAppVitals =[ServerAPI fetchAppVitals:iCurrentAppId];
			arrTabbarDetails = [[ServerAPI fetchStaticPages:iCurrentAppId] objectForKey:@"static-pages"];
			[arrTabbarDetails retain];
			// Fetch Logo Image
					NSString *strUrlLogo = [NSString stringWithFormat:@"%@",[[dictAppVitals objectForKey:@"app-vitals"]objectForKey:@"companyLogoIpadNew"]];
			
			if((![strUrlLogo isEqual:[NSNull null]]) && (![strUrlLogo isEqualToString:@"<null>"]) && ([strUrlLogo length]!=0))
				_savedPreferences.imgLogo=[ServerAPI setLogoImage:[NSString stringWithFormat:@"%@",strUrlLogo]:NO];
			else
			_savedPreferences.imgLogo=	[ServerAPI setLogoImage:[NSString stringWithFormat:@"%@",strUrlLogo]:YES];
			
			
			
			// Save Language Prefrences in Database
			if (!hitLangService && [dictLabels count]>0) 
			{
				[[SqlQuery shared] deleteLangLabels];
				[[SqlQuery shared] saveLanguageLabels:[dictLabels valueForKey:@"Labels"]];
			}
			
            NSDictionary *dictLabelsFromData = [[NSDictionary alloc] initWithDictionary:[[SqlQuery shared]getAllLabels]];
            
            if ([dictLabelsFromData count]>0) 
			{
                [GlobalPrefrences setLanguageLabels:dictLabelsFromData];
            }
			
            // Set TabBar Controllers Selected by User
			
						
			if([dictFeatures count] >0)
				[GlobalPrefrences setTabbarControllers_SelectedByUser:dictFeatures];
			else
			{
				
				NSString* errorString = [NSString string];
				NSString* titleString = [NSString string];
				NSString* cancelString = [NSString string];
				
				if ([[[SqlQuery shared]getLanguageLabel:@"key.iphone.server.notresp.text"] length]>0 && [[[SqlQuery shared]getLanguageLabel:@"key.iphone.server.notresp.title.error"] length]>0 && [[[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.cancelbutton"] length]>0) 
				{
					errorString = [[SqlQuery shared]getLanguageLabel:@"key.iphone.server.notresp.text"];
					
					titleString = [[SqlQuery shared]getLanguageLabel:@"key.iphone.server.notresp.title.error"];
					
					cancelString = [[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.cancelbutton"];
				}
				else 
				{
					errorString = @"Server not Responding.";
					
					titleString = @"Error";
					
					cancelString = @"OK";
				}
				
				UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:titleString message:errorString delegate:self cancelButtonTitle:nil otherButtonTitles:cancelString, nil];
				
				[errorAlert show];
				
				[errorAlert release];
				
				
				
				
				
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[SqlQuery shared] getLanguageLabel:@"key.iphone.server.notresp.title.error"] message:[[SqlQuery shared]getLanguageLabel:@"key.iphone.server.notresp.text"] delegate:nil cancelButtonTitle:[[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
                
				[alert show];
                
				[alert release];
			}
			[GlobalPrefrences setColorScheme_SelectedByUser:dictColorSchemes];
		}
		else 
		{
			
			NSString* errorString = [NSString string];
			NSString* titleString = [NSString string];
			NSString* cancelString = [NSString string];
			
			if ([[[SqlQuery shared]getLanguageLabel:@"key.iphone.home.try.later"] length]>0 && [[[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.title"] length]>0 && [[[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.cancelbutton"] length]>0) 
			{
				errorString = [[SqlQuery shared]getLanguageLabel:@"key.iphone.home.try.later"];
				
				titleString = [[SqlQuery shared]getLanguageLabel:@"key.iphone.server.notresp.text"];
				
				cancelString = [[SqlQuery shared]getLanguageLabel:@"key.iphone.nointernet.cancelbutton"];
			}
			else 
			{
				errorString = @"Please try later";
				
				titleString = @"Server not Responding.";
				
				cancelString = @"OK";
			}
			
			UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:titleString message:errorString delegate:self cancelButtonTitle:nil otherButtonTitles:cancelString, nil];
			
			[errorAlert show];
			
			[errorAlert release];
			
			
		}
	}
    [pool release];
	
}



#pragma mark Tabbar

+(id)currentViewControllerObject:(id)objViewController
{
	return objViewController;
}
+(void)setTitleForViewController:(UIViewController *)_obj:(NSString *)strTitle
{
	if ([strTitle isEqualToString:@"My Account"])
    {
        strTitle = [[SqlQuery shared] getLanguageLabel:@"key.iphone.tabbar.account"];
    }
    
	_obj.title = strTitle;
}


-(void)createTabbarContorllers
{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
    //fetch tabbar settings, as per selected by user 
	NSArray *arrFetchedControllers = [GlobalPrefrences tabBarControllers_SelectedByUser];
	checkTab  = 0;
	if([arrFetchedControllers count] <= 4)
	{
		isMorePage=NO;
		
	}
	else if([arrFetchedControllers count] == 5)
	{
		if(![arrFetchedControllers containsObject:@"NewsViewController"])
		{
			if([arrFetchedControllers containsObject:@"ContactUsViewController"])
			{
				checkTab = 1;
			}
			if([arrFetchedControllers containsObject:@"TermsViewController"])
			{
				checkTab = 2;
			}
			if([arrFetchedControllers containsObject:@"PrivacyViewController"])
			{
				checkTab = 3;
			}
			if([arrFetchedControllers containsObject:@"Page1ViewController"])
			{
				checkTab = 4;
			}
			if([arrFetchedControllers containsObject:@"Page2ViewController"])
			{
				checkTab = 5;
			}
			
		}
	}
	else
	{
		isMorePage=YES;
		if(![arrFetchedControllers containsObject:@"NewsViewController"])
		{
			isMorePage = NO;
		}
	}
	

	NSMutableArray *arrAllControllerObjects = [[NSMutableArray alloc] init];	
	HomeViewController *_objHome=[[HomeViewController alloc]init];
	StoreViewController *_objStore = [[StoreViewController alloc] init];
	NewsViewController *_objNews= [[NewsViewController alloc] init];
	MyAccountViewController *_objMyAccount= [[MyAccountViewController alloc] init];
	AboutUsViewController *_objAboutUs= [[AboutUsViewController alloc] init];
	ContactUsViewController *_objContactUs= [[ContactUsViewController alloc] init];
	TermsViewController *_objTermsConditions = [[TermsViewController alloc] init];
	PrivacyViewController *_objPrivacy = [[PrivacyViewController alloc] init];
	Page1ViewController *_objPage1 = [[Page1ViewController alloc] init];
	Page2ViewController *_objPage2 = [[Page2ViewController alloc] init];
	
	[arrAllControllerObjects addObject:_objHome];
	[arrAllControllerObjects addObject:_objStore];
	[arrAllControllerObjects addObject:_objNews];
	[arrAllControllerObjects addObject:_objMyAccount];
	[arrAllControllerObjects addObject:_objAboutUs];
	[arrAllControllerObjects addObject:_objContactUs];
	[arrAllControllerObjects addObject:_objTermsConditions];
	[arrAllControllerObjects addObject:_objPrivacy];
	[arrAllControllerObjects addObject:_objPage1];
	[arrAllControllerObjects addObject:_objPage2];
	
	NSMutableArray *arrControllersToCreate = [[NSMutableArray alloc] init];	
	View1 *view1=[[View1 alloc]init];
	View2 *view2=[[View2 alloc]init];
	View3 *view3=[[View3 alloc]init];						  
	[arrControllersToCreate addObject:view1];
	[arrControllersToCreate addObject:view2];
	[arrControllersToCreate addObject:view3];
	
	for(int i=0,j=0; i<[arrAllControllerObjects count];i++)
	{
		NSString *strSelectedControllerName = NSStringFromClass([[arrAllControllerObjects objectAtIndex:i] class]);
		
		if(j<[arrFetchedControllers count])
		{
			if([[arrFetchedControllers objectAtIndex:j] isEqualToString:strSelectedControllerName])
			{
				[arrControllersToCreate addObject:[MobicartStart currentViewControllerObject:[arrAllControllerObjects objectAtIndex:i]]]; 
				j++;
			}
		}
		else 
			break;
	}
	
	NSMutableArray *localControllersArray = [[NSMutableArray alloc] initWithCapacity: [arrControllersToCreate count]];
	
	_objMobicartAppDelegate.tabController = [[UITabBarController alloc] init];
	_objMobicartAppDelegate.tabController.delegate=self;
	
	_objMobicartAppDelegate.tabController.moreNavigationController.delegate = self;
	NSArray *arrAllNavigationTitles = [NSArray arrayWithArray:[GlobalPrefrences getAllNavigationTitles]];
	NSMutableArray *arrSelectedTitles = [[[NSMutableArray alloc] init] autorelease];
	[arrSelectedTitles addObject:@""];
	[arrSelectedTitles addObject:@""];
	[arrSelectedTitles addObject:@""];
	for(int i =0; i<[arrAllNavigationTitles count]; i++)
	{
		if([arrAllNavigationTitles objectAtIndex:i] != @"")
			[arrSelectedTitles addObject:[arrAllNavigationTitles objectAtIndex:i]];
	}
	for(int i=0;i< [arrControllersToCreate count]; i++)
	{
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:[arrControllersToCreate objectAtIndex:i]];
		[localControllersArray addObject:localNavigationController];
		localNavigationController.delegate = self;
		[MobicartStart setTitleForViewController:[arrControllersToCreate objectAtIndex:i] :[arrSelectedTitles objectAtIndex:i]];
		[localNavigationController release];
	}	
	_objMobicartAppDelegate.tabController.viewControllers = localControllersArray; 
	[localControllersArray release];
	[_objHome release];
	[_objStore release];
	[_objMyAccount release];
	[_objNews release];
	[_objAboutUs release];
	[_objContactUs release];
	[_objTermsConditions release];
	[_objPrivacy release];
	[_objPage1 release];
	[_objPage2 release];
	[view1 release];
	[view2 release];
	[view3 release];
	
	[_objMobicartAppDelegate.window addSubview:_objMobicartAppDelegate.tabController.view];
	[_objMobicartAppDelegate.tabController setSelectedIndex:3];
    	[_objMobicartAppDelegate.tabController setDelegate:self];
    
    [pool release];
}


 - (void)navigationController:( UINavigationController * )navigationController_local willShowViewController:( UIViewController * )viewController_local animated:( BOOL )animated
{
	MobicartStart *obj=[[MobicartStart alloc]init];
	UIViewController * currentController = navigationController_local.visibleViewController;
    nextController = obj;

	NSLog(@"Nav contoller willShowViewController fired\n'%@'\n'%@'\nThere are currently: %d views on the stack\n",currentController,nextController,[self.navigationController.viewControllers count]);
	
	if ( [nextController isKindOfClass:NSClassFromString(@"UIMoreListController")])
	{
		UINavigationBar *morenavbar = navigationController_local.navigationBar;
		UINavigationItem *morenavitem = morenavbar.topItem;
		morenavitem.rightBarButtonItem = nil;
		NSLog(@"Is a UIMoreListController\n");
	}
	
}
// Fetch StaticPages And Mobicart-Branding Details
- (void)fetchData
{
	NSAutoreleasePool* autoReleasePool = [[NSAutoreleasePool alloc] init];
	if (!_objMobicartAppDelegate.arrAllData)
    {
        _objMobicartAppDelegate.arrAllData = [[NSArray alloc] init];
    }
	
	_objMobicartAppDelegate.arrAllData = [[ServerAPI fetchStaticPages:iCurrentAppId] objectForKey:@"static-pages"];
	[_objMobicartAppDelegate.arrAllData retain];
	
    self.imgFooter=[ServerAPI fetchFooterLogo];
    // Remove Branding Check
	NSDictionary *dictTemp = [_objMobicartAppDelegate.arrAllData objectAtIndex:0];
	
	NSString *strBool = [dictTemp objectForKey:@"bCustomCopyrightPage"];
	
	if (([strBool isEqual:[NSNull null]]) || (strBool == nil))
    {
        hideMobicartCopyrightLogo = FALSE;
    }
	else
    {
        hideMobicartCopyrightLogo = [[dictTemp objectForKey:@"bCustomCopyrightPage"] boolValue];
    }
	
	[autoReleasePool release];
}



- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController1
{
	selectedDepartment = [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.store.tab.all"];
  	
    
    
    switch (_objMobicartAppDelegate.tabController.selectedIndex)
	{
		case 0:
		case 1:
		case 2:
		{
			_objMobicartAppDelegate.tabController.selectedIndex=3;
			break;
		}
	}
	UIView *viewMore=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 60)];
	[viewMore setBackgroundColor:[UIColor clearColor]];
	
	
	
	UILabel *lblMore=[[UILabel alloc]initWithFrame:CGRectMake(40, 16, 150, 30)];
	lblMore.textColor=headingColor;
	[lblMore setBackgroundColor:[UIColor clearColor]];
	[lblMore setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.tabbar.more"]];
	[lblMore setFont:[UIFont boldSystemFontOfSize:15]];
	[viewMore addSubview:lblMore];
	
		
	UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(40, 50, 420,2)];
	[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
	[viewMore addSubview:imgHorizontalDottedLine];
	[imgHorizontalDottedLine release];

	if(tabBarController.moreNavigationController == viewController1)
	{
		// Add a footer view to the root table view of the moreNavigationController
		[tabBarController.moreNavigationController.topViewController.navigationController.navigationBar setHidden:YES];
		[self fetchData];
		lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];			
		if(tabBarController.moreNavigationController == viewController1)
		{
			[tabBarController.moreNavigationController.view setFrame:CGRectMake(0, 0, 1024, 720)];
			// Add a footer view to the root table view of the moreNavigationController
			UIViewController *moreViewController = tabBarController.moreNavigationController.topViewController;
			[tabBarController.moreNavigationController.topViewController.navigationController.navigationBar setHidden:YES];
			
			UIImageView	*themeImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 699)];
			[themeImage setImage:[UIImage imageNamed:@"book.png"]];
			themeImage.backgroundColor=backGroundColor;
			if(detailsView)
			{
				[detailsView removeFromSuperview];
				[detailsView release];
				detailsView=nil;
			}
			
			if(!viewRight)
			{
				viewRight=[[UIView alloc]initWithFrame:CGRectMake(550, 0, 425, 60)];
				[viewRight setBackgroundColor:[UIColor clearColor]];
				[viewMore addSubview:viewRight];
				
				
				UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 51, 424,2)];
				[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
				[viewRight addSubview:imgHorizontalDottedLine];
				[imgHorizontalDottedLine release];
				
				
				UIButton *btnCart = [[UIButton alloc]init];
				btnCart.frame = CGRectMake(350, 13, 78,34);
				[btnCart setBackgroundColor:[UIColor clearColor]];
				[btnCart setImage:[UIImage imageNamed:@"add_cart.png"] forState:UIControlStateNormal];
				[btnCart addTarget:self action:@selector(btnShoppingCart_Clicked) forControlEvents:UIControlEventTouchUpInside];
				[viewRight addSubview:btnCart];
				
				lblCart = [[UILabel alloc] initWithFrame:CGRectMake(42, 2, 30, 30)];
				lblCart.backgroundColor = [UIColor clearColor];
				lblCart.textAlignment = UITextAlignmentCenter;
				lblCart.font = [UIFont boldSystemFontOfSize:16];
				lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
				lblCart.textColor = [UIColor whiteColor];	 
				[btnCart addSubview:lblCart];
			}
			[viewRight setHidden:NO];
			if ([moreViewController.view isKindOfClass:[UITableView class]])
			{				
				if(!moreTableView)
				{
					moreTableView = (UITableView*)moreViewController.view;
					[moreTableView setAutoresizingMask:UIViewAutoresizingNone];
					[moreTableView setBackgroundView:themeImage];
					[moreTableView setScrollEnabled:NO];
					MoreTableViewDataSource *moreTableViewDataSource = [[MoreTableViewDataSource alloc] initWithDataSource:moreTableView.dataSource];
					moreTableView.dataSource = moreTableViewDataSource;
					moreTableView.delegate=moreTableViewDataSource;
					[moreTableView setSeparatorColor:[UIColor clearColor]];
					[moreTableView setTableHeaderView:viewMore];
					
					
					if (!hideMobicartCopyrightLogo)
					{
						moreTableViewDataSource.isPoweredByMobicart=YES;  
					}
					else
					{
						moreTableViewDataSource.isPoweredByMobicart=NO;
					}
					
					
				}
							
				if ([_objMobicartAppDelegate.arrAllData count]>0)
				{
					if (!hideMobicartCopyrightLogo)
					{ 
						[self removeMobicart];
						[moreTableView setScrollEnabled:FALSE];
						[self poweredMobicart];
					}
				}	
				
			}
		}
	}
	else
	{
		UIView *imgBGView = (UIView *)[_objMobicartAppDelegate.window viewWithTag:10801];
		[imgBGView removeFromSuperview];
		[self removeMobicart];
	}
    
    if(tabBarController.selectedIndex==3)
	{
		[[GlobalPrefrences getCurrentNavigationController] popToRootViewControllerAnimated:YES];
	}
	 [viewMore release];
	
	if([viewController1 isKindOfClass:[UINavigationController class]])
		[GlobalPrefrences setCurrentNavigationController:(UINavigationController *)viewController1];
     
    if(tabBarController.selectedIndex==3)
         [[GlobalPrefrences getCurrentNavigationController] popToRootViewControllerAnimated:YES];

         
    
	
	
}
-(void)mobiLogoClicked
{
	UIView *imgBGView = (UIView *)[_objMobicartAppDelegate.window viewWithTag:10801];
	[imgBGView removeFromSuperview];
	MobiCartWebView *objMobiWebView = [[MobiCartWebView alloc]init];
	[[GlobalPrefrences getCurrentNavigationController] pushViewController:objMobiWebView animated:YES];
	[objMobiWebView release];
}

- (void)poweredMobicart
{
	if (!hideMobicartCopyrightLogo)
    {
		
		UIInterfaceOrientation orientation1 = [[UIApplication sharedApplication] statusBarOrientation];
        UIImage *imgView =self.imgFooter;
        if(orientation1==UIInterfaceOrientationPortrait)
        {
        }
       if(orientation1 == UIInterfaceOrientationLandscapeLeft)
		{
			UIView *imgBGView = [[UIView alloc] initWithFrame:CGRectMake(610,  550, 80, 180)];
            
            
            [imgBGView setBackgroundColor:[UIColor clearColor]];
			[imgBGView setTag:10801];
			// calculate the size of the rotated view's containing box for our drawing space
			UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,imgView.size.width, imgView.size.height)];
			CGAffineTransform t = CGAffineTransformMakeRotation(-3.14/2);
			rotatedViewBox.transform = t;
			CGSize rotatedSize = rotatedViewBox.frame.size;
			[rotatedViewBox release];
			
			// Create the bitmap context
			UIGraphicsBeginImageContext(rotatedSize);
			CGContextRef bitmap = UIGraphicsGetCurrentContext();
			
			// Move the origin to the middle of the image so we will rotate and scale around the center.
			CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
			
            // Rotate the image context
			CGContextRotateCTM(bitmap, (3.14/2+3.14));
			
			// Now, draw the rotated/scaled image into the context
			CGContextScaleCTM(bitmap, 1.0, -1.0);
			CGContextDrawImage(bitmap, CGRectMake(-imgView.size.width / 2, -imgView.size.height / 2, imgView.size.width, imgView.size.height), [imgView CGImage]);
			
			UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
			
			UIButton *btnMobicart = [UIButton buttonWithType:UIButtonTypeCustom];
			btnMobicart.frame = CGRectMake(0,0,80,180);
			[btnMobicart setBackgroundColor:[UIColor clearColor]];
			[btnMobicart setImage:newImage forState:UIControlStateNormal];
			[btnMobicart addTarget:self action:@selector(mobiLogoClicked) forControlEvents:UIControlEventTouchUpInside];
			[imgBGView addSubview:btnMobicart];
			
			CGContextRef context = UIGraphicsGetCurrentContext();
			CATransition *animation = [CATransition animation]; 
			[animation setDelegate:self]; 
			[animation setType: kCATransitionMoveIn];
			[animation setSubtype:kCATransitionFromRight]; 
			
			
			[animation setDuration:1.0f]; 
			[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
			[UIView beginAnimations:nil context:context];
			[[imgBGView layer] addAnimation:animation forKey:kCATransition];
			
			
			[_objMobicartAppDelegate.window addSubview:imgBGView];
			[_objMobicartAppDelegate.window bringSubviewToFront:imgBGView];
			[imgBGView release];
			
			[UIView commitAnimations]; 
			
		}
		
		if(orientation1 == UIInterfaceOrientationLandscapeRight)
		
        {
			UIView *imgBGView = [[UIView alloc] initWithFrame:CGRectMake(80,  300, 80, 180)];
			
			[imgBGView setBackgroundColor:[UIColor clearColor]];
			[imgBGView setTag:10801];
		
			UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,imgView.size.width, imgView.size.height)];
			CGAffineTransform t = CGAffineTransformMakeRotation(3.14/2);
			rotatedViewBox.transform = t;
			CGSize rotatedSize = rotatedViewBox.frame.size;
			[rotatedViewBox release];
			
			// Create the bitmap context
			UIGraphicsBeginImageContext(rotatedSize);
			CGContextRef bitmap = UIGraphicsGetCurrentContext();
			
			// Move the origin to the middle of the image so we will rotate and scale around the center.
			CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
			
			// Rotate the image context
			CGContextRotateCTM(bitmap, (3.14/2));
			
			// Now, draw the rotated/scaled image into the context
			CGContextScaleCTM(bitmap, 1.0, -1.0);
			CGContextDrawImage(bitmap, CGRectMake(-imgView.size.width / 2, -imgView.size.height / 2, imgView.size.width, imgView.size.height), [imgView CGImage]);
			
			UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
			
			UIButton *btnMobicart = [UIButton buttonWithType:UIButtonTypeCustom];
			btnMobicart.frame = CGRectMake(0,0,80,180);
			[btnMobicart setBackgroundColor:[UIColor clearColor]];
			[btnMobicart setImage:newImage forState:UIControlStateNormal];
			[btnMobicart addTarget:self action:@selector(mobiLogoClicked) forControlEvents:UIControlEventTouchUpInside];
			[imgBGView addSubview:btnMobicart];
			
			CGContextRef context = UIGraphicsGetCurrentContext();
			CATransition *animation = [CATransition animation]; 
			[animation setDelegate:self]; 
	
             [animation setType: kCATransitionMoveIn];
			[animation setSubtype:kCATransitionFromLeft]; 
		
			
			[animation setDuration:1.0f]; 
			[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
			[UIView beginAnimations:nil context:context];
			[[imgBGView layer] addAnimation:animation forKey:kCATransition];
			
			
			[_objMobicartAppDelegate.window addSubview:imgBGView];
			[_objMobicartAppDelegate.window bringSubviewToFront:imgBGView];
			[imgBGView release];
			
			[UIView commitAnimations]; 
		}
	}
}

- (void)removeMobicart
{
	UIView *imgBGView = (UIView *)[_objMobicartAppDelegate.window viewWithTag:10801];
	[imgBGView removeFromSuperview];
}

-(void)btnShoppingCart_Clicked
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"removedPoweredByMobicart" object:nil];
	if(iNumOfItemsInShoppingCart > 0)
		[NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
	ShoppingCartViewController *objShopping = [[ShoppingCartViewController alloc] init];
	[[GlobalPrefrences getCurrentNavigationController]pushViewController:objShopping animated:YES];
	[objShopping release];
	
}
-(void)showLoading
{
	[GlobalPrefrences addLoadingBar_AtWindow:_objMobicartAppDelegate.window  withTextToDisplay:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
}



-(void)moreTableCellClicked:(UIButton*)sender
{
	
	if(detailsView)
	{
		[detailsView removeFromSuperview];
		[detailsView release];
		detailsView=nil;
	}
	
	
	[viewRight setHidden:YES];
	detailsView=[[UIView alloc]initWithFrame:CGRectMake(500, 10, 500, 650)];
	[detailsView setBackgroundColor:[UIColor clearColor]];
	[moreTableView addSubview:detailsView];
	
	
	for (int index=0; index<[arrTabbarDetails count]; index++) {
		
		NSString *strTitle = [NSString stringWithFormat:@"%@",sender.titleLabel.text];
		
		    if([strTitle isEqualToString: [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.more.aboutus"]])
			{
				AboutUsViewController *objAbout=[[AboutUsViewController alloc]init]; 
				[detailsView addSubview:objAbout.view];
				break;
			}
			else if([strTitle isEqualToString: [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.more.contactus"]])
			{
				ContactUsViewController *objContactUS=[[ContactUsViewController alloc]init]; 
				
				[detailsView addSubview:objContactUS.view];
				break;
				
			}
			else if([strTitle isEqualToString: [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.more.tandc"]])
			{
				TermsViewController *objTerms=[[TermsViewController alloc]init]; 
				
				[detailsView addSubview:objTerms.view];
				break;
				
			}
			else if([strTitle isEqualToString: [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.more.privacy"]])
			{
				PrivacyViewController *objPrivacy=[[PrivacyViewController alloc]init]; 
				
				[detailsView addSubview:objPrivacy.view];
				break;
				
			}
		
		if([[[arrTabbarDetails valueForKey:@"sTitle"] objectAtIndex:index]isEqualToString:[NSString stringWithFormat:@"%@",sender.titleLabel.text]])
		{
			 if([[[arrTabbarDetails valueForKey:@"sName"] objectAtIndex:index]isEqualToString:@"page1"])
			{
				Page1ViewController *objpage1=[[Page1ViewController alloc]init]; 
				
				[detailsView addSubview:objpage1.view];
				break;
				
			}
			else if([[[arrTabbarDetails valueForKey:@"sName"] objectAtIndex:index]isEqualToString:@"page2"])
			{
				Page2ViewController *objpage2=[[Page2ViewController alloc]init]; 
				
				[detailsView addSubview:objpage2.view];
				break;
				
			}
		}
		
   }
	
}

#pragma mark - loading indicator (Global)
-(void)setupLoadingIndicator
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	_objMobicartAppDelegate.backgroundImage = [[UIImageView alloc] initWithFrame:_objMobicartAppDelegate.window.bounds];
	_objMobicartAppDelegate.backgroundImage.image = [UIImage imageNamed:@"Default.png"];
    [_objMobicartAppDelegate.window addSubview:_objMobicartAppDelegate.backgroundImage];
	[_objMobicartAppDelegate.backgroundImage setHidden:YES];
	
    if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ){
     
    }
    if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown ){
      
    }
    if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft )
    {
    }
    if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ){
       
    } 
	CGRect frame = CGRectMake(512.0, 512.0, 50, 50);
	_objMobicartAppDelegate.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[_objMobicartAppDelegate.loadingIndicator setFrame:frame];
   

	[_objMobicartAppDelegate.loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[_objMobicartAppDelegate.loadingIndicator startAnimating];
	[_objMobicartAppDelegate.window addSubview:_objMobicartAppDelegate.loadingIndicator];
	[self show_LoadingIndicator];
	[pool release];
	
}

//show loading indicator
-(void)show_LoadingIndicator
{
	[_objMobicartAppDelegate.window bringSubviewToFront:_objMobicartAppDelegate.backgroundImage];
	[_objMobicartAppDelegate.window bringSubviewToFront:_objMobicartAppDelegate.loadingIndicator];
	[_objMobicartAppDelegate.loadingIndicator setHidden:NO];
	[_objMobicartAppDelegate.backgroundImage setHidden:NO];
}


//hide loading indicator
-(void)hide_LoadingIndicator
{
	[_objMobicartAppDelegate.loadingIndicator setHidden:YES];
	[_objMobicartAppDelegate. backgroundImage setHidden:YES];
}
#pragma mark - button Shoppoing Cart Accessor 
-(void)showLoadingbar
{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
	[GlobalPrefrences addLoadingBar_AtBottom:self.view withTextToDisplay:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
	[pool release];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}*/



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	if([arrTabbarDetails retainCount]>1)
		[arrTabbarDetails release];
	if(viewRight)
		[viewRight release];
    [super dealloc];
}


+(void)tabSettingForAboutUs:(UINavigationController*)_arr
{
	NSArray* arr = [_arr viewControllers];
	if ([arr count]>0) 
	{
		UIViewController *vC = [_arr objectAtIndex:0];
		NSArray* sub = [vC.view subviews];
        
	}
}
	
@end
