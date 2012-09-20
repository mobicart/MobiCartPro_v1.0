//
//  GlobalSearch.m
//  Mobicart
//
//  Created by Mobicart on 16/05/11.
//  Copyright Mobicart. All rights reserved.
//

#import "GlobalSearch.h"


@implementation GlobalSearch
@synthesize strProductToSearch;
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

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */
-(void)btnShoppingCart_Clicked
{
	if(iNumOfItemsInShoppingCart > 0)
		[NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
	ShoppingCartViewController *objShopping = [[ShoppingCartViewController alloc] init];
	[[self navigationController]pushViewController:objShopping animated:YES];
	[objShopping release];
	
}
-(void)showLoading
{
	[GlobalPrefrences addLoadingBar_AtBottom:self.tabBarController.view withTextToDisplay:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
}

-(void)viewWillAppear:(BOOL)animated
{
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
}
- (id)initWithProductName:(NSString *)productNameToSearch {
    if ((self = [super init])) {
        // Custom initialization
		self.strProductToSearch = productNameToSearch;
    }
    return self;
}


#pragma mark Lazy Loading of Images


-(void)loadStart:(int)intValue
{
	[NSThread detachNewThreadSelector:@selector(downloadStart:) toTarget:self withObject:[NSNumber numberWithInt:intValue]];
}


-(void)finishDownload
{
}

-(void)downloadStart:(NSNumber *)intValue
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	@try {
		int i =[intValue intValue]-100;
		NSLog(@"Tag is %d",i);
		NSDictionary *dictTemp=[arrSearchedData objectAtIndex:i];
		NSArray  *arrImagesUrls =[[NSArray alloc]init];
		arrImagesUrls=	[dictTemp objectForKey:@"productImages"];
		
		NSString *	additionalImagesLink =[[NSString alloc]init];
		if([arrImagesUrls count]>0)
			additionalImagesLink =[[arrImagesUrls objectAtIndex:0] valueForKey:@"productImageMediumIpad"];
		
		
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


-(void)hideLoadingView
{
	[GlobalPrefrences dismissLoadingBar_AtBottom];	
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[NSTimer scheduledTimerWithTimeInterval:0.05
									 target:self
								   selector:@selector(hideLoadingView)
								   userInfo:nil
									repeats:NO];
	contentView=[[UIView alloc]initWithFrame:CGRectMake( 0, 0, 1024, 768)];
	contentView.backgroundColor=[UIColor clearColor];
	self.view=contentView;
	
	[GlobalPrefrences setBackgroundTheme_OnView:contentView];
	
	
	
	UIButton *btnCart = [[UIButton alloc]init];
	btnCart.frame = CGRectMake(903, 19, 78,34);
	[btnCart setBackgroundColor:[UIColor clearColor]];
	[btnCart setImage:[UIImage imageNamed:@"add_cart.png"] forState:UIControlStateNormal];
	[btnCart addTarget:self action:@selector(btnShoppingCart_Clicked) forControlEvents:UIControlEventTouchUpInside];
	[contentView addSubview:btnCart];
	
	lblCart = [[UILabel alloc] initWithFrame:CGRectMake(42, 2, 30, 30)];
	lblCart.backgroundColor = [UIColor clearColor];
	lblCart.textAlignment = UITextAlignmentCenter;
	lblCart.font = [UIFont boldSystemFontOfSize:16];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	lblCart.textColor = [UIColor whiteColor];	 
	[btnCart addSubview:lblCart];
	
	
	UILabel *searchLbl=[[UILabel alloc]initWithFrame:CGRectMake(43, 23, 150, 15)];
	[searchLbl setBackgroundColor:[UIColor clearColor]];
    searchLbl.textColor = headingColor;
	[searchLbl setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.global.search.result"]];
	[searchLbl setFont:[UIFont boldSystemFontOfSize:15]];
	[contentView addSubview:searchLbl];
	[searchLbl release]; 
	
	
	UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(46, 52, 420,2)];
	[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
	[contentView addSubview:imgHorizontalDottedLine];
	[imgHorizontalDottedLine release];
	
	UIImageView *imgHorizontalDottedLine1=[[UIImageView alloc]initWithFrame:CGRectMake(555, 52, 426,2)];
	[imgHorizontalDottedLine1 setImage:[UIImage imageNamed:@"dot_line.png"]];
	[contentView addSubview:imgHorizontalDottedLine1];
	[imgHorizontalDottedLine1 release];
	
	contentScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, 1024, 600)];
	[contentView addSubview:contentScrollView];
	arrSearchedData =[[NSArray alloc] init];
	
	
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fetchDataFromServer:) object:self.strProductToSearch];
	
	[GlobalPrefrences addToOpertaionQueue:operation];
	[operation release];
	
	
}
-(void)showProductDetails:(UIButton*)sender
{
	
	NSLog(@"Button tag is %d",sender.tag-100);
	
	
	NSDictionary *	_dict=[arrSearchedData objectAtIndex:sender.tag-100];
	
	
	NSDictionary *_dictNextProduct=nil;
	if([arrSearchedData count]>sender.tag-99)
		_dictNextProduct=[arrSearchedData objectAtIndex:sender.tag-99];
	ProductDetails *objProductDetails=[[ProductDetails alloc]init];
	objProductDetails.dicProduct=_dict;
	
	if(_dictNextProduct!=nil)
		objProductDetails.dicNextProduct=_dictNextProduct;
	
	[[self navigationController]pushViewController:objProductDetails animated:YES];
}
// Fetching Search Results From Server
#pragma mark fetch Data
-(void)fetchDataFromServer:(NSString *) _url
{
	arrSearchedData = [[ServerAPI fetchGlobalSearchProducts:_url:iCurrentAppId] objectForKey:@"products"];
	[arrSearchedData retain];
	[self performSelectorOnMainThread:@selector(loadSearchResults) withObject:nil waitUntilDone:YES];
	
}


-(void)loadSearchResults
{
	
	NSArray *arr=[[NSArray alloc]init];
	arr=	[contentScrollView subviews];
	
	for(int i=0;i<[arr count];i++)
	{
		[[arr objectAtIndex:i] removeFromSuperview];
	}
	
	
	int x=50,y=10,j=0;
	for (int index=0; index<[arrSearchedData count]; index++,j++) {
		
		
		NSDictionary *dicTemp=[arrSearchedData objectAtIndex:index];
		
		UIView *productPlaceHolderView=[[UIView alloc]initWithFrame:CGRectMake(x, y, 115, 115)];
		[productPlaceHolderView setTag:index];
		[productPlaceHolderView setBackgroundColor:[UIColor whiteColor]];
		[[productPlaceHolderView layer] setCornerRadius:6.0];
		[[productPlaceHolderView layer] setBorderWidth:2.0];
		[[productPlaceHolderView layer] setBorderColor:[[UIColor clearColor] CGColor]];
		[contentScrollView addSubview:productPlaceHolderView];
		
		
		UIImageView *imgProductView=[[UIImageView alloc]initWithFrame:CGRectMake(x, y, 115, 115)];
		[imgProductView setBackgroundColor:[UIColor clearColor]];
		[[imgProductView layer] setCornerRadius:6.0];
		[[imgProductView layer] setBorderWidth:2.0];
		imgProductView.layer.masksToBounds = YES;
		[[imgProductView layer] setBorderColor:[[UIColor clearColor] CGColor]];
		[imgProductView setTag:index+100];
		[contentScrollView addSubview:imgProductView];
		[self loadStart:index+100];
		
		UIButton *btnProductImage=[[UIButton alloc]initWithFrame:CGRectMake(x, y, 100, 100)];
		[btnProductImage setBackgroundColor:[UIColor clearColor]];
		[btnProductImage setTag:index+100];
		[btnProductImage addTarget:self action:@selector(showProductDetails:) forControlEvents:UIControlEventTouchUpInside];
		[contentScrollView addSubview:btnProductImage];
		
		
		UILabel *lblProductName=[[UILabel alloc]initWithFrame:CGRectMake(x, y+114, 100, 25)];
		[lblProductName setBackgroundColor:[UIColor clearColor]];
		[lblProductName setText:[dicTemp valueForKey:@"sName"]];
		[lblProductName setFont:[UIFont boldSystemFontOfSize:14]];
		[lblProductName setTextColor:subHeadingColor];
		[contentScrollView addSubview:lblProductName];
		
		UILabel *lblProductPrice=[[UILabel alloc]initWithFrame:CGRectMake(x, y+130, 100, 25)];
		[lblProductPrice setBackgroundColor:[UIColor clearColor]];
		[lblProductPrice setTextColor:subHeadingColor];
        [lblProductPrice setFont:[UIFont systemFontOfSize:12]];
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
		
		
		UIImageView *imgStockStatus=[[UIImageView alloc]initWithFrame:CGRectMake(x, y+169, 63, 17)];
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
		
		
		[self markStarRating:productPlaceHolderView :index];
		
		
		if(j==2)
		{
			x+=195;
		}
		else
		{
		    x+=157;
		}
		
		if(j==5){
	        j=-1;
			x=52;
			y+=211;
		}
		
		
		
		
	}
	
	[contentScrollView setContentSize:CGSizeMake(1024, y+240)];
	
}
-(void)markStarRating:(UIView *)_scrollView:(int)index
{
	
    int xValue=0;
	
	float rating;
	NSDictionary *dictProducts=[arrSearchedData objectAtIndex:index];
  	
    
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
		imgRatingsTemp[i] = [[[UIImageView alloc] initWithFrame:CGRectMake( xValue, 154, 12, 12)] autorelease];
        imgRatingsTemp[i].clipsToBounds = TRUE;
		[imgRatingsTemp[i] setImage:[UIImage imageNamed:@"black_star.png"]];
		[imgRatingsTemp[i] setBackgroundColor:[UIColor clearColor]];
		[_scrollView addSubview:imgRatingsTemp[i]];
		
		xValue += 15;
	}
	
	int iTemp =0;
	
	for(int i=0; i<abs(rating) ; i++)
	{
		
		viewRatingBG[i] = [[[UIView  alloc] initWithFrame:CGRectMake(0, 0, 12, 12)] autorelease];
		[viewRatingBG[i] setBackgroundColor:[UIColor clearColor]];
        
		[imgRatingsTemp[i] addSubview:viewRatingBG[i]];
		
		
		
		imgRatings[i] = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)] autorelease];
		[imgRatings[i] setImage:[UIImage imageNamed:@"yellow_star.png"]];
		[imgRatingsTemp[i] addSubview:imgRatings[i]];
		iTemp = i;
	}
	
	if (tempRating>0)
	{
		int iLastStarValue = 0;
		if(rating >=1.0)
			iLastStarValue = iTemp + 1;
        
        
        
        viewRatingBG[iLastStarValue] = [[[UIView  alloc] initWithFrame:CGRectMake(0, 0, tempRating * 12, 12)] autorelease];
        viewRatingBG[iLastStarValue].clipsToBounds = TRUE;
        [imgRatingsTemp[iLastStarValue] addSubview:viewRatingBG[iLastStarValue]];
        
        imgRatings[iLastStarValue] = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)] autorelease];
        [imgRatings[iLastStarValue] setImage:[UIImage imageNamed:@"yellow_star.png"]];
        [viewRatingBG[iLastStarValue] addSubview:imgRatings[iLastStarValue]];
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
	[lblCart release];
    [super dealloc];
}


@end
