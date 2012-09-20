//
//  DepartmentListingViewController.m
//  Mobicart
//
//  Created by Mobicart on 16/05/11.
//  Copyright Mobicart. All rights reserved.
//

#import "DepartmentListingViewController.h"
#import "Constants.h"
extern NSString *selectedDepartment;
extern StoreViewController *objStoreView;
int countStore=0;

@implementation DepartmentListingViewController

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

-(void)hideLoadingView
{
	[GlobalPrefrences dismissLoadingBar_AtBottom];	
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[NSTimer scheduledTimerWithTimeInterval:0.03
									 target:self
								   selector:@selector(hideLoadingView)
								   userInfo:nil
									repeats:NO];
    [super viewDidLoad];
	contentView = [[UIView	alloc]initWithFrame:CGRectMake( 100, 0,313,330)];
	[contentView setBackgroundColor:[UIColor blackColor]];
	self.view = contentView;
	[self allocateMemoryToObjects];
	
	
}



 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
  return UIInterfaceOrientationIsLandscape(interfaceOrientation);
 }


-(void)allocateMemoryToObjects
{
	
	UINavigationBar *navBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 315, 40)];
	[navBar setBarStyle:UIBarStyleBlackTranslucent];
	[contentView addSubview:navBar];
	
	UILabel *lblDepartments=[[UILabel alloc]initWithFrame:CGRectMake(55,0, 200,40)];
	[lblDepartments setBackgroundColor:[UIColor clearColor]];
	[lblDepartments setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.home.departments"]];
	[lblDepartments setTag:111];
	lblDepartments.textAlignment = UITextAlignmentCenter;
	[lblDepartments setTextColor:[UIColor whiteColor]];
	[lblDepartments setFont:[UIFont boldSystemFontOfSize:20]];
	[contentView addSubview:lblDepartments];
	[lblDepartments release];
	
	UIView *subView = [[UIView	alloc]initWithFrame:CGRectMake( 0,44,315,285)];
	[subView setBackgroundColor:[UIColor whiteColor]];
	[contentView addSubview:subView];
	[[subView layer] setCornerRadius:8.0];
	subView.layer.borderWidth = 4.0;
	subView.layer.borderColor = [[UIColor blackColor] CGColor];
	
	if(!showArray)
		showArray=[[NSMutableArray alloc]init];
	if(!showNoArray)
		showNoArray=[[NSMutableArray alloc]init];
	if(!arrDeptIDs)
		arrDeptIDs = [[NSMutableArray alloc] init];
	if(!showArray_Searched)
		showArray_Searched=[[NSMutableArray alloc]init];
	if(!showNoArray_Searched)
		showNoArray_Searched=[[NSMutableArray alloc]init];
	if(!arrDeptIDs_Searched)
		arrDeptIDs_Searched = [[NSMutableArray alloc] init];
	if(!arrNumberofProducts)
		arrNumberofProducts=[[NSMutableArray alloc]init];
	if(!arrNumberofProducts_Search)
		arrNumberofProducts_Search=[[NSMutableArray alloc]init];
    if(!arrDepartmentData)
		arrDepartmentData=[[NSMutableArray alloc]init];
	arrSubDepts=[[NSArray alloc]init];
	arrSubDepartments=[[NSMutableArray alloc]init];
	arrSubDepatermentsSearch=[[NSMutableArray alloc]init];
	
	
	arrSubDeptID=[[NSMutableArray alloc]init];
	arrSubDeptID_Search=[[NSMutableArray alloc]init];
	arrNumofProducts=[[NSMutableArray alloc]init];
	arrNumofProductsSearch=[[NSMutableArray alloc]init];
	
	
	btnBackToAllDepts = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnBackToAllDepts setTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.store.tab.all"] forState:UIControlStateNormal];
	[btnBackToAllDepts setFrame:CGRectMake(5, 10, 50, 25)];
	[btnBackToAllDepts setBackgroundImage:[UIImage imageNamed:@"edit_cart_btn.png"] forState:UIControlStateNormal];
	btnBackToAllDepts.titleLabel.font = [UIFont boldSystemFontOfSize:11];
	[btnBackToAllDepts setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[btnBackToAllDepts addTarget:self action:@selector(showListOfAllDepts) forControlEvents:UIControlEventTouchUpInside];
	[contentView addSubview:btnBackToAllDepts];
	
	
	btnBackToDepts=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnBackToDepts setTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.home.back"] forState:UIControlStateNormal];
	[btnBackToDepts setFrame:CGRectMake(250, 10, 60, 25)];
	[btnBackToDepts setHidden:YES];
	[btnBackToDepts setBackgroundImage:[UIImage imageNamed:@"edit_cart_btn.png"] forState:UIControlStateNormal];
	btnBackToDepts.titleLabel.font = [UIFont boldSystemFontOfSize:11];
	[btnBackToDepts setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[btnBackToDepts addTarget:self action:@selector(showListOfDepts) forControlEvents:UIControlEventTouchUpInside];
	[contentView addSubview:btnBackToDepts];
	[self createTableView];
}	


#pragma mark createTableView
-(void)createTableView
{
	
	@try {
		
		if(tblDepts)
		{
			[tblDepts release];
			tblDepts=nil;
		}
		
		tblDepts=[[UITableView alloc]initWithFrame:CGRectMake(2,50,315,270) style:UITableViewStylePlain];
		[tblDepts setDelegate:self];
		[tblDepts setDataSource:self];
		tblDepts.showsVerticalScrollIndicator = FALSE;
		[[tblDepts layer] setCornerRadius:4.0];
		[tblDepts setBackgroundColor:[UIColor clearColor]];
		[tblDepts setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		[tblDepts setSeparatorColor:[UIColor blackColor]];
		[contentView addSubview:tblDepts];
		
	}
	@catch (NSException * e) {
		NSLog(@"Exception Occured");
	}
	
}


-(void)viewWillAppear:(BOOL)animated
{
     [GlobalPrefrences removeLocalData];
	[self fetchDataForDepartments];
    countStore=0;
	
}	


	
-(void)showListOfDepts
    {
        countStore--;
        NSLog(@"%d",countStore);
        [arrDepartmentData removeAllObjects];
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSArray *arrTemp=[GlobalPrefrences getDepartmentsDataStore]; 
        [showArray removeAllObjects];
        [arrDeptIDs removeAllObjects];
        [showNoArray removeAllObjects];
        [arrNumberofProducts removeAllObjects];
        
        
        if([arrTemp count] >0)
        {
            for (NSDictionary *dictCategories in arrTemp) {
                [showArray addObject:[dictCategories objectForKey:@"sName"]];
                [arrDeptIDs addObject:[dictCategories objectForKey:@"id"]];
                [showNoArray addObject:[dictCategories objectForKey:@"iCategoryCount"]];
                [arrNumberofProducts addObject:[dictCategories objectForKey:@"iProductCount"]];
                
                
            }
            showArray_Searched = [[NSMutableArray alloc] initWithArray:showArray];
            arrDeptIDs_Searched=[[NSMutableArray alloc] initWithArray:arrDeptIDs];
            showNoArray_Searched=[[NSMutableArray alloc] initWithArray:showNoArray];
            arrNumberofProducts_Search=[[NSMutableArray alloc]initWithArray:arrNumberofProducts];
            
        }
        UILabel *lblDeptName=(UILabel*)[contentView viewWithTag:111];
        if(countStore==0)
        {
            [lblDeptName setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.home.departments"]];
            [btnBackToDepts setHidden:YES];
        }
        else
            [lblDeptName setText:[GlobalPrefrences getLastDepartmentNameStore]];
        
        [tblDepts reloadData];
        
        [pool release];
        
        
    }

-(void) showListOfAllDepts
{
	selectedDepartment = [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.store.tab.all"];
	objStoreView.isComingFromHomePage=NO;
	objStoreView.isProductWithoutSubCategory=NO;
	[objStoreView fetchDataFromServer];
	[objStoreView.popOverController dismissPopoverAnimated:YES];
}

-(void)fetchSubDepartments
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSDictionary* dictCategories = [ServerAPI fetchSubDepartments:iCurrentDepartmentId:iCurrentStoreId];
	NSArray *arrTemp  = [dictCategories objectForKey:@"categories"];
    [arrDepartmentData removeAllObjects];
	[arrDepartmentData addObject:arrTemp];
	[showArray removeAllObjects];
	[arrDeptIDs removeAllObjects];
	[showNoArray removeAllObjects];
    [arrNumberofProducts removeAllObjects];
    
	
	if([arrTemp count] >0)
	{
		for (NSDictionary *dictCategories in arrTemp) {
			[showArray addObject:[dictCategories objectForKey:@"sName"]];
			[arrDeptIDs addObject:[dictCategories objectForKey:@"id"]];
            [showNoArray addObject:[dictCategories objectForKey:@"iCategoryCount"]];
            [arrNumberofProducts addObject:[dictCategories objectForKey:@"iProductCount"]];
            
			
		}
		showArray_Searched = [[NSMutableArray alloc] initWithArray:showArray];
		arrDeptIDs_Searched=[[NSMutableArray alloc] initWithArray:arrDeptIDs];
		showNoArray_Searched=[[NSMutableArray alloc] initWithArray:showNoArray];
        arrNumberofProducts_Search=[[NSMutableArray alloc]initWithArray:arrNumberofProducts];
        
	}
	[tblDepts reloadData];
	[pool release];
	
}


BOOL isTryingSecondTime;
-(void)fetchDataForDepartments
{	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary *dictFeatures = [ServerAPI fetchDepartments:iCurrentStoreId];
	NSArray *arrTemp  = [dictFeatures objectForKey:@"departments"];
    [arrDepartmentData removeAllObjects];
    [arrDepartmentData addObject:arrTemp];
    [showArray removeAllObjects];
	[arrDeptIDs removeAllObjects];
	[showNoArray removeAllObjects];
    [arrNumberofProducts removeAllObjects];
	if(![arrTemp isKindOfClass:[NSNull class]])
	{
		if([arrTemp count] >0)
		{
			for (NSDictionary *dictFeatures in arrTemp) {
				[showArray addObject:[dictFeatures objectForKey:@"sName"]];
				[arrDeptIDs addObject:[dictFeatures objectForKey:@"id"]];
				[showNoArray addObject:[dictFeatures objectForKey:@"iCategoryCount"]];
				[arrNumberofProducts addObject:[dictFeatures objectForKey:@"iProductCount"]];
			}
			
			
			showArray_Searched = [[NSMutableArray alloc] initWithArray:showArray];
			showNoArray_Searched =[[NSMutableArray alloc] initWithArray:showNoArray];
			arrDeptIDs_Searched = [[NSMutableArray alloc] initWithArray:arrDeptIDs];
			arrNumberofProducts_Search=[[NSMutableArray alloc]initWithArray:arrNumberofProducts];
			
			if(tblDepts)
				[tblDepts reloadData];
		}
		
		else
		{
			if(!isTryingSecondTime)
			{ 
				NSLog (@"No Data Available for this Store (StoreViewContoller)  --> TRYING AGAIN TO FETCH DATA ");
				isTryingSecondTime = TRUE;
				[self fetchDataForDepartments];
			}
			else  
				NSLog (@"No Data Available for this Store (StoreViewContoller)");
			
		}
		
	}
	
	else 
	{
		NSLog(@"No Data Returned from server (StoreViewContoller)");
		
	}
	
	
	[pool release];
	[GlobalPrefrences performSelector:@selector(dismissLoadingBar_AtBottom)];
}

#pragma mark TableView Delegate Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 45;
}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
	
	return [showArray_Searched count];
	
}


- (UITableViewCell*) tableView:(UITableView*) tableview cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
	NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableIdentifier%d", indexPath.row];
	TableViewCell_Common *cell= (TableViewCell_Common *)[tableview dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
			
		if(cell==nil)
		{
			cell = [[[TableViewCell_Common alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: SimpleTableIdentifier]autorelease];
			
			cell.backgroundColor=[UIColor clearColor];		
			cell.textLabel.textColor=[UIColor blackColor];
			
			UIImageView *imgSeprator=[[UIImageView alloc]initWithFrame:CGRectMake(0, 43, 315, 2)];
			[imgSeprator setImage:[UIImage imageNamed:@"seperator.png"]];
			[imgSeprator setBackgroundColor:[UIColor clearColor]];
			[cell addSubview:imgSeprator];		
			
			UIImageView *imgOval=[[UIImageView alloc]initWithFrame:CGRectMake(260, 12, 42, 27)];
			[imgOval setImage:[UIImage imageNamed:@"oval_shape_black.png"]];
			[imgOval setBackgroundColor:[UIColor clearColor]];
			UILabel	*lblCount = [[UILabel alloc] initWithFrame:CGRectMake(266, 15, 30, 20)];
			lblCount.textColor = headingColor;
			lblCount.backgroundColor = [UIColor clearColor];
			lblCount.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
			lblCount.textAlignment=UITextAlignmentCenter;
			lblCount.tag = indexPath.row+5555;
			[cell addSubview:lblCount];
			[cell bringSubviewToFront:lblCount];
			[lblCount release];
			
		}
		
		UILabel *lblCountTemp = (UILabel *)[cell viewWithTag:indexPath.row+5555];
		isDepartmentsTable=YES;
		cell.textLabel.font=[UIFont boldSystemFontOfSize:15];		
		if([[showNoArray_Searched objectAtIndex:indexPath.row]intValue]==0)
		{
			if([[arrNumberofProducts_Search objectAtIndex:indexPath.row]intValue]>0)
			{
				cell.textLabel.text = [NSString stringWithFormat:@"%@", [showArray_Searched objectAtIndex:indexPath.row]];				
			}
			else
				cell.textLabel.text = [NSString stringWithFormat:@"%@", [showArray_Searched objectAtIndex:indexPath.row]];	
		}
		else
			cell.textLabel.text = [NSString stringWithFormat:@"%@", [showArray_Searched objectAtIndex:indexPath.row]];
		
		
		
		if([[showNoArray_Searched objectAtIndex:indexPath.row]intValue]==0)
		{
			if([[arrNumberofProducts_Search objectAtIndex:indexPath.row]intValue]>0)
			{
				lblCountTemp.text= [NSString stringWithFormat:@"%@",  [arrNumberofProducts_Search objectAtIndex:indexPath.row]];
			}
			else
			{
				lblCountTemp.text=[NSString stringWithFormat:@"%@", [showNoArray_Searched objectAtIndex:indexPath.row]];
			}
		}
		else
		{
			lblCountTemp.text=[NSString stringWithFormat:@"%@", [showNoArray_Searched objectAtIndex:indexPath.row]];
		}
		
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return  cell;
}

- (void) tableView:(UITableView*)tableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
		
    int indexWhileSearching = [showArray indexOfObject:[showArray_Searched objectAtIndex:indexPath.row]];
    selectedDepartment=[showArray_Searched objectAtIndex:indexPath.row];		
    if([[showNoArray_Searched objectAtIndex:indexPath.row]  intValue]>0)
    {			
        [GlobalPrefrences setCurrentDepartmentId:[[arrDeptIDs objectAtIndex:indexWhileSearching] integerValue]];
        UILabel *lblDeptName=(UILabel*)[contentView viewWithTag:111];
        if(countStore>0)
            [GlobalPrefrences setDepartmentNamesStore:lblDeptName.text];
        [lblDeptName setText:[showArray_Searched objectAtIndex:indexPath.row]];
        if([arrDepartmentData count]>0)
            [GlobalPrefrences  setDepartmentsDataStore:[arrDepartmentData lastObject]];
        [self fetchSubDepartments];
        [btnBackToDepts setHidden:NO];
        countStore++;
        NSLog(@"%d",countStore);
        
    }
    else 
    {	
        
		objStoreView.isComingFromHomePage=YES;
		objStoreView.isProductWithoutSubCategory=NO;
		[GlobalPrefrences setCurrentCategoryId:[[arrDeptIDs objectAtIndex:indexWhileSearching] integerValue]];
		[objStoreView fetchDataFromServer];
		[objStoreView.popOverController dismissPopoverAnimated:YES];
    }
    
	
}




- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)dealloc {
    [super dealloc];
	
	arrSubDeptID=[[NSMutableArray alloc]init];
	arrSubDeptID_Search=[[NSMutableArray alloc]init];
	arrNumofProducts=[[NSMutableArray alloc]init];
	arrNumofProductsSearch=[[NSMutableArray alloc]init];
	[showArray release];
	[showNoArray release];
	[arrDeptIDs release];
	[showArray_Searched release];
	[showNoArray_Searched release];
	[arrDeptIDs_Searched release];
	[arrNumberofProducts release];
	[arrNumberofProducts_Search release];
	[arrSubDepts release];
	[arrSubDepartments release];
	[arrSubDepatermentsSearch release];
	if(tblDepts)
		[tblDepts release];
	if(tblSubDepts)
		[tblSubDepts release];
	if(contentView)
		[contentView release];
	
	
	
}


@end
