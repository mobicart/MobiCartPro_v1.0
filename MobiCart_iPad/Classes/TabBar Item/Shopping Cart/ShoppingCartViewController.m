//
//  ShoppingCartViewController.m
//  Mobicart
//
//  Created by Mobicart on 11/05/11.
//  Copyright Mobicart. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "DetailsViewController.h"
BOOL isLoginClicked;
BOOL isRegisterClicked;
@implementation ShoppingCartViewController


#pragma mark  AppLife Cycle
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	arrDatabaseCart = [[SqlQuery shared]getShoppingCartProductIDs:NO];
	(isLoadingTableFooter2ndTime)?isLoadingTableFooter2ndTime=0:0;
	if(isLoadingTableFooter)
		isLoadingTableFooter2ndTime = TRUE;
	
	
	if ([arrDatabaseCart count]>0) 
	{
		selectedQuantity=[[[arrDatabaseCart objectAtIndex:0]valueForKey:@"quantity"]intValue];
		[self reloadMe];
	}
	else {
		[tableView removeFromSuperview];
		[tableView release];
		tableView = nil;
	}
	if ([arrDatabaseCart count]>0) 
	{
		UIButton *btnEdit = (UIButton *)[contentView viewWithTag:3333];
		[btnEdit setTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.shopping.cart.edit.cart"] forState:UIControlStateNormal]; 
	}
	else
    {
        
		UIButton *btnEdit = (UIButton *)[contentView viewWithTag:3333];
        [btnEdit setHidden:YES];
     }
	
	
	if ([[GlobalPrefrences getUserDefault_Preferences:@"userEmail"] length] ==0)
	{
		
		[self setRightContentView];
	}
    else {
		[self checkoutMethod];
	}
	[NSTimer scheduledTimerWithTimeInterval:0.1
									 target:self
								   selector:@selector(hideLoadingView)
								   userInfo:nil
									repeats:NO];
	
}

-(void)hideLoadingView
{
	[GlobalPrefrences dismissLoadingBar_AtBottom];	
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	isRegisterClicked = NO;
	isLoginClicked = NO;
	contentView=[[UIView alloc]initWithFrame:CGRectMake( 0, 0, 1024, 768)];	
	self.view=contentView;
	[GlobalPrefrences setBackgroundTheme_OnView:contentView];
	arrShoppingCart = [[NSMutableArray alloc] init];
	arrDatabaseCart = [[NSMutableArray alloc] init];
	
	dictSettingsDetails = [[NSDictionary alloc] init];
	dictSettingsDetails = [[GlobalPrefrences getSettingsOfUserAndOtherDetails]retain];
	
	UILabel *cartLbl=[[UILabel alloc]initWithFrame:CGRectMake(43, 18, 310, 28)];
	[cartLbl setBackgroundColor:[UIColor clearColor]];
	cartLbl.textColor = headingColor;
	[cartLbl setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.shoppingcart.yourcart"]];
	[cartLbl setFont:[UIFont boldSystemFontOfSize:14]];
	[contentView addSubview:cartLbl];
	[cartLbl release];
	
	
	UILabel *CheckoutLbl=[[UILabel alloc]initWithFrame:CGRectMake(550, 15, 90, 30)];
	[CheckoutLbl setBackgroundColor:[UIColor clearColor]];
	CheckoutLbl.textColor = headingColor;
	[CheckoutLbl setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.shoppingcart.checkout"]];
	[CheckoutLbl setHidden:NO];
	[CheckoutLbl setTag:6666];
	[CheckoutLbl setFont:[UIFont boldSystemFontOfSize:14]];
	[contentView addSubview:CheckoutLbl];
	[CheckoutLbl release];
	
	
	UIImageView *imgHorizontalDottedLine1=[[UIImageView alloc]initWithFrame:CGRectMake(550, 52, 416,2)];
	[imgHorizontalDottedLine1 setImage:[UIImage imageNamed:@"dot_line.png"]];
	[imgHorizontalDottedLine1 setHidden:NO];
	[imgHorizontalDottedLine1 setTag:7777];
	[contentView addSubview:imgHorizontalDottedLine1];
	[imgHorizontalDottedLine1 release];	
	
	UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(43, 52, 426,2)];
	[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
	
	[contentView addSubview:imgHorizontalDottedLine];
	[imgHorizontalDottedLine release];
	
	interDict = [[NSMutableArray alloc]init];
	NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
	arrTempShippingCountries=[[NSMutableArray alloc]init];
	
	NSDictionary *contentDict = [dictSettingsDetails objectForKey:@"store"];
	arrTemp = [contentDict objectForKey:@"taxList"];
	arrTempShippingCountries=[[contentDict objectForKey:@"shippingList"]retain];
	arrStates=[[NSMutableArray alloc]init];
	for(int i=0;i<[arrTemp count];i++)
	{
	    if (![[interDict valueForKey:@"sCountry"] containsObject:[[arrTemp objectAtIndex:i]valueForKey:@"sCountry"]]) {
			[interDict addObject:[arrTemp objectAtIndex:i]];
		}
		
	}
	for(int i=0;i<[arrTempShippingCountries count];i++)
	{
	    if (![[interDict valueForKey:@"sCountry"] containsObject:[[arrTempShippingCountries objectAtIndex:i]valueForKey:@"sCountry"]]) {
			[interDict addObject:[arrTempShippingCountries objectAtIndex:i]];
		}
		
	}
	[arrTempShippingCountries release];
	
	
	if([interDict count]>0)
		countryID=[[[interDict valueForKey:@"territoryId"]objectAtIndex:0]intValue];
	
	
	
	[arrStates removeAllObjects];
	for(int index=0;index<[arrTemp count];index++)
	{
		if(countryID==[[[arrTemp valueForKey:@"territoryId"]objectAtIndex:index]intValue])
		{
			[arrStates  addObject:[arrTemp objectAtIndex:index]];
		}
		
	}
	for(int index=0;index<[arrTempShippingCountries count];index++)
	{
		if(countryID==[[[arrTempShippingCountries valueForKey:@"territoryId"]objectAtIndex:index]intValue])
		{
			if(![[arrStates valueForKey:@"sState"]containsObject:[[arrTempShippingCountries valueForKey:@"sState"]objectAtIndex:index]])
				[arrStates  addObject:[arrTempShippingCountries objectAtIndex:index]];
		}
		
	}
	
	[interDict retain];
	
	
	//Notification to update the shopping cart controller
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(reloadMe)
												 name:@"updateShoppingCart_ViewController"
											   object:nil];
	
	arrQuantity = [[NSMutableArray alloc] init];
	
	
	[super viewDidLoad];
	
	UIButton *btnEdit=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnEdit setTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.shopping.cart.edit.cart"] forState:UIControlStateNormal];
	[btnEdit setTitleColor:btnTextColor forState:UIControlStateNormal];
	[btnEdit.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
	[btnEdit setBackgroundImage:[UIImage imageNamed:@"edit_cart_btn.png"] forState:UIControlStateNormal];
	btnEdit.backgroundColor = [UIColor clearColor];
	[btnEdit addTarget:self action:@selector(btnEdit_clicked) forControlEvents:UIControlEventTouchUpInside];
	[btnEdit setFrame:CGRectMake(405, 15, 65, 30)];
	[btnEdit setTag:3333];
	[contentView addSubview:btnEdit];
	
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(purchaseDone) name: @"hideTabBarItem" object:nil];
}


-(void)setRightContentView
{
	if (rightContentView)
	{
		NSArray *arrTemp = [rightContentView subviews];
		if([arrTemp count] > 0)
		{
			for(int i = 0; i <[arrTemp count]; i++)
				[[arrTemp objectAtIndex:i] removeFromSuperview];
		}
		[rightContentView removeFromSuperview];
		[rightContentView release];
		rightContentView = nil;
    }
	
	
	if (!rightContentView)
	{
		rightContentView = [[UIView alloc] initWithFrame:CGRectMake(547, 40, 512, 600)];
		[contentView addSubview:rightContentView];
	}
	
	UILabel *btncheckout = (UILabel *)[contentView viewWithTag:6666];
	[btncheckout setHidden:NO];
	
	rightContentView = [[UIView alloc] initWithFrame:CGRectMake(547, 40, 512, 600)];
	[contentView addSubview:rightContentView];
	UIView *rightSubView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 512, 600)];
	[rightContentView addSubview:rightSubView];
	UILabel *lblrightSubView = [[UILabel alloc] initWithFrame:CGRectMake(5,0, 350, 100)];
	[lblrightSubView setNumberOfLines:2];
	[lblrightSubView setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.shopping.cart.order.tocheckout"]];
	[lblrightSubView setBackgroundColor:[UIColor clearColor]];
	lblrightSubView.textColor= subHeadingColor;
	lblrightSubView.font = [UIFont boldSystemFontOfSize:17];
	[rightSubView addSubview:lblrightSubView];
	
	UIButton *btnLogin=[UIButton buttonWithType:UIButtonTypeCustom];
	btnLogin.backgroundColor=[UIColor clearColor];
	[btnLogin setFrame:CGRectMake(0, 90, 174, 39)];
	[btnLogin setTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.details.view.login"] forState:UIControlStateNormal];
	[btnLogin setBackgroundImage:[UIImage imageNamed:@"submit_btn.png"] forState:UIControlStateNormal];
	[btnLogin setTag:1234];
	[btnLogin.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
	btnLogin.titleLabel.textColor = [UIColor whiteColor];
	[btnLogin addTarget:self action:@selector(AccountInfo:) forControlEvents:UIControlEventTouchUpInside];
	
    [rightSubView addSubview:btnLogin];
	
	
	UIButton *btnRegister=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnRegister setFrame:CGRectMake(184, 90, 174, 39)];
	[btnRegister setTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.shopping.cart.register"] forState:UIControlStateNormal];
	[btnRegister setBackgroundImage:[UIImage imageNamed:@"submit_btn.png"] forState:UIControlStateNormal];
	[btnRegister setTag:5678];
	[btnRegister.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
	[btnRegister addTarget:self action:@selector(AccountInfo:) forControlEvents:UIControlEventTouchUpInside];
	btnRegister.titleLabel.textColor = headingColor;
    [rightSubView addSubview:btnRegister];
	
}
-(void)AccountInfo:(UIButton *)sender
{
    if(sender.tag == 1234)
	{
		isRegisterClicked = NO;
		isLoginClicked = YES;
	}
	else if (sender.tag == 5678)
	{
		isRegisterClicked = YES;
		isLoginClicked = NO;
	}
	UILabel *btncheckout = (UILabel *)[contentView viewWithTag:6666];
	[btncheckout setHidden:YES];
	UIImageView *imghorizontaline = (UIImageView *)[contentView viewWithTag:7777];
	[imghorizontaline setHidden:YES];
	if (rightContentView) {
		
		NSArray *arrTemp = [rightContentView subviews];
		if([arrTemp count] > 0)
		{
			for(int i = 0; i <[arrTemp count]; i++)
				[[arrTemp objectAtIndex:i] removeFromSuperview];
		}
		rightContentView = nil;
		[rightContentView release];		
	}
	
	if (!rightContentView) 
	{
		rightContentView = [[UIView alloc] initWithFrame:CGRectMake(560, 0, 512, 600)];
		[contentView addSubview:rightContentView];
	}
	
	DetailsViewController *objDetail=[[DetailsViewController alloc]init];			
	[rightContentView addSubview:objDetail.view];
	[rightContentView bringSubviewToFront:objDetail.view];
}
#pragma mark -
#pragma mark Edit/Done Handler
-(void)btnEdit_clicked
{
	UIToolbar *pickerBar = (UIToolbar *)[contentView viewWithTag:5656];
	if(pickerBar)
		[pickerBar removeFromSuperview];
	if(pickerViewQuantity)
		[pickerViewQuantity removeFromSuperview];
	
	
	
	UIButton *btnEdit = (UIButton *)[contentView viewWithTag:3333];
	if([btnEdit.titleLabel.text isEqualToString:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.shopping.cart.edit.cart"]]){
		isEditing=YES;
		[btnEdit setTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.shoppingcart.done"] forState:UIControlStateNormal];
		[tableView setEditing:YES animated:YES];
		
	} 
	else if([btnEdit.titleLabel.text isEqualToString: [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.shoppingcart.done"]]){
		isEditing=NO;
         [self.view setNeedsDisplay];
        UIToolbar *pickerBar = (UIToolbar *)[contentView viewWithTag:5656];
        [pickerBar removeFromSuperview];
        [pickerViewQuantity removeFromSuperview];
        NSLog(@"pickerViewQuantity->%d",[pickerViewQuantity retainCount]);
        if([pickerViewQuantity retainCount]>0)
        [pickerViewQuantity release];
        pickerViewQuantity = nil;
		[btnEdit setTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.shopping.cart.edit.cart"] forState:UIControlStateNormal];
		[tableView setEditing:NO animated:YES];
		if ([[GlobalPrefrences getUserDefault_Preferences:@"userEmail"] length] !=0)
		{
			
			[self checkoutMethod];
		}
		
	}
	
	(!isLoadingTableFooter2ndTime)?isLoadingTableFooter2ndTime=1:0; //disallowing the viewForFooterInSection to be executed
	
	if([arrShoppingCart count]==1)
    {
        tableView.frame=CGRectMake(43, 70, 454, 140) ;
      
    
    
    }
    else if([arrShoppingCart count]==2)
        
    {
       tableView.frame=CGRectMake(43, 70, 454, 300) ;
        
    }
	else
    {
       tableView.frame=CGRectMake(43, 70, 454, 400) ;
    }
    int i=[interDict count];
    if([interDict count]<12)
    {
        i=i*25;
        
    }else
    {
        i=300;    
    }
    tblCountries.frame=CGRectMake(15, 54, 138, i);
    int j=[arrStates count];
    if([arrStates count]<12)
    {
        j=j*25;
        
    }else
    {
        j=300;    
    }
    tblStates.frame=CGRectMake(15, 106, 138, j) ;
    [tblCountries reloadData];
    [tblStates reloadData];
    viewFooter.frame=CGRectMake(25, tableView.frame.size.height+tableView.frame.origin.x+30, 480, 500);
 
    [tableView reloadData];
	[self viewForFooter];
}
-(void)reloadMe
{
	[arrShoppingCart removeAllObjects];
	
	arrInfoAccount=[[NSMutableArray alloc]init];
	arrInfoAccount=[[SqlQuery shared] getAccountData:[GlobalPrefrences getUserDefault_Preferences:@"userEmail"]];
	
	int lcountryID=0,stateID=0;
	NSMutableArray *arrTemp=[[dictSettingsDetails objectForKey:@"store"]valueForKey:@"taxList" ];
	NSMutableArray *arrTempShppingStates=[[dictSettingsDetails objectForKey:@"store"]valueForKey:@"shippingList" ];
	NSMutableArray *tempDict = [[NSMutableArray alloc] init];
	if ([arrInfoAccount count]>0)
	{
		stateID=[[[NSUserDefaults standardUserDefaults] valueForKey:@"stateID"]intValue];
	    lcountryID=[[[NSUserDefaults standardUserDefaults] valueForKey:@"countryID"]intValue];
	}
	else 
    {
		for(int i=0;i<[arrTemp count];i++)
		{
			if (![[tempDict valueForKey:@"sCountry"] containsObject:[[arrTemp objectAtIndex:i]valueForKey:@"sCountry"]]) {
				[tempDict addObject:[arrTemp objectAtIndex:i]];
			}
			
		}
		for(int i=0;i<[arrTempShppingStates count];i++)
		{
			if (![[tempDict valueForKey:@"sCountry"] containsObject:[[arrTempShppingStates objectAtIndex:i]valueForKey:@"sCountry"]]) {
				[tempDict addObject:[arrTempShppingStates objectAtIndex:i]];
			}
			
		}		
		
		if([tempDict count]>0)
			lcountryID=[[[tempDict valueForKey:@"territoryId"]objectAtIndex:0]intValue];
		
		
		for (int index=0;index<[tempDict count];index++)
		{
			if ([[[tempDict objectAtIndex:index]valueForKey:@"sState"]isEqualToString:@"Other"]&& [[[tempDict objectAtIndex:index]valueForKey:@"territoryId"]intValue]==lcountryID)
			{
				stateID=[[[tempDict objectAtIndex:index]valueForKey:@"id"]intValue];
				break;
			}
		}
		[tempDict release];
	}
	
	countryID=lcountryID;
	
	[arrStates removeAllObjects];
	
	for (int index=0; index<[arrTemp count]; index++)
	{
		if (countryID==[[[arrTemp valueForKey:@"territoryId"]objectAtIndex:index]intValue])
		{
			[arrStates  addObject:[arrTemp objectAtIndex:index]];
		}
	}
	for (int index=0; index<[arrTempShppingStates count]; index++)
	{
		if (countryID==[[[arrTempShppingStates valueForKey:@"territoryId"]objectAtIndex:index]intValue])
		{
			if (![[arrStates valueForKey:@"sState"] containsObject:[[arrTempShppingStates valueForKey:@"sState"]objectAtIndex:index]])
            {
                [arrStates  addObject:[arrTempShppingStates objectAtIndex:index]];
            }
		}
	}
		
	for (int i=0; i<[arrDatabaseCart count]; i++)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		int productId = [[[arrDatabaseCart objectAtIndex:i] valueForKey:@"id"] intValue];
		
		// Fetch data from server0
		NSDictionary *dictProductDetails = [[ServerAPI fetchProductDetails:productId :lcountryID :stateID] objectForKey:@"product"];
		if([dictProductDetails isKindOfClass:[NSDictionary class]])
		{
			
			if (![[[arrDatabaseCart objectAtIndex:i] valueForKey:@"pOptionId"] isEqual:[NSNull null
																						]])
			{
				if ([[[arrDatabaseCart objectAtIndex:i] valueForKey:@"pOptionId"] intValue]==0)
				{
					if (![[dictProductDetails valueForKey:@"iAggregateQuantity"] isEqual:[NSNull null]])
					{
						if ([[dictProductDetails valueForKey:@"iAggregateQuantity"] intValue]!=0)
						{
							[arrShoppingCart addObject:dictProductDetails];
						}
						else
						{
							[[SqlQuery shared] deleteItemFromShoppingCart:productId :[[arrDatabaseCart objectAtIndex:i] valueForKey:@"pOptionId"]];
							[GlobalPrefrences setCurrentItemsInCart:NO];  
							
						}
					}
					else 
					{
						[arrShoppingCart addObject:dictProductDetails];
					}
				}
				else
				{
					NSMutableArray *dictOption = [dictProductDetails objectForKey:@"productOptions"];
					
					NSMutableArray *dictOptionID=[[NSMutableArray alloc]init];
					
					[dictOptionID removeAllObjects];
					
					for (int j=0; j<[dictOption count]; j++)
					{
						[dictOptionID addObject:[[dictOption objectAtIndex:j] valueForKey:@"id"]];
					}
					NSString *strOptions=[[arrDatabaseCart objectAtIndex:i] valueForKey:@"pOptionId"];
					NSArray *arrOptions=[strOptions componentsSeparatedByString:@","];		
					
					int optionIndex[100];
					
					for(int count=0;count<[arrOptions count];count++)
						
					{
						optionIndex[count] = [dictOptionID indexOfObject:[NSNumber numberWithInt:[[arrOptions objectAtIndex:count] intValue]]];
						
						
					}
					BOOL isOutOfStock=NO;
					for(int i=0;i<[arrOptions count];i++)
					{
						
						if ([[[dictOption objectAtIndex:optionIndex[i]] valueForKey:@"iAvailableQuantity"] intValue]==0)
						{
							isOutOfStock=YES;
							break;
						}
						
						
					}
					
					if(isOutOfStock==NO)
					{
						[arrShoppingCart addObject:dictProductDetails];
					}
					else
					{
						[[SqlQuery shared] deleteItemFromShoppingCart:productId :[[arrDatabaseCart objectAtIndex:i] valueForKey:@"pOptionId"]];
						[GlobalPrefrences setCurrentItemsInCart:NO];  
						
					}
					[dictOptionID release];
				}
			}
			
			
		}
		else {
			[[SqlQuery shared] deleteItemFromShoppingCart:productId :[[arrDatabaseCart objectAtIndex:i] valueForKey:@"pOptionId"]];	
			[GlobalPrefrences setCurrentItemsInCart:NO]; 
			
		}
		
		
		[pool release];
	}
	arrDatabaseCart = [[SqlQuery shared]getShoppingCartProductIDs:NO];
	if([arrDatabaseCart count]>0)
	{
		[self createTableView];
	}
	
}

-(void)getCountryTable
{
	
	viewFooter = [contentView viewWithTag:8888];
	tblStates.hidden = YES;
	tblCountries.hidden = !tblCountries.hidden;	
	[viewFooter bringSubviewToFront:tblCountries];
}
-(void)getStatesTable:(id)sender
{
	[tblCountries setHidden:YES];
	
	tblStates.hidden = !tblStates.hidden;
	
}

#pragma mark createTableView
-(void)createTableView
{
	NSArray *arrStateAndCountryID=[[TaxCalculation shared]getStateAndCountryIDForTax];
	int lcountryID;
	
	int stateID;
	
	
	if([arrInfoAccount count]>0)
	{
		lcountryID	=[[arrStateAndCountryID objectAtIndex:1] intValue];
		stateID	=[[arrStateAndCountryID objectAtIndex:0]intValue];
	}
	else {
		if([interDict count]>0)
		{
			NSDictionary *dictTemp = [interDict objectAtIndex:0];
			
			lcountryID=[[dictTemp valueForKey:@"territoryId"]intValue];
			stateID=[[dictTemp valueForKey:@"stateId"]intValue];
			
		}
	}
	
	dictTaxAndShippingDetails = [[ServerAPI fetchTaxShippingDetails:lcountryID :stateID:iCurrentStoreId] retain];
	
	
	
    
	if(tableView)
	{
		[tableView removeFromSuperview];
		[tableView release];
		tableView = nil;
		
	}
	if([arrShoppingCart count]==1)
    {
        tableView=[[UITableView alloc]initWithFrame:CGRectMake(43, 70, 454, 140) style:UITableViewStylePlain];
        
      
        
    }
    else if([arrShoppingCart count]==2)

    {
        tableView=[[UITableView alloc]initWithFrame:CGRectMake(43, 70, 454, 300) style:UITableViewStylePlain];
        
    }
	else
    {
      tableView=[[UITableView alloc]initWithFrame:CGRectMake(43, 70, 454, 400) style:UITableViewStylePlain];  
    }
    
    
    
	tableView.delegate=self;
	tableView.dataSource=self;
	
	[tableView setBackgroundColor:[UIColor clearColor]];
	[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[contentView addSubview:tableView];
	
	UIImageView *imgbackground=[[UIImageView alloc]initWithFrame:CGRectMake(25,  tableView.frame.size.height+tableView.frame.origin.x+30, 480, 500)];
	[imgbackground setImage:[UIImage imageNamed:@"bgview.png"]];
	imgbackground.backgroundColor=backGroundColor;	
	imgbackground.alpha = 0.2;	
	[imgbackground release];
	viewFooter = [[UIView alloc]initWithFrame:CGRectMake(25, tableView.frame.size.height+tableView.frame.origin.x+30, 480, 500)];
	viewFooter.tag = 8888;
	viewFooter.backgroundColor=[UIColor clearColor];
	isLoadingTableFooter2ndTime=NO;
	
	if(!lblSubTotalFooter)
		lblSubTotalFooter=[[UILabel alloc]init];
	lblSubTotalFooter.backgroundColor=[UIColor clearColor];
	[lblSubTotalFooter setTextAlignment:UITextAlignmentLeft];
	lblSubTotalFooter.textColor=subHeadingColor;
	[lblSubTotalFooter setNumberOfLines:0];
	lblSubTotalFooter.lineBreakMode = UILineBreakModeWordWrap;
	lblSubTotalFooter.font=[UIFont boldSystemFontOfSize:15];
	lblSubTotalFooter.frame = CGRectMake(320,14,130,20);
	[viewFooter addSubview:lblSubTotalFooter];
	
	if(!lblGrandTotalFooter)
		lblGrandTotalFooter=[[UILabel alloc]init];
	lblGrandTotalFooter.backgroundColor=[UIColor clearColor];
	[lblGrandTotalFooter setTextAlignment:UITextAlignmentLeft];
	lblGrandTotalFooter.textColor=subHeadingColor;
	[lblGrandTotalFooter setNumberOfLines:0];
	lblGrandTotalFooter.lineBreakMode = UILineBreakModeTailTruncation;
	lblGrandTotalFooter.font=[UIFont boldSystemFontOfSize:20];
	lblGrandTotalFooter.frame = CGRectMake(308,95,140,20);
	[viewFooter addSubview:lblGrandTotalFooter];
	
	if(!lblTax)
		lblTax=[[UILabel alloc]init];
	lblTax.backgroundColor=[UIColor clearColor];
	[lblTax setTextAlignment:UITextAlignmentLeft];
	lblTax.textColor=subHeadingColor;
	[lblTax setNumberOfLines:0];
	lblTax.lineBreakMode = UILineBreakModeTailTruncation;
	lblTax.font=[UIFont boldSystemFontOfSize:15];
	lblTax.frame = CGRectMake(282,32,150,20);
	[viewFooter addSubview:lblTax];
	
	if(!lblShippingCharges)
		lblShippingCharges=[[UILabel alloc]init];
	lblShippingCharges.backgroundColor=[UIColor clearColor];
	[lblShippingCharges setTextAlignment:UITextAlignmentLeft];
	lblShippingCharges.textColor=subHeadingColor;
	[lblShippingCharges setNumberOfLines:0];
	lblShippingCharges.lineBreakMode = UILineBreakModeTailTruncation;
	lblShippingCharges.font=[UIFont boldSystemFontOfSize:15];
	lblShippingCharges.frame = CGRectMake(319,50,130,20);
	[viewFooter addSubview:lblShippingCharges];
	
	if(!lblShippingTax)
		lblShippingTax=[[UILabel alloc]init];
	lblShippingTax.backgroundColor=[UIColor clearColor];
	[lblShippingTax setTextAlignment:UITextAlignmentLeft];
	lblShippingTax.textColor=subHeadingColor;
	[lblShippingTax setNumberOfLines:0];
	lblShippingTax.lineBreakMode = UILineBreakModeTailTruncation;
	lblShippingTax.font=[UIFont boldSystemFontOfSize:15];
	lblShippingTax.frame = CGRectMake(349,68,120,20);
	[viewFooter addSubview:lblShippingTax];
	
	
	UILabel *lblShippingChargesTitle = [[UILabel alloc]initWithFrame:CGRectMake(245,50, 74, 20)];
	lblShippingChargesTitle.backgroundColor=[UIColor clearColor];
	[lblShippingChargesTitle setTextAlignment:UITextAlignmentLeft];
	lblShippingChargesTitle.textColor=headingColor;
	[lblShippingChargesTitle setText:[NSString stringWithFormat:@"%@: ",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.shoppingcart.shipping"]]];
	lblShippingChargesTitle.font = [UIFont boldSystemFontOfSize:15];
	[viewFooter addSubview:lblShippingChargesTitle];
	[lblShippingChargesTitle release];		
	
	
	UILabel *lblShippingTaxTitle = [[UILabel alloc]initWithFrame:CGRectMake(245,68, 104, 20)];
	lblShippingTaxTitle.backgroundColor=[UIColor clearColor];
	[lblShippingTaxTitle setTextAlignment:UITextAlignmentLeft];
	lblShippingTaxTitle.textColor=headingColor;
	[lblShippingTaxTitle setText:[NSString stringWithFormat:@"%@: ",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.shoppingcart.tax.shipping"]]];
	lblShippingTaxTitle.font = [UIFont boldSystemFontOfSize:15];
	[viewFooter addSubview:lblShippingTaxTitle];
	[lblShippingTaxTitle release];
	
	
	UILabel *lblSubTotalFooterTitle = [[UILabel alloc]initWithFrame:CGRectMake(245,14, 75, 20)];
	lblSubTotalFooterTitle.backgroundColor=[UIColor clearColor];
	[lblSubTotalFooterTitle setTextAlignment:UITextAlignmentLeft];
	lblSubTotalFooterTitle.textColor=headingColor;
	[lblSubTotalFooterTitle setText:[NSString stringWithFormat:@"%@: ",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.shoppingcart.subtotal"]]];
	lblSubTotalFooterTitle.font = [UIFont boldSystemFontOfSize:15];
	[viewFooter addSubview:lblSubTotalFooterTitle];
	[lblSubTotalFooterTitle release];
	
	
	UILabel *lblTaxTitle = [[UILabel alloc]initWithFrame:CGRectMake(245,32, 39, 20)];
	lblTaxTitle.backgroundColor=[UIColor clearColor];
	[lblTaxTitle setTextAlignment:UITextAlignmentLeft];
	lblTaxTitle.textColor=headingColor;
	[lblTaxTitle setText:[NSString stringWithFormat:@"%@: ",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.shoppingcart.tax"]]];
	lblTaxTitle.font = [UIFont boldSystemFontOfSize:15];
	[viewFooter addSubview:lblTaxTitle];
	[lblTaxTitle release];	
	
	
	UILabel *lblGrandTotalFooterTitle = [[UILabel alloc]initWithFrame:CGRectMake(245,95, 80, 20)];
	lblGrandTotalFooterTitle.backgroundColor=[UIColor clearColor];
	[lblGrandTotalFooterTitle setTextAlignment:UITextAlignmentLeft];
	lblGrandTotalFooterTitle.textColor=headingColor;
	[lblGrandTotalFooterTitle setText:[NSString stringWithFormat:@"%@: ",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.shoppingcart.total"]]];
	lblGrandTotalFooterTitle.font = [UIFont boldSystemFontOfSize:20];
	[viewFooter addSubview:lblGrandTotalFooterTitle];
	[lblGrandTotalFooterTitle release];
	
	UIButton *optionBtn=[UIButton buttonWithType:UIButtonTypeCustom];
	[optionBtn setBackgroundColor:[UIColor clearColor]];
	[optionBtn setFrame:CGRectMake(15, 30, 138, 26)];
	[optionBtn setImage:[UIImage imageNamed:@"drop_down.png"] forState:UIControlStateNormal];
	[optionBtn addTarget:self action:@selector(getCountryTable) forControlEvents:UIControlEventTouchUpInside];
	[viewFooter addSubview:optionBtn];
	
	UIButton *btnStatesPicker=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnStatesPicker setBackgroundColor:[UIColor clearColor]];
	[btnStatesPicker setFrame:CGRectMake(15, 82, 138, 26)];
	[btnStatesPicker setImage:[UIImage imageNamed:@"drop_down.png"] forState:UIControlStateNormal];
	[btnStatesPicker addTarget:self action:@selector(getStatesTable:) forControlEvents:UIControlEventTouchUpInside];
	[viewFooter addSubview:btnStatesPicker];
	
	
	if(!lblCountryName)
		lblCountryName=[[UILabel alloc]initWithFrame:CGRectMake(16, 33, 100, 20)];
	lblCountryName.backgroundColor=[UIColor clearColor];
	[lblCountryName setTextAlignment:UITextAlignmentCenter];
	lblCountryName.textColor = [UIColor blackColor];;
	[lblCountryName setBackgroundColor:[UIColor clearColor]];
	[lblCountryName setNumberOfLines:0];
	[lblCountryName setText:@""];
	lblCountryName.lineBreakMode = UILineBreakModeTailTruncation;
	lblCountryName.font=[UIFont boldSystemFontOfSize:12];
	[viewFooter addSubview:lblCountryName];	
	
	if(!lblStateName)
		lblStateName=[[UILabel alloc]initWithFrame:CGRectMake(16, 85, 100, 20)];
	lblStateName.backgroundColor=[UIColor clearColor];
	[lblStateName setTextAlignment:UITextAlignmentCenter];
	lblStateName.textColor = [UIColor blackColor];
	[lblStateName setBackgroundColor:[UIColor clearColor]];
	[lblStateName setNumberOfLines:0];
	[lblStateName setText:@""];
	lblStateName.lineBreakMode = UILineBreakModeTailTruncation;
	lblStateName.font=[UIFont boldSystemFontOfSize:12];
	[viewFooter addSubview:lblStateName];	
	
	if([arrInfoAccount count]>0)
	{
		lblStateName.text=[arrInfoAccount objectAtIndex:8];
		lblCountryName.text=[arrInfoAccount objectAtIndex:10];
	}
	else
	{		
		NSString *strCountryname=[[NSString alloc]init];
		if([interDict count]>0)
		{
			NSDictionary *dictTemp = [interDict objectAtIndex:0];
			strCountryname=  [dictTemp objectForKey:@"sCountry"];
			countryID=[[dictTemp valueForKey:@"territoryId"]intValue];
			[lblStateName setText:[dictTemp valueForKey:@"sState"] ];
		}
		else
		{
			strCountryname=@"No Country Defined";
			[lblStateName setText:@"No State Defined"];
		}
		
		lblCountryName.text=strCountryname;
	}
	

    [contentView addSubview: viewFooter];
	
	[self viewForFooter];
	
	UILabel *lblChooseCountry = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 124, 25)];
	[lblChooseCountry setText:[NSString stringWithFormat:@"%@:",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.shoppingcart.choosecountry"]]];
	[lblChooseCountry setBackgroundColor:[UIColor clearColor]];
	lblChooseCountry.textColor=subHeadingColor;
	[lblChooseCountry setTextAlignment:UITextAlignmentLeft];
	[lblChooseCountry setFont:[UIFont boldSystemFontOfSize:13]];
	[viewFooter addSubview:lblChooseCountry];
	[lblChooseCountry release];
	if(tblCountries)
	{
		[tblCountries removeFromSuperview];
		[tblCountries release];
		tblCountries = nil;
	}
	int i = [interDict count];
	if(i<12)
	{
		i = i *25;
	}
	else {
		i = 300;
	}
	tblCountries=[[UITableView alloc]initWithFrame:CGRectMake(15, 54, 138, i) style:UITableViewStylePlain];
	tblCountries.delegate=self;
	tblCountries.dataSource=self;
	[tblCountries setHidden:YES];
    tblCountries.showsVerticalScrollIndicator = FALSE;
	[[tblCountries layer] setCornerRadius:5.0];
	[[tblCountries layer] setBorderColor:[[UIColor blackColor] CGColor]];
	tblCountries.layer.borderWidth = 1.0;
	[tblCountries setBackgroundColor:[UIColor colorWithRed:95.8 green:95.8 blue:95.8 alpha:1.0]];
	[viewFooter addSubview:tblCountries];
	
	
	UILabel *lblChooseState = [[UILabel alloc] initWithFrame:CGRectMake(15, 61, 124, 25)];
	[lblChooseState setText:[NSString stringWithFormat:@"%@:",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.shoppingcart.choose.state"]]];
	[lblChooseState setBackgroundColor:[UIColor clearColor]];
	lblChooseState.textColor=subHeadingColor;
	[lblChooseState setTextAlignment:UITextAlignmentLeft];
	[lblChooseState setFont:[UIFont boldSystemFontOfSize:13]];
	[viewFooter addSubview:lblChooseState];
	[lblChooseState release];
	if(tblStates)
	{
		[tblStates removeFromSuperview];
		[tblStates release];
		tblStates = nil;
	}
	int j = [arrStates count];
	
	if(j<12)
	{
		j = j *25;
	}
	else {
		j = 300;
	}

	tblStates=[[UITableView alloc]initWithFrame:CGRectMake(15, 106, 138, j) style:UITableViewStylePlain];
	tblStates.delegate=self;
	tblStates.dataSource=self;
	tblStates.showsVerticalScrollIndicator = FALSE;
	[[tblStates layer] setCornerRadius:5.0];
	tblStates.layer.borderWidth = 1.0;
	[[tblStates layer] setBorderColor:[[UIColor blackColor] CGColor]];
	[tblStates setBackgroundColor:[UIColor colorWithRed:95.8 green:95.8 blue:95.8 alpha:1.0]];
	[viewFooter addSubview:tblStates];
	[tblStates setHidden:YES];
	[viewFooter release];
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	tblStates.hidden = YES;
	tblCountries.hidden = YES;
	
}
-(void)showLoading
{
	[GlobalPrefrences addLoadingBar_AtBottom:self.tabBarController.view withTextToDisplay:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
}
#pragma mark Checkout Handler
-(void)checkoutMethod
{
	if(iNumOfItemsInShoppingCart > 0)
	{
		if ([[GlobalPrefrences getUserDefault_Preferences:@"userEmail"] length]!=0)
			
		{
			
			if (rightContentView)
			{
				NSArray *arrTemp = [rightContentView subviews];
				if([arrTemp count] > 0)
				{
					for(int i = 0; i <[arrTemp count]; i++)
						[[arrTemp objectAtIndex:i] removeFromSuperview];
				}
				[rightContentView removeFromSuperview];
				[rightContentView release];
				rightContentView = nil;
			}
			
			
			if (!rightContentView)
			{
				rightContentView = [[UIView alloc] initWithFrame:CGRectMake(560, 70, 512, 600)];
				[contentView addSubview:rightContentView];
			}
			
			CheckoutViewController *objCheckout=[[CheckoutViewController alloc]init];
			NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
			
			for (int i=0; i<[arrDatabaseCart count]; i++)
			{
				NSDictionary *dictTemp = [arrShoppingCart objectAtIndex:i];
				
				NSMutableDictionary *dictTemp1=[[NSMutableDictionary alloc]initWithDictionary:dictTemp];
				
				[dictTemp1 setValue:[[arrDatabaseCart objectAtIndex:i] objectForKey:@"quantity"] forKey:@"quantity"];
				[dictTemp1 setValue:[[arrDatabaseCart objectAtIndex:i] objectForKey:@"pOptionId"] forKey:@"pOptionId"];
				
				[arrTemp addObject:dictTemp1];
				[dictTemp1 release];
			}
			objCheckout.arrProductIds = arrTemp;
			objCheckout.arrCartItems=arrDatabaseCart;
			
			[arrTemp release];
			[rightContentView addSubview:objCheckout.view];
			
			[objCheckout release];
		}
		else {
			alertLogin=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.title"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.must.login"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			[alertLogin show];
			[alertLogin release];
		}
	}
	
	else {
		
		if (rightContentView)
		{
			NSArray *arrTemp = [rightContentView subviews];
			if([arrTemp count] > 0)
			{
				for(int i = 0; i <[arrTemp count]; i++)
					[[arrTemp objectAtIndex:i] removeFromSuperview];
			}
			[rightContentView removeFromSuperview];
			[rightContentView release];
			rightContentView = nil;
		}
		
    }
	
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView == alertLogin)
	{
		[self setRightContentView];
	}
	
}
#pragma mark TableView Delegate Method

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(_tableView == tblCountries)
		return 25;
	else if(_tableView == tblStates)
		return 25;
	else
	{
		if (!([[[arrDatabaseCart objectAtIndex:indexPath.row] valueForKey:@"pOptionId"] intValue]==0))
		{
			
			NSArray *arrSelectedOptions=[[[arrDatabaseCart objectAtIndex:indexPath.row] valueForKey:@"pOptionId"] componentsSeparatedByString:@","];
			
			int optionsCount=[arrSelectedOptions count];
			return 120+(optionsCount-1)*15;
		}
		else {
			return 130;
		}
	}
}

- (NSInteger) tableView:(UITableView*) _tableView numberOfRowsInSection:(NSInteger) section
{	
	if(_tableView == tblCountries)
		return [interDict count];
	else if(_tableView == tblStates)
		return [arrStates count];
	else
		return [arrShoppingCart count];
	
}


- (UITableViewCell*) tableView:(UITableView*)tableview cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
	NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableIdentifier%d", indexPath.row];
	TableViewCell_Common *cell= (TableViewCell_Common *)[tableview dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
  	if(tableview == tblCountries)
	{
		int i = [interDict count];
		
      
		
            if([arrShoppingCart count]==1)
            {
                if(i<12)
                {
                    i = i *25;
                }else
                {
                 i = 300;    
                }
                
            }
            else if([arrShoppingCart count]==2)
            {
                if(i<9)
                {
                    i = i *25;
                }else
                {
                    i = 200;    
                }
 
            }
			else{
                
                if(i<6)
                {
                    i = i *25;
                }else
                {
                    i = 150;    
                }  
            }
            
            
		
		tblCountries.frame = CGRectMake(15, 54, 138, i);
		NSDictionary *dictTemp = [interDict objectAtIndex:indexPath.row];
		
		if(cell==nil)
		{	
			cell =[[[TableViewCell_Common alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier]autorelease];
		}
		[cell setBackgroundColor:[UIColor whiteColor]];
		cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        cell.textLabel.text = [dictTemp objectForKey:@"sCountry"];
		[cell.textLabel setTextAlignment:UITextAlignmentCenter];
		
	}
	else if(tableview==tblStates)
	{
		int j = [arrStates count];
		        
        
        if([arrShoppingCart count]==1)
        {
            if(j<12)
            {
                j=j*25;
            }
            else
            {
              j = 300;  
            }
         
        }
        else if([arrShoppingCart count]==2)
        {
            if(j<7)
            {
                j=j*25;
            }
            else
            {
                j = 200;  
            }
            
        }
        else
        {
            if(j<5)
            {
                j=j*25;
            }
            else
            {
                j = 100;  
            }
        }      
        
        
		tblStates.frame =CGRectMake(15, 106, 138, j);
		if(cell==nil)
		{	
			cell = [[[TableViewCell_Common alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier]autorelease];
		}
		[cell setBackgroundColor:[UIColor whiteColor]];
		cell.textLabel.font = [UIFont systemFontOfSize:13.0];
		cell.textLabel.text = [[arrStates valueForKey:@"sState"]objectAtIndex:indexPath.row];
		[cell.textLabel setTextAlignment:UITextAlignmentCenter];
		
	}
	else if (tableview==tableView)
	{
		float productCost = 0.0f;
		productCost=[[TaxCalculation shared]caluateTaxForProductInShoppingCart:arrShoppingCart forIndexPath:indexPath];
		
		float productSubTotal = productCost * [[[arrDatabaseCart objectAtIndex:indexPath.row]valueForKey:@"quantity"] intValue];
		productCost=[GlobalPrefrences getRoundedOffValue:productCost];
		productSubTotal=[GlobalPrefrences getRoundedOffValue:productSubTotal];
		
		if (cell==nil)
		{
			cell = [[TableViewCell_Common alloc] initWithStyleFor_Store_ProductView:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
			
			
			UILabel *lblOptionTitle[100];
			UILabel *lblOptionName[100];
			int optionSizesIndex[100];
			int yValue=55;
			if (!([[[arrDatabaseCart objectAtIndex:indexPath.row] valueForKey:@"pOptionId"] intValue]==0))
			{
				
				NSMutableArray *dictOption = [[arrShoppingCart objectAtIndex:indexPath.row] objectForKey:@"productOptions"];
				
				NSMutableArray *arrProductOptionSize = [[[NSMutableArray alloc] init] autorelease];
				
				for (int i=0; i<[dictOption count]; i++)
                {
                    [arrProductOptionSize addObject:[[dictOption objectAtIndex:i] valueForKey:@"id"]];
                }
				
				NSArray *arrSelectedOptions=[[[arrDatabaseCart objectAtIndex:indexPath.row] valueForKey:@"pOptionId"] componentsSeparatedByString:@","];
				
				if([arrProductOptionSize count]!=0 && [arrSelectedOptions count]!=0)
				{
					for(int count=0;count<[arrSelectedOptions count];count++)
					{
						if ([arrProductOptionSize containsObject: [NSNumber numberWithInt:[[arrSelectedOptions objectAtIndex:count] integerValue]]])
						{
							optionSizesIndex[count] = [arrProductOptionSize indexOfObject:[NSNumber numberWithInt:[[arrSelectedOptions objectAtIndex:count]  intValue]]];
						}
					}
				}
				
				
				
				for(int count=0;count<[arrSelectedOptions count];count++)
				{
					float pOPrice=0;
                    
                    
                    pOPrice =pOPrice+[[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"pPrice"]floatValue];
                 
                    productCost+=pOPrice;
                    productSubTotal = productCost * [[[arrDatabaseCart objectAtIndex:indexPath.row]valueForKey:@"quantity"] intValue];
                    productCost=[GlobalPrefrences getRoundedOffValue:productCost];
                    
                    
                    productSubTotal=[GlobalPrefrences getRoundedOffValue:productSubTotal];
                    
                    
                    
					CGSize size=[[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"sTitle"]sizeWithFont:[UIFont boldSystemFontOfSize:13]];
					int width=size.width;
					if(width>100)
						width=100;
					
					lblOptionTitle[count] = [[UILabel alloc]initWithFrame:CGRectMake(107,yValue,width+9,20)];
					lblOptionTitle[count].backgroundColor=[UIColor clearColor];
					[lblOptionTitle[count] setTextAlignment:UITextAlignmentLeft];
					lblOptionTitle[count].textColor=headingColor;
					[lblOptionTitle[count] setNumberOfLines:0];
					[lblOptionTitle[count] setText: [NSString stringWithFormat:@"%@:",[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"sTitle"]]];
					lblOptionTitle[count].lineBreakMode = UILineBreakModeWordWrap;
					lblOptionTitle[count].lineBreakMode = UILineBreakModeTailTruncation;
					lblOptionTitle[count].font=[UIFont boldSystemFontOfSize:13];
					[cell.contentView addSubview:lblOptionTitle[count]];
					
					
					CGSize size1=[[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"sName"] sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:CGSizeMake(1000, 20)];
					int width1=size1.width;
					if(width1>(100-lblOptionTitle[count].frame.size.width)+90)
						width1=(100-lblOptionTitle[count].frame.size.width)+90;
					[lblOptionTitle[count] release];
					
					lblOptionName[count] = [[UILabel alloc]initWithFrame:CGRectMake(lblOptionTitle[count].frame.size.width+lblOptionTitle[count].frame.origin.x,yValue,width1,20)];
					lblOptionName[count].backgroundColor=[UIColor clearColor];
					[lblOptionName[count] setTextAlignment:UITextAlignmentLeft];
					lblOptionName[count].textColor=subHeadingColor;
					[lblOptionName[count] setNumberOfLines:0];
					[lblOptionName[count] setText: [NSString stringWithFormat:@"%@",[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"sName"]]];
					lblOptionName[count].lineBreakMode = UILineBreakModeWordWrap;
					lblOptionName[count].lineBreakMode = UILineBreakModeTailTruncation;
					lblOptionName[count].font=[UIFont boldSystemFontOfSize:13];
					[cell.contentView addSubview:lblOptionName[count]];
					[lblOptionName[count] release];
					
					yValue=yValue+15;
				}	
				
			}
			int j=0;
			if(yValue > 55)
				j = 43+yValue;
			else {
				j = 128;
			}
			UIImageView *imgSeprator=[[UIImageView alloc]initWithFrame:CGRectMake(2, j, 420, 2)];
			[imgSeprator setImage:[UIImage imageNamed:@"dotted_line_02.png"]];
			[imgSeprator setBackgroundColor:[UIColor clearColor]];
			[cell addSubview:imgSeprator];
			
			
			NSString *strText=[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, productSubTotal];
			CGSize size=[strText sizeWithFont:[UIFont boldSystemFontOfSize:12.00] constrainedToSize:CGSizeMake(500,500) lineBreakMode:UILineBreakModeWordWrap];
			int x=size.width;
			if(x>80)
				x=80;
			
			UILabel *productTotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(400-x,78,x+10,20)];
			productTotalPrice.backgroundColor=[UIColor clearColor];
			[productTotalPrice setTextAlignment:UITextAlignmentLeft];
			productTotalPrice.textColor=subHeadingColor;
			[productTotalPrice setNumberOfLines:0];
			productTotalPrice.tag = [[NSString stringWithFormat:@"1000%d",indexPath.row] intValue];
			[productTotalPrice setText:[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, productSubTotal]];
			productTotalPrice.lineBreakMode=UILineBreakModeTailTruncation;
			productTotalPrice.font=[UIFont boldSystemFontOfSize:13];
			[cell addSubview:productTotalPrice];
			
			UILabel *productTotalPriceTitle = [[UILabel alloc]initWithFrame:CGRectMake(productTotalPrice.frame.origin.x-70,78, 65, 20)];
			productTotalPriceTitle.backgroundColor=[UIColor clearColor];
			[productTotalPriceTitle setTextAlignment:UITextAlignmentRight];
			productTotalPriceTitle.textColor=headingColor;
			[productTotalPriceTitle setNumberOfLines:0];
			[productTotalPriceTitle setTag:[[NSString stringWithFormat:@"999%d",indexPath.row] intValue]];
			[productTotalPriceTitle setText:[NSString stringWithFormat:@"%@:",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.shoppingcart.subtotal"]]];
			productTotalPriceTitle.lineBreakMode = UILineBreakModeWordWrap;
			productTotalPriceTitle.lineBreakMode=UILineBreakModeTailTruncation;
			productTotalPriceTitle.font=[UIFont boldSystemFontOfSize:13];
			[cell addSubview:productTotalPriceTitle];
			[productTotalPriceTitle release];
			
			
			int xTemp;
			xTemp=productTotalPrice.frame.origin.x+productTotalPrice.frame.size.width-25;
			UILabel *lblQuantityTitle = [[UILabel alloc]initWithFrame:CGRectMake(xTemp-2,0, 25, 25)];
			lblQuantityTitle.backgroundColor=[UIColor clearColor];
			[lblQuantityTitle setTextAlignment:UITextAlignmentRight];
			lblQuantityTitle.textColor=subHeadingColor;
			[lblQuantityTitle setNumberOfLines:0];
			lblQuantityTitle.text=[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.shoppingcart.qty"];
			lblQuantityTitle.lineBreakMode = UILineBreakModeWordWrap;
			lblQuantityTitle.tag = [[NSString stringWithFormat:@"88%d0%d",indexPath.row+1,indexPath.row+1] intValue];
			lblQuantityTitle.font=[UIFont boldSystemFontOfSize:11];
			[cell addSubview:lblQuantityTitle];
			[lblQuantityTitle release];
			
            
            UILabel *lblQuantity = [[UILabel alloc]initWithFrame:CGRectMake(xTemp-11, 25, 42, 26)];
			lblQuantity.backgroundColor=[UIColor clearColor];
			[lblQuantity setTextAlignment:UITextAlignmentCenter];
			lblQuantity.textColor=headingColor;
			[lblQuantity setNumberOfLines:0];
			lblQuantity.text = [[arrDatabaseCart objectAtIndex:indexPath.row] valueForKey:@"quantity"];
			lblQuantity.lineBreakMode = UILineBreakModeWordWrap;
			lblQuantity.font=[UIFont systemFontOfSize:14];
			lblQuantity.tag = [[NSString stringWithFormat:@"99%d0%d",indexPath.row+1,indexPath.row+1] intValue];
			[cell addSubview:lblQuantity];
			[lblQuantity release];
			
			
			UIButton *btnQuantity = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			btnQuantity.frame=CGRectMake(xTemp-5,27, 26, 27); 
			btnQuantity.backgroundColor=[UIColor clearColor];
			[btnQuantity setBackgroundImage:[UIImage imageNamed:@"shop_box.png"] forState:UIControlStateNormal];
			[btnQuantity setTitle:[[arrDatabaseCart objectAtIndex:indexPath.row] valueForKey:@"quantity"] forState:UIControlStateNormal];
			[btnQuantity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			btnQuantity.titleLabel.font=	[UIFont fontWithName:@"Helvetica" size:15];
			btnQuantity.tag = [[NSString stringWithFormat:@"%d0%d",indexPath.row+1, indexPath.row+1] intValue];
			[btnQuantity addTarget:self action:@selector(btnQuantity_Clicked:) forControlEvents:UIControlEventTouchUpInside];
			[cell addSubview:btnQuantity];
			btnQuantity.hidden= TRUE;
		
			
			
			UIImage *imgProduct;
			NSDictionary *dictTemp=[arrShoppingCart objectAtIndex:indexPath.row];
			NSArray  *arrImagesUrls = [dictTemp objectForKey:@"productImages"];
			
			
			if ([arrImagesUrls count]!=0)
			{
				NSData *data = [ServerAPI fetchBannerImage:[[arrImagesUrls objectAtIndex:0] valueForKey:@"productImageSmallIpad"]];
				imgProduct = [UIImage imageWithData:data];
			}
			else
			{
				imgProduct = [UIImage imageNamed:@"noImage_S_New.png"];
			}
			
			
			
			UIView *imgPlaceHolder=[[UIView alloc]init];
			imgPlaceHolder.frame  = CGRectMake(4,11, 90, 90);
			imgPlaceHolder.backgroundColor = [UIColor whiteColor];
			[[imgPlaceHolder layer] setCornerRadius:6.0];
			[[imgPlaceHolder layer] setBorderWidth:2.0];
			imgPlaceHolder.layer.masksToBounds = YES;
			[[imgPlaceHolder layer] setBorderColor:[[UIColor clearColor] CGColor]];
			[imgPlaceHolder setTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]];
			
			[cell addSubview:imgPlaceHolder];
			
			if([tableView isEditing])
               
			{
                
                
				[[cell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setBackgroundColor:[UIColor clearColor]];
				[[cell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setHidden:YES];
			}
			else 
			{
				[[cell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setBackgroundColor:[UIColor whiteColor]];
				[[cell viewWithTag: [[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setHidden:NO];
			}
			
			UIImageView *cellProductImage=[[UIImageView alloc]init];
			[cellProductImage setFrame:CGRectMake(0 ,0, 90, 90)];
			[cellProductImage setBackgroundColor:[UIColor clearColor]];
			[[cellProductImage layer] setCornerRadius:6.0];
			cellProductImage.layer.masksToBounds = YES;
			cellProductImage.layer.opaque = NO;
			[imgPlaceHolder addSubview:cellProductImage];
			
			int	y1= (90-imgProduct.size.height)/2;
			int x1 = (90 - imgProduct.size.width)/2;
			
			
			if(![imgProduct isEqual:[NSNull null]])
			{
				[cellProductImage setFrame:CGRectMake(x1, y1, imgProduct.size.width, imgProduct.size.height)];
				cellProductImage.image=imgProduct;
				
			}
			[imgPlaceHolder release];
			
			
		}
		
		else
		{
            
            if (!([[[arrDatabaseCart objectAtIndex:indexPath.row] valueForKey:@"pOptionId"] intValue]==0))
			{
				
				NSMutableArray *dictOption = [[arrShoppingCart objectAtIndex:indexPath.row] objectForKey:@"productOptions"];
				
				NSMutableArray *arrProductOptionSize = [[[NSMutableArray alloc] init] autorelease];
				
				for (int i=0; i<[dictOption count]; i++)
                {
                    [arrProductOptionSize addObject:[[dictOption objectAtIndex:i] valueForKey:@"id"]];
                    
                    
                    
                }
				
				NSArray *arrSelectedOptions=[[[arrDatabaseCart objectAtIndex:indexPath.row] valueForKey:@"pOptionId"] componentsSeparatedByString:@","];
				int optionSizesIndex[100];
				if([arrProductOptionSize count]!=0 && [arrSelectedOptions count]!=0)
				{
					for(int count=0;count<[arrSelectedOptions count];count++)
					{
						if ([arrProductOptionSize containsObject: [NSNumber numberWithInt:[[arrSelectedOptions objectAtIndex:count] integerValue]]])
						{
							optionSizesIndex[count] = [arrProductOptionSize indexOfObject:[NSNumber numberWithInt:[[arrSelectedOptions objectAtIndex:count]  intValue]]];
						}
					}
				}
				
				
				
				for(int count=0;count<[arrSelectedOptions count];count++)
				{
                    
					
                    float pOPrice=0;
               
                    pOPrice =pOPrice+[[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"pPrice"]floatValue];
               
                    productCost+=pOPrice;
                    productSubTotal = productCost * [[[arrDatabaseCart objectAtIndex:indexPath.row]valueForKey:@"quantity"] intValue];
                    productCost=[GlobalPrefrences getRoundedOffValue:productCost];
                    
                    
                    productSubTotal=[GlobalPrefrences getRoundedOffValue:productSubTotal];
                    
                }

            
            
            }
            
            
            
			if([tableView isEditing])
			{
				[[cell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setBackgroundColor:[UIColor clearColor]];
				[[cell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setHidden:YES];
			}
			else 
			{
				[[cell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setBackgroundColor:[UIColor whiteColor]];
				[[cell viewWithTag: [[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setHidden:NO];
				
				UIImage *imgProduct;
				NSDictionary *dictTemp=[arrShoppingCart objectAtIndex:indexPath.row];
				NSArray  *arrImagesUrls = [dictTemp objectForKey:@"productImages"];
				
				
				if ([arrImagesUrls count]!=0)
				{
					NSData *data = [ServerAPI fetchBannerImage:[[arrImagesUrls objectAtIndex:0] valueForKey:@"productImageSmallIpad"]];
					imgProduct = [UIImage imageWithData:data];
				}
				else
				{
					imgProduct = [UIImage imageNamed:@"noImage_S_New.png"];
                    
                }
				
				UIImageView *cellProductImage=[[UIImageView alloc]init];
				[cellProductImage setFrame:CGRectMake(0 ,0, 90, 90)];
				[cellProductImage setBackgroundColor:[UIColor clearColor]];
				[[cellProductImage layer] setCornerRadius:6.0];
				cellProductImage.layer.masksToBounds = YES;
				cellProductImage.layer.opaque = NO;
				[[cell viewWithTag: [[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]] addSubview:cellProductImage];
				
				int	y1= (90-imgProduct.size.height)/2;
				int x1 = (90 - imgProduct.size.width)/2;
				
				
				if(![imgProduct isEqual:[NSNull null]])
				{
					[cellProductImage setFrame:CGRectMake(x1, y1, imgProduct.size.width, imgProduct.size.height)];
					cellProductImage.image=imgProduct;
					
				}
			}
			
			
			
			UILabel *lblProductTotalPrice = (UILabel *)[cell viewWithTag:[[NSString stringWithFormat:@"1000%d",indexPath.row]intValue]];
    		lblProductTotalPrice.text = [NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, productSubTotal];
		}
		
		UIButton *btnQuantity_Temp = (UIButton *)[cell viewWithTag:[[NSString stringWithFormat:@"%d0%d",indexPath.row+1, indexPath.row+1] intValue]];
		
		([tableView isEditing])?(btnQuantity_Temp.hidden = FALSE):(btnQuantity_Temp.hidden = TRUE);
		
		NSString *srtTaxType;
		srtTaxType=[[arrShoppingCart objectAtIndex:indexPath.row] valueForKey:@"sTaxType"];
		
		
		if([[[arrShoppingCart objectAtIndex:indexPath.row]valueForKey:@"bTaxable"]intValue]==1)
		{
			if([srtTaxType isEqualToString:@"default"])
				srtTaxType=@"";
			else 
				srtTaxType=[NSString stringWithFormat:@"(Inc %@)",srtTaxType];
		}
		else
			srtTaxType=@"";
		
		
		 
		if([[[arrShoppingCart objectAtIndex:indexPath.row]valueForKey:@"bTaxable"]intValue]==1)
           
			[cell setProductName:[[arrShoppingCart objectAtIndex:indexPath.row] valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%0.2f %@", _savedPreferences.strCurrencySymbol, productCost, srtTaxType]:nil:@""];
		else
			[cell setProductName:[[arrShoppingCart objectAtIndex:indexPath.row] valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%0.2f ", _savedPreferences.strCurrencySymbol, productCost] :nil:@""];
		
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
	}
	
	
	return  cell;
}
-(void)viewWillDisappear:(BOOL)animated
{
	isShoppingCart_TableStyle = NO;
}
#pragma mark -
- (void) tableView:(UITableView*)tableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	
	if(tableview==tblCountries)
	{
		NSDictionary *dictTemp = [interDict objectAtIndex:indexPath.row];
		countryID=[[dictTemp valueForKey:@"territoryId"]intValue];
		NSDictionary *contentDict = [dictSettingsDetails objectForKey:@"store"];
		NSArray* arrTemp = [contentDict objectForKey:@"taxList"];
		
		[arrStates removeAllObjects];
		for(int index=0;index<[arrTemp count];index++)
		{
			if(countryID==[[[arrTemp valueForKey:@"territoryId"]objectAtIndex:index]intValue])
			{
				[arrStates  addObject:[arrTemp objectAtIndex:index]];
			}
		}
		for(int index=0;index<[arrTempShippingCountries count];index++)
		{
			if(countryID==[[[arrTempShippingCountries valueForKey:@"territoryId"]objectAtIndex:index]intValue])
			{
				if(![[arrStates valueForKey:@"sState"]containsObject:[[arrTempShippingCountries valueForKey:@"sState"]objectAtIndex:index]] ) 
					[arrStates  addObject:[arrTempShippingCountries objectAtIndex:index]];
			}
		}
		
		
	
		int stateID=0;
		isLoadingTableFooter2ndTime=NO;
		[GlobalPrefrences setUserCountryAndStateForTax_country:[dictTemp valueForKey:@"sCountry"] countryID:countryID];
		[tblCountries setHidden:YES];
		[lblCountryName setText:[dictTemp valueForKey:@"sCountry"]];
		[lblStateName setText:[[arrStates valueForKey:@"sState"]objectAtIndex:0]];
		stateID=[[[arrStates valueForKey:@"stateId"]objectAtIndex:0]intValue];
		if(dictTaxAndShippingDetails)
		{
			
			[dictTaxAndShippingDetails release];
			dictTaxAndShippingDetails=nil;
		}
		dictTaxAndShippingDetails = [ServerAPI fetchTaxShippingDetails:countryID:stateID:iCurrentStoreId];
		[tblStates reloadData];
		[tableView reloadData];
		[self viewForFooter];
	}
	else if(tableview==tblStates)
	{
		int stateID=0;
		isLoadingTableFooter2ndTime=NO;
		stateID=[[[arrStates valueForKey:@"stateId"]objectAtIndex:indexPath.row]intValue];
		if(dictTaxAndShippingDetails)
		{
			
			[dictTaxAndShippingDetails release];
			dictTaxAndShippingDetails=nil;
		}
		dictTaxAndShippingDetails=[ServerAPI fetchTaxShippingDetails:countryID :stateID:iCurrentStoreId];
		[tblStates setHidden:YES];
		[lblStateName setText:[[arrStates valueForKey:@"sState"]objectAtIndex:indexPath.row]];
		[tableView reloadData];
		[self viewForFooter];
	}	
}


- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}
- (BOOL)tableView:(UITableView *)tableView1 canEditRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *tblViewCell=(UITableViewCell *)[tableView1 cellForRowAtIndexPath:indexPath];
	if([tableView isEditing])
	{
		[[tblViewCell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setBackgroundColor:[UIColor clearColor]];
		[[tblViewCell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setHidden:YES];
	}
	else 
	{
		[[tblViewCell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setBackgroundColor:[UIColor whiteColor]];
		[[tblViewCell viewWithTag: [[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setHidden:NO];
	}	
	
	
	return [tableView isEditing];
}


- (void)willTransitionToState:(UITableViewCellStateMask)state
{
	
}

static int kAnimationType;
- (void)tableView:(UITableView *)_tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	//For changing th animation style for every odd.even row
	(kAnimationType == 6)?kAnimationType = 0:0;
	kAnimationType += 1; 
	
	if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
		
		[[SqlQuery shared] deleteItemFromShoppingCart:[[[arrDatabaseCart objectAtIndex:indexPath.row] valueForKey:@"id"]integerValue] :[[arrDatabaseCart objectAtIndex:indexPath.row] valueForKey:@"pOptionId"]];	
		[arrShoppingCart removeObjectAtIndex:indexPath.row];
		[arrDatabaseCart removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:kAnimationType];
		[GlobalPrefrences setCurrentItemsInCart:NO];  ///USING "NO" TO REDUCE ONE ELEMENT FROM THE SHOPPING CART's COUNTER
		
		if([arrDatabaseCart count]>0)
		{
			[tableView reloadData];
			
		}
		else
        {
            UIButton *btnEdit = (UIButton *)[contentView viewWithTag:3333];
            [btnEdit setHidden:YES];
           [tableView setHidden:YES];
        }	
            
           
            [self viewForFooter];
        
        
		if ([[GlobalPrefrences getUserDefault_Preferences:@"userEmail"] length] !=0)
		{
			
			[self checkoutMethod];
		}
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.remove.item"];
}


#pragma mark Footer
-(void)viewForFooter
{  
 
	float subTotal=0,grandTotal;
	float  mainTotal=0;
	float totalTaxApplied=0;
	float shippingCharges=0,fShippingtax=0;
	float tax=[[[dictTaxAndShippingDetails valueForKey:@"tax"]valueForKey:@"fTax"]floatValue];
	
	if([arrDatabaseCart count] == 0)
	{
		viewFooter = (UIView *)[contentView viewWithTag:8888];
		viewFooter.hidden = YES;
		
	}
	else {
		viewFooter = (UIView *)[contentView viewWithTag:8888];
		viewFooter.hidden = NO;
		for (int index=0; index<[arrDatabaseCart count]; index++) {
			
			float productCost;
			
			if([arrShoppingCart count]>0)
			{
				
				NSMutableArray *arrCalculatedTaxDetails=	[[TaxCalculation shared]calculateTaxForItemsInShoppingCart:arrShoppingCart arrDatabaseCart:arrDatabaseCart tax:tax forIndex:index];
				productCost=[[arrCalculatedTaxDetails objectAtIndex:0]floatValue];
				subTotal=[[arrCalculatedTaxDetails objectAtIndex:1]floatValue ];
				totalTaxApplied+=[[arrCalculatedTaxDetails objectAtIndex:2]floatValue];
				
				mainTotal += subTotal;
				grandTotal = mainTotal;
			}
			
			isLoadingTableFooter2ndTime = TRUE; //Stopping the viewForFooterInSection delegate call again, when table reload
			shippingCharges= [[TaxCalculation shared]calculateShippingChargesForProduct:dictTaxAndShippingDetails selectedQuantity:selectedQuantity totalProductsInCart:arrShoppingCart];
			
			
			
			totalTaxApplied = [GlobalPrefrences getRoundedOffValue:totalTaxApplied];
			
			if ([[[dictSettingsDetails valueForKey:@"store"]valueForKey:@"bIncludeTax"]intValue]==0)
				totalTaxApplied=0;
			if ([[[dictSettingsDetails valueForKey:@"store"]valueForKey:@"bTaxShipping"]intValue]==0)
				fShippingtax=0;
			else 
				fShippingtax=(shippingCharges*tax)/100;
			
			
			grandTotal=grandTotal+totalTaxApplied+shippingCharges+fShippingtax;
			
			
			
			
			[lblShippingCharges setText:[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, shippingCharges]];
			[lblShippingTax setText:[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, fShippingtax]];
			[lblSubTotalFooter setText:[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, mainTotal]];
			[lblTax setText:[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, totalTaxApplied]];
			[lblGrandTotalFooter setText:[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, grandTotal]];
		}		
		
	}
	
	
}
-(void)btnQuantity_Clicked:(id)sender
{
	
	iTagOfCurrentQuantityBtn=[sender tag];
	
	iTagOfCurrentQuantityLabel = [[NSString stringWithFormat:@"99%d",[sender tag]] intValue];
	
	NSString *strSelectedIndex=[NSString stringWithFormat:@"%d",iTagOfCurrentQuantityBtn];
	
	NSArray *temp = [strSelectedIndex componentsSeparatedByString:@"0"];
	
	
	[arrQuantity removeAllObjects];
	
	int max=100;
	
	if ([arrDatabaseCart count]>0)
	{
		int selectedRow = [[temp objectAtIndex:0] intValue] - 1;
		
		if ([[[arrDatabaseCart objectAtIndex:selectedRow] valueForKey:@"pOptionId"] intValue]==0)
		{
			max=[[[arrShoppingCart objectAtIndex:selectedRow] objectForKey:@"iAggregateQuantity"] intValue];
			if (max==-1)
            {
				max=100; 
            }
		}
		else
		{
			
			NSMutableArray *dictOption = [[arrShoppingCart objectAtIndex:selectedRow] objectForKey:@"productOptions"];
			
			NSMutableArray *arrProductOptionId = [[[NSMutableArray alloc] init] autorelease];
			
			for (int i=0; i<[dictOption count]; i++)
            {
                
				[arrProductOptionId addObject:[[dictOption objectAtIndex:i] valueForKey:@"id"]];
				
            }
			
			NSArray *arrOptions=[[[arrDatabaseCart objectAtIndex:selectedRow] valueForKey:@"pOptionId"] componentsSeparatedByString:@","];
			
			int optionIndexes[100];
			for(int count=0;count<[arrOptions count];count++)
			{
				
				if ([arrProductOptionId containsObject: [NSNumber numberWithInt:[[arrOptions objectAtIndex:count] intValue]]])
				{
					optionIndexes[count] = [arrProductOptionId indexOfObject:[NSNumber numberWithInt:[[arrOptions objectAtIndex:count]intValue]]];
				}
			}							  
			
			NSMutableArray * arrSameProductOptions=[[NSMutableArray alloc]init];
			if([arrDatabaseCart count]>0)
			{
				
				for(int count=0;count<[arrDatabaseCart count];count++)
				{
					if(count!=selectedRow)
					{
						
						if([[[arrDatabaseCart objectAtIndex:count] valueForKey:@"id"]intValue]==[[[arrDatabaseCart objectAtIndex:selectedRow] valueForKey:@"id"]intValue])
						{
							[arrSameProductOptions addObject:[arrDatabaseCart objectAtIndex:count]];	
							
						}	
					}	
					
				}
			}
			
			int quantityAdded[100];
			int minQuantityCheck[100];
			
			for(int i=0;i<=[arrOptions count] ;i++)
			{
				quantityAdded[i]=0;	
				minQuantityCheck[i]=100;	
				
			}	
			
			for(int i=0;i<[arrOptions count];i++)
			{
				for(int j=0;j<[arrSameProductOptions count];j++)     	
				{
				 	
					NSArray *arrayOptions=[[[arrSameProductOptions objectAtIndex:j]valueForKey:@"pOptionId"] componentsSeparatedByString:@","];
					
					for(int k=0;k<[arrayOptions count];k++)
					{
						
						if([[arrOptions objectAtIndex:i] intValue]==[[arrayOptions objectAtIndex:k]intValue])
						{
							
							quantityAdded[i]=quantityAdded[i]+[[[arrSameProductOptions objectAtIndex:j]objectForKey:@"quantity"]intValue];
							NSLog(@"%d",quantityAdded[i]);
						}	
					}
					
				}	
			}
			if(arrSameProductOptions)
				[arrSameProductOptions release];
			
			for(int count=0;count<[arrOptions count];count++)
			{
				minQuantityCheck[count]=[[[dictOption objectAtIndex:optionIndexes[count]]objectForKey:@"iAvailableQuantity"]intValue];
				if((quantityAdded[count]<100&&quantityAdded[count]>0))
				{
					
					minQuantityCheck[count]=[[[dictOption objectAtIndex:optionIndexes[count]]objectForKey:@"iAvailableQuantity"]intValue]-quantityAdded[count];
					
					
				}
				NSLog(@"%d", minQuantityCheck[count]);
				
			}
			
			
			if ([arrOptions count]>0) 
			{
				if(minQuantityCheck[0]<100&&minQuantityCheck[0]>0)
					max=minQuantityCheck[0];	
			}
			for(int i=1;i<[arrOptions count];i++)
			{
				if(max>minQuantityCheck[i])
					max=minQuantityCheck[i];
				
			}	
			
			if(max<[[[arrDatabaseCart objectAtIndex:selectedRow]objectForKey:@"quantity"]intValue])
			{
			  	max=[[[arrDatabaseCart objectAtIndex:selectedRow]objectForKey:@"quantity"]intValue];
				
			}	
			
		}            
		for (int i=0; i<max; i++)
        {
            [arrQuantity addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
        
		if (max==0)
        {
            [arrQuantity addObject:[NSString stringWithFormat:@"%d",1]];
        }
	}
	else
	{
		int i=0;
		[arrQuantity addObject:[NSString stringWithFormat:@"%d",i+1]];
	}	
	pickerViewQuantity = [[UIPickerView alloc]initWithFrame:CGRectMake( 50, 490, 400, 200.0)];
	[pickerViewQuantity setDelegate:self];
	[pickerViewQuantity setDataSource:self];
	[pickerViewQuantity setShowsSelectionIndicator:YES];
	[contentView addSubview:pickerViewQuantity];
	[contentView bringSubviewToFront:pickerViewQuantity];
	
	
	
	UIButton *btnTemp = (UIButton *) [tableView viewWithTag:iTagOfCurrentQuantityBtn];
	UILabel *lblTemp = (UILabel *)[tableView viewWithTag:iTagOfCurrentQuantityLabel];
   	
	if([btnTemp isKindOfClass:[UIButton class]])
	{
		if([arrQuantity count]>0)
			[btnTemp setTitle:[arrQuantity objectAtIndex:0] forState:UIControlStateNormal];
		else
			[btnTemp setTitle:@"0" forState:UIControlStateNormal];
		
	}
	
	if([lblTemp isKindOfClass:[UILabel class]])
	{
		if([arrQuantity count]>0)
			lblTemp.text =[arrQuantity objectAtIndex:0];
		else
			[lblTemp setText:@"0"];
	}
	
	
	
	UIToolbar *toolbarForPicker = [[UIToolbar alloc] initWithFrame:CGRectMake(50, 460, 400, 44)];
	toolbarForPicker.barStyle = UIBarStyleBlackOpaque;
	
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	[barItems addObject:flexSpace];
	[flexSpace release];
	
	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonForActionSheet:)];
	[barItems addObject:doneBtn];
	[doneBtn release];
	
	[toolbarForPicker setItems:barItems animated:YES];
	[toolbarForPicker setTag:5656];
	[contentView addSubview:toolbarForPicker];
	[barItems release];
}



-(void)doneButtonForActionSheet:(id)sender
{
	UIToolbar *pickerBar = (UIToolbar *)[contentView viewWithTag:5656];
	[pickerBar removeFromSuperview];
	[pickerViewQuantity removeFromSuperview];
	[pickerViewQuantity release];
	pickerViewQuantity = nil;
	
	UIButton *btnTemp = (UIButton *) [tableView viewWithTag:iTagOfCurrentQuantityBtn];	
	[[SqlQuery shared] updateTblShoppingCart:[btnTemp.titleLabel.text intValue] :[[[arrDatabaseCart objectAtIndex:(iTagOfCurrentQuantityBtn%10)-1] valueForKey:@"id"] intValue] :[[arrDatabaseCart objectAtIndex:(iTagOfCurrentQuantityBtn%10)-1] valueForKey:@"pOptionId"] ];
	
	arrDatabaseCart = [[SqlQuery shared]getShoppingCartProductIDs:NO];
	UILabel *lblTemp = (UILabel *)[tableView viewWithTag:iTagOfCurrentQuantityLabel];
	lblTemp.text = btnTemp.titleLabel.text;
	[tableView reloadData];
	[self viewForFooter];	
}


#pragma mark Footer

-(void)purchaseDone
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark Picker View Delegates method

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView 
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component 
{
	return [arrQuantity count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
	return [arrQuantity objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	UIButton *btnTemp = (UIButton *) [tableView viewWithTag:iTagOfCurrentQuantityBtn];
	UILabel *lblTemp = (UILabel *)[tableView viewWithTag:iTagOfCurrentQuantityLabel];
    selectedQuantity=[[arrQuantity objectAtIndex:row]intValue];
	isLoadingTableFooter2ndTime=NO;
	
	
	if([btnTemp isKindOfClass:[UIButton class]])
	{
		if([arrQuantity count]>=row)
			[btnTemp setTitle:[arrQuantity objectAtIndex:row] forState:UIControlStateNormal];
		else
			[btnTemp setTitle:@"0" forState:UIControlStateNormal];
		
	}
	
	if([lblTemp isKindOfClass:[UILabel class]])
	{
		if([arrQuantity count]>=row)
			lblTemp.text =[arrQuantity objectAtIndex:row];
		else
			[lblTemp setText:@"0"];
	}
	
	
}



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
	[pickerViewQuantity release];
	
	isLoadingTableFooter=NO;
	isLoadingTableFooter2ndTime=NO;
	[[NSNotificationCenter defaultCenter] removeObserver:@"updateShoppingCart_ViewController"];
	
	if(tableView)
	{
		[tableView release];
		tableView=nil;
	}
	
	if(lblSubTotalFooter)
		[lblSubTotalFooter release];
	if(lblGrandTotalFooter)
		[lblGrandTotalFooter release];
	if(lblTax)
		[lblTax release];		
	if(lblShippingCharges)
		[lblShippingCharges release];
	if(lblShippingTax)
		[lblShippingTax release];
	
    [super dealloc];
}


@end
