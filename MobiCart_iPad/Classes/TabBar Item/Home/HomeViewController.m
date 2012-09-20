//
//  HomeViewController.m
//  Mobicart
//
//  Created by Mobicart on 05/03/11.
//  Copyright Mobicart. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"

#define urlMainServer @"http://www.mobi-cart.com"
@class CustomImageView;
BOOL isSortShown;
BOOL isPromotionalItem;
BOOL isSecondTime;
int count=0;
@implementation HomeViewController
@synthesize arrAppRecordsAllEntries;
@synthesize imageDownloadsInProgress; 
@synthesize dictdataFeatures,arrTempImage;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		self.tabBarItem.image=[UIImage imageNamed:@"home_icon.png"];
        
        if (!arrSearch)
        {
            arrSearch=[[NSMutableArray alloc]init];
        }

	}
    return self;
}


/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */
-(void)updateImage
{
    NSLog(@"6");
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
	
    NSString* tempString;
  
	if (backgroundImg && !isUpdateControlsCalled)
	{
        arrTempImage = [dictBanners objectForKey:@"gallery-images"];
        
        if([arrTempImage count]>0)
        {
            
				tempString=[[arrTempImage objectAtIndex:0 ] objectForKey:@"galleryImageIpad"];
            
            
            NSData *dataBannerImages = [ServerAPI fetchBannerImage:tempString];
            if(!dataBannerImages)
                dataBannerImages = [ServerAPI fetchBannerImage:tempString];
            
            [arrBanners addObject:dataBannerImages] ;
            [arrBanners retain];
            UIImage *imgprod = [UIImage imageWithData:[arrBanners objectAtIndex:0]];
            int y2= (325 - imgprod.size.height)/2;
            int x2 = (430 - imgprod.size.width)/2;
            
            [backgroundImg setFrame:CGRectMake(x2+43, y2+22, imgprod.size.width, imgprod.size.height)]; 
            
                    
            [backgroundImg setImage:[UIImage imageWithData:[arrBanners objectAtIndex:0]]];
            [backgroundImg setContentMode:UIViewContentModeScaleAspectFit];
            [ZoomScrollView addSubview:backgroundImg];  
        }
    }
    [arrTempImage retain];
    [pool release];
    
}


#pragma mark -
-(void)updateControls
{ 
	int i;
  
	if(backgroundImg && !isUpdateControlsCalled)
	{
		NSArray *arrTemp = [dictBanners objectForKey:@"gallery-images"];
		for(i=0;i<[arrTemp count];i++)
		{
			NSDictionary *dictTemp=[arrTemp objectAtIndex:i];
			NSString *string=[dictTemp objectForKey:@"galleryImageIpad"];
			
			NSData *dataBannerImage = [ServerAPI fetchBannerImage:string];
			
			if(dataBannerImage)
				[arrBanners addObject:dataBannerImage];
			else 
			{
				NSData *dataBannerTemp= [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noImage_l" ofType:@"png"]];
				[arrBanners addObject:dataBannerTemp];
			}
			
		}
		if([arrBanners count]>0)
		{
			if([arrBanners objectAtIndex:0])
			{
				UIImage *imgprod = [UIImage imageWithData:[arrBanners objectAtIndex:0]];
				int	y1= (325 - imgprod.size.height)/2;
				int x1 = (430 - imgprod.size.width)/2;
				
				[backgroundImg setFrame:CGRectMake(x1+43, y1+22, imgprod.size.width, imgprod.size.height)];	
				
				[backgroundImg setImage:[UIImage imageWithData:[arrBanners objectAtIndex:0]]];
	
			}
			
		}
	}	
	
	
	if((isUpdateControlsCalled) && (![arrBanners count]>0))
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		CATransition *animation = [CATransition animation]; 
		[animation setDelegate:self]; 
		[animation setType: kCATransitionMoveIn];
		[animation setSubtype:kCATransitionFromTop]; 
		[animation setDuration:2.0f]; 
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[UIView beginAnimations:nil context:context];
		[[backgroundImg layer] addAnimation:animation forKey:kCATransition];
		
		UILabel *lblErrorMsg =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, backgroundImg.bounds.size.height)];
		lblErrorMsg.textColor=[UIColor lightTextColor];
		[lblErrorMsg setNumberOfLines:0];
		[lblErrorMsg setFont:[UIFont boldSystemFontOfSize:15]];
		[lblErrorMsg setTextAlignment:UITextAlignmentCenter];
		[lblErrorMsg setLineBreakMode:UILineBreakModeWordWrap];
		[lblErrorMsg setBackgroundColor:[UIColor clearColor]];
		[lblErrorMsg setText:@"No Banner Product Available"];
		[backgroundImg addSubview:lblErrorMsg];
		[UIView commitAnimations]; 
		
		
	}
	
	isUpdateControlsCalled = TRUE;
}

-(void)allocateMemoryToObjects
{
	if(!arrAllData)
		arrAllData = [[NSArray alloc] init];
	if(!dictFeaturedProducts)
		dictFeaturedProducts=[[NSDictionary alloc]init];
	if(!dictBanners)
		dictBanners=[[NSDictionary alloc]init];
	if(!arrBanners)
		arrBanners = [[NSMutableArray alloc] init];
	
	arrSubDepts=[[NSArray alloc]init];
    arrDepartmentData=[[NSMutableArray alloc] init];
	arrSubDepartments=[[NSMutableArray alloc]init];
	arrSubDepatermentsSearch=[[NSMutableArray alloc]init];
	arrSubCategoryCount=[[NSMutableArray alloc]init];
	
	arrSubDeptID=[[NSMutableArray alloc]init];
	arrSubDeptID_Search=[[NSMutableArray alloc]init];
	arrNumofProducts=[[NSMutableArray alloc]init];
	arrNumofProductsSearch=[[NSMutableArray alloc]init];

	
	
	
	
	
	self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
	
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
    if(!arrSubCategoryCount)
		arrSubCategoryCount=[[NSMutableArray alloc]init];
    if(!arrDepartmentData)
		arrDepartmentData=[[NSMutableArray alloc]init];

        
	
}


#pragma mark viewDidLoad
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[GlobalPrefrences setCurrentNavigationController:self.navigationController];
	[self.navigationController.navigationBar setHidden:YES];
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isDataInShoppingCartQueue"] == TRUE)
	{
        // Fetch Shopping Cart Queue from local DB,  (and send it to the server, If internet is available now)
		NSInvocationOperation *operationFetchShoppingCartQueue= [[NSInvocationOperation alloc]  initWithTarget:self selector:@selector(fetchQueue_ShoppingCart) object:nil];
		
		[GlobalPrefrences addToOpertaionQueue:operationFetchShoppingCartQueue];
		[operationFetchShoppingCartQueue release];
	}

    [self performSelector:@selector(allocateMemoryToObjects) withObject:nil];
	selectedDepartment=[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.store.tab.all"];
	[GlobalPrefrences addLoadingBar_AtBottom: self.tabBarController.view withTextToDisplay:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
	
	NSInvocationOperation *operationFetchSettings = [[NSInvocationOperation alloc] initWithTarget:self
																						 selector:@selector(fetchSettingsFromServer) 
																						   object:nil];
	
	[operationFetchSettings setQueuePriority:NSOperationQueuePriorityVeryHigh];
	
	[GlobalPrefrences addToOpertaionQueue:operationFetchSettings];
	
	
	
	NSInvocationOperation *operationFetchMainData = [[NSInvocationOperation alloc] initWithTarget:self
																						 selector:@selector(fetchDataFromServer) 
																						   object:nil];
	
	[GlobalPrefrences addToOpertaionQueue:operationFetchMainData];
	[operationFetchMainData release];
	
	NSInvocationOperation *operationFetchDepartments = [[NSInvocationOperation alloc] initWithTarget:self
																							selector:@selector(fetchDataForDepartments) 
																							  object:nil];
	
	[GlobalPrefrences addToOpertaionQueue:operationFetchDepartments];
	[operationFetchDepartments release];
    [self performSelector:@selector(createBasicControls) withObject:nil];
	[super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	if([GlobalPrefrences getPersonLoginStatus])
	{
		[NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
		[self fetchFeaturedProducts];
		[NSTimer scheduledTimerWithTimeInterval:0.1
										 target:self
									   selector:@selector(hideLoadingView)
									   userInfo:nil
										repeats:NO];
	}
	
}
-(void)hideLoadingView
{
	[GlobalPrefrences dismissLoadingBar_AtBottom];	
}
#pragma mark createBasicControls
-(void)createBasicControls
{
	contentView = [[UIView	alloc]initWithFrame:CGRectMake( 0, 0, 1024, 768)];
	[contentView setBackgroundColor:[UIColor colorWithRed:78.4/100 green:89.0/100 blue:87.8 alpha:1]];
	[GlobalPrefrences setBackgroundTheme_OnView:contentView];

	self.view = contentView;
	
	ZoomScrollView = [[EbookScrollView alloc]initWithFrame:CGRectMake(43, 22,  430, 325)];
	ZoomScrollView.contentSize = CGSizeMake(430, 325);
	[ZoomScrollView setBackgroundColor:[UIColor clearColor]];
	ZoomScrollView.showsHorizontalScrollIndicator = YES;
	ZoomScrollView.showsVerticalScrollIndicator = YES;
	ZoomScrollView.maximumZoomScale=1.0;
	ZoomScrollView.minimumZoomScale=1.0;
	ZoomScrollView.clipsToBounds=YES;
	ZoomScrollView.delegate=self;
	ZoomScrollView.scrollEnabled=NO;
	ZoomScrollView.pagingEnabled=YES;
	[ZoomScrollView setUserInteractionEnabled:YES];
	[contentView addSubview:ZoomScrollView];	
		
	
	backgroundImg=[[UIImageView alloc]initWithFrame:CGRectMake(43, 22, 430, 325)];
	[contentView addSubview:backgroundImg];
	
	
	int x =  472 -(_savedPreferences.imgLogo.size.width+2);
	int y =  345 -(_savedPreferences.imgLogo.size.height+2);
	UIImageView *imgViewLogo=[[UIImageView alloc]initWithFrame:CGRectMake(x, y, _savedPreferences.imgLogo.size.width, _savedPreferences.imgLogo.size.height)];
	[imgViewLogo setImage:_savedPreferences.imgLogo];
	[imgViewLogo setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:imgViewLogo];
	[contentView bringSubviewToFront:imgViewLogo];
	
	bottomHorizontalView=[[UIScrollView alloc]initWithFrame:CGRectMake(34.5, 347, 440, 330)];
	bottomHorizontalView.backgroundColor=[UIColor clearColor];
	[bottomHorizontalView setContentSize:CGSizeMake(440, 70)];
	[bottomHorizontalView setShowsHorizontalScrollIndicator:NO];
	[contentView addSubview:bottomHorizontalView];
	
	btnCart = [[UIButton alloc]init];
	btnCart.frame = CGRectMake(907, 18, 78,34);
	[btnCart setBackgroundColor:[UIColor clearColor]];
	[btnCart setImage:[UIImage imageNamed:@"add_cart.png"] forState:UIControlStateNormal];
	[btnCart addTarget:self action:@selector(btnShoppingCart_Clicked:) forControlEvents:UIControlEventTouchUpInside];
	[contentView addSubview:btnCart];
	
	lblCart = [[UILabel alloc] initWithFrame:CGRectMake(42, 2, 30, 30)];
	lblCart.backgroundColor = [UIColor clearColor];
	lblCart.textAlignment = UITextAlignmentCenter;
	lblCart.font = [UIFont boldSystemFontOfSize:16];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	lblCart.textColor = [UIColor whiteColor];	 
	[btnCart addSubview:lblCart];
	
	
	UILabel *lblDepartments=[[UILabel alloc]initWithFrame:CGRectMake(547, 82, 350, 40)];
	[lblDepartments setBackgroundColor:[UIColor clearColor]];
	[lblDepartments setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.home.departments"]];
	[lblDepartments setTag:111];
	lblDepartments.textColor=headingColor;
	[lblDepartments setFont:[UIFont boldSystemFontOfSize:35]];
	[contentView addSubview:lblDepartments];
	[lblDepartments release];
	
	UIImageView *imgWhiteLine=[[UIImageView alloc]initWithFrame:CGRectMake(550, 57, 431, 2)];
	[imgWhiteLine setImage:[UIImage imageNamed:@"dot_line.png"]];
	[contentView addSubview:imgWhiteLine];
	[imgWhiteLine release];
	
	_searchBar = [[UISearchBar alloc]init];
	[_searchBar setFrame:CGRectMake( 540, 23, 296, 26)];
	[_searchBar setDelegate:self];
	[_searchBar setBackgroundColor:[UIColor clearColor]];
	NSString *str = [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.common.search"];
	[_searchBar setPlaceholder:str];
	[_searchBar setTranslucent:YES];
	[[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
	[_searchBar setTintColor:_searchBar.backgroundColor];
	[_searchBar setTranslucent:YES];
	[contentView addSubview:_searchBar];	
   
    [self performSelectorOnMainThread:@selector(showDepartments) withObject:self waitUntilDone:YES];

}
-(void)showDepartments
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
    btnBackToDepts=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnBackToDepts setTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.home.back"] forState:UIControlStateNormal];
	[btnBackToDepts setFrame:CGRectMake(920, 90, 70, 30)];
	[btnBackToDepts setHidden:YES];
	[btnBackToDepts setTitleColor:subHeadingColor forState:UIControlStateNormal];
	[btnBackToDepts setBackgroundImage:[UIImage imageNamed:@"edit_cart_btn.png"] forState:UIControlStateNormal];
	btnBackToDepts.backgroundColor = [UIColor clearColor];
    
    [btnBackToDepts addTarget:self action:@selector(showListOfDepts) forControlEvents:UIControlEventTouchUpInside];
	[contentView addSubview:btnBackToDepts];
    [pool release];
    
}
-(void)showLoading
{
	[GlobalPrefrences addLoadingBar_AtBottom:self.tabBarController.view withTextToDisplay:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
}
-(void)btnShoppingCart_Clicked:(id)sender
{
	[_searchBar resignFirstResponder];
	_searchBar.showsCancelButton = NO;
	if(iNumOfItemsInShoppingCart > 0)
	[NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
	isShoppingCart_TableStyle =YES;
	ShoppingCartViewController *objShopping = [[ShoppingCartViewController alloc] init];
	[[self navigationController]pushViewController:objShopping animated:YES];
	[objShopping release];
	
}

-(void)showListOfDepts
{
    count--;
    NSLog(@"%d",count);
    [arrDepartmentData removeAllObjects];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSArray *arrTemp=[GlobalPrefrences getDepartmentsDataHomes]; 
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
    if(count==0)
    {
        [lblDeptName setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.home.departments"]];
        [btnBackToDepts setHidden:YES];
    }
    else
    [lblDeptName setText:[GlobalPrefrences getLastDepartmentNameHomes]];
    
	[tblDepts reloadData];

	[pool release];

    
}
/** Multithreaded Selectors to fetch data from server **/
#pragma mark fetch data
-(void)fetchDataFromServer
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [NSThread detachNewThreadSelector:@selector(fetchBannerImages) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(fetchFeaturedProducts) toTarget:self withObject:nil];
	[pool release];
	
}
-(void)fetchSettingsFromServer
{	
	//  Set the user settings into the global preferences (like tax type, tax charges for user's country etc)
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary *dicTemp;
	dicTemp=[ServerAPI fetchSettings:iCurrentStoreId];
    [dicTemp retain];
    [GlobalPrefrences setSettingsOfUserAndOtherDetails:dicTemp];
	[pool release];	
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
	//fetch data from server
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
	
	[NSThread detachNewThreadSelector:@selector(createTableView) toTarget:self withObject:nil];
	
    [pool release];
}

#pragma mark createTableView
-(void)createTableView
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
	@try {
		
		if(tblDepts)
		{
			[tblDepts removeFromSuperview];
			[tblDepts release];
			tblDepts = nil;
			
		}
		
		tblDepts=[[UITableView alloc]initWithFrame:CGRectMake(540, 120, 445, 550) style:UITableViewStylePlain];
		tblDepts.delegate=self;
		tblDepts.dataSource=self;
		tblDepts.showsVerticalScrollIndicator = FALSE;
		[tblDepts setBackgroundColor:[UIColor clearColor]];
		[tblDepts setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		[tblDepts setSeparatorColor:[UIColor blackColor]];
		[contentView addSubview:tblDepts];
		
	}
	@catch (NSException * e) {
		NSLog(@"Exception Occured");
	}
    [GlobalPrefrences performSelector:@selector(dismissLoadingBar_AtBottom)];
    [pool release];
	
}


-(void)fetchBannerImages
{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	dictBanners=[ServerAPI fetchGallaryImages:iCurrentStoreId];
    [dictBanners retain];
    [self performSelector:@selector(updateControls)];   
 	[pool release];

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


- (UITableViewCell*) tableView:(UITableView*) tableview cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
	NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableIdentifier%d", indexPath.row];
	TableViewCell_Common *cell= (TableViewCell_Common *)[tableview dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	
		if(cell==nil)
		{
			cell = [[[TableViewCell_Common alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: SimpleTableIdentifier]autorelease];
			
			cell.backgroundColor=[UIColor clearColor];		
			cell.textLabel.textColor=subHeadingColor;
			cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
			UIImageView *imgSeprator=[[UIImageView alloc]initWithFrame:CGRectMake(10, 53, 430, 3)];
			[imgSeprator setImage:[UIImage imageNamed:@"seperator.png"]];
			[imgSeprator setBackgroundColor:[UIColor clearColor]];
			[cell addSubview:imgSeprator];		
			cell.detailTextLabel.textColor=subHeadingColor;
			
			UIImageView *imgOval=[[UIImageView alloc]initWithFrame:CGRectMake(345, 12, 45, 28)];
			[imgOval setImage:[UIImage imageNamed:@"number_oval.png"]];
			[imgOval setBackgroundColor:[UIColor clearColor]];				
            
            UILabel	*lblText = [[UILabel alloc] initWithFrame:CGRectMake(10, 16,300, 20)];
			lblText.textColor = subHeadingColor;
			lblText.backgroundColor = [UIColor clearColor];
			lblText.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
            lblText.tag = indexPath.row+6666;
			[cell addSubview:lblText];
			[cell bringSubviewToFront:lblText];
			[lblText release];

			
			UILabel	*lblCount = [[UILabel alloc] initWithFrame:CGRectMake(349, 16, 39, 20)];
			lblCount.textColor = headingColor;
			lblCount.backgroundColor = [UIColor clearColor];
			lblCount.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
			lblCount.textAlignment=UITextAlignmentCenter;
			lblCount.tag = indexPath.row+5555;
			[cell addSubview:lblCount];
			[cell bringSubviewToFront:lblCount];
			[lblCount release];
			
			
			UIImageView *imgArrow=[[UIImageView alloc]initWithFrame:CGRectMake(415, 19, 9, 13)];
			[imgArrow setImage:[UIImage imageNamed:@"arrow_left.png"]];
			[imgArrow setBackgroundColor:[UIColor clearColor]];
			[cell addSubview:imgArrow];
			[imgArrow release];
		}
		
		UILabel *lblCountTemp = (UILabel *)[cell viewWithTag:indexPath.row+5555];
        UILabel *lblText = (UILabel *)[cell viewWithTag:indexPath.row+6666];

		if([[showNoArray_Searched objectAtIndex:indexPath.row]intValue]==0)
		{
			if([[arrNumberofProducts_Search objectAtIndex:indexPath.row]intValue]>0)
			{
				lblText.text = [NSString stringWithFormat:@"%@", [showArray_Searched objectAtIndex:indexPath.row]];				
			}
			else
				lblText.text = [NSString stringWithFormat:@"%@", [showArray_Searched objectAtIndex:indexPath.row]];	
		}
		else
			lblText.text = [NSString stringWithFormat:@"%@", [showArray_Searched objectAtIndex:indexPath.row]];
		
		
		
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
	[_searchBar resignFirstResponder];
	_searchBar.showsCancelButton = NO;		
      int indexWhileSearching = [showArray indexOfObject:[showArray_Searched objectAtIndex:indexPath.row]];
		selectedDepartment=[showArray_Searched objectAtIndex:indexPath.row];		
		if([[showNoArray_Searched objectAtIndex:indexPath.row]  intValue]>0)
		{			
            [GlobalPrefrences setCurrentDepartmentId:[[arrDeptIDs objectAtIndex:indexWhileSearching] integerValue]];
			UILabel *lblDeptName=(UILabel*)[contentView viewWithTag:111];
            if(count>0)
            [GlobalPrefrences setDepartmentNamesHomes:lblDeptName.text];
			[lblDeptName setText:[showArray_Searched objectAtIndex:indexPath.row]];
            if([arrDepartmentData count]>0)
             [GlobalPrefrences  setDepartmentsDataHomes:[arrDepartmentData lastObject]];
			[self fetchSubDepartments];
            [btnBackToDepts setHidden:NO];
             count++;
            NSLog(@"%d",count);

		}
		else 
		{	
			
			[GlobalPrefrences setCurrentCategoryId:[[arrDeptIDs objectAtIndex:indexWhileSearching] integerValue] ];
			StoreViewController *objStore=[[ StoreViewController alloc]init];
			objStore.isComingFromHomePage=YES;
			[[self navigationController]pushViewController:objStore animated:YES];
			[objStore release];
		}
		
	
}

#pragma mark featured products
-(void)fetchFeaturedProducts
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
	NSArray *arrStateAndCountryID= [[TaxCalculation shared]getStateAndCountryIDForTax];

	int stateID=[[arrStateAndCountryID objectAtIndex:0] intValue];
	int countryID=[[arrStateAndCountryID objectAtIndex:1] intValue];
	
	dictFeaturedProducts=[ServerAPI fetchFeaturedproducts:countryID :stateID:iCurrentAppId];
	[self performSelectorOnMainThread:@selector(createDynamicControls) withObject:nil waitUntilDone:YES];
	
	[pool release];
	
	if(!dictFeaturedProducts)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		CATransition *animation = [CATransition animation]; 
		[animation setDelegate:self]; 
		[animation setType: kCATransitionPush];
		[animation setSubtype:kCATransitionFromLeft]; 
		[animation setDuration:1.0f]; 
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[UIView beginAnimations:nil context:context];
		[[bottomHorizontalView layer] addAnimation:animation forKey:kCATransition];
		
		
		UILabel *lblErrorMsg =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 95)];
		lblErrorMsg.textColor=[UIColor lightTextColor];
		[lblErrorMsg setNumberOfLines:0];
		[lblErrorMsg setFont:[UIFont boldSystemFontOfSize:15]];
		[lblErrorMsg setTextAlignment:UITextAlignmentCenter];
		[lblErrorMsg setLineBreakMode:UILineBreakModeWordWrap];
		[lblErrorMsg setBackgroundColor:[UIColor clearColor]];
		[lblErrorMsg setText:@"No Featured Product Available"];
		[bottomHorizontalView addSubview:lblErrorMsg];
		[lblErrorMsg release];		
		[UIView commitAnimations]; 
		
	}	
	[pool release];
}	
#pragma mark - Image Thumbnail selected


-(void)fectNextFeaturedProductDetails:(NSNumber*)_num
{

	int promotionalId;
	promotionalId=[_num intValue];
	NSString* nextProductID;
	NSDictionary *dictTempNextProduct ;
    
	if([arrAllData count]>promotionalId)
	{
	  dictTempNextProduct	= [arrAllData objectAtIndex:promotionalId];
    nextProductID=[dictTempNextProduct valueForKey:@"id"];
    		
		NSArray *arrStateAndCountryID=[[TaxCalculation shared]getStateAndCountryIDForTax];
		NSDictionary *dictDataForNextProduct;
	if(![[dictTempNextProduct objectForKey:@"categoryId"]isKindOfClass:[NSNull class]])
	{
        if([[dictTempNextProduct objectForKey:@"categoryId"] intValue]>0)
			dictDataForNextProduct = [ServerAPI fetchnextfeatureProductwithcategory:[[dictTempNextProduct objectForKey:@"departmentId"] intValue] catId:[[dictTempNextProduct objectForKey:@"categoryId"] intValue] countryId:[[arrStateAndCountryID objectAtIndex:1]intValue] stateId:[[arrStateAndCountryID objectAtIndex:0]intValue]:iCurrentStoreId];
        else 
        {
      		dictDataForNextProduct = [ServerAPI fetchnextfeatureProduct:[[dictTempNextProduct objectForKey:@"departmentId"] intValue] countryId:[[arrStateAndCountryID objectAtIndex:1]intValue] stateId:[[arrStateAndCountryID objectAtIndex:0]intValue]:iCurrentStoreId];

		}
	}
	else
	{
		dictDataForNextProduct = [ServerAPI fetchnextfeatureProduct:[[dictTempNextProduct objectForKey:@"departmentId"] intValue] countryId:[[arrStateAndCountryID objectAtIndex:1]intValue] stateId:[[arrStateAndCountryID objectAtIndex:0]intValue]:iCurrentStoreId];
	}
		
	NSArray *arrProducts=[dictDataForNextProduct objectForKey:@"products"];
	int productIndex=0;
	if([[arrProducts valueForKey:@"id"] containsObject:nextProductID])
		productIndex=[[arrProducts valueForKey:@"id"]indexOfObject:nextProductID];
	
	//Set the bool value YES, to pop a controller to rool view controller, (In case, when featured product has been clicked, and when clicked on STORE tab, all elements can be popped out)
	
	[GlobalPrefrences setNextProductDetails:[[dictDataForNextProduct objectForKey:@"products"] objectAtIndex:productIndex]];
	
	
	
	
	NSInteger iNextDeptID = [[[[dictDataForNextProduct objectForKey:@"products"] objectAtIndex:0] objectForKey:@"departmentId"] intValue];
	
	[GlobalPrefrences setCurrentDepartmentId:iNextDeptID];
	}
	else {
		[GlobalPrefrences setCurrentDepartmentId:0];
		[GlobalPrefrences setNextProductDetails:nil];
	}

}
 
-(void)imageDetails:(UIButton *)sender
{	
	
	[_searchBar resignFirstResponder];
	_searchBar.showsCancelButton = NO;
	[NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
	isPromotionalItem=YES;
	int stateID=0,countryID=0;
	int promotionalId = [sender tag];
	
	NSArray *arrStateAndCountryID=[[TaxCalculation shared]getStateAndCountryIDForTax];
	countryID=[[arrStateAndCountryID objectAtIndex:1] intValue];
	stateID=[[arrStateAndCountryID objectAtIndex:0] intValue];
		
	NSString* productID;
	NSDictionary *dictTemp = [arrAllData objectAtIndex:promotionalId-1];
    productID=[dictTemp valueForKey:@"id"];
	 NSDictionary *dictDataForCurrentProduct;
	if (![[dictTemp objectForKey:@"categoryId"]isKindOfClass:[NSNull class]])
	{
        if ([[dictTemp objectForKey:@"categoryId"] intValue]>0)
        {
			dictDataForCurrentProduct = [ServerAPI fetchnextfeatureProductwithcategory:[[dictTemp objectForKey:@"departmentId"] intValue] catId:[[dictTemp objectForKey:@"categoryId"] intValue] countryId:countryID stateId:stateID:iCurrentStoreId];
        }
        else 
        {
			dictDataForCurrentProduct =  [ServerAPI fetchnextfeatureProduct:[[dictTemp objectForKey:@"departmentId"] intValue] countryId:countryID stateId:stateID:iCurrentStoreId];	
        }
	}
	else
	{
		dictDataForCurrentProduct =  [ServerAPI fetchnextfeatureProduct:[[dictTemp objectForKey:@"departmentId"] intValue] countryId:countryID stateId:stateID:iCurrentStoreId];	
	}
    
	
	
	[self fectNextFeaturedProductDetails:[NSNumber numberWithInt:promotionalId]];
	
	//Setting the bool variable, so the app can directly jump to the selected product detail
	[GlobalPrefrences setIsClickedOnFeaturedImage:YES];
	
	
	NSArray *arrProducts=[dictDataForCurrentProduct objectForKey:@"products"];
	int productIndex=0;
	if([[arrProducts valueForKey:@"id"] containsObject:productID])
		productIndex=[[arrProducts valueForKey:@"id"]indexOfObject:productID];
	
	//Set the bool value YES, to pop a controller to rool view controller, (In case, when featured product has been clicked, and when clicked on STORE tab, all elements can be popped out)
	
	[GlobalPrefrences setCurrentFeaturedProductDetails:[[dictDataForCurrentProduct objectForKey:@"products"] objectAtIndex:productIndex]];
	
	
	NSInteger iCurrentDeptID = [[[[dictDataForCurrentProduct objectForKey:@"products"] objectAtIndex:0] objectForKey:@"departmentId"] intValue];
	
	[GlobalPrefrences setCurrentDepartmentId:iCurrentDeptID];
	
	[GlobalPrefrences setCanPopToRootViewController: YES];
	self.tabBarController.selectedIndex = 4;
	
}

#pragma mark create Featured Products
-(void)createDynamicControls
{
	
	if(dictFeaturedProducts)
	{
		if(!self.arrAppRecordsAllEntries)
			self.arrAppRecordsAllEntries = [[NSMutableArray alloc] init];
		
		arrAllData=[dictFeaturedProducts objectForKey:@"featured-products"];
		[arrAllData retain];
		BOOL isSecondLine = NO;
		
		if((![arrAllData isEqual:[NSNull null]]) && (arrAllData !=nil))
		{
            
            
            int newFeturedCount;
            newFeturedCount=[arrAllData count];
			
            
            if(newFeturedCount>7)
            {
                newFeturedCount=7;
            }
            int x=3,y=8.5;
			
			for (int i=0; i<newFeturedCount; i++)
			{			
					
				int count;
			    	count=newFeturedCount/2;
				if(count < 3)
					count = count + 1;
				if(i>=count && isSecondLine==NO)
				{
					y=168;
					x=3;
					isSecondLine=YES;
				}
				
				btnBlue[i]=[UIButton buttonWithType:UIButtonTypeCustom];
				btnBlue[i].frame=CGRectMake(x+6, y+7, 115.2, 115);
				[[btnBlue[i] layer] setCornerRadius:6];
				btnBlue[i].backgroundColor = [UIColor whiteColor];
				[btnBlue[i] setTag:i+1];
				btnBlue[i].showsTouchWhenHighlighted = TRUE;
				[btnBlue[i] addTarget:self action:@selector(imageDetails:) forControlEvents:UIControlEventTouchUpInside];
				NSDictionary *dictTemp = [arrAllData objectAtIndex:i];
				NSString *strImageUrl;
				NSData *dataBannerImage;
				
				
				if([[dictTemp objectForKey:@"productImages"] count] >0)
				{
					strImageUrl=[[[dictTemp objectForKey:@"productImages"] objectAtIndex:0] objectForKey:@"productImageMediumIpad"];
                    
                   img[i] = [[CustomImageView alloc] initWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlMainServer,strImageUrl]] frame:CGRectMake(0, 0, 115, 115)];
                   [img[i] setClipsToBounds:YES];
                   
                    
			       dataBannerImage = [ServerAPI fetchBannerImage:strImageUrl];
                    UIImage *imgprod = [UIImage imageWithData:dataBannerImage];
                    int	y1= (115 - imgprod.size.height)/2;
                    int x1 = (115 - imgprod.size.width)/2;
                    
                    [img[i] setFrame:CGRectMake(x1, y1, imgprod.size.width, imgprod.size.height)];
                    [btnBlue[i] addSubview:img[i]];
				
				}
				
				else 
				{
					dataBannerImage = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noImage_S_New" ofType:@"png"]];
					
				}
				if(!dataBannerImage)
				{
					dataBannerImage = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noImage_S_New" ofType:@"png"]];
				}
			
				[bottomHorizontalView addSubview:btnBlue[i]];
				
				if(!lblPrice[i])
				lblPrice[i]=[[UILabel alloc]initWithFrame:CGRectMake(x+9, y+141, 120, 17)];
				lblPrice[i].backgroundColor=[UIColor clearColor];
				[lblPrice[i] setTextAlignment:UITextAlignmentCenter];
				[lblPrice[i] setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.5]];

				if([_savedPreferences.strCurrencySymbol isEqualToString:@"<null>"]|| _savedPreferences.strCurrencySymbol==nil)
					_savedPreferences.strCurrencySymbol=@"";
			    [lblPrice[i] setText:[[TaxCalculation shared]caluateTaxForProduct:dictTemp]];
				[lblPrice[i] setTextAlignment:UITextAlignmentLeft];
				[lblPrice[i] setTextColor:labelColor];
				[bottomHorizontalView addSubview:lblPrice[i]];
				
				if(!lblProductName[i])
				lblProductName[i]=[[UILabel alloc]initWithFrame:CGRectMake(x+9, y+126, 120, 17)];
				[lblProductName[i] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];

				lblProductName[i].backgroundColor=[UIColor clearColor];
				[lblProductName[i] setTextAlignment:UITextAlignmentLeft];
				[lblProductName[i] setText:[[arrAllData objectAtIndex:i]valueForKey:@"sName"]];
				[lblProductName[i] setTextColor:subHeadingColor];
				[bottomHorizontalView addSubview:lblProductName[i]];
				x+=157;
			}
			
			[bottomHorizontalView setContentSize:CGSizeMake(x, 70)];
						 			
			//calling this method again to update aal the images recenlty fetct, if in case, this method has called already
			if(isUpdateControlsCalled)
                [NSThread detachNewThreadSelector:@selector(updateControls) toTarget:self withObject:nil];
				
		}
		else
			NSLog(@"No Featured Products available (Home View Controller");
		
	}
	else
		NSLog(@"No Featured Products available (Home View Controller");
	
	
	
}

#pragma mark scrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return backgroundImg;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale // scale between minimum and maximum. called after any 'bounce' animations
{
	if(scale == 1.0)
		[ZoomScrollView setScrollEnabled:NO];
}



#pragma mark UISearchBarDelegate delegate methods


#pragma mark Search Bar Delegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {  
    searchBar.showsCancelButton = YES;  
	return YES;
}  

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {  
    searchBar.showsCancelButton = NO;  
	return YES;
}  



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{	
	[_searchBar resignFirstResponder];
}



- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// only show the status bar’s cancel button while in edit mode
	searchBar.showsCancelButton = YES;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	
	// flush the previous search content
	
	
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
		
		if([searchText isEqualToString:@""] || searchText==nil)
		{
			[showArray_Searched addObjectsFromArray:showArray];
			[showNoArray_Searched addObjectsFromArray:showNoArray];
			[arrNumberofProducts_Search addObjectsFromArray:arrNumberofProducts];
			[self createTableView];
			return;
		}
		
		
		NSInteger counter = 0;
		for(NSString *name in showArray)
		{
			NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
			NSRange r = [[name uppercaseString] rangeOfString:[searchText uppercaseString]] ;
			if(r.location != NSNotFound)
			{
				if(r.location==0)//that is we are checking only the start of the names.
				{
					[showArray_Searched addObject:name];
					
					[showNoArray_Searched addObject:[showNoArray objectAtIndex:[showArray indexOfObject:name]]];
					
					[arrNumberofProducts_Search addObject:[arrNumberofProducts objectAtIndex:[showArray indexOfObject:name]]];
					
				}
			}
			counter++;
			[pool release];
		}
		[self createTableView];
		
}



// called when keyboard search button pressed
// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
		[showArray_Searched removeAllObjects];
		[showNoArray_Searched removeAllObjects];
		[arrNumberofProducts_Search removeAllObjects];
		
		[showArray_Searched addObjectsFromArray:showArray];
		[showNoArray_Searched addObjectsFromArray:showNoArray];
		[arrNumberofProducts_Search addObjectsFromArray:arrNumberofProducts];
		@try
		{
			[tblDepts reloadData];
		}
		@catch(NSException *e)
		{
			
 		}
	searchBar.showsCancelButton = NO; 
	[searchBar resignFirstResponder];
	searchBar.text = @"";
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
	if(lblCart)
	[lblCart release];
	
    [super dealloc];
}
#pragma mark fetch Shopping Cart Queue 

// Fetch Shopping cart details. These are saved in case Internet is unavailable, once payment has been made succesfully, but before placing/sending the order to the server
- (void)fetchQueue_ShoppingCart
{
	NSArray *arrShoppingCart_Queue = [[SqlQuery shared] getShoppingCartQueue];
	if ((arrShoppingCart_Queue) && ([GlobalPrefrences isInternetAvailable]))
	{
		if ([arrShoppingCart_Queue count]>0)
		{	
			// Send data to the server, If internet is available now)
			NSInvocationOperation *operationSendDataToServer= [[NSInvocationOperation alloc]  initWithTarget:self selector:@selector(sendDataToServer:) object:[arrShoppingCart_Queue objectAtIndex:0]];
			
			[GlobalPrefrences addToOpertaionQueue:operationSendDataToServer];
			[operationSendDataToServer release];
		}
	}
}

#pragma mark Send Data To Server

// The data for placing/sending the order to Server, if Internet was Unavailable 
- (void)sendDataToServer:(NSDictionary *)dictShoppingCartQueueData
{	
    NSString *strDataToPost = [dictShoppingCartQueueData objectForKey:@"sDataToSend"];
	NSString *reponseRecieved = [ServerAPI SQLServerAPI:[dictShoppingCartQueueData objectForKey:@"sUrl"] :strDataToPost];
	
	// Now send data to the server for this recently made order 
	if ([reponseRecieved isKindOfClass:[NSString class]])
	{
		int iCurrentOrderId = [[[[[reponseRecieved componentsSeparatedByString:@":"] objectAtIndex:1] componentsSeparatedByString:@"}"] objectAtIndex:0] intValue];
		
		NSArray *arrIndividualProducts = [[SqlQuery shared] getIndividualProducts_Queue:0];
		for( int i =0; i<[arrIndividualProducts count];i++)
		{
			[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isDataInShoppingCartQueue"];
			
			NSString *dataToSave =[[arrIndividualProducts objectAtIndex:i] objectForKey:@"sDataToSend"];
			dataToSave =  [dataToSave stringByReplacingOccurrencesOfString:@"\"orderId\":0" withString:[NSString stringWithFormat:@"\"orderId\":%d",iCurrentOrderId]];
			
			if ([GlobalPrefrences isInternetAvailable])
			{
                NSString *response = [ServerAPI SQLServerAPI:[[arrIndividualProducts objectAtIndex:i] objectForKey:@"sUrl"] :dataToSave];
				
				// Delete sold item from the cart
				[[SqlQuery shared] deleteItemFromIndividualQueue:[[[arrIndividualProducts objectAtIndex:i] objectForKey:@"iProductId"] intValue]];
				
				if (([arrIndividualProducts count]-1)==i)
				{
					[[SqlQuery shared] deleteItemFromShoppingQueue:1];
					[[SqlQuery shared] emptyShoppingCart];
					lblCart.text=@"0";
					iNumOfItemsInShoppingCart = 0;
					[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isDataInIndividualProductsQueue"];
				}
			}
			
			if (iCurrentOrderId>0) 
			{
				[ServerAPI product_order_NotifyURLSend:@"Sending Order Number Last Time" :iCurrentOrderId];
			}
			else
			{
				NSLog(@"INTERNET IS UNAVAILABLE, KEEPING DATA IN THE LOCAL DATABASE");
				[[SqlQuery shared] updateIndividualProducts_Queue:iCurrentOrderId :[[[arrIndividualProducts objectAtIndex:i] objectForKey:@"iProductId"] intValue]];
				[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isDataInIndividualProductsQueue"];
			}
		}
	}
	
	else
    {
        NSLog(@"Error While sending billing details to server (CheckoutViewController)");
    }
}

@end
