//
//  CategoryViewController.m
//  MobiCart
//
//  Created by Mobicart on 8/4/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

/** The View Controller For Sub-Departments in a Store **/

#import "CategoryViewController.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

@implementation CategoryViewController
@synthesize selectedRow,categoryId;

- (void)viewWillAppear:(BOOL)animated
{
	// The title is set to keep checks on Search Bar of this view controller
    self.title = @"Category";
	if (btnStore)
	{
		[btnStore removeFromSuperview];
		[btnStore release];
		btnStore=nil;
	}
    btnStore=[[UIButton alloc]init];
	[btnStore setBackgroundImage:[UIImage imageNamed:@"store_btn_iphone4.png"] forState:UIControlStateNormal];
	[btnStore setTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.department.store"] forState:UIControlStateNormal];
	[btnStore.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
	[btnStore addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	[btnStore setFrame:CGRectMake(35, 0, 69,36)];
	
	UIBarButtonItem *btnBack=[[UIBarButtonItem alloc] initWithCustomView:btnStore];
	[btnBack setStyle:UIBarButtonItemStyleBordered];
	
	[self.navigationItem setLeftBarButtonItem:btnBack];
	
	
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateLabelStore" object:nil];
	
	if ([GlobalPreferences isClickedOnFeaturedProductFromHomeTab])
	{
		[self performSelector:@selector(dismissLoadingBar_AtBottom) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES];
		
		ProductViewController *objProduct = [[ProductViewController alloc]init];
		if (![[[GlobalPreferences getCurrentFeaturedDetails] objectForKey:@"categoryId"] isKindOfClass:[NSNull class]])
        {
            [GlobalPreferences setCurrentCategoryId:[[[GlobalPreferences getCurrentFeaturedDetails] objectForKey:@"categoryId"] intValue]];
        }
        
		[self.navigationController pushViewController:objProduct animated:NO];
		[objProduct release];
	}
}
- (void)viewDidAppear:(BOOL)animated
{
	if (isCatogeryEmpty==YES)
	{
		isCatogeryEmpty=NO;
		[[self navigationController]popViewControllerAnimated:NO];
	}
}
-(void)viewWillDisappear:(BOOL)animated
{
	self.title=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.home.back"];
}
- (void)back
{
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)loadView
{
	categoryCount=categoryCount+1;
    
    // The title is set to keep checks on Search Bar of this view controller
	self.title = @"Category";
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignSearchBar) name:@"resignSearchBarFromCategory" object:nil];
    
	if (![GlobalPreferences isInternetAvailable])
	{
		[GlobalPreferences stopLoadingIndicator];
		NSString* errorString = [[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.text"];
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.title"] message:errorString delegate:self cancelButtonTitle:nil otherButtonTitles:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"], nil];
		[errorAlert show];
		[errorAlert release];
	}
	else
	{
		[GlobalPreferences setCurrentNavigationController:self.navigationController];
		
		self.navigationItem.titleView = [GlobalPreferences createLogoImage];
		
		[self allocateMemoryToObjects];
		
		[NSThread detachNewThreadSelector:@selector(fetchDataFromServer) toTarget:self withObject:nil];
		contentView=[[UIView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake(0, 0, 320, 396) chageHieght:YES]];
		self.view=contentView;
		UIImageView *imgBg=[[UIImageView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake(0, 0, 320, 396) chageHieght:YES]];
		[imgBg setImage:[UIImage imageNamed:@"product_details_bg.png"]];
		[contentView addSubview:imgBg];
		[imgBg release];
		
		[self createTableView];
		[self createSubViewsAndControls];
	}
}
-(void)resignSearchBar
{
	[_searchBar resignFirstResponder];
}
- (void)allocateMemoryToObjects
{
	if (!showArray)
    {
        showArray=[[NSMutableArray alloc]init];
    }
    
	if (!showNoArray)
    {
        showNoArray=[[NSMutableArray alloc]init];
    }
    if (!showNoArrayCategories)
    {
        showNoArrayCategories=[[NSMutableArray alloc]init];
    }
    
	if (!arrCategoryIDs)
    {
        arrCategoryIDs = [[NSMutableArray alloc] init];
    }
    
	if (!showArray_Searched)
    {
        showArray_Searched=[[NSMutableArray alloc]init];
    }
    
	if (!showNoArray_Searched)
    {
        showNoArray_Searched=[[NSMutableArray alloc]init];
    }
    
	if (! arrCategoryIDs_Searched)
    {
        arrCategoryIDs_Searched=[[NSMutableArray alloc]init];
    }
    
}

- (void)navigatePlease
{
	ProductViewController *objProduct = [[ProductViewController alloc]init];
	isCatogeryEmpty=YES;
	[self.navigationController pushViewController:objProduct animated:YES];
	[objProduct release];
}

- (void)fetchDataFromServer
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSDictionary *dictCategories;
    
    if(self.categoryId==0)
        dictCategories = [ServerAPI fetchAllCatogeries:iCurrentDepartmentId:iCurrentStoreId];
	else
        dictCategories=[ServerAPI fetchSubCategories:self.categoryId:iCurrentStoreId];
    
	
    NSArray *arrTemp  = [dictCategories objectForKey:@"categories"];
	
	if ([arrTemp count] >0)
	{
		for (NSDictionary *dictCategories in arrTemp)
        {
			[showArray addObject:[dictCategories objectForKey:@"sName"]];
			[arrCategoryIDs addObject:[dictCategories objectForKey:@"id"]];
            [showNoArray addObject:[dictCategories objectForKey:@"iProductCount"]];
            [showNoArrayCategories addObject:[dictCategories objectForKey:@"iCategoryCount"]];
            
        }
        
		showArray_Searched = [[NSMutableArray alloc] initWithArray:showArray];
		showNoArray_Searched =[[NSMutableArray alloc] initWithArray:showNoArray];
		arrCategoryIDs_Searched = [[NSMutableArray alloc] initWithArray:arrCategoryIDs];
		arrCategoriesCount_Searched=[[NSMutableArray alloc] initWithArray:showNoArrayCategories];
        
		if (tableView)
        {
            [tableView reloadData];
        }
	}
	else
	{
		isCatogeryEmpty=YES;
	}
	[pool release];
	
	[GlobalPreferences stopLoadingIndicator];
	
	[self performSelector:@selector(dismissLoadingBar_AtBottom) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES];
}

- (void)dismissLoadingBar_AtBottom
{
	[GlobalPreferences performSelector:@selector(dismissLoadingBar_AtBottom)];
}

- (void)createSubViewsAndControls
{
	if (isCatogeryEmpty==YES)
    {
        [self navigatePlease];
    }
    
	_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,
															  321 ,44)];
	[GlobalPreferences setSearchBarDefaultSettings:_searchBar];
	[_searchBar setDelegate:self];
	[_searchBar setTag:1001];
	[contentView addSubview:_searchBar];
	
	
    // Only show bottom loading bar, If clicked on Store Tab
	if (![GlobalPreferences isClickedOnFeaturedProductFromHomeTab])
	{
		// Adding loading indicator on topBar
		[GlobalPreferences startLoadingIndicator];
	}
	
	UIView *selectDeptView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, 28)];
	[contentView addSubview:selectDeptView];
	[selectDeptView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"select_dept_bar.png"]]];
	
	UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(9, 0, 310, 28)];
	lblTitle.font=lblFont;
	[lblTitle setBackgroundColor:[UIColor clearColor]];
	[lblTitle setFont:[UIFont boldSystemFontOfSize:13]];
    [lblTitle setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.shoppingcart.select.category"]];
	[lblTitle setTextColor:[UIColor whiteColor]];
	[selectDeptView addSubview:lblTitle];
	[lblTitle release];
}
- (void)createTableView
{
	if (tableView)
	{
		[tableView release];
		tableView=nil;
	}
	
	tableView=[[UITableView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake(0,62, 320, 300) chageHieght:YES] style:UITableViewStyleGrouped];
	tableView.delegate=self;
	tableView.dataSource=self;
	tableView.showsVerticalScrollIndicator = FALSE;
	tableView.backgroundView=nil;
    tableView.backgroundColor=[UIColor clearColor];
	[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[contentView addSubview:tableView];
}

#pragma mark Search Bar Delegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
	return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	// If a valid search was entered but the user wanted to cancel, bring back the main list content
	[showArray_Searched removeAllObjects];
	[showNoArray_Searched removeAllObjects];
	[arrCategoriesCount_Searched removeAllObjects];
    
	[showArray_Searched addObjectsFromArray:showArray];
	[showNoArray_Searched addObjectsFromArray:showNoArray];
    [arrCategoriesCount_Searched addObjectsFromArray:showNoArrayCategories];
	
    @try
	{
		[tableView reloadData];
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
	[showArray_Searched removeAllObjects];
	[showNoArray_Searched removeAllObjects];
    [arrCategoriesCount_Searched removeAllObjects];
    
	
	if ([searchText isEqualToString:@""] || searchText==nil)
	{
		[showArray_Searched addObjectsFromArray:showArray];
		[showNoArray_Searched addObjectsFromArray:showNoArray];
        [arrCategoriesCount_Searched addObjectsFromArray:showNoArrayCategories];
        [tableView reloadData];
		return;
	}
	
	
	NSInteger counter = 0;
	for(NSString *name in showArray)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
		NSRange r = [[name uppercaseString] rangeOfString:[searchText uppercaseString]] ;
		if (r.location != NSNotFound)
		{
			// Checking only the start of the names.
			if (r.location==0)
			{
				[showArray_Searched addObject:name];
				[showNoArray_Searched addObject:[showNoArray objectAtIndex:[showArray indexOfObject:name]]];
                [arrCategoriesCount_Searched addObject:[showNoArrayCategories objectAtIndex:[showArray indexOfObject:name]]];
			}
		}
		counter++;
		[pool release];
	}
	[tableView reloadData];
}

#pragma mark -
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch=[touches anyObject];
	
	if ([touch tapCount]==1)
    {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark TableView Delegate Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 55;
}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
	return [showArray_Searched count];
}

-(UITableViewCell*) tableView:(UITableView*) tableview cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
	NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableIdentifier%d", indexPath.row];
	TableViewCell_Common *cell= (TableViewCell_Common *)[tableview dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	
	{
		cell = [[[TableViewCell_Common alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: SimpleTableIdentifier]autorelease];
		cell.backgroundColor=cellBackColor;
        cell.textLabel.textColor=_savedPreferences.headerColor;
        
        UILabel *lblQyantity = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 46, 28)];
		[lblQyantity setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        UIImageView *cellImage =[[UIImageView alloc]initWithFrame:CGRectMake(228, 13, 46, 28)];
        cellImage.image  = [UIImage imageNamed:@"oval_shape.png"];
		
		UIImageView *imgCellBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 56)];
		[imgCellBackground setImage:[UIImage imageNamed:@"store_cell_bg.png"]];
		
		[[cell layer] insertSublayer:imgCellBackground.layer atIndex:0];
		
		[imgCellBackground release];
        
        if ([[arrCategoriesCount_Searched objectAtIndex:indexPath.row]intValue]==0)
        {
            if ([[showNoArray_Searched objectAtIndex:indexPath.row]intValue]>0)
            {
                [lblQyantity setText:[NSString stringWithFormat:@"%@", [showNoArray_Searched objectAtIndex:indexPath.row]]];
            }
            else
            {
                [lblQyantity setText:[NSString stringWithFormat:@"%@", [arrCategoriesCount_Searched objectAtIndex:indexPath.row]]];
            }
        }
        else
        {
            [lblQyantity setText:[NSString stringWithFormat:@"%@", [arrCategoriesCount_Searched objectAtIndex:indexPath.row]]];
        }
		[lblQyantity setTextAlignment:UITextAlignmentCenter];
		[lblQyantity setBackgroundColor:[UIColor clearColor]];
        lblQyantity.textColor = _savedPreferences.headerColor;
        [cell addSubview:cellImage];
        [cellImage addSubview:lblQyantity];
		[lblQyantity release];
		[cellImage release];
	}
	UILabel *cellCategoryName=[[UILabel alloc]initWithFrame:CGRectMake(7, 17, 218, 28)];
	cellCategoryName.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
	[cellCategoryName setBackgroundColor:[UIColor clearColor]];
	cellCategoryName.textColor=_savedPreferences.headerColor;
	cellCategoryName.text= [NSString stringWithFormat:@"%@", [showArray_Searched objectAtIndex:indexPath.row]];
	[cell addSubview:cellCategoryName];
	[cellCategoryName release];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	UIImageView *imgViewCellAcccesory=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
	[cell setAccessoryView:imgViewCellAcccesory];
	[imgViewCellAcccesory release];
	
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return  cell;
}

- (void)tableView:(UITableView*)tableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	
    if([[arrCategoriesCount_Searched objectAtIndex:indexPath.row]intValue]==0)
	{
		if([[showNoArray_Searched objectAtIndex:indexPath.row]intValue]>0)
		{
			
            ProductViewController *objProduct = [[ProductViewController alloc]init];
            UISearchBar *searchbar = (UISearchBar *)[contentView viewWithTag:1001];
            if ([searchbar isFirstResponder])
            {
                [searchbar resignFirstResponder];
            }
            
            int indexWhileSearching = [showArray indexOfObject:[showArray_Searched objectAtIndex:indexPath.row]];
            
            [GlobalPreferences setCurrentCategoryId:[[arrCategoryIDs objectAtIndex:indexWhileSearching] integerValue]];
            self.navigationItem.title = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.tabbar.store"];
            [self.navigationController pushViewController:objProduct animated:YES];
            [objProduct release];
	    }
    }
	else
    {
		CategoryViewController *objCategory = [[CategoryViewController alloc]init];
		isCatogeryEmpty=NO;
        int indexWhileSearching = [showArray indexOfObject:[showArray_Searched objectAtIndex:indexPath.row]];
        
        objCategory.categoryId=[[arrCategoryIDs objectAtIndex:indexWhileSearching] integerValue];
        
		// Hide keyboard, if visible, when navigating to the next view controller
		UISearchBar *searchbar = (UISearchBar *)[contentView viewWithTag:1001];
		if([searchbar isFirstResponder])
        {
            [searchbar resignFirstResponder];
        }
		
      	[self.navigationController pushViewController:objCategory animated:YES];
		[objCategory release];
	}
    
    
    
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
	[btnStore release];
	[showArray release];
    
	showArray=nil;
	[showNoArray release];
    
	showNoArray=nil;
	[tableView release];
    
	tableView =nil;
	[contentView release];
    
	contentView=nil;
	[_searchBar release];
	
    [super dealloc];
}


@end
