//
//  DetailsViewController.m
//  MobiCart
//
//  Created by Mobicart on 8/26/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

/** The view controller to create account & View Account Details and Delivery Address & Update Account Details and Delivery Address **/

#import "DetailsViewController.h"
#import "Constants.h"

BOOL isDeliveryShown;
int isfromTag;
BOOL selectPicker;
int rowValue;
extern   MobicartAppAppDelegate *_objMobicartAppDelegate;
extern BOOL isCheckForCheckout;
BOOL isEditMode=false;

extern BOOL isWishlistLogin;
extern BOOL isCheckout;
extern BOOL isOrderLogin;
extern BOOL isAccount;
BOOL isLoadingTableFooter;

@implementation DetailsViewController

@synthesize viewForLogin, viewForRegistration;
@synthesize alertMain,isReview;

- (void)viewWillAppear:(BOOL)animated
{
	if(_objMobicartAppDelegate.tabController.selectedIndex>3)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"removedPoweredByMobicart" object:nil];
    }	
	
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateLabelAccount" object:nil];
	isLoadingTableFooter = NO;
    isEditMode=false;
}

-(void)viewDidDisappear:(BOOL)animated
{
    if(isCheckForCheckout==NO)
    {
        isCheckout=NO;
    }
    
	
}	

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	self.navigationItem.titleView = [GlobalPreferences createLogoImage];
	UIColor *tempColor = [UIColor colorWithRed:248.0/256 green:248.0/256 blue:248.0/256 alpha:1];
	UIColor *tempColor1 = [UIColor colorWithRed:203.0/256 green:203.0/256 blue:203.0/256 alpha:1];
	
	isLoadingFirstTime=YES;
	contentView=[[UIView alloc]initWithFrame:CGRectMake( 0, 0, 320, 372)];
	contentView.backgroundColor=tempColor;
	self.view=contentView;
	
	UIImageView *imgContentView=[[UIImageView alloc]initWithFrame:CGRectMake(0,30,320,350)];
	[imgContentView setBackgroundColor:[UIColor clearColor]];
	[imgContentView setImage:[UIImage imageNamed:@"product_details_bg.png"]];
	[contentView addSubview:imgContentView];
	[imgContentView release];
    
	viewForRegistration = [[UIView alloc]initWithFrame:CGRectMake( 0, 0, 320, 372)];
	viewForRegistration.backgroundColor=tempColor;
	viewForRegistration.hidden = TRUE;
	[contentView addSubview:viewForRegistration];
	
	UIImageView *imgViewForRegistration=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40,320,350)];
	[imgViewForRegistration setBackgroundColor:[UIColor clearColor]];
	[imgViewForRegistration setImage:[UIImage imageNamed:@"product_details_bg.png"]];
	[viewForRegistration addSubview:imgViewForRegistration];
	[imgViewForRegistration release];
	
	[GlobalPreferences setGradientEffectOnView:viewForRegistration:tempColor:tempColor1];
	
	viewForLogin =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 372)];
	viewForLogin.backgroundColor=tempColor;
	viewForLogin.hidden = TRUE;
	[contentView addSubview:viewForLogin];
	
	UIImageView *imgViewForLogin=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40,320,350)];
	[imgViewForLogin setBackgroundColor:[UIColor clearColor]];
	[imgViewForLogin setImage:[UIImage imageNamed:@"product_details_bg.png"]];
	[viewForLogin addSubview:imgViewForLogin];
	[imgViewForLogin release];
	
	[GlobalPreferences setGradientEffectOnView:viewForLogin:tempColor:tempColor1];
	
	arrInfoAccount=[[NSMutableArray alloc]init];
	arrInfoAccount=[[SqlQuery shared] getAccountData:[GlobalPreferences getUserDefault_Preferences:@"userEmail"]];
	
	// If the user is not logged in then display Alert Box Else Create View for Account Details
	if ([arrInfoAccount count]==0)
	{
		alertMain = [[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.account.info"] message:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.must.login"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.cancel"] otherButtonTitles:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.loginto.account"],[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.create.account"],nil];
		[alertMain show];
		DETAILSPRESENT=NO;
	}
	else
	{
		DETAILSPRESENT=YES;
		
		contentScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake( 0, 20, 320,400)];
		[contentScrollView setBackgroundColor:[UIColor clearColor]];
		[contentScrollView setContentSize:CGSizeMake( 320,610)];
		[contentView addSubview:contentScrollView];
		
		UIView *viewTopBar=[[UIView alloc]initWithFrame:CGRectMake(0,0, 320,30)];
		[viewTopBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"barNews.png"]]];
		
        // Setting gradient effect on view
		[contentView addSubview:viewTopBar];
		
		UILabel *accountLbl=[[UILabel alloc]initWithFrame:CGRectMake(10,0, 310, 30)];
		[accountLbl setBackgroundColor:[UIColor clearColor]];
		[accountLbl setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.account.info"]];
		[accountLbl setTextColor:[UIColor whiteColor]];
		[accountLbl setFont:[UIFont boldSystemFontOfSize:13]];
		[viewTopBar addSubview:accountLbl];
		[accountLbl release];
		
		[viewTopBar release];
		
		NSArray *arrDetailLbl=[NSArray arrayWithObjects:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.email"], [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.street"], [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.city"],[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.zip"] , [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.country"], [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.state"], nil];
        
		
		int yAxis=20;
		for (int i=0; i<6; i++) 
        {
			lblDetails[i] = [[UILabel alloc]initWithFrame:CGRectMake( 13, yAxis, 150, 30)];
			[lblDetails[i] setBackgroundColor:[UIColor clearColor]];
			lblDetails[i].textColor=[UIColor darkGrayColor];
			lblDetails[i].font=[UIFont boldSystemFontOfSize:16];
			[lblDetails[i] setText:[arrDetailLbl objectAtIndex:i]];
			[contentScrollView addSubview:lblDetails[i]];
			[lblDetails[i] release];
			
			txtDetails[i] = [[UITextField alloc] initWithFrame:CGRectMake( 100, yAxis, 200,30)];
			[txtDetails[i] setBorderStyle:UITextBorderStyleRoundedRect];
			[txtDetails[i] setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
			[txtDetails[i] setDelegate:self];
			[txtDetails[i] setEnabled:NO];
			[contentScrollView addSubview:txtDetails[i]];

			if ([arrInfoAccount count]!=0)
			{
				txtDetails[i].text = [arrInfoAccount objectAtIndex:i];
			}
			
			if (i==5)
			{
				[txtDetails[i] setKeyboardType:UIKeyboardTypeDefault];
                
				[txtDetails[i] setFrame:CGRectMake( 100, yAxis-73, 200, 30)];
                txtDetails[i].text = [arrInfoAccount objectAtIndex:4];
			}
            else if (i==0)
            {
                [txtDetails[i] setKeyboardType:UIKeyboardTypeEmailAddress];
            }
			else if (i==3)
			{
				[txtDetails[i] setEnabled:NO];
				
				[txtDetails[i] setFrame:CGRectMake( 100, yAxis+37, 200, 30)];
				
				btnShowPickerViewState = [UIButton buttonWithType:UIButtonTypeCustom];
				[btnShowPickerViewState setFrame:txtDetails[i].frame];
				[btnShowPickerViewState setBackgroundColor:[UIColor clearColor]];
				[btnShowPickerViewState setTag:3];
				[btnShowPickerViewState setEnabled:NO];
				[btnShowPickerViewState addTarget:self action:@selector(getPickerView:) forControlEvents:UIControlEventTouchUpInside];
				[contentScrollView addSubview:btnShowPickerViewState];
				[contentScrollView bringSubviewToFront:btnShowPickerViewState];
                txtDetails[i].text = [arrInfoAccount objectAtIndex:5];
                
			}
			else if (i==4)
			{
				[txtDetails[i] setEnabled:NO];
                txtDetails[i].text = [arrInfoAccount objectAtIndex:3];
                [txtDetails[i] setFrame:CGRectMake( 100, yAxis+37, 200, 30)];
				
				
				btnShowPickerViewDetails = [UIButton buttonWithType:UIButtonTypeCustom];
				[btnShowPickerViewDetails setFrame:txtDetails[i].frame];
				[btnShowPickerViewDetails setBackgroundColor:[UIColor clearColor]];
				[btnShowPickerViewDetails setTag:7];
				[btnShowPickerViewDetails setEnabled:NO];
				[btnShowPickerViewDetails addTarget:self action:@selector(getPickerView:) forControlEvents:UIControlEventTouchUpInside];
				[contentScrollView addSubview:btnShowPickerViewDetails];
				[contentScrollView bringSubviewToFront:btnShowPickerViewDetails];
			}
			
			[txtDetails[i] setReturnKeyType:UIReturnKeyDone];
			yAxis+=37;
		}
		
		UILabel *lblDeliveryAddress=[[UILabel alloc]initWithFrame:CGRectMake( 10, 240, 200, 50)];
		[lblDeliveryAddress setBackgroundColor:[UIColor clearColor]];
		lblDeliveryAddress.textColor=[UIColor blackColor];
		lblDeliveryAddress.font=[UIFont boldSystemFontOfSize:16];
		[lblDeliveryAddress setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.daddr"]];
		[contentScrollView addSubview:lblDeliveryAddress];
		[lblDeliveryAddress release];
		
		arrDetailLbl=[NSArray arrayWithObjects: [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.street"], [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.city"], [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.zip"],[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.country"], [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.state"],  nil];
		
		yAxis=290;
		
        for (int i=0; i<5; i++) 
        {
			lblDeliveryDetails[i] = [[UILabel alloc]initWithFrame:CGRectMake( 13, yAxis, 150, 30)];
			[lblDeliveryDetails[i] setBackgroundColor:[UIColor clearColor]];
			lblDeliveryDetails[i].textColor=[UIColor darkGrayColor];
			lblDeliveryDetails[i].font=[UIFont boldSystemFontOfSize:18];
			[lblDeliveryDetails[i] setText:[arrDetailLbl objectAtIndex:i]];
			[contentScrollView addSubview:lblDeliveryDetails[i]];
			[lblDeliveryDetails[i] release];
			
			txtDeliveryDetails[i] = [[UITextField alloc] initWithFrame:CGRectMake(100,yAxis,200,30)];
			[txtDeliveryDetails[i] setBorderStyle:UITextBorderStyleRoundedRect];
			[txtDeliveryDetails[i] setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
			[txtDeliveryDetails[i] setDelegate:self];
			[txtDeliveryDetails[i] setEnabled:NO];
			[contentScrollView addSubview:txtDeliveryDetails[i]];
			
			if ([arrInfoAccount count]!=0)
			{
				txtDeliveryDetails[i].text = [arrInfoAccount objectAtIndex:(i+6)];
			}
			
			if (i==4)
			{
				[txtDeliveryDetails[i] setKeyboardType:UIKeyboardTypeDefault];
				[txtDeliveryDetails[i] setFrame:CGRectMake( 100, yAxis-73, 200,30)];
                txtDeliveryDetails[i].text = [arrInfoAccount objectAtIndex:9];
				
			}
			else if (i==3)
			{
				[txtDeliveryDetails[i] setEnabled:NO];
				[txtDeliveryDetails[i] setFrame:CGRectMake( 100, yAxis+37, 200,30)];
                
				btnShowPickerViewDeliveryState = [UIButton buttonWithType:UIButtonTypeCustom];
				[btnShowPickerViewDeliveryState setFrame:txtDeliveryDetails[i].frame];
				[btnShowPickerViewDeliveryState setBackgroundColor:[UIColor clearColor]];
				[btnShowPickerViewDeliveryState setTag:8];
				[btnShowPickerViewDeliveryState setEnabled:NO];
				[btnShowPickerViewDeliveryState addTarget:self action:@selector(getPickerView:) forControlEvents:UIControlEventTouchUpInside];
				[contentScrollView addSubview:btnShowPickerViewDeliveryState];
				[contentScrollView bringSubviewToFront:btnShowPickerViewDeliveryState];
				if ([arrInfoAccount count])
                {
                    txtDeliveryDetails[i].text = [arrInfoAccount objectAtIndex:8];
                }
			}
			else if (i==2)
			{
				[txtDeliveryDetails[i] setEnabled:NO];
				
				[txtDeliveryDetails[i] setFrame:CGRectMake( 100, yAxis+37, 200,30)];
				btnShowPickerViewDeliveryDetails = [UIButton buttonWithType:UIButtonTypeCustom];
				[btnShowPickerViewDeliveryDetails setFrame:txtDeliveryDetails[i].frame];
				[btnShowPickerViewDeliveryDetails setBackgroundColor:[UIColor clearColor]];
				[btnShowPickerViewDeliveryDetails setTag:4];
				[btnShowPickerViewDeliveryDetails setEnabled:NO];
				[btnShowPickerViewDeliveryDetails addTarget:self action:@selector(getPickerView:) forControlEvents:UIControlEventTouchUpInside];
				[contentScrollView addSubview:btnShowPickerViewDeliveryDetails];
				[contentScrollView bringSubviewToFront:btnShowPickerViewDeliveryDetails];
				
				if ([arrInfoAccount count])
                {
                    txtDeliveryDetails[i].text = [arrInfoAccount objectAtIndex:10];
                }
			}
			
			[txtDeliveryDetails[i] setReturnKeyType:UIReturnKeyDone];
			
			yAxis+=37;
		}
		
		
		
		toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake( 0, 160, 320, 40)];
		[toolBar setTintColor:[UIColor blackColor]];
		[toolBar setHidden:YES];
		[contentView addSubview:toolBar];
		
		UIBarButtonItem *btnDone=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignTextField)];
		UIBarButtonItem *flexiSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
		
		[toolBar setItems:[NSArray arrayWithObjects: flexiSpace,btnDone,nil]];
		[btnDone release];
		[flexiSpace release];
		
		btnEdit=[UIButton buttonWithType:UIButtonTypeCustom];
		[btnEdit setFrame:CGRectMake( 100, 480, 120, 30)];
		[btnEdit setTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.createaccount.edit"] forState:UIControlStateNormal];
		[btnEdit layer].cornerRadius=5.0;
		[btnEdit setBackgroundColor:navBarColor];
		[btnEdit setBackgroundImage:[UIImage imageNamed:@"edit_btn.png"] forState:UIControlStateNormal];
		[btnEdit addTarget:self action:@selector(editInfo) forControlEvents:UIControlEventTouchUpInside];
		[contentScrollView addSubview:btnEdit];
	}
	[self createPickerView];
}

// Load Picker Views for Country and States and Hide them initially 
- (void)createPickerView
{
	pickerViewCountry = [[UIPickerView alloc]initWithFrame:CGRectMake( 0, 200, 320, 160)];
	[pickerViewCountry setDelegate:self];
	[pickerViewCountry setDataSource:self];
	[pickerViewCountry setShowsSelectionIndicator:YES];
	[pickerViewCountry setHidden:YES];
	[contentView addSubview:pickerViewCountry];
	
	pickerViewStates = [[UIPickerView alloc]initWithFrame:CGRectMake( 0, 200, 320, 160)];
	[pickerViewStates setDelegate:self];
	[pickerViewStates setDataSource:self];
	[pickerViewStates setShowsSelectionIndicator:YES];
	[pickerViewStates setHidden:YES];
	[contentView addSubview:pickerViewStates];
	
	dicSettings = [[NSDictionary alloc]init];
	dicSettings = [GlobalPreferences getSettingsOfUserAndOtherDetails];
	[dicSettings retain];
	
	interShippingDict = [[NSArray alloc]init];
	NSDictionary *contentDict = [dicSettings objectForKey:@"store"];
	interShippingDict = [contentDict objectForKey:@"shippingList"];
	[interShippingDict retain];
	
	NSDictionary *lDicAppVitals=[[NSDictionary alloc]init];
	lDicAppVitals=[GlobalPreferences getAppVitals];
	NSMutableArray *arrTempComp=[[NSMutableArray alloc]init];
	arrTempComp=[contentDict valueForKey:@"taxList"];
	
	NSMutableArray *arrayCountryTemp = [[NSMutableArray alloc] init];
	arrcountryCodes=[[NSMutableArray alloc]init];
    
	for(int i=0;i<[arrTempComp count];i++)
	{
	    if (![[arrayCountryTemp valueForKey:@"sCountry"] containsObject:[[arrTempComp objectAtIndex:i]valueForKey:@"sCountry"]]) 
        {
			[arrayCountryTemp addObject:[arrTempComp objectAtIndex:i]];
			[arrcountryCodes addObject:[[arrTempComp objectAtIndex:i] valueForKey:@"territoryId"]];
		}
		
	}
	for(int i=0;i<[interShippingDict count];i++)
	{
	    if (![[arrayCountryTemp valueForKey:@"sCountry"] containsObject:[[interShippingDict objectAtIndex:i]valueForKey:@"sCountry"]]) 
        {
			[arrayCountryTemp addObject:[interShippingDict objectAtIndex:i]];
			[arrcountryCodes addObject:[[interShippingDict objectAtIndex:i] valueForKey:@"territoryId"]];
		}
		
	}
    
	[dicSettings release];
	
	arrayCountry = [[NSArray alloc] initWithArray:arrayCountryTemp];
    
	[arrayCountry retain];
	
	arrayStates = [[NSMutableArray alloc] init];
	currentCountryIdForDelivery=[GlobalPreferences getUserCountryID];
	
	if (currentCountryIdForDelivery==0)
	{
		if ([arrcountryCodes count]>0)
        {
            currentCountryIdForDelivery=[[arrcountryCodes objectAtIndex:0]intValue];
        }
	}
	
	[arrayStates removeAllObjects];
	for(int index=0;index<[arrTempComp count];index++)
	{
		if (currentCountryIdForDelivery==[[[arrTempComp valueForKey:@"territoryId"]objectAtIndex:index]intValue])
		{
			[arrayStates  addObject:[arrTempComp objectAtIndex:index]];
		}
	}
	for(int index=0;index<[interShippingDict count];index++)
	{
		if (currentCountryIdForDelivery==[[[interShippingDict valueForKey:@"territoryId"]objectAtIndex:index]intValue])
		{
			if (![[arrayStates valueForKey:@"sState"]containsObject:[[interShippingDict valueForKey:@"sState"]objectAtIndex:index]])
            {
                [arrayStates  addObject:[interShippingDict objectAtIndex:index]];
            }
		}
	}
    
	if([arrayStates count]>0)
		currentStateIdForDelivery=[[[arrayStates valueForKey:@"stateId"]objectAtIndex:0]intValue];
	
	[arrayCountryTemp release];
}

// Called when Edit/Update button  is tapped
- (void)editInfo
{
    isEditMode=true;
	if (![txtDetails[2] isEnabled])
	{
		int index;
		currentCountryIdForDelivery = [[[NSUserDefaults standardUserDefaults]valueForKey:@"countryID"]intValue];
		currentStateIdForDelivery=[[[NSUserDefaults standardUserDefaults]valueForKey:@"stateID"]intValue];
		NSString *strCountry=txtDetails[5].text;
	
		if ([arrayCountry containsObject:strCountry])
		{
			index=[arrayCountry indexOfObject:strCountry];
			currentCountryIdForDelivery=[[arrcountryCodes objectAtIndex:index]intValue];
		}
		
		[NSThread detachNewThreadSelector:@selector(getStatesOfaCountry:) toTarget:self withObject:@""];
		
		for (int i=0; i<6; i++)
		{
			if (i!=0)
			{
				if (i<5)
                {
                    [txtDetails[i] setEnabled:YES];
                }
				else
				{
					[btnShowPickerViewDetails setEnabled:YES];
					[btnShowPickerViewState setEnabled:YES];
				}
			}
			
			if (i<5) 
			{
				if (i<4)
                {
                    [txtDeliveryDetails[i] setEnabled:YES];
                }
				else
				{
					[btnShowPickerViewDeliveryDetails setEnabled:YES];
					[btnShowPickerViewDeliveryState setEnabled:YES];
				}
			}
		}
		[txtDeliveryDetails[4] setEnabled:YES];
		[btnEdit setTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.createaccount.update"] forState:UIControlStateNormal];
	}
	else
	{
		if (([txtDetails[0].text length]==0) || ([txtDetails[1].text length]==0) || ([txtDetails[2].text length]==0) || ([txtDetails[3].text length]==0) || ([txtDetails[4].text length]==0) || ([txtDetails[5].text length]==0) || ([txtDeliveryDetails[0].text length]==0) || [txtDeliveryDetails[1].text length]==0 || [txtDeliveryDetails[2].text length]==0 || [txtDeliveryDetails[3].text length]==0 || [txtDeliveryDetails[4].text length]==0)
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.textfield.notempty.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else
        {
			for (int i=0; i<6; i++)
			{
				if (i!=0)
				{
					if (i<5)
                    {
                        [txtDetails[i] setEnabled:NO];
                    }
					else
					{
						[btnShowPickerViewDetails setEnabled:NO];
						[btnShowPickerViewState setEnabled:NO];
					}
				}
				
				if (i<5) 
				{
					if (i<4)
                    {
                        [txtDeliveryDetails[i] setEnabled:NO];
                    }
					else
					{
						[btnShowPickerViewDeliveryDetails setEnabled:NO];
						[btnShowPickerViewDeliveryState setEnabled:NO];
					}
				}
			}
            
			[btnEdit setTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.createaccount.edit"] forState:UIControlStateNormal];
			
            
            
           
			[[SqlQuery shared] updateTblAccountDetails:txtDetails[1].text :txtDetails[2].text :txtDetails[4].text :txtDetails[3].text :txtDetails[5].text :txtDeliveryDetails[0].text :txtDeliveryDetails[1].text :txtDeliveryDetails[2].text :txtDeliveryDetails[3].text :txtDeliveryDetails[4].text :txtDetails[0].text];
			
			NSDictionary *contentDict = [dicSettings objectForKey:@"store"];
			NSArray* arrTemp =[contentDict objectForKey:@"taxList"];
			NSArray *arrTempShippingCountries=[contentDict objectForKey:@"shippingList"];
			
			
			NSString *strCountryCode;
			for(int i=0;i<[arrTemp count];i++)
			{
				if ([txtDeliveryDetails[3].text isEqualToString:[[arrTemp objectAtIndex:i]valueForKey:@"sCountry"]]) 
				{
					strCountryCode = [[arrTemp objectAtIndex:i] valueForKey:@"territoryId"];

				}
			}
			for(int i=0;i<[arrTempShippingCountries count];i++)
			{
				if ([txtDeliveryDetails[2].text isEqualToString:[[arrTempShippingCountries objectAtIndex:i]valueForKey:@"sCountry"]]) 
				{
					strCountryCode = [[arrTempShippingCountries objectAtIndex:i] valueForKey:@"territoryId"];
				}
			}
			int CountryCode = [strCountryCode integerValue];
			
			[[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",currentStateIdForDelivery] forKey:@"stateID"];
			[[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",CountryCode] forKey:@"countryID"];
			
			[GlobalPreferences setUserDefault_Preferences:txtDetails[0].text :@"userEmail"];
			
			
			
			[GlobalPreferences setPersonLoginStatus:YES];
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.info.update.title"] message:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.info.update.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			[alert show];
			[alert release];
		}		
	}
}

// Called when Create Account is clicked on Alert Box
- (void)displayViewForRegistration
{
	contentScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake( 0, 20, 320,480)];
	[contentScrollView setBackgroundColor:[UIColor clearColor]];
	[contentScrollView setContentSize:CGSizeMake(320,580)];
	[viewForRegistration addSubview:contentScrollView];
	
	UIView *viewTopBar=[[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 30)];
	[viewTopBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"barNews.png"]]];
	[viewForRegistration addSubview:viewTopBar];
	
	UILabel *accountLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 310, 20)];
	[accountLbl setBackgroundColor:[UIColor clearColor]];
	[accountLbl setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.signup"]];
    [accountLbl setTextColor:[UIColor whiteColor]];
	[accountLbl setFont:[UIFont boldSystemFontOfSize:13.0]];
	[viewTopBar addSubview:accountLbl];
	[accountLbl release];
	[viewTopBar release];
	
	NSArray *arrPasswordLblTxt=[NSArray arrayWithObjects:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.password"], [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.confirm"],nil];
	
	UILabel *lblPassword[2];
	
	int yAxis=16;
	
	toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake( 0, 160, 320, 40)];
	[toolBar setTintColor:[UIColor blackColor]];
	[toolBar setHidden:YES];
	[viewForRegistration addSubview:toolBar];
	
	UIBarButtonItem *btnDone=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignTextField)];
	UIBarButtonItem *flexiSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
	
	[toolBar setItems:[NSArray arrayWithObjects: flexiSpace,btnDone,nil]];
	[btnDone release];
	[flexiSpace release];
	
	for (int i=0; i<2; i++)
    {
		lblPassword[i] = [[UILabel alloc]initWithFrame:CGRectMake( 13, yAxis-1, 150,27)];
		[lblPassword[i] setBackgroundColor:[UIColor clearColor]];
		lblPassword[i].textColor=[UIColor darkGrayColor];
		lblPassword[i].font=[UIFont boldSystemFontOfSize:16.0];
		[lblPassword[i] setText:[arrPasswordLblTxt objectAtIndex:i]];
		[contentScrollView addSubview:lblPassword[i]];
		[lblPassword[i] release];
		
		txtPassword[i] = [[UITextField alloc] initWithFrame:CGRectMake(100, yAxis, 200,30)];
		[txtPassword[i] setBorderStyle:UITextBorderStyleRoundedRect];
		[txtPassword[i] setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[txtPassword[i] setDelegate:self];
		[txtPassword[i] setSecureTextEntry:YES];
		[txtPassword[i] setReturnKeyType:UIReturnKeyDone];
		[contentScrollView addSubview:txtPassword[i]];
		
		yAxis+=37;
	}
	
	UIView *viewbillingBar=[[UIView alloc]initWithFrame:CGRectMake(0, 88, 320, 30)];
    [viewbillingBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom_bar.png"]]];
    [contentScrollView addSubview:viewbillingBar];
    
    UILabel *lblBilling=[[UILabel alloc]initWithFrame:CGRectMake( 10, 5, 100, 20)];
	[lblBilling setBackgroundColor:[UIColor clearColor]];
	lblBilling.textColor=[UIColor whiteColor];
	[lblBilling setFont:[UIFont boldSystemFontOfSize:13.0]];
	[lblBilling setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.billing"]];
	[viewbillingBar addSubview:lblBilling];
	[lblBilling release];
    [viewbillingBar release];
	
	NSArray *arrBillingLblTxt=[NSArray arrayWithObjects:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.name"], [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.email"], [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.street"], [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.city"],[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.zip"], [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.country"], [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.state"],  nil];
	
	UILabel *lblBillingTxtSet[7];
	yAxis=124;
	
	for (int i=0; i<7; i++)
    {
		lblBillingTxtSet[i] = [[UILabel alloc]initWithFrame:CGRectMake(13, yAxis-1, 150, 30)];
		[lblBillingTxtSet[i] setBackgroundColor:[UIColor clearColor]];
		lblBillingTxtSet[i].textColor=[UIColor darkGrayColor];
		lblBillingTxtSet[i].font=[UIFont boldSystemFontOfSize:16.0];
		[lblBillingTxtSet[i] setText: [arrBillingLblTxt objectAtIndex:i]];
		[contentScrollView addSubview:lblBillingTxtSet[i]];
		[lblBillingTxtSet[i] release];
		
		txtBillingField[i] = [[UITextField alloc] initWithFrame:CGRectMake(100, yAxis, 200, 30)];
		[txtBillingField[i] setDelegate:self];
		[txtBillingField[i] setReturnKeyType:UIReturnKeyDone];
		[txtBillingField[i] setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[contentScrollView addSubview:txtBillingField[i]];
		
		if (i==6) 
		{
			[txtBillingField[i] setKeyboardType:UIKeyboardTypeDefault];
            [txtBillingField[i] setFrame:CGRectMake( 100, yAxis-73, 200, 30)];
            
		}
		else if (i==1)
        {
            [txtBillingField[i] setKeyboardType:UIKeyboardTypeEmailAddress];
        }
		else if (i==5)
		{
			[txtBillingField[i] setEnabled:NO];
			[txtBillingField[i] setFrame:CGRectMake(100, yAxis+37, 200, 30)];
			UIButton *btnShowPickerView = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnShowPickerView setFrame:txtBillingField[i].frame];
			[btnShowPickerView setBackgroundColor:[UIColor clearColor]];
			[btnShowPickerView setTag:5];
			[btnShowPickerView addTarget:self action:@selector(getPickerView:) forControlEvents:UIControlEventTouchUpInside];
			[contentScrollView addSubview:btnShowPickerView];
			[contentScrollView bringSubviewToFront:btnShowPickerView];
		}
		else if (i==4)
		{
			[txtBillingField[i] setEnabled:NO];
			
			[txtBillingField[i] setFrame:CGRectMake( 100, yAxis+37, 200, 30)];

			UIButton *btnShowPickerView = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnShowPickerView setFrame:txtBillingField[i].frame];
			[btnShowPickerView setBackgroundColor:[UIColor clearColor]];
			[btnShowPickerView setTag:1];
			[btnShowPickerView addTarget:self action:@selector(getPickerView:) forControlEvents:UIControlEventTouchUpInside];
			[contentScrollView addSubview:btnShowPickerView];
			[contentScrollView bringSubviewToFront:btnShowPickerView];
		}
		
		[txtBillingField[i] setBorderStyle:UITextBorderStyleRoundedRect];
		yAxis+=37;
	}
	
    btnSameAddress=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnSameAddress setBackgroundColor:[UIColor clearColor]];
	[btnSameAddress setFrame:CGRectMake(9, 383, 30, 30)];
	[btnSameAddress setImage:[UIImage imageNamed:@"box_tick.png"] forState:UIControlStateNormal];
	[btnSameAddress addTarget:self action:@selector(showDeliveryView) forControlEvents:UIControlEventTouchUpInside];
	[contentScrollView addSubview:btnSameAddress];
	
	UILabel *lblSameTxt=[[UILabel alloc]initWithFrame:CGRectMake(45, 388, 200, 20)];
	[lblSameTxt setBackgroundColor:[UIColor clearColor]];
	lblSameTxt.textColor=[UIColor grayColor];
	lblSameTxt.font=[UIFont boldSystemFontOfSize:12.0];
	[lblSameTxt setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.deliveryaddr"]];
	[contentScrollView addSubview:lblSameTxt];
	[lblSameTxt release];
	
	btnSubmit=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnSubmit setFrame:CGRectMake(200, 383, 99 , 34)];
	[btnSubmit layer].cornerRadius=5.0;
	[btnSubmit setTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.submit"] forState:UIControlStateNormal];
	[btnSubmit setBackgroundColor:navBarColor];
	[btnSubmit setBackgroundImage:[UIImage imageNamed:@"submit_btn.png"] forState:UIControlStateNormal];
	[btnSubmit addTarget:self action:@selector(createAccount) forControlEvents:UIControlEventTouchUpInside];
	[contentScrollView addSubview:btnSubmit];
    
	[self createDeliveryView];
}

// Creating Delivery View Controls
- (void)createDeliveryView
{
	deliveryView=[[UIView alloc]initWithFrame:CGRectMake( 0, 394, 320, 300)];
	[deliveryView setBackgroundColor:[UIColor clearColor]];
	[deliveryView setHidden:YES];
	[contentScrollView addSubview:deliveryView];
    
    UIView *viewDeliveryBar=[[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, 30)];
    [viewDeliveryBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom_bar.png"]]];
    [deliveryView addSubview:viewDeliveryBar];
    
    UILabel *lblDelivery=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 320, 20)];
	[lblDelivery setBackgroundColor:[UIColor clearColor]];
	lblDelivery.textColor=[UIColor whiteColor];
	[lblDelivery setFont:[UIFont boldSystemFontOfSize:13.0]];
	[lblDelivery setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.shoppingcart.delivery.add"]];
	[viewDeliveryBar addSubview:lblDelivery];
	[lblDelivery release];
    
    [viewDeliveryBar release];
	
	NSArray *arrDeliveryLblTxt=[NSArray arrayWithObjects: [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.street"], [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.city"],[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.zip"],  [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.country"], [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.state"], nil];
	
	UILabel *lblDeliveryTxtSet[5];
	
	int yAxis=60;
	
	for (int i=0; i<5; i++)
    {
		lblDeliveryTxtSet[i] = [[UILabel alloc]initWithFrame:CGRectMake(13, yAxis, 150, 30)];
		[lblDeliveryTxtSet[i] setBackgroundColor:[UIColor clearColor]];
		lblDeliveryTxtSet[i].textColor=[UIColor darkGrayColor];
		lblDeliveryTxtSet[i].font=[UIFont boldSystemFontOfSize:16.0];
		[lblDeliveryTxtSet[i] setText: [arrDeliveryLblTxt objectAtIndex:i]];
		[deliveryView addSubview:lblDeliveryTxtSet[i]];
		[lblDeliveryTxtSet[i] release];
		
		txtDeliveryField[i] = [[UITextField alloc] initWithFrame:CGRectMake(  100, yAxis, 200, 30)];
		[txtDeliveryField[i] setDelegate:self];
		[txtDeliveryField[i] setReturnKeyType:UIReturnKeyDone];
		[txtDeliveryField[i] setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[deliveryView addSubview:txtDeliveryField[i]];
		if (i==4) 
		{
			[txtDeliveryField[i] setKeyboardType:UIKeyboardTypeDefault];
			
            [txtDeliveryField[i] setFrame:CGRectMake(100, yAxis-73, 200, 30)];
            
			
		}
		else if (i==3)
		{
			[txtDeliveryField[i] setEnabled:NO];
			[txtDeliveryField[i] setFrame:CGRectMake( 100, yAxis+37, 200, 30)];
			UIButton *btnShowPickerView = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnShowPickerView setFrame:txtDeliveryField[i].frame];
			[btnShowPickerView setBackgroundColor:[UIColor clearColor]];
			[btnShowPickerView setTag:6];
			[btnShowPickerView addTarget:self action:@selector(getPickerView:) forControlEvents:UIControlEventTouchUpInside];
			[deliveryView addSubview:btnShowPickerView];
			[deliveryView bringSubviewToFront:btnShowPickerView];
		}
		else if (i==2)
		{
			[txtDeliveryField[i] setEnabled:NO];
			
			[txtDeliveryField[i] setFrame:CGRectMake( 100, yAxis+37, 200, 30)];
			UIButton *btnShowPickerView = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnShowPickerView setFrame:txtDeliveryField[i].frame];
			[btnShowPickerView setBackgroundColor:[UIColor clearColor]];
			[btnShowPickerView setTag:2];
			[btnShowPickerView addTarget:self action:@selector(getPickerView:) forControlEvents:UIControlEventTouchUpInside];
			[deliveryView addSubview:btnShowPickerView];
			[contentScrollView bringSubviewToFront:btnShowPickerView];
		}
		[txtDeliveryField[i] setBorderStyle:UITextBorderStyleRoundedRect];
		yAxis+=37;
	}
   
    if([arrayCountry count]>0)
	{
		NSString *strCountry=[GlobalPreferences getUserCountryFortax];
		if (!strCountry)
		{
			txtBillingField[4].text = [NSString stringWithFormat:@"%@", [[arrayCountry valueForKey:@"sCountry"]objectAtIndex:0]];
			txtDeliveryField[2].text = [NSString stringWithFormat:@"%@", [[arrayCountry valueForKey:@"sCountry"]objectAtIndex:0]];
		}
		else
		{
			txtBillingField[4].text =strCountry;
			txtDeliveryField[2].text=strCountry;
		}
	}
	if ([arrayStates count]>0)
	{
		txtBillingField[5].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:0]];
		txtDeliveryField[3].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:0]];
	}
}
- (void)showLoadingbar
{
	[GlobalPreferences addLoadingBar_AtBottom:self.tabBarController.view withTextToDisplay:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
}

- (void)hideBottombar
{
	[GlobalPreferences dismissLoadingBar_AtBottom];
}

// Called when submit button is tapped
- (void)createAccount
{   
	
    if (([txtPassword[0].text length]==0) || ([txtBillingField[0].text length]==0) || ([txtBillingField[1].text length]==0) || ([txtBillingField[2].text length]==0) || ([txtBillingField[3].text length]==0) || ([txtBillingField[4].text length]==0) || ([txtBillingField[5].text length]==0) || ([txtBillingField[6].text length]==0))
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.textfield.notempty.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else if(!([txtPassword[0].text isEqualToString:txtPassword[1].text]))
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.confirm.pass.notmatch.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        
    }	
    
    else if (![GlobalPreferences validateEmail:txtBillingField[1].text])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.invalid.email.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    else
    {
        if (!isDeliveryShown)
        {
            NSMutableArray *arrAccount = [[NSMutableArray alloc] init];
            arrAccount =[[SqlQuery shared] getAccountData:txtBillingField[1].text];
            if ([arrAccount count]==0)
            {
                if (!isCheckout || isWishlistLogin || isOrderLogin)
                {
                    if (!isAccount)
                    {
                        if (!isReview)
                        {
                            [self performSelectorInBackground:@selector(showLoadingbar) withObject:nil];	
                        }
                        
                    }
                }
                [[SqlQuery shared] setTblAccountDetails: txtBillingField[0].text : txtBillingField[1].text : txtPassword[0].text : txtBillingField[2].text : txtBillingField[3].text : txtBillingField[4].text : txtBillingField[5].text : txtBillingField[6].text : txtBillingField[2].text : txtBillingField[3].text : txtBillingField[4].text : txtBillingField[5].text : txtBillingField[6].text];
                
                [GlobalPreferences setUserDefault_Preferences:txtBillingField[1].text :@"userEmail"];
                
             
                [GlobalPreferences setUserDefault_Preferences:txtBillingField[1].text :@"userEmail"];
                NSDictionary *contentDict = [dicSettings objectForKey:@"store"];
                NSArray* arrTemp =[contentDict objectForKey:@"taxList"];
                NSArray *arrTempShippingCountries=[contentDict objectForKey:@"shippingList"];
                
                
                NSString *strCountryCode;
                for(int i=0;i<[arrTemp count];i++)
                {
                    if ([txtBillingField[4].text isEqualToString:[[arrTemp objectAtIndex:i]valueForKey:@"sCountry"]]) 
                    {
                        strCountryCode = [[arrTemp objectAtIndex:i] valueForKey:@"territoryId"];
    
                    }
                }
                for(int i=0;i<[arrTempShippingCountries count];i++)
                {
                    if ([txtBillingField[4].text isEqualToString:[[arrTempShippingCountries objectAtIndex:i]valueForKey:@"sCountry"]]) 
                    {
                        strCountryCode = [[arrTempShippingCountries objectAtIndex:i] valueForKey:@"territoryId"];
                    }
                }
                int CountryCode = [strCountryCode integerValue];
                
                [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",currentStateIdForDelivery] forKey:@"stateID"];
                [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",CountryCode] forKey:@"countryID"];
                [GlobalPreferences setPersonLoginStatus:YES];
                
                if (!isCheckout || isWishlistLogin || isOrderLogin)
                {
                    if (!isAccount)
                    {
                        isCheckout = YES;
                    }
                    else
                    {
                        isAccount = NO;
                    }
                    
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.email.already.exists.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            [arrAccount release];
        }
        else
        {
            if ([txtDeliveryField[0].text length]==0 || [txtDeliveryField[1].text length]==0 || [txtDeliveryField[2].text length]==0 || [txtDeliveryField[3].text length]==0 || [txtDeliveryField[4].text length]==0)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:@"Text Filed must not be empty" delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            else
            {
                NSMutableArray *arrAccount = [[NSMutableArray alloc] init];
                arrAccount =[[SqlQuery shared] getAccountData:txtBillingField[1].text];
                if ([arrAccount count]==0)
                {
                    if (!isCheckout || isWishlistLogin || isOrderLogin)
                    {
                        if (!isAccount)
                        {
                 
                        }
                    }
                    
                    
                    [[SqlQuery shared] setTblAccountDetails:txtBillingField[0].text : txtBillingField[1].text : txtPassword[0].text : txtBillingField[2].text : txtBillingField[3].text : txtBillingField[4].text : txtBillingField[5].text : txtBillingField[6].text : txtDeliveryField[0].text : txtDeliveryField[1].text : txtDeliveryField[2].text : txtDeliveryField[3].text : txtDeliveryField[4].text];
                    
                    [GlobalPreferences setUserDefault_Preferences:txtBillingField[1].text :@"userEmail"];
                    NSDictionary *contentDict = [dicSettings objectForKey:@"store"];
                    NSArray* arrTemp =[contentDict objectForKey:@"taxList"];
                    NSArray *arrTempShippingCountries=[contentDict objectForKey:@"shippingList"];
                    
                    
                    NSString *strCountryCode;
                    for(int i=0;i<[arrTemp count];i++)
                    {
                        
                        if ([txtDeliveryField[2].text isEqualToString:[[arrTemp objectAtIndex:i]valueForKey:@"sCountry"]]) 
                        {
                            strCountryCode = [[arrTemp objectAtIndex:i] valueForKey:@"territoryId"];
                           
                        }
                        
                    }
                    for(int i=0;i<[arrTempShippingCountries count];i++)
                    {
                        if ([txtDeliveryField[2].text isEqualToString:[[arrTempShippingCountries objectAtIndex:i]valueForKey:@"sCountry"]]) 
                        {
                            strCountryCode = [[arrTempShippingCountries objectAtIndex:i] valueForKey:@"territoryId"];
                            
                        }
                        
                    }
                    int CountryCode = [strCountryCode integerValue];
                    
                    
                    
                    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",currentStateIdForDelivery] forKey:@"stateID"];
                    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",CountryCode] forKey:@"countryID"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutNotification" object:self];
                    
                    if (!isCheckout || isWishlistLogin || isOrderLogin)
                    {
                        if (!isAccount)
                        {
                            isCheckout = YES;
                        }
                        else
                        {
                            isAccount = NO;
                        }
                        
                        [self.navigationController popViewControllerAnimated:NO];
                    }
                    else
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.email.already.exists.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
                [arrAccount release];
            }
        }
    }
	
	
	isReview=NO;
}

// Called when checkbox-"Same Delivery Address" is tapped And Unhide Delivery Address View
- (void)showDeliveryView
{
	if (!isDeliveryShown)
	{
      [deliveryView setHidden:NO];
		[contentScrollView setContentSize:CGSizeMake(320,850)];
		[btnSameAddress setImage:[UIImage imageNamed:@"block.png"] forState:UIControlStateNormal];
		isDeliveryShown=YES;
		[btnSubmit setFrame:CGRectMake(  100,643,99,34)];
		[contentScrollView bringSubviewToFront:btnSubmit];
		
		if ([arrayCountry count]>0)
		{
			NSString *strCountry=[GlobalPreferences getUserCountryFortax];
			if (!strCountry)
            {
                txtDeliveryField[2].text = [NSString stringWithFormat:@"%@", [[arrayCountry valueForKey:@"sCountry"]objectAtIndex:rowValue]];
               
                
            }
			else
            {
                txtDeliveryField[2].text=strCountry;	
            }
		}
		if ([arrayStates count]>0)
        {
            txtDeliveryField[3].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:0]];
            
        }
	}
	else
	{  
		[deliveryView setHidden:YES];
		[contentScrollView setContentSize:CGSizeMake(320,580)];
		isDeliveryShown=NO;
		[btnSameAddress setImage:[UIImage imageNamed:@"box_tick.png"] forState:UIControlStateNormal];
        [btnSubmit setFrame:CGRectMake( 200, 383, 99 , 34)];
	}
}

// Called when Country/State textfield is tapped
- (void)getPickerView:(id)sender
{
  	if ([sender tag]<5)
	{
		if (([sender tag] == 2) || ([sender tag] == 4))
        {
            isDeliveryCountries = TRUE;
        }
		else 
        {
			isDeliveryCountries = FALSE;
		}
		if ([arrayCountry count]>0)
		{
			if ([sender tag]==1||[sender tag]==3)
            {
                selectPicker=NO;
            }
			else
            {
                selectPicker=YES;
            }
			
			for (int i=0; i<5; i++)
			{
				if (i<2)
                {
					[txtPassword[i] setEnabled:NO];
                }
				
				if (i<4)
				{
					[txtDeliveryDetails[i] setEnabled:NO];
					[txtDeliveryField[i] setEnabled:NO];
				}
				[txtBillingField[i] setEnabled:NO];
				[txtDetails[i] setEnabled:NO];
			}
			isStatesToBeReloaded=YES;
			[self setStatesCountry];
			[pickerViewCountry setHidden:NO];
            if(!isEditMode){
            if([sender tag]==1)
            {
                if([txtBillingField[4].text length] != 0)
                {
                    [pickerViewCountry selectRow:[[arrayCountry valueForKey:@"sCountry"] indexOfObject:txtBillingField[4].text] inComponent:0 animated:YES];
                }
            }
            else
            {
                if([txtDeliveryField[2].text length] != 0)
                {
                    [pickerViewCountry selectRow:[[arrayCountry valueForKey:@"sCountry"] indexOfObject:txtDeliveryField[2].text] inComponent:0 animated:YES];
                }
            }
            }else 
            {
                if([sender tag]==3)
                {
                    if([txtDetails[3].text length] != 0)
                    {
                        [pickerViewCountry selectRow:[[arrayCountry valueForKey:@"sCountry"] indexOfObject:txtDetails[3].text] inComponent:0 animated:YES];
                    }
                }
                else
                {
                    if([txtDeliveryDetails[2].text length] != 0)
                    {
                        [pickerViewCountry selectRow:[[arrayCountry valueForKey:@"sCountry"] indexOfObject:txtDeliveryDetails[2].text] inComponent:0 animated:YES];
                    }
                }

            }
			[toolBar setHidden:NO];
			[contentView bringSubviewToFront:pickerViewCountry];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nocountry.avail.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
	else
	{
		isStatesToBeReloaded=NO;
        
		if ([arrayStates count]>0)
		{
			if ([sender tag]==5 || [sender tag]==7)
            { isfromTag=1;
                if(!isEditMode){
                  
                    [self getStatesOfaCountry:[txtBillingField[4] text]];
                }else{
                    [self getStatesOfaCountry:[txtDetails[3] text]]; 
                   

                    
                    
                }
				
                
                selectPicker=YES;
            }
			else if([sender tag]==8)
			{  isfromTag=0;
                
				[self getStatesOfaCountry:[txtDeliveryDetails[2] text]];
                
                
				selectPicker=YES;
			}
			else
            {
               
                isfromTag=0;
                if(!isEditMode){
                    [self getStatesOfaCountry:txtDeliveryField[2].text]; 
                }
				
                selectPicker=YES;
            }
            
			for (int i=0; i<5; i++)
			{
				if (i<2)
                {
                    [txtPassword[i] setEnabled:NO];
                }				
				if (i<4)
				{
					[txtDeliveryDetails[i] setEnabled:NO];
					[txtDeliveryField[i] setEnabled:NO];
				}
                
				[txtBillingField[i] setEnabled:NO];
				[txtDetails[i] setEnabled:NO];
			}
			
			[self setStatesCountry];
            
            
                        
            
            
            
            
			[pickerViewStates setHidden:NO];
			[toolBar setHidden:NO];
			[contentView bringSubviewToFront:pickerViewStates];
        }
		else
		{
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nostate.avail.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
}

// Called to get the states and countries defined for the store
- (void)getStatesOfaCountry:(NSString*)strCountryVal
{
    dicSettings = [GlobalPreferences getSettingsOfUserAndOtherDetails];
	NSDictionary *contentDict = [dicSettings objectForKey:@"store"];
	NSArray* arrTemp =[contentDict objectForKey:@"taxList"];
	NSArray *arrTempShippingCountries=[contentDict objectForKey:@"shippingList"];
	[arrayStates removeAllObjects];
	
	int CountryCode ;
	if ([strCountryVal length]>0)
	{
		NSString *strCountry=strCountryVal;
		NSString *strCountryCode;
		for(int i=0;i<[arrTemp count];i++)
		{
			
			if ([strCountry isEqualToString:[[arrTemp objectAtIndex:i]valueForKey:@"sCountry"]]) 
			{
				strCountryCode = [[arrTemp objectAtIndex:i] valueForKey:@"territoryId"];
            }
			
		}
		for(int i=0;i<[arrTempShippingCountries count];i++)
		{
			if ([strCountry isEqualToString:[[arrTempShippingCountries objectAtIndex:i]valueForKey:@"sCountry"]]) 
			{
				strCountryCode = [[arrTempShippingCountries objectAtIndex:i] valueForKey:@"territoryId"];
				
			}
			
		}
		CountryCode = [strCountryCode integerValue];
	}
	else {
		CountryCode = currentCountryIdForDelivery ;
	}
    
    if (selectPicker) {
        currentCountryIdForDelivery = CountryCode;
    }
	
	
	
	for(int index=0;index<[arrTemp count];index++)
	{
		if(CountryCode==[[[arrTemp valueForKey:@"territoryId"]objectAtIndex:index]intValue])
		{
			[arrayStates  addObject:[arrTemp objectAtIndex:index]];
		}
	}
	
	for(int index=0;index<[arrTempShippingCountries count];index++)
	{
		if (CountryCode==[[[arrTempShippingCountries valueForKey:@"territoryId"]objectAtIndex:index]intValue])
		{
			if (![[arrayStates valueForKey:@"sState"] containsObject:[[arrTempShippingCountries valueForKey:@"sState"]objectAtIndex:index]])
            {
                [arrayStates  addObject:[arrTempShippingCountries objectAtIndex:index]];
            }
		}
	}
	
    
	
	[pickerViewStates reloadAllComponents];
	[pickerViewStates selectRow:0 inComponent:0 animated:YES];
    
	}

// Called when Done is tapped for resigning pickerviews and textfields
- (void)resignTextField
{
	[btnSubmit setEnabled:YES];
	UIButton *btnPicker[8];
	
	for(int i=0; i<8; i++)
	{
		btnPicker[i]  = (UIButton *)[contentScrollView viewWithTag:i+1];
		btnPicker[i].enabled = YES;
	}
	NSMutableArray *arrInfo=[[NSMutableArray alloc]init];
	arrInfo=[[SqlQuery shared] getAccountData:[GlobalPreferences getUserDefault_Preferences:@"userEmail"]];
	for(int i=0; i<=6; i++)
	{
		if(i<2)
			[txtPassword[i] setEnabled:YES];
		
		if(i<4)
		{
			[txtDeliveryDetails[i] setEnabled:YES];
			[txtDeliveryField[i] setEnabled:YES];
		}
		[txtBillingField[i] setEnabled:YES];
		
		if([arrInfo count]>0)
		{
			if(i!=0)
				[txtDetails[i] setEnabled:YES];
		}
		else {
			[txtDetails[i] setEnabled:YES];
		}
		
	}
	[arrInfo release];
    
	[txtBillingField[6] resignFirstResponder];
	[txtDeliveryField[4] resignFirstResponder];
	[txtDetails[5] resignFirstResponder];
	[txtDeliveryDetails[4] resignFirstResponder];
	[toolBar setHidden:YES];
	[pickerViewCountry setHidden:YES];
    
	[pickerViewStates setHidden:YES];
}

// Called when user taps Login on Alert Box
- (void)displayViewForLogin
{
	UIView *viewTopBar=[[UIView alloc]initWithFrame:CGRectMake(0,-2, 320, 42)];
	[viewTopBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom_bar.png"]]];
	
	[viewForLogin addSubview:viewTopBar];
	
	UILabel *accountLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 310, 30)];
	[accountLbl setBackgroundColor:[UIColor clearColor]];
	[accountLbl setTextColor:[UIColor whiteColor]];
	[accountLbl setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.loginto.account"]];
	[accountLbl setFont:[UIFont boldSystemFontOfSize:13]];
	[viewTopBar addSubview:accountLbl];
	[accountLbl release];
	
	[viewTopBar release];
	
	UILabel *lblEmail = [[UILabel alloc]initWithFrame:CGRectMake( 20, 70, 150, 30)];
	[lblEmail setBackgroundColor:[UIColor clearColor]];
	lblEmail.textColor=[UIColor darkGrayColor];
	lblEmail.font=[UIFont boldSystemFontOfSize:16.0];
	[lblEmail setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.email"]];
	[viewForLogin addSubview:lblEmail];
	[lblEmail release];
	
	txtEmailForLogin = [[UITextField alloc] initWithFrame:CGRectMake(110, 70,190,30)];
	[txtEmailForLogin setBorderStyle:UITextBorderStyleRoundedRect];
	[txtEmailForLogin setDelegate:self];
	[txtEmailForLogin setKeyboardType:UIKeyboardTypeEmailAddress];
	[txtEmailForLogin setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[txtEmailForLogin setReturnKeyType:UIReturnKeyDone];
	[viewForLogin addSubview:txtEmailForLogin];
	
	UILabel *lblPassword = [[UILabel alloc]initWithFrame:CGRectMake( 20, 110, 150, 30)];
	[lblPassword setBackgroundColor:[UIColor clearColor]];
	lblPassword.textColor=[UIColor darkGrayColor];
	lblPassword.font=[UIFont boldSystemFontOfSize:16.0];
	[lblPassword setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.signup.password"]];
	[viewForLogin addSubview:lblPassword];
	[lblPassword release];
	
	txtPasswordForLogin = [[UITextField alloc] initWithFrame:CGRectMake(110, 110,190,30)];
	[txtPasswordForLogin setBorderStyle:UITextBorderStyleRoundedRect];
	[txtPasswordForLogin setDelegate:self];
	[txtPasswordForLogin setSecureTextEntry:YES];
	txtPasswordForLogin.autocorrectionType = UITextAutocorrectionTypeNo;
	[txtPasswordForLogin setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [txtPasswordForLogin setReturnKeyType:UIReturnKeyDone];
	[viewForLogin addSubview:txtPasswordForLogin];
	
	UIButton *btnLogin=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnLogin setFrame:CGRectMake( 110, 150,190,40)];
	[btnLogin addTarget:self action:@selector(methodLogin) forControlEvents:UIControlEventTouchUpInside];
	[btnLogin.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
	[btnLogin setBackgroundColor:navBarColor];
	[btnLogin setBackgroundImage:[UIImage imageNamed:@"loginButton.png"] forState:UIControlStateNormal];
	[btnLogin setTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.loginto.account"] forState:UIControlStateNormal];
	[btnLogin layer].cornerRadius=5.0;
    
	[viewForLogin addSubview:btnLogin];
	
	UIButton *btnCreateLogin=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnCreateLogin setFrame:CGRectMake(110, 200,190,40)];
	[btnCreateLogin setTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.create.account"] forState:UIControlStateNormal];
	[btnCreateLogin.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
	[btnCreateLogin setBackgroundColor:navBarColor];
	[btnCreateLogin layer].cornerRadius=5.0;
    
	[btnCreateLogin setBackgroundImage:[UIImage imageNamed:@"loginButton.png"] forState:UIControlStateNormal];
	[btnCreateLogin addTarget:self action:@selector(btnCreateAccount_Clicked) forControlEvents:UIControlEventTouchUpInside];
	[viewForLogin addSubview:btnCreateLogin];
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{    
	if (alertView==alertView1)
	{
		if (!isCheckout||isWishlistLogin || isOrderLogin)
		{
			if (!isAccount)
            {
                isCheckout = YES;
            }
			else
            {
                isAccount = NO;
            }
			
			if ([txtEmailForLogin isFirstResponder])
            {
                [txtEmailForLogin resignFirstResponder];
            }
            
			if ([txtPasswordForLogin isFirstResponder])
            {
                [txtPasswordForLogin resignFirstResponder];
            }
	    }
        
		[self.navigationController popViewControllerAnimated:NO];
    }
	
	else if (alertView == alertMain)
	{
		switch (buttonIndex) 
        {
			case 0:
				if (!isCheckout)
                {
                    isLoadingTableFooter = TRUE;
                }
                
				isWishlistLogin = NO;
				isOrderLogin = NO;
				[self.navigationController popViewControllerAnimated:YES];
				break;
                
			case 1:
				[self displayViewForLogin];
				[self animationForViews:viewForLogin :viewForRegistration];
				break;
                
			case 2:
				[self displayViewForRegistration];
				[self animationForViews:viewForRegistration :viewForLogin];
				break;
                
			default:
				break;
		}
	}
}

// Called when Login button on alert Box is tapped
- (void)methodLogin
{
	NSString *strPassword = [[SqlQuery shared]getPassword:txtEmailForLogin.text];
	
	if (![GlobalPreferences validateEmail:txtEmailForLogin.text])
	{
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.invalid.email.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
        [alertView show];
        [alertView release];
	}
	else if ([txtEmailForLogin.text length]==0 || [txtPasswordForLogin.text length]==0)
	{
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.textfield.notempty.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
        [alertView show];
        [alertView release];
	}
	else
	{
		if ([strPassword isEqualToString:[NSString stringWithFormat:@""]])
		{
			UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.account.notfound.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			[alertView show];
			[alertView release];
			
		}
		else
		{
			if ([strPassword isEqualToString:txtPasswordForLogin.text])
			{
				alertView1=[[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.login.sucess.title"] message:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.login.sucess.text"] delegate:self cancelButtonTitle:nil  otherButtonTitles:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"],nil];
                [alertView1 show];
				
				
				
				[GlobalPreferences setUserDefault_Preferences:txtEmailForLogin.text :@"userEmail"];
				[GlobalPreferences setPersonLoginStatus:YES];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutNotification" object:self];
			}
			else
			{
				UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.password.notcorrect.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
				[alertView show];
				[alertView release];
			}
		}
	}
}

// Animations on switching from multiple views in create account section
- (void)animationForViews:(UIView *) viewToShow :(UIView *)viewToHide
{
	viewToShow.hidden = NO;
	[contentView bringSubviewToFront:viewToShow];
	viewToHide.hidden = YES;
}

// Called when Create Account is tapped from Login Section
- (void)btnCreateAccount_Clicked
{
	[self animationForViews:viewForRegistration :viewForLogin];
	[self displayViewForRegistration];
}

#pragma mark Text Field Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	[btnSubmit setEnabled:YES];
	UIButton *btnPicker[8];
	for (int i=0; i<8; i++)
	{
		btnPicker[i]  = (UIButton *)[contentScrollView viewWithTag:i+1];
		btnPicker[i].enabled = YES;
	}
	[toolBar setHidden:YES];
	[textField resignFirstResponder];
	[contentScrollView setContentOffset:svos animated:YES];
	
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	[btnSubmit setEnabled:NO];
	if (textField==txtBillingField[6] || textField==txtDeliveryField[4] || textField==txtDetails[5] || textField==txtDeliveryDetails[4])
	{
		UIButton *btnPicker[8];
		
		for(int i=0; i<8; i++)
		{
			btnPicker[i]  = (UIButton *)[contentScrollView viewWithTag:i+1];
			btnPicker[i].enabled = NO;
		}
		[toolBar setHidden:NO];
	}
	else
	{
		[toolBar setHidden:YES];
	}
	
	svos = contentScrollView.contentOffset;
	CGPoint pt;
	CGRect rc = [textField bounds];
	rc = [textField convertRect:rc toView:contentScrollView];
	pt = rc.origin;
	pt.x = 0;
	pt.y -= 60;
	
	[contentScrollView setContentOffset:pt animated:YES];
	
	return YES;
}

#pragma mark Picker View Delegates method

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView 
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
	if (thePickerView == pickerViewStates)
    {
        return [arrayStates count];
    }
    
	return [arrayCountry count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
	if (thePickerView == pickerViewStates)
    {
        return [[arrayStates valueForKey:@"sState"]objectAtIndex:row];
    }
    
    return [[arrayCountry valueForKey:@"sCountry"]objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component 
{
	currentSelectedRow=row;
    
    
	if (thePickerView == pickerViewCountry)
	{
			
		if (!selectPicker)
        {
            txtBillingField[4].text = [NSString stringWithFormat:@"%@", [[arrayCountry valueForKey:@"sCountry"]objectAtIndex:row]];
        }
		else
        {
            if(isDeliveryShown)
              {
            if(!isEditMode){
                
                
                txtDeliveryField[2].text = [NSString stringWithFormat:@"%@", [[arrayCountry valueForKey:@"sCountry"]objectAtIndex:row]];  
            }
         }
            
        }
		
		if (txtDeliveryDetails[2])
		{
			if (!selectPicker)
            {
                txtDetails[3].text = [NSString stringWithFormat:@"%@", [[arrayCountry valueForKey:@"sCountry"]objectAtIndex:row]];
            }
			else
            {
                txtDeliveryDetails[2].text = [NSString stringWithFormat:@"%@", [[arrayCountry valueForKey:@"sCountry"]objectAtIndex:row]];
            }
		}
		rowValue = row;
		[self setStates];
	}
	else
	{
		if (!selectPicker)
		{
			if ([arrayStates count]>0)
			{
				if (isDeliveryShown==NO && [arrInfoAccount count]==0)
                {
                    currentStateIdForDelivery=[[[arrayStates valueForKey:@"stateId"]objectAtIndex:row]intValue];
                }
                
				txtBillingField[5].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:row]];
			}
		}
		else
		{
			if ([arrayStates count]>0)
			{     if(isDeliveryShown)
                    {   
                        if(isfromTag==1)
                        {
                            txtBillingField[5].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:row]]; 
                            
   
                        }else
                        {
                            txtDeliveryField[3].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:row]];
                            
  
                        }
                       
                                                                         
                
                       }else{
                     if(!isEditMode)
                         {
                       txtBillingField[5].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:row]];      
                    txtDeliveryField[3].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:row]];
                             
                    currentStateIdForDelivery=[[[arrayStates valueForKey:@"stateId"]objectAtIndex:row]intValue];
                    
                         }
            }
			}
		}
		if (txtDeliveryDetails[4])
		{
			if (!selectPicker)
			{
				if ([arrayStates count]>0)
                {
                    txtDetails[4].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:row]];
                }
			}
			else
			{
				if ([arrayStates count]>0)
                {
                    if(!isEditMode){
                    
                    
                    txtDeliveryDetails[3].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:row]];
					currentStateIdForDelivery=[[[arrayStates valueForKey:@"stateId"]objectAtIndex:row]intValue];
                    }else{
                        if(isfromTag==1)
                        {
                           txtDetails[4].text  = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:row]]; 
                            
                            
                        }else
                        {
                            txtDeliveryDetails[3].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:row]];
                            
                            
                        } 
                        
                    }
                }
				
			}
		}
	}
}

// Set states/ country in respective textfields when seected from picker view
- (void)setStates
{
	[arrayStates removeAllObjects];
	
	for(int i=0; i<[interShippingDict count]; i++)
	{
		if ([[[arrayCountry valueForKey:@"sCountry"]objectAtIndex:rowValue] isEqualToString:[NSString stringWithFormat:@"%@", [[interShippingDict objectAtIndex:i] valueForKey:@"sCountry"]]])
        {
            [arrayStates addObject:[interShippingDict objectAtIndex:i]];
        }
	}
	
	NSMutableArray *arrTempComp=[[NSMutableArray alloc]init];
	NSDictionary *contentDict = [dicSettings objectForKey:@"store"];
	arrTempComp=[contentDict valueForKey:@"taxList"];
	
	for(int i=0; i<[arrTempComp count]; i++)
	{
		if ([[[arrayCountry valueForKey:@"sCountry"]objectAtIndex:rowValue] isEqualToString:[NSString stringWithFormat:@"%@", [[arrTempComp objectAtIndex:i] valueForKey:@"sCountry"]]])
		{
			if (![[arrayStates valueForKey:@"sState"]containsObject:[[arrTempComp objectAtIndex:i]valueForKey:@"sState"]])
            {
                [arrayStates addObject:[arrTempComp objectAtIndex:i]];
            }
		}
	}
	if(!DETAILSPRESENT)
	{
		if(!isDeliveryShown) {
			currentStateIdForDelivery=[[[arrayStates valueForKey:@"stateId"]objectAtIndex:0]intValue];
		}
	}
	
	else if (selectPicker) {
		currentStateIdForDelivery=[[[arrayStates valueForKey:@"stateId"]objectAtIndex:0]intValue];
	}
	
    
	
	isLoadingFirstTime=NO;
	[arrayStates retain];
	
	if (!selectPicker)
	{	
		if ([arrayStates count]>0)
        {
            txtBillingField[5].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:0]];
			
            
			
			
        }
	}
	else
	{
		if ([arrayStates count]>0)
        {
            txtDeliveryField[3].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:0]];
            
            
		}
	}
	if (txtDeliveryDetails[4])
	{
		if (!selectPicker)
		{
			if ([arrayStates count]>0)
            {
                txtDetails[4].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:0]];
            }
		}
		else
		{
			if ([arrayStates count]>0)
            {
                txtDeliveryDetails[3].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:0]];
            }
		}
		if(!DETAILSPRESENT)
		{
			if(!isDeliveryShown) {
				currentStateIdForDelivery=[[[arrayStates valueForKey:@"stateId"]objectAtIndex:0]intValue];
			}
		}
		
		else if (selectPicker) {
			currentStateIdForDelivery=[[[arrayStates valueForKey:@"stateId"]objectAtIndex:0]intValue];
		}
		
        
	}
	[pickerViewStates reloadAllComponents];
	
}

// Called to set states and countries from picker view
- (void)setStatesCountry
{
    [pickerViewStates reloadAllComponents];
	
}

- (void)viewWillDisappear:(BOOL)animated
{
	
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	for(int i=0; i<7; i++)
	{
		if (i<5)
		{
			if (lblDeliveryDetails[i])
			{
				[lblDeliveryDetails[i] release];
				lblDeliveryDetails[i]=nil;
			}
            
			if (txtDeliveryDetails[i])
			{
				[txtDeliveryDetails[i] release];
				txtDeliveryDetails[i]=nil;
			}
            
			if (txtDeliveryField[i])
            {
                [txtDeliveryField[i] release];
            }
            
		}
		if (i<2)
		{
			if (txtPassword[i])
            {
                [txtPassword[i] release];
            }
		}
		
		if (txtBillingField[i])
        {
            [txtBillingField[i] release];
        }
		
		if (lblDetails[i])
		{
			[lblDetails[i] release];
			lblDetails[i]=nil;
		}
        
		if (txtDetails[i])
		{
			[txtDetails[i] release];
			txtDetails[i]=nil;
		}
	}
    
	if (alertMain)
    {
        [alertMain release];
    }
	
	if (deliveryView)
    {
        [deliveryView release];
    }
	
	if (toolBar)
    {
        [toolBar release];
    }
	
	if (contentScrollView)
    {
        [contentScrollView release];
    }
	
	if (viewForRegistration)
    {
        [viewForRegistration release];
    }
	
	if (viewForLogin)
    {
        [viewForLogin release];
    }
	
	[interShippingDict release];
	[arrayStates release];
	[arrayCountry release];
	selectPicker=NO;
	[pickerViewCountry release];
	[pickerViewStates release];
	[alertView1 release];
	
    [super dealloc];
}


@end
