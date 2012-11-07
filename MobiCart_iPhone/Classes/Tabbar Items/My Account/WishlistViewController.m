//
//  WishlistViewController.m
//  MobiCart
//
//  Created by Mobicart on 7/26/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

/** This Class shows the Products Added in Wishlist **/

#import "WishlistViewController.h"
#import "Constants.h"
#import "ProductPriceCalculation.h"
extern BOOL isWishlistLogin;

@implementation WishlistViewController
@synthesize alertMain;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	objDetails=[[DetailsViewController alloc]init];
	
	viewForLogin =  [[UIView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake(0, 0, 320, 372) chageHieght:YES]];
	viewForLogin.backgroundColor=navBarColor;
	viewForLogin.hidden = TRUE;
	
	self.navigationItem.titleView = [GlobalPreferences createLogoImage];
	
	UIBarButtonItem *barBtnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(btnEdit_clicked)];
	[self.navigationItem setRightBarButtonItem:barBtnEdit animated:YES];
	[barBtnEdit release];
	
	contentView=[[UIView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake( 0, 0, 320, 396) chageHieght:YES]];
	contentView.backgroundColor=navBarColor;
	self.view = contentView;
	
	UIImageView *imgBg=[[UIImageView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake( 0, 0, 320, 396) chageHieght:YES]];
	[imgBg setImage:[UIImage imageNamed:@"product_details_bg.png"]];
	[contentView addSubview:imgBg];
	[imgBg release];
	
	
	
	
	viewForLogin =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 372)];
	viewForLogin.backgroundColor=navBarColor;
	viewForLogin.hidden = TRUE;
	[contentView addSubview:viewForLogin];
	
	isWishlistLogin=NO;
	[self showView];
}

- (void)showView
{
	arrWishlist = [[NSMutableArray alloc] init];
	
	showWishlistArray=[[NSMutableArray alloc]init];
	
	arrWishlist = [[SqlQuery shared]getWishlistProductIDs:NO];
	
	if ([arrWishlist count]==0)
	{
		//There are no items in your wishlist
		UILabel *noItemLbl=[[UILabel alloc]initWithFrame:CGRectMake( 10, 40, 310, 50)];
		noItemLbl.textColor=[UIColor whiteColor];
		[noItemLbl setFont:[UIFont boldSystemFontOfSize:14]];
		[noItemLbl setBackgroundColor:[UIColor clearColor]];
		[noItemLbl setText:@""];
		[contentView addSubview:noItemLbl];
		[noItemLbl release];
	}
	else
	{
		[self createTableView];
	}
	
	UIView *viewTopBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [viewTopBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"barNews.png"]]];
    [contentView addSubview:viewTopBar];
    
    UIImageView *imgWishlist=[[UIImageView alloc]initWithFrame:CGRectMake(10,6,15,15)];
    [imgWishlist setImage:[UIImage imageNamed:@"whishlist_star.png"]];
    [viewTopBar addSubview:imgWishlist];
	[imgWishlist release];
	
	UILabel *wishlistLbl=[[UILabel alloc]initWithFrame:CGRectMake(30, 5, 80,20)];
	[wishlistLbl setBackgroundColor:[UIColor clearColor]];
    [wishlistLbl setTextColor:[UIColor whiteColor]];
	[wishlistLbl setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.wishlist"]];
	[wishlistLbl setFont:[UIFont boldSystemFontOfSize:13]];
	[viewTopBar addSubview:wishlistLbl];
	[wishlistLbl release];
    [viewTopBar release];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void)createTableView
{
	if (tableView)
	{
		[tableView release];
		tableView=nil;
	}
	
	tableView=[[UITableView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake(0,20, 320, 360) chageHieght:YES] style:UITableViewStyleGrouped];
	tableView.delegate=self;
	tableView.dataSource=self;
    tableView.backgroundView=nil;
	[tableView setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:tableView];
}


#pragma mark View Controller Delegates
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	isWishlist_TableStyle=YES;
	
	for (UIView *view in [self.navigationController.navigationBar subviews])
	{
		UIButton *btnTemp = (UIButton *)view;
		
		if (([view isKindOfClass:[UIButton class]]) && !([btnTemp.titleLabel.text isEqualToString:@"Edit"] ||[btnTemp.titleLabel.text isEqualToString:@"Done"]))
		{
			view.hidden =TRUE;
		}
		
		if ([view isKindOfClass:[UILabel class]])
		{
			view.hidden =TRUE;
		}
	}
	
	UIBarButtonItem *barBtnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(btnEdit_clicked)];
	[self.navigationItem setRightBarButtonItem:barBtnEdit animated:YES];
    [barBtnEdit release];
	if([tableView isEditing])
		self.navigationItem.rightBarButtonItem.title = @"Done";
	else
		self.navigationItem.rightBarButtonItem.title = @"Edit";
	
	
	arrWishlist = [[SqlQuery shared]getWishlistProductIDs:NO];
	
	[showWishlistArray removeAllObjects];
	
	int countryID=0,stateID=0;
	
	NSMutableArray *arrInfoAccount=[[NSMutableArray alloc]init];
	arrInfoAccount=[[SqlQuery shared] getAccountData:[GlobalPreferences getUserDefault_Preferences:@"userEmail"]];
	
	NSDictionary *dictSettingsDetails=[[GlobalPreferences getSettingsOfUserAndOtherDetails]retain];
	if ([arrInfoAccount count]>0)
	{
		stateID=[[[NSUserDefaults standardUserDefaults] valueForKey:@"stateID"]intValue];
	    countryID=[[[NSUserDefaults standardUserDefaults] valueForKey:@"countryID"]intValue];
	}
	else
    {
		countryID=[[[dictSettingsDetails valueForKey:@"store"]valueForKey:@"territoryId"]intValue];
		NSArray *arrtaxCountries=[[dictSettingsDetails valueForKey:@"store"]valueForKey:@"taxList"];
		for(int index=0;index<[arrtaxCountries count];index++)
		{
			if ([[[arrtaxCountries objectAtIndex:index]valueForKey:@"sState"]isEqualToString:@"Other"]&& [[[arrtaxCountries objectAtIndex:index]valueForKey:@"territoryId"]intValue]==countryID)
			{
				stateID=[[[arrtaxCountries objectAtIndex:index]valueForKey:@"id"]intValue];
			    break;
			}
		}
		
	}
	
	
	[arrInfoAccount release];
	
	for(int i=0; i<[arrWishlist count]; i++)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		int productId = [[[arrWishlist objectAtIndex:i] valueForKey:@"id"] intValue];
		
       	NSDictionary *dictProductDetails=[[ServerAPI fetchDetailsOfProductWithID:productId countryID:countryID stateID:stateID]objectForKey:@"product"];
        
		[showWishlistArray addObject:dictProductDetails];
		
		[pool release];
	}
	
	[showWishlistArray retain];
	
	[tableView reloadData];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateLabelAccount" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	isWishlist_TableStyle=NO;
	for (UIView *view in [self.navigationController.navigationBar subviews])
	{
		UIButton *btnTemp = (UIButton *)view;
		if (([view isKindOfClass:[UIButton class]]) && !([btnTemp.titleLabel.text isEqualToString:@"Edit"] ||[btnTemp.titleLabel.text isEqualToString:@"Done"]))
		{
			view.hidden =FALSE;
		}
		
		if ([view isKindOfClass:[UILabel class]])
		{
			view.hidden =FALSE;
		}
	}
	
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
}
#pragma mark -

- (void)btnBack_clicked
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)btnEdit_clicked
{
	if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Edit"])
    {
		self.navigationItem.rightBarButtonItem.title = @"Done";
		[tableView setEditing:YES animated:YES];
	}
    else if ([self.navigationItem.rightBarButtonItem.title isEqualToString: @"Done"])
    {
		self.navigationItem.rightBarButtonItem.title = @"Edit";
		[tableView setEditing:NO animated:YES];
	}
	
	[tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (BOOL)tableView:(UITableView *)tableView1 canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *tblViewCell=(UITableViewCell *)[tableView1 cellForRowAtIndexPath:indexPath];
	if([tableView isEditing])
		[[tblViewCell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setHidden:YES];
	else {
		[[tblViewCell viewWithTag: [[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setHidden:NO];
	}
	
	return [tableView isEditing];
}

static int kAnimationType;

- (void)tableView:(UITableView *)_tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// For changing the animation style for every odd.even row
	(kAnimationType == 6)?kAnimationType = 0:0;
	kAnimationType += 1;
	
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		if([[[arrWishlist objectAtIndex:indexPath.row] valueForKey:@"pOptionId"]isEqualToString:@"0"])
			[[SqlQuery shared] deleteItemFromWishList:[[[arrWishlist objectAtIndex:indexPath.row] valueForKey:@"id"]integerValue]];
		else
			[[SqlQuery shared] deleteItemFromWishList:[[[arrWishlist objectAtIndex:indexPath.row] valueForKey:@"id"]integerValue]:[[arrWishlist objectAtIndex:indexPath.row] valueForKey:@"pOptionId"]];
		
        
		[showWishlistArray removeObjectAtIndex:indexPath.row];
		[arrWishlist removeObjectAtIndex:indexPath.row];
		[_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:kAnimationType];
		
		[tableView reloadData];
	}
}
- (void)markStarRating:(UITableViewCell *)cell:(int)index
{
    int xValue=217;
	
	float rating;
	NSDictionary *dictProducts=[showWishlistArray objectAtIndex:index];
  	
    /* if ([[dictProducts valueForKey:@"categoryName"] isEqual:[NSNull null]])
     {
     isFeaturedProductWithoutCatogery=YES;
     }*/
    
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
	
	for(int i=0; i<5; i++)
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

#pragma mark TableView Delegate Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 86;
}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
	return [showWishlistArray count];
}

- (UITableViewCell*) tableView:(UITableView*) tableview cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
	NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableIdentifier%d", indexPath.row];
	TableViewCell_Common *cell= (TableViewCell_Common *)[tableview dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	
    if(cell==nil)
	{
		cell =[[TableViewCell_Common alloc] initWithStyleFor_Store_ProductView:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
		
		UIImageView *imgCellBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,87)];
		[imgCellBackground setImage:[UIImage imageNamed:@"320-86.png"]];
		[[cell layer] insertSublayer:imgCellBackground.layer atIndex:0];
		[imgCellBackground release];
		
		cell.textLabel.textColor=_savedPreferences.headerColor;
		cell.textLabel.backgroundColor=[UIColor clearColor];
		
		
		UIImageView *imgPlaceHolder=[[UIImageView alloc]initWithFrame:CGRectMake(10.5,9, 68, 67)];
		[imgPlaceHolder setImage:[UIImage imageNamed:@"product_list_ph.png"]];
		
		[imgPlaceHolder setTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]];
		[cell addSubview:imgPlaceHolder];
		
		if([tableview isEditing])
			[imgPlaceHolder setHidden:YES];
		else {
			[imgPlaceHolder setHidden:NO];
		}
		
		
		UIImageView *cellProductImage=[[UIImageView alloc]initWithFrame:CGRectMake(0 ,0, 60, 65)];
		[cellProductImage setBackgroundColor:[UIColor clearColor]];
		[cellProductImage setTag:[[NSString stringWithFormat:@"9911%d0%d",indexPath.row+1,indexPath.row+1] intValue]];
		[imgPlaceHolder addSubview:cellProductImage];
		[imgPlaceHolder release];
		
		
        
		NSString *discount = [NSString stringWithFormat:@"%@", [[showWishlistArray objectAtIndex:indexPath.row] objectForKey:@"fDiscountedPrice"]];
		
		NSString *tempDiscount;
		NSString *strTaxTypeLenght=@"";
		
		strTaxTypeLenght=[[showWishlistArray objectAtIndex:indexPath.row]  objectForKey:@"sTaxType"];
		
		if ([strTaxTypeLenght isEqualToString:@"default"])
        {
            strTaxTypeLenght=[NSString stringWithFormat:@"%@ %@",_savedPreferences.strCurrencySymbol, [[showWishlistArray objectAtIndex:indexPath.row]  objectForKey:@"fPrice"]];
        }
		else
        {
            strTaxTypeLenght=[NSString stringWithFormat:@"%@%@",_savedPreferences.strCurrencySymbol, [[showWishlistArray objectAtIndex:indexPath.row] objectForKey:@"fPrice"]];
        }
		
		
		if ([[[showWishlistArray objectAtIndex:indexPath.row]  objectForKey:@"bTaxable"]intValue]==1)
        {
            tempDiscount =strTaxTypeLenght;
        }
		else
        {
            tempDiscount = [NSString stringWithFormat:@"%@%@",_savedPreferences.strCurrencySymbol, [[showWishlistArray objectAtIndex:indexPath.row]  objectForKey:@"fPrice"]];
        }
        
        CGSize size=[[ProductPriceCalculation productActualPrice:[showWishlistArray objectAtIndex:indexPath.row]] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:13] constrainedToSize:CGSizeMake(100000,20) lineBreakMode:UILineBreakModeWordWrap];
        
        
		if ((![discount isEqual:[NSNull null]]) && (![discount isEqualToString:@"<null>"]) && ([discount length]!=0))
		{
			if ([[[showWishlistArray objectAtIndex:indexPath.row] objectForKey:@"fPrice"] floatValue]>[discount floatValue])
			{
				UIImageView *imgCutLine = [[UIImageView alloc]initWithFrame:CGRectMake(83, 41, size.width+4,2)];
                [imgCutLine setBackgroundColor:_savedPreferences.labelColor];
                
               	[cell addSubview:imgCutLine];
				[imgCutLine release];
			}
		}
		
	}
	
	UIImage *imgProduct;
	
	NSDictionary *dictTemp=[showWishlistArray objectAtIndex:indexPath.row];
	NSArray  *arrImagesUrls = [dictTemp objectForKey:@"productImages"];
	
	if([arrImagesUrls count]!=0)
    {
        NSData *data = [ServerAPI fetchBannerImage:[[arrImagesUrls objectAtIndex:0] valueForKey:@"productImageSmallIphone4"]];
		imgProduct = [UIImage imageWithData:data];
    }
    else
    {
		imgProduct = [UIImage imageNamed:@""];
    }
	UIImageView *imgTemp=(UIImageView *)[cell viewWithTag:[[NSString stringWithFormat:@"9911%d0%d",indexPath.row+1,indexPath.row+1] intValue]];
	
	int yImage=(67-imgProduct.size.height/2)/2;
	int xImage=(67-imgProduct.size.width/2)/2;
	if (![imgProduct isEqual:[NSNull null]])
	{
		[imgTemp setFrame:CGRectMake(xImage+3.5, yImage, imgProduct.size.width/2-10, imgProduct.size.height/2-4)];
		imgTemp.image=imgProduct;
	}
	if([tableView isEditing])
		[[cell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setHidden:YES];
	else
		[[cell viewWithTag: [[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setHidden:NO];
	
	float	finalProductPrice=0,actualPrice=0;
    
    actualPrice=[[[showWishlistArray objectAtIndex:indexPath.row] objectForKey:@"fPrice"]floatValue];
	if((dictTemp) || (![dictTemp isEqual:[NSNull null]]))
	{
		NSString *discount = [NSString stringWithFormat:@"%@", [[showWishlistArray objectAtIndex:indexPath.row] objectForKey:@"fDiscountedPrice"]];
		
		if([[dictTemp objectForKey:@"bTaxable"]intValue]==1)
		{
			if([[dictTemp objectForKey:@"fPrice"] floatValue]>[discount floatValue])
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
			if([[dictTemp objectForKey:@"fPrice"] floatValue]>[discount floatValue])
            {
                finalProductPrice=[[dictTemp objectForKey:@"fDiscountedPrice"]floatValue];
            }
			else
            {
				finalProductPrice=[[dictTemp objectForKey:@"fPrice"]floatValue];
			}
		}
	}
    
    NSString *strStatus, *strTemp;
	
	if(dictTemp)
    {
        strTemp = [dictTemp objectForKey:@"sIPhoneStatus"];
    }
	
	if((strTemp != nil) && (![strTemp isEqual:[NSNull null]]))
	{
		if([[dictTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"coming"])
        {
            strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.comming.soon"];
			
			isComingSoonChecked=YES;
			
        }
		else if([[dictTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"sold"])
        {
            strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
        }
		else if([[dictTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"active"])
        {
            strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"];
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
	
	if(isComingSoonChecked==NO)
	{
        
        NSArray *interOptionDict = [[NSArray alloc]init];
        interOptionDict = [dictTemp objectForKey:@"productOptions"];
        
        [interOptionDict retain];
        
        NSString *strProductOptions=[[arrWishlist objectAtIndex:indexPath.row] valueForKey:@"pOptionId"];
        NSArray *arrOptions=[strProductOptions componentsSeparatedByString:@","];
        
        
        
        NSMutableArray *dictOption = [[showWishlistArray objectAtIndex:indexPath.row] objectForKey:@"productOptions"];
        
        NSMutableArray *arrProductOptionSize = [[[NSMutableArray alloc] init] autorelease];
        
        for(int i=0; i<[dictOption count]; i++)
        {
            [arrProductOptionSize addObject:[[dictOption objectAtIndex:i] valueForKey:@"id"]];
        }
        BOOL isContained=YES;
        int optionSizeIndex[100];
        for(int i=0;i<[arrOptions count];i++)
        {
            float optionPrice=0;
            if([arrProductOptionSize containsObject: [NSNumber numberWithInt:[[arrOptions objectAtIndex:i] integerValue]]])
            {
                optionSizeIndex[i] =[arrProductOptionSize indexOfObject:[NSNumber numberWithInt:[[arrOptions objectAtIndex:i]intValue]]];
                
                optionPrice+=[[[dictOption objectAtIndex:optionSizeIndex[i]]valueForKey:@"pPrice"]floatValue];
                
                
                
            }
            
            else {
                strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
                isContained=NO;
                
            }
            
            
            finalProductPrice+=optionPrice;
            actualPrice+=optionPrice;
        }
        if([arrProductOptionSize count]==0)
        {
            strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
            isContained=NO;
            
        }
        
        if([[dictTemp valueForKey:@"bUseOptions"] boolValue]==TRUE)
        {
            if(![interOptionDict isKindOfClass:[NSNull class]])
            {
                
                if([interOptionDict count]>0)
                {
                    if(isContained==YES)
                    {
                        for(int count=0;count<[arrOptions count];count++)
                        {
                            if([[[interOptionDict objectAtIndex:optionSizeIndex[count]] valueForKey:@"iAvailableQuantity"] intValue] == 0)
                            {
                                strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
                                break;
                                
                            }
                            
                            else {
                                strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"];
                            }
                            
                        }
                    }
                }
                
                
            }
        }
        
        if([[dictTemp valueForKey:@"bUseOptions"] intValue]==0)
        {
            NSString *strDicTemp=[dictTemp valueForKey:@"iAggregateQuantity"];
            if(![strDicTemp isKindOfClass:[NSNull class]])
            {
                if([strDicTemp intValue]!=0)
                {
                    strStatus=[dictTemp objectForKey:@"sIPhoneStatus"];
                    if([strStatus isEqualToString:@"sold"])
                    {
                        strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
                    }
                    else if([strStatus isEqualToString:@"coming"])
                    {
                        strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"];
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
	}
    if([strStatus isEqualToString:@"active"])
    {
        strStatus=[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"];
        
    }
	
    NSString *strFinalProductPrice=@"";
	NSString *strOriginalTaxType=@"";
	strOriginalTaxType=[[showWishlistArray objectAtIndex:indexPath.row]valueForKey:@"sTaxType"] ;
	if([strOriginalTaxType isEqualToString:@"default"])
    {
        strOriginalTaxType=@"";
    }
	else
    {
        strOriginalTaxType=[NSString stringWithFormat:@" (inc %@)",strOriginalTaxType];
    }
	
	if([[dictTemp objectForKey:@"bTaxable"]intValue]==1)
	{
		if(![[dictTemp objectForKey:@"sTaxType"]isEqualToString:@"default"])
        {
            strFinalProductPrice=[NSString stringWithFormat:@"%0.2f (inc %@)",finalProductPrice,[dictTemp objectForKey:@"sTaxType"]];
        }
		else
        {
			strFinalProductPrice=[NSString stringWithFormat:@"%0.2f",finalProductPrice];
		}
	}
	else
    {
		strFinalProductPrice=[NSString stringWithFormat:@"%0.2f",finalProductPrice];
	}
	NSString *discount = [NSString stringWithFormat:@"%@", [[showWishlistArray objectAtIndex:indexPath.row] objectForKey:@"fDiscountedPrice"]];
	
	if((![discount isEqual:[NSNull null]]) && (![discount isEqualToString:@"<null>"]) && ([discount length]!=0))
	{
		if([[[showWishlistArray objectAtIndex:indexPath.row] objectForKey:@"fPrice"] floatValue]<=[discount floatValue])
		{
			[cell setProductName:[[showWishlistArray objectAtIndex:indexPath.row] valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%@", _savedPreferences.strCurrencySymbol, strFinalProductPrice]:strStatus :[NSString stringWithFormat:@""]:nil];
		}
		else
		{
			if([[dictTemp objectForKey:@"bTaxable"]intValue]==0)
			{
				[cell setProductName:[[showWishlistArray objectAtIndex:indexPath.row] valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, finalProductPrice]:strStatus :[NSString stringWithFormat:@"%@", strFinalProductPrice]:nil];
				
				
				
				
				
			}
			else
			{
				[cell setProductName:[[showWishlistArray objectAtIndex:indexPath.row] valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, (actualPrice+[[[showWishlistArray objectAtIndex:indexPath.row]valueForKey:@"fTaxOnFPrice"] floatValue])]:strStatus :[NSString stringWithFormat:@"%@", strFinalProductPrice]:nil];
			}
		}
	}
	else
	{
		[cell setProductName:[[showWishlistArray objectAtIndex:indexPath.row] valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, strFinalProductPrice ]:strStatus :[NSString stringWithFormat:@""]:nil];
	}
    
	[self markStarRating:cell :indexPath.row];
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	UIImageView *imgViewCellAcccesory=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
	[cell setAccessoryView:imgViewCellAcccesory];
	[imgViewCellAcccesory release];
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	
	
	
	return  cell;
}

- (void)tableView:(UITableView*)tableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSDictionary *dictTemp = [showWishlistArray objectAtIndex:indexPath.row];
	
	ProductDetailsViewController *objProductDetails=[[ProductDetailsViewController alloc]init];
	objProductDetails.optionIndex =[[arrWishlist objectAtIndex:indexPath.row] valueForKey:@"pOptionId"];
	
	// Passing product details to ProductDetailsViewController
	objProductDetails.isWishlist = YES;
	objProductDetails.dicProduct = dictTemp;
	[self.navigationController pushViewController:objProductDetails animated:YES];
	[objProductDetails release];
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
	[arrWishlist release];
    
	[showWishlistArray release];
    showWishlistArray=nil;
    
    [tableView release];
	tableView =nil;
    
	[contentView release];
	contentView=nil;
    
    [super dealloc];
}


@end
