//
//  DetailsViewController.m
//  MobiCart
//
//  Copyright Mobicart. All rights reserved.
//

#import "DetailsViewController.h"
#import "Constants.h"

BOOL isDeliveryShown;
BOOL selectPicker;
BOOL isEditMode=false;
int rowValue;
extern BOOL isRegisterClicked;
extern BOOL isLoginClicked;
extern BOOL isWishlistLogin;
extern BOOL isOrderLogin;
extern BOOL isAccount;
BOOL isLoadingTableFooter;
int isfromTag;
@implementation DetailsViewController
@synthesize viewForLogin, viewForRegistration;
@synthesize alertMain,isReview,pickerViewCountry,pickerViewStates;
@synthesize isFromPostReview;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */
-(void)btnShoppingCart_Clicked
{
	if(iNumOfItemsInShoppingCart > 0)
		[NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
	ShoppingCartViewController *objShopping = [[ShoppingCartViewController alloc] init];
	[[GlobalPrefrences getCurrentNavigationController]pushViewController:objShopping animated:YES];
	[objShopping release];
	
}
-(void)showLoading
{
	[GlobalPrefrences addLoadingBar_AtBottom:self.tabBarController.view withTextToDisplay:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
}
-(void)viewWillAppear:(BOOL)animated
{
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateLabelAccount" object:nil];
	isLoadingTableFooter = NO;
	isEditMode=false;
}

-(void)hideLoadingView
{
	[GlobalPrefrences dismissLoadingBar_AtBottom];	
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[NSTimer scheduledTimerWithTimeInterval:0.03
									 target:self
								   selector:@selector(hideLoadingView)
								   userInfo:nil
									repeats:NO];
	isLoadingFirstTime=YES;
	
	
	contentView=[[UIView alloc]initWithFrame:CGRectMake( 0, 0, 420, 760)];
	contentView.backgroundColor = [UIColor clearColor];
	self.view=contentView;
	
	UIButton *	btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
	btnCart.frame = CGRectMake(340, 13, 78,34);
	[btnCart setBackgroundColor:[UIColor clearColor]];
	[btnCart setTag:23456];
	[btnCart setImage:[UIImage imageNamed:@"add_cart.png"] forState:UIControlStateNormal];
	[btnCart addTarget:nextController action:@selector(btnShoppingCart_Clicked) forControlEvents:UIControlEventTouchUpInside];
	[contentView addSubview:btnCart];
	
	lblCart = [[UILabel alloc] initWithFrame:CGRectMake(42, 2, 30, 30)];
	lblCart.backgroundColor = [UIColor clearColor];
	lblCart.textAlignment = UITextAlignmentCenter;
	lblCart.font = [UIFont boldSystemFontOfSize:16];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	lblCart.textColor = [UIColor whiteColor];	 
	[btnCart addSubview:lblCart];
	
	
	viewForRegistration = [[UIView alloc]initWithFrame:CGRectMake( -10, 40, 320, 760)];
	viewForRegistration.backgroundColor = [UIColor clearColor];
	viewForRegistration.hidden = TRUE;
	[contentView addSubview:viewForRegistration];
	
	viewForLogin =  [[UIView alloc]initWithFrame:CGRectMake(-10, 40, 320, 400)];
	viewForLogin.hidden = TRUE;
	viewForLogin.backgroundColor = [UIColor clearColor];
	[contentView addSubview:viewForLogin];
	
	
	
	
	arrInfoAccount=[[NSMutableArray alloc]init];
	arrInfoAccount=[[SqlQuery shared] getAccountData:[GlobalPrefrences getUserDefault_Preferences:@"userEmail"]];
    
	isLoginByCheckOut = NO;
	if([arrInfoAccount count]==0)
	{
		DETAILSPRESENT=NO;
		if(isLoginClicked)
		{
			[btnCart setHidden:YES];
			isLoginClicked = NO;
			isLoginByCheckOut = YES;
			[self displayViewForLogin];
			[self animationForViews:viewForLogin :viewForRegistration];
		}
		else if(isRegisterClicked)
		{
			[btnCart setHidden:YES];
			isLoginByCheckOut = YES;
			isRegisterClicked = NO;
            [self createPickerView];
			[self displayViewForRegistration];
            
			[self animationForViews:viewForRegistration :viewForLogin];
		}
		else {
			isLoginByCheckOut = NO;
			alertMain = [[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.account.info"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.must.login"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.cancel"] otherButtonTitles:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.loginto.account"],[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.create.account"],nil];
		    [alertMain show];
		}
	}
	else
	{
		DETAILSPRESENT=YES;
		if(isLoginClicked)
		{
			[btnCart setHidden:YES];
			isLoginClicked = NO;
			isLoginByCheckOut = YES;
			[self displayViewForLogin];
			[self animationForViews:viewForLogin :viewForRegistration];
		}
		else if(isRegisterClicked)
		{
			[btnCart setHidden:YES];
			isLoginByCheckOut = YES;
			isRegisterClicked = NO;
			[self AccountInfoToEdit];
		}
		else
			isLoginByCheckOut = NO;
		[self AccountInfoToEdit];
	}
	
	
}
-(void)AccountInfoToEdit
{
	
	[arrInfoAccount removeAllObjects];
	arrInfoAccount=[[SqlQuery shared] getAccountData:[GlobalPrefrences getUserDefault_Preferences:@"userEmail"]];
	contentScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake( 0, 60, 420, 600)];
	[contentScrollView setBackgroundColor:[UIColor clearColor]];
	[contentScrollView setContentSize:CGSizeMake( 420, 600)];
	[contentView addSubview:contentScrollView];
	
	UIView *viewTopBar=[[UIView alloc]initWithFrame:CGRectMake(0,40, 420, 40)];
	[contentView addSubview:viewTopBar];		
	
	UILabel *accountLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, -18, 410, 20)];
	[accountLbl setBackgroundColor:[UIColor clearColor]];
	[accountLbl setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.account.info"]];
	accountLbl.textColor=headingColor;
	[accountLbl setFont:[UIFont boldSystemFontOfSize:15]];
	[viewTopBar addSubview:accountLbl];
	[accountLbl release];
	UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 11, 426,2)];
	[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
	[viewTopBar addSubview:imgHorizontalDottedLine];
	[imgHorizontalDottedLine release];
	[viewTopBar release];
	
	NSArray *arrDetailLbl=[NSArray arrayWithObjects:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.email"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.street"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.city"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.zip"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.country"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.state"], nil];
	
	int yAxis=40;
	for (int i=0; i<6; i++) {
		
		lblDetails[i] = [[UILabel alloc]initWithFrame:CGRectMake( 3, yAxis, 150, 30)];
		[lblDetails[i] setBackgroundColor:[UIColor clearColor]];
		lblDetails[i].textColor=subHeadingColor;
		lblDetails[i].font=[UIFont systemFontOfSize:14];
		[lblDetails[i] setText:[arrDetailLbl objectAtIndex:i]];
		[contentScrollView addSubview:lblDetails[i]];
		[lblDetails[i] release];
		
		txtDetails[i] = [[UITextField alloc] initWithFrame:CGRectMake( 90, yAxis, 210, 28)];
		[txtDetails[i] setBorderStyle:UITextBorderStyleRoundedRect];
		[txtDetails[i] setDelegate:self];
		[txtDetails[i] setEnabled:NO];
		[contentScrollView addSubview:txtDetails[i]];
		
		if([arrInfoAccount count]!=0)
			txtDetails[i].text = [arrInfoAccount objectAtIndex:i];
		
		if(i==5)
		{
            [txtDetails[i] setFrame:CGRectMake( 90, yAxis-66, 210, 28)];
            txtDetails[i].text = [arrInfoAccount objectAtIndex:4];
			
			
		}else if(i==0)
			[txtDetails[i] setKeyboardType:UIKeyboardTypeEmailAddress];
		else if(i==3)
		{
			[txtDetails[i] setEnabled:NO];
			
			[txtDetails[i] setFrame:CGRectMake( 90, yAxis+33, 210, 28)];	
           
            txtDetails[i].text = [arrInfoAccount objectAtIndex:5];
			btnShowPickerViewState = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnShowPickerViewState setFrame:txtDetails[i].frame];
			[btnShowPickerViewState setBackgroundColor:[UIColor clearColor]];
			[btnShowPickerViewState setTag:3];
			[btnShowPickerViewState setEnabled:NO];
			[btnShowPickerViewState addTarget:self action:@selector(getPickerView:) forControlEvents:UIControlEventTouchUpInside];
			[contentScrollView addSubview:btnShowPickerViewState];
			[contentScrollView bringSubviewToFront:btnShowPickerViewState];
			
		}
		else if(i==4)
		{
			[txtDetails[i] setEnabled:NO];
            txtDetails[i].text = [arrInfoAccount objectAtIndex:3];
          
            [txtDetails[i] setFrame:CGRectMake( 90, yAxis+33, 210, 28)];
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
		
		yAxis+=33;
	}		
	UILabel *lblDeliveryAddress=[[UILabel alloc]initWithFrame:CGRectMake( 3, 235, 200, 50)];
	[lblDeliveryAddress setBackgroundColor:[UIColor clearColor]];
	lblDeliveryAddress.textColor=subHeadingColor;
	[lblDeliveryAddress setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.daddr"]];
	[contentScrollView addSubview:lblDeliveryAddress];
	[lblDeliveryAddress release];
	
	arrDetailLbl=[NSArray arrayWithObjects: [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.street"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.city"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.zip"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.country"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.state"],  nil];
	yAxis=280;
	
	for (int i=0; i<5; i++)
	{		
		lblDeliveryDetails[i] = [[UILabel alloc]initWithFrame:CGRectMake( 3, yAxis, 150, 30)];
		[lblDeliveryDetails[i] setBackgroundColor:[UIColor clearColor]];
		lblDeliveryDetails[i].textColor=subHeadingColor;
		lblDeliveryDetails[i].font=[UIFont systemFontOfSize:14];
		[lblDeliveryDetails[i] setText:[arrDetailLbl objectAtIndex:i]];
		[contentScrollView addSubview:lblDeliveryDetails[i]];
		[lblDeliveryDetails[i] release];
		
		txtDeliveryDetails[i] = [[UITextField alloc] initWithFrame:CGRectMake( 90, yAxis, 210, 28)];
		[txtDeliveryDetails[i] setBorderStyle:UITextBorderStyleRoundedRect];
		[txtDeliveryDetails[i] setDelegate:self];
		[txtDeliveryDetails[i] setEnabled:NO];
		[contentScrollView addSubview:txtDeliveryDetails[i]];
		
		if([arrInfoAccount count]!=0)
			txtDeliveryDetails[i].text = [arrInfoAccount objectAtIndex:(i+6)];
		
		if(i==4)
		{
			[txtDeliveryDetails[i] setFrame:CGRectMake( 90, yAxis-66, 210, 28)];
            txtDeliveryDetails[i].text = [arrInfoAccount objectAtIndex:9];

			
		}
		else if(i==2)
		{
			[txtDeliveryDetails[i] setEnabled:NO];
            
			[txtDeliveryDetails[i] setFrame:CGRectMake( 90, yAxis+33, 210, 28)];
			btnShowPickerViewDeliveryState = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnShowPickerViewDeliveryState setFrame:txtDeliveryDetails[i].frame];
			[btnShowPickerViewDeliveryState setBackgroundColor:[UIColor clearColor]];
			[btnShowPickerViewDeliveryState setTag:4];
			[btnShowPickerViewDeliveryState setEnabled:NO];
			[btnShowPickerViewDeliveryState addTarget:self action:@selector(getPickerView:) forControlEvents:UIControlEventTouchUpInside];
			[contentScrollView addSubview:btnShowPickerViewDeliveryState];
			[contentScrollView bringSubviewToFront:btnShowPickerViewDeliveryState];
			
			if([arrInfoAccount count])
				txtDeliveryDetails[i].text = [arrInfoAccount objectAtIndex:10];
		}
		else if(i==3)
		{
			[txtDeliveryDetails[i] setEnabled:NO];
			
			[txtDeliveryDetails[i] setFrame:CGRectMake( 90, yAxis+33, 210, 28)];
			btnShowPickerViewDeliveryDetails = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnShowPickerViewDeliveryDetails setFrame:txtDeliveryDetails[i].frame];
			[btnShowPickerViewDeliveryDetails setBackgroundColor:[UIColor clearColor]];
			[btnShowPickerViewDeliveryDetails setTag:8];
			[btnShowPickerViewDeliveryDetails setEnabled:NO];
			[btnShowPickerViewDeliveryDetails addTarget:self action:@selector(getPickerView:) forControlEvents:UIControlEventTouchUpInside];
			[contentScrollView addSubview:btnShowPickerViewDeliveryDetails];
			[contentScrollView bringSubviewToFront:btnShowPickerViewDeliveryDetails];				
			if([arrInfoAccount count])
				txtDeliveryDetails[i].text = [arrInfoAccount objectAtIndex:8];
		}			
		[txtDeliveryDetails[i] setReturnKeyType:UIReturnKeyDone];			
		yAxis+=33;
	}		
	
	btnEdit=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnEdit setFrame:CGRectMake( 90, 455, 120, 30)];
	[btnEdit setTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.createaccount.edit"] forState:UIControlStateNormal];
	
	[btnEdit setTitleColor:btnTextColor forState:UIControlStateNormal];
    btnEdit.backgroundColor = [UIColor clearColor];
	[btnEdit.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
	[btnEdit setBackgroundImage:[UIImage imageNamed:@"submit_btn.png"] forState:UIControlStateNormal];
	[btnEdit addTarget:self action:@selector(editInfo) forControlEvents:UIControlEventTouchUpInside];
	[contentScrollView addSubview:btnEdit];
	
}
-(void)createPickerView
{
	pickerViewCountry = [[UIPickerView alloc]initWithFrame:CGRectMake( 0, 490, 320, 160)];
	[pickerViewCountry setDelegate:self];
	[pickerViewCountry setDataSource:self];
	[pickerViewCountry setShowsSelectionIndicator:YES];
	[pickerViewCountry setHidden:YES];
	[contentView addSubview:pickerViewCountry];
	
	pickerViewStates = [[UIPickerView alloc]initWithFrame:CGRectMake( 0, 490, 320, 160)];
	[pickerViewStates setDelegate:self];
	[pickerViewStates setDataSource:self];
	[pickerViewStates setShowsSelectionIndicator:YES];
	[pickerViewStates setHidden:YES];
	[contentView addSubview:pickerViewStates];
	
	dicSettings = [[NSDictionary alloc]init];
	dicSettings = [GlobalPrefrences getSettingsOfUserAndOtherDetails];
	[dicSettings retain];
	
	interShippingDict = [[NSArray alloc]init];
	NSDictionary *contentDict = [dicSettings objectForKey:@"store"];
	interShippingDict = [contentDict objectForKey:@"shippingList"];
	[interShippingDict retain];
	
	NSDictionary *lDicAppVitals=[[NSDictionary alloc]init];
	lDicAppVitals=[GlobalPrefrences getAppVitals];
	NSMutableArray *arrTempComp=[[NSMutableArray alloc]init];
	arrTempComp=[contentDict valueForKey:@"taxList"];
	
	
	NSMutableArray *arrayCountryTemp = [[NSMutableArray alloc] init];
	arrcountryCodes=[[NSMutableArray alloc]init];
	
	for(int i=0;i<[arrTempComp count];i++)
	{
	    if (![[arrayCountryTemp valueForKey:@"sCountry"] containsObject:[[arrTempComp objectAtIndex:i]valueForKey:@"sCountry"]]) {
			[arrayCountryTemp addObject:[arrTempComp objectAtIndex:i]];
			[arrcountryCodes addObject:[[arrTempComp objectAtIndex:i] valueForKey:@"territoryId"]];
		}
		
	}
	for(int i=0;i<[interShippingDict count];i++)
	{
	    if (![[arrayCountryTemp valueForKey:@"sCountry"] containsObject:[[interShippingDict objectAtIndex:i]valueForKey:@"sCountry"]]) {
			[arrayCountryTemp addObject:[interShippingDict objectAtIndex:i]];
			[arrcountryCodes addObject:[[interShippingDict objectAtIndex:i] valueForKey:@"territoryId"]];
		}
		
	}
	
	[dicSettings release];
	
	arrayCountry = [[NSArray alloc] initWithArray:arrayCountryTemp];
	[arrayCountry retain];
	
	arrayStates = [[NSMutableArray alloc] init];
	currentCountryIdForDelivery=[GlobalPrefrences getUserCountryID];
	
	if(currentCountryIdForDelivery==0)
	{
		if([arrcountryCodes count]>0)
		{
			currentCountryIdForDelivery=[[arrcountryCodes objectAtIndex:0]intValue]; 
		}
	}
	
	[arrayStates removeAllObjects];
	for(int index=0;index<[arrTempComp count];index++)
	{
		if(currentCountryIdForDelivery==[[[arrTempComp valueForKey:@"territoryId"]objectAtIndex:index]intValue])
		{
			[arrayStates  addObject:[arrTempComp objectAtIndex:index]];
		}		
	}
	for(int index=0;index<[interShippingDict count];index++)
	{
		if(currentCountryIdForDelivery==[[[interShippingDict valueForKey:@"territoryId"]objectAtIndex:index]intValue])
		{
			if(![[arrayStates valueForKey:@"sState"]containsObject:[[interShippingDict valueForKey:@"sState"]objectAtIndex:index]])	
			{	
				[arrayStates  addObject:[interShippingDict objectAtIndex:index]];
			}
		}		
	}
	
	if([arrayStates count]>0)
		currentStateIdForDelivery=[[[arrayStates valueForKey:@"stateId"]objectAtIndex:0]intValue];
	[arrayCountryTemp release];
}

-(void)editInfo
{
	isEditMode=true;
	if(![txtDetails[2] isEnabled])
	{
		int index;
		currentCountryIdForDelivery = [[[NSUserDefaults standardUserDefaults]valueForKey:@"countryID"]intValue];
		currentStateIdForDelivery=[[[NSUserDefaults standardUserDefaults]valueForKey:@"stateID"]intValue];
		NSString *strCountry=txtDetails[3].text;
		
		if([arrayCountry containsObject:strCountry])
		{
			index=[arrayCountry indexOfObject:strCountry];
			currentCountryIdForDelivery=[[arrcountryCodes objectAtIndex:index]intValue];
			
		}
		
		[NSThread detachNewThreadSelector:@selector(getStatesOfaCountry:) toTarget:self withObject:@""];
		
		for (int i=0; i<6; i++)
		{
			if(i!=0)
			{
				if(i<5)
					[txtDetails[i] setEnabled:YES];
				else
				{
					[btnShowPickerViewDetails setEnabled:YES];
					[btnShowPickerViewState setEnabled:YES];
				}
			}
			
			if (i<5) 
			{
				if (i<4) 
					[txtDeliveryDetails[i] setEnabled:YES];
				else
				{
					[btnShowPickerViewDeliveryDetails setEnabled:YES];
					[btnShowPickerViewDeliveryState setEnabled:YES];
				}
			}
			
		}
        [txtDetails[5] setEnabled:YES];
      [txtDeliveryDetails[4] setEnabled:YES];
		
		[btnEdit setTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.createaccount.update"] forState:UIControlStateNormal];
	}
	else
	{
		if(([txtDetails[0].text length]==0) || ([txtDetails[1].text length]==0) || ([txtDetails[2].text length]==0) || ([txtDetails[3].text length]==0) || ([txtDetails[4].text length]==0) || ([txtDetails[5].text length]==0) || ([txtDeliveryDetails[0].text length]==0) || [txtDeliveryDetails[1].text length]==0 || [txtDeliveryDetails[2].text length]==0 || [txtDeliveryDetails[3].text length]==0 || [txtDeliveryDetails[4].text length]==0)
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.textfield.notempty.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else {
			
			for (int i=0; i<6; i++)
			{
				if(i!=0)
				{
					if(i<5)
						[txtDetails[i] setEnabled:NO];
					else
					{
						[btnShowPickerViewDetails setEnabled:NO];
						[btnShowPickerViewState setEnabled:NO];
					}
				}
				
				if (i<5) 
				{
					if (i<4) 
						[txtDeliveryDetails[i] setEnabled:NO];
					else
					{
						[btnShowPickerViewDeliveryDetails setEnabled:NO];
						[btnShowPickerViewDeliveryState setEnabled:NO];
					}
				}
				
			}
			[btnEdit setTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.createaccount.edit"] forState:UIControlStateNormal];
			
			
			
			[[SqlQuery shared] updateTblAccountDetails:txtDetails[1].text :txtDetails[2].text :txtDetails[4].text :txtDetails[3].text :txtDetails[5].text :txtDeliveryDetails[0].text :txtDeliveryDetails[1].text :txtDeliveryDetails[2].text :txtDeliveryDetails[3].text :txtDeliveryDetails[4].text :txtDetails[0].text];
			NSDictionary *contentDict = [dicSettings objectForKey:@"store"];
			NSArray* arrTemp =[contentDict objectForKey:@"taxList"];
			NSArray *arrTempShippingCountries=[contentDict objectForKey:@"shippingList"];
			
			
			NSString *strCountryCode;
			for(int i=0;i<[arrTemp count];i++)
			{
				if ([txtDeliveryDetails[2].text isEqualToString:[[arrTemp objectAtIndex:i]valueForKey:@"sCountry"]]) 
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
			
			[GlobalPrefrences setUserDefault_Preferences:txtDetails[0].text :@"userEmail"];
			[GlobalPrefrences setPersonLoginStatus:YES];
			
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.info.update.title"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.info.update.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			[alert show];
			[alert release];			
			if(isLoginByCheckOut)
			{
				isLoginByCheckOut = NO;
				ShoppingCartViewController *objShopping = [[ShoppingCartViewController alloc] init];
				[[GlobalPrefrences getCurrentNavigationController] pushViewController:objShopping animated:YES];
				[objShopping release];
			}
			
		}		
	}
	
}


-(void)displayViewForRegistration
{
	contentScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake( 0, 20, 420, 570)];
	[contentScrollView setBackgroundColor:[UIColor clearColor]];
	[contentScrollView setContentSize:CGSizeMake( 420, 600)];
	[viewForRegistration addSubview:contentScrollView];
	
	UIView *viewTopBar=[[UIView alloc]initWithFrame:CGRectMake(0,0, 420, 30)];
	[viewForRegistration addSubview:viewTopBar];
	
	UILabel *accountLbl=[[UILabel alloc]initWithFrame:CGRectMake(-6, -20, 410, 20)];
	[accountLbl setBackgroundColor:[UIColor clearColor]];
	[accountLbl setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.signup"]];
	accountLbl.textColor = headingColor;
	[accountLbl setFont:[UIFont boldSystemFontOfSize:15.0]];
	[viewTopBar addSubview:accountLbl];
	[accountLbl release];
	[viewTopBar release];
	
	
	UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(-3, 11, 426,2)];
	[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
	[viewTopBar addSubview:imgHorizontalDottedLine];
	[imgHorizontalDottedLine release];
	
	
	
	NSArray *arrPasswordLblTxt=[NSArray arrayWithObjects:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.password"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.confirm"],nil];
	
	UILabel *lblPassword[2];
	
	int yAxis=18;
	if(toolBar)
	{
		NSArray *arrTemp = [toolBar subviews];
		if([arrTemp count] > 0)
		{
			for(int i = 0; i <[arrTemp count]; i++)
				[[arrTemp objectAtIndex:i] removeFromSuperview];
			
		}	
		[toolBar removeFromSuperview];
		[toolBar release];
		toolBar = nil;
	}
	toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake( 0, 450, 320, 40)];
	[toolBar setTintColor:[UIColor blackColor]];
	[toolBar setHidden:YES];
	[contentView addSubview:toolBar];
	
	UIBarButtonItem *btnDone=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignTextField)];
	UIBarButtonItem *flexiSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
	
	[toolBar setItems:[NSArray arrayWithObjects: flexiSpace,btnDone,nil]];
	[btnDone release];
	[flexiSpace release];
	
	for (int i=0; i<2; i++)
	{		
		lblPassword[i] = [[UILabel alloc]initWithFrame:CGRectMake( 0, yAxis, 150, 30)];
		[lblPassword[i] setBackgroundColor:[UIColor clearColor]];
		lblPassword[i].textColor=subHeadingColor;
		lblPassword[i].font=[UIFont boldSystemFontOfSize:16.0];
		[lblPassword[i] setText:[arrPasswordLblTxt objectAtIndex:i]];
		[contentScrollView addSubview:lblPassword[i]];
		[lblPassword[i] release];
		
		txtPassword[i] = [[UITextField alloc] initWithFrame:CGRectMake( 105, yAxis, 190, 28)];
		[txtPassword[i] setBorderStyle:UITextBorderStyleRoundedRect];
		[txtPassword[i] setDelegate:self];
		[txtPassword[i] setSecureTextEntry:YES];
		[txtPassword[i] setReturnKeyType:UIReturnKeyDone];
		[contentScrollView addSubview:txtPassword[i]];
		
		yAxis+=35;
	}
	
	UIView *viewbillingBar=[[UIView alloc]initWithFrame:CGRectMake(0, 90, 320, 30)];
    [contentScrollView addSubview:viewbillingBar];
	
    
    UILabel *lblBilling=[[UILabel alloc]initWithFrame:CGRectMake( 0, 15, 100, 20)];
	[lblBilling setBackgroundColor:[UIColor clearColor]];
	lblBilling.textColor=headingColor;
	[lblBilling setFont:[UIFont boldSystemFontOfSize:13.0]];
	[lblBilling setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.billing"]];
	[viewbillingBar addSubview:lblBilling];
	[lblBilling release];
    [viewbillingBar release];
    
	
	NSArray *arrBillingLblTxt=[NSArray arrayWithObjects:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.name"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.email"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.street"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.city"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.zip"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.country"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.state"], nil];
	
	
	UILabel *lblBillingTxtSet[7];
	
	yAxis=141;
	
	for (int i=0; i<7; i++) {
		
		lblBillingTxtSet[i] = [[UILabel alloc]initWithFrame:CGRectMake( 0, yAxis, 150, 30)];
		[lblBillingTxtSet[i] setBackgroundColor:[UIColor clearColor]];
		lblBillingTxtSet[i].textColor=subHeadingColor;
		lblBillingTxtSet[i].font=[UIFont boldSystemFontOfSize:16.0];
		[lblBillingTxtSet[i] setText: [arrBillingLblTxt objectAtIndex:i]];
		[contentScrollView addSubview:lblBillingTxtSet[i]];
		[lblBillingTxtSet[i] release];
		
		
		txtBillingField[i] = [[UITextField alloc] initWithFrame:CGRectMake( 105, yAxis, 190, 28)];
		[txtBillingField[i] setDelegate:self];
		[txtBillingField[i] setReturnKeyType:UIReturnKeyDone];
		[contentScrollView addSubview:txtBillingField[i]];
		
		if(i==6) 
		{
		   [txtBillingField[i] setFrame:CGRectMake( 105, yAxis-70, 190, 28)];           
			
		}
		else if(i==1)
			[txtBillingField[i] setKeyboardType:UIKeyboardTypeEmailAddress];
		else if(i==5)
		{
			[txtBillingField[i] setEnabled:NO];
			[txtBillingField[i] setFrame:CGRectMake( 105, yAxis+35, 190, 28)];
			
			UIButton *btnShowPickerView = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnShowPickerView setFrame:txtBillingField[i].frame];
			[btnShowPickerView setBackgroundColor:[UIColor clearColor]];
			[btnShowPickerView setTag:5];
			[btnShowPickerView addTarget:self action:@selector(getPickerView:) forControlEvents:UIControlEventTouchUpInside];
           
			[contentScrollView addSubview:btnShowPickerView];
			[contentScrollView bringSubviewToFront:btnShowPickerView];
		}
		else if(i==4)
		{
			[txtBillingField[i] setEnabled:NO];
			
			[txtBillingField[i] setFrame:CGRectMake( 105, yAxis+35, 190, 28)];
			UIButton *btnShowPickerView = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnShowPickerView setFrame:txtBillingField[i].frame];
			[btnShowPickerView setBackgroundColor:[UIColor clearColor]];
			[btnShowPickerView setTag:1];
			[btnShowPickerView addTarget:self action:@selector(getPickerView:) forControlEvents:UIControlEventTouchUpInside];
			[contentScrollView addSubview:btnShowPickerView];
			[contentScrollView bringSubviewToFront:btnShowPickerView];
		}
		
		[txtBillingField[i] setBorderStyle:UITextBorderStyleRoundedRect];
		
		yAxis+=35;
	}
	
    btnSameAddress=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnSameAddress setBackgroundColor:[UIColor clearColor]];
    [btnSameAddress setFrame:CGRectMake( 0, 398, 30, 30)];
	[btnSameAddress setImage:[UIImage imageNamed:@"box_tick.png"] forState:UIControlStateNormal];
	[btnSameAddress addTarget:self action:@selector(showDeliveryView) forControlEvents:UIControlEventTouchUpInside];
	[contentScrollView addSubview:btnSameAddress];
	
	UILabel *lblSameTxt=[[UILabel alloc]initWithFrame:CGRectMake( 37, 404, 200, 20)];
	[lblSameTxt setBackgroundColor:[UIColor clearColor]];
	lblSameTxt.textColor=headingColor;
	lblSameTxt.font=[UIFont boldSystemFontOfSize:12.0];
	[lblSameTxt setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.deliveryaddr"]];
	[contentScrollView addSubview:lblSameTxt];
	[lblSameTxt release];
	
	btnSubmit=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnSubmit setFrame:CGRectMake( 0, 460, 120, 30)];
	
	
	[btnSubmit setTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.submit"] forState:UIControlStateNormal];
	[btnSubmit setTitleColor:btnTextColor forState:UIControlStateNormal];
    btnSubmit.backgroundColor = [UIColor clearColor];
	[btnSubmit.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
	[btnSubmit setBackgroundImage:[UIImage imageNamed:@"submit_btn.png"] forState:UIControlStateNormal];
	[btnSubmit addTarget:self action:@selector(createAccount) forControlEvents:UIControlEventTouchUpInside];
	[contentScrollView addSubview:btnSubmit];
   	[self createDeliveryView];
}

-(void)createDeliveryView
{
	deliveryView=[[UIView alloc]initWithFrame:CGRectMake( -10, 410, 420, 300)];
	[deliveryView setBackgroundColor:[UIColor clearColor]];
	[deliveryView setHidden:YES];
	[contentScrollView addSubview:deliveryView];
    
    UIView *viewDeliveryBar=[[UIView alloc]initWithFrame:CGRectMake(0, 20, 420, 30)];
    [deliveryView addSubview:viewDeliveryBar];
    
    UILabel *lblDelivery=[[UILabel alloc]initWithFrame:CGRectMake( 10, 5, 420, 20)];
	[lblDelivery setBackgroundColor:[UIColor clearColor]];
	lblDelivery.textColor=headingColor;
	[lblDelivery setFont:[UIFont boldSystemFontOfSize:13.0]];
	[lblDelivery setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.daddr"]];
	[viewDeliveryBar addSubview:lblDelivery];
	[lblDelivery release];
    
    [viewDeliveryBar release];
	
	NSArray *arrDeliveryLblTxt=[NSArray arrayWithObjects: [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.street"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.city"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.zip"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.country"], [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.state"], nil];
	
	
	UILabel *lblDeliveryTxtSet[5];
	
	int yAxis=60;
	
	for (int i=0; i<5; i++) {
		
		lblDeliveryTxtSet[i] = [[UILabel alloc]initWithFrame:CGRectMake( 13, yAxis, 150, 30)];
		[lblDeliveryTxtSet[i] setBackgroundColor:[UIColor clearColor]];
		lblDeliveryTxtSet[i].textColor=subHeadingColor;
		lblDeliveryTxtSet[i].font=[UIFont boldSystemFontOfSize:14.0];
		[lblDeliveryTxtSet[i] setText: [arrDeliveryLblTxt objectAtIndex:i]];
		[deliveryView addSubview:lblDeliveryTxtSet[i]];
		[lblDeliveryTxtSet[i] release];
		
		txtDeliveryField[i] = [[UITextField alloc] initWithFrame:CGRectMake( 115, yAxis, 190, 28)];
		[txtDeliveryField[i] setDelegate:self];
		[txtDeliveryField[i] setReturnKeyType:UIReturnKeyDone];
		[deliveryView addSubview:txtDeliveryField[i]];
		
		if(i==4) 
		{
			[txtDeliveryField[i] setFrame:CGRectMake( 115, yAxis-66, 190, 28)];
			
		}
		else if(i==3)
		{
			[txtDeliveryField[i] setEnabled:NO];
			[txtDeliveryField[i] setFrame:CGRectMake( 115, yAxis+33, 190, 28)];
			UIButton *btnShowPickerView = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnShowPickerView setFrame:txtDeliveryField[i].frame];
			[btnShowPickerView setBackgroundColor:[UIColor clearColor]];
			[btnShowPickerView setTag:6];
			[btnShowPickerView addTarget:self action:@selector(getPickerView:) forControlEvents:UIControlEventTouchUpInside];
			[deliveryView addSubview:btnShowPickerView];
			[deliveryView bringSubviewToFront:btnShowPickerView];
		}
		else if(i==2)
		{
			[txtDeliveryField[i] setEnabled:NO];
			
			[txtDeliveryField[i] setFrame:CGRectMake( 115, yAxis+33, 190, 28)];
			UIButton *btnShowPickerView = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnShowPickerView setFrame:txtDeliveryField[i].frame];
			[btnShowPickerView setBackgroundColor:[UIColor clearColor]];
			[btnShowPickerView setTag:2];
			[btnShowPickerView addTarget:self action:@selector(getPickerView:) forControlEvents:UIControlEventTouchUpInside];
			[deliveryView addSubview:btnShowPickerView];
			[contentScrollView bringSubviewToFront:btnShowPickerView];
		}
		
		[txtDeliveryField[i] setBorderStyle:UITextBorderStyleRoundedRect];		
		yAxis+=33;
	}
	if([arrayCountry count]>0)
	{
		NSString *strCountry=[GlobalPrefrences getUserCountryFortax];
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
-(void)showLoadingbar
{
	[GlobalPrefrences addLoadingBar_AtBottom:self.tabBarController.view withTextToDisplay:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
}



-(void)createAccount
{
	
	
    if(([txtPassword[0].text length]==0) || ([txtBillingField[0].text length]==0) || ([txtBillingField[1].text length]==0) || ([txtBillingField[2].text length]==0) || ([txtBillingField[3].text length]==0) || ([txtBillingField[4].text length]==0) || ([txtBillingField[5].text length]==0) || ([txtBillingField[6].text length]==0))
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.textfield.notempty.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    else if(!([txtPassword[0].text isEqualToString:txtPassword[1].text]))
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.confirm.pass.notmatch.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        
        
    }	
    
    else if (![GlobalPrefrences validateEmail:txtBillingField[1].text])
    {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.invalid.email.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        
    }
    
    else
    {
        if(!isDeliveryShown)
        {
            NSMutableArray *arrAccount = [[NSMutableArray alloc] init];
            arrAccount =[[SqlQuery shared] getAccountData:txtBillingField[1].text];
            if([arrAccount count]==0)
            {
                if(isWishlistLogin || isOrderLogin)
                {
                    if(!isAccount)
                    {
                        if(!isReview)
                            [self performSelectorInBackground:@selector(showLoadingbar) withObject:nil];
                    }
                }
                [[SqlQuery shared] setTblAccountDetails: txtBillingField[0].text : txtBillingField[1].text : txtPassword[0].text : txtBillingField[2].text : txtBillingField[3].text : txtBillingField[4].text : txtBillingField[5].text : txtBillingField[6].text : txtBillingField[2].text : txtBillingField[3].text : txtBillingField[4].text : txtBillingField[5].text : txtBillingField[6].text];
                

                
                [GlobalPrefrences setUserDefault_Preferences:txtBillingField[1].text :@"userEmail"];
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
                [GlobalPrefrences setPersonLoginStatus:YES];
                if(isFromPostReview==YES)
                {
                    isFromPostReview=NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PostReviewShow" object:self];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutNotification" object:self];
                
                if(isLoginByCheckOut)
                {
                    isLoginByCheckOut = NO;
                    ShoppingCartViewController *objShopping = [[ShoppingCartViewController alloc] init];
                    [[GlobalPrefrences getCurrentNavigationController] pushViewController:objShopping animated:YES];
                    [objShopping release];
                }
                
                else 
                {
                    [viewForRegistration setHidden:YES];
                    [self AccountInfoToEdit];
                }
                if(isWishlistLogin || isOrderLogin)
                {
                    if(isAccount)
                        isAccount = NO;
                }
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.email.already.exists.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            [arrAccount release];
        }
        else
        {
            
            if([txtDeliveryField[0].text length]==0 || [txtDeliveryField[1].text length]==0 || [txtDeliveryField[2].text length]==0 || [txtDeliveryField[3].text length]==0 || [txtDeliveryField[4].text length]==0)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.textfield.notempty.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            else
            {
                
                
                NSMutableArray *arrAccount = [[NSMutableArray alloc] init];
                
                arrAccount =[[SqlQuery shared] getAccountData:txtBillingField[1].text];
                
                if([arrAccount count]==0)
                {
                    if(isWishlistLogin || isOrderLogin)	
                    {
                        if(!isAccount)
                            
                        {
                            [self performSelectorInBackground:@selector(showLoadingbar) withObject:nil];
                            
                        }
                    }
                    [[SqlQuery shared] setTblAccountDetails:txtBillingField[0].text : txtBillingField[1].text : txtPassword[0].text : txtBillingField[2].text : txtBillingField[3].text : txtBillingField[4].text : txtBillingField[5].text : txtBillingField[6].text : txtDeliveryField[0].text : txtDeliveryField[1].text : txtDeliveryField[2].text : txtDeliveryField[3].text : txtDeliveryField[4].text];
                    
                    [GlobalPrefrences setUserDefault_Preferences:txtBillingField[1].text :@"userEmail"];
                    
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
                    
                    
                    
                    if(isWishlistLogin || isOrderLogin)
                    {
                        if(isAccount)
                            isAccount = NO;
                    }	
                    
                    if(isLoginByCheckOut)
                    {
                        isLoginByCheckOut = NO;
                        ShoppingCartViewController *objShopping = [[ShoppingCartViewController alloc] init];
                        [[GlobalPrefrences getCurrentNavigationController] pushViewController:objShopping animated:YES];
                        [objShopping release];
                    }
                    
                    else 
                    {
                        [viewForRegistration setHidden:YES];
                        [self AccountInfoToEdit];
                    }
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.email.already.exists.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
                [arrAccount release];
            }
        }
    }
	
	/*else
     {
     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.confirm.pass.notmatch.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
     [alert show];
     [alert release];
     }*/
	isReview=NO;
}

-(void)showDeliveryView
{
	if(!isDeliveryShown)
	{
		[deliveryView setHidden:NO];
		[contentScrollView setContentSize:CGSizeMake(320, 690)];
		[btnSameAddress setImage:[UIImage imageNamed:@"block.png"] forState:UIControlStateNormal];
		isDeliveryShown=YES;
		[contentScrollView setContentOffset:CGPointMake( 0, 200) animated:YES];
		[btnSubmit setFrame:CGRectMake( 10, 650, 120, 30)];
		[contentScrollView bringSubviewToFront:btnSubmit];
		
		if([arrayCountry count]>0)
		{
			NSString *strCountry=[GlobalPrefrences getUserCountryFortax];
			if(!strCountry)
			{
				
				txtDeliveryField[2].text = [NSString stringWithFormat:@"%@", [[arrayCountry valueForKey:@"sCountry"]objectAtIndex:rowValue]];
			} else
			{
				 
				txtDeliveryField[2].text=strCountry;	
			}
		}
        if([arrayStates count]>0)
        {
            
			
			txtDeliveryField[3].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:0]];
        }
	}
	else
	{
		[deliveryView setHidden:YES];
		[contentScrollView setContentSize:CGSizeMake(420, 585)];
		isDeliveryShown=NO;
		[btnSameAddress setImage:[UIImage imageNamed:@"box_tick.png"] forState:UIControlStateNormal];
        [btnSubmit setFrame:CGRectMake( 10, 460, 120, 30)];
	}
}

-(void)getPickerView:(UIButton *)sender
{
	NSLog(@"%d",[sender tag]);
	if([sender tag]<5)
	{
		
		if([arrayCountry count]>0)
		{
			
			if([sender tag]==1||[sender tag]==3)
				selectPicker=NO;
			else
				selectPicker=YES;
			
			for(int i=0; i<=6; i++)
			{
				if(i<2)
					[txtPassword[i] setEnabled:NO];
				
				if(i<4)
				{
					[txtDeliveryDetails[i] setEnabled:NO];
					[txtDeliveryField[i] setEnabled:NO];
				}
				[txtBillingField[i] setEnabled:NO];
				
                [txtDetails[i] setEnabled:NO];
				
			}
			
			if(toolBar)
			{
				NSArray *arrTemp = [toolBar subviews];
				if([arrTemp count] > 0)
				{
					for(int i = 0; i <[arrTemp count]; i++)
						[[arrTemp objectAtIndex:i] removeFromSuperview];
				}	
				[toolBar removeFromSuperview];
				[toolBar release];
				toolBar = nil;
			}
            
            
            
            
            
			toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake( 0, 450, 320, 40)];
			[toolBar setTintColor:[UIColor blackColor]];
			[contentView addSubview:toolBar];
			[toolBar setHidden:NO];
			UIBarButtonItem *btnDone=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignTextField)];
			UIBarButtonItem *flexiSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
			
			[toolBar setItems:[NSArray arrayWithObjects: flexiSpace,btnDone,nil]];
			[btnDone release];
			[flexiSpace release];
			
            //========position of country in picker view
            if(!isEditMode)
            {
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
                //========position of country in picker view
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
                                   
            
			
			[pickerViewCountry setHidden:NO];
			[contentView bringSubviewToFront:toolBar];
			[contentView bringSubviewToFront:pickerViewCountry];
			
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nocountry.avail.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			[alert show];
			[alert release];		}
	}
	else
	{
		if([arrayStates count]>0)
		{
			if ([sender tag]==5 || [sender tag]==7)
            {    isfromTag=1;
				if(!isEditMode)
                {
                    [self getStatesOfaCountry:[txtBillingField[4] text]];
                    
                }else
                {
                    [self getStatesOfaCountry:[txtDetails[3] text]]; 
                }
                selectPicker=YES;
            }
			else if([sender tag]==8)
			{   
                isfromTag=0;
				[self getStatesOfaCountry:[txtDeliveryDetails[2] text]];
				selectPicker=YES;
			}
			else
            {isfromTag=0;
                if(!isEditMode){
                    [self getStatesOfaCountry:txtDeliveryField[2].text]; 
                }
                selectPicker=YES;
            }
			
			for(int i=0; i<5; i++)
			{
				if(i<2)
					[txtPassword[i] setEnabled:NO];
				
				if(i<4)
				{
					[txtDeliveryDetails[i] setEnabled:NO];
					[txtDeliveryField[i] setEnabled:NO];
				}
				[txtBillingField[i] setEnabled:NO];
				
                [txtDetails[i] setEnabled:NO];
				
				
			}
			[pickerViewStates setHidden:NO];
			if(toolBar)
			{
				NSArray *arrTemp = [toolBar subviews];
				if([arrTemp count] > 0)
				{
					for(int i = 0; i <[arrTemp count]; i++)
						[[arrTemp objectAtIndex:i] removeFromSuperview];
				}	
				[toolBar removeFromSuperview];
				[toolBar release];
				toolBar = nil;				
			}
			toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake( 0, 450, 320, 40)];
			[toolBar setTintColor:[UIColor blackColor]];
			[contentView addSubview:toolBar];
			[toolBar setHidden:NO];
			UIBarButtonItem *btnDone=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignTextField)];
			UIBarButtonItem *flexiSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
			
			[toolBar setItems:[NSArray arrayWithObjects: flexiSpace,btnDone,nil]];
			[btnDone release];
			[flexiSpace release];
			            

			[contentView bringSubviewToFront:toolBar];
			[contentView bringSubviewToFront:pickerViewStates];
			
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nostate.avail.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		
	}
	
}
// Called to get the states and countries defined for the store

- (void)getStatesOfaCountry:(NSString*)strCountryVal
{
    NSLog(@"test%@",strCountryVal);
	dicSettings = [GlobalPrefrences getSettingsOfUserAndOtherDetails];
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

-(void)resignTextField
{
	
	UIButton *btnPicker[8];
	
	for(int i=0; i<8; i++)
	{
		btnPicker[i]  = (UIButton *)[contentScrollView viewWithTag:i+1];
		btnPicker[i].enabled = YES;
	}
	NSMutableArray *arrInfo=[[NSMutableArray alloc]init];
	arrInfo=[[SqlQuery shared] getAccountData:[GlobalPrefrences getUserDefault_Preferences:@"userEmail"]];
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
	[txtDetails[4] resignFirstResponder];
    [txtDetails[3] resignFirstResponder];
    [txtDetails[5] resignFirstResponder];
	[txtDeliveryDetails[3] resignFirstResponder];
	[toolBar setHidden:YES];
	[pickerViewCountry setHidden:YES];
	[pickerViewStates setHidden:YES];
	
	
}


-(void)displayViewForLogin
{
	UIView *viewTopBar=[[UIView alloc]initWithFrame:CGRectMake(0,0, 420, 40)];
	[viewForLogin addSubview:viewTopBar];
	
	UILabel *accountLbl=[[UILabel alloc]initWithFrame:CGRectMake(-6, -19, 410, 20)];
	[accountLbl setBackgroundColor:[UIColor clearColor]];
	accountLbl.textColor =headingColor;
	[accountLbl setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.loginto.account"]];
	[accountLbl setFont:[UIFont boldSystemFontOfSize:15]];
	[viewTopBar addSubview:accountLbl];
	[accountLbl release];
	
	UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(-3, 11, 426,2)];
	[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
	[viewTopBar addSubview:imgHorizontalDottedLine];
	[imgHorizontalDottedLine release];
	[viewTopBar release];
	
	UILabel *lblEmail = [[UILabel alloc]initWithFrame:CGRectMake( 0, 70, 150, 30)];
	[lblEmail setBackgroundColor:[UIColor clearColor]];
	lblEmail.textColor=subHeadingColor;
	lblEmail.font=[UIFont boldSystemFontOfSize:15];
	[lblEmail setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.email"]];
	[viewForLogin addSubview:lblEmail];
	[lblEmail release];
	
	txtEmailForLogin = [[UITextField alloc] initWithFrame:CGRectMake(110, 70, 210, 25)];
	[txtEmailForLogin setBorderStyle:UITextBorderStyleRoundedRect];
	[txtEmailForLogin setDelegate:self];
	[txtEmailForLogin setKeyboardType:UIKeyboardTypeEmailAddress];
	[txtEmailForLogin setReturnKeyType:UIReturnKeyDone];
	[viewForLogin addSubview:txtEmailForLogin];
	
	UILabel *lblPassword = [[UILabel alloc]initWithFrame:CGRectMake( 0, 100, 150, 30)];
	[lblPassword setBackgroundColor:[UIColor clearColor]];
	lblPassword.textColor=subHeadingColor;
	lblPassword.font=[UIFont boldSystemFontOfSize:15];
	[lblPassword setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.password"]];
	[viewForLogin addSubview:lblPassword];
	[lblPassword release];
	
	txtPasswordForLogin = [[UITextField alloc] initWithFrame:CGRectMake(110, 100, 210, 25)];
	[txtPasswordForLogin setBorderStyle:UITextBorderStyleRoundedRect];
	[txtPasswordForLogin setDelegate:self];
	[txtPasswordForLogin setSecureTextEntry:YES];
	txtPasswordForLogin.autocorrectionType = UITextAutocorrectionTypeNo;
	[txtPasswordForLogin setReturnKeyType:UIReturnKeyDone];
	[viewForLogin addSubview:txtPasswordForLogin];
	
	UIButton *btnLogin=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnLogin setFrame:CGRectMake( 110, 140, 174, 39)];
	[btnLogin addTarget:self action:@selector(methodLogin) forControlEvents:UIControlEventTouchUpInside];
	[btnLogin setTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.loginto.account"] forState:UIControlStateNormal];
	[btnLogin setTitleColor:btnTextColor forState:UIControlStateNormal];
    btnLogin.backgroundColor = [UIColor clearColor];
	[btnLogin.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
	[btnLogin setBackgroundImage:[UIImage imageNamed:@"submit_btn.png"] forState:UIControlStateNormal];
	[viewForLogin addSubview:btnLogin];
	
	UIButton *btnCreateLogin=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnCreateLogin setFrame:CGRectMake(110, 190, 174, 39)];
	[btnCreateLogin setTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.create.account"] forState:UIControlStateNormal];
	[btnCreateLogin setTitleColor:btnTextColor forState:UIControlStateNormal];
    btnCreateLogin.backgroundColor = [UIColor clearColor];
	[btnCreateLogin.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
	[btnCreateLogin setBackgroundImage:[UIImage imageNamed:@"submit_btn.png"] forState:UIControlStateNormal];
	[btnCreateLogin addTarget:self action:@selector(btnCreateAccount_Clicked) forControlEvents:UIControlEventTouchUpInside];
	[viewForLogin addSubview:btnCreateLogin];
	
}

-(void)login_FromOtherViewControllers
{
	
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{    
	if(alertView==alertView1)
	{
		if(isWishlistLogin || isOrderLogin)
		{
			if(isAccount)
				isAccount = NO;
			
			if([txtEmailForLogin isFirstResponder])
				[txtEmailForLogin resignFirstResponder];
			if([txtPasswordForLogin isFirstResponder])
				[txtPasswordForLogin resignFirstResponder];
	    }	
		
    }
	
	else if(alertView == alertMain)
	{
		UIButton *btnCart = (UIButton *)[contentView viewWithTag:23456];
		switch (buttonIndex) {
			case 0:
				isLoadingTableFooter = TRUE;
				isWishlistLogin = NO;
				isOrderLogin = NO;
				if(isFromPostReview==YES)
				{
					isFromPostReview=NO;
					[[NSNotificationCenter defaultCenter] postNotificationName:@"PostReviewShow" object:nil];
					
				}	
				
				[btnCart setHidden:NO];
				UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(-3, 50, 426,2)];
				[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
				[contentView addSubview:imgHorizontalDottedLine];
				[imgHorizontalDottedLine release];
				[self.navigationController popViewControllerAnimated:YES];
				break;
			case 1:
				[self displayViewForLogin];
				[btnCart setHidden:NO];
				[self animationForViews:viewForLogin :viewForRegistration];
				break;
			case 2:
				[self displayViewForRegistration];
				[btnCart setHidden:NO];
				[self animationForViews:viewForRegistration :viewForLogin];
				
				break;
			default:
				break;
		}
	}
}

-(void)methodLogin
{
	NSString *strPassword = [[SqlQuery shared]getPassword:txtEmailForLogin.text];
	
	if (![GlobalPrefrences validateEmail:txtEmailForLogin.text])
	{
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.invalid.email.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
        [alertView show];
        [alertView release];
	}
	else if([txtEmailForLogin.text length]==0 || [txtPasswordForLogin.text length]==0)
	{
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.textfield.notempty.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
        [alertView show];
        [alertView release];
	}
	else
	{
		if([strPassword isEqualToString:[NSString stringWithFormat:@""]])
		{
			UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.account.notfound.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
		else
		{
			if([strPassword isEqualToString:txtPasswordForLogin.text])
			{
				[GlobalPrefrences setUserDefault_Preferences:txtEmailForLogin.text :@"userEmail"];
				alertView1=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.login.sucess.title"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.login.sucess.text"] delegate:self cancelButtonTitle:nil  otherButtonTitles:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"],nil];
                [alertView1 show];
                [alertView1 show];
				[alertView1 release];
				
				[GlobalPrefrences setPersonLoginStatus:YES];
				if(isFromPostReview==YES)
				{
					isFromPostReview=NO;
					[[NSNotificationCenter defaultCenter] postNotificationName:@"PostReviewShow" object:nil];
					
				}	
				
				[[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutNotification" object:self];
				if(isLoginByCheckOut)
				{
					isLoginByCheckOut = NO;
					ShoppingCartViewController *objShopping = [[ShoppingCartViewController alloc] init];
					[[GlobalPrefrences getCurrentNavigationController] pushViewController:objShopping animated:YES];
					[objShopping release];
				}
				else 
				{   
					[viewForLogin setHidden:YES];
					isLoginByCheckOut = YES;
					[self AccountInfoToEdit];
				}
				
			}
			
			
			else
			{
				UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.server.notresp.title.error"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.password.notcorrect.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
				[alertView show];
				[alertView release];
				
			}
		}
	}
}


-(void)animationForViews:(UIView *) viewToShow :(UIView *)viewToHide
{
	viewToShow.hidden = NO;
	[contentView bringSubviewToFront:viewToShow];
	viewToHide.hidden = YES;
}

-(void)btnCreateAccount_Clicked
{
	[self animationForViews:viewForRegistration :viewForLogin];
	[self displayViewForRegistration];
}

#pragma mark Text Field Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	UIButton *btnPicker[8];
	
	for(int i=0; i<8; i++)
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
	if (textField==txtBillingField[0])
	
	{
		UIButton *btnPicker[8];
		
		for(int i=0; i<8; i++)
		{
			btnPicker[i]  = (UIButton *)[contentScrollView viewWithTag:i+1];
			btnPicker[i].enabled = NO;
		}
		[toolBar setHidden:YES];
		
	}
	else
	{
		pickerViewStates.hidden = YES;
		pickerViewCountry.hidden = YES;
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
	if(thePickerView == pickerViewStates)
		return [arrayStates count];
	
	return [arrayCountry count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	if(thePickerView == pickerViewStates)
		return [[arrayStates valueForKey:@"sState"]objectAtIndex:row];
	
	return [[arrayCountry valueForKey:@"sCountry"]objectAtIndex:row];
	
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	currentSelectedRow=row;
	if(thePickerView == pickerViewCountry)
	{
			
		if(!selectPicker)
			txtBillingField[4].text = [NSString stringWithFormat:@"%@", [[arrayCountry valueForKey:@"sCountry"]objectAtIndex:row]];
		else{
            
            if(isDeliveryShown){
                if(!isEditMode){
                    
                    
                    txtDeliveryField[2].text = [NSString stringWithFormat:@"%@", [[arrayCountry valueForKey:@"sCountry"]objectAtIndex:row]];  
                }
            }else{
            }
			
        }
		if(txtDeliveryDetails[2])
		{
			if(!selectPicker)
				txtDetails[3].text = [NSString stringWithFormat:@"%@", [[arrayCountry valueForKey:@"sCountry"]objectAtIndex:row]];
			else
				txtDeliveryDetails[2].text = [NSString stringWithFormat:@"%@", [[arrayCountry valueForKey:@"sCountry"]objectAtIndex:row]];
		}
		rowValue = row;
		
		[self setStates];
	}
	
	else
	{
		
		if(!selectPicker)
		{
			
			if([arrayStates count]>0)
			{
				if(isDeliveryShown==NO && [arrInfoAccount count]==0)
				{
					currentStateIdForDelivery=[[[arrayStates valueForKey:@"stateId"]objectAtIndex:row]intValue];
				}
				txtBillingField[5].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:row]];
				
			}
		}
		else
		{
			if([arrayStates count]>0)
			{  
                if(isDeliveryShown)
                {
                    if(isfromTag==1)
                    {
                        txtBillingField[5].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:row]]; 
                        
                        
                    }else
                    {
                        txtDeliveryField[3].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:row]];
                        
                        
                    }
					
                }
                else
                {
                    
                    if(!isEditMode)
                    { 
                        txtBillingField[5].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:row]]; 
                        txtDeliveryField[3].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:row]];
                        currentStateIdForDelivery=[[[arrayStates valueForKey:@"stateId"]objectAtIndex:row]intValue];
                        
                    }
                }
            }
		}
		if(txtDeliveryDetails[4])
		{
			
			
			if(!selectPicker)
			{
				if([arrayStates count]>0)
				{
        			txtDetails[4].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:row]];
				}
			}
			else
			{
				if([arrayStates count]>0)
				{
                    if(!isEditMode)
                    {
                        
                        
                        txtDeliveryDetails[3].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:row]];
                        currentStateIdForDelivery=[[[arrayStates valueForKey:@"stateId"]objectAtIndex:row]intValue];
                    }else
                    {
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

-(void)setStates
{
	[arrayStates removeAllObjects];
	
	for(int i=0; i<[interShippingDict count]; i++)
	{
		if([[[arrayCountry valueForKey:@"sCountry"]objectAtIndex:rowValue] isEqualToString:[NSString stringWithFormat:@"%@", [[interShippingDict objectAtIndex:i] valueForKey:@"sCountry"]]])
			[arrayStates addObject:[interShippingDict objectAtIndex:i]];
	}
	
	NSMutableArray *arrTempComp=[[NSMutableArray alloc]init];
	NSDictionary *contentDict = [dicSettings objectForKey:@"store"];
	arrTempComp=[contentDict valueForKey:@"taxList"];
	
	for(int i=0; i<[arrTempComp count]; i++)
	{
		if([[[arrayCountry valueForKey:@"sCountry"]objectAtIndex:rowValue] isEqualToString:[NSString stringWithFormat:@"%@", [[arrTempComp objectAtIndex:i] valueForKey:@"sCountry"]]])
		{
			if(![[arrayStates valueForKey:@"sState"]containsObject:[[arrTempComp objectAtIndex:i]valueForKey:@"sState"]])
				[arrayStates addObject:[arrTempComp objectAtIndex:i]];
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
	
	if(!selectPicker)
	{	
		if([arrayStates count]>0)
    		txtBillingField[5].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:0]];
	}
	else
	{
		if([arrayStates count]>0)
    		txtDeliveryField[3].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:0]];
	}
	if(txtDeliveryDetails[4])
	{
		if(!selectPicker)
		{
			if([arrayStates count]>0)
    			txtDetails[4].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:0]];
			
		}
		else
		{
			if([arrayStates count]>0)
            	txtDeliveryDetails[3].text = [NSString stringWithFormat:@"%@", [[arrayStates valueForKey:@"sState"]objectAtIndex:0]];
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[self createPickerView];
	[super viewDidLoad];
}



/* // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationLandscape);
 }
 
 */
-(void)viewWillDisappear:(BOOL)animated
{
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[lblCart release];
	for(int i=0; i<7; i++)
	{
		if(i<5)
		{
			if(lblDeliveryDetails[i])
			{
				[lblDeliveryDetails[i] release];
				lblDeliveryDetails[i]=nil;
			}
			if(txtDeliveryDetails[i])
			{
				[txtDeliveryDetails[i] release];
				txtDeliveryDetails[i]=nil;
			}
			if (txtDeliveryField[i]) 
				[txtDeliveryField[i] release];
		}
		if (i<2)
		{
			if(txtPassword[i])
				[txtPassword[i] release];
		}
		
		if(txtBillingField[i])
			[txtBillingField[i] release];
		
		if(lblDetails[i])
		{
			[lblDetails[i] release];
			lblDetails[i]=nil;
		}
		if(txtDetails[i])
		{
			[txtDetails[i] release];
			txtDetails[i]=nil;
		}
	}
	if(alertMain)
		[alertMain release];
	
	if(deliveryView)
		[deliveryView release];
	
	if(toolBar)
		[toolBar release];
	
	if(contentScrollView)
		[contentScrollView release];
	
	if(viewForRegistration)
		[viewForRegistration release];
	
	if(viewForLogin)
		[viewForLogin release];
	
	[interShippingDict release];
	[arrayStates release];
	[arrayCountry release];
	selectPicker=NO;
	[alertView1 release];
	
    [super dealloc];
}


@end
