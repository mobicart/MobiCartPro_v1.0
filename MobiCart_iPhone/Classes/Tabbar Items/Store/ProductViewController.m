//
//  ProductViewController.m
//  MobiCart
//
//  Created by Mobicart on 8/4/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import "ProductViewController.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "ProductPriceCalculation.h"
#import "StockCalculation.h"

extern BOOL isNewsSection;

@implementation ProductViewController

@synthesize arrAppRecordsAllEntries,arrTempProducts;
@synthesize imageDownloadsInProgress;
@synthesize sTaxType;

- (void)viewWillAppear:(BOOL)animated
{
	// The title is set to keep checks on Search Bar of this view controller
	self.title = @"Products";
	[GlobalPreferences startLoadingIndicator];
	
	if(btnStore)
	{
		[btnStore removeFromSuperview];
		[btnStore release];
		btnStore=nil;
	}
	btnStore=[[UIButton alloc]init];
	[btnStore setBackgroundImage:[UIImage imageNamed:@"store_btn_iphone4.png"] forState:UIControlStateNormal];
	[btnStore setTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.department.store"] forState:UIControlStateNormal];
	[btnStore.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
	[btnStore addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	[btnStore setFrame:CGRectMake(35, 0, 69,36)];
	
	UIBarButtonItem *btnBack=[[UIBarButtonItem alloc] initWithCustomView:btnStore];
	[btnBack setStyle:UIBarButtonItemStyleBordered];
	
	[self.navigationItem setLeftBarButtonItem:btnBack];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateLabelStore" object:nil];
	
	isNewsSection = NO;
	
	if ([GlobalPreferences isClickedOnFeaturedProductFromHomeTab])
	{
		[self performSelector:@selector(dismissLoadingBar_AtBottom) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES];
		
		NSDictionary *dictTemp = [GlobalPreferences getCurrentFeaturedDetails];
		[NSThread detachNewThreadSelector:@selector(sendDataForAnalytics:) toTarget:self withObject:[dictTemp objectForKey:@"id"]];
		
		ProductDetailsViewController *objProductDetails=[[ProductDetailsViewController alloc]init];
		
		// Passing product details to ProductDetailsViewController
		objProductDetails.isWishlist = NO;
		objProductDetails.dicProduct = dictTemp;
		
		[self.navigationController pushViewController:objProductDetails animated:NO];
		[objProductDetails release];
	}
}

-(void)viewWillDisappear:(BOOL)animated
{
	self.title=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.home.back"];
}
- (void)back
{
	[[self navigationController]popViewControllerAnimated:YES];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	// The title is set to keep checks on Search Bar of this view controller
	self.title = @"Products";
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignSearchBar) name:@"resignSearchBarFromProducts" object:nil];
	
	if (![GlobalPreferences isInternetAvailable])
	{
		NSString* errorString = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.text"];
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.title"] message:errorString delegate:self cancelButtonTitle:nil otherButtonTitles:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"], nil];
		[errorAlert show];
		[errorAlert release];
	}
	else
	{
		[GlobalPreferences setCurrentNavigationController:self.navigationController];
		
		self.navigationItem.titleView = [GlobalPreferences createLogoImage];
		
		UIView *viewRemoveLine = [[UIView alloc] initWithFrame:CGRectMake( 0, 43, 320,1)];
		[viewRemoveLine setBackgroundColor:self.navigationController.navigationBar.tintColor];
        
		[self.navigationController.navigationBar addSubview:viewRemoveLine];
		[viewRemoveLine release];
		
		[self allocateMemoryToObjects];
		
		contentView=[[UIView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake( 0, 0, 320, 396) chageHieght:YES]];
		UIImageView *imgBg=[[UIImageView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake( 0, 0, 320, 396) chageHieght:YES]];
		[imgBg setImage:[UIImage imageNamed:@"product_details_bg.png"]];
		[contentView addSubview:imgBg];
		[imgBg release];
		
		self.view=contentView;
        
		
		[NSThread detachNewThreadSelector:@selector(fetchDataFromServer) toTarget:self withObject:nil];
		
		self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
		
		[self performSelectorOnMainThread:@selector(createTableView) withObject:nil waitUntilDone:YES];
		[self createSubViewsAndControls];
		[GlobalPreferences addLoadingBar_AtBottom:self.tabBarController.view withTextToDisplay:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
	}
}
-(void)resignSearchBar
{
	[_searchBar resignFirstResponder];
}
- (void)allocateMemoryToObjects
{
	if (!arrAllData)
    {
        arrAllData = [[NSArray alloc] init];
    }
	
	if (!dict)
    {
        dict=[[NSMutableDictionary alloc]init];
    }
	
	if (!arrSearch)
    {
        arrSearch=[[NSMutableArray alloc]init];
    }
	
}

- (void)fetchDataFromServer
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary *dictCategories=[[NSDictionary alloc]init];
	
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
	
	if (isCatogeryEmpty==YES)
	{
    	dictCategories=[ServerAPI fetchProductsWithoutCategories_departmentID:iCurrentDepartmentId countryID:countryID stateID:stateID:iCurrentStoreId];
    }
	else
	{
        dictCategories=	[ServerAPI fetchProductsWithCategoriesAndSubCategories_departmentID:iCurrentDepartmentId categoryID:iCurrentCategoryId countyID:countryID stateID:stateID:iCurrentStoreId];
	}
	
	arrAllData = [dictCategories objectForKey:@"products"];
	[arrAllData retain];
	
	
	if ([arrAllData count] >0)
	{
		arrSearch=[NSMutableArray arrayWithArray:arrAllData];
		[arrSearch retain];
		
		// Sort basic settings
		[self sortingHandlers];
		
		if (!self.arrAppRecordsAllEntries)
        {
            self.arrAppRecordsAllEntries = [[NSMutableArray alloc] init];
        }
		
		for (int i =0; i<[arrSearch count] ;i++)
		{
			AppRecord *_currentRecord = [[AppRecord alloc] init];
			NSDictionary *dictTemp=[arrSearch objectAtIndex:i];
			NSArray  *arrImagesUrls = [dictTemp objectForKey:@"productImages"];
			if ([arrImagesUrls count]!=0)
			{
                _currentRecord.requestImg=[ServerAPI createImageURLConnection:[[arrImagesUrls objectAtIndex:0] valueForKey:@"productImageSmallIphone4"]];
				
			}
			[self.arrAppRecordsAllEntries addObject:_currentRecord];
			[_currentRecord release];
		}
		[self.arrAppRecordsAllEntries retain];
		
		if (tableView)
        {
            [self performSelectorOnMainThread:@selector(createTableView) withObject:nil waitUntilDone:YES];
        }
	}
	else
		NSLog (@"No Data Available for this Department (CategoryViewContoller)");
	
	[dictSettingsDetails release];
	[pool release];
	[GlobalPreferences stopLoadingIndicator];
	[self performSelector:@selector(dismissLoadingBar_AtBottom) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES];
	
	
}
- (void)dismissLoadingBar_AtBottom{
	[GlobalPreferences performSelector:@selector(dismissLoadingBar_AtBottom)];
	
}
- (void)createSubViewsAndControls
{
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0 ,
															  320 ,44)];
	[GlobalPreferences setSearchBarDefaultSettings:_searchBar];
	[_searchBar setDelegate:self];
	[contentView addSubview:_searchBar];
    
	UIToolbar *topSortToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,44,320,40)];
    
    [topSortToolBar setTintColor:[UIColor lightGrayColor]];
	// Setting gradient effect on view
	[GlobalPreferences setShadowOnView:topSortToolBar:[UIColor darkGrayColor]:YES:[UIColor whiteColor]:[UIColor lightGrayColor]];
	topSortToolBar.tag = 10101010;
	
	[contentView addSubview:topSortToolBar];
	
	NSArray *toggleItems = [[NSArray alloc] initWithObjects:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.productlist.price"],[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.productlist.status"],[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.productlist.atoz"],nil];
	
	CustomSegmentControl *sortSegCtrl = [[CustomSegmentControl alloc] initWithItems:toggleItems offColor:[UIColor colorWithRed:81.6/100 green:81.6/100 blue:81.6/100 alpha:1.0] onColor:[UIColor colorWithRed:78.6/100 green:78.3/100 blue:78.3/100 alpha:1.0]];
	if([GlobalPreferences getCureentSystemVersion]>=6.0)
        [sortSegCtrl setTintColor:[UIColor colorWithRed:81.6/100 green:81.6/100 blue:81.6/100 alpha:1.0]];
	
    [self setTextColors:sortSegCtrl];
	
	[sortSegCtrl addTarget:self action:@selector(sortSegementChanged:) forControlEvents:UIControlEventValueChanged];
	[sortSegCtrl setFrame:CGRectMake(95,5,220, 30)];
	[topSortToolBar addSubview:sortSegCtrl];
	[sortSegCtrl release];
	
	[toggleItems release];
	
	UILabel *lblSort=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 30)];
    [lblSort setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.productlist.sortby"]];
    [lblSort setBackgroundColor:[UIColor clearColor]];
	[lblSort setTextColor:[UIColor blackColor]];
	[lblSort setFont:[UIFont boldSystemFontOfSize:13]];
	[topSortToolBar addSubview:lblSort];
	[lblSort release];
}

#pragma mark Sort handlers
//Called to Change The Text of Segment Controller when Clicked
- (void)setTextColors:(id)sender
{
	UISegmentedControl *sg = (UISegmentedControl*)sender;
	
	int eg=0;
    for (id seg in [sg subviews])
    {
        int gg=sg.selectedSegmentIndex;
        if(gg==2)
            gg=0;
        else if(gg==0)
            gg=2;
        if(eg==gg && eg!=1)
        {
            for (id label in [seg subviews])
                if ([label isKindOfClass:[UILabel class]])
                {
					[label setTextAlignment:UITextAlignmentCenter];
                    [label setFont:[UIFont fontWithName:@"Helvetica" size:12]];
                    [label setTextColor:[UIColor colorWithRed:57.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1]];
                }
        }
        else if(eg==1)
        {
            for (id label in [seg subviews])
                if ([label isKindOfClass:[UILabel class]])
                {
                    [label setTextAlignment:UITextAlignmentCenter];
                    [label setFont:[UIFont fontWithName:@"Helvetica" size:12]];
                    [label setTextColor:[UIColor colorWithRed:58.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1]];
                }
        }
        else
        {
            for (id label in [seg subviews])
                if ([label isKindOfClass:[UILabel class]])
                {
                    [label setTextAlignment:UITextAlignmentCenter];
					[label setFont:[UIFont fontWithName:@"Helvetica" size:12]];
                    [label setTextColor:[UIColor colorWithRed:58.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1]];
                }
        }
        eg++;
    }
	
}

- (void)sortingHandlers
{
	NSString *sortByName = @"sName";
	NSString *sortByPrice = @"fPrice";
	NSString *sortByStatus = @"sIPhoneStatus";
	
	nameDescriptor = [[NSSortDescriptor alloc] initWithKey:sortByName
												 ascending:YES
												  selector:@selector(caseInsensitiveCompare:)];
	priceDescriptor =[[NSSortDescriptor alloc] initWithKey:sortByPrice
												 ascending:YES
												  selector:@selector(compare:)] ;
	
	statusDescriptor = [[NSSortDescriptor alloc] initWithKey:sortByStatus
												   ascending:YES
													selector:@selector(caseInsensitiveCompare:)] ;
	
	NSArray *descriptors = [NSArray arrayWithObjects:priceDescriptor,nameDescriptor,statusDescriptor,nil];
	arrAllData = [arrAllData sortedArrayUsingDescriptors:descriptors];
	[arrAllData retain];
	if ([arrAllData count]>0)
	{
		arrSearch=[NSMutableArray arrayWithArray:arrAllData];
		[arrSearch retain];
	}
	
}
- (void)sortSegementChanged:(id)sender
{
	@try
	{
		[self setTextColors:sender];
		UISegmentedControl *segTemp = sender;
		switch (segTemp.selectedSegmentIndex)
		{
			case 0:
			{
				NSArray *descriptors = [NSArray arrayWithObjects:priceDescriptor, nameDescriptor,statusDescriptor,nil];
				arrAllData = [arrAllData sortedArrayUsingDescriptors:descriptors];
				arrSearch=[NSMutableArray arrayWithArray:arrAllData];
				break;
			}
			case 1:
			{
				NSArray *descriptors = [NSArray arrayWithObjects:statusDescriptor,priceDescriptor, nameDescriptor,nil];
			    arrAllData = [arrAllData sortedArrayUsingDescriptors:descriptors];
				arrSearch=[NSMutableArray arrayWithArray:arrAllData];
				break;
			}
			case 2:
			{
				NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor,priceDescriptor,statusDescriptor,nil];
				arrAllData = [arrAllData sortedArrayUsingDescriptors:descriptors];
				arrSearch=[NSMutableArray arrayWithArray:arrAllData];
				
			}
			default:
				break;
		}
		
	}
	
	@catch (NSException * e)
    {
		NSLog(@"Error While Sorting (ProductViewController)");
	}
	@finally
	{
		[arrAllData retain];
		[arrSearch retain];
		
		[tableView removeFromSuperview];
		
		[self.arrAppRecordsAllEntries removeAllObjects];
		
		for (int i =0; i<[arrSearch count] ;i++)
		{
			AppRecord *_currentRecord = [[AppRecord alloc] init];
			NSDictionary *dictTemp=[arrSearch objectAtIndex:i];
			NSArray  *arrImagesUrls = [dictTemp objectForKey:@"productImages"];
			
			if ([arrImagesUrls count]!=0)
            {
                _currentRecord.requestImg=[ServerAPI createImageURLConnection:[[arrImagesUrls objectAtIndex:0] valueForKey:@"productImageSmallIphone4"]];
				
            }
            
			[self.arrAppRecordsAllEntries addObject:_currentRecord];
			[_currentRecord release];
		}
		
		[self performSelectorOnMainThread:@selector(createTableView) withObject:nil waitUntilDone:YES];
	}
}

#pragma mark -
- (void)createTableView
{
	if (tableView)
	{
		[tableView removeFromSuperview];
		[tableView release];
		tableView=nil;
	}
	
	tableView=[[UITableView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake(0, 70,320, 295) chageHieght:YES] style:UITableViewStyleGrouped];
	tableView.delegate=self;
	tableView.dataSource=self;
    tableView.backgroundView=nil;
    tableView.backgroundColor=[UIColor clearColor];
	tableView.showsVerticalScrollIndicator = FALSE;
	
    [contentView addSubview:tableView];
	
	[self.imageDownloadsInProgress removeAllObjects];
	
	UIToolbar *topSortToolBar =  (UIToolbar *)[contentView viewWithTag:10101010];
	[contentView bringSubviewToFront:topSortToolBar];
}
#pragma mark Search Bar Delegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
	return YES;
}

// Called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
	[arrSearch removeAllObjects];
	[arrSearch addObjectsFromArray:arrAllData];
	for (int i =0; i<[arrSearch count] ;i++)
	{
		AppRecord *_currentRecord = [[AppRecord alloc] init];
		NSDictionary *dictTemp=[arrSearch objectAtIndex:i];
		NSArray  *arrImagesUrls = [dictTemp objectForKey:@"productImages"];
		
		if ([arrImagesUrls count]!=0)
        {
            _currentRecord.requestImg=[ServerAPI createImageURLConnection:[[arrImagesUrls objectAtIndex:0] valueForKey:@"productImageSmallIphone4"]];
			
        }
        
		[self.arrAppRecordsAllEntries addObject:_currentRecord];
		[_currentRecord release];
	}
	
	@try
	{
		[self performSelectorOnMainThread:@selector(createTableView) withObject:nil waitUntilDone:YES];
	}
	@catch(NSException *e)
	{
		
	}
	searchBar.showsCancelButton = NO;
	[searchBar resignFirstResponder];
	searchBar.text = @"";
	
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// Only show the status bar’s cancel button while in edit mode
	searchBar.showsCancelButton = YES;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	
	// Flush the previous search content
	
	
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	searchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[arrSearch removeAllObjects];
	
	if ([searchText isEqualToString:@""] || searchText==nil)
	{
		[arrSearch addObjectsFromArray:arrAllData];
		
		[self.arrAppRecordsAllEntries removeAllObjects];
		
		for (int i =0; i<[arrSearch count] ;i++)
		{
			AppRecord *_currentRecord = [[AppRecord alloc] init];
			NSDictionary *dictTemp=[arrSearch objectAtIndex:i];
			NSArray  *arrImagesUrls = [dictTemp objectForKey:@"productImages"];
			
			if ([arrImagesUrls count]!=0)
            {
                _currentRecord.requestImg=[ServerAPI createImageURLConnection:[[arrImagesUrls objectAtIndex:0] valueForKey:@"productImageSmallIphone4"]];
				
            }
            
			[self.arrAppRecordsAllEntries addObject:_currentRecord];
			[_currentRecord release];
		}
		
		[self performSelectorOnMainThread:@selector(createTableView) withObject:nil waitUntilDone:YES];
		return;
	}
	else
	{
		NSInteger counter = 0;
		for (NSDictionary *dictName in arrAllData)
		{
			NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
			NSRange r = [[[dictName objectForKey:@"sName"] uppercaseString] rangeOfString:[searchText uppercaseString]] ;
			if (r.location != NSNotFound)
			{
				if (r.location==0)
				{
					[arrSearch addObject:dictName];
				}
			}
			counter++;
			[pool release];
		}
		
		[self.arrAppRecordsAllEntries removeAllObjects];
		
		for (int i =0; i<[arrSearch count] ;i++)
		{
			AppRecord *_currentRecord = [[AppRecord alloc] init];
			NSDictionary *dictTemp=[arrSearch objectAtIndex:i];
			NSArray  *arrImagesUrls = [dictTemp objectForKey:@"productImages"];
			
			if ([arrImagesUrls count]!=0)
            {
                _currentRecord.requestImg=[ServerAPI createImageURLConnection:[[arrImagesUrls objectAtIndex:0] valueForKey:@"productImageSmallIphone4"]];
				
            }
            
			[self.arrAppRecordsAllEntries addObject:_currentRecord];
			[_currentRecord release];
		}
		
		[self performSelectorOnMainThread:@selector(createTableView) withObject:nil waitUntilDone:YES];
	}
}


#pragma mark -

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch=[touches anyObject];
	
	if ([touch tapCount]==1)
		[_searchBar resignFirstResponder];
}

#pragma mark TableView Delegate Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 86;
}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
	return [arrSearch count];
}

- (UITableViewCell*) tableView:(UITableView*)tableview cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
	NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableIdentifier%d", indexPath.row];
	TableViewCell_Common *cell= (TableViewCell_Common *)[tableview dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	
	NSDictionary *dictTemp=[arrSearch objectAtIndex:indexPath.row];
	
	int nodeCount = [arrSearch count];
	
	if (cell==nil)
	{
		cell = [[TableViewCell_Common alloc] initWithStyleFor_Store_ProductView:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
		
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
		
		
		UIImageView *imgBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 86)];
		[imgBg setImage:[UIImage imageNamed:@"320-86.png"]];
		
		[[cell layer] insertSublayer:imgBg.layer atIndex:0];
		
		[imgBg release];
		
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
		
		CGSize size=[[ProductPriceCalculation productActualPrice:dictTemp] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:13] constrainedToSize:CGSizeMake(100000,20) lineBreakMode:UILineBreakModeWordWrap];
        
		
		if ((![discount isEqual:[NSNull null]]) && (![discount isEqualToString:@"<null>"]) && ([discount length]!=0))
		{
			if ([[dictTemp objectForKey:@"fPrice"] floatValue]>[discount floatValue])
			{
				if ([[dictTemp objectForKey:@"fPrice"] floatValue]>[discount floatValue])
				{
                    
					UIImageView *imgCutLine = [[UIImageView alloc]initWithFrame:CGRectMake(93, 41, size.width+4,2)];
					[imgCutLine setBackgroundColor:_savedPreferences.labelColor];
                    [cell addSubview:imgCutLine];
					[imgCutLine release];
				}
			}
		}
	}
	
	UIImage *imgProduct;
	if (nodeCount > 0)
	{
        AppRecord *appRecord = [self.arrAppRecordsAllEntries objectAtIndex:indexPath.row];
		
        // Only load cached images; defer new downloads until scrolling ends
        if (!appRecord.appIcon)
        {
            if (tableView.dragging == NO && tableView.decelerating == NO)
            {
				[self performSelector:@selector(startIconDownload:forIndexPath:) withObject:appRecord withObject:indexPath];
				
				UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(35, 35, 15, 15)];
				[loadingIndicator startAnimating];
				[loadingIndicator setHidden:NO];
				[loadingIndicator setTag:[[NSString stringWithFormat:@"222%d",indexPath.row] intValue]];
				[cell addSubview:loadingIndicator];
				[loadingIndicator release];
            }
			
 			imgProduct = [UIImage imageNamed:@""];
        }
        else
        {
			for (UIActivityIndicatorView *actInd in [cell subviews])
			{
				if ([actInd isKindOfClass:[UIActivityIndicatorView class]])
                {
                    [actInd removeFromSuperview];
                }
			}
			imgProduct = appRecord.appIcon;
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
            strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.comming.soon"];
        }
		else if ([[dictTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"sold"])
        {
            strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
        }
		else if ([[dictTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"active"])
        {
            strStatus = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"];
        }
		else
        {
   			strStatus = [NSString stringWithFormat:@"%@",[dictTemp objectForKey:@"sIPhoneStatus"]];
        }
	}
	else
    {
        strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
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
					strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
                }
				else if ([strStatus isEqualToString:@"coming"])
                {
					strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.comming.soon"];
                }
				else
                {
                    strStatus=[dictTemp objectForKey:@"sIPhoneStatus"];
                }
			}
			else
            {
				strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
            }
		}
		
	}
	
	if (interOptionDict)
    {
        [interOptionDict release];
    }
	
	if ([strStatus isEqualToString:@"active"])
    {
        strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"];
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
                    
					[cell setProductName:[dictTemp valueForKey:@"sName"] :[ProductPriceCalculation productActualPrice:dictTemp]:strStatus :[NSString stringWithFormat:@"%@",strFinalProductPrice]:imgProduct];
					
					
				}
				else
                {
                    
					[cell setProductName:[dictTemp valueForKey:@"sName"] :[ProductPriceCalculation productActualPrice:dictTemp]:strStatus :[NSString stringWithFormat:@"%@",strFinalProductPrice]:imgProduct];
					
					
				}
			}
			else
            {
                [cell setProductName:[dictTemp valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%@", _savedPreferences.strCurrencySymbol, strFinalProductPrice]:strStatus :@"":imgProduct];
            }
		}
		else
        {
            [cell setProductName:[dictTemp objectForKey:@"sName"] :[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, [[dictTemp objectForKey:@"fPrice"] floatValue]]]:strStatus: [NSString stringWithFormat:@"%@",strFinalProductPrice]:imgProduct];
        }
	}
	[self markStarRating:cell :indexPath.row];
	UIImageView *imgViewCellAcccesory=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
	[cell setAccessoryView:imgViewCellAcccesory];
	[imgViewCellAcccesory release];
	
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return  cell;
}

- (void)tableView:(UITableView*)tableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSDictionary *dictTemp = [arrSearch objectAtIndex:indexPath.row];
	
	// Send data for product analytics
	[NSThread detachNewThreadSelector:@selector(sendDataForAnalytics:) toTarget:self withObject:[dictTemp objectForKey:@"id"]];
	
	[GlobalPreferences setCurrentProductDetails:dictTemp];
	
	ProductDetailsViewController *objProductDetails=[[ProductDetailsViewController alloc]init];
	
	// Passing product details to ProductDetailsViewController
	objProductDetails.isWishlist = NO;
	
	objProductDetails.dicProduct = dictTemp;
	self.navigationItem.title = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.tabbar.store"];
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
#pragma mark Table cell image support

- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
		if (imageDownloadsInProgress!=nil)
			[iconDownloader startDownload];
        [iconDownloader release];
    }
}

// This method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.arrAppRecordsAllEntries count] > 0)
    {
        NSArray *visiblePaths = [tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            AppRecord *appRecord = [self.arrAppRecordsAllEntries objectAtIndex:indexPath.row];
            
            if (!appRecord.appIcon) // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
}

// Called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        TableViewCell_Common *cell = (TableViewCell_Common *) [tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
		NSDictionary *dictTemp=[arrSearch objectAtIndex:indexPath.row];
		
        // Display the newly loaded image
		UIImage *imgProduct;
		
		for (UIActivityIndicatorView *actInd in [cell subviews])
		{
			if ([actInd isKindOfClass:[UIActivityIndicatorView class]])
            {
                [actInd removeFromSuperview];
            }
		}
		
        imgProduct = iconDownloader.appRecord.appIcon;
		
		NSString *strStatus, *strTemp;
		
		if (dictTemp)
        {
            strTemp = [dictTemp objectForKey:@"sIPhoneStatus"];
        }
		
		if ((strTemp != nil) && (![strTemp isEqual:[NSNull null]]))
		{
			if ([[dictTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"coming"])
            {
                strStatus=[NSString stringWithFormat:@"%@    ",[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.comming.soon"]];
            }
			else if ([[dictTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"sold"])
            {
                strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
            }
			else if ([[dictTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"active"])
            {
                strStatus = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"];
            }
			else
            {
                strStatus = [NSString stringWithFormat:@"%@",[dictTemp objectForKey:@"sIPhoneStatus"]];
            }
		}
		else
        {
            strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
        }
		
		NSArray *interOptionDict = [[NSArray alloc]init];
		interOptionDict = [dictTemp objectForKey:@"productOptions"];
		
		[interOptionDict retain];
		
		if ([[dictTemp valueForKey:@"bUseOptions"] intValue]==0)
		{
			NSString *strDicTemp=[dictTemp valueForKey:@"iAggregateQuantity"];
			
			if (![strDicTemp isKindOfClass:[NSNull class]])
			{
				
				if ([[dictTemp valueForKey:@"iAggregateQuantity"] intValue]!=0)
                {
                    strStatus=[dictTemp objectForKey:@"sIPhoneStatus"];
                }
				else
                {
                    strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
                }
			}
		}
		if (interOptionDict)
        {
            [interOptionDict release];
        }
		
		if ([strStatus isEqualToString:@"active"])
        {
            strStatus = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"];
        }
		
		else if ([strStatus isEqualToString:@"sold"])
        {
            strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
        }
		else if ([strStatus isEqualToString:@"coming"])
        {
            strStatus=[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.comming.soon"];
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
                        
						[cell setProductName:[dictTemp valueForKey:@"sName"] :[ProductPriceCalculation productActualPrice:dictTemp]:strStatus :[NSString stringWithFormat:@"%@",strFinalProductPrice]:imgProduct];
						
					}
					else
                    {
						[cell setProductName:[dictTemp valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%0.2f ", _savedPreferences.strCurrencySymbol,( [[dictTemp valueForKey:@"fPrice"] floatValue])]:strStatus :[NSString stringWithFormat:@"%@",strFinalProductPrice]:imgProduct];
					}
					
				}
				else
                {
                    [cell setProductName:[dictTemp valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%@", _savedPreferences.strCurrencySymbol, strFinalProductPrice]:strStatus :@"":imgProduct];
                }
			}
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
	}
}

// Called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageError:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        TableViewCell_Common *cell = (TableViewCell_Common *) [tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
		NSDictionary *dictTemp=[arrSearch objectAtIndex:indexPath.row];
		
      	UIImage *imgProduct;
		
		for (UIActivityIndicatorView *actInd in [cell subviews])
		{
			if ([actInd isKindOfClass:[UIActivityIndicatorView class]])
            {
                [actInd removeFromSuperview];
            }
		}
		
        imgProduct=nil;
        
		NSString *strStatus, *strTemp;
		
		if (dictTemp)
        {
            strTemp = [dictTemp objectForKey:@"sIPhoneStatus"];
        }
		
		if ((strTemp != nil) && (![strTemp isEqual:[NSNull null]]))
		{
			if ([[dictTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"coming"])
            {
                strStatus=[NSString stringWithFormat:@"%@    ",[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.comming.soon"]];
            }
			else if ([[dictTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"sold"])
            {
                strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
            }
			else if ([[dictTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"active"])
            {
                strStatus = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"];
            }
			else
            {
                strStatus = [NSString stringWithFormat:@"%@",[dictTemp objectForKey:@"sIPhoneStatus"]];
            }
			
		}
		else
        {
            strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
        }
		
		NSArray *interOptionDict = [[NSArray alloc]init];
		interOptionDict = [dictTemp objectForKey:@"productOptions"];
		
		[interOptionDict retain];
		
		if ([[dictTemp valueForKey:@"bUseOptions"] intValue]==0)
		{
			NSString *strDicTemp=[dictTemp valueForKey:@"iAggregateQuantity"];
			if (![strDicTemp isKindOfClass:[NSNull class]])
			{
				if ([[dictTemp valueForKey:@"iAggregateQuantity"] intValue]!=0)
                {
                    strStatus=[dictTemp objectForKey:@"sIPhoneStatus"];
                }
				else
                {
                    strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
                }
			}
		}
		
		if (interOptionDict)
        {
            [interOptionDict release];
        }
		
		if ([strStatus isEqualToString:@"active"])
        {
            strStatus = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"];
        }
		else if ([strStatus isEqualToString:@"sold"])
        {
            strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
        }
		else if ([strStatus isEqualToString:@"coming"])
        {
            strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.comming.soon"];
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
					strOriginalPrice=[NSString stringWithFormat:@"( inc %@)",[dictTemp objectForKey:@"sTaxType"]];
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
						[cell setProductName:[dictTemp valueForKey:@"sName"] :[ProductPriceCalculation productActualPrice:dictTemp]:strStatus :[NSString stringWithFormat:@"%@",strFinalProductPrice]:imgProduct];
						
					}
					else
                    {
						[cell setProductName:[dictTemp valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%0.2f ", _savedPreferences.strCurrencySymbol,( [[dictTemp valueForKey:@"fPrice"] floatValue])]:strStatus :[NSString stringWithFormat:@"%@",strFinalProductPrice]:imgProduct];
					}
				}
				else
                {
                    [cell setProductName:[dictTemp valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%@", _savedPreferences.strCurrencySymbol, strFinalProductPrice]:strStatus :@"":imgProduct];
                }
				
            }
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
	}
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

- (void)markStarRating:(UITableViewCell *)cell:(int)index
{
    int xValue=226;
	float rating;
    
	NSDictionary *dictProducts=[arrSearch objectAtIndex:index];
  	
	if (![dictProducts isKindOfClass:[NSNull class]])
    {
		if ([[dictProducts valueForKey:@"fAverageRating"] isEqual:[NSNull null]])
        {
            rating = 0.0;
        }
		else
        {
            rating = [[dictProducts valueForKey:@"fAverageRating"] floatValue];
        }
    }
    
	float tempRating;
	tempRating=floor(rating);
	tempRating=rating-tempRating;
	
	for (int i=0; i<5; i++)
	{
		imgRatingsTemp[i] = [[[UIImageView alloc] initWithFrame:CGRectMake( xValue, 60, 12, 12)] autorelease];
        imgRatingsTemp[i].clipsToBounds = TRUE;
		[imgRatingsTemp[i] setImage:[UIImage imageNamed:@"black_star.png"]];
		[imgRatingsTemp[i] setBackgroundColor:[UIColor clearColor]];
		[cell addSubview:imgRatingsTemp[i]];
		
		xValue += 15;
	}
	
	int iTemp =0;
	
	for (int i=0; i<abs(rating) ; i++)
	{
		viewRatingBG[i] = [[[UIView  alloc] initWithFrame:CGRectMake(0, 0, 12, 12)] autorelease];
		[viewRatingBG[i] setBackgroundColor:[UIColor clearColor]];
		[imgRatingsTemp[i] addSubview:viewRatingBG[i]];
		imgRatings[i] = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)] autorelease];
		[imgRatings[i] setImage:[UIImage imageNamed:@"yello_star.png"]];
		[imgRatingsTemp[i] addSubview:imgRatings[i]];
		iTemp = i;
	}
	
	if (tempRating>0)
	{
		int iLastStarValue = 0;
		if (rating >=1.0)
        {
            iLastStarValue = iTemp + 1;
        }
        
        viewRatingBG[iLastStarValue] = [[[UIView  alloc] initWithFrame:CGRectMake(0, 0, tempRating * 12, 12)] autorelease];
        viewRatingBG[iLastStarValue].clipsToBounds = TRUE;
        [imgRatingsTemp[iLastStarValue] addSubview:viewRatingBG[iLastStarValue]];
        
        imgRatings[iLastStarValue] = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)] autorelease];
        [imgRatings[iLastStarValue] setImage:[UIImage imageNamed:@"yello_star.png"]];
        [viewRatingBG[iLastStarValue] addSubview:imgRatings[iLastStarValue]];
    }
}

-(BOOL)checkOptionsAvailability:(NSArray *)arrOptionsData

{
	BOOL isOutOfStock=NO;
	int dropDownCount=-1;
	NSMutableArray *arrDropDown[100];
	NSString *strTitle;
	
	if([arrOptionsData count]>0)
	{
		dropDownCount=0;
		strTitle= [NSString stringWithFormat:@"%@",[[arrOptionsData objectAtIndex:0] objectForKey:@"sTitle"]];
		
	}
	
	
	for(int count=0;count<[arrOptionsData count];count++)
	{
		
		if(([[NSString stringWithFormat:@"%@",[[arrOptionsData objectAtIndex:count]objectForKey:@"sTitle"]] isEqualToString:strTitle]))
		{
			if(!arrDropDown[dropDownCount])
				arrDropDown[dropDownCount]=[[NSMutableArray alloc]init];
			
			[arrDropDown[dropDownCount] addObject:[arrOptionsData objectAtIndex:count]];
			
		}
		
		else
		{
			strTitle=[NSString stringWithFormat:@"%@",[[arrOptionsData objectAtIndex:count]objectForKey:@"sTitle"]];
			dropDownCount++;
			
			if(!arrDropDown[dropDownCount])
				arrDropDown[dropDownCount]=[[NSMutableArray alloc]init];
			
			[arrDropDown[dropDownCount] addObject:[arrOptionsData objectAtIndex:count]];
			
		}
	}
	
	for(int i=0;i<=dropDownCount;i++)
		
	{
		if(isOutOfStock==NO)
		{
			for(int j=0;j<[arrDropDown[i] count];j++)
			{
				if ([[[arrDropDown[i] objectAtIndex:j]valueForKey:@"iAvailableQuantity"]intValue]!=0)
				{
					
					isOutOfStock=NO;
					break;
					
				}
				
				else
					
				{
					isOutOfStock=YES;
				}
			}
	    }
		else
		{
			break;
		}
	}
	
	return isOutOfStock;
	
}



- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
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
	[arrAppRecordsAllEntries release];
	[imageDownloadsInProgress release];
    
	[tableView release];
	tableView =nil;
    
	[contentView release];
	contentView=nil;
	
	[nameDescriptor release];
	[priceDescriptor release];
	[statusDescriptor release];
    
    [super dealloc];
}


@end
