//
//  StoreViewController.m
//  Mobicart
//
//  Created by Mobicart on 05/03/11.
//  Copyright Mobicart. All rights reserved.
//

#import "StoreViewController.h"

BOOL showSegmentCtrl;
@implementation StoreViewController
@synthesize selectedRow,arrAppRecordsAllEntries,isComingFromHomePage,isProductWithoutSubCategory,popOverController;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
@synthesize btnProductImage,firstPageIndex,imgNextPage,imgPrePage;
@synthesize isBack;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
   		self.tabBarItem.image=[UIImage imageNamed:@"store_icon.png"];
		
		
		
	}
    return self;
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

int myintcurrentpage; 
#pragma mark leaves
- (NSUInteger) numberOfPagesInLeavesView:(LeavesView*)leavesView1 {
	leavesView1=[[LeavesView alloc] init];
	
	float numOfPages2=[arrSearch count]/18.0;
	NSNumber *numOfPages3 = [NSNumber numberWithFloat:(numOfPages2+0.9)];
	int numOfPages1 = [numOfPages3 intValue];
	
	
	if(numOfPages1<=1)
		numOfPages1=1;
	else 
	{
		
		if(numOfPages1 % 2 == 0)
			numOfPages1 = numOfPages1;
		else 
			numOfPages1+=2;
	}
	
	float mycurInt =0;
	if(numOfPages1 % 2 == 0)
		mycurInt = numOfPages1;
	else 
		mycurInt = numOfPages1/2.0;
	
	
	NSNumber *myCurNumber = [NSNumber numberWithFloat:(mycurInt+0.5)];
	myintcurrentpage = [myCurNumber intValue];
	
	return numOfPages1;
	
}


- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	
    [GlobalPrefrences setCurrentNavigationController:self.navigationController];
	mainLayer = leavesView.basePage;
	mainLayer.frame=CGRectMake(0, 0, 1024, 768) ;
	[contentScrollView setNeedsDisplay];
	[mainLayer addSublayer: contentScrollView.layer];
}


#pragma mark sort Handlers
-(void)sortingHandlers
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
	if([arrAllData count]>0)
	{ 
		arrSearch=[NSMutableArray arrayWithArray:arrAllData];
		[arrSearch retain];
	}
	
}

-(void)sortSegementChanged:(id)sender
{
	@try 
	{
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
		[tableView release];
		tableView = nil;
		[self.arrAppRecordsAllEntries removeAllObjects];
		
		[leavesView reloadData];
		[self performSelectorOnMainThread:@selector(createBasicControls) withObject:nil waitUntilDone:YES];
	}
	
	
}

-(void)viewWillAppear:(BOOL)animated
{

    objStoreView=self;
    
    
    if (![GlobalPrefrences isInternetAvailable])
	{
		NSString* errorString = [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.text"];
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.title"] message:errorString delegate:self cancelButtonTitle:nil otherButtonTitles:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"], nil];
		[errorAlert show];
		[errorAlert release];	}
	else 
	{
		if(![GlobalPrefrences  isClickedOnFeaturedProductFromHomeTab])
		{
			[NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
		}
		showSegmentCtrl =NO;
		
		[self.navigationController.navigationBar setHidden:YES];
		MobicartAppDelegate*	_objMobicartAppDelegate = [[MobicartAppDelegate alloc] init];
		_objMobicartAppDelegate.tabController.delegate	=self;
		[GlobalPrefrences setCurrentNavigationController:self.navigationController];
		
		
		firstPageIndex=lastPageIndex=0;
		
		[self allocateMemoryToObjects];
		
		[NSThread detachNewThreadSelector:@selector(fetchDataFromServer) toTarget:self withObject:nil];
		contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
		[contentView setBackgroundColor:[UIColor colorWithRed:78.4/100 green:89.0/100 blue:87.8 alpha:1]];
		self.view = contentView;
		
		[GlobalPrefrences setBackgroundTheme_OnView:contentView];
		
		contentScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 65 , 1015, 660)];
		[contentScrollView setContentSize:CGSizeMake(1024, 768)];
		[contentScrollView setBackgroundColor:[UIColor clearColor]];
		[contentView addSubview:contentScrollView];
		[self createSubViewsAndControls];
		
	}

    
    
    
    self.navigationController.navigationBar.hidden = YES;
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	NSArray *toggleItems = [[NSArray alloc] initWithObjects:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.productlist.price"],[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.productlist.status"],[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.productlist.atoz"],nil];
	
	if(sortSegCtrl)
	{
		[sortSegCtrl removeFromSuperview];
		[sortSegCtrl release];
		sortSegCtrl = nil;
	}
	UILabel *lblSortBy;
	lblSortBy = [[UILabel alloc] initWithFrame:CGRectMake(17, 732, 70, 20)];
	[lblSortBy setText:[NSString stringWithFormat:@"%@:",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.productlist.sortby"]]];
	lblSortBy.tag = 2222;
	lblSortBy.backgroundColor = [UIColor clearColor];
	[lblSortBy setFont:[UIFont boldSystemFontOfSize:13]];
	lblSortBy.textColor = [UIColor lightGrayColor];
	[self.tabBarController.view addSubview:lblSortBy];
	[lblSortBy release];
	
	sortSegCtrl = [[SegmentControl_Customized alloc] initWithItems:toggleItems offColor:[UIColor grayColor] onColor:[UIColor blackColor]];
	if(!showSegmentCtrl)
	{
		showSegmentCtrl = YES;
		[sortSegCtrl setHidden:YES];
	}
	[sortSegCtrl addTarget:self action:@selector(sortSegementChanged:) forControlEvents:UIControlEventValueChanged];
	[sortSegCtrl setTag:1001];
	[sortSegCtrl setFrame:CGRectMake(107,726, 208, 31)];
	[self.tabBarController.view addSubview:sortSegCtrl];
	
	[toggleItems release];
	
	
	if([GlobalPrefrences getPersonLoginStatus])
	{
		[GlobalPrefrences setPersonLoginStatus:NO];
		[self fetchDataFromServer];
	}
	
	
	if([GlobalPrefrences isClickedOnFeaturedProductFromHomeTab])
	{
		[GlobalPrefrences setIsClickedOnFeaturedImage:NO];
		NSDictionary *dictTemp = [GlobalPrefrences getCurrentFeaturedDetails];
		[NSThread detachNewThreadSelector:@selector(sendDataForAnalytics:) toTarget:self withObject:[dictTemp objectForKey:@"id"]];
		NSDictionary *dicNextProduct=[GlobalPrefrences getNextFeaturedProductDetails];
		[lblSortBy removeFromSuperview];
		[sortSegCtrl removeFromSuperview];
		ProductDetails *objDetails=[[ProductDetails alloc]init];
		objDetails.dicProduct=nil;
		objDetails.dicNextProduct=nil;
		objDetails.dicProduct = dictTemp;
		objDetails.dicNextProduct = dicNextProduct;
		[[self navigationController]pushViewController:objDetails animated:YES];
		[objDetails release];
	}
}
#pragma mark - Product Analytics
-(void) sendDataForAnalytics:(NSString *)sProductId
{
	if((![sProductId isEqual:[NSNull null]]) || (![sProductId isEqualToString:@""]))
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		[ServerAPI fetchProductAnalytics:sProductId];
        [pool release];
	}
	
}

#pragma mark viewDidLoad
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
   	[super viewDidLoad];
}
-(void)hideLoadingView
{
	[GlobalPrefrences dismissLoadingBar_AtBottom];	
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

-(void)allocateMemoryToObjects
{
	arrAllData=[[NSArray alloc]init];
	//arrSearch=[[NSMutableArray alloc]init];
	
	if(!showArray)
		showArray=[[NSMutableArray alloc]init];
	if(!showNoArray)
		showNoArray=[[NSMutableArray alloc]init];
	if(!arrCategoryIDs)
		arrCategoryIDs = [[NSMutableArray alloc] init];
	if(!showArray_Searched)
		showArray_Searched=[[NSMutableArray alloc]init];
	if(!showNoArray_Searched)
		showNoArray_Searched=[[NSMutableArray alloc]init];
	if(! arrCategoryIDs_Searched)
	{
		arrCategoryIDs_Searched=[[NSMutableArray alloc]init];	
	}	
}
-(void)showLoading
{
	[GlobalPrefrences addLoadingBar_AtBottom:self.tabBarController.view withTextToDisplay:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
}
-(void)btnShoppingCart_Clicked:(id)sender
{
	[productSearchBar resignFirstResponder];
	productSearchBar.showsCancelButton = NO;
	if(iNumOfItemsInShoppingCart > 0)
	{
		[NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
	}
	isShoppingCart_TableStyle=YES;
	ShoppingCartViewController *objShopping = [[ShoppingCartViewController alloc] init];
	[[self navigationController]pushViewController:objShopping animated:YES];
	[objShopping release];
	
}
#pragma mark Lazy Loading of Images


-(void)loadStart:(int)intValue
{
	[NSThread detachNewThreadSelector:@selector(downloadStart:) toTarget:self withObject:[NSNumber numberWithInt:intValue]];
}



-(void)downloadStart:(NSNumber *)intValue
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	@try {
		int i =[intValue intValue]-100;
		NSLog(@"Tag is %d",i);
		NSDictionary *dictTemp=[arrSearch objectAtIndex:i];
		NSArray  *arrImagesUrls =[[NSArray alloc]init];
		arrImagesUrls=	[dictTemp objectForKey:@"productImages"];

		NSString *	additionalImagesLink =[[NSString alloc]init];
		if([arrImagesUrls count]>0)
		{
			additionalImagesLink =[[arrImagesUrls objectAtIndex:0] valueForKey:@"productImageMediumIpad"];
		
		}
		if(!additionalImagesLink || [additionalImagesLink isEqual:[NSNull null]])
		{
			[self performSelectorOnMainThread:@selector(finishDownload) withObject:nil waitUntilDone:NO];
		}
		else 
		{
			NSString *url = additionalImagesLink;
			UIImageView *additionalImage=[[UIImageView alloc]init];;
			if(url)
			{
				NSData *imgData = [ServerAPI fetchBannerImage:url];
				UIImage *img = [UIImage imageWithData:imgData];
				additionalImage = (UIImageView *)[contentScrollView viewWithTag:i+100];
				int x = additionalImage.frame.origin.x;
				int y = additionalImage.frame.origin.y;
				if(additionalImage)
				{
					if([additionalImage isKindOfClass:[UIImageView class]])
					{
						int	y1= (115-img.size.height)/2;
						int x1 = (115 - img.size.width)/2;
						
						
						if(![img isEqual:[NSNull null]])
						{
							[additionalImage setFrame:CGRectMake(x1+x, y1+y, img.size.width, img.size.height)];
							[additionalImage setImage:img];
							
						}
						
						if(img==nil)
						{
							[additionalImage setImage:[UIImage imageNamed:@"noImage_M.png"]];
						}
					}
				}
				
			}
			
		}
	}
	
	@catch (NSException * e) {
		NSLog(@"Exception occured");
	}
	[pool release];
}

#pragma mark createBasicControls
// Create controls for various images displayed in store

-(void)createBasicControls
{
	
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
	
	NSArray *arr=[[NSArray alloc]init];
	arr=	[contentScrollView subviews];
	
	for(int i=0;i<[arr count];i++)
	{ 
		[[arr objectAtIndex:i] removeFromSuperview];
	}
	
	int temp;
	if(firstPageIndex<1)
	{
		temp=0;
	}
	else 
	{
		if(!isBack)
		{
			temp=lastPageIndex+1;
		}
		else
		{
			temp=firstPageIndex;
		}
	}
	
	NSArray *arrButtons=[[NSArray alloc]init];
	arrButtons=	[contentView subviews];
	
	for(int i=0;i<[arrButtons count];i++)
	{ 
		if([[arrButtons objectAtIndex:i]isKindOfClass:[UIButton class]])
		{
			UIButton *btnTemp = (UIButton *)[arrButtons objectAtIndex:i];
			if(!(btnTemp.tag == 5655656) && !(btnTemp.tag == 656565))
			{
				[[arrButtons objectAtIndex:i] removeFromSuperview];
			}
		}
	}
    [contentView addSubview:productSearchBar];
	[contentView addSubview:btnCart];
	[btnCart addSubview:lblCart];
	
	[contentView addSubview:btnDept];
	
	UILabel *lblPageCount = (UILabel *)[contentView viewWithTag:990099];
	lblPageCount.text = nil;
	lblPageCount.text = [NSString stringWithFormat:@"%@ 1 %@ 1",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.store.tab.page"],[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.store.tab.of"]];
	
	int x=52,y=0,j=0,k=1 ,z=0;
	int xForButton=62,yForButton=62;
	startIndex=temp;
	for (int index=temp; (index<[arrSearch count] &&  k<=18) ; index++,j++,k++) 
	{
		if (z == 0)
		{
			z++;
			int curPage =0;
			
			if(index > 0)
			{
			  	curPage =((index+1) / 18 )+1;
			}
			else {
				curPage =(index / 18 )+1;
			}
			
			UILabel *lblPageCount = (UILabel *)[contentView viewWithTag:990099];
			lblPageCount.text = nil;
			lblPageCount.text = [NSString stringWithFormat:@"%@ %d %@ %d",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.store.tab.page"],curPage,[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.store.tab.of"]
								 ,myintcurrentpage];
			
			
			UIImageView *temp1 = (UIImageView *)[contentView viewWithTag:1111];
			if(temp1)
			{
				[temp1 removeFromSuperview];
				[temp1 release];
				temp1 = nil;
				
			}			
			imgPrePage = [[UIImageView alloc] initWithFrame:CGRectMake(28, 659, 25, 18)];
			[imgPrePage setImage:[UIImage imageNamed:@"pre_page.png"]];
			[imgPrePage setTag:1111];
			[imgPrePage setHidden:YES];
			[contentView addSubview:imgPrePage];
			
			UIImageView *temp2 = (UIImageView *)[contentView viewWithTag:3333];
			if(temp2)
			{
				[temp2 removeFromSuperview];
				[temp2 release];
				temp2 = nil;
			}
			
			
			imgNextPage = [[UIImageView alloc] initWithFrame:CGRectMake(974, 659, 25, 18)];
			[imgNextPage setImage:[UIImage imageNamed:@"next_page.png"]];
			[imgNextPage setTag:3333];
			[imgNextPage setHidden:YES];
			[contentView addSubview:imgNextPage];			
			if(curPage == 1 && myintcurrentpage == 1)
			{
				[imgPrePage setHidden: YES];
				[imgNextPage setHidden:YES];
			}
			
			else if(curPage == 1 && myintcurrentpage > 1)
			{
				[imgPrePage setHidden: YES];
				[imgNextPage setHidden:NO];
			}
			
			else if(curPage == myintcurrentpage )
			{
				[imgPrePage setHidden: NO];
				[imgNextPage setHidden:YES];
			}
			else if(curPage > 1 )
			{
				[imgPrePage setHidden: NO];
				[imgNextPage setHidden:NO];
			}
		}
		
		
		lastPageIndex=index;
		
		NSLog(@"%d is index  and k is %d",index,k);
		
		NSDictionary *dicTemp=[arrSearch objectAtIndex:index];
		
		UIView  *productPlaceHolderView=[[UIView alloc]initWithFrame:CGRectMake(x, y, 115, 115)];
		[productPlaceHolderView setTag:index];
		[productPlaceHolderView setBackgroundColor:[UIColor whiteColor]];
		[[productPlaceHolderView layer] setCornerRadius:6.0];
     	[[productPlaceHolderView layer] setBorderWidth:2.0];
		[[productPlaceHolderView layer] setBorderColor:[[UIColor clearColor] CGColor]];
		[contentScrollView addSubview:productPlaceHolderView];
		
		UIImageView *imgProductView=[[UIImageView alloc]initWithFrame:CGRectMake(x, y, 115, 115)];
		[imgProductView setBackgroundColor:[UIColor clearColor]];
		[imgProductView setTag:index+100];
		[[imgProductView layer] setCornerRadius:6];
		imgProductView.layer.masksToBounds = YES;
		imgProductView.layer.opaque = NO;
		[contentScrollView addSubview:imgProductView];
		
			
		[self loadStart:index+100];
		
		btnProductImage=[[UIButton alloc]initWithFrame:CGRectMake(xForButton, yForButton, 100, 100)];
		[btnProductImage setBackgroundColor:[UIColor clearColor]];
		[btnProductImage setTag:index+100];
		[btnProductImage addTarget:self action:@selector(showProductDetails:) forControlEvents:UIControlEventTouchUpInside];
	
		[contentView addSubview:btnProductImage];
		
		
		UILabel *lblProductName=[[UILabel alloc]initWithFrame:CGRectMake(x, y+114, 100, 25)];
		[lblProductName setBackgroundColor:[UIColor clearColor]];
		[lblProductName setText:[dicTemp valueForKey:@"sName"]];
		[lblProductName setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
		
		[lblProductName setTextColor:subHeadingColor];
		[contentScrollView addSubview:lblProductName];
		
		UILabel *lblProductPrice=[[UILabel alloc]initWithFrame:CGRectMake(x, y+130, 130, 25)];
		[lblProductPrice setBackgroundColor:[UIColor clearColor]];
		[lblProductPrice setTextColor:labelColor];
		[lblProductPrice setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        
		[lblProductPrice setText:[[TaxCalculation shared]caluateTaxForProduct:dicTemp]];
		
        
		[contentScrollView addSubview:lblProductPrice];
		NSString *strStatus, *strTemp;
		
		if(dicTemp)
			strTemp = [dicTemp objectForKey:@"sIPhoneStatus"];
		
		
		if ((strTemp != nil) && (![strTemp isEqual:[NSNull null]]))
		{
			if ([[dicTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"coming"])
			{
				strStatus=@"Coming Soon";
			}
			else if ([[dicTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"sold"])
			{
				strStatus=@"Sold Out";
			}
			else if ([[dicTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"active"])
			{
				strStatus = @"In Stock";
			}
			else
			{
				strStatus = [NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"sIPhoneStatus"]];
			}
		}
		else
		{
			strStatus=@"Sold Out";
		}
		
		[dicTemp retain];
		
		UIImageView *imgStockStatus=[[UIImageView alloc]initWithFrame:CGRectMake(x, y+169, 59, 16)];
		[imgStockStatus setBackgroundColor:[UIColor clearColor]];
		[contentScrollView addSubview:imgStockStatus];
		
		UILabel	*lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(x, y+169, 59, 16)];
		[lblStatus setBackgroundColor:[UIColor clearColor]];
		[lblStatus setTextColor:[UIColor whiteColor]];
		[lblStatus setTextAlignment:UITextAlignmentCenter];
		[lblStatus setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10]];
		
		[contentScrollView addSubview:lblStatus];
		
		
		if([strStatus isEqualToString:@"In Stock"]){
			[imgStockStatus setImage:[UIImage imageNamed:@"instock_btn.png"]];
			[lblStatus setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.instock"]];
		}
		else if([strStatus isEqualToString:@"Sold Out"]){
			[imgStockStatus setImage:[UIImage imageNamed:@"sold_out.png"]];
			[lblStatus setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
		}
		else if([strStatus isEqualToString:@"Coming Soon"]){
			[imgStockStatus setImage:[UIImage imageNamed:@"coming_soon.png"]];
			[lblStatus setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.comming.soon"]];
			[lblStatus setFrame:CGRectMake(x, y+168, 81, 16)];
			[imgStockStatus setFrame:CGRectMake(x, y+168, 81, 16)];
		}
        
        
        NSDictionary* dictProduct1=[dicTemp objectForKey:@"productOptions"];
        
        if (![[dicTemp valueForKey:@"bStockControl"]isEqual:[NSNull null]])
        {
            if ([[dicTemp valueForKey:@"bStockControl"] boolValue] ==FALSE)
            {
                if (![[dicTemp valueForKey:@"productOptions"]isEqual:[NSNull null]])
                {
                    if ([dictProduct1 count]==0)
                    {
                        [imgStockStatus setImage:[UIImage imageNamed:@"sold_out.png"]];
                        [lblStatus setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
                        
                    }
                }
                
                
            }
        }

        
		[self markStarRating:productPlaceHolderView :index];
		if(j==2)
		{
			x+=195;
			xForButton+=195;
		}
		else
		{
		    x+=157;
			xForButton+=157;
		}
		
		if(j==5){
	        j=-1;
			x=52;
			y+=211;
			xForButton=52;
			yForButton+=211;
		}
		
		
		
	}
	
	[contentScrollView setContentSize:CGSizeMake(990, y+240)];
	[pool release];
	[sortSegCtrl setHidden:NO];
}


#pragma mark showProductDetails

-(void)showProductDetails:(UIButton*)sender
{
	[productSearchBar resignFirstResponder];
	productSearchBar.showsCancelButton = NO;
	
	NSLog(@"Button tag is %d",sender.tag-100);
	[NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
	NSDictionary *	_dict=[arrSearch objectAtIndex:sender.tag-100];
	
	[NSThread detachNewThreadSelector:@selector(sendDataForAnalytics:) toTarget:self withObject:[_dict objectForKey:@"id"]];
	
	NSDictionary *_dictNextProduct=nil;
	if([arrSearch count]>sender.tag-99)
		_dictNextProduct=[arrSearch objectAtIndex:sender.tag-99];
	[NSThread detachNewThreadSelector:@selector(sendDataForAnalytics:) toTarget:self withObject:[_dictNextProduct objectForKey:@"id"]];
	
	ProductDetails *objProductDetails=[[ProductDetails alloc]init];
	objProductDetails.dicProduct=_dict;
	
	if(_dictNextProduct!=nil)
		objProductDetails.dicNextProduct=_dictNextProduct;						
	
	[[GlobalPrefrences getCurrentNavigationController] pushViewController:objProductDetails animated:YES];
	[objProductDetails release];
	objProductDetails = nil;
}
// Fetching Departments from Server
#pragma mark fetchDataFromServer
-(void)fetchDataFromServer
{
	[lblDepartmetsName setText:selectedDepartment];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary *dictCategories;
	
	if(isComingFromHomePage==NO)
	{
		NSArray *arrCountryAndStateID=[[TaxCalculation shared]getStateAndCountryIDForTax];
		int countryID=[[arrCountryAndStateID objectAtIndex:1] intValue];
		int stateID=[[arrCountryAndStateID objectAtIndex:0]intValue];
		dictCategories=[ServerAPI fetchAllProductsInStore:countryID stateID:stateID:iCurrentStoreId];
		arrAllData=[[NSMutableArray alloc]initWithArray:[[dictCategories objectForKey:@"productsResponse"]objectForKey:@"productList"]];
	}
	else
	{
        NSArray *arrCountryAndStateID=[[TaxCalculation shared]getStateAndCountryIDForTax];
		int countryID=[[arrCountryAndStateID objectAtIndex:1] intValue];
		int stateID=[[arrCountryAndStateID objectAtIndex:0]intValue];
		if(isProductWithoutSubCategory==YES)
		{
            
            dictCategories=[ServerAPI fetchProductsWithoutCategories:iCurrentAppId :countryID :stateID:iCurrentStoreId];
            	}
        
		else {
		    dictCategories = [ServerAPI fetchProductsWithCategories:iCurrentCategoryId :countryID :stateID:iCurrentStoreId:iCurrentDepartmentId];
		}
        
		arrAllData=[[NSMutableArray alloc]initWithArray:[dictCategories objectForKey:@"products"]];
	}
	
	[arrAllData retain];
	[arrSearch removeAllObjects];
	
	if([arrAllData count]>0)
	{
		arrSearch=[NSMutableArray arrayWithArray:arrAllData];
		[arrSearch retain];
		
		[self sortingHandlers];
	}
	
	[self hideLoadingView];
	leavesView = [[LeavesView alloc] initWithFrame:CGRectZero];
	leavesView.frame = self.view.bounds;
	leavesView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[contentView addSubview:leavesView];
	leavesView.dataSource = self;
	leavesView.delegate = self;
	[leavesView reloadData];
	
	[self performSelectorOnMainThread:@selector(createBasicControls) withObject:nil waitUntilDone:NO];
	[pool release];
	
	
}


#pragma mark rating
-(void)markStarRating:(UIView *)_scrollView:(int)index
{
	
    int xValue=0;
	float rating;
	NSDictionary *dictProducts=[arrSearch objectAtIndex:index];
	
	if(![dictProducts isKindOfClass:[NSNull class]])
		if([[dictProducts valueForKey:@"fAverageRating"] isEqual:[NSNull null]])
			rating = 0.0;
		else
			rating = [[dictProducts valueForKey:@"fAverageRating"] floatValue];
	float tempRating;
	tempRating=floor(rating);
	tempRating=rating-tempRating;
	
	for(int i=0; i<5; i++)
	{
		imgRatingsTemp[i] = [[[UIImageView alloc] initWithFrame:CGRectMake( xValue, 154, 9, 9)] autorelease];
        imgRatingsTemp[i].clipsToBounds = TRUE;
		[imgRatingsTemp[i] setImage:[UIImage imageNamed:@"black_star.png"]];
		[imgRatingsTemp[i] setBackgroundColor:[UIColor clearColor]];
		[_scrollView addSubview:imgRatingsTemp[i]];
		
		xValue += 11;
	}
	
	int iTemp =0;
	
	for(int i=0; i<abs(rating) ; i++)
	{
		
		viewRatingBG[i] = [[[UIView  alloc] initWithFrame:CGRectMake(0, 0, 9, 9)] autorelease];
		[viewRatingBG[i] setBackgroundColor:[UIColor clearColor]];
		[imgRatingsTemp[i] addSubview:viewRatingBG[i]];
		
		imgRatings[i] = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 9, 9)] autorelease];
		[imgRatings[i] setImage:[UIImage imageNamed:@"yellow_star.png"]];
		[imgRatingsTemp[i] addSubview:imgRatings[i]];
		iTemp = i;
	}
	
	if (tempRating>0)
	{
		int iLastStarValue = 0;
		if(rating >=1.0)
			iLastStarValue = iTemp + 1;
        
        viewRatingBG[iLastStarValue] = [[[UIView  alloc] initWithFrame:CGRectMake(0, 0, tempRating * 9, 9)] autorelease];
        viewRatingBG[iLastStarValue].clipsToBounds = TRUE;
        [imgRatingsTemp[iLastStarValue] addSubview:viewRatingBG[iLastStarValue]];
        
        imgRatings[iLastStarValue] = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 9, 9)] autorelease];
        [imgRatings[iLastStarValue] setImage:[UIImage imageNamed:@"yellow_star.png"]];
        [viewRatingBG[iLastStarValue] addSubview:imgRatings[iLastStarValue]];
    }
}


#pragma mark create subviews and controls

-(void)createSubViewsAndControls
{
	btnCart = [[UIButton alloc]init];
	btnCart.frame = CGRectMake(905, 12, 78,34);
	[btnCart setBackgroundColor:[UIColor clearColor]];
	btnCart.tag = 5655656;
	[btnCart setImage:[UIImage imageNamed:@"add_cart.png"] forState:UIControlStateNormal];
	[btnCart addTarget:self action:@selector(btnShoppingCart_Clicked:) forControlEvents:UIControlEventTouchUpInside];
	
	lblCart = [[UILabel alloc] initWithFrame:CGRectMake(42, 2, 30, 30)];
	lblCart.backgroundColor = [UIColor clearColor];
	lblCart.textAlignment = UITextAlignmentCenter;
	lblCart.font = [UIFont boldSystemFontOfSize:16];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	lblCart.textColor = [UIColor whiteColor];	 
	
    btnDept=[[UIButton alloc] init];
	[btnDept setFrame: CGRectMake(43, 13, 93, 31)];
	[btnDept setTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.home.departments"] forState:UIControlStateNormal];
	btnDept.tag = 656565;
	[btnDept setTitleColor:btnTextColor forState:UIControlStateNormal];
	[btnDept.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
	[btnDept setBackgroundImage:[UIImage imageNamed:@"department.png"] forState:UIControlStateNormal];
	btnDept.backgroundColor = [UIColor clearColor];
	[btnDept addTarget:self action:@selector(btnDept_Clicked:) forControlEvents:UIControlEventTouchUpInside];
	[contentView addSubview:btnDept];
	
	UILabel *lblDepartmets=[[UILabel alloc]initWithFrame:CGRectMake(158, 15, 80, 30)];
	[lblDepartmets setBackgroundColor:[UIColor clearColor]];
	[lblDepartmets setText:[NSString stringWithFormat:@"%@:", [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.store.tab.department"]]];
	[lblDepartmets setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
	
	lblDepartmets.textColor = headingColor;
	[contentView addSubview:lblDepartmets];
	[lblDepartmets release];
	
	UILabel *lblPageCount=[[UILabel alloc]initWithFrame:CGRectMake(396, 14, 100, 30)];
	[lblPageCount setBackgroundColor:[UIColor clearColor]];
	[lblPageCount setTag:990099];
	[lblPageCount setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
	
	lblPageCount.textColor = headingColor;
	[contentView addSubview:lblPageCount];
	[lblPageCount release];
	
	lblDepartmetsName=[[UILabel alloc]initWithFrame:CGRectMake(243, 15, 150, 30)];
	[lblDepartmetsName setBackgroundColor:[UIColor clearColor]];
	[lblDepartmetsName setText:selectedDepartment];
	[lblDepartmetsName setTextColor:subHeadingColor];
	[lblDepartmetsName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.5]];
	
	[contentView addSubview:lblDepartmetsName];
	
	productSearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(540, 18, 296, 28)];
	[productSearchBar setBackgroundColor:[UIColor clearColor]];
	NSString *str = [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.common.search"];
	[productSearchBar setPlaceholder:str];
	[productSearchBar setTranslucent:YES];
	[[productSearchBar.subviews objectAtIndex:0] removeFromSuperview];
	[productSearchBar setDelegate:self];
    [productSearchBar setTintColor:productSearchBar.backgroundColor];
	[productSearchBar setTranslucent:YES];
	[contentView addSubview:productSearchBar];
	
	UIImageView *imgVerticalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(144, 17, 1, 34)];
	[imgVerticalDottedLine setImage:[UIImage imageNamed:@"vertical_dotted_lines.png"]];
	[contentView addSubview:imgVerticalDottedLine];
	[imgVerticalDottedLine release];
	
	UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(45, 50, 429,2)];
	[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
	[contentView addSubview:imgHorizontalDottedLine];
	[imgHorizontalDottedLine release];
	
	UIImageView *imgHorizontalDottedLine1=[[UIImageView alloc]initWithFrame:CGRectMake(554, 50, 429,2)];
	[imgHorizontalDottedLine1 setImage:[UIImage imageNamed:@"dot_line.png"]];
	[contentView addSubview:imgHorizontalDottedLine1];
	[imgHorizontalDottedLine1 release];
	
}



#pragma mark DepartmentListingViewControllerDelegates
-(void)btnDept_Clicked:(UIButton *)sender
{
	[productSearchBar resignFirstResponder];
	productSearchBar.showsCancelButton = NO;
	
	[NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
	DepartmentListingViewController *objDepartment=[[DepartmentListingViewController alloc]init];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:objDepartment];
	[objDepartment release];
	self.popOverController=popover;
	[self.popOverController setDelegate:self];
    [popover release];
	CGRect popoverRect = [self.view convertRect:[sender frame] fromView:[sender superview]];
	[self.popOverController setPopoverContentSize:CGSizeMake(313,330) animated:YES];
	popoverRect.size.width = MIN(popoverRect.size.width, 100); 
	
    [self.popOverController
	 presentPopoverFromRect:popoverRect 
	 inView:self.view 
	 permittedArrowDirections:UIPopoverArrowDirectionUp
	 animated:YES];
	
	
}	

//---called when the user clicks outside the popover view---
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
	
    NSLog(@"popover about to be dismissed");
    return YES;
}

//---called when the popover view is dismissed---
- (void)popoverControllerDidDismissPopover:
(UIPopoverController *)popoverController {
	
    NSLog(@"popover dismissed");    
}


#pragma mark Search Bar Delegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {  
    searchBar.showsCancelButton = YES;  
	return YES;
}  

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {  
    searchBar.showsCancelButton = NO;  
	[leavesView reloadData];
	[self performSelectorOnMainThread:@selector(createBasicControls) withObject:nil waitUntilDone:YES];
	return YES;
}  

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
	[arrSearch removeAllObjects];
	[arrSearch addObjectsFromArray:arrAllData];
	
	@try
	{
		[leavesView reloadData];
		[self performSelectorOnMainThread:@selector(createBasicControls) withObject:nil waitUntilDone:YES];
	}
	@catch(NSException *e)
	{
		
	}
	searchBar.showsCancelButton = NO; 
	[searchBar resignFirstResponder];
	searchBar.text = @"";
	
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{   
	[arrSearch removeAllObjects];
	
	if([searchText isEqualToString:@""] || searchText==nil)
	{      
		[arrSearch addObjectsFromArray:arrAllData];		
        [leavesView reloadData];
		[self performSelectorOnMainThread:@selector(createBasicControls) withObject:nil waitUntilDone:YES];
		return;
	}
	else
	{
		NSInteger counter = 0;
		for(NSDictionary *dictName in arrAllData)
		{
			NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
			NSRange r = [[[dictName objectForKey:@"sName"] uppercaseString] rangeOfString:[searchText uppercaseString]] ;
			if(r.location != NSNotFound)
			{
				if(r.location==0)//that is we are checking only the start of the names.
				{
					[arrSearch addObject:dictName];
				}
			}
			counter++;
			[pool release];
		}
				
		[leavesView reloadData];
		[self performSelectorOnMainThread:@selector(createBasicControls) withObject:nil waitUntilDone:YES];
	}
}


#pragma mark -

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{	
	[searchBar resignFirstResponder];
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

-(void)viewWillDisappear:(BOOL)animated
{
	UILabel *lblSortBy = (UILabel *)[self.tabBarController.view viewWithTag:2222];
	[lblSortBy removeFromSuperview];
	
	NSArray *arrButtons=[[NSArray alloc]init];
	arrButtons=	[self.tabBarController.view subviews];
	
	for(int i=0;i<[arrButtons count];i++)
	{ 
		if([[arrButtons objectAtIndex:i]isKindOfClass:[UILabel class]])
		{
			if([[arrButtons objectAtIndex:i]tag]==2222)
				[[arrButtons objectAtIndex:i] removeFromSuperview];
		}
	}
	
	
	[sortSegCtrl removeFromSuperview];
	
}
- (void)viewDidUnload {
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)dealloc {
	
	
	[btnCart release];
	[btnDept release];
	[lblCart release];
	[sortSegCtrl removeFromSuperview];
	[lblDepartmetsName release];
	[super dealloc];
}


@end
