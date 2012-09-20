//
//  StoreViewController.m
//  MobiCart
//
//  Created by Mobicart on 7/6/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

/** The View Controller For Mobi-cart Departments/SubDepartments And Products Store. **/

#import "StoreViewController.h"
#import "GlobalPreferences.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>


@implementation StoreViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
    {
        // Custom initialization
		[self.tabBarItem setTitle:@"Account"];
		self.tabBarItem.image =[UIImage imageNamed:@"store_icon.png"];
    }
    return self;
}

#pragma mark -
- (void)viewWillAppear:(BOOL)animated
{ 
	[super viewWillAppear:animated];
	
	categoryCount=0;
    
    isStoreSearch=NO;

	if(isCatogeryEmpty==YES)
    {
        isCatogeryEmpty=NO;
    }
	
	if(isFeaturedProductWithoutCatogery==YES)
    {
        isFeaturedProductWithoutCatogery=NO;
    }
	
	if([GlobalPreferences isClickedOnFeaturedProductFromHomeTab])
	{
		CategoryViewController *objCategory = [[CategoryViewController alloc]init];
		[self.navigationController pushViewController:objCategory animated:NO];
		[objCategory release];
        
		// Setting the current navigation controller, for navigation from top button
		[GlobalPreferences setCurrentNavigationController:self.navigationController];
	}
	
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateShoppingLabel) name:@"updateLabelStore" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
	// Stoping the loading indicator
	[GlobalPreferences dismissLoadingBar_AtBottom];
}

- (void)updateShoppingLabel
{
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
}

#pragma mark - 
- (void)updateDataForCurrent_Navigation_And_View_Controller
{
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
}

- (void)loadView
{
	[NSThread detachNewThreadSelector:@selector(fetchDataFromServer) toTarget:self withObject:nil];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignSearchBar) name:@"resignSearchBarFromStore" object:nil];
	
	[GlobalPreferences setCurrentNavigationController:self.navigationController];
	[super viewDidLoad];
	
	self.navigationItem.titleView = [GlobalPreferences createLogoImage];
	
	lblCart = [[UILabel alloc] initWithFrame:CGRectMake(280, 5, 30, 34)];
	lblCart.backgroundColor = [UIColor clearColor];
	lblCart.textAlignment = UITextAlignmentCenter;
	lblCart.font = [UIFont boldSystemFontOfSize:16];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	lblCart.textColor = [UIColor whiteColor];
	[self.navigationController.navigationBar addSubview:lblCart];
	
	contentView=[[UIView alloc]initWithFrame:CGRectMake( 0, 0, 320, 396)];

	self.view=contentView;
	
	UIImageView *imgBg=[[UIImageView alloc]initWithFrame:CGRectMake(0,30, 320, 396)];
	[imgBg setImage:[UIImage imageNamed:@"product_details_bg.png"]];
	[contentView addSubview:imgBg];
	[imgBg release];
	
	if(![GlobalPreferences isInternetAvailable])
	{
		NSString* errorString = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.text"];
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.title"] message:errorString delegate:self cancelButtonTitle:nil otherButtonTitles:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"], nil];
		[errorAlert show];
		[errorAlert release];
	}
	else
	{
		_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,
																  320 ,44)];
		[GlobalPreferences setSearchBarDefaultSettings:_searchBar];	
		[_searchBar setDelegate:self];
		[_searchBar setTag:1001];
		[contentView addSubview:_searchBar];
		UIView *viewRemoveLine = [[UIView alloc] initWithFrame:CGRectMake( 0, 43, 320,1)];
		[viewRemoveLine setBackgroundColor:self.navigationController.navigationBar.tintColor];
		[self.navigationController.navigationBar addSubview:viewRemoveLine];
        [viewRemoveLine release];
		
		[self allocateMemoryToObjects];
		
		[self createTableView];
				
		UIView *selectDeptView=[[UIView alloc]initWithFrame:CGRectMake(0,44, 320, 28)];
		[contentView addSubview:selectDeptView];
		[selectDeptView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"select_dept_bar.png"]]];
		
		UILabel *storeLbl=[[UILabel alloc]initWithFrame:CGRectMake(9, 0, 310, 28)];
		storeLbl.font=lblFont;
		[storeLbl setBackgroundColor:[UIColor clearColor]];
		[storeLbl setFont:[UIFont boldSystemFontOfSize:13]];
		[storeLbl setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.department.selectdepartment"]];
		[storeLbl setTextColor:[UIColor whiteColor]];
		[selectDeptView addSubview:storeLbl];
		[storeLbl release];
		
        // Only show bottom loading bar, If clicked on Store Tab
		if(![GlobalPreferences isClickedOnFeaturedProductFromHomeTab])
		{
			// Adding Loading bar at bottom
			[GlobalPreferences addLoadingBar_AtBottom:self.tabBarController.view withTextToDisplay:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
		}
	}
}
-(void)resignSearchBar
{
	[_searchBar resignFirstResponder];
}
- (void)allocateMemoryToObjects
{
	if(!showArray)
    {
        showArray=[[NSMutableArray alloc]init];
    }
		
	if(!showNoArray)
    {
        showNoArray=[[NSMutableArray alloc]init];
    }
		
	if(!arrDeptIDs)
    {
        arrDeptIDs = [[NSMutableArray alloc] init];
    }
		
	if(!showArray_Searched)
    {
        showArray_Searched=[[NSMutableArray alloc]init];
    }
		
	if(!showNoArray_Searched)
    {
        showNoArray_Searched=[[NSMutableArray alloc]init];
    }
		
	if(!arrDeptIDs_Searched)
    {
        arrDeptIDs_Searched = [[NSMutableArray alloc] init];
    }
		
	if(!arrNumberofProducts)
    {
        arrNumberofProducts=[[NSMutableArray alloc]init];
    }
		
	if(!arrNumberofProducts_Search)
    {
        arrNumberofProducts_Search=[[NSMutableArray alloc]init];
    }
		
}

BOOL isTryingSecondTime;

// Fetching Departments from Server
- (void)fetchDataFromServer
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    // Fetch data from server
	NSDictionary *dictFeatures = [ServerAPI fetchAllDepartments:iCurrentStoreId];
	
	NSArray *arrTemp  = [dictFeatures objectForKey:@"departments"];
	if (![arrTemp isKindOfClass:[NSNull class]])
	{
		if ([arrTemp count] >0)
		{
			for (NSDictionary *dictFeatures in arrTemp)
            {
				[showArray addObject:[dictFeatures objectForKey:@"sName"]];
				[arrDeptIDs addObject:[dictFeatures objectForKey:@"id"]];
				[showNoArray addObject:[dictFeatures objectForKey:@"iCategoryCount"]];
				[arrNumberofProducts addObject:[dictFeatures objectForKey:@"iProductCount"]];
			}
			
			showArray_Searched = [[NSMutableArray alloc] initWithArray:showArray];
			showNoArray_Searched =[[NSMutableArray alloc] initWithArray:showNoArray];
			arrDeptIDs_Searched = [[NSMutableArray alloc] initWithArray:arrDeptIDs];
			arrNumberofProducts_Search=[[NSMutableArray alloc]initWithArray:arrNumberofProducts];
			
			if(tableView)
            {
                [tableView reloadData];
            }
		}
		else
		{
			if (!isTryingSecondTime)
			{ 
				NSLog (@"No Data Available for this Store (StoreViewContoller)  --> TRYING AGAIN TO FETCH DATA ");
				isTryingSecondTime = TRUE;
				[self fetchDataFromServer];
			}
			else
            {
				NSLog (@"No Data Available for this Store (StoreViewContoller)");
            }
		}
	}
	else 
	{
		NSLog(@"No Data Returned from server (StoreViewContoller)");
	}
	
	[pool release];
	
	// Stoping the loading indicator
	[GlobalPreferences stopLoadingIndicator];
	[GlobalPreferences performSelector:@selector(dismissLoadingBar_AtBottom)];
}

- (void)createTableView
{
	if (tableView)
	{
		[tableView release];
		tableView=nil;
	}
	tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,70, 320, 295) style:UITableViewStylePlain];
	tableView.delegate=self;
	tableView.dataSource=self;
   	
	tableView.showsVerticalScrollIndicator = FALSE;
	[tableView setBackgroundColor:[UIColor clearColor]];
	[tableView setSeparatorStyle:UITableViewCellSelectionStyleNone];
	[contentView addSubview:tableView];
}

#pragma mark -
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch=[touches anyObject];
	
	if([touch tapCount]==1)
    {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark TableView Delegate Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 55;
}

- (NSInteger)tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
	
	return [showArray_Searched count];
}

- (UITableViewCell*)tableView:(UITableView*) tableview cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
	NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableIdentifier%d", indexPath.row];
	UITableViewCell *cell= [tableview dequeueReusableCellWithIdentifier:SimpleTableIdentifier];

	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: SimpleTableIdentifier]autorelease];
		
		cell.backgroundColor=cellBackColor;
		UIImageView *imgCellBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 55)];
		[imgCellBackground setImage:[UIImage imageNamed:@"store_cell_bg.png"]];
		
		[[cell layer] insertSublayer:imgCellBackground.layer atIndex:0];
		
		[imgCellBackground release];
    }
	
	UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(7, 17, 218, 28)];
	lblTitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
	lblTitle.textColor=_savedPreferences.headerColor;
	[lblTitle setBackgroundColor:[UIColor clearColor]];
	[cell addSubview:lblTitle];
	UILabel *lblQyantity = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 46, 28)];
	UIImageView *cellImage =[[UIImageView alloc]initWithFrame:CGRectMake(232, 13, 46, 28)];                                 
	cellImage.image  = [UIImage imageNamed:@"oval_shape.png"];
	
	if ([[showNoArray_Searched objectAtIndex:indexPath.row]intValue]==0)
	{
		if ([[arrNumberofProducts_Search objectAtIndex:indexPath.row]intValue]>0)
		{
			[lblQyantity setText:[NSString stringWithFormat:@"%@", [arrNumberofProducts_Search objectAtIndex:indexPath.row]]];
		}
		else
		{
			[lblQyantity setText:[NSString stringWithFormat:@"%@", [showNoArray_Searched objectAtIndex:indexPath.row]]];
		}
	}
	else
	{
		[lblQyantity setText:[NSString stringWithFormat:@"%@", [showNoArray_Searched objectAtIndex:indexPath.row]]];
	}
	[lblQyantity setTextAlignment:UITextAlignmentCenter];
	[lblQyantity setBackgroundColor:[UIColor clearColor]];
	[lblQyantity setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
	lblQyantity.textColor = _savedPreferences.headerColor;        
	[cell addSubview:cellImage];
	
	[cellImage addSubview:lblQyantity];
	[lblQyantity release];
	[cellImage release];
	
	if ([[showNoArray_Searched objectAtIndex:indexPath.row]intValue]==0)
	{
		if ([[arrNumberofProducts_Search objectAtIndex:indexPath.row]intValue]>0)
		{
			lblTitle.text=[NSString stringWithFormat:@"%@", [showArray_Searched objectAtIndex:indexPath.row]];
			
		}
		else
        {
            lblTitle.text=[NSString stringWithFormat:@"%@", [showArray_Searched objectAtIndex:indexPath.row]];
			
        }
	}
	else
    {  
        lblTitle.text=@"";
        lblTitle.text=[NSString stringWithFormat:@"%@", [showArray_Searched objectAtIndex:indexPath.row]];
        }
	[lblTitle release];
	UIImageView *imgViewCellAcccesory=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
	[cell setAccessoryView:imgViewCellAcccesory];
	[imgViewCellAcccesory release];
	
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return  cell;
}

- (void)tableView:(UITableView*)tableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	int indexWhileSearching = [showArray indexOfObject:[showArray_Searched objectAtIndex:indexPath.row]];
	
	if([[showNoArray_Searched objectAtIndex:indexPath.row]intValue]==0)
	{
		if([[arrNumberofProducts_Search objectAtIndex:indexPath.row]intValue]>0)
		{			
			
			ProductViewController *objProducts = [[ProductViewController alloc]init];
			isCatogeryEmpty=YES;
			[GlobalPreferences setCurrentDepartmentId:[[arrDeptIDs objectAtIndex:indexWhileSearching] integerValue]];
			
			[[self navigationController]pushViewController:objProducts animated:YES];
			[objProducts release];
		}
	}
	else 
    {
		CategoryViewController *objCategory = [[CategoryViewController alloc]init];
		isCatogeryEmpty=NO;
        objCategory.categoryId=0;
    
		// Hide keyboard, if visible, when navigating to the next view controller
		UISearchBar *searchbar = (UISearchBar *)[contentView viewWithTag:1001];
		if([searchbar isFirstResponder])
        {
            [searchbar resignFirstResponder];
        }
		
		[GlobalPreferences setCurrentDepartmentId:[[arrDeptIDs objectAtIndex:indexWhileSearching] integerValue]];
		
		[self.navigationController pushViewController:objCategory animated:YES];
		[objCategory release];
	}
}

#pragma mark Search Bar Delegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar 
{  
    searchBar.showsCancelButton = YES;  
	isStoreSearch=YES;
	return YES;
}  

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar 
{  
    searchBar.showsCancelButton = NO;  
	isStoreSearch=NO;
	return YES;
}  

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{	
	[_searchBar resignFirstResponder];
	isStoreSearch=NO;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// Only show the status bar’s cancel button while in edit mode
	searchBar.showsCancelButton = YES;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	searchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[showArray_Searched removeAllObjects];
	[showNoArray_Searched removeAllObjects];
	[arrNumberofProducts_Search removeAllObjects];
    [tableView reloadData];

	if ([searchText isEqualToString:@""] || searchText==nil)
	{
		[showArray_Searched addObjectsFromArray:showArray];
		[showNoArray_Searched addObjectsFromArray:showNoArray];
		[arrNumberofProducts_Search addObjectsFromArray:arrNumberofProducts];
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
			if (r.location==0)// that is we are checking only the start of the names.
			{
				[showArray_Searched addObject:name];
				
				[showNoArray_Searched addObject:[showNoArray objectAtIndex:[showArray indexOfObject:name]]];
				
				[arrNumberofProducts_Search addObject:[arrNumberofProducts objectAtIndex:[showArray indexOfObject:name]]];
			}
		}
		counter++;
		[pool release];
	}
	[tableView reloadData];
   
}

// Called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	// If a valid search was entered but the user wanted to cancel, bring back the main list content
	[showArray_Searched removeAllObjects];
	[showNoArray_Searched removeAllObjects];
	[arrNumberofProducts_Search removeAllObjects];
	
	[showArray_Searched addObjectsFromArray:showArray];
	[showNoArray_Searched addObjectsFromArray:showNoArray];
	[arrNumberofProducts_Search addObjectsFromArray:arrNumberofProducts];
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

#pragma mark -
#pragma mark Memory Management
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
	[showArray release];
	showArray=nil;
	
    [showNoArray release];
	showNoArray=nil;
	
    [tableView release];
	tableView =nil;
	
    [contentView release];
	contentView=nil;
	
    if(arrDeptIDs)
    {
        [arrDeptIDs release];
    }	
    [super dealloc];
}


@end
