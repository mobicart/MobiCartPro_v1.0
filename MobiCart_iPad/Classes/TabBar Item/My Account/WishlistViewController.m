//
//  WishlistViewController.m
//  MobiCart
//
//  Created by Mobicart on 7/26/10.
//  Copyright Mobicart. All rights reserved.
//

#import "WishlistViewController.h"
#import "Constants.h"

extern BOOL isWishlistLogin;

@implementation WishlistViewController
@synthesize alertMain;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


-(void)hideLoadingView
{
	[GlobalPrefrences dismissLoadingBar_AtBottom];	
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	[NSTimer scheduledTimerWithTimeInterval:2
									 target:self
								   selector:@selector(hideLoadingView)
								   userInfo:nil
									repeats:NO];
	
	objDetails=[[DetailsViewController alloc]init];
	
	[self.navigationController.navigationBar setHidden:YES];
	contentView=[[UIView alloc]initWithFrame:CGRectMake( 0, 0, 450, 600)];
	contentView.backgroundColor=[UIColor clearColor];
	self.view = contentView;
	isWishlistLogin=NO;
	[self showView];
}

-(void)showView
{
	arrWishlist = [[NSMutableArray alloc] init];	
	showWishlistArray=[[NSMutableArray alloc]init];	
	arrWishlist = [[SqlQuery shared]getWishlistProductIDs:NO];	
	
	UILabel *wishlistLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 23, 80, 15)];
	[wishlistLbl setBackgroundColor:[UIColor clearColor]];
    wishlistLbl.textColor = headingColor;
	[wishlistLbl setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.wishlist"]];
	[wishlistLbl setFont:[UIFont boldSystemFontOfSize:15]];
	[contentView addSubview:wishlistLbl];
	
   if([arrWishlist count]==0)
	{
		UILabel *noItemLbl=[[UILabel alloc]initWithFrame:CGRectMake( 10, 40, 310, 50)];
		noItemLbl.textColor=subHeadingColor;
		[noItemLbl setFont:[UIFont boldSystemFontOfSize:14]];
		[noItemLbl setBackgroundColor:[UIColor clearColor]];

        [noItemLbl setText:@""];
		[contentView addSubview:noItemLbl];
		[noItemLbl release];
	}
	else 
	{
		[self viewWillAppear:NO];
		[self createTableView];
		UIButton *btnEdit=[UIButton buttonWithType:UIButtonTypeCustom];
		[btnEdit setTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.createaccount.edit"] forState:UIControlStateNormal];
		[btnEdit setTitleColor:btnTextColor forState:UIControlStateNormal];
		[btnEdit.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
		[btnEdit setBackgroundImage:[UIImage imageNamed:@"edit_cart_btn.png"] forState:UIControlStateNormal];
		btnEdit.backgroundColor = [UIColor clearColor];
		[btnEdit addTarget:self action:@selector(btnEdit_clicked) forControlEvents:UIControlEventTouchUpInside];
		[btnEdit setFrame:CGRectMake(wishlistLbl.frame.size.width+5, 17, 60, 25)];
		[btnEdit setTag:112233];
		btnEdit.hidden = NO;
		[contentView bringSubviewToFront:btnEdit];
		[contentView addSubview:btnEdit];	
	}
	
	UIButton *	btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
	btnCart.frame = CGRectMake(340, 13, 78,34);
	[btnCart setBackgroundColor:[UIColor clearColor]];
	[btnCart setTag:2507];
	[btnCart setImage:[UIImage imageNamed:@"add_cart.png"] forState:UIControlStateNormal];
	[btnCart addTarget:nextController action:@selector(btnShoppingCart_Clicked) forControlEvents:UIControlEventTouchUpInside];
	[contentView addSubview:btnCart];
	
	lblCart = [[UILabel alloc] initWithFrame:CGRectMake(42, 2, 30, 30)];
	lblCart.backgroundColor = [UIColor clearColor];
	lblCart.textAlignment = UITextAlignmentCenter;
	lblCart.font = [UIFont boldSystemFontOfSize:16];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	lblCart.textColor = [UIColor whiteColor];	 
	[btnCart addSubview:lblCart];
	
	UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 51, 420,2)];
	[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
	[contentView addSubview:imgHorizontalDottedLine];
	[imgHorizontalDottedLine release];
}	



-(void)btnShoppingCart_Clicked
{
	if(iNumOfItemsInShoppingCart > 0)
		[NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
	ShoppingCartViewController *objShopping = [[ShoppingCartViewController alloc] init];
	[[GlobalPrefrences getCurrentNavigationController]pushViewController:objShopping animated:YES];
	[objShopping release];
	
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}	



-(void)createTableView
{
	if(tableView)
	{
		[tableView release];
		tableView=nil;
	}	
	tableView=[[UITableView alloc]initWithFrame:CGRectMake( 0, 65, 420, 600) style:UITableViewStylePlain];
	tableView.delegate=self;
	tableView.dataSource=self;
	[tableView setBackgroundColor:[UIColor clearColor]];
	[tableView setSeparatorColor:[UIColor clearColor]];
	[contentView addSubview:tableView];
}

#pragma mark View Controller Delegates
-(void)viewWillAppear:(BOOL)animated
{
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	[super viewWillAppear:animated];
	isWishlist_TableStyle=YES;	
	for (UIView *view in [self.navigationController.navigationBar subviews]) {
		
		UIButton *btnTemp = (UIButton *)view;
		if (([view isKindOfClass:[UIButton class]]) && !([btnTemp.titleLabel.text isEqualToString:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.createaccount.edit"]] ||[btnTemp.titleLabel.text isEqualToString:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.shoppingcart.done"]]))
		{
			view.hidden =TRUE;
		}
		
		if ([view isKindOfClass:[UILabel class]])
		{
			view.hidden =TRUE;
		}
	}
	
	arrWishlist = [[SqlQuery shared]getWishlistProductIDs:NO];
	
	[showWishlistArray removeAllObjects];	
	int countryID=0,stateID=0;
	NSMutableArray *arrInfoAccount=[[NSMutableArray alloc]init];
	arrInfoAccount=[[SqlQuery shared] getAccountData:[GlobalPrefrences getUserDefault_Preferences:@"userEmail"]];
	NSDictionary *dictSettingsDetails=[[GlobalPrefrences getSettingsOfUserAndOtherDetails]retain];
	if([arrInfoAccount count]>0)
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
			if([[[arrtaxCountries objectAtIndex:index]valueForKey:@"sState"]isEqualToString:@"Other"]&& [[[arrtaxCountries objectAtIndex:index]valueForKey:@"territoryId"]intValue]==countryID)
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

-(void)viewWillDisappear:(BOOL)animated
{
	isWishlist_TableStyle = NO;
	for (UIView *view in [self.navigationController.navigationBar subviews])
	{		
		UIButton *btnTemp = (UIButton *)view;
		if (([view isKindOfClass:[UIButton class]]) && !([btnTemp.titleLabel.text isEqualToString:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.createaccount.edit"]] ||[btnTemp.titleLabel.text isEqualToString:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.shoppingcart.done"]]))
		{
			view.hidden =FALSE;
		}
		if ([view isKindOfClass:[UILabel class]])
		{
			view.hidden =FALSE;
		}
	}
	
}	
#pragma mark -



-(void)btnEdit_clicked
{
	UIButton *btnEdit = (UIButton *)[contentView viewWithTag:112233];
	btnEdit.hidden = NO;
	if([btnEdit.titleLabel.text isEqualToString:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.createaccount.edit"]])
	{
		[btnEdit setTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.shoppingcart.done"] forState:UIControlStateNormal];
		[tableView setEditing:YES animated:YES];
	
	} 
	else if([btnEdit.titleLabel.text isEqualToString: [[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.shoppingcart.done"]])
	{
		[btnEdit setTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.createaccount.edit"] forState:UIControlStateNormal];
		[tableView setEditing:NO animated:YES];
	}
		[tableView reloadData];
	
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (BOOL)tableView:(UITableView *)tableview canEditRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *tblViewCell=(UITableViewCell *)[tableview cellForRowAtIndexPath:indexPath];
	if([tableView isEditing])
	{
		[[tblViewCell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setBackgroundColor:[UIColor clearColor]];
		[[tblViewCell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setHidden:YES];
	}
	else 
	{
		[[tblViewCell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setBackgroundColor:[UIColor whiteColor]];
		[[tblViewCell viewWithTag: [[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setHidden:NO];
	}
	
	return [tableView isEditing];
}

static int kAnimationType;
- (void)tableView:(UITableView *)_tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	(kAnimationType == 6)?kAnimationType = 0:0;
	kAnimationType += 1; 
	
	if (editingStyle == UITableViewCellEditingStyleDelete) 
	{		
		if([[[arrWishlist objectAtIndex:indexPath.row] valueForKey:@"pOptionId"] intValue]==0)
			[[SqlQuery shared] deleteItemFromWishList:[[[arrWishlist objectAtIndex:indexPath.row] valueForKey:@"id"]integerValue]];
		else
			[[SqlQuery shared] deleteItemFromWishList:[[[arrWishlist objectAtIndex:indexPath.row] valueForKey:@"id"]integerValue]:[[arrWishlist objectAtIndex:indexPath.row] valueForKey:@"pOptionId"]];
		
		[arrWishlist removeObjectAtIndex:indexPath.row];
		[showWishlistArray removeObjectAtIndex:indexPath.row];
		[_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:kAnimationType];
		
		[tableView reloadData];
	}
	if([showWishlistArray count] == 0)
	{
		UIButton *btnEdit = (UIButton *)[contentView viewWithTag:112233];
		btnEdit.hidden = YES;
	}
	
	
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.remove.item"];
	
}

-(void)markStarRating:(UITableViewCell *)cell:(int)index
{
	
    int xValue=355;
	
	float rating;
	NSDictionary *dictProducts=[showWishlistArray objectAtIndex:index];
  	
    if([[dictProducts valueForKey:@"categoryName"] isEqual:[NSNull null]])
		isFeaturedProductWithoutCatogery=YES;
    
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
		imgRatingsTemp[i] = [[[UIImageView alloc] initWithFrame:CGRectMake( xValue, 10, 9, 9)] autorelease];
        imgRatingsTemp[i].clipsToBounds = TRUE;
		[imgRatingsTemp[i] setImage:[UIImage imageNamed:@"black_star.png"]];
		[imgRatingsTemp[i] setBackgroundColor:[UIColor clearColor]];
		[cell addSubview:imgRatingsTemp[i]];
		xValue += 10;
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

#pragma mark TableView Delegate Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!([[[arrWishlist objectAtIndex:indexPath.row] valueForKey:@"pOptionId"] intValue]==0))
	{
		NSArray *arrSelectedOptions=[[[arrWishlist objectAtIndex:indexPath.row] valueForKey:@"pOptionId"] componentsSeparatedByString:@","];
		int optionsCount=[arrSelectedOptions count];
		return 120+(optionsCount-1)*15;
	}
	else {
		return 130;
	}
}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
	
	return [showWishlistArray count];
}



- (UITableViewCell*) tableView:(UITableView*) tableview cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
	NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableIdentifier%d", indexPath.row];
	TableViewCell_Common *cell= (TableViewCell_Common *)[tableview dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	
	NSDictionary *dictTemp=[showWishlistArray objectAtIndex:indexPath.row];
	
	
    if(cell==nil)
	{
		cell = [[TableViewCell_Common alloc] initWithStyleFor_Store_ProductView:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
		cell.textLabel.backgroundColor=[UIColor clearColor];

		NSString *discount = [NSString stringWithFormat:@"%@", [[showWishlistArray objectAtIndex:indexPath.row] objectForKey:@"fDiscountedPrice"]];
		CGSize size = [[NSString stringWithFormat:@"%@", [[showWishlistArray objectAtIndex:indexPath.row] objectForKey:@"fPrice"]]  sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12]];
		if ((![discount isEqual:[NSNull null]]) && (![discount isEqualToString:@"<null>"]) && ([discount length]!=0))
		{
			if ([[[showWishlistArray objectAtIndex:indexPath.row] objectForKey:@"fPrice"] floatValue]>[discount floatValue])
			{
				UIImageView *imgCutLine = [[UIImageView alloc]initWithFrame:CGRectMake(105, 34, size.width+35,2)];
				
               [imgCutLine setBackgroundColor:labelColor];
                
                [imgCutLine release];
			}
		}
		UIView *imgPlaceHolder=[[UIView alloc]init];
		imgPlaceHolder.frame  = CGRectMake(4,11, 90, 90);
		imgPlaceHolder.backgroundColor = [UIColor whiteColor];
		[[imgPlaceHolder layer] setCornerRadius:6.0];
		[[imgPlaceHolder layer] setBorderWidth:2.0];
		imgPlaceHolder.layer.masksToBounds = YES;
		[[imgPlaceHolder layer] setBorderColor:[[UIColor clearColor] CGColor]];
		[imgPlaceHolder setTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]];
		[cell addSubview:imgPlaceHolder];
		if([tableView isEditing])
		{
			[[cell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setBackgroundColor:[UIColor clearColor]];
			[[cell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setHidden:YES];
		}
		else 
		{
			[[cell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setBackgroundColor:[UIColor whiteColor]];
			[[cell viewWithTag: [[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setHidden:NO];
		}
		UIImage *imgProduct;
		NSArray  *arrImagesUrls = [dictTemp objectForKey:@"productImages"];
		if([arrImagesUrls count]!=0)
		{
			NSData *data = [ServerAPI fetchBannerImage:[[arrImagesUrls objectAtIndex:0] valueForKey:@"productImageSmallIpad"]];
			imgProduct = [UIImage imageWithData:data];
		}
		else
		{
			imgProduct = [UIImage imageNamed:@""];
		}
		UIImageView *cellProductImage=[[UIImageView alloc]init];
		[cellProductImage setFrame:CGRectMake(0 ,0, 90, 90)];
		[cellProductImage setBackgroundColor:[UIColor clearColor]];
		[[cellProductImage layer] setCornerRadius:6.0];
		cellProductImage.layer.masksToBounds = YES;
		cellProductImage.layer.opaque = NO;
		
		[imgPlaceHolder addSubview:cellProductImage];
		
		int	y1= (90-imgProduct.size.height)/2;
		int x1 = (90 - imgProduct.size.width)/2;
		if(![imgProduct isEqual:[NSNull null]])
		{
			[cellProductImage setFrame:CGRectMake(x1, y1, imgProduct.size.width, imgProduct.size.height)];
			cellProductImage.image=imgProduct;
			
		}
		[imgPlaceHolder release];
		
	}

	else {
		if([tableView isEditing])
		{
			[[cell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setBackgroundColor:[UIColor clearColor]];
			[[cell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setHidden:YES];
		}
		else 
		{
			[[cell viewWithTag:[[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setBackgroundColor:[UIColor whiteColor]];
			[[cell viewWithTag: [[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]]setHidden:NO];
			UIImage *imgProduct;
			NSArray  *arrImagesUrls = [dictTemp objectForKey:@"productImages"];
			if([arrImagesUrls count]!=0)
			{
				NSData *data = [ServerAPI fetchBannerImage:[[arrImagesUrls objectAtIndex:0] valueForKey:@"productImageSmallIpad"]];
				imgProduct = [UIImage imageWithData:data];
			}
			else
			{
				imgProduct = [UIImage imageNamed:@""];
			}
			
			UIImageView *cellProductImage=[[UIImageView alloc]init];
			[cellProductImage setFrame:CGRectMake(0 ,0, 90, 90)];
			[cellProductImage setBackgroundColor:[UIColor clearColor]];
			[[cellProductImage layer] setCornerRadius:6.0];
			cellProductImage.layer.masksToBounds = YES;
			cellProductImage.layer.opaque = NO;
			
			[[cell viewWithTag: [[NSString stringWithFormat:@"9900%d0%d",indexPath.row+1,indexPath.row+1] intValue]] addSubview:cellProductImage];
			
			int	y1= (90-imgProduct.size.height)/2;
			int x1 = (90 - imgProduct.size.width)/2;
			if(![imgProduct isEqual:[NSNull null]])
			{
				[cellProductImage setFrame:CGRectMake(x1, y1, imgProduct.size.width, imgProduct.size.height)];
				cellProductImage.image=imgProduct;
				
			}
			
			
		}	
	}

	
		
	float	finalProductPrice=0;
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
            strStatus=[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.comming.soon"];
        }
		else if([[dictTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"sold"])
        {
            strStatus=[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
        }
		else if([[dictTemp objectForKey:@"sIPhoneStatus"] isEqualToString:@"active"])
        {
            strStatus = [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"];
        }
		else
        {
            strStatus = [NSString stringWithFormat:@"%@",[dictTemp objectForKey:@"sIPhoneStatus"]];
        }
	}
	else
    {
        strStatus=[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
    }
    
	[dictTemp retain];
	NSArray *interOptionDict = [[NSArray alloc]init];
	interOptionDict = [dictTemp objectForKey:@"productOptions"];
	[interOptionDict retain];
	
	UILabel *lblOptionTitle[100];
	UILabel *lblOptionName[100];
	int optionSizesIndex[100];
	int yValue=55;
	if (!([[[arrWishlist objectAtIndex:indexPath.row] valueForKey:@"pOptionId"] intValue]==0))
	{
		
		NSMutableArray *dictOption = [[showWishlistArray objectAtIndex:indexPath.row] objectForKey:@"productOptions"];
		
		NSMutableArray *arrProductOptionSize = [[[NSMutableArray alloc] init] autorelease];
		
		for (int i=0; i<[dictOption count]; i++)
		{
			[arrProductOptionSize addObject:[[dictOption objectAtIndex:i] valueForKey:@"id"]];
		}
		
		NSArray *arrSelectedOptions=[[[arrWishlist objectAtIndex:indexPath.row] valueForKey:@"pOptionId"] componentsSeparatedByString:@","];
		
		if([arrProductOptionSize count]!=0 && [arrSelectedOptions count]!=0)
		{
			for(int count=0;count<[arrSelectedOptions count];count++)
			{
				if ([arrProductOptionSize containsObject: [NSNumber numberWithInt:[[arrSelectedOptions objectAtIndex:count] integerValue]]])
				{
					optionSizesIndex[count] = [arrProductOptionSize indexOfObject:[NSNumber numberWithInt:[[arrSelectedOptions objectAtIndex:count]  intValue]]];
				}
			}
		}
				
		for(int count=0;count<[arrSelectedOptions count];count++)
		{
            
            float pOPrice=0;
            
            
            pOPrice =pOPrice+[[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"pPrice"]floatValue];
            
            //pOPrice=   pOPrice* [[[arrDatabaseCart objectAtIndex:indexPath.row]valueForKey:@"quantity"] intValue];
            finalProductPrice+=pOPrice;
           
           
            
            
          
            

            
            
            
            
            
			CGSize size=[[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"sTitle"]sizeWithFont:[UIFont boldSystemFontOfSize:13]];
			int width=size.width;
			if(width>100)
				width=100;
			
			lblOptionTitle[count] = [[UILabel alloc]initWithFrame:CGRectMake(107,yValue,width+9,20)];
			lblOptionTitle[count].backgroundColor=[UIColor clearColor];
			[lblOptionTitle[count] setTextAlignment:UITextAlignmentLeft];
			lblOptionTitle[count].textColor=headingColor;
			[lblOptionTitle[count] setNumberOfLines:0];
			[lblOptionTitle[count] setText: [NSString stringWithFormat:@"%@:",[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"sTitle"]]];
			lblOptionTitle[count].lineBreakMode = UILineBreakModeWordWrap;
			lblOptionTitle[count].lineBreakMode = UILineBreakModeTailTruncation;
			lblOptionTitle[count].font=[UIFont boldSystemFontOfSize:13];
			[cell addSubview:lblOptionTitle[count]];
			
			
			CGSize size1=[[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"sName"] sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:CGSizeMake(1000, 20)];
			int width1=size1.width;
			if(width1>(100-lblOptionTitle[count].frame.size.width)+90)
				width1=(100-lblOptionTitle[count].frame.size.width)+90;
			[lblOptionTitle[count] release];
			
			lblOptionName[count] = [[UILabel alloc]initWithFrame:CGRectMake(lblOptionTitle[count].frame.size.width+lblOptionTitle[count].frame.origin.x,yValue,width1,20)];
			lblOptionName[count].backgroundColor=[UIColor clearColor];
			[lblOptionName[count] setTextAlignment:UITextAlignmentLeft];
			lblOptionName[count].textColor=subHeadingColor;
			[lblOptionName[count] setNumberOfLines:0];
			[lblOptionName[count] setText: [NSString stringWithFormat:@"%@",[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"sName"]]];
			lblOptionName[count].lineBreakMode = UILineBreakModeWordWrap;
			lblOptionName[count].lineBreakMode = UILineBreakModeTailTruncation;
			lblOptionName[count].font=[UIFont boldSystemFontOfSize:13];
			[cell addSubview:lblOptionName[count]];
			[lblOptionName[count] release];
			
			yValue=yValue+15;
		}	
		
	}
	int j=0;
	if(yValue > 55)
		j = 43+yValue;
	else {
		j = 128;
	}
	
	UIImageView *imgSeprator=[[UIImageView alloc]initWithFrame:CGRectMake(2, j, 420, 2)];
	[imgSeprator setImage:[UIImage imageNamed:@"dotted_line_02.png"]];
	[imgSeprator setBackgroundColor:[UIColor clearColor]];
	[cell addSubview:imgSeprator];	
	
	NSMutableArray *dictOption = [[showWishlistArray objectAtIndex:indexPath.row] objectForKey:@"productOptions"];
	NSMutableArray *arrProductOptionSize = [[[NSMutableArray alloc] init] autorelease];
	
	for(int i=0; i<[dictOption count]; i++)
    {
        [arrProductOptionSize addObject:[[dictOption objectAtIndex:i] valueForKey:@"id"]];
    }
	
	NSString *strProductOptions=[[arrWishlist objectAtIndex:indexPath.row] valueForKey:@"pOptionId"];
	NSArray *arrOptions=[strProductOptions componentsSeparatedByString:@","];
	
	BOOL isContained=YES;	
	int optionSizeIndex[100];
	for(int i=0;i<[arrOptions count];i++)
	{
		if([arrProductOptionSize containsObject: [NSNumber numberWithInt:[[arrOptions objectAtIndex:i] integerValue]]])
		{
			optionSizeIndex[i] =[arrProductOptionSize indexOfObject:[NSNumber numberWithInt:[[arrOptions objectAtIndex:i]intValue]]];
		}
		else 
		{
			strStatus=[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
			isContained=NO;
		}
	}
	if([arrProductOptionSize count]==0)
	{
		strStatus=[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
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
							strStatus=[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
							break;
						}
						
						else 
						{
							strStatus=[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"];
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
                    strStatus=[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
                }
				else if([strStatus isEqualToString:@"coming"])
                {
                    strStatus=[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.comming.soon"];
                }
				else	
                {
                    strStatus=[dictTemp objectForKey:@"sIPhoneStatus"];
                }
			}
            else
            {
                strStatus=[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"];
            }
		}
	}
	
    if([strStatus isEqualToString:@"active"])
    {
        strStatus = [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"];
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
        strOriginalTaxType=[NSString stringWithFormat:@" (Inc. %@)",strOriginalTaxType];
    }
	
	if([[dictTemp objectForKey:@"bTaxable"]intValue]==1)
	{
		if(![[dictTemp objectForKey:@"sTaxType"]isEqualToString:@"default"])
        {
            strFinalProductPrice=[NSString stringWithFormat:@"%0.2f (Inc. %@)",finalProductPrice,[dictTemp objectForKey:@"sTaxType"]];
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
			[cell setProductName:[[showWishlistArray objectAtIndex:indexPath.row] valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%@", _savedPreferences.strCurrencySymbol, strFinalProductPrice]:strStatus :[NSString stringWithFormat:@""]];
		}
		else
		{
			if([[dictTemp objectForKey:@"bTaxable"]intValue]==0)
			{
				[cell setProductName:[[showWishlistArray objectAtIndex:indexPath.row] valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, ([[[showWishlistArray objectAtIndex:indexPath.row]valueForKey:@"fPrice"] floatValue])]:strStatus :[NSString stringWithFormat:@"%@", strFinalProductPrice]];
			}
			else 
			{
				[cell setProductName:[[showWishlistArray objectAtIndex:indexPath.row] valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, ([[[showWishlistArray objectAtIndex:indexPath.row]valueForKey:@"fPrice"] floatValue]+[[[showWishlistArray objectAtIndex:indexPath.row]valueForKey:@"fTaxOnFPrice"] floatValue])]:strStatus :[NSString stringWithFormat:@"%@", strFinalProductPrice]];
			}
		}
	}
	else
	{
		[cell setProductName:[[showWishlistArray objectAtIndex:indexPath.row] valueForKey:@"sName"] :[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, strFinalProductPrice ]:strStatus :[NSString stringWithFormat:@""]];
	}
    
	[self markStarRating:cell :indexPath.row];
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	return  cell;
}


-(void)showLoading
{
	[GlobalPrefrences addLoadingBar_AtBottom:self.tabBarController.view withTextToDisplay:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
}
- (void) tableView:(UITableView*)tableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	
	[NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
	NSDictionary *dictTemp = [showWishlistArray objectAtIndex:indexPath.row];
	ProductDetails *objProductDetails=[[ProductDetails alloc]init];
	
	objProductDetails.optionIndex = [[arrWishlist objectAtIndex:indexPath.row] valueForKey:@"pOptionId"];
	objProductDetails.isWishlist = YES;
	
	objProductDetails.dicProduct = dictTemp;	
	[[GlobalPrefrences getCurrentNavigationController] pushViewController:objProductDetails animated:YES];
	[objProductDetails release];
}
/*
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */



/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */


 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
  return UIInterfaceOrientationIsLandscape(interfaceOrientation);
 }


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)dealloc {
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
