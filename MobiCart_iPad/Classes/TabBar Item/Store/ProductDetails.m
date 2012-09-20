//
//  ProductDetails.m
//  Mobicart

//  Created by Mobicart on 03/05/11.
//  Copyright Mobicart. All rights reserved.
//

#import "ProductDetails.h"
#import "ReadReviews.h"
#import "CoverFlowViewController.h"

@implementation ProductDetails
@synthesize productID,nextProductID,dicProduct,dicNextProduct;
@synthesize isWishlist, optionIndex,lblProductPrice,strPriceCurrentProduct,lblProductPriceSecond,strPriceNxtProduct;
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




#pragma mark Mail Composer
-(void) sendFeedBack:(UIButton*)sender
{		
	UIAlertView *theAlert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.tapscreen.keyboard.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.tapscreen.keyboard.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
	[theAlert show];
	[theAlert release];
	tagForEmail=[sender tag];
	if([MFMailComposeViewController canSendMail])
	{
		MFMailComposeViewController *mcvc =	[[MFMailComposeViewController alloc] init]; 
		mcvc.mailComposeDelegate =self; 
		
		NSDictionary *dicAppSettings = [GlobalPrefrences getSettingsOfUserAndOtherDetails];
		NSString *strEmailBody;
		if([sender tag]==101010)
		{
			[mcvc setSubject:[NSString stringWithFormat:@"%@ - %@", [dicProduct objectForKey:@"sName"], [[dicAppSettings objectForKey:@"store"] objectForKey:@"sSName"]]];
		
		
			
			strEmailBody = [NSString stringWithFormat:@"%@",[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.product.detail.email.content"]];
		}
		else{ 
			[mcvc setSubject:[NSString stringWithFormat:@"%@ - %@", [dicNextProduct objectForKey:@"sName"], [[dicAppSettings objectForKey:@"store"] objectForKey:@"sSName"]]];
					strEmailBody = [NSString stringWithFormat:@"%@",[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.product.detail.email.content"]];
            }
		
		[mcvc setMessageBody:strEmailBody isHTML:YES]; 
		[self presentModalViewController:mcvc animated:YES];
		[mcvc release];
	}
	else 
	{
		if([sender tag]==101010)
			[self newEmailTo:[NSArray  arrayWithObject:@""] withSubject:[dicProduct objectForKey:@"sName"] body:@""];
		else	
			[self newEmailTo:[NSArray  arrayWithObject:@""] withSubject:[dicNextProduct objectForKey:@"sName"] body:@""];
		
	}
}


-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	if(result==MFMailComposeResultSent)
	{
		theAlert1=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.product.detail.email.sent"] message:@"" delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
		[theAlert1 show];
	}
	else
		[self dismissModalViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView == theAlert1)
		[self dismissModalViewControllerAnimated:YES];
}

- (void)newEmailTo:(NSArray*)theToRecepients withSubject:(NSString*)theSubject body:(NSString*)theEmailBody 
{
	NSString* to = @"";
	NSString* subject = @"";
	NSString* body;
	if(tagForEmail==101010)
		body= [NSString stringWithFormat:@"%@", [dicProduct objectForKey:@"link"]];
	else
		body= [NSString stringWithFormat:@"%@", [dicNextProduct objectForKey:@"link"]];
	
	
	if(theToRecepients)
	{
		if([theToRecepients count] > 0)
			to = [theToRecepients objectAtIndex:0];
	}
	
	if(theSubject)
		subject = theSubject;
	
	if(theEmailBody)
		body = theEmailBody;
	
	
	NSString *mailString = [NSString
							stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@", [to stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
							[subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
							[body	stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
}


#pragma mark YouTube Video


-(void)watchYouTubeVideo:(UIButton*)sender
{
	webViewVideo *_webViewVideo = [[webViewVideo alloc]init];
	
	if([sender tag]==202020)
	{
		_webViewVideo.strVideo  = [dicProduct objectForKey:@"sVideoUrl"];
		if(([[dicProduct objectForKey:@"sVideoTitle"] isEqual:[NSNull null]]) || (![dicProduct objectForKey:@"sVideoTitle"]) || ([[dicProduct objectForKey:@"sVideoTitle"] isEqualToString:@""]))
			_webViewVideo.navigationItem.title = @"Video";
		else 
			_webViewVideo.navigationItem.title=	[dicProduct objectForKey:@"sVideoTitle"];
	}
	else {
		_webViewVideo.strVideo  = [dicNextProduct objectForKey:@"sVideoUrl"];
		if(([[dicNextProduct objectForKey:@"sVideoTitle"] isEqual:[NSNull null]]) || (![dicNextProduct objectForKey:@"sVideoTitle"]) || ([[dicNextProduct objectForKey:@"sVideoTitle"] isEqualToString:@""]))
			_webViewVideo.navigationItem.title = @"Video";
		else 
			_webViewVideo.navigationItem.title=	[dicNextProduct objectForKey:@"sVideoTitle"];
		
	}
	
	
	[self.navigationController pushViewController:_webViewVideo animated:YES];
	[_webViewVideo release];
	
}

-(void)allocateMemoryToObjects
{
    if (![[dicProduct valueForKey:@"productOptions"]isEqual:[NSNull null]])
    {
        
        
        if(optionArray)
        {
            [optionArray release];
            optionArray = nil;
        }
        optionArray = [[NSArray alloc] init];
        optionArray = [dicProduct objectForKey:@"productOptions"];
        
        
        if(optionsArrayNextProduct)
        {
            [optionsArrayNextProduct release];
            optionsArrayNextProduct = nil;
        }
        optionsArrayNextProduct = [[NSArray alloc] init];
        optionsArrayNextProduct=[dicNextProduct objectForKey:@"productOptions"];
        NSString *sortByQuantity =@"iAvailableQuantity";
        
        NSSortDescriptor*	priceDescriptor =[[NSSortDescriptor alloc] initWithKey:sortByQuantity
                                                                       ascending:NO
                                                                        selector:@selector(compare:)] ;
        
        
        NSArray *descriptors = [NSArray arrayWithObjects:priceDescriptor,nil];
        
        optionArray = [optionArray sortedArrayUsingDescriptors:descriptors];
        [optionArray retain];
        
        optionsArrayNextProduct = [optionsArrayNextProduct sortedArrayUsingDescriptors:descriptors];
        [optionsArrayNextProduct retain];
        if([optionArray count]>0)
            [optionTableView reloadData];
        
        if([optionsArrayNextProduct count]>0)
            [optionTableViewNextProduct reloadData];
        
        
        [self createDropDowns];
        [self createDropDownsNext]; 
        
    }

}



-(void)createDropDowns
{
	NSArray *arrTempOptions=[[NSArray alloc]initWithArray:optionArray];
	dropDownCount=-1;
	if([arrTempOptions count]>0)
	{
		dropDownCount=0;
		strTitle= [NSString stringWithFormat:@"%@",[[arrTempOptions objectAtIndex:0] objectForKey:@"sTitle"]];
		strTitle=[strTitle lowercaseString];
		
	}	
	
	
	for(int count=0;count<[arrTempOptions count];count++)
	{
				
		if([[[NSString stringWithFormat:@"%@",[[arrTempOptions objectAtIndex:count]objectForKey:@"sTitle"]] lowercaseString] isEqualToString:strTitle])
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
			    if([[[[arrDropDown[countTemp] objectAtIndex:0]objectForKey:@"sTitle"]lowercaseString]isEqualToString:[[[arrTempOptions objectAtIndex:count]objectForKey:@"sTitle"]lowercaseString]])
				{
					[arrDropDown[countTemp] addObject:[arrTempOptions objectAtIndex:count]];
					isValueSet=YES;
					break;
				}			
				
			}	
			
			if(isValueSet==NO)
			{
				strTitle=[NSString stringWithFormat:@"%@",[[arrTempOptions objectAtIndex:count]objectForKey:@"sTitle"]];
				strTitle=[strTitle lowercaseString];
				dropDownCount++;
				
				if(!arrDropDown[dropDownCount])
					arrDropDown[dropDownCount]=[[NSMutableArray alloc]init];	
				
				[arrDropDown[dropDownCount] addObject:[arrTempOptions objectAtIndex:count]];			
				
		    }
		}
	}
	
	if(arrTempOptions)
		[arrTempOptions release];
    
	for(int count=0;count<=dropDownCount;count++)
	{
		selectedIndex[count]=-1;	
		
	}	
	
}	


-(void)createDropDownsNext
{
	
	NSArray *arrTempOptions=[[NSArray alloc]initWithArray:optionsArrayNextProduct];
	dropDownCountNext=-1;
	
	
	if([arrTempOptions count]>0)
	{
		dropDownCountNext=0;
		strTitleNext= [NSString stringWithFormat:@"%@",[[arrTempOptions objectAtIndex:0] objectForKey:@"sTitle"]];
		strTitleNext=[strTitleNext lowercaseString];
    }	
	
	
	for(int count=0;count<[arrTempOptions count];count++)
	{
		if([[[NSString stringWithFormat:@"%@",[[arrTempOptions objectAtIndex:count]objectForKey:@"sTitle"]] lowercaseString] isEqualToString:strTitleNext])
		{ 
			if(!arrDropDownNext[dropDownCountNext])
				arrDropDownNext[dropDownCountNext]=[[NSMutableArray alloc]init];
			
			[arrDropDownNext[dropDownCountNext] addObject:[arrTempOptions objectAtIndex:count]];
			
		}
		
		else 
		{
			BOOL isValueSet=NO;
			for(int countTemp=0;countTemp<=dropDownCountNext;countTemp++)
			{
			    if([[[[arrDropDownNext[countTemp] objectAtIndex:0]objectForKey:@"sTitle"]lowercaseString]isEqualToString:[[[arrTempOptions objectAtIndex:count]objectForKey:@"sTitle"]lowercaseString]])
				{
					[arrDropDownNext[countTemp] addObject:[arrTempOptions objectAtIndex:count]];
					isValueSet=YES;
					break;
				}			
				
			}	
			
			if(isValueSet==NO)
			{
				strTitleNext=[NSString stringWithFormat:@"%@",[[arrTempOptions objectAtIndex:count]objectForKey:@"sTitle"]];
				strTitleNext=[strTitleNext lowercaseString];
				dropDownCountNext++;
				
				if(!arrDropDownNext[dropDownCountNext])
					arrDropDownNext[dropDownCountNext]=[[NSMutableArray alloc]init];	
				
				[arrDropDownNext[dropDownCountNext] addObject:[arrTempOptions objectAtIndex:count]];			
				
		    }
		}
	}
	
	if(arrTempOptions)
		[arrTempOptions release];
    
	for(int count=0;count<=dropDownCountNext;count++)
	{
		selectedIndexNext[count]=-1;	
		
	}	
	
}	


-(void)dataValidationChecks
{
	
	if([[dicProduct objectForKey:@"sDescription"] isEqual:[NSNull null]])
		[dicProduct setValue:@" " forKey:@"sDescription"];
	else
		(([dicProduct objectForKey:@"sDescription"] == nil) || ([[dicProduct objectForKey:@"sDescription"] isEqualToString:@""]))? [dicProduct setValue:@" " forKey:@"sDescription"]:nil;
	
	if([[dicNextProduct objectForKey:@"sDescription"] isEqual:[NSNull null]])
		[dicNextProduct setValue:@" " forKey:@"sDescription"];
	else
		(([dicNextProduct objectForKey:@"sDescription"] == nil) || ([[dicNextProduct objectForKey:@"sDescription"] isEqualToString:@""]))? [dicNextProduct setValue:@" " forKey:@"sDescription"]:nil;
	
}



-(void)getOptionTableNextProduct
{
	if(optionTableViewNextProduct.hidden==YES)
		optionTableViewNextProduct.hidden=NO;
	else if(optionTableViewNextProduct.hidden==NO)
		optionTableViewNextProduct.hidden=YES;
}


-(void)getOptionTable
{
	if(optionTableView.hidden==YES)
		optionTableView.hidden=NO;
	else if(optionTableView.hidden==NO)
		optionTableView.hidden=YES;
	
	
	
}
#pragma mark createTableView
- (void)createTableView:(UIButton *)sender
{
	index=[sender tag];
	if(optionTableView)
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
		int i=[arrDropDownTable count];
		if([arrDropDownTable count]<5)
        {
            i=i*30;
        }
        else
        {
            i=160;
        }
		
		optionTableView=[[UITableView alloc]initWithFrame:CGRectMake(10,optionBtn[index].frame.origin.y+optionBtn[index].frame.size.height, 160,i) style:UITableViewStylePlain];
		
		pastIndex=index;
		optionTableView.delegate=self;
		optionTableView.dataSource=self;
		[optionTableView setBackgroundColor:[UIColor whiteColor]];
		[[optionTableView layer] setCornerRadius:5.0];
		[[optionTableView layer] setBorderColor:[[UIColor blackColor] CGColor]];
		[[optionTableView layer] setBorderWidth:1.0];
		[currentDescriptionScrollView addSubview:optionTableView];
		
		
	}
	else 
	{
		pastIndex=-1;
	}
	
	
}
-(void)createTableViewForNextProduct:(UIButton *)sender
{
	indexNext=[sender tag];
	
	
	if(optionTableViewNextProduct)
	{
		[optionTableViewNextProduct setHidden:YES];
		[optionTableViewNextProduct release];
		optionTableViewNextProduct=nil;
	}
	
	
	if(indexNext!=pastIndexNext)
		
	{
		
		if(arrDropDownTableNext)
		{
			[arrDropDownTableNext	release];
			arrDropDownTableNext=nil;
			
		}	
        
       
		arrDropDownTableNext=[[NSArray alloc]initWithArray:arrDropDownNext[indexNext]];	
        int j=[arrDropDownTableNext count];
		if([arrDropDownTableNext count]<5)
        {
            j=j*30;
        }
        else
        {
            j=160;
        }

		optionTableViewNextProduct=[[UITableView alloc]initWithFrame:CGRectMake(10
																				,optionBtnNext[indexNext].frame.origin.y+optionBtnNext[indexNext].frame.size.height, 160, j) style:UITableViewStylePlain];
		pastIndexNext=indexNext;
		optionTableViewNextProduct.delegate=self;
		optionTableViewNextProduct.dataSource=self;
		[[optionTableViewNextProduct layer] setCornerRadius:5.0];
		[[optionTableViewNextProduct layer] setBorderColor:[[UIColor blackColor] CGColor]];
		[[optionTableViewNextProduct layer] setBorderWidth:1.0];
		[optionTableViewNextProduct setBackgroundColor:[UIColor whiteColor]];
		[nextDescriptionScrollView addSubview:optionTableViewNextProduct];
	}
	else 
	{
		pastIndexNext=-1;
	}
	
}


#pragma mark create basic controls
-(void)createBasicControls
{
	currentProductScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(20, 20, 450, 670)];
	[currentProductScrollView setBackgroundColor:[UIColor clearColor]];
	[currentProductScrollView setTag:100];
	[contentView addSubview:currentProductScrollView];
	
	UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(46, 52, 420,2)];
	[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
	[contentView addSubview:imgHorizontalDottedLine];
	[imgHorizontalDottedLine release];
	
	UIImageView *productbackImg = [[UIImageView alloc]initWithFrame:CGRectMake(25, 47, 426, 300)];
	[productbackImg setBackgroundColor:[UIColor clearColor]];
	[productbackImg setImage:[UIImage imageNamed:@"large_placeholder.png"]];
	[currentProductScrollView addSubview:productbackImg];
	
	
	productImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 425, 300)];
	[productImg setBackgroundColor:[UIColor clearColor]];
	[productbackImg addSubview:productImg];
		
	
	UIImageView *imgZoom = [[UIImageView alloc]initWithFrame:CGRectMake(33,58,27,27)];
	[imgZoom setBackgroundColor:[UIColor clearColor]];
	[imgZoom setImage:[UIImage imageNamed:@"new_search.png"]];
	[currentProductScrollView addSubview:imgZoom];
	
    UIButton *btnZoom =[UIButton buttonWithType:UIButtonTypeCustom];
	[btnZoom setFrame:CGRectMake(25, 47, 426, 300)];
	[btnZoom setBackgroundColor:[UIColor clearColor]];
	[btnZoom setTag:1000];
	[btnZoom addTarget:self action:@selector(zoomMethod:) forControlEvents:UIControlEventTouchUpInside];
	[currentProductScrollView addSubview:btnZoom];
	
	
	UILabel *lblProductName=[[UILabel alloc]initWithFrame:CGRectMake(25, 365, 300, 25)];
	[lblProductName setBackgroundColor:[UIColor clearColor]];
	[lblProductName setText:[dicProduct valueForKey:@"sName"]];
	[lblProductName setFont:[UIFont boldSystemFontOfSize:22]];
	[lblProductName setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:21]];
	
	[lblProductName setTextColor:subHeadingColor];
	[currentProductScrollView addSubview:lblProductName];
	[lblProductName release];
	
	
	lblProductPrice=[[UILabel alloc]initWithFrame:CGRectMake(25, 390, 250, 25)];
	[lblProductPrice setBackgroundColor:[UIColor clearColor]];
	lblProductPrice.textColor = labelColor;
	[lblProductPrice setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:21]];
	
    [currentProductScrollView addSubview:lblProductPrice];
	
	
	strPriceCurrentProduct=[[TaxCalculation shared]caluateTaxForProduct:dicProduct];
	
	float discount=[[dicProduct objectForKey:@"fDiscountedPrice"]floatValue];
	float finalProductPrice;
	if([[dicProduct objectForKey:@"fPrice"] floatValue]>discount )
		finalProductPrice=[[dicProduct objectForKey:@"fDiscountedPrice"]floatValue];
	else 
		finalProductPrice=[[dicProduct objectForKey:@"fPrice"]floatValue];
	
	[lblProductPrice setText:strPriceCurrentProduct];
	
	currentDescriptionScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(15, 420, 330, 195)];
	[currentDescriptionScrollView setBackgroundColor:[UIColor clearColor]];	
	[currentDescriptionScrollView setScrollEnabled:YES];
	[currentProductScrollView addSubview:currentDescriptionScrollView];
	
		
	
	UIButton *btnSendEmail=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnSendEmail setBackgroundColor:[UIColor clearColor]];
	[btnSendEmail setTag:101010];
	[btnSendEmail setImage:[UIImage imageNamed:@"new_email.png"] forState:UIControlStateNormal];
	[btnSendEmail addTarget:self action:@selector(sendFeedBack:) forControlEvents:UIControlEventTouchUpInside];
	[btnSendEmail setFrame:CGRectMake( 355, 518,95,40)];
	[currentProductScrollView addSubview:btnSendEmail];
	[btnSendEmail setShowsTouchWhenHighlighted:YES];
	
	
	UILabel *lblSendMail = [[UILabel alloc] initWithFrame:CGRectMake(btnSendEmail.frame.origin.x+39, btnSendEmail.frame.origin.y+2, 55, 32)];
	[lblSendMail setBackgroundColor:[UIColor clearColor]];
	[currentProductScrollView addSubview:lblSendMail];
	[lblSendMail setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.mainproduct.sendtofriend"]];
	[lblSendMail setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
	[lblSendMail setTextAlignment:UITextAlignmentLeft];
	[lblSendMail setLineBreakMode:UILineBreakModeWordWrap];
	[lblSendMail setNumberOfLines:2];
	[lblSendMail setTextColor:[UIColor whiteColor]];
	[lblSendMail release];
	
	if((![[dicProduct objectForKey:@"sVideoUrl"] isEqual:[NSNull null]]) && (![[dicProduct objectForKey:@"sVideoUrl"] isEqualToString:@""]))
	{
		UIButton *btnYoutube=[UIButton buttonWithType:UIButtonTypeCustom];
		[btnYoutube setBackgroundColor:[UIColor clearColor]];
		[btnYoutube setImage:[UIImage imageNamed:@"new_youtube.png"] forState:UIControlStateNormal];
		[btnYoutube setTag:202020];
		[btnYoutube addTarget:self action:@selector(watchYouTubeVideo:) forControlEvents:UIControlEventTouchUpInside];
		[btnYoutube setFrame:CGRectMake( 355, 468,95,40)];
		[currentProductScrollView addSubview:btnYoutube];
		[btnYoutube setShowsTouchWhenHighlighted:YES];
		
		
		
		UILabel *lblYouTube = [[UILabel alloc] initWithFrame:CGRectMake(btnYoutube.frame.origin.x+38, btnYoutube.frame.origin.y+2, 55, 32)];
		[lblYouTube setBackgroundColor:[UIColor clearColor]];
		[currentProductScrollView addSubview:lblYouTube];
		[lblYouTube setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.mainproduct.watchvideo"]];
		[lblYouTube setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
		[lblYouTube setTextAlignment:UITextAlignmentLeft];
		[lblYouTube setLineBreakMode:UILineBreakModeWordWrap];
		[lblYouTube setNumberOfLines:2];
		[lblYouTube setTextColor:[UIColor whiteColor]];
		[lblYouTube release];
	}
	if (!isWishlist)
	{
		
		UIButton *btnAddToWishList=[UIButton buttonWithType:UIButtonTypeCustom];
		[btnAddToWishList setBackgroundColor:[UIColor clearColor]];
		[btnAddToWishList setImage:[UIImage imageNamed:@"new_wishlist.png"] forState:UIControlStateNormal];
		[btnAddToWishList addTarget:self action:@selector(addToWishMethod:) forControlEvents:UIControlEventTouchUpInside];
		[btnAddToWishList setFrame:CGRectMake( 355, 565,95,40)];
		[btnAddToWishList setTag:303030];
		[currentProductScrollView addSubview:btnAddToWishList];
		[btnAddToWishList setShowsTouchWhenHighlighted:YES];
		
		UILabel *lblWishlist = [[UILabel alloc] init];
		[lblWishlist setBackgroundColor:[UIColor clearColor]];
		[currentProductScrollView addSubview:lblWishlist];
		[lblWishlist setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.mainproduct.addwishlist"]];
		[lblWishlist setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
		[lblWishlist setTextAlignment:UITextAlignmentLeft];
		[lblWishlist setLineBreakMode:UILineBreakModeWordWrap];
		[lblWishlist setNumberOfLines:2];
		[lblWishlist setTextColor:[UIColor whiteColor]];
		[lblWishlist setFrame:CGRectMake(btnAddToWishList.frame.origin.x+38, btnAddToWishList.frame.origin.y+2, 55, 32)];
		[lblWishlist release];
		
	}
	
	
	optionBtn[0]=[UIButton buttonWithType:UIButtonTypeCustom];
	[optionBtn[0] setBackgroundColor:[UIColor clearColor]];
	
	[optionBtn[0] setFrame:CGRectMake(-15, 5 ,210, 35)];
	[optionBtn[0] setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
	[optionBtn[0] setTag:0];
	[optionBtn[0] addTarget:self action:@selector(createTableView:) forControlEvents:UIControlEventTouchUpInside];
	[currentDescriptionScrollView addSubview:optionBtn[0]];
	
	lblOption[0] = [[UILabel alloc]initWithFrame:CGRectMake(20,5,100, 35)];
	
	[lblOption[0] setTextAlignment:UITextAlignmentLeft];
	[lblOption[0] setBackgroundColor:[UIColor clearColor]];
	lblOption[0].textColor=[UIColor blackColor];
	lblOption[0].font=[UIFont systemFontOfSize:14];
	if([arrDropDown[0] count]>0)
		[lblOption[0] setText:[[NSString stringWithFormat:@"Select: %@",[[arrDropDown[0] objectAtIndex:0]valueForKey:@"sTitle"]]capitalizedString]];
	[currentDescriptionScrollView addSubview:lblOption[0]];
	
	int countTemp;
	for(countTemp=1;countTemp<=dropDownCount;countTemp++)
	{
		
		optionBtn[countTemp]=[UIButton buttonWithType:UIButtonTypeCustom];
		[optionBtn[countTemp] setBackgroundColor:[UIColor clearColor]];
		[optionBtn[countTemp] setFrame:CGRectMake(-15,optionBtn[countTemp-1].frame.origin.y+optionBtn[countTemp-1].frame.size.height+8,210,35)];
		[optionBtn[countTemp] setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
		[optionBtn[countTemp] setTag:countTemp];
		[optionBtn[countTemp] addTarget:self action:@selector(createTableView:) forControlEvents:UIControlEventTouchUpInside];
		[currentDescriptionScrollView addSubview:optionBtn[countTemp]];
		
		lblOption[countTemp] = [[UILabel alloc]initWithFrame:CGRectMake(20,optionBtn[countTemp-1].frame.origin.y+optionBtn[countTemp-1].frame.size.height+8,100, 35)];
		[lblOption[countTemp] setTextAlignment:UITextAlignmentLeft];
		[lblOption[countTemp] setBackgroundColor:[UIColor clearColor]];
		lblOption[countTemp].textColor=[UIColor blackColor];
		[lblOption[countTemp] setText:[[NSString stringWithFormat:@"Select: %@",[[arrDropDown[countTemp] objectAtIndex:0]valueForKey:@"sTitle"]]capitalizedString]];
		lblOption[countTemp].font=[UIFont systemFontOfSize:14];
		
		
		[currentDescriptionScrollView addSubview:lblOption[countTemp]];
		
	}	
	
	btnAddCurrentProductToCart=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnAddCurrentProductToCart setTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.mainproduct.addtocart"] forState:UIControlStateNormal];
	[btnAddCurrentProductToCart setTitleColor:btnTextColor forState:UIControlStateNormal];
	[btnAddCurrentProductToCart.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
	[btnAddCurrentProductToCart setBackgroundImage:[UIImage imageNamed:@"add_to_cart.png"] forState:UIControlStateNormal];
	btnAddCurrentProductToCart.backgroundColor = [UIColor clearColor];
	[btnAddCurrentProductToCart addTarget:self action:@selector(addToCartMethod:) forControlEvents:UIControlEventTouchUpInside];
	int j;
	if(dropDownCount<0)
	{
		j=10;
	}
	else {
		j=countTemp*45;
	}


	[btnAddCurrentProductToCart setFrame:CGRectMake(10,j,161,37)];	
	[btnAddCurrentProductToCart setTag:404040];
	[currentDescriptionScrollView addSubview:btnAddCurrentProductToCart];
	[btnAddCurrentProductToCart setShowsTouchWhenHighlighted:YES];	
	
	
	
	
	
	
	imgStockStatusCurrentProduct=[[UIImageView alloc]initWithFrame:CGRectMake(370, 365, 77, 20)];
	[imgStockStatusCurrentProduct setBackgroundColor:[UIColor clearColor]];
	[currentProductScrollView addSubview:imgStockStatusCurrentProduct];	
	
	lblStatusCurrentProduct = [[UILabel alloc] initWithFrame:CGRectMake(370, 365, 77, 20)];
	[lblStatusCurrentProduct setBackgroundColor:[UIColor clearColor]];
	[lblStatusCurrentProduct setTextColor:[UIColor whiteColor]];
	[lblStatusCurrentProduct setTextAlignment:UITextAlignmentCenter];
	[lblStatusCurrentProduct setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
	
	[currentProductScrollView addSubview:lblStatusCurrentProduct];
	
	
	
	NSString*	strStatus = nil;
	BOOL isToBeCartShown;
	strStatus=[dicProduct objectForKey:@"sIPhoneStatus"];
	
	
	if ((strStatus !=nil) &&(![strStatus isEqual:[NSNull null]]))
	{
		if ([strStatus isEqualToString:@"coming"] || [strStatus isEqualToString:@"Coming Soon"])
		{
			[imgStockStatusCurrentProduct setImage:[UIImage imageNamed:@"coming_soon_large.png"]];
			[imgStockStatusCurrentProduct setFrame:CGRectMake(330, 365, 117, 20)];
			[lblStatusCurrentProduct setFrame:CGRectMake(330, 365, 117, 20)];
			[lblStatusCurrentProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.comming.soon"]];
			isToBeCartShown=NO;
		}
		else if ([strStatus isEqualToString:@"sold"] || [strStatus isEqualToString:@"Sold Out"])
		{  	
			[imgStockStatusCurrentProduct setImage:[UIImage imageNamed:@"sold_out_large.png"]];
			[lblStatusCurrentProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
			[btnAddCurrentProductToCart setHidden:YES];
			isToBeCartShown=NO;
		}
		else if ([strStatus isEqualToString:@"active"])
		{
			[imgStockStatusCurrentProduct setImage:[UIImage imageNamed:@"instock_btn_large.png"]];
			[lblStatusCurrentProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.instock"]];
			[btnAddCurrentProductToCart setHidden:NO];
			isToBeCartShown=YES;
		}
	}
	else
	{
		[imgStockStatusCurrentProduct setImage:[UIImage imageNamed:@"sold_out_large.png"]];
		[lblStatusCurrentProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
		[btnAddCurrentProductToCart setHidden:YES];
		isToBeCartShown=NO;
		
	}	
	
	
	if ([[dicProduct valueForKey:@"bUseOptions"] boolValue]==TRUE)
	{
		if(isWishlist)
		{
			[imgStockStatusCurrentProduct setHidden:NO];
            
			NSArray *arrOptions=[optionIndex componentsSeparatedByString:@","];
			if([arrOptions count]==0||[optionArray count]==0)
			{
				[btnAddCurrentProductToCart setHidden:YES];
				[imgStockStatusCurrentProduct setImage:[UIImage imageNamed:@"sold_out_large.png"]];
				[lblStatusCurrentProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
				
				
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
					[btnAddCurrentProductToCart setHidden:YES];
					[imgStockStatusCurrentProduct setImage:[UIImage imageNamed:@"sold_out_large.png"]];
					[lblStatusCurrentProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
					isContained=NO;
					
				}
                
                
                strPriceCurrentProduct=[[TaxCalculation shared]caluatePriceOptionProduct: dicProduct pPrice:optionPrice];
                
                
                [lblProductPrice setText:strPriceCurrentProduct];
                
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
								[btnAddCurrentProductToCart setHidden:YES];
								[imgStockStatusCurrentProduct setImage:[UIImage imageNamed:@"sold_out_large.png"]];
								[lblStatusCurrentProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
								break;
								
							}
							else {
								[imgStockStatusCurrentProduct setImage:[UIImage imageNamed:@"instock_btn_large.png"]];
								[lblStatusCurrentProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.instock"]];
								[btnAddCurrentProductToCart setHidden:NO];
							}
							
						}
					}
				}
				
				
			}
		}
	}		
	else 
	{
		[imgStockStatusCurrentProduct setHidden:NO];
		
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
					[btnAddCurrentProductToCart setHidden:NO]; 
                    
				}
				else
				{
					[btnAddCurrentProductToCart setHidden:YES];
                    [imgStockStatusCurrentProduct setImage:[UIImage imageNamed:@"sold_out_large.png"]];
                    [lblStatusCurrentProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
                    
					
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
    
    NSDictionary* dictProduct1=[dicProduct valueForKey:@"productOptions"];
    
    if (![[dicProduct valueForKey:@"bStockControl"]isEqual:[NSNull null]])
    {
        if ([[dicProduct valueForKey:@"bStockControl"] boolValue] ==FALSE)
        {  
            if (![[dictProduct1 valueForKey:@"productOptions"]isEqual:[NSNull null]])
              {
            
                  if ([dictProduct1 count]==0)
                  {
                      [optionBtn[0] setHidden:YES];
                      [lblOption[0] setHidden:YES];
                      [btnAddCurrentProductToCart setHidden:YES];
                      [imgStockStatusCurrentProduct setImage:[UIImage imageNamed:@"sold_out.png"]];
                      [lblStatusCurrentProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
                  }
              }
        }
    }
    
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
	
	
	int d;
	if(dropDownCount<0)
	{
		d=10;
	}
	else {
		d=countTemp*45;
	}
	
	
	
	if (optionBtn[0].hidden==YES)
    {
		
		[btnAddCurrentProductToCart setFrame:CGRectMake(10,10,161,37)];
    }
	else 
    {
		
		[btnAddCurrentProductToCart setFrame:CGRectMake(10,d,161,37)];
    }
	
	int Yval;
	if(btnAddCurrentProductToCart.hidden && (optionBtn[0].hidden
										  ||lblOption[0].hidden))
		Yval = 10;
	else if(optionBtn[0].hidden
			||lblOption[0].hidden){
		Yval = 60;
	}
	else {
		Yval = countTemp*45+50;
	}

	UILabel *txtProductDescription=[[UILabel alloc]initWithFrame:CGRectMake(10, Yval,300, 150)];
	[txtProductDescription setTextColor:labelColor];
	[txtProductDescription setBackgroundColor:[UIColor clearColor]];
	[txtProductDescription setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
	[txtProductDescription setTag:555];
	NSString *strDescription=[dicProduct objectForKey:@"sDescription"];
	if(![strDescription isEqual:[NSNull null]])
		[txtProductDescription setText:[dicProduct objectForKey:@"sDescription"]];
	else
		[txtProductDescription setText:@"No Description Available"];
	[currentDescriptionScrollView addSubview:txtProductDescription];
	
	
	NSString *text = [txtProductDescription text];
    txtProductDescription.textAlignment = UITextAlignmentLeft;
    txtProductDescription.lineBreakMode = UILineBreakModeWordWrap;
	
    CGSize expectedLabelSize = [text sizeWithFont:txtProductDescription.font 
                                constrainedToSize:txtProductDescription.frame.size
                                    lineBreakMode:UILineBreakModeWordWrap];
	
    newFrame = txtProductDescription.frame;
    newFrame.size.height = expectedLabelSize.height;
	
    txtProductDescription.frame = newFrame;
    txtProductDescription.numberOfLines = 0;
    [txtProductDescription sizeToFit];		
	[txtProductDescription release];
	
	[currentDescriptionScrollView setContentSize:CGSizeMake(330, txtProductDescription.frame.origin.y+txtProductDescription.frame.size.height+50)];
	
	
	
	UILabel *lblDepartmets=[[UILabel alloc]initWithFrame:CGRectMake(45, 16, 150, 30)];
	[lblDepartmets setBackgroundColor:[UIColor clearColor]];
	[lblDepartmets setText:[NSString stringWithFormat:@"%@:", [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.store.tab.department"]]];
	[lblDepartmets setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
	
	lblDepartmets.textColor = headingColor;
	[contentView addSubview:lblDepartmets];
	[lblDepartmets release];
	
	
	UILabel *lblDepartmetsName=[[UILabel alloc]initWithFrame:CGRectMake(141, 16, 150, 30)];
	[lblDepartmetsName setBackgroundColor:[UIColor clearColor]];
	[lblDepartmetsName setText:selectedDepartment];
	[lblDepartmetsName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
	
	[lblDepartmetsName setTextColor:subHeadingColor];
	[contentView addSubview:lblDepartmetsName];
	[lblDepartmetsName release];
	
	UIButton *btnBackToDepts=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnBackToDepts setTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.home.back"] forState:UIControlStateNormal];
	[btnBackToDepts setFrame:CGRectMake(400, 16, 70, 30)];
	[btnBackToDepts.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
	[btnBackToDepts setTitleColor:btnTextColor forState:UIControlStateNormal];
	[btnBackToDepts setBackgroundImage:[UIImage imageNamed:@"edit_cart_btn.png"] forState:UIControlStateNormal];
	btnBackToDepts.backgroundColor = [UIColor clearColor];
	[btnBackToDepts addTarget:self action:@selector(showListOfDepts) forControlEvents:UIControlEventTouchUpInside];
	[contentView addSubview:btnBackToDepts];
	//NextProductScrollView
	
	if(dicNextProduct!=nil)
	{	
		nextProductScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(526, 10, 450, 670)];
		[nextProductScrollView setBackgroundColor:[UIColor clearColor]]; 
		[nextProductScrollView setTag:200];
		[contentView addSubview:nextProductScrollView];
	}
	
	
	UIImageView *imgHorizontalDottedLine1=[[UIImageView alloc]initWithFrame:CGRectMake(549, 52, 426,2)];
	[imgHorizontalDottedLine1 setImage:[UIImage imageNamed:@"dot_line.png"]];
	[contentView addSubview:imgHorizontalDottedLine1];
	[imgHorizontalDottedLine1 release];
	
	
	_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(20, 10, 300, 30)];
	[_searchBar setBackgroundColor:[UIColor clearColor]];
	NSString *str = [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.common.search"];
	[_searchBar setPlaceholder:str];
	[_searchBar setTranslucent:YES];
	[[_searchBar.subviews objectAtIndex:0] removeFromSuperview];	
	[_searchBar setBarStyle:UIBarStyleBlackTranslucent];
	[_searchBar setDelegate:self];
	[nextProductScrollView addSubview:_searchBar];	
	
	
	UIImageView *productNextbackImg = [[UIImageView alloc]initWithFrame:CGRectMake(23, 57, 426, 300)];
	[productNextbackImg setBackgroundColor:[UIColor clearColor]];
	[productNextbackImg setImage:[UIImage imageNamed:@"large_placeholder.png"]];
	[nextProductScrollView addSubview:productNextbackImg];
	
	
	
	
	productImgNextProduct = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 425, 300)];
	[productImgNextProduct setBackgroundColor:[UIColor clearColor]];
	[productNextbackImg addSubview:productImgNextProduct];
	
	
	UIImageView *imgZoomNext = [[UIImageView alloc]initWithFrame:CGRectMake(33,68, 27, 27)];
	[imgZoomNext setBackgroundColor:[UIColor clearColor]];
	[imgZoomNext setImage:[UIImage imageNamed:@"new_search.png"]];
	[nextProductScrollView addSubview:imgZoomNext];
	
	UIButton *btnZoomNext = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnZoomNext setFrame:CGRectMake(23, 57, 426, 300)];
	[btnZoomNext setBackgroundColor:[UIColor clearColor]];
	[btnZoomNext setTag:2000];
	[btnZoomNext addTarget:self action:@selector(zoomMethod:) forControlEvents:UIControlEventTouchUpInside];
	[nextProductScrollView addSubview:btnZoomNext];
	
	
	UILabel *lblProductNameSecond=[[UILabel alloc]initWithFrame:CGRectMake(25, 375, 300, 25)];
	[lblProductNameSecond setBackgroundColor:[UIColor clearColor]];
	[lblProductNameSecond setText:[dicNextProduct valueForKey:@"sName"]];
	[lblProductNameSecond setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:21]];
	[lblProductNameSecond setTextColor:subHeadingColor];
	[nextProductScrollView addSubview:lblProductNameSecond];
	[lblProductNameSecond release];
	
	
	
    lblProductPriceSecond=[[UILabel alloc]initWithFrame:CGRectMake(25, 400, 250, 25)];
	[lblProductPriceSecond setBackgroundColor:[UIColor clearColor]];
	lblProductPriceSecond.textColor = labelColor;
	[lblProductPriceSecond setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:21]];
    [nextProductScrollView addSubview:lblProductPriceSecond];	
	
	[lblProductPriceSecond setText:[[TaxCalculation shared]caluateTaxForProduct:dicNextProduct]];

	nextDescriptionScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(15, 430, 330, 195)];
	[nextDescriptionScrollView setBackgroundColor:[UIColor clearColor]]; 
	[nextDescriptionScrollView setScrollEnabled:YES];
	[nextProductScrollView addSubview:nextDescriptionScrollView];
	
	
		
	
	UIButton *btnSendEmailNextProduct=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnSendEmailNextProduct setBackgroundColor:[UIColor clearColor]];
	[btnSendEmailNextProduct setTag:010101];
	[btnSendEmailNextProduct setImage:[UIImage imageNamed:@"new_email.png"] forState:UIControlStateNormal];
	[btnSendEmailNextProduct addTarget:self action:@selector(sendFeedBack:) forControlEvents:UIControlEventTouchUpInside];
	[btnSendEmailNextProduct setFrame:CGRectMake( 355, 528,95,40)];
	[nextProductScrollView addSubview:btnSendEmailNextProduct];
	[btnSendEmailNextProduct setShowsTouchWhenHighlighted:YES];
	
	
	
	UILabel *lblSendMailNextProduct = [[UILabel alloc] initWithFrame:CGRectMake(btnSendEmailNextProduct.frame.origin.x+39, btnSendEmailNextProduct.frame.origin.y+2, 55, 32)];
	[lblSendMailNextProduct setBackgroundColor:[UIColor clearColor]];
	[nextProductScrollView addSubview:lblSendMailNextProduct];
	[lblSendMailNextProduct setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.mainproduct.sendtofriend"]];
	[lblSendMailNextProduct setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
	[lblSendMailNextProduct setTextAlignment:UITextAlignmentLeft];
	[lblSendMailNextProduct setLineBreakMode:UILineBreakModeWordWrap];
	[lblSendMailNextProduct setNumberOfLines:2];
	[lblSendMailNextProduct setTextColor:[UIColor whiteColor]];
	[lblSendMailNextProduct release];
	
	
		if((![[dicNextProduct objectForKey:@"sVideoUrl"] isEqual:[NSNull null]]) && (![[dicNextProduct objectForKey:@"sVideoUrl"] isEqualToString:@""]))
	{
		
		UIButton *btnWatchVideo=[UIButton buttonWithType:UIButtonTypeCustom];
		[btnWatchVideo setBackgroundColor:[UIColor clearColor]];
		[btnWatchVideo setTag:020202];
		[btnWatchVideo setImage:[UIImage imageNamed:@"new_youtube.png"] forState:UIControlStateNormal];
		[btnWatchVideo addTarget:self action:@selector(watchYouTubeVideo:) forControlEvents:UIControlEventTouchUpInside];
		[btnWatchVideo setFrame:CGRectMake( 355, 478,95,40)];
		[nextProductScrollView addSubview:btnWatchVideo];
		[btnWatchVideo setShowsTouchWhenHighlighted:YES];
		
		
		UILabel *lblWatchVideo = [[UILabel alloc] initWithFrame:CGRectMake(btnWatchVideo.frame.origin.x+38, btnWatchVideo.frame.origin.y+2, 55, 32)];
		[lblWatchVideo setBackgroundColor:[UIColor clearColor]];
		[nextProductScrollView addSubview:lblWatchVideo];
		[lblWatchVideo setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.mainproduct.watchvideo"]];
		[lblWatchVideo setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
		[lblWatchVideo setTextAlignment:UITextAlignmentLeft];
		[lblWatchVideo setLineBreakMode:UILineBreakModeWordWrap];
		[lblWatchVideo setNumberOfLines:2];
		[lblWatchVideo setTextColor:[UIColor whiteColor]];
		[lblWatchVideo release];
	}
	if (!isWishlist)
	{
		
		UIButton *btnAddToWishListSecondProduct=[UIButton buttonWithType:UIButtonTypeCustom];
		[btnAddToWishListSecondProduct setBackgroundColor:[UIColor clearColor]];
		[btnAddToWishListSecondProduct setImage:[UIImage imageNamed:@"new_wishlist.png"] forState:UIControlStateNormal];
		[btnAddToWishListSecondProduct addTarget:self action:@selector(addToWishMethod:) forControlEvents:UIControlEventTouchUpInside];
		[btnAddToWishListSecondProduct setFrame:CGRectMake( 355, 575,95,40)];
		[btnAddToWishListSecondProduct setTag:030303];
		[nextProductScrollView addSubview:btnAddToWishListSecondProduct];
		[btnAddToWishListSecondProduct setShowsTouchWhenHighlighted:YES];	
		
		UILabel *lblWishlistSecondProduct = [[UILabel alloc] init];
		[lblWishlistSecondProduct setBackgroundColor:[UIColor clearColor]];
		[nextProductScrollView addSubview:lblWishlistSecondProduct];
		[lblWishlistSecondProduct setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.mainproduct.addwishlist"]];
		[lblWishlistSecondProduct setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
		[lblWishlistSecondProduct setTextAlignment:UITextAlignmentLeft];
		[lblWishlistSecondProduct setLineBreakMode:UILineBreakModeWordWrap];
		[lblWishlistSecondProduct setNumberOfLines:2];
		[lblWishlistSecondProduct setTextColor:[UIColor whiteColor]];
		[lblWishlistSecondProduct setFrame:CGRectMake(btnAddToWishListSecondProduct.frame.origin.x+38, btnAddToWishListSecondProduct.frame.origin.y+2, 55, 32)];
		[lblWishlistSecondProduct release];
	}
	
	
	optionBtnNext[0]=[UIButton buttonWithType:UIButtonTypeCustom];
	[optionBtnNext[0] setBackgroundColor:[UIColor clearColor]];
	[optionBtnNext[0] setFrame:CGRectMake(-15, 5 ,210, 35)];	
	[optionBtnNext[0] setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
	[optionBtnNext[0] setTag:0];
	[optionBtnNext[0] addTarget:self action:@selector(createTableViewForNextProduct:) forControlEvents:UIControlEventTouchUpInside];
	[nextDescriptionScrollView addSubview:optionBtnNext[0]];
	
	lblOptionNext[0] = [[UILabel alloc]initWithFrame:CGRectMake(20,5,100, 35)];
	[lblOptionNext[0] setTextAlignment:UITextAlignmentLeft];
	[lblOptionNext[0] setBackgroundColor:[UIColor clearColor]];
	lblOptionNext[0].textColor=[UIColor blackColor];
	lblOptionNext[0].font=[UIFont systemFontOfSize:14];
	if([arrDropDownNext[0] count]>0)
		[lblOptionNext[0] setText:[[NSString stringWithFormat:@"Select: %@",[[arrDropDownNext[0] objectAtIndex:0]valueForKey:@"sTitle"]]capitalizedString]];
	[nextDescriptionScrollView addSubview:lblOptionNext[0]];
	
	int countTempNext;
	for(countTempNext=1;countTempNext<=dropDownCountNext;countTempNext++)
	{
		
		optionBtnNext[countTempNext]=[UIButton buttonWithType:UIButtonTypeCustom];
		[optionBtnNext[countTempNext] setBackgroundColor:[UIColor clearColor]];
		[optionBtnNext[countTempNext] setFrame:CGRectMake(-15,optionBtnNext[countTempNext-1].frame.origin.y+optionBtnNext[countTempNext-1].frame.size.height+8,210,35)];
		[optionBtnNext[countTempNext] setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
		[optionBtnNext[countTempNext] setTag:countTempNext];
		[optionBtnNext[countTempNext] addTarget:self action:@selector(createTableViewForNextProduct:) forControlEvents:UIControlEventTouchUpInside];
		[nextDescriptionScrollView addSubview:optionBtnNext[countTempNext]];
		
		lblOptionNext[countTempNext] = [[UILabel alloc]initWithFrame:CGRectMake(20,optionBtnNext[countTempNext-1].frame.origin.y+optionBtnNext[countTempNext-1].frame.size.height+8,100, 35)];
		[lblOptionNext[countTempNext] setTextAlignment:UITextAlignmentLeft];
		[lblOptionNext[countTempNext] setBackgroundColor:[UIColor clearColor]];
		lblOptionNext[countTempNext].textColor=[UIColor blackColor];
		[lblOptionNext[countTempNext] setText:[[NSString stringWithFormat:@"Select: %@",[[arrDropDownNext[countTempNext] objectAtIndex:0]valueForKey:@"sTitle"]]capitalizedString]];
		lblOptionNext[countTempNext].font=[UIFont systemFontOfSize:14];
		
		
		[nextDescriptionScrollView addSubview:lblOptionNext[countTempNext]];
		
	}	
	
	btnAddNextProductToCart=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnAddNextProductToCart setTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.mainproduct.addtocart"] forState:UIControlStateNormal];
	[btnAddNextProductToCart setTitleColor:btnTextColor forState:UIControlStateNormal];
	[btnAddNextProductToCart.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
	[btnAddNextProductToCart setBackgroundImage:[UIImage imageNamed:@"add_to_cart.png"] forState:UIControlStateNormal];
	btnAddNextProductToCart.backgroundColor = [UIColor clearColor];
	[btnAddNextProductToCart addTarget:self action:@selector(addToCartMethod:) forControlEvents:UIControlEventTouchUpInside];
	
	int k;
	if(dropDownCountNext<0)
		k=10;
	else {
		k=countTempNext*45;
	}
	
	[btnAddNextProductToCart setFrame:CGRectMake(10,k,161,37)];		
	[btnAddNextProductToCart setTag:040404];
	[nextDescriptionScrollView addSubview:btnAddNextProductToCart];
	[btnAddNextProductToCart setShowsTouchWhenHighlighted:YES];	
	
		
	
	imgStockStatusNextProduct=[[UIImageView alloc]initWithFrame:CGRectMake(370, 375, 77, 20)];
	[imgStockStatusNextProduct setBackgroundColor:[UIColor clearColor]];
	[nextProductScrollView addSubview:imgStockStatusNextProduct];
	
	
	lblStatusNextProduct = [[UILabel alloc] initWithFrame:CGRectMake(370, 375, 77, 20)];
	[lblStatusNextProduct setBackgroundColor:[UIColor clearColor]];
	[lblStatusNextProduct setTextColor:[UIColor whiteColor]];
	[lblStatusNextProduct setTextAlignment:UITextAlignmentCenter];
	[lblStatusNextProduct setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
	
	[nextProductScrollView addSubview:lblStatusNextProduct];
	
	
	NSString*	strStatusNextProduct = nil;
	BOOL isToBeCartShownNext;
	if(dicNextProduct!= nil)
		strStatusNextProduct=[dicNextProduct objectForKey:@"sIPhoneStatus"];
	
	
	if ((strStatusNextProduct !=nil) &&(![strStatusNextProduct isEqual:[NSNull null]]))
	{
		if ([strStatusNextProduct isEqualToString:@"coming"] || [strStatusNextProduct isEqualToString:@"Coming Soon"])
		{
			[imgStockStatusNextProduct setImage:[UIImage imageNamed:@"coming_soon_large.png"]];
			[lblStatusNextProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.comming.soon"]];
			[imgStockStatusNextProduct setFrame:CGRectMake(323, 365, 117,20)];
			[lblStatusNextProduct setFrame:CGRectMake(330, 365, 117, 20)];
			strStatusNextProduct=NO;
		}
		else if ([strStatusNextProduct isEqualToString:@"sold"] || [strStatusNextProduct isEqualToString:@"Sold Out"])
		{  	
			[imgStockStatusNextProduct setImage:[UIImage imageNamed:@"sold_out_large.png"]];
			[lblStatusNextProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
			[btnAddNextProductToCart setHidden:YES];
			isToBeCartShownNext=NO;
		}
		else if ([strStatusNextProduct isEqualToString:@"active"])
		{
			[imgStockStatusNextProduct setImage:[UIImage imageNamed:@"instock_btn_large.png"]];
			[lblStatusNextProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.instock"]];
			[btnAddNextProductToCart setHidden:NO];
			isToBeCartShownNext=YES;
		}
	}
	else
	{
		[imgStockStatusNextProduct setImage:[UIImage imageNamed:@"sold_out_large.png"]];
		[lblStatusNextProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
		[btnAddNextProductToCart setHidden:YES];
		isToBeCartShownNext=NO;
		
	}	
	
	if ([[dicNextProduct valueForKey:@"bUseOptions"] boolValue]==TRUE)
	{
		if(isWishlist)
		{
			[imgStockStatusNextProduct setHidden:NO];	
            
			NSArray *arrOptions=[optionIndex componentsSeparatedByString:@","];
			if([arrOptions count]==0||[optionsArrayNextProduct count]==0)
			{
				[btnAddNextProductToCart setHidden:YES];
				[imgStockStatusNextProduct setImage:[UIImage imageNamed:@"sold_out_large.png"]];
				[lblStatusNextProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
				
				
			}
			
			
			NSMutableArray *arrProductOptionSize = [[[NSMutableArray alloc] init] autorelease];
			
			for(int i=0; i<[optionsArrayNextProduct count]; i++)
			{
				[arrProductOptionSize addObject:[[optionsArrayNextProduct objectAtIndex:i] valueForKey:@"id"]];
			}
			BOOL isContained=YES;	
			int optionSizeIndex[100];
			for(int i=0;i<[arrOptions count];i++)
			{
				if([arrProductOptionSize containsObject: [NSNumber numberWithInt:[[arrOptions objectAtIndex:i] integerValue]]])
				{
					optionSizeIndex[i] =[arrProductOptionSize indexOfObject:[NSNumber numberWithInt:[[arrOptions objectAtIndex:i]intValue]]];
				}
				else {
					[btnAddNextProductToCart setHidden:YES];
					[imgStockStatusNextProduct setImage:[UIImage imageNamed:@"sold_out_large.png"]];
					[lblStatusNextProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
					isContained=NO;
					
				}
			}
			if(![optionsArrayNextProduct isKindOfClass:[NSNull class]])
			{
				if([optionsArrayNextProduct count]>0)
				{
					if(isContained==YES)
					{
						for(int count=0;count<[arrOptions count];count++)
						{
							if([[[optionsArrayNextProduct objectAtIndex:optionSizeIndex[count]] valueForKey:@"iAvailableQuantity"] intValue] == 0)
							{
								[btnAddNextProductToCart setHidden:YES];
								[imgStockStatusNextProduct setImage:[UIImage imageNamed:@"sold_out_large.png"]];
								[lblStatusNextProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
								break;
								
							}
							else {
								[imgStockStatusNextProduct setImage:[UIImage imageNamed:@"instock_btn_large.png"]];
								[lblStatusNextProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.instock"]];
								[btnAddNextProductToCart setHidden:NO];
							}
							
						}
					}
				}
				
				
			}
		}
	}		
	else 
	{
		[imgStockStatusNextProduct setHidden:NO];
		
		if (![[dicNextProduct valueForKey:@"bStockControl"]isEqual:[NSNull null]])
		{
			if ([[dicNextProduct valueForKey:@"bStockControl"] boolValue] ==TRUE)
			{
				[optionBtnNext[0] setHidden:YES];
				[lblOptionNext[0] setHidden:YES];
				for(int countTemp1=1;countTemp1<=dropDownCountNext;countTemp1++)
				{
					[optionBtnNext[countTemp1] setHidden:YES];
					[lblOptionNext[countTemp1] setHidden:YES];
				}
				
				if ([[dicNextProduct valueForKey:@"iAggregateQuantity"]intValue]!=0 && isToBeCartShownNext==YES)
				{
					[btnAddNextProductToCart setHidden:NO]; 
                    				}
				else
				{
					[btnAddNextProductToCart setHidden:YES];
                    [imgStockStatusNextProduct setImage:[UIImage imageNamed:@"sold_out_large.png"]];
                    [lblStatusNextProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
				}
			}
			else 
            {
				
				[optionBtnNext[0] setHidden:YES];
				[lblOptionNext[0] setHidden:YES];
				for(int countTemp1=1;countTemp1<=dropDownCountNext;countTemp1++)
				{
					[optionBtnNext[countTemp1] setHidden:YES];
					[lblOptionNext[countTemp1] setHidden:YES];
				}
				
			}
		}
	}
    

    NSDictionary* dictProduct2=[dicNextProduct valueForKey:@"productOptions"];
    
    if (![[dicNextProduct valueForKey:@"bStockControl"]isEqual:[NSNull null]])
    {
        if ([[dicNextProduct valueForKey:@"bStockControl"] boolValue] ==FALSE)
        {
            
            if ([dictProduct2 count]==0)
            {
                [optionBtnNext[0] setHidden:YES];
                [lblOptionNext[0] setHidden:YES];
                [btnAddNextProductToCart setHidden:YES];
                [imgStockStatusNextProduct setImage:[UIImage imageNamed:@"sold_out_large.png"]];
                [lblStatusNextProduct setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
            }
        }
    }

	if (isWishlist)
	{
		
		[optionBtnNext[0] setHidden:YES];
		[lblOptionNext[0] setHidden:YES];
		for(int countTemp1=1;countTemp1<=dropDownCountNext;countTemp1++)
		{
			[optionBtnNext[countTemp1] setHidden:YES];
			[lblOptionNext[countTemp1] setHidden:YES];
		}
		
		
		
	}	
	
	int l;
	if(dropDownCountNext<0)
	{
		l=10;
	}
	else {
		l=countTempNext*45;
	}
	
	
	
	if (optionBtnNext[0].hidden==YES)
    {
		
		[btnAddNextProductToCart setFrame:CGRectMake(10,10,161,37)];
    }
	else 
    {
		
		[btnAddNextProductToCart setFrame:CGRectMake(10,l,161,37)];
    }
	
	
	
	
	int Yval2;
	if(btnAddNextProductToCart.hidden && (optionBtnNext[0].hidden
										  ||lblOptionNext[0].hidden))
		Yval2 = 10;
	else if(optionBtnNext[0].hidden
			||lblOptionNext[0].hidden){
		Yval2 = 60;
	}
	else {
		Yval2 = countTempNext*45+50;
	}
	
	
	
	UILabel *txtProductDescriptionSecond=[[UILabel alloc]initWithFrame:CGRectMake(10, Yval2,300, 150)];
	[txtProductDescriptionSecond setTag:666];
	[txtProductDescriptionSecond setTextColor:labelColor];
	[txtProductDescriptionSecond setBackgroundColor:[UIColor clearColor]];
	[txtProductDescriptionSecond setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
	
	NSString *strDescriptionSecond=[dicNextProduct objectForKey:@"sDescription"];
	if(![strDescriptionSecond isEqual:[NSNull null]])
		[txtProductDescriptionSecond setText:[dicNextProduct objectForKey:@"sDescription"]];
	else
		[txtProductDescriptionSecond setText:@"No Description Available"];
	
	[nextDescriptionScrollView addSubview:txtProductDescriptionSecond];
	
	NSString *text2 = [txtProductDescriptionSecond text];
    txtProductDescriptionSecond.textAlignment = UITextAlignmentLeft;
    txtProductDescriptionSecond.lineBreakMode = UILineBreakModeWordWrap;
	
    CGSize expectedLabelSize2 = [text2 sizeWithFont:txtProductDescriptionSecond.font 
								  constrainedToSize:txtProductDescriptionSecond.frame.size
									  lineBreakMode:UILineBreakModeWordWrap];
	
    newFrame2 = txtProductDescriptionSecond.frame;
    newFrame2.size.height = expectedLabelSize2.height;
    txtProductDescriptionSecond.frame = newFrame2;
    txtProductDescriptionSecond.numberOfLines = 0;
    [txtProductDescriptionSecond sizeToFit];		
	[txtProductDescriptionSecond release];
	
	
	[nextDescriptionScrollView setContentSize:CGSizeMake(330, txtProductDescriptionSecond.frame.origin.y+txtProductDescriptionSecond.frame.size.height+50)];
	
	
	
	[self markStarRating_onView:currentProductScrollView withTag:100];
	[self markStarRating_onView:nextProductScrollView withTag:200];
	
	
	UIImageView *imgBottomLineLeft=[[UIImageView alloc]initWithFrame:CGRectMake(24, 618, 426,2)];
	[imgBottomLineLeft setImage:[UIImage imageNamed:@"dot_line.png"]];
	[currentProductScrollView addSubview:imgBottomLineLeft];
	[imgBottomLineLeft release];
	
	UIImageView *imgBottomLineRight=[[UIImageView alloc]initWithFrame:CGRectMake(24, 628, 426,2)];
	[imgBottomLineRight setImage:[UIImage imageNamed:@"dot_line.png"]];
	[nextProductScrollView addSubview:imgBottomLineRight];
	[imgBottomLineRight release];
	
	UIButton *btnPostReviewLeft=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnPostReviewLeft setTag:3000];
	[btnPostReviewLeft setFrame:CGRectMake(352, 627, 97, 24)];
	[btnPostReviewLeft setBackgroundColor:[UIColor clearColor]];
	
	[btnPostReviewLeft setTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.mainproduct.postreview"] forState:UIControlStateNormal];
	[btnPostReviewLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[btnPostReviewLeft setBackgroundImage:[UIImage imageNamed:@"post_a_review.png"] forState:UIControlStateNormal];
	[btnPostReviewLeft.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
	[btnPostReviewLeft addTarget:self action:@selector(btnReadReview_clicked:)forControlEvents:UIControlEventTouchUpInside];
	[currentProductScrollView addSubview:btnPostReviewLeft];
	
	UIButton *btnPostReviewRight=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnPostReviewRight setTag:4000];
	[btnPostReviewRight setFrame:CGRectMake(352, 637, 97, 24)];
	[btnPostReviewRight setBackgroundColor:[UIColor clearColor]];
	[btnPostReviewRight setBackgroundImage:[UIImage imageNamed:@"post_a_review.png"] forState:UIControlStateNormal];
	[btnPostReviewRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[btnPostReviewRight.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
	[btnPostReviewRight setTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.mainproduct.postreview"] forState:UIControlStateNormal];
	[btnPostReviewRight addTarget:self action:@selector(btnReadReview_clicked:)forControlEvents:UIControlEventTouchUpInside];
	[nextProductScrollView addSubview:btnPostReviewRight];
	
	UIButton *	btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
	btnCart.frame = CGRectMake(903, 14, 78,34);
	[btnCart setBackgroundColor:[UIColor clearColor]];
	[btnCart setImage:[UIImage imageNamed:@"add_cart.png"] forState:UIControlStateNormal];
	[btnCart addTarget:self action:@selector(btnShoppingCart_Clicked:) forControlEvents:UIControlEventTouchUpInside];
	[contentView addSubview:btnCart];
	[contentView bringSubviewToFront:btnCart];
	
	
	lblCart = [[UILabel alloc] initWithFrame:CGRectMake(42, 2, 30, 30)];
	lblCart.backgroundColor = [UIColor clearColor];
	lblCart.textAlignment = UITextAlignmentCenter;
	lblCart.font = [UIFont boldSystemFontOfSize:16];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	lblCart.textColor = [UIColor whiteColor];	 
	[btnCart addSubview:lblCart];
	
}


-(void)showListOfDepts
{
	[self.navigationController popViewControllerAnimated:YES];
	
}
-(void)btnReadReview_clicked:(UIButton *)sender
{ 
	
	ReadReviews *objReadView=[[ReadReviews alloc]init];
	if(sender.tag==3000)
		objReadView.selectedProductId=[[dicProduct objectForKey:@"id"]intValue];
	else if(sender.tag == 1)
		objReadView.selectedProductId=[[dicProduct objectForKey:@"id"]intValue];
	
	if(sender.tag==4000)
		objReadView.selectedProductId=[[dicNextProduct objectForKey:@"id"]intValue];	else if(sender.tag == 2)
			objReadView.selectedProductId=[[dicNextProduct objectForKey:@"id"]intValue];		
	
	[self.navigationController pushViewController:objReadView animated:YES];
	[objReadView release];
	
}
-(void)viewWillAppear:(BOOL)animated
{
	self.navigationController.navigationBar.hidden = YES;
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	if([GlobalPrefrences isClickedOnFeaturedProductFromHomeTab])
	{
		[GlobalPrefrences setIsClickedOnFeaturedImage:NO];
		[GlobalPrefrences setCanPopToRootViewController:YES];
	}
	[NSTimer scheduledTimerWithTimeInterval:0.01
									 target:self
								   selector:@selector(hideLoadingView)
								   userInfo:nil
									repeats:NO];
	
	
	if (![GlobalPrefrences isInternetAvailable])
	{
		NSString* errorString = [[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.text"];
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.title"] message:errorString delegate:self cancelButtonTitle:nil otherButtonTitles:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"], nil];
		[errorAlert show];
		[errorAlert release];
	}
	else 
	{	
		
		arrDropDownTable=[[NSArray alloc]init];
		pastIndex=-1;
		
		arrDropDownTableNext=[[NSArray alloc]init];
		pastIndexNext=-1;
		
		contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
		self.view=contentView;
		[contentView setBackgroundColor:[UIColor colorWithRed:78.4/100 green:89.0/100 blue:87.8 alpha:1]];
		
		[GlobalPrefrences setCurrentNavigationController:self.navigationController];
		
		[GlobalPrefrences setBackgroundTheme_OnView:contentView];
		[self performSelectorInBackground:@selector(fetchDataFromServer:) withObject:[NSNumber numberWithBool:NO]];
		[self dataValidationChecks];
		
		[self performSelectorOnMainThread:@selector(createBasicControls) withObject:nil waitUntilDone:NO];
		[self allocateMemoryToObjects];
	}

	
	
	
}

-(void)hideLoadingView
{
	[GlobalPrefrences dismissLoadingBar_AtBottom];	
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
   
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnteredBackground) 
                                                 name: UIApplicationDidBecomeActiveNotification
                                               object: nil];
[super viewDidLoad];
}

-(void)handleEnteredBackground{
 [NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
    [self viewWillAppear:YES];
    
}

#pragma mark - fetchDataFromServer

-(void)fetchDataFromServer:(NSNumber *)isHandlingZoomImage
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSArray  *arrImagesUrls = [dicProduct objectForKey:@"productImages"];
	
	NSArray *arrNextImageUrls=[dicNextProduct objectForKey:@"productImages"];
	
	if(arrImagesUrls)
		[self displayProductImage:arrImagesUrls picToShowAtAIndex:0];
	
	if(arrNextImageUrls)
		[self displayProductImage:arrNextImageUrls picToShowAtAIndex:1];
	
	
	[pool release];
	
}
//reload the image of product , once it is loaded from the server	 
-(void) resetControls
{
	if((productImg) || (productImg.image==nil))
	{
			UIImage *imgprod1 = [UIImage imageWithData:dataForProductImage];
			int	y1= (300 - imgprod1.size.height)/2;
			int x1 = (425 - imgprod1.size.width)/2;
			int h1 = imgprod1.size.height;
			int w1 = imgprod1.size.width;
       
        float actualHeight = imgprod1.size.height;
        float actualWidth = imgprod1.size.width;
        float imgRatio = actualWidth/actualHeight;
        float maxRatio = 200/300.0;
        
        if(imgRatio!=maxRatio){
            if(imgRatio < maxRatio){
                imgRatio = 310 / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = 310;
            }
            else{
                imgRatio = 220 / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = 220;
            }
        }
      
        
        NSLog(@"test%d ",h1);
        
        
        if(h1<301)
        {
         [productImg setFrame:CGRectMake(x1, y1, w1, h1)];   
        }else
        {
          
          [productImg setFrame:CGRectMake((425 -actualWidth)/2,0, actualWidth, actualHeight)]; 
        }
        
      
        
			[productImg setImage:[UIImage imageWithData:dataForProductImage]];
		
		
	}
			
	if((productImgNextProduct) || (productImgNextProduct.image==nil))
	{
		UIImage *imgprod2 = [UIImage imageWithData:dataForNextProductImage];
		int	y2= (300 - imgprod2.size.height)/2;
		int x2 = (425 - imgprod2.size.width)/2;
		int h2 = imgprod2.size.height;
		int w2 = imgprod2.size.width;
		
        float actualHeight = imgprod2.size.height;
        float actualWidth = imgprod2.size.width;
        float imgRatio = actualWidth/actualHeight;
        float maxRatio = 200.0/300.0;
        
        if(imgRatio!=maxRatio){
            if(imgRatio < maxRatio){
                imgRatio = 310 / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = 310;
            }
            else{
                imgRatio = 220 / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = 220;
            }
        }
        
        
        
        
        
        if(h2<301)
        {
            [productImgNextProduct setFrame:CGRectMake(x2, y2, w2, h2)];   
        }else
        {
            
            [productImgNextProduct setFrame:CGRectMake((425 -actualWidth)/2, 0.0, actualWidth, actualHeight)]; 
        }
        

     

		[productImgNextProduct setImage:[UIImage imageWithData:dataForNextProductImage]];
	}
}
#pragma mark Dispaly product image
-(void)displayProductImage:(NSArray *)arrImagesUrls picToShowAtAIndex:(NSInteger)_picNum
{
    
    if (![arrImagesUrls isEqual:[NSNull null]])
    {
        if(_picNum==0)
        {
            if([arrImagesUrls count]==0)
            {
                
                dataForProductImage = [[[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noImage_M" ofType:@"png"]] autorelease];
                
                
            }
            else 
            {
                dataForProductImage = [ServerAPI fetchBannerImage:[[arrImagesUrls objectAtIndex:_picNum] objectForKey:@"productImageCoverFlowIphone4"]];
            }
        }	
        else {
            if([arrImagesUrls count]==0)
            {
                dataForNextProductImage = [[[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noImage_M" ofType:@"png"]] autorelease];
                
            }
            else 
            {
                dataForNextProductImage = [ServerAPI fetchBannerImage:[[arrImagesUrls objectAtIndex:0] objectForKey:@"productImageCoverFlowIphone4"]];
            }
        }
	
	
	
	}
	
	
	
	
	if(!dataForProductImage)
	{
		dataForProductImage = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noImage_M" ofType:@"png"]];
	}
	
	if(!dataForNextProductImage)
	{
		dataForNextProductImage = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noImage_M" ofType:@"png"]];
	}
	
	
	[self performSelectorOnMainThread:@selector(resetControls) withObject:nil waitUntilDone:YES];
	
}


#pragma mark -Zoom Image
-(void)zoomMethod:(UIButton *)sender
{
	[_searchBar resignFirstResponder];
	_searchBar.showsCancelButton = NO;
	NSMutableArray  *arrImagesUrls;
	if(sender.tag==1000)
	{
		
		
		arrImagesUrls = [dicProduct objectForKey:@"productImages"];
	}
	
	else {
		
		arrImagesUrls = [dicNextProduct objectForKey:@"productImages"];
	}
    if(![arrImagesUrls isEqual:[NSNull null]])
    {
        if([arrImagesUrls count]>0)
        {
            [NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
             CoverFlowViewController *objFlowCover = [[CoverFlowViewController alloc] init];
            objFlowCover.arrImages = arrImagesUrls;
            [self.navigationController pushViewController:objFlowCover animated:YES];
            [objFlowCover release];
            
        }
        
        else {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.detail.no.image"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
	
	}
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return productImg;
}



#pragma mark Add To Wishlist 

-(void)addToWishMethod:(UIButton*)sender
{
	
	int	_tag=[sender tag];
	
	
	
	if(_tag==303030)
	{
		
		BOOL isAllOptionsSelected=YES;
		
		if (![[dicProduct valueForKey:@"bUseOptions"] intValue]==0)
        {
        
        for(int i=0;i<=dropDownCount;i++)
		{
			
			if([[lblOption[i].text lowercaseString]  isEqualToString:[[NSString stringWithFormat:@"Select: %@",[[arrDropDown[i] objectAtIndex:0]objectForKey:@"sTitle"]]lowercaseString]])
			{
				
				isAllOptionsSelected=NO;
				break;
			}
		}
     }
		if(isAllOptionsSelected==NO)
			
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
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
				UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.detail.already.added"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
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
					UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.detail.add.wishlist"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
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
						
						UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.detail.add.wishlist"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
						[alert show];
						
						[alert release];
					}
				}
			}
		}
    }
	else
	{
		BOOL isAllOptionsSelected=YES;
		if (![[dicProduct valueForKey:@"bUseOptions"] intValue]==0)
        {
		for(int i=0;i<=dropDownCountNext;i++)
		{
			
			if([[lblOptionNext[i].text lowercaseString]  isEqualToString:[[NSString stringWithFormat:@"Select: %@",[[arrDropDownNext[i] objectAtIndex:0]objectForKey:@"sTitle"]]lowercaseString]])
			{
				
				isAllOptionsSelected=NO;
				break;
			}
		}
		}
		if(isAllOptionsSelected==NO)
			
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			[alert show];
			[alert release];	
        }
		else
		{
			NSMutableArray *arrAddedToWishlist = [[SqlQuery shared]getWishlistProductIDs:YES];
			
			NSMutableArray *arrProductID = [[[NSMutableArray alloc] init] autorelease];
			arrProductID = [arrAddedToWishlist valueForKey:@"id"];
			
			NSMutableArray *arrProductSize = [[[NSMutableArray alloc] init] autorelease];
			arrProductSize = [[SqlQuery shared] getWishListProductSizes:[[dicNextProduct objectForKey:@"id"]intValue]];
			
			
			
			BOOL isContained =NO;
			
			if([arrProductSize count]>0)
			{
				
				for(int count=0;count<[arrProductSize count];count++)
				{
					if(isContained==NO)
					{
						
						NSArray *arrOptions=[[arrProductSize objectAtIndex:count] componentsSeparatedByString:@","];
						if([arrOptions count]==dropDownCountNext+1)
						{
							for(int count=0;count<=dropDownCountNext;count++)
								
							{
								NSNumber *optionID = [NSNumber numberWithInt:[[[arrDropDownNext[count] objectAtIndex:selectedIndexNext[count]] valueForKey:@"id"] intValue]];
								
								
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
			
			
			if ([[dicNextProduct valueForKey:@"bUseOptions"] intValue]==0)
			{
				if ([arrProductSize count] != 0)
				{
					if ([[arrProductSize objectAtIndex:0] isEqualToString:@"0"])
					{
						isContained = YES;
					}
				}
			} 
			
			if ([arrProductID containsObject:[NSString stringWithFormat:@"%@", [dicNextProduct objectForKey:@"id"]]] && isContained)
			{
				UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.detail.already.added"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
				[alert show];
				[alert release];			
            }
			else
			{
				NSString *strProductOptions=@"";	
				
				// Convert product image into NSData, so it can be saved into the sqlite3 database
				if ([[dicNextProduct valueForKey:@"bUseOptions"] intValue]==0)
				{
					strProductOptions=@"0";
					[[SqlQuery shared] setTblWishlist:[[dicNextProduct objectForKey:@"id"] intValue] :1 :strProductOptions];
					UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.detail.add.wishlist"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
					[alert show];
					
					[alert release];			
                }
				else
				{
					if ([optionsArrayNextProduct count]>0)
					{
						for(int count=0;count<=dropDownCountNext;count++)
						{
							if(count==dropDownCountNext)
							{
								strProductOptions=[strProductOptions   stringByAppendingFormat:@"%@",[[arrDropDownNext[count] objectAtIndex:selectedIndexNext[count]]objectForKey:@"id"]];	
							}
							else
							{
								strProductOptions=[strProductOptions stringByAppendingFormat:@"%@,",[[arrDropDownNext[count] objectAtIndex:selectedIndexNext[count]]objectForKey:@"id"]];	
							}
						}
						[[SqlQuery shared] setTblWishlist:[[dicNextProduct objectForKey:@"id"] intValue] :1 :strProductOptions];
						UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.detail.add.wishlist"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
						[alert show];
						
						[alert release];
					}
				}
			}
		}
	}
}

#pragma mark Add To Shopping Cart


-(void)addToCartMethod:(UIButton*)sender
{		
	
	int _tag=[sender tag];
	//Add to cart for first product
	if(_tag==404040)
	{
		if(!isWishlist)
		{
			BOOL isAllOptionsSelected=YES;
			
            if (![[dicProduct valueForKey:@"bUseOptions"] intValue]==0)
            {
            for(int i=0;i<=dropDownCount;i++)
			{
				if([[lblOption[i].text lowercaseString]  isEqualToString:[[NSString stringWithFormat:@"Select: %@",[[arrDropDown[i] objectAtIndex:0]objectForKey:@"sTitle"]]lowercaseString]])
				{
					isAllOptionsSelected=NO;
					break;
				}
			}
           }
			if(isAllOptionsSelected==NO)
				
			{
				UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
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
                else 
                
                {

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
								NSLog(@"%d",quantityAdded[i]);
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
					
					
					if(max==0)
					{
						
						isTobeAdded=NO;
						
					}
					
				}
				}
				
				if ([arrProductID containsObject:[NSString stringWithFormat:@"%@", [dicProduct objectForKey:@"id"]]] && isContained)
				{
					UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.alreadyadded.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
					[alert show];
					[alert release];
				}
				
				else if(isTobeAdded==NO)
				{
					
					UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.detail.cannot.added"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
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
						[GlobalPrefrences setCurrentItemsInCart:YES];
						
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
							
							[GlobalPrefrences setCurrentItemsInCart:YES];
							
							
							
						}		
						else 
						{
							UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.detail.cannot.added"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
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
					
					viewForAnimationEffect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 500)];
					[viewForAnimationEffect setBackgroundColor:[UIColor clearColor]];
					[contentView addSubview:viewForAnimationEffect];
					
					UIImageView* rotatingImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 400, 400)];
					if ([dicProduct count]>0) 
						[rotatingImage setImage:productImg.image];
					else
						[rotatingImage setImage:[UIImage imageNamed:@"Icon.png"]];
					
					
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
					rotatingImage.frame = CGRectMake(900,0, 0, 0);
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
				UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.alreadyadded.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
			
			else if(isTobeAdded==NO)
			{
				
				UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.detail.cannot.added"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
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
					[GlobalPrefrences setCurrentItemsInCart:YES];
					
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
						
						[GlobalPrefrences setCurrentItemsInCart:YES];
						
					}		
					else 
					{
						UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.detail.cannot.added"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
						[alert show];
						[alert release];
					}
				}
				
				
				
				SystemSoundID soundID;
				NSURL *filePath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] resourcePath], @"/pickup_coin.wav"] isDirectory:NO];
				AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
				AudioServicesPlaySystemSound(soundID);
				
				
				viewForAnimationEffect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 500)];
				[viewForAnimationEffect setBackgroundColor:[UIColor clearColor]];
				[contentView addSubview:viewForAnimationEffect];
				
				UIImageView* rotatingImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 400, 400)];
				if ([dicProduct count]>0) 
					[rotatingImage setImage:productImg.image];
				else
					[rotatingImage setImage:[UIImage imageNamed:@"Icon.png"]];
				
				
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
				rotatingImage.frame = CGRectMake(900,0, 0, 0);
				[UIView setAnimationDelegate:self];
				
				[UIView setAnimationDidStopSelector:@selector(animationEnded:)];
				[UIView commitAnimations];
				
				[rotatingImage release];				
				
			}
			
		}
		
	}
	
	//Add to cart for next product
	else
	{
		if(!isWishlist)
		{
			
			BOOL isAllOptionsSelected=YES;
			if (![[dicNextProduct valueForKey:@"bUseOptions"] intValue]==0)
            {
			for(int i=0;i<=dropDownCountNext;i++)
			{
				
				if([[lblOptionNext[i].text lowercaseString]  isEqualToString:[[NSString stringWithFormat:@"Select: %@",[[arrDropDownNext[i] objectAtIndex:0]objectForKey:@"sTitle"]]lowercaseString]])
				{
					
					isAllOptionsSelected=NO;
					break;
				}
			}
           }
			
			if(isAllOptionsSelected==NO)
				
			{
				UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
				[alert show];
				[alert release];
				
				
			}
			else
			{
				NSMutableArray *arrAddedToShoppingCart = [[SqlQuery shared]getShoppingCartProductIDs:NO];
				NSMutableArray *arrProductID = [[[NSMutableArray alloc] init] autorelease];
				arrProductID = [arrAddedToShoppingCart valueForKey:@"id"];
				
				NSMutableArray *arrProductSize = [[[NSMutableArray alloc] init] autorelease];
				arrProductSize = [[SqlQuery shared] getShoppingProductSizes:[[dicNextProduct objectForKey:@"id"]intValue]];
				
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
                else
                {
				if([arrProductSize count]>0)
				{
					
					for(int count=0;count<[arrProductSize count];count++)
					{
						if(isContained==NO)
						{
							
							NSArray *arrOptions=[[arrProductSize objectAtIndex:count] componentsSeparatedByString:@","];
							if([arrOptions count]==dropDownCountNext+1)
							{
								for(int count=0;count<=dropDownCountNext;count++)
									
								{
									NSNumber *optionID = [NSNumber numberWithInt:[[[arrDropDownNext[count] objectAtIndex:selectedIndexNext[count]] valueForKey:@"id"] intValue]];
									
									
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
						if([[[arrAddedToShoppingCart objectAtIndex:count] valueForKey:@"id"]intValue]==[[dicNextProduct objectForKey:@"id"]intValue])
						{
							[arrSameProductOptions addObject:[arrAddedToShoppingCart objectAtIndex:count]];	
							
						}	
						
						
					}
					
				}
				
				int quantityAdded[100];
				int minQuantityCheck[100];
				for(int i=0;i<=dropDownCountNext;i++)
				{
					quantityAdded[i]=0;	
					minQuantityCheck[i]=0;
					
				}	
				
				for(int i=0;i<=dropDownCountNext;i++)
				{
					for(int j=0;j<[arrSameProductOptions count];j++)     	
					{
						
						NSArray *arrayOptions=[[[arrSameProductOptions objectAtIndex:j]valueForKey:@"pOptionId"] componentsSeparatedByString:@","];
						
						for(int k=0;k<[arrayOptions count];k++)
						{
							
							if([[[arrDropDownNext[i] objectAtIndex:selectedIndexNext[i]]valueForKey:@"id"]intValue]==[[arrayOptions objectAtIndex:k]intValue])
							{
								
								quantityAdded[i]=quantityAdded[i]+[[[arrSameProductOptions objectAtIndex:j]objectForKey:@"quantity"]intValue];
								NSLog(@"%d",quantityAdded[i]);
							}	
						}
						
					}	
				}
				for(int count=0;count<=dropDownCountNext;count++)
				{
					minQuantityCheck[count]=[[[arrDropDownNext[count] objectAtIndex:selectedIndexNext[count]]objectForKey:@"iAvailableQuantity"]intValue];
					
					if((quantityAdded[count]<100&&quantityAdded[count]>0))
					{
						
						minQuantityCheck[count]=[[[arrDropDownNext[count] objectAtIndex:selectedIndexNext[count]]objectForKey:@"iAvailableQuantity"]intValue]-quantityAdded[count];
						
						
					}
					NSLog(@"%d", minQuantityCheck[count]);
					
				}
				
				
				if (!([[dicNextProduct valueForKey:@"bUseOptions"] intValue]==0))
				{
					int max=0;
					if (dropDownCountNext>=0) 
					{
						
							max=minQuantityCheck[0];	
					}
					
					for(int i=1;i<=dropDownCountNext;i++)
					{
						if(max>minQuantityCheck[i])
							max=minQuantityCheck[i];
						
					}
					
					
					if(max==0)
					{
						
						isTobeAdded=NO;
						
					}
					
				}
                
            
                
				}
				
				if ([arrProductID containsObject:[NSString stringWithFormat:@"%@", [dicNextProduct objectForKey:@"id"]]] && isContained)
				{
					UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.alreadyadded.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
					[alert show];
					[alert release];
				}
				
				else if(isTobeAdded==NO)
				{
					
					UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.detail.cannot.added"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
					[alert show];
					[alert release];
					
				}	
				
				
				else
				{
					NSString *strProductOptions=@"";	
					
					// Convert product image into NSData, so it can be saved into the sqlite3 database
					if ([[dicNextProduct valueForKey:@"bUseOptions"] intValue]==0)
					{
						strProductOptions=@"0";
						[[SqlQuery shared] setTblShoppingCart:[[dicNextProduct objectForKey:@"id"] intValue] :1:strProductOptions];
						[GlobalPrefrences setCurrentItemsInCart:YES];
						
					}
					else
					{
						if ([optionsArrayNextProduct count]>0)
						{
							for(int count=0;count<=dropDownCountNext;count++)
							{
								if(count==dropDownCountNext)
								{
									strProductOptions=[strProductOptions   stringByAppendingFormat:@"%@",[[arrDropDownNext[count] objectAtIndex:selectedIndexNext[count]]objectForKey:@"id"]];	
								}
								else
								{
									strProductOptions=[strProductOptions stringByAppendingFormat:@"%@,",[[arrDropDownNext[count] objectAtIndex:selectedIndexNext[count]]objectForKey:@"id"]];	
								}
							}
							[[SqlQuery shared] setTblShoppingCart:[[dicNextProduct objectForKey:@"id"] intValue]:1:strProductOptions];
							
							[GlobalPrefrences setCurrentItemsInCart:YES];
							
							
							
						}		
						else 
						{
							UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.detail.cannot.added"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
							[alert show];
							[alert release];
						}
					}
					
					
					SystemSoundID soundID;
					NSURL *filePath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] resourcePath], @"/pickup_coin.wav"] isDirectory:NO];
					AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
					AudioServicesPlaySystemSound(soundID);
					
					
					viewForAnimationEffect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 500)];
					[viewForAnimationEffect setBackgroundColor:[UIColor clearColor]];
					[contentView addSubview:viewForAnimationEffect];
					
					UIImageView* rotatingImage = [[UIImageView alloc] initWithFrame:CGRectMake(510, 10, 400, 400)];
					if ([dicNextProduct count]>0) 
						[rotatingImage setImage:productImgNextProduct.image];
					else
						[rotatingImage setImage:[UIImage imageNamed:@"Icon.png"]];
					
					
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
					rotatingImage.frame = CGRectMake(900,0, 0, 0);
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
			arrProductSize = [[SqlQuery shared] getShoppingProductSizes:[[dicNextProduct objectForKey:@"id"]intValue]];
			NSArray *wishlistOptions=[optionIndex componentsSeparatedByString:@","];
			
			
			BOOL isContained =NO;
			BOOL isTobeAdded=YES;
			
			
			if ([[dicNextProduct valueForKey:@"bUseOptions"] intValue]==0)
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
				
				for(int i=0; i<[optionsArrayNextProduct count]; i++)
				{
					[arrProductOptionSize addObject:[[optionsArrayNextProduct objectAtIndex:i] valueForKey:@"id"]];
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
						if([[[arrAddedToShoppingCart objectAtIndex:count] valueForKey:@"id"]intValue]==[[dicNextProduct objectForKey:@"id"]intValue])
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
					
					
					minimumQuantity=[[[optionsArrayNextProduct objectAtIndex:optionSizeIndex[0]]objectForKey:@"iAvailableQuantity"]intValue];
				}
				for(int i=1;i<[wishlistOptions count];i++)
				{
					NSLog(@"%d",optionSizeIndex[i]);
					
					if(minimumQuantity>[[[optionsArrayNextProduct objectAtIndex:optionSizeIndex[i]]objectForKey:@"iAvailableQuantity"]intValue])		
						minimumQuantity=[[[optionsArrayNextProduct objectAtIndex:optionSizeIndex[i]]objectForKey:@"iAvailableQuantity"]intValue];	
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
				UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.alreadyadded.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
			
			else if(isTobeAdded==NO)
			{
				
				UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.selectopt.product.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.detail.cannot.added"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
				[alert show];
				[alert release];
				
			}	
			
			else
			{
				NSString *strProductOptions=@"";	
				
				// Convert product image into NSData, so it can be saved into the sqlite3 database
				if ([[dicNextProduct valueForKey:@"bUseOptions"] intValue]==0)
				{
					strProductOptions=@"0";
					[[SqlQuery shared] setTblShoppingCart:[[dicNextProduct objectForKey:@"id"] intValue] :1:strProductOptions];
					[GlobalPrefrences setCurrentItemsInCart:YES];
					
				}
				else
				{
					if ([optionsArrayNextProduct count]>0)
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
						[[SqlQuery shared] setTblShoppingCart:[[dicNextProduct objectForKey:@"id"] intValue]:1:strProductOptions];
						
						[GlobalPrefrences setCurrentItemsInCart:YES];
						
					}		
					else 
					{
						UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.product.detail.cannot.added"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
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
				
				viewForAnimationEffect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 500)];
				[viewForAnimationEffect setBackgroundColor:[UIColor clearColor]];
				[contentView addSubview:viewForAnimationEffect];
				
				UIImageView* rotatingImage = [[UIImageView alloc] initWithFrame:CGRectMake(510, 10, 400, 400)];
				if ([dicNextProduct count]>0) 
					[rotatingImage setImage:productImgNextProduct.image];
				else
					[rotatingImage setImage:[UIImage imageNamed:@"Icon.png"]];
				
				
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
				rotatingImage.frame = CGRectMake(900,0, 0, 0);
				[UIView setAnimationDelegate:self];
				
				[UIView setAnimationDidStopSelector:@selector(animationEnded:)];
				[UIView commitAnimations];
				
				[rotatingImage release];				
				
				
			}
			
		}
	
	
	
	
    }
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
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
	isShoppingCart_TableStyle=YES;
	ShoppingCartViewController *objShopping = [[ShoppingCartViewController alloc] init];
	[[self navigationController]pushViewController:objShopping animated:YES];
	[objShopping release];
	
}

-(void)animationEnded:(id)sender
{
	if(viewForAnimationEffect)
	{
		[viewForAnimationEffect removeFromSuperview];
		[viewForAnimationEffect release];
		viewForAnimationEffect = nil;
	}
	
}



#pragma mark TableView Delegate Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 30;
}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
	if(tableView==optionTableView)
	{
		if (![arrDropDownTable isKindOfClass:[NSNull class]])
		{
			return [arrDropDownTable count];
		}
		else {
			return 0;
		}
	}
	else
	{
		if (![arrDropDownTableNext isKindOfClass:[NSNull class]])
		{
			return [arrDropDownTableNext count];
		}
		else {
			return 0;
		}
	}
	
}


- (UITableViewCell*) tableView:(UITableView*) tableview cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
	NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableIdentifier%d",indexPath.row];
	UITableViewCell *cell= [tableview dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if(cell==nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:SimpleTableIdentifier]autorelease];
		cell.backgroundColor=[UIColor whiteColor];
		cell.textLabel.font=[UIFont systemFontOfSize:12];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		if(tableview==optionTableView)
		{
			cell.textLabel.text =[NSString stringWithFormat:@"%@", [[arrDropDownTable objectAtIndex:indexPath.row] objectForKey:@"sName"]];
		}
		else
		{
			cell.textLabel.text =[NSString stringWithFormat:@"%@", [[arrDropDownTableNext objectAtIndex:indexPath.row] objectForKey:@"sName"]]; 
		}
	}
	return  cell;
}

- (void) tableView:(UITableView*)tableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath

{	
	if(tableview==optionTableView)
	{
		pastIndex=-1;
		selectedIndex[index]=indexPath.row;
		[lblOption[index] setText:[NSString stringWithFormat:@"%@",[[arrDropDownTable objectAtIndex:indexPath.row] objectForKey:@"sName"]]];
		
		BOOL canShowAddToCart;
		canShowAddToCart = NO;
		float pPrice=0;
		
		for(int i=0;i<=dropDownCount;i++)
		{
			if(!([[lblOption[i].text lowercaseString]  isEqualToString:[[NSString stringWithFormat:@"Select: %@",[[arrDropDown[i] objectAtIndex:0] objectForKey:@"sTitle"]] lowercaseString]]))
			{
                
                  pPrice =pPrice+[[[arrDropDown[i] objectAtIndex:selectedIndex[i]]valueForKey:@"pPrice"]floatValue];
                
                strPriceCurrentProduct=[[TaxCalculation shared]caluatePriceOptionProduct: dicProduct pPrice:pPrice];
                
                
                [lblProductPrice setText:strPriceCurrentProduct];
			
				if([[[arrDropDown[i] objectAtIndex:selectedIndex[i]]valueForKey:@"iAvailableQuantity"]intValue]<=0)
				{
					[imgStockStatusCurrentProduct setImage:[UIImage imageNamed:@"sold_out_large.png"]];
					[lblStatusCurrentProduct setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"]];
					canShowAddToCart=NO;
					break;
				}	
				else 
				{
					[imgStockStatusCurrentProduct setImage:[UIImage imageNamed:@"instock_btn_large.png"]];
					[lblStatusCurrentProduct setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"]];
					canShowAddToCart=YES;
					
				}
			}
		}
		
		imgStockStatusCurrentProduct.hidden=NO;
		
		
		
		if (canShowAddToCart)
		{
			[btnAddCurrentProductToCart setHidden:NO];
		}
		else
		{
			[btnAddCurrentProductToCart setHidden:YES];
		}	 
		
		
		[self getOptionTable];
	}
	else		
	{
		pastIndexNext=-1;
		selectedIndexNext[indexNext]=indexPath.row;
		[lblOptionNext[indexNext] setText:[NSString stringWithFormat:@"%@",[[arrDropDownTableNext objectAtIndex:indexPath.row] objectForKey:@"sName"]]];
		
		BOOL canShowAddToCart;
		canShowAddToCart = NO;
		float pNxtOPrice=0;
		
		for(int i=0;i<=dropDownCountNext;i++)
		{
			if(!([[lblOptionNext[i].text lowercaseString]  isEqualToString:[[NSString stringWithFormat:@"Select: %@",[[arrDropDownNext[i] objectAtIndex:0] objectForKey:@"sTitle"]] lowercaseString]]))
			{
				
                pNxtOPrice =pNxtOPrice+[[[arrDropDownNext[i] objectAtIndex:selectedIndexNext[i]]valueForKey:@"pPrice"]floatValue];
                
                strPriceNxtProduct=[[TaxCalculation shared]caluatePriceOptionProduct: dicNextProduct pPrice:pNxtOPrice];
                
                
                [lblProductPriceSecond setText:strPriceNxtProduct];

	
				if([[[arrDropDownNext[i] objectAtIndex:selectedIndexNext[i]]valueForKey:@"iAvailableQuantity"]intValue]<=0)
				{
					[imgStockStatusNextProduct setImage:[UIImage imageNamed:@"sold_out_large.png"]];
					[lblStatusNextProduct setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.soldout"]];
					canShowAddToCart=NO;
					break;
				}	
				else 
				{
					[imgStockStatusNextProduct setImage:[UIImage imageNamed:@"instock_btn_large.png"]];
					[lblStatusNextProduct setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.wishlist.instock"]];
					canShowAddToCart=YES;
					
				}
			}
		}
		
		imgStockStatusNextProduct.hidden=NO;
		
		
		
		if (canShowAddToCart)
		{
			[btnAddNextProductToCart setHidden:NO];
		}
		else
		{
			[btnAddNextProductToCart setHidden:YES];
		}	 
		
		
		[self getOptionTableNextProduct];
		
	}
	
}


#pragma mark Ratings
-(void)markStarRating_onView:(UIView*)_viewName withTag:(int)_tag
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    
	if(_tag==100)
	{
		if(lblReadReviews)
		{
			[lblReadReviews removeFromSuperview];
			[lblReadReviews release];
			lblReadReviews = nil;
		}
		lblReadReviews=[[UILabel alloc]initWithFrame:CGRectMake(168, 628, 100, 25)];
		[lblReadReviews setBackgroundColor:[UIColor clearColor]];
		[lblReadReviews setTextColor:subHeadingColor];
		[lblReadReviews setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
		
		[_viewName addSubview:lblReadReviews];
		
		UIButton *btnReadReviews=[UIButton buttonWithType:UIButtonTypeCustom];
		[btnReadReviews setTag:1];
		[btnReadReviews setFrame:CGRectMake(168, 628, 100, 25)];
		[btnReadReviews setBackgroundColor:[UIColor clearColor]];
		[btnReadReviews addTarget:self action:@selector(btnReadReview_clicked:)forControlEvents:UIControlEventTouchUpInside];
		[_viewName addSubview:btnReadReviews];
		
		
	}
	
	if(lblReadReviewsSecond)
	{
		[lblReadReviewsSecond removeFromSuperview];
		[lblReadReviewsSecond release];
		lblReadReviewsSecond = nil;
	}
	lblReadReviewsSecond=[[UILabel alloc]initWithFrame:CGRectMake(168, 638, 100, 25)];
	[lblReadReviewsSecond setBackgroundColor:[UIColor clearColor]];
	[lblReadReviewsSecond setTextColor:subHeadingColor];
	[lblReadReviewsSecond setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
	
	[nextProductScrollView addSubview:lblReadReviewsSecond];
	
	UIButton *btnReadReviewsSecond=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnReadReviewsSecond setTag:2];
	[btnReadReviewsSecond setFrame:CGRectMake(168, 628, 100, 25)];
	[btnReadReviewsSecond setBackgroundColor:[UIColor clearColor]];
	[btnReadReviewsSecond addTarget:self action:@selector(btnReadReview_clicked:)forControlEvents:UIControlEventTouchUpInside];
	[nextProductScrollView addSubview:btnReadReviewsSecond];
	
	int xValue=23;
	float rating;
	int strTemp ;
	if(_tag==100)
		strTemp= [[dicProduct valueForKey:@"id"]intValue];
	else
		strTemp= [[dicNextProduct valueForKey:@"id"]intValue];
	
	NSDictionary *dictProducts = [ServerAPI fetchDetailsOfProductWithID:strTemp];
	
	NSArray *arr=	[dictProducts valueForKey:@"product"];
	if(![arr isKindOfClass:[NSDecimalNumber class]])
		if([[[dictProducts valueForKey:@"product"]valueForKey:@"fAverageRating"] isEqual:[NSNull null]])
			rating = 0.0;
		else
			rating = [[[dictProducts valueForKey:@"product"]valueForKey:@"fAverageRating"] floatValue];
	float tempRating;
	
	
	tempRating=floor(rating);
	tempRating=rating-tempRating;
	
	for(int i=0; i<5; i++)
	{
		if(_tag == 100)
		{
			imgRatingsTemp[i] = [[[UIImageView alloc] initWithFrame:CGRectMake( xValue, 630, 20, 20)] autorelease];
		}
		else
		{
			imgRatingsTemp[i] = [[[UIImageView alloc] initWithFrame:CGRectMake( xValue, 640, 20, 20)] autorelease];
		}
        imgRatingsTemp[i].clipsToBounds = TRUE;
		[imgRatingsTemp[i] setImage:[UIImage imageNamed:@"favorite_star-off-transparent.png"]];
		[imgRatingsTemp[i] setBackgroundColor:[UIColor clearColor]];
		[_viewName addSubview:imgRatingsTemp[i]];
		
		
		xValue += 26;
	}
	
	int iTemp =0;
	
	for(int i=0; i<abs(rating) ; i++)
	{
		
		viewRatingBG[i] = [[[UIView  alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
		[viewRatingBG[i] setBackgroundColor:[UIColor clearColor]];
		[imgRatingsTemp[i] addSubview:viewRatingBG[i]];
		
		imgRatings[i] = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
		[imgRatings[i] setImage:[UIImage imageNamed:@"favorite_star-on-transparent.png"]];
		[imgRatingsTemp[i] addSubview:imgRatings[i]];
		iTemp = i;
	}
	
	if (tempRating>0)
	{
		int iLastStarValue = 0;
		if(rating >=1.0)
		{
			iLastStarValue = iTemp + 1;
		}
		
		viewRatingBG[iLastStarValue] = [[[UIView  alloc] initWithFrame:CGRectMake(0, 0, tempRating * 20, 20)] autorelease];
		viewRatingBG[iLastStarValue].clipsToBounds = TRUE;
		[imgRatingsTemp[iLastStarValue] addSubview:viewRatingBG[iLastStarValue]];
		
		
		
		imgRatings[iLastStarValue] = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
		[imgRatings[iLastStarValue] setImage:[UIImage imageNamed:@"favorite_star-on-transparent.png"]];
		[viewRatingBG[iLastStarValue] addSubview:imgRatings[iLastStarValue]];
	}
	
	
	if(![arr isKindOfClass:[NSDecimalNumber class]])
	{
		if(_tag==100)
		{
			if([[[dictProducts valueForKey:@"product"]valueForKey:@"productReviews"]count]>1)
			{
				[lblReadReviews setText:[NSString stringWithFormat:@"%d %@",[[[dictProducts valueForKey:@"product"]valueForKey:@"productReviews"]count],[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.mainproduct.reviews"]]];	
			}
			else
			{
				[lblReadReviews setText:[NSString stringWithFormat:@"%d %@",[[[dictProducts valueForKey:@"product"]valueForKey:@"productReviews"]count],[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.mainproduct.reviews"]]];		}
		}
		else if(_tag==200){
			if([[[dictProducts valueForKey:@"product"]valueForKey:@"productReviews"]count]>1)
			{
				[lblReadReviewsSecond setText:[NSString stringWithFormat:@"%d %@",[[[dictProducts valueForKey:@"product"]valueForKey:@"productReviews"]count],[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.mainproduct.reviews"]]];	
			}
			else
			{
				[lblReadReviewsSecond setText:[NSString stringWithFormat:@"%d %@",[[[dictProducts valueForKey:@"product"]valueForKey:@"productReviews"]count],[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.mainproduct.reviews"]]];	}
		}
	}
	
	
    [pool release];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{	
	[searchBar resignFirstResponder];
	[NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
	
	GlobalSearch *_globalSearch = [[GlobalSearch alloc] initWithProductName:searchBar.text];
	[self.navigationController pushViewController:_globalSearch animated:YES];
	[_globalSearch release];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// only show the status bar‚Äôs cancel button while in edit mode
	searchBar.showsCancelButton = YES;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	searchBar.showsCancelButton = NO;
}


// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
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
	[currentDescriptionScrollView release];
	[nextDescriptionScrollView release];
	[_searchBar release];
    [super dealloc];
}


@end
