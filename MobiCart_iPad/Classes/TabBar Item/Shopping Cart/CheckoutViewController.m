//
//  CheckoutViewController.m
//  MobiCart
//
//  Created by Mobicart on 8/31/10.
//  Copyright 2010 Mobicart. All rights reserved.
//`

#import "CheckoutViewController.h"
#import "Constants.h"
MobicartAppDelegate *_objMobicartAppDelegate;

extern BOOL isLoadingTableFooter;

@implementation CheckoutViewController

@synthesize grandTotalValue,fSubTotalAmount,fTaxAmount,arrProductIds, fShippingCharges,sCountry,fSubTotal,arrCartItems,btnPayPal2;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 
 
 */
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	
	isLoadingTableFooter = TRUE;
	NSMutableArray *arrInfoAccount=[[NSMutableArray alloc]init];
	arrInfoAccount=[[SqlQuery shared] getAccountData:[GlobalPrefrences getUserDefault_Preferences:@"userEmail"]];
	
	
	contentView = [[UIView alloc]initWithFrame:CGRectMake(0,0,450,520)];
	contentView.backgroundColor = [UIColor clearColor];
	contentView.tag = 101010;
	self.view = contentView;
	
	UIImageView *imgViewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 2, 25, 25)];
	[imgViewIcon setImage:[UIImage imageNamed:@"page_1.png"]];
	[imgViewIcon setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:imgViewIcon];
	
	
	UILabel *lbltotprice = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 30)];
	[lbltotprice setBackgroundColor:[UIColor clearColor]];
	[lbltotprice setText:@"Total to be charged is: "];
	lbltotprice.textColor =headingColor;
	[lbltotprice setFont:[UIFont boldSystemFontOfSize:23]];
	[contentView addSubview:lbltotprice];
	
	UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(-5, 50, 416,2)];
	[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
	
	[contentView addSubview:imgHorizontalDottedLine];
	[imgHorizontalDottedLine release];
	
	contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 50, 450, 560)];
	[contentScrollView setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:contentScrollView];
	
	
	
	
	NSDictionary *dicSettings = [[NSDictionary alloc]init];
	dicSettings = [GlobalPrefrences getSettingsOfUserAndOtherDetails];
	[dicSettings retain];
	
	NSMutableArray *interShippingDict = [[NSMutableArray alloc]init];
	NSDictionary *contentDict = [dicSettings objectForKey:@"store"];
	NSArray *arrShipping = [contentDict objectForKey:@"shippingList"];
	[interShippingDict retain];
	
	NSDictionary *taxDict = [dicSettings objectForKey:@"store"];
	NSArray *arrTax = [contentDict objectForKey:@"taxList"];
    [taxDict retain];
	
	for (int index=0;index<[arrShipping count]; index++)
	{
		[interShippingDict addObject:[arrShipping objectAtIndex:index]];
	}
	
	for (int index=0;index<[arrTax count]; index++)
	{
		[interShippingDict addObject:[arrTax objectAtIndex:index]];
	}
	int countryID=0, stateID=0;
	if([arrInfoAccount count]>0)
	{
		for(int i=0; i<[interShippingDict count]; i++)
		{
			if([[arrInfoAccount objectAtIndex:10] isEqualToString:[[interShippingDict objectAtIndex:i] valueForKey:@"sCountry"]])
			{
				countryID = [[[interShippingDict objectAtIndex:i] valueForKey:@"territoryId"] intValue];
				
				if([[arrInfoAccount objectAtIndex:8] isEqualToString:[[interShippingDict objectAtIndex:i] valueForKey:@"sState"]])
				{
					stateID = [[[interShippingDict objectAtIndex:i] valueForKey:@"stateId"] intValue];
				}
				
			}
		}
	}
	
	
	if(stateID==0)
	{
		NSDictionary *dicStates;
		//fetch data from server
		dicStates = [ServerAPI fetchStatesOfAcountryURL:countryID];
		
		for (int index=0;	index<[dicStates count]; index++)
		{
			if([[[dicStates valueForKey:@"sName"] objectAtIndex:index]isEqualToString:@"Other"])
				stateID=[[[dicStates valueForKey:@"id"]objectAtIndex:index]intValue];
		}
	}
	
	[dicSettings release];
	[interShippingDict release];
	NSDictionary *dictTax =[ServerAPI fetchTaxShippingDetails:countryID :stateID:iCurrentStoreId];
	[dictTax retain];
	
	fShippingCharges=[[TaxCalculation shared]calculateShippingForCheckoutScreen:arrProductIds taxDetails:dictTax];
	
	fShippingCharges=[GlobalPrefrences getRoundedOffValue:fShippingCharges];
	float taxPercent = [[[dictTax valueForKey:@"tax"] valueForKey:@"fTax"] floatValue];
	taxPercent=[GlobalPrefrences getRoundedOffValue:taxPercent];
	float _fSubTotal=0;
	float shippingtax=0.0;
	
	
	
	if([[[dictTax valueForKey:@"tax"] valueForKey:@"fTax"] isKindOfClass:[NSNull class]])
		shippingtax=0.0;
	else
	    shippingtax=[[[dictTax valueForKey:@"tax"] valueForKey:@"fTax"] floatValue];
	
	
	shippingtax=[GlobalPrefrences getRoundedOffValue:shippingtax];
	
	int yValue=50;
	
	NSMutableArray *arrTaxable = [[NSMutableArray alloc] init];
	
	for(int i=0; i<=[arrProductIds count]; i++)
	{
		if(i==0)
		{
			UILabel *lblProductNames = [[UILabel alloc] init];
			lblProductNames.frame = CGRectMake( 10, yValue, 150, 30);
			[lblProductNames setBackgroundColor:[UIColor clearColor]];
			lblProductNames.textColor =subHeadingColor;
			
			lblProductNames.font=[UIFont boldSystemFontOfSize:12];
			lblProductNames.textAlignment = UITextAlignmentLeft;
			lblProductNames.lineBreakMode = UILineBreakModeTailTruncation;
			lblProductNames.text = [NSString stringWithFormat:@"%@",[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.checkout.name"]];
			[contentScrollView addSubview:lblProductNames];
			[lblProductNames release];
			
			UILabel *lblProductQuantity = [[UILabel alloc] init];
			lblProductQuantity.frame = CGRectMake( 165, yValue, 40, 30);
			[lblProductQuantity setBackgroundColor:[UIColor clearColor]];
			lblProductQuantity.textColor = subHeadingColor;
			
			lblProductQuantity.font=[UIFont boldSystemFontOfSize:12];
			lblProductQuantity.textColor=subHeadingColor;
			lblProductQuantity.textAlignment = UITextAlignmentLeft;
			lblProductQuantity.lineBreakMode = UILineBreakModeTailTruncation;
			lblProductQuantity.text = [NSString stringWithFormat:@"%@",[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.checkout.qty"]];
			[contentScrollView addSubview:lblProductQuantity];
			[lblProductQuantity release];
			
			UILabel *lblProductSize = [[UILabel alloc] init];
			lblProductSize.frame = CGRectMake( 220, yValue, 80, 30);
			[lblProductSize setBackgroundColor:[UIColor clearColor]];
			lblProductSize.textColor = subHeadingColor;
			
			lblProductSize.font=[UIFont boldSystemFontOfSize:12];
			lblProductSize.textColor= subHeadingColor;
			lblProductSize.textAlignment = UITextAlignmentLeft;
			lblProductSize.lineBreakMode = UILineBreakModeTailTruncation;
			lblProductSize.text = [NSString stringWithFormat:@"%@",[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.checkout.options"]];
			[contentScrollView addSubview:lblProductSize];
			[lblProductSize release];
			
			UILabel *lblProductSubTotal = [[UILabel alloc] init];
			lblProductSubTotal.frame = CGRectMake( 300, yValue, 80, 30);
			[lblProductSubTotal setBackgroundColor:[UIColor clearColor]];
			lblProductSubTotal.textColor = subHeadingColor;
			
			lblProductSubTotal.font=[UIFont boldSystemFontOfSize:12];
			lblProductSubTotal.textColor=subHeadingColor;
	        lblProductSubTotal.textAlignment = UITextAlignmentRight;
			lblProductSubTotal.lineBreakMode = UILineBreakModeTailTruncation;
			lblProductSubTotal.text = [NSString stringWithFormat:@"%@",[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.checkout.sub-total"]];
			[contentScrollView addSubview:lblProductSubTotal];
			[lblProductSubTotal release];
			
			
			UILabel *lblProductTax = [[UILabel alloc] init];
			lblProductTax.frame = CGRectMake( 295, yValue, 53, 30);
			[lblProductTax setBackgroundColor:[UIColor clearColor]];
			lblProductTax.textColor = subHeadingColor;
			
			lblProductTax.font=[UIFont boldSystemFontOfSize:12];
			lblProductTax.textAlignment = UITextAlignmentCenter;
			lblProductTax.lineBreakMode = UILineBreakModeTailTruncation;
			lblProductTax.text = [NSString stringWithFormat:@"Tax"];
			[lblProductTax release];
			
			UILabel *lblProductTotal = [[UILabel alloc] init];
			lblProductTotal.frame = CGRectMake( 325, yValue, 70, 30);
			[lblProductTotal setBackgroundColor:[UIColor clearColor]];
			lblProductTotal.textColor = subHeadingColor;
			
			lblProductTotal.font=[UIFont boldSystemFontOfSize:13];
			lblProductTotal.textAlignment = UITextAlignmentRight;
			lblProductTotal.lineBreakMode = UILineBreakModeTailTruncation;
			lblProductTotal.text = [NSString stringWithFormat:@"%@",[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.checkout.totalcost"]];
			[lblProductTotal release];
		}
		else
		{
			
			UILabel *lblProductNames = [[UILabel alloc] init];
			lblProductNames.frame = CGRectMake( 10, yValue, 150, 30);
			[lblProductNames setBackgroundColor:[UIColor clearColor]];
			lblProductNames.textColor = subHeadingColor;
			lblProductNames.font = [UIFont boldSystemFontOfSize:12];
			lblProductNames.textAlignment = UITextAlignmentLeft;
			lblProductNames.lineBreakMode = UILineBreakModeTailTruncation;
			lblProductNames.text = [NSString stringWithFormat:@"%@", [[arrProductIds objectAtIndex:i-1] valueForKey:@"sName"]];
			[contentScrollView addSubview:lblProductNames];
			[lblProductNames release];
			
			UILabel *lblProductQuantity = [[UILabel alloc] init];
			lblProductQuantity.frame = CGRectMake( 170, yValue, 30, 30);
            [lblProductQuantity setBackgroundColor:[UIColor clearColor]];
			lblProductQuantity.textColor = subHeadingColor;
			lblProductQuantity.font = [UIFont boldSystemFontOfSize:12];
			lblProductQuantity.textAlignment = UITextAlignmentLeft;
			lblProductQuantity.lineBreakMode = UILineBreakModeTailTruncation;
			lblProductQuantity.text = [NSString stringWithFormat:@"%@", [[arrProductIds objectAtIndex:i-1] valueForKey:@"quantity"]];
			[contentScrollView addSubview:lblProductQuantity];
			[lblProductQuantity release];
			
			int optionSizeIndex=555545;
			NSString *sizeName;
			
			if([[[arrProductIds objectAtIndex:i-1] valueForKey:@"pOptionId"] intValue]==0)
			{
				sizeName = @"";
			}
			else
			{
				NSMutableArray *dictOption = [[arrProductIds objectAtIndex:i-1] objectForKey:@"productOptions"];
				
				NSMutableArray *arrProductOptionSize = [[[NSMutableArray alloc] init] autorelease];
				
				for(int i=0; i<[dictOption count]; i++)
					[arrProductOptionSize addObject:[[dictOption objectAtIndex:i] valueForKey:@"id"]];
				
				if([arrProductOptionSize containsObject: [NSNumber numberWithInt:[[[arrProductIds objectAtIndex:i-1] valueForKey:@"pOptionId"] integerValue]]])
					optionSizeIndex = [arrProductOptionSize indexOfObject:[NSNumber numberWithInt:[[[arrProductIds objectAtIndex:i-1] valueForKey:@"pOptionId"] intValue]]];
				
				if(optionSizeIndex<15455 && optionSizeIndex>=0)
					sizeName = [[dictOption objectAtIndex:optionSizeIndex] valueForKey:@"sName"];
				else
					sizeName = @"";
			}
			
			UILabel *lblProductSize = [[UILabel alloc] init];
			lblProductSize.frame = CGRectMake( 222,yValue, 70, 30);
			[lblProductSize setBackgroundColor:[UIColor clearColor]];
			lblProductSize.textColor = subHeadingColor;
			lblProductSize.font = [UIFont boldSystemFontOfSize:12];
			lblProductSize.textAlignment = UITextAlignmentLeft;
			lblProductSize.lineBreakMode = UILineBreakModeTailTruncation;
			lblProductSize.text = [NSString stringWithFormat:@"%@", sizeName];
			[contentScrollView addSubview:lblProductSize];
			[lblProductSize release];
			
			float productCost=0, productTax=0;
			
			
			
			NSArray *arrTempTaxDetails=[[TaxCalculation shared]calculatetaxForCheckOutScreen:arrProductIds withSettings:dicSettings forIndex:i forCountryID:countryID taxAmount:taxPercent];
			
			
			productCost=[[arrTempTaxDetails objectAtIndex:0] floatValue];
			
			productCost=[GlobalPrefrences getRoundedOffValue:productCost];
			priceWithoutTax+=[[arrTempTaxDetails objectAtIndex:1] floatValue];
			
			
			float productTotal=[[arrTempTaxDetails objectAtIndex:2] floatValue];
			productTotal=[GlobalPrefrences getRoundedOffValue:productTotal];
			
			_fSubTotal+=productTotal;
			_fSubTotal=[GlobalPrefrences getRoundedOffValue:_fSubTotal];
			fTaxAmount=[GlobalPrefrences getRoundedOffValue:fTaxAmount];
			if([[[dicSettings valueForKey:@"store"]valueForKey:@"bIncludeTax"]intValue]==1)
			{				
				if(countryID==0)
				{
					istaxToBeApplied=NO;
					productTax = 0;
					fTaxAmount = 0;
					productTotal = productTotal;
					fShippingCharges=0;
				}
				else
				{
					istaxToBeApplied=YES;
					productTax=[[arrTempTaxDetails objectAtIndex:4] floatValue];
					fTaxAmount += productTax;
					productTotal = productTotal; 
				}
			}
			else {
				istaxToBeApplied=NO;
			}
					
			grandTotalValue += productTotal;			
			UILabel *lblProductSubTotal = [[UILabel alloc] init];
			lblProductSubTotal.frame = CGRectMake( 300, yValue, 80, 30);
			[lblProductSubTotal setBackgroundColor:[UIColor clearColor]];
			lblProductSubTotal.textColor =subHeadingColor;
			lblProductSubTotal.font=[UIFont boldSystemFontOfSize:12];
			lblProductSubTotal.textAlignment = UITextAlignmentRight;
			lblProductSubTotal.lineBreakMode = UILineBreakModeTailTruncation;
	        lblProductSubTotal.text = [NSString stringWithFormat:@"%@%0.2f",_savedPreferences.strCurrencySymbol,productCost];
			[contentScrollView addSubview:lblProductSubTotal];
			[lblProductSubTotal release];
			
			
			UILabel *lblProductTax = [[UILabel alloc] init];
			lblProductTax.frame = CGRectMake( 285, yValue, 53, 30);
			[lblProductTax setBackgroundColor:[UIColor clearColor]];
			lblProductTax.textColor = subHeadingColor;
			lblProductTax.font=[UIFont boldSystemFontOfSize:12];
			lblProductTax.textAlignment = UITextAlignmentCenter;
			lblProductTax.lineBreakMode = UILineBreakModeTailTruncation;
			lblProductTax.text = [NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, productTax];
			[lblProductTax release];
			
			
			UILabel *lblProductTotal = [[UILabel alloc] init];
			lblProductTotal.frame = CGRectMake( 325, yValue, 68, 40);
			[lblProductTotal setBackgroundColor:[UIColor clearColor]];
			lblProductTotal.textColor = subHeadingColor;
			lblProductTotal.font = [UIFont boldSystemFontOfSize:12];
			lblProductTotal.textAlignment = UITextAlignmentRight;
			lblProductTotal.numberOfLines=2;
			lblProductTotal.lineBreakMode = UILineBreakModeTailTruncation;
			
			NSString *strTemptaxType=[[dictTax valueForKey:@"tax"] valueForKey:@"sType"];
			
			if([strTemptaxType isEqualToString:@"default"])
				strTemptaxType=@"tax";
			
			
			if(istaxToBeApplied==YES)
				lblProductTotal.text = [NSString stringWithFormat:@"%@%0.2f\n(Inc. %@)", _savedPreferences.strCurrencySymbol, productTotal,strTemptaxType];
			else
				lblProductTotal.text = [NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, productTotal];
			
			[lblProductTotal release];
		}
		yValue+=40;
	}
	
	fShippingCharges = [[NSString stringWithFormat:@"%0.2f", fShippingCharges] floatValue];
	
	grandTotalValue+=fShippingCharges;
	[arrTaxable release];
	
	UIImageView *imgLineView1=[[UIImageView alloc]initWithFrame:CGRectMake(8,yValue,374,2)];
	[imgLineView1 setImage:[UIImage imageNamed:@"horizontal-line.png"]];
	[contentScrollView addSubview:imgLineView1];
	[imgLineView1 release];
	
    
	
	UILabel *lblSubTotalCharges = [[UILabel alloc] init];
	lblSubTotalCharges.frame = CGRectMake( 210, yValue+10, 170, 20);
	[lblSubTotalCharges setBackgroundColor:[UIColor clearColor]];
	lblSubTotalCharges.textColor = subHeadingColor;
	lblSubTotalCharges.font=[UIFont boldSystemFontOfSize:14];
	lblSubTotalCharges.textAlignment = UITextAlignmentRight;
	lblSubTotalCharges.text = [NSString stringWithFormat:@"%@:	%@%0.2f",[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.checkout.sub-total"], _savedPreferences.strCurrencySymbol, priceWithoutTax];
	[contentScrollView addSubview:lblSubTotalCharges];
	[lblSubTotalCharges release];
	
	
	
	
	UILabel *lblTaxAmount = [[UILabel alloc] init];
	lblTaxAmount.frame = CGRectMake( 220,lblSubTotalCharges.frame.origin.y+lblSubTotalCharges.frame.size.height, 160, 20);
	[lblTaxAmount setBackgroundColor:[UIColor clearColor]];
	lblTaxAmount.textColor = subHeadingColor;
	lblTaxAmount.font=[UIFont boldSystemFontOfSize:14];
	lblTaxAmount.textAlignment = UITextAlignmentRight;
	lblTaxAmount.text = [NSString stringWithFormat:@"%@:	%@%0.2f",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.shoppingcart.tax"], _savedPreferences.strCurrencySymbol, fTaxAmount];
	[contentScrollView addSubview:lblTaxAmount];
	[lblTaxAmount release];
	
	UILabel *lblShippingCharges = [[UILabel alloc] init];
	lblShippingCharges.frame = CGRectMake( 180, lblTaxAmount.frame.origin.y+lblTaxAmount.frame.size.height, 200, 20);
	[lblShippingCharges setBackgroundColor:[UIColor clearColor]];
	lblShippingCharges.textColor =subHeadingColor;
	lblShippingCharges.font=[UIFont boldSystemFontOfSize:14];
	lblShippingCharges.textAlignment = UITextAlignmentRight;
	lblShippingCharges.text = [NSString stringWithFormat:@" %@:	%@%0.2f",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.shoppingcart.shipping"], _savedPreferences.strCurrencySymbol, fShippingCharges ];
	[contentScrollView addSubview:lblShippingCharges];
	[lblShippingCharges release];
	
	fSubTotalAmount = grandTotalValue;
	
	UILabel *lblShippingTax= [[UILabel alloc] init];
	lblShippingTax.frame = CGRectMake( 178, lblShippingCharges.frame.origin.y+lblTaxAmount.frame.size.height, 200, 20);
	[lblShippingTax setBackgroundColor:[UIColor clearColor]];
	lblShippingTax.textColor =subHeadingColor;
	lblShippingTax.font=[UIFont boldSystemFontOfSize:14];
	lblShippingTax.textAlignment = UITextAlignmentRight;
	[contentScrollView addSubview:lblShippingTax];
	
	if([[[dicSettings valueForKey:@"store"] valueForKey:@"bTaxShipping"]intValue]==1)
		lblShippingTax.text= [NSString stringWithFormat:@"%@: %@%0.2f",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.shoppingcart.tax.shipping"],_savedPreferences.strCurrencySymbol,(fShippingCharges*shippingtax)/100];
	else
		lblShippingTax.text= [NSString stringWithFormat:@"%@: %@0.00",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.shoppingcart.tax.shipping"],_savedPreferences.strCurrencySymbol];
	[lblShippingTax release];
	
	
	if([[[dicSettings valueForKey:@"store"] valueForKey:@"bTaxShipping"]intValue]==1)
		taxOnShipping=((fShippingCharges *shippingtax)/100);
	else
	{
		taxOnShipping=0;	
		shippingtax=0;
	}
	
	taxOnShipping=[GlobalPrefrences getRoundedOffValue:taxOnShipping];
	shippingtax = [[NSString stringWithFormat:@"%0.2f",shippingtax] floatValue];
	taxOnShipping = [[NSString stringWithFormat:@"%0.2f", taxOnShipping] floatValue];
	
	
	grandTotalValue=grandTotalValue+((fShippingCharges *shippingtax)/100);
	
	
	UILabel *lblStars=[[UILabel alloc]initWithFrame:CGRectMake(210, lblShippingTax.frame.origin.y+lblShippingTax.frame.size.height, 210, 20)];
	[lblStars setBackgroundColor:[UIColor clearColor]];
	[lblStars setText:@"****************************"];
	[lblStars setTextColor:subHeadingColor];
	[contentScrollView
	 addSubview:lblStars];
	[lblStars release];
	
	
	
	
	UILabel *lblGrandTotal = [[UILabel alloc] init];
	lblGrandTotal.frame = CGRectMake( 190, lblStars.frame.origin.y+lblStars.frame.size.height-7, 190, 20);
	[lblGrandTotal setBackgroundColor:[UIColor clearColor]];
	lblGrandTotal.textColor = subHeadingColor;
	lblGrandTotal.font=[UIFont boldSystemFontOfSize:18];
	lblGrandTotal.textAlignment = UITextAlignmentRight;
	lblGrandTotal.text = [NSString stringWithFormat:@"%@: %@%0.2f",[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.checkout.total"], _savedPreferences.strCurrencySymbol, grandTotalValue];
	[contentScrollView addSubview:lblGrandTotal];
	
	[self performSelectorInBackground:@selector(fetchDataFromLocalDB) withObject:nil];
	
	
	UILabel *lblprice = [[UILabel alloc] initWithFrame:CGRectMake(275, 0, 150, 30)];
	[lblprice setBackgroundColor:[UIColor clearColor]];
	[lblprice setText:[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, grandTotalValue]];
	lblprice.textColor =subHeadingColor;
	[lblprice setFont:[UIFont boldSystemFontOfSize:21]];
	[contentView addSubview:lblprice];
	
	
	
	UILabel*lblCountryTitle=[[UILabel alloc] initWithFrame:CGRectMake(12, yValue +10,100,20)];
	[lblCountryTitle setText:[NSString stringWithFormat:@"%@:",[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.checkout.country"]]];
	[lblCountryTitle setBackgroundColor:[UIColor clearColor]];
	lblCountryTitle.textColor=headingColor;
	lblCountryTitle.font =[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
	[contentScrollView addSubview:lblCountryTitle];
	[lblCountryTitle release];
	
	
	UILabel*lblCountryFooter=[[UILabel alloc] initWithFrame:CGRectMake(12, yValue +30,100, 20)];
	[lblCountryFooter setText:[arrInfoAccount objectAtIndex:10]];
	[lblCountryFooter setBackgroundColor:[UIColor clearColor]];
	lblCountryFooter.textColor=subHeadingColor;
	lblCountryFooter.font =[UIFont fontWithName:@"Helvetica-Bold" size:13.0];
	[contentScrollView addSubview:lblCountryFooter];
	[lblCountryFooter release];
	
	UILabel*lblStateTitle=[[UILabel alloc] initWithFrame:CGRectMake(12, yValue +60,100,20)];
	[lblStateTitle setText:[NSString stringWithFormat:@"%@:",[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.signup.state"]]];
	[lblStateTitle setBackgroundColor:[UIColor clearColor]];
	lblStateTitle.textColor=headingColor;
	lblStateTitle.font =[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
	[contentScrollView addSubview:lblStateTitle];
	[lblStateTitle release];
	
	
	UILabel*lblStateFooter=[[UILabel alloc] initWithFrame:CGRectMake(12, yValue +80,100, 20)];
	[lblStateFooter setText:[arrInfoAccount objectAtIndex:8]];
	[lblStateFooter setBackgroundColor:[UIColor clearColor]];
	lblStateFooter.textColor=subHeadingColor;
	lblStateFooter.font =[UIFont fontWithName:@"Helvetica-Bold" size:13.0];
	[contentScrollView addSubview:lblStateFooter];
	[lblStateFooter release];
	
/*********************************integration with Zooz payment gatway****************************************/
	if(([[GlobalPrefrences getPaypalLiveToken] isEqual:[NSNull null]]) || ([GlobalPrefrences getPaypalLiveToken]==nil) || ([[GlobalPrefrences getPaypalLiveToken] length]==0))
    {
        
    }else {
        
    		
	btnPayPal2=[UIButton buttonWithType:UIButtonTypeCustom];
    
   [btnPayPal2 addTarget:self action:@selector(payWithZooz) forControlEvents:UIControlEventTouchUpInside];
    
    [btnPayPal2 setTitle:[NSString stringWithFormat:@"%@",[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.PayWithPaypal"]] forState:UIControlStateNormal];
    [btnPayPal2 setBackgroundImage:[UIImage imageNamed:@"checkout_btn.png"] forState:UIControlStateNormal];
    [btnPayPal2 layer].cornerRadius=5.0;
	[btnPayPal2.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
    btnPayPal2.frame=CGRectMake (70, lblGrandTotal.frame.origin.y+lblGrandTotal.frame.size.height+30, 278, 38);
    
    [contentScrollView addSubview:btnPayPal2];
    
    }
    if(![[[dicSettings valueForKey:@"store"] valueForKey:@"codEnabled"]isEqual:[NSNull null]])
    {
        if([[[dicSettings valueForKey:@"store"] valueForKey:@"codEnabled"]intValue]==1)
        {
            
            UIButton *cashOnDBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [cashOnDBtn addTarget:self action:@selector(cashOnDeveliery) forControlEvents:UIControlEventTouchUpInside];
            cashOnDBtn.userInteractionEnabled=YES;
            [cashOnDBtn setTitle:[NSString stringWithFormat:@"%@",[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.CashOnDelivery"]] forState:UIControlStateNormal];
            [cashOnDBtn setBackgroundImage:[UIImage imageNamed:@"checkout_btn.png"] forState:UIControlStateNormal];
            [cashOnDBtn layer].cornerRadius=5.0;
            [cashOnDBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
            
            
            if([[GlobalPrefrences getPaypalLiveToken] length]==0)
              {
                  cashOnDBtn.frame=CGRectMake (70, lblGrandTotal.frame.origin.y+lblGrandTotal.frame.size.height+30, 278, 38);

            }else
              {
            cashOnDBtn.frame=CGRectMake(70, btnPayPal2.frame.origin.y+btnPayPal2.frame.size.height+20, 278, 38);
            
            }
            [contentScrollView addSubview:cashOnDBtn]; 
            [contentScrollView setContentSize:CGSizeMake( 450, cashOnDBtn.frame.origin.y+cashOnDBtn.frame.size.height+50)];
        }
    }else{
        [contentScrollView setContentSize:CGSizeMake( 450, btnPayPal2.frame.origin.y+btnPayPal2.frame.size.height+50)];
    }

	
		if(!sMerchantPaypayEmail)
		sMerchantPaypayEmail = [[NSString alloc] init];
}



-(void)viewWillAppear:(BOOL)animated
{
	
	[super viewWillAppear:animated];
	
	for (UIView *view in [self.navigationController.navigationBar subviews]) 
	{
		if ([view isKindOfClass:[UIButton class]])
			view.hidden =TRUE;
		if ([view isKindOfClass:[UILabel class]])
			view.hidden =TRUE;
	}
	
	
}

-(void)viewWillDisappear:(BOOL)animated
{
	for (UIView *view in [self.navigationController.navigationBar subviews]) {
		
		if ([view isKindOfClass:[UIButton class]])
			view.hidden =FALSE;
		
		
		if ([view isKindOfClass:[UILabel class]])
			view.hidden =FALSE;
	}
}


#pragma mark Zooz Payment Integration
-(void)payWithZooz
{
    
    NSLog(@"%@", [[NSBundle mainBundle] bundleIdentifier]);
    NSString *strCode =[_savedPreferences.strCurrency substringFromIndex:3];
    
    NSString *invRef;
    invRef=[NSString stringWithFormat:@"INV-%@", [NSDate new ]] ;
    
	totalShippingAmount=0.0;
	
	float shipping = fShippingCharges + taxOnShipping;
	totalShippingAmount=shipping;
    
    float totalAmount=priceWithoutTax+totalShippingAmount+[GlobalPrefrences getRoundedOffValue:fTaxAmount];
    
	ZooZ * zooz = [ZooZ sharedInstance];
    zooz.rootView=_objMobicartAppDelegate.tabController.view;
    zooz.tintColor=backGroundColor;
	ZooZPaymentRequest * req = [zooz createPaymentRequestWithTotal:totalAmount invoiceRefNumber:invRef delegate:self];
	req.currencyCode = strCode;
    
    /* Optional - recommended */
    req.payerDetails.firstName = [[arrUserDetails objectAtIndex:0] objectForKey:@"sUserName"];
    req.payerDetails.lastName = @"";
    req.payerDetails.email = [[arrUserDetails objectAtIndex:0] objectForKey:@"sEmailAddress"];
    req.payerDetails.address.zip=[[arrUserDetails objectAtIndex:0] objectForKey:@"sPincode"];
    
    req.payerDetails.address.country=[[arrUserDetails objectAtIndex:0] objectForKey:@"sDeliveryCountry"];
    req.payerDetails.address.state=[[arrUserDetails objectAtIndex:0] objectForKey:@"sDeliveryState"];
   
    req.payerDetails.address.city=[[arrUserDetails objectAtIndex:0] objectForKey:@"sDeliveryCity"];
     req.payerDetails.address.streetAddress=[[arrUserDetails objectAtIndex:0] objectForKey:@"sStreetAddress"];
    
    
    for (int i =0; i<[arrProductIds count];i++)
    {
        float price;
        NSString *nameOption;
        NSMutableArray * productNameOpt;
        productNameOpt=  [self fetchNameOptionProduct:i];
        nameOption= [productNameOpt objectAtIndex:0];
        
        if ([[[arrProductIds objectAtIndex:i] objectForKey:@"fPrice"] floatValue]>[[[arrProductIds objectAtIndex:i] objectForKey:@"fDiscountedPrice"] floatValue])
        {
            price=[[[arrProductIds objectAtIndex:i] objectForKey:@"fDiscountedPrice"] floatValue];
            price+=[[productNameOpt objectAtIndex:1] floatValue];
        }
        else 
        {
            price=[[[arrProductIds objectAtIndex:i] objectForKey:@"fPrice"] floatValue];
            price+=[[productNameOpt objectAtIndex:1] floatValue];
        }
        
        ZooZInvoiceItem * item = [[[ZooZInvoiceItem alloc] initWithPrice:price quantity:[[[arrProductIds objectAtIndex:i] objectForKey:@"quantity"] intValue] name:[NSString stringWithFormat:@"%@", nameOption ] ] autorelease];//Don't forget to release/autorelease
        item.itemId =[NSString stringWithFormat:@"%d", [[[arrProductIds objectAtIndex:i] objectForKey:@"id"] intValue]];
        
        [req addItem:item];
        
        
         
    }
    
    
    
    NSLog(@"ZooZ token:- %@",[GlobalPrefrences getPaypalLiveToken]);
    NSLog(@"ZooZ Payment Mode:- %@",[GlobalPrefrences  getPaypal_TOKEN_CHECK]);
    
    /* End of optional */
    
    if(([[GlobalPrefrences getPaypalLiveToken] isEqual:[NSNull null]]) || ([GlobalPrefrences getPaypalLiveToken]==nil) || ([[GlobalPrefrences getPaypalLiveToken] length]==0))
    {
		
        zooz.sandbox = YES;
        [zooz openPayment:req forAppKey:@""];
        
    }
    else
    {
        if([[GlobalPrefrences  getPaypal_TOKEN_CHECK] isEqualToString:@"YES"])
        { 
            zooz.sandbox = NO;
            [zooz openPayment:req forAppKey:[GlobalPrefrences getPaypalLiveToken]];
            
            
        } else
        {    
            zooz.sandbox = YES;
            [zooz openPayment:req forAppKey:[GlobalPrefrences getPaypalLiveToken]];
        }
    }
 
    
    
    
}

#pragma mark fetching option and name of product

-(NSMutableArray *) fetchNameOptionProduct:(int)k
{  
    NSMutableString * newproductName ;
    
    NSMutableArray *test=[NSMutableArray new];
    
    NSMutableArray * strArray=[NSMutableArray new];
    float optionPrice=0;
    
    newproductName = [NSString stringWithFormat:@"%@", [[arrProductIds objectAtIndex:k] valueForKey:@"sName"]];
    
    
    
    int optionSizesIndex[100];
    
    if (!([[[arrProductIds objectAtIndex:k] valueForKey:@"pOptionId"] intValue]==0))
    {
        
        NSMutableArray *dictOption = [[arrProductIds objectAtIndex:k] objectForKey:@"productOptions"];
        
        NSMutableArray *arrProductOptionSize = [[[NSMutableArray alloc] init] autorelease];
        
        for (int i=0; i<[dictOption count]; i++)
        {
            [arrProductOptionSize addObject:[[dictOption objectAtIndex:i] valueForKey:@"id"]];
        }
        
        NSArray *arrSelectedOptions=[[[arrCartItems objectAtIndex:k] valueForKey:@"pOptionId"] componentsSeparatedByString:@","];
        
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
            
            
            
            optionPrice+=[[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"pPrice"]floatValue];
            
            
            [test addObject: [NSString stringWithFormat:@"%@: %@",[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"sTitle"],[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"sName"]]] ;
            
        } 
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",newproductName,[test componentsJoinedByString:@"," ]]);
        
        [strArray addObject:[NSString stringWithFormat:@"%@ [%@]",newproductName,[test componentsJoinedByString:@"," ]]]; 
        [strArray addObject:[NSString stringWithFormat:@"%f",optionPrice]];
        
        return strArray;
    }
    else 
    {
        [strArray addObject:[NSString stringWithFormat:@"%@",newproductName]];
        [strArray addObject:[NSString stringWithFormat:@"%f",optionPrice]];
        return strArray;
    }
    
}


#pragma mark Cash On Develiery Integration


-(void)cashOnDeveliery
{  
    
    [self performSelectorInBackground:@selector(sendDataToServer:) withObject:@"1"];
	
	NSString *strTitle = [[NSString alloc] initWithFormat:@"%@",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.order.completed.sucess.title"] ];
	
	NSString *strMessage = [[NSString alloc] initWithFormat:@"%@",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.order.completed.sucess.text"]];
	
	NSString *strCancelButton = [[NSString alloc] initWithFormat:@"%@",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] ];
	
	if ([strTitle length]>0 && [strMessage length]>0 && [strCancelButton length]>0) 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.order.completed.sucess.title"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.order.completed.sucess.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
		
		[alert show];
		
		[alert release];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Order Approved" message:@"Thank you, your order has been completed successfully. Please visit the 'Account' tab for further details." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		[alert show];
		
		[alert release];
	}
	[strTitle release];
	[strMessage release];
	[strCancelButton release];
    
}


- (void)openPaymentRequestFailed:(ZooZPaymentRequest *)request withErrorCode:(int)errorCode andErrorMessage:(NSString *)errorMessage{
	NSLog(@"failed: %@", errorMessage);
    //this is a network / integration failure, not a payment processing failure.
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.order.failed.title"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.order.failed.text"] delegate:nil cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
	
	[alert show];
	
	[alert release];
}

- (void)paymentSuccessWithResponse:(ZooZPaymentResponse *)response{
	NSLog(@"payment success with payment Id: %@, %@, %@, %f", response.transactionId, response.cardType, response.cardDisplayString, response.paidAmount);
    
    
    
}

-(void)paymentSuccessDialogClosed{
    NSLog(@"Payment dialog closed after success");
    //see paymentSuccessWithResponse: for the response transaction ID. 
    [self performSelectorInBackground:@selector(sendDataToServer:) withObject:@"0"];
	
	NSString *strTitle = [[NSString alloc] initWithFormat:@"%@",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.order.completed.sucess.title"] ];
	
	NSString *strMessage = [[NSString alloc] initWithFormat:@"%@",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.order.completed.sucess.text"]];
	
	NSString *strCancelButton = [[NSString alloc] initWithFormat:@"%@",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] ];
	
	if ([strTitle length]>0 && [strMessage length]>0 && [strCancelButton length]>0) 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.order.completed.sucess.title"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.order.completed.sucess.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
		
		[alert show];
		
		[alert release];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Order Approved" message:@"Thank you, your order has been completed successfully. Please visit the 'Account' tab for further details." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		[alert show];
		
		[alert release];
	}
	[strTitle release];
	[strMessage release];
	[strCancelButton release];
    
    
}

- (void)paymentCanceled{
	NSLog(@"payment cancelled");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.order.cancel.title"] message:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.order.cancel.text"] delegate:nil cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
	
	[alert show];
	
	[alert release];
}



#pragma mark -Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	iNumOfItemsInShoppingCart = 0;
	[self.navigationController popToRootViewControllerAnimated:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabBarItem" object:nil];
	
}

#pragma mark Fetch Data From SQLite DB

-(void)fetchDataFromLocalDB 
{
	if(!arrUserDetails)		
		arrUserDetails = [[NSArray alloc] init];
	
	arrUserDetails = [[SqlQuery shared] getBuyerData:[GlobalPrefrences getUserDefault_Preferences:@"userEmail"]];
	NSDictionary *dictAppDetails = [[GlobalPrefrences getSettingsOfUserAndOtherDetails] objectForKey:@"store"];
	if(dictAppDetails)
	{
		sMerchantPaypayEmail = [dictAppDetails objectForKey:@"sPaypalEmail"];
		if(([sMerchantPaypayEmail isEqual:[NSNull null]]) || ([sMerchantPaypayEmail isEqualToString:@"null"]) ||  ([sMerchantPaypayEmail isEqualToString:@""]))
		{
			//use the the merchant email ID as his paypal email ID
			sMerchantPaypayEmail = merchant_email;
		}
		
	}
	

	
}
#pragma mark Send Data To Server
-(void) sendDataToServer:(NSString *)codEnabled 
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];    
   
	NSString *strDataToPost = [NSString stringWithFormat:@"{\"storeId\":%d,\"appId\":%d,\"merchantId\":%d,\"fAmount\":%0.2f,\"sMerchantPaypalEmail\":\"%@\",\"fTaxAmount\":%0.2f,\"fShippingAmount\":%0.2f,\"fTotalAmount\":%0.2f,\"sBuyerName\":\"%@\",\"sBuyerEmail\":\"%@\",\"iBuyerPhone\":null,\"sShippingStreet\":\"%@\",\"sShippingCity\":\"%@\",\"sShippingState\":\"%@\",\"sShippingPostalCode\":\"%@\",\"sShippingCountry\":\"%@\",\"sBillingStreet\":\"%@\",\"sBillingCity\":\"%@\",\"sBillingState\":\"%@\",\"sBillingPostalCode\":\"%@\",\"sBillingCountry\":\"%@\",\"codEnabled\":%d,\"orderCurrency\":\"%@\"}",iCurrentStoreId,iCurrentAppId,iCurrentMerchantId, priceWithoutTax,sMerchantPaypayEmail,fTaxAmount, totalShippingAmount,grandTotalValue, [[arrUserDetails objectAtIndex:0] objectForKey:@"sUserName"],[[arrUserDetails objectAtIndex:0] objectForKey:@"sEmailAddress"], [[arrUserDetails objectAtIndex:0] objectForKey:@"sDeliveryAddress"],[[arrUserDetails objectAtIndex:0] objectForKey:@"sDeliveryCity"],[[arrUserDetails objectAtIndex:0] objectForKey:@"sDeliveryState"],[[arrUserDetails objectAtIndex:0] objectForKey:@"sDeliveryPincode"],[[arrUserDetails objectAtIndex:0] objectForKey:@"sDeliveryCountry"],[[arrUserDetails objectAtIndex:0] objectForKey:@"sStreetAddress"],[[arrUserDetails objectAtIndex:0] objectForKey:@"sCity"],[[arrUserDetails objectAtIndex:0] objectForKey:@"sState"],[[arrUserDetails objectAtIndex:0] objectForKey:@"sPincode"],[[arrUserDetails objectAtIndex:0] objectForKey:@"sCountry"],[codEnabled intValue],_savedPreferences.strCurrency];

   
   
	
	if (![GlobalPrefrences isInternetAvailable])
	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isDataInShoppingCartQueue"];
		
        // If internet is not available, then save the data into the database, for sending it later
		
		NSLog(@"INTERNET IS UNAVAILABLE, SAVING DATA IN THE LOCAL DATABASE");
		
		[[SqlQuery shared] addToQueue_Shoppingcart:strDataToPost sendAtUrl:[NSString stringWithFormat:@"/product-order/save"]];
		for (int i =0; i<[arrProductIds count];i++)
		{
			float price;
            
			if ([[[arrProductIds objectAtIndex:i] objectForKey:@"fPrice"] floatValue]>[[[arrProductIds objectAtIndex:i] objectForKey:@"fDiscountedPrice"] floatValue])
            {
                price=[[[arrProductIds objectAtIndex:i] objectForKey:@"fDiscountedPrice"] floatValue];
            }
			else 
            {
				price=[[[arrProductIds objectAtIndex:i] objectForKey:@"fPrice"] floatValue];
			}
			
			NSString *dataToSave = [NSString stringWithFormat:@"{\"productId\":%d,\"fAmount\":%0.2f,\"orderId\":0,\"productOptionId\":%d,\"iQuantity\":%d,\"id\":null}",[[[arrProductIds objectAtIndex:i] objectForKey:@"id"] intValue],price, [[arrCartItems objectAtIndex:i] objectForKey:@"pOptionsId"], [[[arrProductIds objectAtIndex:i] objectForKey:@"quantity"] intValue]];
			
			
			
			
			
			
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isDataInIndividualProductsQueue"];
			
            [[SqlQuery shared] addToQueue_IndividualProducts:[GlobalPrefrences getCurrentShoppingCartNum] dataToSend:dataToSave sendAtUrl:[NSString stringWithFormat:@"/product-order-item-multiple/save"]];
		}
	}
	
	else 
	{
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isDataInShoppingCartQueue"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isDataInIndividualProductsQueue"];
		
		NSString *reponseRecieved = [ServerAPI product_orderSaveURLSend:strDataToPost]; 
		
		// Now send data to the server for this recently made order 
		if ([reponseRecieved isKindOfClass:[NSString class]]) 
		{
			int iCurrentOrderId = [[[[[reponseRecieved componentsSeparatedByString:@":"] objectAtIndex:1] componentsSeparatedByString:@"}"] objectAtIndex:0] intValue];
			
			for (int i =0; i<[arrProductIds count];i++)
			{
				NSString *dataToSave = [NSString stringWithFormat:@"{\"productId\":%d,\"fAmount\":%0.2f,\"orderId\":%d,\"productOptionId\":\"%@\",\"iQuantity\":%d,\"id\":null}",[[[arrProductIds objectAtIndex:i] objectForKey:@"id"] intValue],[[[arrProductIds objectAtIndex:i] objectForKey:@"fDiscountedPrice"] floatValue], iCurrentOrderId, [[arrCartItems objectAtIndex:i] valueForKey:@"pOptionId"], [[[arrProductIds objectAtIndex:i] objectForKey:@"quantity"] intValue]];				
				
				if (![GlobalPrefrences isInternetAvailable])
				{
					// If internet is not available, then save the data into the database, for sending it later
					
					NSLog(@"INTERNET IS UNAVAILABLE, SAVING DATA IN THE LOCAL DATABASE");
					
					[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isDataInIndividualProductsQueue"];
					
					[[SqlQuery shared] addToQueue_IndividualProducts:iCurrentOrderId dataToSend:dataToSave sendAtUrl:[NSString stringWithFormat:@"/product-order-item-multiple/save"]];
				}
				
				else
				{
					[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isDataInIndividualProductsQueue"];
					[ServerAPI product_order_ItemSaveURLSend:dataToSave];
			    }
				
				[[SqlQuery shared] deleteItemFromShoppingCart:[[[arrProductIds objectAtIndex:i] valueForKey:@"id"]integerValue] :[[arrCartItems objectAtIndex:i] valueForKey:@"pOptionId"]];
			}
			
			if (iCurrentOrderId>0) 
			{
				[ServerAPI product_order_NotifyURLSend:@"Sending Order Number Last Time":iCurrentOrderId];
			}	
		}
		else
        {
            NSLog(@"Error While sending billing details to server (CheckoutViewController)");
        }
	}
	
	[pool release];
	
	
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
*/
-(void) receivedRotate: (NSNotification*) notification
{
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
// Return YES for supported orientations
    return YES;
}

- (void)dealloc {
}


@end
