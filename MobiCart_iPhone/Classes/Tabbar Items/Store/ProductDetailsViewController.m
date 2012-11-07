
//
//  ProductDetailsViewController.m
//  MobiCart
//
//  Created by Mobicart on 8/7/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "Constants.h"
#import "webViewVideo.h"
#include <math.h>
#include "ProductPriceCalculation.h"
#import "CoverFlowViewController.h"
BOOL isZoomIn;
BOOL isShowOptionTable;
BOOL moveONSwap=NO;
BOOL moveON =YES;
BOOL isProductDetails;
BOOL fromProductDetails;
extern int categoryCount;

@implementation ProductDetailsViewController

@synthesize dicProduct, isWishlist, optionIndex;

#pragma mark View Controller Delegates


- (void)dismissLoadingBar_AtBottom
{
	[GlobalPreferences dismissLoadingBar_AtBottom];
}

-(void)createDropDowns
{
	NSArray *arrTempOptions=[[NSArray alloc]initWithArray:optionArray];
	dropDownCount=-1;
	
	
	if([arrTempOptions count]>0)
	{
		dropDownCount=0;
		strTitle= [NSString stringWithFormat:@"%@",[[arrTempOptions objectAtIndex:0] objectForKey:@"sTitle"]];
		strTitle=[[strTitle  stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]lowercaseString];
    }
	
	
	for(int count=0;count<[arrTempOptions count];count++)
	{
        if([[[[NSString stringWithFormat:@"%@",[[arrTempOptions objectAtIndex:count]objectForKey:@"sTitle"]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString] isEqualToString:strTitle])
        {
            if(!arrDropDown[dropDownCount])
                arrDropDown[dropDownCount]=[[NSMutableArray alloc]init];
			
            [arrDropDown[dropDownCount] addObject:[arrTempOptions objectAtIndex:count]];
			
        }
		
        else
        {
            BOOL isValueSet=NO;
            for(int countTemp=0;countTemp<=dropDownCount;countTemp++)
            {
				
                if([[[[[arrDropDown[countTemp] objectAtIndex:0]objectForKey:@"sTitle"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]lowercaseString]isEqualToString:[[[[arrTempOptions objectAtIndex:count]objectForKey:@"sTitle"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]lowercaseString]])
                {
                    [arrDropDown[countTemp] addObject:[arrTempOptions objectAtIndex:count]];
                    isValueSet=YES;
                    break;
                }
				
            }
			
			if(isValueSet==NO)
			{
				strTitle=[NSString stringWithFormat:@"%@",[[arrTempOptions objectAtIndex:count]objectForKey:@"sTitle"]];
				strTitle=[[strTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]lowercaseString];
				dropDownCount++;
				
				if(!arrDropDown[dropDownCount])
					arrDropDown[dropDownCount]=[[NSMutableArray alloc]init];
				
				[arrDropDown[dropDownCount] addObject:[arrTempOptions objectAtIndex:count]];
				
		    }
		}
	}
	
	if(arrTempOptions)
		[arrTempOptions release];
    
	if(!resetIndex)
	{
        
        for(int count=0;count<=dropDownCount;count++)
        {
            selectedIndex[count]=-1;
            
        }	    }
    
	resetIndex=YES;
}


- (void)viewWillAppear:(BOOL)animated
{
	
	self.title=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.home.back"];
	if([GlobalPreferences getPersonLoginStatus])
    {
        
        if(shouldNavigateToWriteReview)
        {
            shouldNavigateToWriteReview=NO;
            [self navigateToPostReview];
            
        }
    }
	
    self.navigationItem.leftBarButtonItem=nil;
	
	UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom ];
	[btn setBackgroundImage:[UIImage imageNamed:@"store_btn_iphone4.png"] forState:UIControlStateNormal];
	[btn setTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.department.store"] forState:UIControlStateNormal];
	[btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
	[btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	[btn setFrame:CGRectMake(35, 0, 69,36)];
	
	UIBarButtonItem *btnBack=[[UIBarButtonItem alloc] initWithCustomView:btn];
	[btnBack setStyle:UIBarButtonItemStyleBordered];
	
    [self.navigationItem setLeftBarButtonItem:btnBack];
    lblCart.text =[NSString stringWithFormat:@"%d",iNumOfItemsInShoppingCart];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateLabelStore" object:nil];
	for(UILabel *lblTemp in [self.navigationController.navigationBar subviews])
	{
		if ([lblTemp isKindOfClass:[UILabel class]])
		{
			lblTemp.text = [NSString stringWithFormat:@"%d",iNumOfItemsInShoppingCart];
			break;
		}
	}
	
	
	FeaturedProductFromHomePage=[GlobalPreferences isClickedOnFeaturedProductFromHomeTab];
    
	if ([GlobalPreferences isClickedOnFeaturedProductFromHomeTab])
	{
		[GlobalPreferences setIsClickedOnFeaturedImage:NO];
		[GlobalPreferences setCanPopToRootViewController:YES];
	}
	else
	{
		[GlobalPreferences setCanPopToRootViewController:NO];
	}
    
	[self performSelectorInBackground:@selector(markStarRating) withObject:nil];
	[self performSelector:@selector(dismissLoadingBar_AtBottom) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
    
	
}

- (void)back
{
    if(FeaturedProductFromHomePage==YES)
    {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        if (isFeaturedProductWithoutCatogery==YES)
        {
            isFeaturedProductWithoutCatogery=NO;
            if (FeaturedProductFromHomePage==YES)
            {
                FeaturedProductFromHomePage=NO;
                [[self navigationController]popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            }
            else
            {
                [[self navigationController]popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
        }
        else
        {
            [[self navigationController]popViewControllerAnimated:YES];
        }
    }
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	self.title=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.home.back"];
	if (![GlobalPreferences isInternetAvailable])
	{
		NSString* errorString = [[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.text"];
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.title"] message:errorString delegate:self cancelButtonTitle:nil otherButtonTitles:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"], nil];
		[errorAlert show];
		[errorAlert release];
	}
	else
	{
		
		
		arrDropDownTable=[[NSArray alloc]init];
		
		arrAddedToCartList=[[NSMutableArray alloc] init];
		
		pastIndex=-1;
		
		loadingStatus=YES;
		[GlobalPreferences setCurrentNavigationController:self.navigationController];
		self.navigationItem.titleView = [GlobalPreferences createLogoImage];
		contentView=[[UIView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake( 0, 0, 320, 396) chageHieght:YES]];
        UIImageView * bgImage=[[UIImageView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake( 0, 0, 320, 396) chageHieght:YES]];
		[bgImage setImage:[UIImage imageNamed:@"product_details_bg.png"]];
		[contentView addSubview:bgImage];
        
		self.view=contentView;
		
		UIView *viewRemoveLine = [[UIView alloc] initWithFrame:CGRectMake( 0, 43, 320,1)];
		[viewRemoveLine setBackgroundColor:self.navigationController.navigationBar.tintColor];
        
		[self.navigationController.navigationBar addSubview:viewRemoveLine];
		[viewRemoveLine release];
		
		[self performSelectorInBackground:@selector(fetchDataFromServer:) withObject:[NSNumber numberWithBool:NO]];
		[self dataValidationChecks];
		
		[self performSelectorOnMainThread:@selector(createBasicControls) withObject:nil waitUntilDone:NO];
		[self allocateMemoryToObjects];
        
	}
	
}

#pragma mark - fetchDataFromServer
- (void)fetchDataFromServer:(NSNumber *)isHandlingZoomImage
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSArray  *arrImagesUrls = [dicProduct objectForKey:@"productImages"];
	if (arrImagesUrls)
    {
        [self displayProductImage:arrImagesUrls picToShowAtAIndex:0 willZoom:isHandlingZoomImage];
    }
    
	[pool release];
}

- (void)displayProductImage:(NSArray *)arrImagesUrls picToShowAtAIndex:(NSInteger)_picNum willZoom:(NSNumber *)isHandlingZoomImage
{
	if ([arrImagesUrls count]==0)
	{
		dataForProductImage =nil;
		loadingStatus=NO;
		imageCheck=YES;
	}
	else
	{
        // Checking if the data is to be fetched for medium sized image, or large image
		if (!isHandlingZoomImage)
        {
            dataForProductImage = [ServerAPI fetchBannerImage:[[arrImagesUrls objectAtIndex:_picNum] objectForKey:@"productImageMediumIphone"]];
        }
        else
        {
            dataForProductImage = [ServerAPI fetchBannerImage:[[arrImagesUrls objectAtIndex:_picNum] objectForKey:@"productImageCoverFlowIphone"]];
        }
	}
    
	if (!dataForProductImage)
	{
		dataForProductImage=nil;
		imageCheck=YES;
	}
    
	[self performSelectorOnMainThread:@selector(resetControls) withObject:nil waitUntilDone:YES];
	
}
- (void)navigateToPostReview
{
    
	if ([[GlobalPreferences getUserDefault_Preferences:@"userEmail"] length]==0)
	{
		shouldNavigateToWriteReview=YES;
        
		fromProductDetails = YES;
		DetailsViewController *_details = 	[[DetailsViewController alloc] init];
		_details.isReview=YES;
		[self.navigationController pushViewController:_details animated:YES];
		[_details release];
	}
	else
	{
		PostReviewsViewController *objPost = [[PostReviewsViewController alloc] init];
		[self.navigationController pushViewController:objPost animated:YES];
		objPost.productId = [[dicProduct objectForKey:@"id"]intValue];
		[objPost release];
	}
}
- (void)allocateMemoryToObjects
{
	if(optionArray)
	{
		[optionArray release];
		optionArray = nil;
	}
	optionArray = [[NSArray alloc] init];
	optionArray = [dicProduct objectForKey:@"productOptions"];
	
	[optionArray retain];
    [self createDropDowns];
	
	
}
- (void)dataValidationChecks
{
	if ([[dicProduct objectForKey:@"sDescription"] isEqual:[NSNull null]])
    {
		[dicProduct setValue:@" " forKey:@"sDescription"];
    }
	else
    {
        (([dicProduct objectForKey:@"sDescription"] == nil) || ([[dicProduct objectForKey:@"sDescription"] isEqualToString:@""]))? [dicProduct setValue:@" " forKey:@"sDescription"]:nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
	self.title=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.home.back"];
}

#pragma mark - reload Image
- (void)navigateToReadReview
{
	[GlobalPreferences addLoadingBar_AtBottom:self.tabBarController.view withTextToDisplay:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
    ReadReviewsViewController *objRead = [[ReadReviewsViewController alloc] init];
	objRead.selectedProductId = [[dicProduct objectForKey:@"id"]intValue];
	
	
	[[GlobalPreferences getCurrentNavigationController] pushViewController:objRead animated:YES];
	[objRead release];
}

//reload the image of product , once it is loaded from the server
- (void)resetControls
{
	if ((productImg) || (productImg.image==nil))
    {
        [productImg setImage:[UIImage imageWithData:dataForProductImage]];
    }
    
	[productImg setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)markStarRating
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if (!contentView)
	{
		contentView=[[UIView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake( 0, 0, 320, 396) chageHieght:YES]];
		contentView.backgroundColor=[UIColor colorWithRed:248.0/256 green:248.0/256 blue:248.0/256 alpha:1];
		[GlobalPreferences setGradientEffectOnView:contentView:contentView.backgroundColor:[UIColor lightGrayColor]];
		
		self.view=contentView;
	}
	
	int xValue=12;
	float rating;
	
	NSDictionary *dictProducts = [ServerAPI fetchDetailsOfProductWithID:[[dicProduct valueForKey:@"id"]intValue]];
	
    if ([[[dictProducts valueForKey:@"product"]valueForKey:@"categoryName"] isEqual:[NSNull null]]&&categoryCount==0)
    {
        isFeaturedProductWithoutCatogery=YES;
    }
	
	if (![dictProducts isKindOfClass:[NSNull class]])
    {
        if ([[[dictProducts valueForKey:@"product"]valueForKey:@"fAverageRating"] isEqual:[NSNull null]])
        {
            rating = 0.0;
        }
		else
        {
            rating = [[[dictProducts valueForKey:@"product"]valueForKey:@"fAverageRating"] floatValue];
        }
    }
    
	float tempRating;
	tempRating=floor(rating);
	tempRating=rating-tempRating;
	
	for(int i=0; i<5; i++)
	{
		imgRatingsTemp[i] = [[[UIImageView alloc] initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake(xValue, 336, 20,20) chageHieght:NO]] autorelease];
        imgRatingsTemp[i].clipsToBounds = TRUE;
		[imgRatingsTemp[i] setImage:[UIImage imageNamed:@"grey_star1.png"]];
		[imgRatingsTemp[i] setBackgroundColor:[UIColor clearColor]];
		[contentView addSubview:imgRatingsTemp[i]];
		
		xValue += 26;
	}
	
	int iTemp =0;
	for(int i=0; i<abs(rating) ; i++)
	{
		viewRatingBG[i] = [[[UIView  alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
		[viewRatingBG[i] setBackgroundColor:[UIColor clearColor]];
		[imgRatingsTemp[i] addSubview:viewRatingBG[i]];
		imgRatings[i] = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
		[imgRatings[i] setImage:[UIImage imageNamed:@"yellow_star1.png"]];
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
        
		viewRatingBG[iLastStarValue] = [[[UIView  alloc] initWithFrame:CGRectMake(0, 0, tempRating * 20, 20)] autorelease];
		viewRatingBG[iLastStarValue].clipsToBounds = TRUE;
		[imgRatingsTemp[iLastStarValue] addSubview:viewRatingBG[iLastStarValue]];
		imgRatings[iLastStarValue] = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
		[imgRatings[iLastStarValue] setImage:[UIImage imageNamed:@"yellow_star1.png"]];
		[viewRatingBG[iLastStarValue] addSubview:imgRatings[iLastStarValue]];
	}
	
	if ([[[dictProducts valueForKey:@"product"]valueForKey:@"productReviews"]count]>1)
    {
        [lblReadReviews setText:[NSString stringWithFormat:@"%d %@",[[[dictProducts valueForKey:@"product"]valueForKey:@"productReviews"]count],[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.mainproduct.reviews"]]];
    }
    else
    {
		[lblReadReviews setText:[NSString stringWithFormat:@"%d %@",[[[dictProducts valueForKey:@"product"]valueForKey:@"productReviews"]count],[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.mainproduct.reviews"]]];
    }    [pool release];
}

- (void)createBasicControls
{
	if(!contentScrollView)
	{
		contentScrollView=[[UIScrollView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake(0, 0, 320, 360) chageHieght:YES]];
		[contentScrollView setBackgroundColor:[UIColor clearColor]];
        if([GlobalPreferences isScreen_iPhone5])
            [contentScrollView setContentSize:CGSizeMake( 320, 370+88)];
        else
            [contentScrollView setContentSize:CGSizeMake( 320, 370)];
        [contentView addSubview:contentScrollView];
	}
    
	UIImageView *imgPlaceholder=[[UIImageView alloc]initWithFrame:CGRectMake(6, 20, 133, 150)];
	[imgPlaceholder setImage:[UIImage imageNamed:@"product_detail_placeholder.png"]];
	[contentScrollView addSubview:imgPlaceholder];
	
	scrollProductImg=[[UIScrollView alloc]initWithFrame:CGRectMake( 0, 1, 127, 143)];
	[scrollProductImg setBackgroundColor:[UIColor clearColor]];
	[scrollProductImg setContentSize:CGSizeMake( 127, 143)];
	[scrollProductImg setMinimumZoomScale:1.0];
	[scrollProductImg setMaximumZoomScale:2.0];
	[scrollProductImg setScrollEnabled:YES];
	scrollProductImg.clipsToBounds=YES;
	[scrollProductImg setDelegate:self];
	[imgPlaceholder addSubview:scrollProductImg];
	[imgPlaceholder release];
	
	productImg = [[UIImageView alloc]initWithFrame:CGRectMake(2.5,0, 127, 143)];
	[productImg setBackgroundColor:[UIColor clearColor]];
	[productImg setImage:[UIImage imageWithData:dataForProductImage]];
	
	[scrollProductImg addSubview:productImg];
	
	whiteView = [[UIImageView alloc]initWithFrame:CGRectMake( 0, 1, 0, 0)];
	[whiteView setBackgroundColor:[UIColor whiteColor]];
	[whiteView setHidden:YES];
	[self.view addSubview:whiteView];
	
	zoomProduct = [[UIImageView alloc]initWithFrame:CGRectMake( 0, 1, 130, 150)];
	[zoomProduct setBackgroundColor:[UIColor clearColor]];
	[zoomProduct setHidden:YES];
	[self.view addSubview:zoomProduct];
	
	UIActivityIndicatorView *loadingIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(50, 70, 25, 25)];
	[loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
	[loadingIndicator startAnimating];
	[loadingIndicator setTag:10001];
	[productImg addSubview:loadingIndicator];
	[loadingIndicator release];
	
    // Stop loading indicator if display image is displayed
	imgTimer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(CheckImageLoading) userInfo:nil repeats:YES];
	
	NSString *strText=[NSString stringWithFormat:@"%@",[dicProduct valueForKey:@"sName"]];
	CGSize size=[strText sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size :16] constrainedToSize:CGSizeMake(160,500) lineBreakMode:UILineBreakModeWordWrap];
	int yName=size.height;
	
    if (yName>40)
    {
        yName=40;
    }
    
	UILabel *lblProductName = [[UILabel	alloc]initWithFrame:CGRectMake(152,17,160,yName)];
	[lblProductName setBackgroundColor:[UIColor clearColor]];
	lblProductName.textColor=_savedPreferences.headerColor;
	[lblProductName setNumberOfLines:2];
	[lblProductName setLineBreakMode:UILineBreakModeWordWrap];
	[lblProductName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
	[lblProductName setTextAlignment:UITextAlignmentLeft];
	[lblProductName setText:[dicProduct valueForKey:@"sName"]];
    [contentScrollView addSubview:lblProductName];
	[lblProductName release];
	
	lblProductPrice = [[UILabel alloc]initWithFrame:CGRectMake(152, lblProductName.frame.origin.y+lblProductName.frame.size.height+2,160, 20)];
	[lblProductPrice setBackgroundColor:[UIColor clearColor]];
	lblProductPrice.textColor=_savedPreferences.labelColor;
	[lblProductPrice setTextAlignment:UITextAlignmentLeft];
    lblProductPrice.font=[UIFont boldSystemFontOfSize:14];
	[contentScrollView addSubview:lblProductPrice];
    
	lblStock = [[UILabel alloc]initWithFrame:CGRectMake(245, 40,160, 20)];
	[lblStock setBackgroundColor:[UIColor clearColor]];
	[lblStock layer].cornerRadius=8.0;
	lblStock.textColor=[UIColor whiteColor];
	[lblStock setTextAlignment:UITextAlignmentCenter];
	lblStock.font=[UIFont boldSystemFontOfSize:10.0];
    
	lblProductDiscount = [[UILabel alloc]initWithFrame:CGRectMake(148,lblProductPrice.frame.origin.y+lblProductPrice.frame.size.height+1, 160, 20)];
	[lblProductDiscount setBackgroundColor:[UIColor clearColor]];
	lblProductDiscount.textColor=_savedPreferences.labelColor;
	[lblProductDiscount setTextAlignment:UITextAlignmentLeft];
	lblProductDiscount.font=[UIFont boldSystemFontOfSize:14];
    
    NSString *strPrice=[NSString stringWithFormat:@"%@",[ProductPriceCalculation calculateProductPrice:dicProduct] ];
    [lblProductPrice setText:strPrice];
	
    // Display Stock Availability
    if (![[dicProduct valueForKey:@"fDiscountedPrice"] isEqual:[NSNull null]])
    {
        if ([[dicProduct objectForKey:@"fPrice"] floatValue]>[[dicProduct valueForKey:@"fDiscountedPrice"] floatValue])
        {
            NSString *strFinalProductPrice=[NSString stringWithFormat:@"%@",[ProductPriceCalculation calculateDiscountedPrice:dicProduct]];
            [lblProductDiscount setText:[NSString stringWithFormat:@"\n%@%@", _savedPreferences.strCurrencySymbol, strFinalProductPrice]];
        }
    }
	[contentScrollView addSubview:lblProductDiscount];
	
	if ([lblProductDiscount.text length]==0)
	{
		imgStock=[[UIImageView alloc]initWithFrame:CGRectMake(151,lblProductPrice.frame.origin.y+lblProductPrice.frame.size.height+4,56,17)];
	}
	else
    {
		imgStock=[[UIImageView alloc]initWithFrame:CGRectMake(151,lblProductDiscount.frame.origin.y+lblProductDiscount.frame.size.height+4,56,17)];
	}
	
	lblImgStock = [[UILabel alloc] initWithFrame:CGRectMake(imgStock.frame.origin.x, imgStock.frame.origin.y-1, imgStock.frame.size.width, imgStock.frame.size.height)];
	[lblImgStock setBackgroundColor:[UIColor clearColor]];
	[lblImgStock setTextColor:[UIColor whiteColor]];
	[lblImgStock setTextAlignment:UITextAlignmentCenter];
	[lblImgStock setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10]];
	
	[contentScrollView addSubview:imgStock];
	[contentScrollView addSubview:lblImgStock];
	
	
    // Displaying Cut Line on Discounted Price
	NSString *discount = [NSString stringWithFormat:@"%@", [dicProduct objectForKey:@"fDiscountedPrice"]];
	
    CGSize sizeDiscount = [[ProductPriceCalculation productActualPrice:dicProduct] sizeWithFont:[UIFont boldSystemFontOfSize:14]];
    
    
	
	if ((![discount isEqual:[NSNull null]]) && (![discount isEqualToString:@"<null>"]) && ([discount length]!=0))
	{
		if ([[dicProduct objectForKey:@"fPrice"] floatValue]>[discount floatValue])
		{
			UIImageView *imgCutLine = [[UIImageView alloc]initWithFrame:CGRectMake(150,lblProductPrice.frame.origin.y+lblProductPrice.frame.size.height/2, sizeDiscount.width+4,2)];
            
            [imgCutLine setBackgroundColor:_savedPreferences.labelColor];
            
            [contentScrollView addSubview:imgCutLine];
			[imgCutLine release];
		}
	}
	addToCartBtn=[UIButton buttonWithType:UIButtonTypeCustom];
	[addToCartBtn setBackgroundColor:navBarColor];
	[addToCartBtn setFrame:CGRectMake(154, 150, 162, 37)];
	[addToCartBtn setHidden:YES];
	[addToCartBtn addTarget:self action:@selector(addToCartMethod) forControlEvents:UIControlEventTouchUpInside];
	[[addToCartBtn layer] setCornerRadius:8.0];
	[addToCartBtn setBackgroundImage:[UIImage imageNamed:@"add_to_cart.png"] forState:UIControlStateNormal];
	[addToCartBtn setTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.mainproduct.addtocart"] forState:UIControlStateNormal];
	[addToCartBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
	[contentScrollView addSubview:addToCartBtn];
	
	BOOL isToBeCartShown;
	
    // Determine Product Status for iPhone
	NSString *striPhoneStatus = [dicProduct objectForKey:@"sIPhoneStatus"];
	
	if ((striPhoneStatus!=nil) &&(![striPhoneStatus isEqual:[NSNull null]]))
	{
		if ([striPhoneStatus isEqualToString:@"coming"] || [striPhoneStatus isEqualToString:@"Coming Soon"])
		{
			[imgStock setImage:[UIImage imageNamed:@"coming_soon.png"]];
			[imgStock setFrame:CGRectMake(imgStock.frame.origin.x, imgStock.frame.origin.y, 85, 17)];
			[lblImgStock setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.comming.soon"]];
			[lblImgStock setFrame:imgStock.frame];
			isToBeCartShown=NO;
			isComingSoonCheck=YES;
		}
		else if ([striPhoneStatus isEqualToString:@"sold"] || [striPhoneStatus isEqualToString:@"Sold Out"])
		{
			[imgStock setImage:[UIImage imageNamed:@"sold_out.png"]];
			[lblImgStock setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"]];
			[addToCartBtn setHidden:YES];
			isToBeCartShown=NO;
		}
		else if ([striPhoneStatus isEqualToString:@"active"])
		{
			[imgStock setImage:[UIImage imageNamed:@"instock_btn.png"]];
			[lblImgStock setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"]];
			[addToCartBtn setHidden:NO];
			isToBeCartShown=YES;
		}
	}
	else
	{
		[imgStock setImage:[UIImage imageNamed:@"sold_out.png"]];
		[lblImgStock setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"]];
		[addToCartBtn setHidden:YES];
		isToBeCartShown=NO;
		
		
	}
	imgZoom = [[UIImageView alloc]initWithFrame:CGRectMake(10,18, 27, 27)];
	[imgZoom setBackgroundColor:[UIColor clearColor]];
	[imgZoom setImage:[UIImage imageNamed:@"new_search.png"]];
	[contentScrollView addSubview:imgZoom];
	
	btnZoom = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnZoom setFrame:CGRectMake(10, 10, 130, 150)];
	[btnZoom setBackgroundColor:[UIColor clearColor]];
	[btnZoom addTarget:self action:@selector(zoomMethod) forControlEvents:UIControlEventTouchUpInside];
    [contentScrollView addSubview:btnZoom];
    
    
	optionBtn[0]=[UIButton buttonWithType:UIButtonTypeCustom];
	[optionBtn[0] setBackgroundColor:[UIColor clearColor]];
	[optionBtn[0] setFrame:CGRectMake(130,imgStock.frame.origin.y+imgStock.frame.size.height+15,210,29)];
	[optionBtn[0] setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
	[optionBtn[0] setTag:0];
	[optionBtn[0] addTarget:self action:@selector(createTableView:) forControlEvents:UIControlEventTouchUpInside];
	[contentScrollView addSubview:optionBtn[0]];
	
	lblOption[0] = [[UILabel alloc]initWithFrame:CGRectMake(160,imgStock.frame.origin.y+imgStock.frame.size.height+15,115, 29)];
    
	[lblOption[0] setTextAlignment:UITextAlignmentCenter];
	[lblOption[0] setBackgroundColor:[UIColor clearColor]];
	lblOption[0].textColor=[UIColor blackColor];
	lblOption[0].font=[UIFont systemFontOfSize:12];
	if([arrDropDown[0] count]>0)
		[lblOption[0] setText:[[NSString stringWithFormat:@"Select %@",[[arrDropDown[0] objectAtIndex:0]valueForKey:@"sTitle"]]capitalizedString]];
	[contentScrollView addSubview:lblOption[0]];
	
	
	for(int countTemp=1;countTemp<=dropDownCount;countTemp++)
	{
		
		optionBtn[countTemp]=[UIButton buttonWithType:UIButtonTypeCustom];
		[optionBtn[countTemp] setBackgroundColor:[UIColor clearColor]];
		[optionBtn[countTemp] setFrame:CGRectMake(130,optionBtn[countTemp-1].frame.origin.y+optionBtn[countTemp-1].frame.size.height+8,210,29)];
		[optionBtn[countTemp] setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
		[optionBtn[countTemp] setTag:countTemp];
		[optionBtn[countTemp] addTarget:self action:@selector(createTableView:) forControlEvents:UIControlEventTouchUpInside];
		[contentScrollView addSubview:optionBtn[countTemp]];
		
		lblOption[countTemp] = [[UILabel alloc]initWithFrame:CGRectMake(130,optionBtn[countTemp-1].frame.origin.y+optionBtn[countTemp-1].frame.size.height+8,170, 29)];
		[lblOption[countTemp] setTextAlignment:UITextAlignmentCenter];
		[lblOption[countTemp] setBackgroundColor:[UIColor clearColor]];
		lblOption[countTemp].textColor=[UIColor blackColor];
		[lblOption[countTemp] setText:[[NSString stringWithFormat:@"Select %@",[[arrDropDown[countTemp] objectAtIndex:0]valueForKey:@"sTitle"]]capitalizedString]];
		lblOption[countTemp].font=[UIFont systemFontOfSize:12];
		
		
		[contentScrollView addSubview:lblOption[countTemp]];
		
	}
	
    
	if ([[dicProduct valueForKey:@"bUseOptions"] boolValue]==TRUE)
	{
		if(isWishlist)
		{
			[imgStock setHidden:NO];
			[lblImgStock setHidden:NO];
			if(isComingSoonCheck==NO)
			{
                NSArray *arrOptions=[optionIndex componentsSeparatedByString:@","];
                if([arrOptions count]==0||[optionArray count]==0)
                {
                    [addToCartBtn setHidden:YES];
                    [imgStock setImage:[UIImage imageNamed:@"sold_out.png"]];
                    [lblImgStock setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"]];
                    
                    
                }
                
                
                NSMutableArray *arrProductOptionSize = [[[NSMutableArray alloc] init] autorelease];
                
                for(int i=0; i<[optionArray count]; i++)
                {
                    [arrProductOptionSize addObject:[[optionArray objectAtIndex:i] valueForKey:@"id"]];
                }
                BOOL isContained=YES;
                int optionSizeIndex[100];
                float optionPrice=0;
                for(int i=0;i<[arrOptions count];i++)
                {
                    if([arrProductOptionSize containsObject: [NSNumber numberWithInt:[[arrOptions objectAtIndex:i] integerValue]]])
                    {
                        optionSizeIndex[i] =[arrProductOptionSize indexOfObject:[NSNumber numberWithInt:[[arrOptions objectAtIndex:i]intValue]]];
                        
                        optionPrice+=[[[optionArray objectAtIndex:optionSizeIndex[i]]valueForKey:@"pPrice"]floatValue];
                        
                        
                        
                    }
                    else {
                        [addToCartBtn setHidden:YES];
                        [imgStock setImage:[UIImage imageNamed:@"sold_out.png"]];
                        [lblImgStock setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"]];
                        
                        isContained=NO;
                        
                    }
                    //-----------setoption price---------------
                    
                    
                    
                    NSString *strPrice=[NSString stringWithFormat:@"%@",[ProductPriceCalculation caluatePriceOptionProduct: dicProduct pPrice:optionPrice] ];
                    
                    if (![[dicProduct valueForKey:@"fDiscountedPrice"] isEqual:[NSNull null]])
                    {
                        
                        if ([[dicProduct objectForKey:@"fPrice"] floatValue]>[[dicProduct valueForKey:@"fDiscountedPrice"] floatValue])
                        {
                            [lblProductDiscount setText:[NSString stringWithFormat:@"%@",[ProductPriceCalculation caluateOriginalPriceOptionProduct: dicProduct pPrice:optionPrice] ]];
                        }
                        
                        [lblProductPrice setText:strPrice];
                        
                        
                        
                    }else
                    {
                        [lblProductPrice setText:strPrice];
                    }
                    
                    
                    
                    
                    
                    
                }
                if(![optionArray isKindOfClass:[NSNull class]])
                {
                    if([optionArray count]>0)
                    {
                        if(isContained==YES)
                        {
                            for(int count=0;count<[arrOptions count];count++)
                            {
                                if([[[optionArray objectAtIndex:optionSizeIndex[count]] valueForKey:@"iAvailableQuantity"] intValue] == 0)
                                {
                                    [addToCartBtn setHidden:YES];
                                    [imgStock setImage:[UIImage imageNamed:@"sold_out.png"]];
                                    [lblImgStock setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"]];
                                    break;
                                    
                                }
                                else {
                                    [imgStock setImage:[UIImage imageNamed:@"instock_btn.png"]];
                                    [lblImgStock setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"]];
                                    [addToCartBtn setHidden:NO];
                                }
                                
                            }
                        }
                    }
                    
                    
                }
            }
            
			else {
				[addToCartBtn setHidden:YES];
				
			}
		}
        
	}
    
	else
	{
		[imgStock setHidden:NO];
		[lblImgStock setHidden:NO];
		
		
		
		if (![[dicProduct valueForKey:@"bStockControl"]isEqual:[NSNull null]])
		{
			if ([[dicProduct valueForKey:@"bStockControl"] boolValue] ==TRUE)
			{
				[optionBtn[0] setHidden:YES];
				[lblOption[0] setHidden:YES];
				for(int countTemp1=1;countTemp1<=dropDownCount;countTemp1++)
				{
					[optionBtn[countTemp1] setHidden:YES];
					[lblOption[countTemp1] setHidden:YES];
				}
				
				if ([[dicProduct valueForKey:@"iAggregateQuantity"]intValue]!=0 && isToBeCartShown==YES)
				{
					[addToCartBtn setHidden:NO];
                    
				}
				else
				{
					[addToCartBtn setHidden:YES];
                    [imgStock setImage:[UIImage imageNamed:@"sold_out.png"]];
                    [lblImgStock setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"]];
					
				}
			}
			else
            {
				
				[optionBtn[0] setHidden:YES];
				[lblOption[0] setHidden:YES];
				for(int countTemp1=1;countTemp1<=dropDownCount;countTemp1++)
				{
					[optionBtn[countTemp1] setHidden:YES];
					[lblOption[countTemp1] setHidden:YES];
				}
				
			}
		}
		
        
	}
    NSDictionary* dict=[dicProduct valueForKey:@"productOptions"];
    
    if (![[dicProduct valueForKey:@"bStockControl"]isEqual:[NSNull null]])
    {
        if ([[dicProduct valueForKey:@"bStockControl"] boolValue] ==FALSE)
        {
            
            if ([dict count]==0)
            {
                [optionBtn[0] setHidden:YES];
                [lblOption[0] setHidden:YES];
                [imgStock setImage:[UIImage imageNamed:@"sold_out.png"]];
                [lblImgStock setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"]];
                [addToCartBtn setHidden:YES];
                
            }
        }
    }
    
	UILabel *lblWishlist = [[UILabel alloc] init];
	if (isWishlist)
	{
		
		[optionBtn[0] setHidden:YES];
		[lblOption[0] setHidden:YES];
		for(int countTemp1=1;countTemp1<=dropDownCount;countTemp1++)
		{
			[optionBtn[countTemp1] setHidden:YES];
			[lblOption[countTemp1] setHidden:YES];
		}
		
		
		
	}
	if (!isWishlist)
	{
		addToWishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
		[addToWishBtn setBackgroundColor:[UIColor clearColor]];
		[addToWishBtn addTarget:self action:@selector(addToWishMethod) forControlEvents:UIControlEventTouchUpInside];
		[addToWishBtn setBackgroundImage:[UIImage imageNamed:@"new_wishlist.png"] forState:UIControlStateNormal];
		[addToWishBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
		[contentScrollView addSubview:addToWishBtn];
		
		[lblWishlist setBackgroundColor:[UIColor clearColor]];
		[contentScrollView addSubview:lblWishlist];
		[lblWishlist setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.mainproduct.addwishlist"]];
		[lblWishlist setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
		[lblWishlist setTextAlignment:UITextAlignmentLeft];
		[lblWishlist setLineBreakMode:UILineBreakModeWordWrap];
		[lblWishlist setNumberOfLines:2];
		[lblWishlist setTextColor:[UIColor whiteColor]];
    }
	
	if (optionBtn[0].hidden==YES)
    {
        [addToCartBtn setFrame:CGRectMake(154,imgStock.frame.origin.y+imgStock.frame.size.height+20, 162, 37)];
    }
	else
    {
        [addToCartBtn setFrame:CGRectMake(154,optionBtn[dropDownCount].frame.origin.y+optionBtn[dropDownCount].frame.size.height+20, 162, 37)];
    }
	
	
	UILabel *lblDescriptionDetails = [[UILabel alloc]initWithFrame:CGRectMake(10,185, 300, 29)];
    [lblDescriptionDetails setBackgroundColor:[UIColor clearColor]];
	lblDescriptionDetails.textColor=_savedPreferences.labelColor;
	lblDescriptionDetails.font =[UIFont fontWithName:@"Helvetica" size:13.0];
    [lblDescriptionDetails setNumberOfLines:0];
	[lblDescriptionDetails setLineBreakMode:UILineBreakModeWordWrap];
	[lblDescriptionDetails setText:[dicProduct objectForKey:@"sDescription"]];
	[contentScrollView addSubview:lblDescriptionDetails];
	
	CGRect frame = [lblDescriptionDetails frame];
	CGSize sizeName = [lblDescriptionDetails.text sizeWithFont:lblDescriptionDetails.font
											 constrainedToSize:CGSizeMake(frame.size.width-10, 9999)
												 lineBreakMode:UILineBreakModeWordWrap];
	frame.size.height = sizeName.height;
	[lblDescriptionDetails setFrame:frame];
	
	if(addToCartBtn.hidden==NO)
	{
		
		int y=addToCartBtn.frame.origin.y+addToCartBtn.frame.size.height;
		if(y>175)
		{
			[lblDescriptionDetails setFrame:CGRectMake(frame.origin.x,addToCartBtn.frame.origin.y+addToCartBtn.frame.size.height+20, frame.size.width-20, frame.size.height)];
		}
	}
	else if(optionBtn[0].hidden==NO)
	{
		int y=optionBtn[dropDownCount].frame.origin.y+optionBtn[dropDownCount].frame.size.height;
		if(y>175)
		{
			[lblDescriptionDetails setFrame:CGRectMake(frame.origin.x,optionBtn[dropDownCount].frame.size.height+optionBtn[dropDownCount].frame.origin.y+20, frame.size.width, frame.size.height)];
		}
		
	}
	else {
		[lblDescriptionDetails setFrame:CGRectMake(frame.origin.x,185, frame.size.width, frame.size.height)];
	}
	
	if ((![[dicProduct objectForKey:@"sVideoUrl"] isEqual:[NSNull null]]) && (![[dicProduct objectForKey:@"sVideoUrl"] isEqualToString:@""]))
	{
		UIImageView *imgVideo = [[UIImageView alloc]initWithFrame:CGRectMake(9,lblDescriptionDetails.frame.origin.y+lblDescriptionDetails.frame.size.height+20,91,40)];
		[imgVideo setBackgroundColor:[UIColor clearColor]];
		[imgVideo setImage:[UIImage imageNamed:@"new_youtube.png"]];
		[contentScrollView addSubview:imgVideo];
		[imgVideo release];
		
		UILabel *lblYouTube = [[UILabel alloc] initWithFrame:CGRectMake(imgVideo.frame.origin.x+38, imgVideo.frame.origin.y+2, 55, 32)];
		[lblYouTube setBackgroundColor:[UIColor clearColor]];
		[contentScrollView addSubview:lblYouTube];
		[lblYouTube setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.mainproduct.watchvideo"]];
		[lblYouTube setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
		[lblYouTube setTextAlignment:UITextAlignmentLeft];
		[lblYouTube setLineBreakMode:UILineBreakModeWordWrap];
		[lblYouTube setNumberOfLines:2];
		[lblYouTube setTextColor:[UIColor whiteColor]];
		[lblYouTube release];
		
		
		UIButton *videoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
		[videoBtn setBackgroundColor:[UIColor clearColor]];
		[videoBtn addTarget:self action:@selector(navToVideo) forControlEvents:UIControlEventTouchUpInside];
		[videoBtn setShowsTouchWhenHighlighted:YES];
		[videoBtn setFrame:CGRectMake( 5, lblDescriptionDetails.frame.origin.y+lblDescriptionDetails.frame.size.height+20, 95,40)];
		[contentScrollView addSubview:videoBtn];
	}
	
	lblStock.text = [lblStock.text uppercaseString];
	UIImageView *imgMail = [[UIImageView alloc]initWithFrame:CGRectMake(113, lblDescriptionDetails.frame.origin.y+lblDescriptionDetails.frame.size.height+20,94, 40)];
	[imgMail setBackgroundColor:[UIColor clearColor]];
	[imgMail setImage:[UIImage imageNamed:@"new_email.png"]];
	[contentScrollView addSubview:imgMail];
	[imgMail release];
	
	UILabel *lblSendMail = [[UILabel alloc] initWithFrame:CGRectMake(imgMail.frame.origin.x+38, imgMail.frame.origin.y+2, 55, 32)];
	[lblSendMail setBackgroundColor:[UIColor clearColor]];
	[contentScrollView addSubview:lblSendMail];
	[lblSendMail setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.mainproduct.sendtofriend"]];
	[lblSendMail setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
	[lblSendMail setTextAlignment:UITextAlignmentLeft];
	[lblSendMail setLineBreakMode:UILineBreakModeWordWrap];
	[lblSendMail setNumberOfLines:2];
	[lblSendMail setTextColor:[UIColor whiteColor]];
	[lblSendMail release];
	
	UIButton *sendMailBtn=[UIButton buttonWithType:UIButtonTypeCustom];
	[sendMailBtn setBackgroundColor:[UIColor clearColor]];
	[sendMailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[sendMailBtn addTarget:self action:@selector(sendFeedBack) forControlEvents:UIControlEventTouchUpInside];
	[sendMailBtn setFrame:CGRectMake( 113, lblDescriptionDetails.frame.origin.y+lblDescriptionDetails.frame.size.height+20,95,40)];
	[contentScrollView addSubview:sendMailBtn];
	[sendMailBtn setShowsTouchWhenHighlighted:YES];
	
	[addToWishBtn setFrame:CGRectMake(220,lblDescriptionDetails.frame.origin.y+lblDescriptionDetails.frame.size.height+20,96,40)];
	[lblWishlist setFrame:CGRectMake(addToWishBtn.frame.origin.x+38, addToWishBtn.frame.origin.y+2, 55, 32)];
	[lblWishlist release];
	UIView *viewBottomBar=[[UIView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake(0,330, 320, 40) chageHieght:NO]];
	[viewBottomBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom_bar.png"]]];
    [contentView addSubview:viewBottomBar];
	
	lblReadReviews=[[UILabel alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake(145, 338, 85,20) chageHieght:NO]];
    [lblReadReviews setTextColor:[UIColor whiteColor]];
	[lblReadReviews setTextAlignment:UITextAlignmentCenter];
    [lblReadReviews setFont:[UIFont boldSystemFontOfSize:14.00]];
    
    if ([[dicProduct valueForKey:@"productReviews"]count]>1)
    {
        [lblReadReviews setText:[NSString stringWithFormat:@"%d %@",[[dicProduct valueForKey:@"productReviews"]count],[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.mainproduct.reviews"]]];
    }
    else
    {
        [lblReadReviews setText:[NSString stringWithFormat:@"%d %@",[[dicProduct valueForKey:@"productReviews"]count],[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.mainproduct.reviews"]]];
    }
    
    [lblReadReviews setBackgroundColor:[UIColor clearColor]];
    [contentView addSubview:lblReadReviews];
	
    UIButton *btnReadReviews=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnReadReviews setFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake(140, 338, 70, 20) chageHieght:NO]];
    [[btnReadReviews layer]setCornerRadius:20.0];
	[btnReadReviews setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[btnReadReviews addTarget:self action:@selector(navigateToReadReview) forControlEvents:UIControlEventTouchUpInside];
	[contentView addSubview:btnReadReviews];
    
    UIButton *btnPostReview=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnPostReview setFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake(233,338, 83, 21) chageHieght:NO]];
    [btnPostReview setBackgroundImage:[UIImage imageNamed:@"post_review.png"] forState:UIControlStateNormal];
	[btnPostReview setTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.mainproduct.postreview"] forState:UIControlStateNormal];
	[btnPostReview.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [btnPostReview addTarget:self action:@selector(navigateToPostReview) forControlEvents:UIControlEventTouchUpInside];
	
	[contentView addSubview:btnPostReview];
	[btnPostReview setShowsTouchWhenHighlighted:YES];
    if([GlobalPreferences isScreen_iPhone5])
        [contentScrollView setContentSize:CGSizeMake(320, sendMailBtn.frame.origin.y+sendMailBtn.frame.size.height+40+88)];
    else
        [contentScrollView setContentSize:CGSizeMake(320, sendMailBtn.frame.origin.y+sendMailBtn.frame.size.height+40)];
	NSArray  *arrImagesUrls = [dicProduct objectForKey:@"productImages"];
	if ([arrImagesUrls count]>1)
	{
		btnLeftArrow = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnLeftArrow setFrame:CGRectMake(13, 160, 30, 30)];
		[btnLeftArrow setBackgroundColor:[UIColor clearColor]];
		[btnLeftArrow setBackgroundImage:[UIImage imageNamed:@"left_trans_arrow.png"] forState:UIControlStateNormal];
		[btnLeftArrow addTarget:self action:@selector(previousImageBtn) forControlEvents:UIControlEventTouchUpInside];
		btnLeftArrow.hidden = TRUE;
		
		btnRightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnRightArrow setFrame:CGRectMake(110, 160, 30, 30)];
		
		[btnRightArrow setBackgroundImage:[UIImage imageNamed:@"right_trans_arrow.png"] forState:UIControlStateNormal];
		[btnRightArrow addTarget:self action:@selector(nextImageBtn) forControlEvents:UIControlEventTouchUpInside];
	}
}
- (void)CheckImageLoading
{
	if (productImg.image ||loadingStatus==NO)
	{
		UIActivityIndicatorView *loadingIndicatorTemp = (UIActivityIndicatorView *)[productImg viewWithTag:10001];
		[loadingIndicatorTemp stopAnimating];
		if ([imgTimer isValid])
        {
            [imgTimer invalidate];
        }
	}
	if(!productImg.image)
	{
		[imgZoom setHidden:YES];
		[btnZoom setHidden:YES];
		
        
	}
	else {
		[imgZoom setHidden:NO];
		[btnZoom setHidden:NO];
		
	}
    
	
	
}
- (void)createTableView:(UIButton *)sender
{
	
	index=[sender tag];
	
	if (optionTableView)
	{
		[optionTableView setHidden:YES];
		[optionTableView release];
		optionTableView=nil;
	}
	
	if(index!=pastIndex)
		
	{
		
		if(arrDropDownTable)
		{
			[arrDropDownTable	release];
			arrDropDownTable=nil;
			
		}
		arrDropDownTable=[[NSArray alloc]initWithArray:arrDropDown[index]];
		
		
		
		optionTableView=[[UITableView alloc]initWithFrame:CGRectMake(144
																	 ,optionBtn[index].frame.origin.y+optionBtn[index].frame.size.height-15, 180, 200) style:UITableViewStyleGrouped];
		optionTableView.delegate=self;
		optionTableView.dataSource=self;
        optionTableView.backgroundView=nil;
		[optionTableView setBackgroundColor:[UIColor clearColor]];
		pastIndex=index;
		[contentScrollView addSubview:optionTableView];
		
		
	}
	else
	{
		pastIndex=-1;
	}
	
	
}


- (void)navToVideo
{
	webViewVideo *_webViewVideo = [[webViewVideo alloc]init];
	_webViewVideo.strVideo  = [dicProduct objectForKey:@"sVideoUrl"];
    
	if (([[dicProduct objectForKey:@"sVideoTitle"] isEqual:[NSNull null]]) || (![dicProduct objectForKey:@"sVideoTitle"]) || ([[dicProduct objectForKey:@"sVideoTitle"] isEqualToString:@""]))
    {
        _webViewVideo.navigationItem.title = @"Video";
    }
	else
    {
        _webViewVideo.navigationItem.title=	[dicProduct objectForKey:@"sVideoTitle"];
    }
	
	[self.navigationController pushViewController:_webViewVideo animated:YES];
	[_webViewVideo release];
}

#pragma mark Add To Shopping Cart
- (void)addToCartMethod
{
	if(!isWishlist)
	{
		
		BOOL isAllOptionsSelected=YES;
		
		if (![[dicProduct valueForKey:@"bUseOptions"] intValue]==0)
		{
			
			for(int i=0;i<=dropDownCount;i++)
            {
                
                if([[lblOption[i].text lowercaseString]  isEqualToString:[[NSString stringWithFormat:@"Select %@",[[arrDropDown[i] objectAtIndex:0]objectForKey:@"sTitle"]]lowercaseString]])
                {
                    
                    isAllOptionsSelected=NO;
                    break;
                }
            }
		}
		
		if(isAllOptionsSelected==NO)
			
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		}
	    else
	    {
			NSMutableArray *arrAddedToShoppingCart = [[SqlQuery shared]getShoppingCartProductIDs:NO];
			NSMutableArray *arrProductID = [[[NSMutableArray alloc] init] autorelease];
			arrProductID = [arrAddedToShoppingCart valueForKey:@"id"];
			
			NSMutableArray *arrProductSize = [[[NSMutableArray alloc] init] autorelease];
			arrProductSize = [[SqlQuery shared] getShoppingProductSizes:[[dicProduct objectForKey:@"id"]intValue]];
			
			BOOL isContained =NO;
			BOOL isTobeAdded=YES;
            
            
			if ([[dicProduct valueForKey:@"bUseOptions"] intValue]==0)
			{
				if ([arrProductSize count] !=0)
				{
					for(int i=0;i<[arrProductSize count];i++)
					{
						if ([[arrProductSize objectAtIndex:i] isEqualToString:@"0"])
						{
							isContained =YES;
							break;
						}
						
					}
				}
			}
			
			else {
				
                if([arrProductSize count]>0)
                {
                    
                    for(int count=0;count<[arrProductSize count];count++)
                    {
                        if(isContained==NO)
                        {
                            
                            NSArray *arrOptions=[[arrProductSize objectAtIndex:count] componentsSeparatedByString:@","];
                            if([arrOptions count]==dropDownCount+1)
                            {
                                for(int count=0;count<=dropDownCount;count++)
                                    
                                {
                                    NSLog(@"%d",selectedIndex[count]);
                                    NSNumber *optionID = [NSNumber numberWithInt:[[[arrDropDown[count] objectAtIndex:selectedIndex[count]] valueForKey:@"id"] intValue]];
                                    
                                    
                                    if ([arrOptions containsObject:[optionID stringValue]])
                                        
                                    {
                                        isContained=YES;
                                    }
                                    else
                                    {
                                        isContained=NO;
                                        break;
                                    }
                                }
                            }
                            
                            
                        }
                        else
                        {
                            break;
                        }
                        
                    }
                }
                
                
                
                
                NSMutableArray * arrSameProductOptions=[[NSMutableArray alloc]init];
                if([arrAddedToShoppingCart count]>0)
                {
                    for(int count=0;count<[arrAddedToShoppingCart count];count++)
                    {
                        if([[[arrAddedToShoppingCart objectAtIndex:count] valueForKey:@"id"]intValue]==[[dicProduct objectForKey:@"id"]intValue])
                        {
                            [arrSameProductOptions addObject:[arrAddedToShoppingCart objectAtIndex:count]];
                            
                        }
                        
                        
                    }
                    
                }
                
                int quantityAdded[100];
                int minQuantityCheck[100];
                for(int i=0;i<=dropDownCount;i++)
                {
                    quantityAdded[i]=0;
                    minQuantityCheck[i]=0;
                    
                }
                
                for(int i=0;i<=dropDownCount;i++)
                {
                    for(int j=0;j<[arrSameProductOptions count];j++)
                    {
                        
                        NSArray *arrayOptions=[[[arrSameProductOptions objectAtIndex:j]valueForKey:@"pOptionId"] componentsSeparatedByString:@","];
                        
                        for(int k=0;k<[arrayOptions count];k++)
                        {
                            
                            if([[[arrDropDown[i] objectAtIndex:selectedIndex[i]]valueForKey:@"id"]intValue]==[[arrayOptions objectAtIndex:k]intValue])
                            {
                                
                                quantityAdded[i]=quantityAdded[i]+[[[arrSameProductOptions objectAtIndex:j]objectForKey:@"quantity"]intValue];
                            }
                        }
                        
                    }
                }
                for(int count=0;count<=dropDownCount;count++)
                {
                    minQuantityCheck[count]=[[[arrDropDown[count] objectAtIndex:selectedIndex[count]]objectForKey:@"iAvailableQuantity"]intValue];
                    
                    if((quantityAdded[count]<100&&quantityAdded[count]>0))
                    {
                        
                        minQuantityCheck[count]=[[[arrDropDown[count] objectAtIndex:selectedIndex[count]]objectForKey:@"iAvailableQuantity"]intValue]-quantityAdded[count];
                        
                        
                    }
                    NSLog(@"%d", minQuantityCheck[count]);
                    
                }
                
                
                if (!([[dicProduct valueForKey:@"bUseOptions"] intValue]==0))
                {
                    int max=0;
                    
                    if (dropDownCount>=0)
                    {
                        max=minQuantityCheck[0];
                    }
                    
                    for(int i=1;i<=dropDownCount;i++)
                    {
                        if(max>minQuantityCheck[i])
                            max=minQuantityCheck[i];
                        
                    }
                    
                    
                    if(max<=0)
                    {
                        
                        isTobeAdded=NO;
                        
                    }
                    
                }
                
            }
            if ([arrProductID containsObject:[NSString stringWithFormat:@"%@", [dicProduct objectForKey:@"id"]]] && isContained)
			{
				UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.product.alreadyadded.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
			
			else if(isTobeAdded==NO)
			{
				
				UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:@"Product cannot be added to  cart" delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
				[alert show];
				[alert release];
				
			}
			
			
			else
			{
				NSString *strProductOptions=@"";
				
				// Convert product image into NSData, so it can be saved into the sqlite3 database
				if ([[dicProduct valueForKey:@"bUseOptions"] intValue]==0)
				{
					strProductOptions=@"0";
					[[SqlQuery shared] setTblShoppingCart:[[dicProduct objectForKey:@"id"] intValue] :1:strProductOptions];
					[GlobalPreferences setCurrentItemsInCart:YES];
					
				}
				else
				{
					if ([optionArray count]>0)
					{
						for(int count=0;count<=dropDownCount;count++)
						{
							if(count==dropDownCount)
							{
								strProductOptions=[strProductOptions   stringByAppendingFormat:@"%@",[[arrDropDown[count] objectAtIndex:selectedIndex[count]]objectForKey:@"id"]];
							}
							else
							{
								strProductOptions=[strProductOptions stringByAppendingFormat:@"%@,",[[arrDropDown[count] objectAtIndex:selectedIndex[count]]objectForKey:@"id"]];
							}
						}
						[[SqlQuery shared] setTblShoppingCart:[[dicProduct objectForKey:@"id"] intValue]:1:strProductOptions];
						
						[GlobalPreferences setCurrentItemsInCart:YES];
						
						
						
					}
					else
					{
						UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.title"] message:@"This product can not be added to cart" delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
						[alert show];
						[alert release];
					}
				}
				
				
				SystemSoundID soundID;
				NSURL *filePath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] resourcePath], @"/pickup_coin.wav"] isDirectory:NO];
				AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
				AudioServicesPlaySystemSound(soundID);
				
				for(UILabel *lblTemp in [self.navigationController.navigationBar subviews])
				{
					if ([lblTemp isKindOfClass:[UILabel class]])
					{
						lblTemp.text = [NSString stringWithFormat:@"%d",iNumOfItemsInShoppingCart];
						break;
					}
				}
				
				viewForAnimationEffect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
				[viewForAnimationEffect setBackgroundColor:[UIColor clearColor]];
				[contentScrollView addSubview:viewForAnimationEffect];
				
				UIImageView* rotatingImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
				if ([dicProduct count]>0)
				{
					[rotatingImage setImage:productImg.image];
				}
				else
				{
					[rotatingImage setImage:[UIImage imageNamed:@"Icon.png"]];
				}
				
				CATransform3D rotationTransform = CATransform3DMakeRotation(1.0f * M_PI, 0, 0, 1.0);
				CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
				
				rotationAnimation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
				rotationAnimation.duration = 0.25f;
				rotationAnimation.cumulative = YES;
				rotationAnimation.repeatCount = 5;
				
				[rotatingImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
				[viewForAnimationEffect addSubview:rotatingImage];
				
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationBeginsFromCurrentState:YES];
				[UIView setAnimationDuration:0.5];
				rotatingImage.frame = CGRectMake(300,0, 0, 0);
				[UIView setAnimationDelegate:self];
				
				[UIView setAnimationDidStopSelector:@selector(animationEnded:)];
				[UIView commitAnimations];
				
				[rotatingImage release];
				
				
				
				
			}
			
		}
		
		// Save the data in global preferences //YES, if the item is added, //NO if item is deleted from the cart
		
	}
	
	else {
		
		
		NSMutableArray *arrAddedToShoppingCart = [[SqlQuery shared]getShoppingCartProductIDs:NO];
		NSMutableArray *arrProductID = [[[NSMutableArray alloc] init] autorelease];
	    arrProductID = [arrAddedToShoppingCart valueForKey:@"id"];
		
	    NSMutableArray *arrProductSize = [[[NSMutableArray alloc] init] autorelease];
	    arrProductSize = [[SqlQuery shared] getShoppingProductSizes:[[dicProduct objectForKey:@"id"]intValue]];
		NSArray *wishlistOptions=[optionIndex componentsSeparatedByString:@","];
	  	
		BOOL isContained =NO;
		BOOL isTobeAdded=YES;
        
		
		if ([[dicProduct valueForKey:@"bUseOptions"] intValue]==0)
		{
			if ([arrProductSize count] !=0)
			{
				for(int i=0;i<[arrProductSize count];i++)
				{
					if ([[arrProductSize objectAtIndex:i] isEqualToString:@"0"])
					{
						isContained =YES;
						break;
					}
					
				}
			}
		}
		
		
		else {
			
			if([arrProductSize count]>0)
		    {
                
                for(int count=0;count<[arrProductSize count];count++)
                {
                    if(isContained==NO)
                    {
                        
                        NSArray *arrOptions=[[arrProductSize objectAtIndex:count] componentsSeparatedByString:@","];
                        if([arrOptions count]==[wishlistOptions count])
                        {
                            for(int count=0;count<[wishlistOptions count];count++)
                                
                            {
                                NSNumber *optionID = [NSNumber numberWithInt:[[wishlistOptions objectAtIndex:count] intValue]];
                                
                                
                                if ([arrOptions containsObject:[optionID stringValue]])
                                    
                                {
                                    isContained=YES;
                                }
                                else
                                {
                                    isContained=NO;
                                    break;
                                }
                            }
                        }
                        
                        
                    }
                    else
                    {
                        break;
                    }
                    
                }
            }
            
            
            
            
            int optionSizeIndex[100];
            
            
            
            NSMutableArray *arrProductOptionSize = [[[NSMutableArray alloc] init] autorelease];
            
            for(int i=0; i<[optionArray count]; i++)
            {
                [arrProductOptionSize addObject:[[optionArray objectAtIndex:i] valueForKey:@"id"]];
            }
            
            
            
            for(int i=0;i<[wishlistOptions count];i++)
            {
                
                if([arrProductOptionSize containsObject: [NSNumber numberWithInt:[[wishlistOptions objectAtIndex:i] integerValue]]])
                {
                    optionSizeIndex[i] =[arrProductOptionSize indexOfObject:[NSNumber numberWithInt:[[wishlistOptions objectAtIndex:i]intValue]]];
                    NSLog(@"%d",optionSizeIndex[i]);
                    
                }
            }
            
            
            
            NSMutableArray * arrSameProductOptions=[[NSMutableArray alloc]init];
            
            if([arrAddedToShoppingCart count]>0)
            {
                for(int count=0;count<[arrAddedToShoppingCart count];count++)
                {
                    if([[[arrAddedToShoppingCart objectAtIndex:count] valueForKey:@"id"]intValue]==[[dicProduct objectForKey:@"id"]intValue])
                    {
                        [arrSameProductOptions addObject:[arrAddedToShoppingCart objectAtIndex:count]];
                        
                    }
                    
                    
                }
                
            }
            
            int quantityAdded[100];
            
            for(int i=0;i<[wishlistOptions count];i++)
                
            {
                quantityAdded[i]=0;
            }
            
            
            
            for(int i=0;i<[wishlistOptions count];i++)
            {
                for(int j=0;j<[arrSameProductOptions count];j++)
                {
                    
                    NSArray *arrayOptions=[[[arrSameProductOptions objectAtIndex:j]valueForKey:@"pOptionId"] componentsSeparatedByString:@","];
                    
                    for(int k=0;k<[arrayOptions count];k++)
                    {
                        
                        if([[wishlistOptions objectAtIndex:i]intValue]==[[arrayOptions objectAtIndex:k]intValue])
                        {
                            
                            quantityAdded[i]=quantityAdded[i]+[[[arrSameProductOptions objectAtIndex:j]objectForKey:@"quantity"]intValue];
                            NSLog(@"%d",quantityAdded[i]);
                        }
                    }
                    
                }
            }
            
            int minimumQuantity=0;
            
            if ([wishlistOptions count]>0)
            {
                NSLog(@"%d",optionSizeIndex[0]);
                
                
                minimumQuantity=[[[optionArray objectAtIndex:optionSizeIndex[0]]objectForKey:@"iAvailableQuantity"]intValue];
            }
            for(int i=1;i<[wishlistOptions count];i++)
            {
                NSLog(@"%d",optionSizeIndex[i]);
                
                if(minimumQuantity>[[[optionArray objectAtIndex:optionSizeIndex[i]]objectForKey:@"iAvailableQuantity"]intValue])
                    minimumQuantity=[[[optionArray objectAtIndex:optionSizeIndex[i]]objectForKey:@"iAvailableQuantity"]intValue];
            }
            
            for(int i=0;i<[wishlistOptions count];i++)
            {
                if(quantityAdded[i]<100 && quantityAdded[i]>0)
                {
                    if(quantityAdded[i]>=minimumQuantity)
                        
                    {
                        isTobeAdded=NO;
                        break;
                    }
                }
            }
            
        }
		
		if ([arrProductID containsObject:[NSString stringWithFormat:@"%@", [dicProduct objectForKey:@"id"]]] && isContained)
		{
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.product.alreadyadded.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			[alert show];
			[alert release];		}
		
		else if(isTobeAdded==NO)
		{
			
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:@"Product cannot be added to  cart" delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		}
		
		else
		{
			NSString *strProductOptions=@"";
			
			// Convert product image into NSData, so it can be saved into the sqlite3 database
			if ([[dicProduct valueForKey:@"bUseOptions"] intValue]==0)
			{
				strProductOptions=@"0";
				[[SqlQuery shared] setTblShoppingCart:[[dicProduct objectForKey:@"id"] intValue] :1:strProductOptions];
				[GlobalPreferences setCurrentItemsInCart:YES];
				
			}
			else
			{
				if ([optionArray count]>0)
				{
					for(int count=0;count<[wishlistOptions count];count++)
					{
						if(count==[wishlistOptions count]-1)
						{
							strProductOptions=[strProductOptions   stringByAppendingFormat:@"%@",[wishlistOptions objectAtIndex:count]];
						}
						else
						{
							strProductOptions=[strProductOptions stringByAppendingFormat:@"%@,",[wishlistOptions objectAtIndex:count]];
						}
					}
					[[SqlQuery shared] setTblShoppingCart:[[dicProduct objectForKey:@"id"] intValue]:1:strProductOptions];
					
				    [GlobalPreferences setCurrentItemsInCart:YES];
					
				}
				else
	            {
					UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.title"] message:@"This product can not be added to cart" delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
					[alert show];
					[alert release];
	            }
			}
			
			
			
			for(UILabel *lblTemp in [self.navigationController.navigationBar subviews])
			{
				if ([lblTemp isKindOfClass:[UILabel class]])
				{
					lblTemp.text = [NSString stringWithFormat:@"%d",iNumOfItemsInShoppingCart];
					break;
				}
			}
			
			SystemSoundID soundID;
			NSURL *filePath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] resourcePath], @"/pickup_coin.wav"] isDirectory:NO];
			AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
			AudioServicesPlaySystemSound(soundID);
			
			viewForAnimationEffect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
			[viewForAnimationEffect setBackgroundColor:[UIColor clearColor]];
			[contentScrollView addSubview:viewForAnimationEffect];
			
			UIImageView* rotatingImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
			if ([dicProduct count]>0)
			{
				[rotatingImage setImage:productImg.image];
			}
			else
			{
				[rotatingImage setImage:[UIImage imageNamed:@"Icon.png"]];
			}
			
			CATransform3D rotationTransform = CATransform3DMakeRotation(1.0f * M_PI, 0, 0, 1.0);
			CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
			
			rotationAnimation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
			rotationAnimation.duration = 0.25f;
			rotationAnimation.cumulative = YES;
			rotationAnimation.repeatCount = 5;
			
			[rotatingImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
			[viewForAnimationEffect addSubview:rotatingImage];
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationBeginsFromCurrentState:YES];
			[UIView setAnimationDuration:0.5];
			rotatingImage.frame = CGRectMake(300,0, 0, 0);
			[UIView setAnimationDelegate:self];
			
			[UIView setAnimationDidStopSelector:@selector(animationEnded:)];
			[UIView commitAnimations];
			
			[rotatingImage release];
			
			
			
		}
		
	}
	
}

- (void)animationEnded:(id)sender
{
	if (viewForAnimationEffect)
	{
		[viewForAnimationEffect removeFromSuperview];
		[viewForAnimationEffect release];
	}
}

#pragma mark Add To Wishlist
- (void)addToWishMethod
{
	BOOL isAllOptionsSelected=YES;
	
	if (![[dicProduct valueForKey:@"bUseOptions"] intValue]==0)
	{
        for(int i=0;i<=dropDownCount;i++)
        {
            
            if([[lblOption[i].text lowercaseString]  isEqualToString:[[NSString stringWithFormat:@"Select %@",[[arrDropDown[i] objectAtIndex:0]objectForKey:@"sTitle"]]lowercaseString]])
            {
                
                isAllOptionsSelected=NO;
                break;
            }
        }
	}
	if(isAllOptionsSelected==NO)
		
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	}
	else
	{
		NSMutableArray *arrAddedToWishlist = [[SqlQuery shared]getWishlistProductIDs:YES];
		
		NSMutableArray *arrProductID = [[[NSMutableArray alloc] init] autorelease];
		arrProductID = [arrAddedToWishlist valueForKey:@"id"];
		
		NSMutableArray *arrProductSize = [[[NSMutableArray alloc] init] autorelease];
		arrProductSize = [[SqlQuery shared] getWishListProductSizes:[[dicProduct objectForKey:@"id"]intValue]];
		
		
		
	  	BOOL isContained =NO;
		
		if([arrProductSize count]>0)
		{
			
			for(int count=0;count<[arrProductSize count];count++)
			{
				if(isContained==NO)
				{
					
					NSArray *arrOptions=[[arrProductSize objectAtIndex:count] componentsSeparatedByString:@","];
				    if([arrOptions count]==dropDownCount+1)
					{
						for(int count=0;count<=dropDownCount;count++)
							
						{
							NSNumber *optionID = [NSNumber numberWithInt:[[[arrDropDown[count] objectAtIndex:selectedIndex[count]] valueForKey:@"id"] intValue]];
							
							
							if ([arrOptions containsObject:[optionID stringValue]])
								
							{
								isContained=YES;
							}
							else
							{
								isContained=NO;
								break;
							}
						}
					}
					
					
				}
				else
				{
					break;
				}
				
			}
		}
		
		
		if ([[dicProduct valueForKey:@"bUseOptions"] intValue]==0)
		{
			if ([arrProductSize count] != 0)
			{
				if ([[arrProductSize objectAtIndex:0] isEqualToString:@"0"])
				{
					isContained = YES;
				}
			}
		}
		
		if ([arrProductID containsObject:[NSString stringWithFormat:@"%@", [dicProduct objectForKey:@"id"]]] && isContained)
		{
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:@"Product already added to Wishlist." delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else
		{
			NSString *strProductOptions=@"";
			
			// Convert product image into NSData, so it can be saved into the sqlite3 database
			if ([[dicProduct valueForKey:@"bUseOptions"] intValue]==0)
			{
				strProductOptions=@"0";
				[[SqlQuery shared] setTblWishlist:[[dicProduct objectForKey:@"id"] intValue] :1 :strProductOptions];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:@"Product has been added \n to the wishlist" delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
				[alert show];
				
				[alert release];
			}
			else
			{
				if ([optionArray count]>0)
				{
					for(int count=0;count<=dropDownCount;count++)
					{
						if(count==dropDownCount)
						{
							strProductOptions=[strProductOptions   stringByAppendingFormat:@"%@",[[arrDropDown[count] objectAtIndex:selectedIndex[count]]objectForKey:@"id"]];
						}
						else
						{
							strProductOptions=[strProductOptions stringByAppendingFormat:@"%@,",[[arrDropDown[count] objectAtIndex:selectedIndex[count]]objectForKey:@"id"]];
						}
					}
					[[SqlQuery shared] setTblWishlist:[[dicProduct objectForKey:@"id"] intValue] :1 :strProductOptions];
					
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:@"Product has been added \n to the wishlist" delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
					[alert show];
					
					[alert release];
				}
			}
		}
	}
}
- (void)getOptionTable
{
	if (!isShowOptionTable)
	{
		optionTableView.hidden=NO;
		[contentScrollView bringSubviewToFront:optionTableView];
		isShowOptionTable=YES;
	}
	else
	{
		optionTableView.hidden=YES;
		isShowOptionTable=NO;
	}
}

- (void)showLoadingbar
{
	
	if (loadingActionSheet1)
	{
		[loadingActionSheet1 release];
		loadingActionSheet1 = nil;
	}
	loadingActionSheet1 = [[UIActionSheet alloc] initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"] delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	[loadingActionSheet1 showInView:self.tabBarController.view];
	
	
}


#pragma mark -Zoom Image
- (void)zoomMethod
{
    
	[NSThread detachNewThreadSelector:@selector(showLoadingbar) toTarget:self withObject:nil];
    NSMutableArray  *arrImagesUrls;
	arrImagesUrls = [dicProduct objectForKey:@"productImages"];
	CoverFlowViewController *objFlowCover = [[CoverFlowViewController alloc] init];
	objFlowCover.arrImages = arrImagesUrls;
	[self.navigationController pushViewController:objFlowCover animated:YES];
	[objFlowCover release];
	
    
	
	
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return productImg;
}

#pragma mark TableView Delegate Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 30;
}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
    
	if (![arrDropDownTable isKindOfClass:[NSNull class]])
	{
		return [arrDropDownTable count];
	}
	
	else
    {
		return 0;
	}
	
	
}

- (UITableViewCell*) tableView:(UITableView*) tableview cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
	NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableIdentifier%d",indexPath.row];
	UITableViewCell *cell= [tableview dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if (cell==nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:SimpleTableIdentifier]autorelease];
		cell.backgroundColor=[UIColor whiteColor];
		cell.textLabel.text =[NSString stringWithFormat:@"%@", [[arrDropDownTable objectAtIndex:indexPath.row] objectForKey:@"sName"]];
		cell.textLabel.font=[UIFont systemFontOfSize:12];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
	}
	return  cell;
}

- (void)tableView:(UITableView*)tableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[tableview setHidden:YES];
    pastIndex=-1;
	
	iSelectedProductSize_Index = indexPath.row;
	selectedIndex[index]=indexPath.row;
	NSLog(@"%d",selectedIndex[index]);
	
	[lblOption[index] setText:[NSString stringWithFormat:@"%@",[[arrDropDownTable objectAtIndex:indexPath.row] objectForKey:@"sName"]]];
	
	BOOL canShowAddToCart;
	canShowAddToCart = NO;
	
	if(isComingSoonCheck==NO)
	{
        float pOtionPrice=0;
        for(int i=0;i<=dropDownCount;i++)
        {
            
            if(!([[lblOption[i].text lowercaseString]  isEqualToString:[[NSString stringWithFormat:@"Select %@",[[arrDropDown[i] objectAtIndex:0] objectForKey:@"sTitle"]] lowercaseString]]))
            {
                
                pOtionPrice= pOtionPrice+[[[arrDropDown[i] objectAtIndex:selectedIndex[i]]valueForKey:@"pPrice"]floatValue];
                
                NSString *strPrice=[NSString stringWithFormat:@"%@",[ProductPriceCalculation caluatePriceOptionProduct: dicProduct pPrice:pOtionPrice] ];
                if (![[dicProduct valueForKey:@"fDiscountedPrice"] isEqual:[NSNull null]])
                {
                    
                    if ([[dicProduct objectForKey:@"fPrice"] floatValue]>[[dicProduct valueForKey:@"fDiscountedPrice"] floatValue])
                    {
                        lblProductDiscount.frame = CGRectMake(152,lblProductPrice.frame.origin.y+lblProductPrice.frame.size.height+1, 160, 20);
                        NSString *str;
                        str=[NSString stringWithFormat:@"%@",[ProductPriceCalculation caluateOriginalPriceOptionProduct: dicProduct pPrice:pOtionPrice] ];
                        
                        [lblProductDiscount setText:str];
                        
                    }
                    
                    [lblProductPrice setText:strPrice];
                    
                    
                    
                }else
                {
                    [lblProductPrice setText:strPrice];
                }
                if([[[arrDropDown[i] objectAtIndex:selectedIndex[i]]valueForKey:@"iAvailableQuantity"]intValue]<=0)
                {
                    [imgStock setImage:[UIImage imageNamed:@"sold_out.png"]];
                    [lblImgStock setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"]];
                    canShowAddToCart=NO;
                    break;
                }
                else
                {
                    [imgStock setImage:[UIImage imageNamed:@"instock_btn.png"]];
                    [lblImgStock setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"]];
                    canShowAddToCart=YES;
                }
            }
        }
    }
	
	imgStock.hidden=NO;
	[lblImgStock setHidden:NO];
    
	if(isComingSoonCheck==NO)
	{
        if (canShowAddToCart)
        {
            [addToCartBtn setHidden:NO];
        }
        else
        {
            [addToCartBtn setHidden:YES];
        }
	}
	else
	{
		[addToCartBtn setHidden:YES];
        
		
	}
	
	
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	CGPoint startLocation	= [touch locationInView:self.view];
	
	startX = startLocation.x;
	startY = startLocation.y;
	moveONSwap=YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	CGPoint currentLocation	= [touch locationInView:self.view];
	
	currentX = currentLocation.x;
	currentY = currentLocation.y;
	
	if (currentX-startX>45)
    {
        [self previousImageSwap];
    }
	else if (startX-currentX>45)
    {
        [self nextImageSwap];
    }
}

- (void)previousImageSwap
{
	if (iCurrentThumbnailNum>0 && moveONSwap)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		CATransition *animation = [CATransition animation];
		[animation setDelegate:self];
		[animation setType: kCATransitionPush];
		[animation setSubtype:kCATransitionFromLeft];
		[animation setDuration:0.5f];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[UIView beginAnimations:nil context:context];
		[[zoomProduct layer] addAnimation:animation forKey:kCATransition];
		[UIView commitAnimations];
		
		iCurrentThumbnailNum--;
		
		NSArray  *arrImagesUrls = [dicProduct objectForKey:@"productImages"];
		
		[self displayProductImage:arrImagesUrls picToShowAtAIndex:iCurrentThumbnailNum willZoom:0];
		
		[zoomProduct setImage:[UIImage imageWithData:dataForProductImage]];
		moveONSwap=NO;
	}
	
	if (iCurrentThumbnailNum==0)
	{
		moveON = YES;
		btnLeftArrow.hidden = TRUE;
		btnRightArrow.hidden = FALSE;
	}
	else
	{
		moveON = YES;
		btnLeftArrow.hidden = FALSE;
		btnRightArrow.hidden = FALSE;
	}
}

// Method to get next image

- (void)nextImageSwap
{
	if (iCurrentThumbnailNum<([[dicProduct objectForKey:@"productImages"] count] -1) && moveONSwap)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		CATransition *animation = [CATransition animation];
		[animation setDelegate:self];
		[animation setType: kCATransitionPush];
		[animation setSubtype:kCATransitionFromRight];
		[animation setDuration:0.5f];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[UIView beginAnimations:nil context:context];
		[[zoomProduct layer] addAnimation:animation forKey:kCATransition];
		
		iCurrentThumbnailNum++;
		NSArray  *arrImagesUrls = [dicProduct objectForKey:@"productImages"];
		
		[self displayProductImage:arrImagesUrls picToShowAtAIndex:iCurrentThumbnailNum willZoom:(NSNumber *)0];
		
		[zoomProduct setImage:[UIImage imageWithData:dataForProductImage]];
		
		if (iCurrentThumbnailNum>=[[dicProduct objectForKey:@"productImages"] count]-1)
		{
			moveON= YES;
			btnRightArrow.hidden = TRUE;
			btnLeftArrow.hidden = FALSE;
			[contentScrollView sendSubviewToBack:btnRightArrow];
		}
		else
		{
			moveON = YES;
			btnRightArrow.hidden = FALSE;
			btnLeftArrow.hidden = FALSE;
			[contentScrollView bringSubviewToFront:btnRightArrow];
		}
		
		moveONSwap=NO;
		[UIView commitAnimations];
		
	}
	else
    {
		btnRightArrow.hidden = TRUE;
		[contentScrollView sendSubviewToBack:btnRightArrow];
	}
}


#pragma mark Mail Composer
- (void)sendFeedBack
{
	UIAlertView *theAlert=[[UIAlertView alloc]initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.tapscreen.keyboard.title"] message:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.tapscreen.keyboard.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
	[theAlert show];
	[theAlert release];
	
	if ([MFMailComposeViewController canSendMail])
	{
		MFMailComposeViewController *mcvc =	[[MFMailComposeViewController alloc] init];
		mcvc.mailComposeDelegate =self;
		
		NSDictionary *dicAppSettings = [GlobalPreferences getSettingsOfUserAndOtherDetails];
		
		[mcvc setSubject:[NSString stringWithFormat:@"%@ - %@", [dicProduct objectForKey:@"sName"], [[dicAppSettings objectForKey:@"store"] objectForKey:@"sSName"]]];
		
		
		NSString *strEmailBody = [NSString stringWithFormat:@"%@",[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.product.detail.email.content"]];
		
		[mcvc setMessageBody:strEmailBody isHTML:YES];
		[self presentModalViewController:mcvc animated:YES];
		[mcvc release];
	}
	else
	{
		[self newEmailTo:[NSArray  arrayWithObject:@""] withSubject:[dicProduct objectForKey:@"sName"] body:@""];
	}
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	if (result==MFMailComposeResultSent)
	{
		NSString *strEmailSent = [NSString stringWithFormat:@"%@",[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.product.detail.email.sent"]];
		
		theAlert1=[[UIAlertView alloc]initWithTitle:strEmailSent message:@"" delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
		[theAlert1 show];
	}
	else
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView == theAlert1)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)newEmailTo:(NSArray*)theToRecepients withSubject:(NSString*)theSubject body:(NSString*)theEmailBody 
{
	NSString* to = @"";
	NSString* subject = @"";
	NSString* body = [NSString stringWithFormat:@"%@", [dicProduct objectForKey:@"link"]];
	
	if (theToRecepients)
	{
		if ([theToRecepients count] > 0)
        {
            to = [theToRecepients objectAtIndex:0];
        }
	}
	
	if (theSubject)
    {
        subject = theSubject;
    }
	
	if (theEmailBody)
    {
        body = theEmailBody;
    }
    
	NSString *mailString = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@", [to stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[body	stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
}

#pragma mark - Memory Management

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
	[imgZoom release];
	
	
	if (optionArray)
	{
		[optionArray release];
		optionArray = nil;
	}
	
	if(arrAddedToCartList)
	{
		[arrAddedToCartList release];
		arrAddedToCartList =nil;
	}
	if(arrDropDownTable)
	{
		[arrDropDownTable release];
		arrDropDownTable=nil;
	}
	
	[zoomProduct release];
	zoomProduct = nil;
	[whiteView release];
	whiteView = nil;
	isZoomIn = NO;
	[lblReadReviews release];
	[productImg release];
	productImg=nil;
	[contentScrollView release];
	contentScrollView=nil;
	[contentView release];
	contentView=nil;
	
	for(int count=0;count<=dropDownCount;count++)
		
	{
		[lblOption[count] release];
		lblOption[count]=nil;
	}	
	
	resetIndex=NO;
	[super dealloc];
}


#pragma mark - Next Button
- (void)nextImageBtn
{
	[self nextImage];
}

#pragma mark - Previous Button
- (void)previousImageBtn
{
	[self previousImage];
}

#pragma mark - Previous / Next  Image 
// Method to get previous Image			

- (void)previousImage
{
	
	if (iCurrentThumbnailNum>0 && moveON)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		CATransition *animation = [CATransition animation]; 
		[animation setDelegate:self]; 
		[animation setType: kCATransitionPush];
		[animation setSubtype:kCATransitionFromLeft]; 
		[animation setDuration:0.5f]; 
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[UIView beginAnimations:nil context:context];
		[[productImg layer] addAnimation:animation forKey:kCATransition];
		[UIView commitAnimations]; 
		
		iCurrentThumbnailNum--;
		
		NSArray  *arrImagesUrls = [dicProduct objectForKey:@"productImages"];
		
		[self displayProductImage:arrImagesUrls picToShowAtAIndex:iCurrentThumbnailNum willZoom:0];
		
		moveON=NO;
	}
	
	if (iCurrentThumbnailNum==0)
	{
		moveON = YES;
		btnLeftArrow.hidden = TRUE;
		btnRightArrow.hidden = FALSE;
	}
	else
	{
		moveON = YES;
		btnLeftArrow.hidden = FALSE;
		btnRightArrow.hidden = FALSE;
	}
}

// Method to get next image	
- (void)nextImage
{
	if (iCurrentThumbnailNum<[[dicProduct objectForKey:@"productImages"] count] && moveON)		
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		CATransition *animation = [CATransition animation]; 
		[animation setDelegate:self]; 
		[animation setType: kCATransitionPush];
		[animation setSubtype:kCATransitionFromRight]; 
		[animation setDuration:0.5f]; 
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[UIView beginAnimations:nil context:context];
		[[productImg layer] addAnimation:animation forKey:kCATransition];
		
		iCurrentThumbnailNum++;
		NSArray  *arrImagesUrls = [dicProduct objectForKey:@"productImages"];
		
		[self displayProductImage:arrImagesUrls picToShowAtAIndex:iCurrentThumbnailNum willZoom:(NSNumber *)0];		
		
		if (iCurrentThumbnailNum>=[[dicProduct objectForKey:@"productImages"] count]-1)
		{
			moveON= YES;
			btnRightArrow.hidden = TRUE;
			btnLeftArrow.hidden = FALSE;
			[contentScrollView sendSubviewToBack:btnRightArrow];
		}
		else
		{
			moveON = YES;
			btnRightArrow.hidden = FALSE;
			btnLeftArrow.hidden = FALSE;
			[contentScrollView bringSubviewToFront:btnRightArrow];
		}
		
		[UIView commitAnimations]; 
	} 
	else
    {
		btnRightArrow.hidden = TRUE;
		[contentScrollView sendSubviewToBack:btnRightArrow];
	}
}
@end