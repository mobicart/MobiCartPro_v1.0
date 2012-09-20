//
//  GlobalSearchViewController.m
//  MobicartApp
//
//  Created by Mobicart on 04/10/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

/** The View Controller for Global Search on HomePage **/

#import "GlobalSearchViewController.h"
#import "Constants.h"
#import "StockCalculation.h"
#import "ProductPriceCalculation.h"

@implementation GlobalSearchViewController

@synthesize strProductToSearch;

#pragma mark View controller Delegates
- (id)initWithProductName:(NSString *)productNameToSearch 
{
    if ((self = [super init])) 
    {
        // Custom initialization
		self.strProductToSearch = productNameToSearch;
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	self.navigationItem.titleView = [GlobalPreferences createLogoImage];
	[GlobalPreferences addLoadingBar_AtBottom:self.tabBarController.view withTextToDisplay:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];

	contentView=[[UIView alloc]initWithFrame:CGRectMake( 0, 0, 320, 396)];
	contentView.backgroundColor=navBarColor;
	self.view=contentView;
	
	if (!_tableView)
	{
		_tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 30, 320, 340) style:UITableViewStyleGrouped];
		_tableView.delegate=self;
		_tableView.dataSource=self;
		_tableView.showsVerticalScrollIndicator = FALSE;
		[_tableView setBackgroundColor:[UIColor clearColor]];
		[contentView addSubview:_tableView];
	}
	
	UIView *viewTopBar=[[UIView alloc]initWithFrame:CGRectMake( 0, 0, 320, 40)];
	viewTopBar.backgroundColor=[UIColor colorWithRed:242.0/100 green:242.0/100 blue:242.0/100 alpha:1];
	
    // Setting gradient effect on view
	[GlobalPreferences setShadowOnView:viewTopBar:[UIColor darkGrayColor]:YES:[UIColor whiteColor]:[UIColor lightGrayColor]];
	[contentView addSubview:viewTopBar];	
	
	UILabel *searchLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 30)];
	[searchLbl setBackgroundColor:[UIColor clearColor]];
	[searchLbl setText:[NSString stringWithFormat:@"Search result for \"%@\"",self.strProductToSearch]];
	[searchLbl setFont:[UIFont boldSystemFontOfSize:17]];
	[searchLbl setTextAlignment:UITextAlignmentLeft];
	[viewTopBar addSubview:searchLbl];
	[searchLbl release];
	[viewTopBar release];

	arrSearchedData =[[NSArray alloc] init];
	
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fetchDataFromServer:) object:self.strProductToSearch];
	
	[GlobalPreferences addToOpertaionQueue:operation];
	[operation release];

	[super viewDidLoad];
}

#pragma mark fetch Data
// Fetching Search Results From Server
- (void)fetchDataFromServer:(NSString *) strProductsToSearch
{
    NSDictionary *dictSettingsDetails=[[NSDictionary alloc]init];
	dictSettingsDetails=[[GlobalPreferences getSettingsOfUserAndOtherDetails]retain];
	NSMutableArray *arrInfoAccount=[[NSMutableArray alloc]init];
	arrInfoAccount=[[SqlQuery shared] getAccountData:[GlobalPreferences getUserDefault_Preferences:@"userEmail"]];
	
	int countryID=0,stateID=0;
	
	if ([arrInfoAccount count]>0)
	{
		stateID=[[[NSUserDefaults standardUserDefaults] valueForKey:@"stateID"]intValue];
	    countryID=[[[NSUserDefaults standardUserDefaults] valueForKey:@"countryID"]intValue];
		
	}
	else
    {
		countryID=[[[dictSettingsDetails valueForKey:@"store"]valueForKey:@"territoryId"]intValue];
		NSArray *arrtaxCountries=[[dictSettingsDetails valueForKey:@"store"]valueForKey:@"taxList"];
		for (int index=0;index<[arrtaxCountries count];index++)
		{
			if ([[[arrtaxCountries objectAtIndex:index]valueForKey:@"sState"]isEqualToString:@"Other"]&& [[[arrtaxCountries objectAtIndex:index]valueForKey:@"territoryId"]intValue]==countryID)
			{
				stateID=[[[arrtaxCountries objectAtIndex:index]valueForKey:@"id"]intValue];
			    break;
			}
		}
	}
	
	[arrInfoAccount release];
	
	arrSearchedData = [[ServerAPI fetchSearchProducts:strProductsToSearch:countryID:stateID:iCurrentAppId] objectForKey:@"products"];
	[arrSearchedData retain];
	[GlobalPreferences performSelector:@selector(dismissLoadingBar_AtBottom)];
	[self performSelectorOnMainThread:@selector(loadTableView) withObject:nil waitUntilDone:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
  	
	
}	

#pragma mark - load TableView

// View in case No Search Results Found
- (void)loadTableView
{
	if (![arrSearchedData isKindOfClass:[NSNull class]])
	{
		if ([arrSearchedData count]>0)
        {
            [_tableView reloadData];
        }
		else
		{
			[GlobalPreferences performSelector:@selector(dismissLoadingBar_AtBottom)];

			UILabel *lblNoItem=[[UILabel alloc]initWithFrame:CGRectMake(10, 45, 300, 30)];
			[lblNoItem setBackgroundColor:[UIColor clearColor]];
			[lblNoItem setText:@"No results found"];
			[lblNoItem setTextColor:[UIColor whiteColor]];
			[lblNoItem setFont:[UIFont boldSystemFontOfSize:17]];
			[lblNoItem setTextAlignment:UITextAlignmentCenter];
			[contentView addSubview:lblNoItem];
			[lblNoItem release];
		}
	}
	else 
    {
		UILabel *lblNoItem=[[UILabel alloc]initWithFrame:CGRectMake(10, 45, 300, 30)];
		[lblNoItem setBackgroundColor:[UIColor clearColor]];
		[lblNoItem setText:@"No results found"];
		[lblNoItem setTextColor:[UIColor whiteColor]];
		[lblNoItem setFont:[UIFont boldSystemFontOfSize:17]];
		[lblNoItem setTextAlignment:UITextAlignmentCenter];
		[contentView addSubview:lblNoItem];
		[lblNoItem release];
	}
}

#pragma mark TableView Delegate Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80;
}

- (NSInteger)tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
	return [arrSearchedData count];
}

- (UITableViewCell*)tableView:(UITableView*)tableview cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
	
	
	NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableIdentifier%d",indexPath.row];
	TableViewCell_Common *cell= (TableViewCell_Common *)[tableview dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	[cell retain];
	
	NSDictionary *dictTemp=[arrSearchedData objectAtIndex:indexPath.row];
	NSData *dataForProductImage;

	if (cell==nil)
	{
		cell = [[TableViewCell_Common alloc] initWithStyleFor_Store_ProductView:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
		
		UIImageView *imgBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 86)];
		[imgBg setImage:[UIImage imageNamed:@"320-86.png"]];
		
		[[cell layer] insertSublayer:imgBg.layer atIndex:0];
		
		[imgBg release];
		
		if (![[dictTemp objectForKey:@"bTaxable"] isKindOfClass:[NSNull class]])
		{
			if ([[dictTemp objectForKey:@"bTaxable"]intValue]==1)
			{
				cell.isTaxbale=YES;
			}
			else 
            {
				cell.isTaxbale=NO;
			}
		}
		
		
		
		
		NSArray  *arrImagesUrls = [dictTemp objectForKey:@"productImages"];
		if (![arrImagesUrls isEqual:[NSNull null]])
		{
			if ([arrImagesUrls count]==0)
			{
				dataForProductImage =nil; //[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noImage_S_New" ofType:@"png"]];
			}
			else 
			{
				dataForProductImage = [ServerAPI fetchBannerImage:[[arrImagesUrls objectAtIndex:0] objectForKey:@"productImageSmallIphone4"]];
			}
		}
		
		if((!dataForProductImage) || (![dataForProductImage isKindOfClass:[NSData class]]))
		{
			dataForProductImage =nil; //[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noImage_S_New" ofType:@"png"]];
		}
		
		
		
		UIColor *tempColor = [UIColor colorWithRed:248.0/256 green:248.0/256 blue:248.0/256 alpha:1];
		UIColor *tempColor1 = [UIColor colorWithRed:203.0/256 green:203.0/256 blue:203.0/256 alpha:1];
		
		// Setting gradient effect on view
		[GlobalPreferences setGradientEffectOnView:cell:tempColor:tempColor1];
		cell.textLabel.textColor=[UIColor colorWithRed:127.0/256 green:127.0/256 blue:127.0/256 alpha:1];
		
		NSString *discount = [NSString stringWithFormat:@"%@", [dictTemp objectForKey:@"fDiscountedPrice"]];
		
		NSString *tempDiscount;
		NSString *strTaxTypeLenght=@"";
		
		strTaxTypeLenght=[dictTemp objectForKey:@"sTaxType"];
		
		if ([strTaxTypeLenght isEqualToString:@"default"])
        {
            strTaxTypeLenght=[NSString stringWithFormat:@"%@ %@",_savedPreferences.strCurrencySymbol, [dictTemp objectForKey:@"fPrice"]];
        }
		else
        {
            strTaxTypeLenght=[NSString stringWithFormat:@"%@%@",_savedPreferences.strCurrencySymbol, [dictTemp objectForKey:@"fPrice"]];
        }
		
		
		if ([[dictTemp objectForKey:@"bTaxable"]intValue]==1)
        {
            tempDiscount =strTaxTypeLenght;
        }
		else
        {
            tempDiscount = [NSString stringWithFormat:@"%@%@",_savedPreferences.strCurrencySymbol, [dictTemp objectForKey:@"fPrice"]];
        }
		
		//CGSize size = [tempDiscount sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
		
        CGSize size=[[ProductPriceCalculation productActualPrice:dictTemp] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:13] constrainedToSize:CGSizeMake(100000,20) lineBreakMode:UILineBreakModeWordWrap];

		if ((![discount isEqual:[NSNull null]]) && (![discount isEqualToString:@"<null>"]) && ([discount length]!=0))
		{
			if ([[dictTemp objectForKey:@"fPrice"] floatValue]>[discount floatValue])
			{
				if ([[dictTemp objectForKey:@"fPrice"] floatValue]>[discount floatValue])
				{
					UIImageView *imgCutLine = [[UIImageView alloc]initWithFrame:CGRectMake(93, 41, size.width+4
                                                                                           ,2)];
                    [imgCutLine setBackgroundColor:_savedPreferences.labelColor];

                    //[imgCutLine setImage:[UIImage imageNamed:@"cut_line.png"]];
					[cell addSubview:imgCutLine];
					[imgCutLine release];
				}
			}
		}
	
	
		
	NSString *strStatus, *strTemp;
	
	if (dictTemp)
    {
        strTemp = [dictTemp objectForKey:@"sIPhoneStatus"];
    }
	
	if ((strTemp != nil) && (![strTemp isEqual:[NSNull null]]))
	{
		if ([[dictTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"coming"])
        {
            strStatus=@"Coming Soon    ";
        }
		else if ([[dictTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"sold"])
        {
            strStatus=@"Sold Out";
        }
		else if ([[dictTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"active"])
        {
            strStatus = @"In Stock";
        }
		else
        {
   			strStatus = [NSString stringWithFormat:@"%@",[dictTemp objectForKey:@"sIPhoneStatus"]];
        }
	}
	else
    {
        strStatus=@"Sold Out";
    }
    
	[dictTemp retain];
	NSArray *interOptionDict = [[NSArray alloc]init];
	interOptionDict = [dictTemp objectForKey:@"productOptions"];
	
	[interOptionDict retain];
	
	if ([[dictTemp valueForKey:@"bUseOptions"] intValue]==0)
	{
		NSString *strDicTemp=[dictTemp valueForKey:@"iAggregateQuantity"];
		
		if (![strDicTemp isKindOfClass:[NSNull class]])
		{
			if ([strDicTemp intValue]!=0)
			{
				strStatus=[dictTemp objectForKey:@"sIPhoneStatus"];
                
				if ([strStatus isEqualToString:@"sold"])
                {
                    strStatus=@"Sold Out";
                }
				else if ([strStatus isEqualToString:@"coming"])
                {
                    strStatus=@"Coming Soon";
                }
				else
                {
                    strStatus=[dictTemp objectForKey:@"sIPhoneStatus"];
                }
			}
			else
            {
				strStatus=@"Sold Out";
            }
		}
		
	}
	else
	{		
		
		NSArray *arrDicTemp=[dictTemp valueForKey:@"productOptions"];
		StockCalculation *objStockCalculation=[[StockCalculation alloc]init];
		BOOL isOutOfStock =[objStockCalculation checkOptionsAvailability:arrDicTemp];
		[objStockCalculation release];
		if(isOutOfStock==YES)
		{
			strStatus=@"Sold Out";
			
		}	
		else 
			
		{
			
			strStatus=[dictTemp objectForKey:@"sIPhoneStatus"];
			
			if ([strStatus isEqualToString:@"sold"])
			{
				strStatus=@"Sold Out";
			}
			else if ([strStatus isEqualToString:@"coming"])
			{
				strStatus=@"Coming Soon";
			}
			else
			{
				strStatus=[dictTemp objectForKey:@"sIPhoneStatus"];
			}
		}
		
		
		
		
			}
	if (interOptionDict)
    {
        [interOptionDict release];
    }
	
	if ([strStatus isEqualToString:@"active"])
    {
        strStatus = @"In Stock";
    }		
	
	float finalProductPrice=0;
	
	if ((dictTemp) || (![dictTemp isEqual:[NSNull null]]))
	{
		NSString *discount = [NSString stringWithFormat:@"%@", [dictTemp objectForKey:@"fDiscountedPrice"]];
		
		if ([[dictTemp objectForKey:@"bTaxable"]intValue]==1)
		{
			if ([[dictTemp objectForKey:@"fPrice"] floatValue]>[discount floatValue])
            {
                finalProductPrice=[[dictTemp objectForKey:@"fDiscountedPrice"]floatValue]+[[dictTemp objectForKey:@"fTax"]floatValue];
            }
			else 
            {
				finalProductPrice=[[dictTemp objectForKey:@"fPrice"]floatValue]+[[dictTemp objectForKey:@"fTax"]floatValue];
			}
		}
		else 
        {
			if ([[dictTemp objectForKey:@"fPrice"] floatValue]>[discount floatValue])
            {
                finalProductPrice=[[dictTemp objectForKey:@"fDiscountedPrice"]floatValue];
            }
			else 
            {
				finalProductPrice=[[dictTemp objectForKey:@"fPrice"]floatValue];
			}
		}
		
		NSString *strFinalProductPrice=@"";
		NSString *strOriginalPrice=@"";
		if ([[dictTemp objectForKey:@"bTaxable"]intValue]==1)
		{
			if (![[dictTemp objectForKey:@"sTaxType"]isEqualToString:@"default"])
			{
				strFinalProductPrice=[NSString stringWithFormat:@"%0.2f (inc %@)",finalProductPrice,[dictTemp objectForKey:@"sTaxType"]];
				
				strOriginalPrice=[NSString stringWithFormat:@" (inc %@)",[dictTemp objectForKey:@"sTaxType"]];
			}
			else 
            {
				strFinalProductPrice=[NSString stringWithFormat:@"%0.2f",finalProductPrice];
				strOriginalPrice=@"";
			}
		}
		else 
        {
			strFinalProductPrice=[NSString stringWithFormat:@"%0.2f",finalProductPrice]; 
		}
		
		if ((![discount isEqual:[NSNull null]]) && (![discount isEqualToString:@"<null>"]) && ([discount length]!=0))
		{
			if ([[dictTemp objectForKey:@"fPrice"] floatValue]>[discount floatValue])
			{
				if ([[dictTemp objectForKey:@"bTaxable"]intValue]==1)
				{
					//[cell setProductName:[dictTemp valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%0.2f %@ ", _savedPreferences.strCurrencySymbol,( [[dictTemp valueForKey:@"fPrice"] floatValue]+[[dictTemp valueForKey:@"fTaxOnFPrice"] floatValue]),strOriginalPrice]:strStatus :[NSString stringWithFormat:@"%@",strFinalProductPrice]:imgProduct];
					
					[cell setProductName:[dictTemp valueForKey:@"sName"] :[ProductPriceCalculation productActualPrice:dictTemp]:strStatus :[NSString stringWithFormat:@"%@",strFinalProductPrice]:[UIImage imageWithData:dataForProductImage]];
					
					
				}
				else 
                {
					//[cell setProductName:[dictTemp valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%0.2f ", _savedPreferences.strCurrencySymbol,( [[dictTemp valueForKey:@"fPrice"] floatValue])]:strStatus :[NSString stringWithFormat:@"%@",strFinalProductPrice]:imgProduct];
					
					[cell setProductName:[dictTemp valueForKey:@"sName"] :[ProductPriceCalculation productActualPrice:dictTemp]:strStatus :[NSString stringWithFormat:@"%@",strFinalProductPrice]:[UIImage imageWithData:dataForProductImage]];
					
					
				}
			}
			else
            {
                [cell setProductName:[dictTemp valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%@", _savedPreferences.strCurrencySymbol, strFinalProductPrice]:strStatus :@"":[UIImage imageWithData:dataForProductImage]];
            }
		}
		else
        {
            [cell setProductName:[dictTemp objectForKey:@"sName"] :[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, [[dictTemp objectForKey:@"fPrice"] floatValue]]]:strStatus: [NSString stringWithFormat:@"%@",strFinalProductPrice]:[UIImage imageWithData:dataForProductImage]];
        }
	}
	}
	
	UIImageView *imgViewCellAcccesory=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
	[cell setAccessoryView:imgViewCellAcccesory];
	[imgViewCellAcccesory release];
	
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return  cell;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/*NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableIdentifier%d", indexPath.row];
	TableViewCell_Common *cell= (TableViewCell_Common *)[tableview dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	
	NSDictionary *dictTemp=[arrSearchedData objectAtIndex:indexPath.row];
	NSData *dataForProductImage;
	
	if (cell==nil)
	{
		cell = [[TableViewCell_Common alloc] initWithStyleFor_Store_ProductView:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
		cell.contentView.backgroundColor=cellBackColor;
		cell.backgroundColor=cellBackColor;
		cell.textLabel.textColor=[UIColor colorWithRed:127.0/256 green:127.0/256 blue:127.0/256 alpha:1];
		
		UIImageView *imgBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 86)];
		[imgBg setImage:[UIImage imageNamed:@"product_list_cell_bg.png"]];
		[[cell layer] insertSublayer:imgBg.layer atIndex:0];
		[imgBg release];
		
		NSArray  *arrImagesUrls = [dictTemp objectForKey:@"productImages"];
		if (![arrImagesUrls isEqual:[NSNull null]])
		{
			if ([arrImagesUrls count]==0)
			{
				dataForProductImage =nil; //[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noImage_S_New" ofType:@"png"]];
			}
			else 
			{
				dataForProductImage = [ServerAPI fetchBannerImage:[[arrImagesUrls objectAtIndex:0] objectForKey:@"sLocationSmall"]];
			}
		}
		
		if ((!dataForProductImage) || (![dataForProductImage isKindOfClass:[NSData class]]))
		{
			dataForProductImage =nil; //[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noImage_S_New" ofType:@"png"]];
		}
		NSString *strStatus=[dictTemp objectForKey:@"sIPhoneStatus"];
		if ([strStatus isEqualToString:@"active"])
        {
            strStatus=@"In Stock";
        }
		
		NSString *discount = [NSString stringWithFormat:@"%@", [dictTemp objectForKey:@"fDiscountedPrice"]];
		
		NSString *tempDiscount;
		NSString *strTaxTypeLenght=@"";
		
		strTaxTypeLenght=[dictTemp objectForKey:@"sTaxType"];
		
		if ([strTaxTypeLenght isEqualToString:@"default"])
        {
            strTaxTypeLenght=[NSString stringWithFormat:@"%@ %@",_savedPreferences.strCurrencySymbol, [dictTemp objectForKey:@"fPrice"]];
        }
		else
        {
            strTaxTypeLenght=[NSString stringWithFormat:@"%@%@",_savedPreferences.strCurrencySymbol, [dictTemp objectForKey:@"fPrice"]];
        }
		
		
		if ([[dictTemp objectForKey:@"bTaxable"]intValue]==1)
        {
            tempDiscount =strTaxTypeLenght;
        }
		else
        {
            tempDiscount = [NSString stringWithFormat:@"%@%@",_savedPreferences.strCurrencySymbol, [dictTemp objectForKey:@"fPrice"]];
        }
		
		CGSize size = [tempDiscount sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
		
		
		if ((![discount isEqual:[NSNull null]]) && (![discount isEqualToString:@"<null>"]) && ([discount length]!=0))
		{
			if ([[dictTemp objectForKey:@"fPrice"] floatValue]>[discount floatValue])
			{
				if ([[dictTemp objectForKey:@"fPrice"] floatValue]>[discount floatValue])
				{
					UIImageView *imgCutLine = [[UIImageView alloc]initWithFrame:CGRectMake(93, 41, size.width+20,1)];
					[imgCutLine setImage:[UIImage imageNamed:@"cut_line.png"]];
					[cell addSubview:imgCutLine];
					[imgCutLine release];
				}
			}
		}
		
		
		
		
		
        
		if ((dictTemp) || (![dictTemp isEqual:[NSNull null]]))
		{
			[cell setProductName:[dictTemp objectForKey:@"sName"] :[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, [[dictTemp objectForKey:@"fPrice"] floatValue]]]:strStatus: [NSString stringWithFormat:@"%@", [dictTemp objectForKey:@"fDiscountedPrice"]]:[UIImage imageWithData:dataForProductImage]];
		}
	}
	
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	return  cell;
 */
}

- (void)tableView:(UITableView*)tableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSDictionary *dictTemp = [arrSearchedData objectAtIndex:indexPath.row];
	
	// Send data for product analytics
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(sendDataForAnalytics:) object:[dictTemp objectForKey:@"id"]];
	
	[GlobalPreferences addToOpertaionQueue:operation];
	[operation release];
	
	[GlobalPreferences setCurrentProductDetails:dictTemp];
	
	ProductDetailsViewController *objProductDetails=[[ProductDetailsViewController alloc]init];
	
	// Passing product details to ProductDetailsViewController
	objProductDetails.isWishlist = NO;
	objProductDetails.dicProduct = dictTemp;
	[self.navigationController pushViewController:objProductDetails animated:YES];
	[objProductDetails release];
}

#pragma mark - Product Analytics
- (void)sendDataForAnalytics:(NSString *)sProductId
{
	if ((![sProductId isEqual:[NSNull null]]) || (![sProductId isEqualToString:@""]))
	{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		[ServerAPI fetchProductAnalytics:sProductId];
		[pool release];
	}
}
#pragma mark -
#pragma mark Memory Mgmt
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
	[contentView release];
    [super dealloc];
}

@end