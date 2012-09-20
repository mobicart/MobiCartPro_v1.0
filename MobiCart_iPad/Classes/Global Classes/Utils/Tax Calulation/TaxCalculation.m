//
//  TaxCalculation.m
//  Mobicart
//
//  Created by Mobicart on 11/05/11.
//  Copyright Mobicart. All rights reserved.
//

#import "TaxCalculation.h"


@implementation TaxCalculation


static TaxCalculation *shared;

//Intitializes SqlQuery instance
- (id)init {
	if (shared) {
        [self autorelease];
        return shared;
    }
	
	if (![super init]) return nil;
	
	shared = self;
	return self;
} 

//Creates a single instance of SqlQuery and returns the same every time called.
+ (id)shared 
{
    if (!shared) 
	{
        [[TaxCalculation alloc] init];
    }
    return shared;
}
-(NSArray*)getStateAndCountryIDForTax
{
	
	NSDictionary *dictSettingsDetails=[[NSDictionary alloc]init];
	dictSettingsDetails=[[GlobalPrefrences getSettingsOfUserAndOtherDetails]retain];
	
	//Check if user is logged into app or not
	NSMutableArray *arrInfoAccount=[[NSMutableArray alloc]init];
	arrInfoAccount=[[SqlQuery shared] getAccountData:[GlobalPrefrences getUserDefault_Preferences:@"userEmail"]];
	
	int countryID=0,stateID=0;
	
	
	//if user is logged into aap we will use his country and state id to get the tax which we are saving in while default
	//when user is creating his account. The state and count id will be of shipping address
	if([arrInfoAccount count]>0)
	{
		stateID=[[[NSUserDefaults standardUserDefaults] valueForKey:@"stateID"]intValue];
	    countryID=[[[NSUserDefaults standardUserDefaults] valueForKey:@"countryID"]intValue];
		
	}
	else {
		/*if use  is not logged into app we will use merchats base country tax with others state combination. 
		 if tax of other state is defined we will use mechant's base country and others combination other wise we will use merchants base county and 0 as 
		 state id and in this case tax will be 0
		 */
		
		
		countryID=[[[dictSettingsDetails valueForKey:@"store"]valueForKey:@"territoryId"]intValue];
		NSArray *arrtaxCountries=[[dictSettingsDetails valueForKey:@"store"]valueForKey:@"taxList"];
		NSArray *arrShippingCountries=[[dictSettingsDetails valueForKey:@"store"]valueForKey:@"shippingList"];
		
		NSMutableArray *arrTaxAndShippingCountries=[[NSMutableArray alloc]init];
		
		for (int index=0; index<[arrtaxCountries count]; index++) {
			[arrTaxAndShippingCountries addObject:[arrtaxCountries objectAtIndex:index]];
		}
		
	    for (int index=0; index<[arrShippingCountries count]; index++) {
			[arrTaxAndShippingCountries addObject:[arrShippingCountries objectAtIndex:index]];
		}
		
		
		for(int index=0;index<[arrTaxAndShippingCountries count];index++)
		{
			if([[[arrTaxAndShippingCountries objectAtIndex:index]valueForKey:@"sState"]isEqualToString:@"Other"]&& [[[arrTaxAndShippingCountries objectAtIndex:index]valueForKey:@"territoryId"]intValue]==countryID)
			{
				stateID=[[[arrTaxAndShippingCountries objectAtIndex:index]valueForKey:@"id"]intValue];
			    break;
			}
		}
		
	}
	
	[arrInfoAccount release];
    NSArray *arrTemp=[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:stateID],[NSNumber numberWithInt:countryID],nil];
	return arrTemp;
	
}


-(float)caluateTaxForProductInShoppingCart:(NSMutableArray*)_arrTemp forIndexPath:(NSIndexPath*)indexPath
{
    float productCost = 0.0f;
	NSString *discount = [NSString stringWithFormat:@"%@",[[_arrTemp objectAtIndex:indexPath.row]valueForKey:@"fDiscountedPrice"]];
	float temp=[GlobalPrefrences getRoundedOffValue:[discount floatValue]];
	discount=[NSString stringWithFormat:@"%f",temp];
	
	if([[[_arrTemp objectAtIndex:indexPath.row]valueForKey:@"bTaxable"]intValue]==1)
	{
		if([[[_arrTemp objectAtIndex:indexPath.row]valueForKey:@"fPrice"] floatValue]>[discount floatValue])
			productCost=[discount floatValue]+[[[_arrTemp objectAtIndex:indexPath.row]valueForKey:@"fTax"] floatValue];
		else 
			productCost=[[[_arrTemp objectAtIndex:indexPath.row]valueForKey:@"fPrice"] floatValue]+[[[_arrTemp objectAtIndex:indexPath.row]valueForKey:@"fTax"] floatValue];
	}
	else {
		if([[[_arrTemp objectAtIndex:indexPath.row]valueForKey:@"fPrice"] floatValue]>[discount floatValue])
			productCost=[discount floatValue];
		else 
			productCost=[[[_arrTemp objectAtIndex:indexPath.row]valueForKey:@"fPrice"] floatValue];
	}
	
	return productCost;
}

-(NSString*)caluateTaxForProduct:(NSDictionary*)_dict
{
	float productCost=0;
	NSString *strFinalPrice;
	NSString *discount = [NSString stringWithFormat:@"%@", [_dict objectForKey:@"fDiscountedPrice"]];
	
	
	if([_savedPreferences.strCurrencySymbol isEqualToString:@"<null>"]|| _savedPreferences.strCurrencySymbol==nil)
		_savedPreferences.strCurrencySymbol=@"";
	
	
	if((![discount isEqual:[NSNull null]]) && (![discount isEqualToString:@"<null>"]) && ([discount length]!=0))
	{
		if([[_dict objectForKey:@"fPrice"] floatValue]>=[discount floatValue])
			productCost=[discount floatValue];
	}
	else
		productCost=[[_dict objectForKey:@"fPrice"] floatValue];
	
	if(![[_dict objectForKey:@"bTaxable"]isEqual:[NSNull null]])	
	{
		if([[_dict objectForKey:@"bTaxable"] intValue]==1)
		{
			productCost=productCost+[[_dict objectForKey:@"fTax"] floatValue];
			if(![[_dict objectForKey:@"sTaxType"] isEqualToString:@"default"])
				strFinalPrice=[NSString stringWithFormat:@"%@%0.2f (Inc. %@)",_savedPreferences.strCurrencySymbol,productCost,[_dict objectForKey:@"sTaxType"]];
			else
				strFinalPrice=[NSString stringWithFormat:@"%@%0.2f",_savedPreferences.strCurrencySymbol,productCost];
			
		}
		else {
			strFinalPrice=[NSString stringWithFormat:@"%@%0.2f",_savedPreferences.strCurrencySymbol,productCost];
		}
		
	}
	
	
	return strFinalPrice;
}

-(NSMutableArray*)calculateTaxForItemsInShoppingCart:(NSArray*)_arrayShoppingCart arrDatabaseCart:(NSArray*)_arrDatabaseCart tax:(float)_tax forIndex:(int)i
{
	
 	float subTotal=0,productCost=0,totalTaxApplied=0,optionPrice=0;
	
	NSString *discount = [NSString stringWithFormat:@"%@",[[_arrayShoppingCart objectAtIndex:i]valueForKey:@"fDiscountedPrice"]];
	
	
	float productQuantity=[[[_arrDatabaseCart objectAtIndex:i]valueForKey:@"quantity"] intValue];
	if([[[_arrayShoppingCart objectAtIndex:i]valueForKey:@"bTaxable"]intValue]==1)
	{
		if([[[_arrayShoppingCart objectAtIndex:i]valueForKey:@"fPrice"] floatValue]>[discount floatValue])
		{
			productCost=[discount floatValue];
			totalTaxApplied+=(([discount floatValue]*productQuantity)*_tax)/100;
		}
		else 
		{
			productCost=[[[_arrayShoppingCart objectAtIndex:i]valueForKey:@"fPrice"] floatValue];
			totalTaxApplied=(totalTaxApplied+(([[[_arrayShoppingCart objectAtIndex:i]valueForKey:@"fPrice"] floatValue]*_tax)/100)*productQuantity);
			
			
		}
	}
	else {
		if([[[_arrayShoppingCart objectAtIndex:i]valueForKey:@"fPrice"] floatValue]>[discount floatValue])
			productCost=[discount floatValue];
		else 
			productCost=[[[_arrayShoppingCart objectAtIndex:i]valueForKey:@"fPrice"] floatValue];
	}
	
	
	
	subTotal =	productCost * [[[_arrDatabaseCart objectAtIndex:i]valueForKey:@"quantity"] intValue];    
	
    //------------------getOptionPrice--------------------------
        if(![_arrDatabaseCart count] == 0)
    {
  
        {
            
           if (!([[[_arrDatabaseCart objectAtIndex:i] valueForKey:@"pOptionId"] intValue]==0))
            {
                
                NSMutableArray *dictOption = [[_arrayShoppingCart objectAtIndex:i] objectForKey:@"productOptions"];
                
                NSMutableArray *arrProductOptionSize = [[[NSMutableArray alloc] init] autorelease];
                
                for (int j=0; j<[dictOption count]; j++)
                {
                    [arrProductOptionSize addObject:[[dictOption objectAtIndex:j] valueForKey:@"id"]];
                    
                    
                    
                }
                
                NSArray *arrSelectedOptions=[[[_arrDatabaseCart objectAtIndex:i] valueForKey:@"pOptionId"] componentsSeparatedByString:@","];
                int optionSizesIndex[100];
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
                    optionPrice =optionPrice+[[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"pPrice"]floatValue];
               
                }
                
                
            } 
            optionPrice=optionPrice*[[[_arrDatabaseCart objectAtIndex:i]valueForKey:@"quantity"] intValue]; 
            
        }
    }

    productCost+=optionPrice;
    subTotal+=optionPrice;
    
	NSMutableArray *arrTaxDetails=[[NSMutableArray alloc]init];
	[arrTaxDetails addObject:[NSString stringWithFormat:@"%f", productCost]];
	[arrTaxDetails addObject:[NSString stringWithFormat:@"%f", subTotal]];
	[arrTaxDetails addObject:[NSString stringWithFormat:@"%f", totalTaxApplied]];
	return arrTaxDetails;
}

-(NSArray*)calculatetaxForCheckOutScreen:(NSArray*)arrProductIds withSettings:(NSDictionary*)dicSettings forIndex:(int) index forCountryID:(int)countryID taxAmount:(float)taxPercent
{
	float productCost,_fSubTotal=0,priceWithoutTax=0;
	float productTax=0,fTaxAmount=0,optionPrice=0;
	
	NSString *discount = [NSString stringWithFormat:@"%@", [[arrProductIds objectAtIndex:index-1]valueForKey:@"fDiscountedPrice"]];
	
	if((![discount isEqual:[NSNull null]]) && (![discount isEqualToString:@"<null>"]) && ([discount length]!=0))
	{
		if([[[arrProductIds objectAtIndex:index-1]valueForKey:@"fPrice"] floatValue]>[discount floatValue])
			productCost=[discount floatValue];
		else
			productCost=[discount floatValue];
		
	}
	else
		productCost=[[[arrProductIds objectAtIndex:index-1]valueForKey:@"fPrice"] floatValue];
	
	productCost=[GlobalPrefrences getRoundedOffValue:productCost];
	priceWithoutTax+=(productCost*[[[arrProductIds objectAtIndex:index-1] valueForKey:@"quantity"] intValue]);
	
	
	if([[[dicSettings valueForKey:@"store"]valueForKey:@"bIncludeTax"]intValue]==1)
		productCost=(productCost+[[[arrProductIds objectAtIndex:index-1]valueForKey:@"fTax"]floatValue]);
	
	
	float productTotal = [[[arrProductIds objectAtIndex:index-1] valueForKey:@"quantity"] intValue] * productCost;
	productTotal=[GlobalPrefrences getRoundedOffValue:productTotal];
	_fSubTotal+=productTotal;
	_fSubTotal=[GlobalPrefrences getRoundedOffValue:_fSubTotal];
	
	
	
	
	
	if([[[dicSettings valueForKey:@"store"]valueForKey:@"bIncludeTax"]intValue]==1)
	{				
		if(countryID==0)
		{
			productTax = 0;
			fTaxAmount = 0;
			productTotal = productTotal;
		}
		else
		{
			if([[[arrProductIds objectAtIndex:index-1]valueForKey:@"fPrice"] floatValue]>[discount floatValue])
				productTax=([discount floatValue]*taxPercent)/100;
			else
				
				productTax=([[[arrProductIds objectAtIndex:index-1]valueForKey:@"fPrice"] floatValue]*taxPercent)/100;
			productTax = (productTax * [[[arrProductIds objectAtIndex:index-1] valueForKey:@"quantity"] intValue]);
			fTaxAmount += productTax;
			productTotal = productTotal; 
		}
	}
    //-------------------------getOptionPrice--------------------
     {
        
         {
            
            
            
            if (!([[[arrProductIds objectAtIndex:index-1] valueForKey:@"pOptionId"] intValue]==0))
            {
                
                NSMutableArray *dictOption = [[arrProductIds objectAtIndex:index-1] objectForKey:@"productOptions"];
                
                NSMutableArray *arrProductOptionSize = [[[NSMutableArray alloc] init] autorelease];
                
                for (int j=0; j<[dictOption count]; j++)
                {
                    [arrProductOptionSize addObject:[[dictOption objectAtIndex:j] valueForKey:@"id"]];
                    
                    
                    
                }
                
                NSArray *arrSelectedOptions=[[[arrProductIds objectAtIndex:index-1] valueForKey:@"pOptionId"] componentsSeparatedByString:@","];
                int optionSizesIndex[100];
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
                    optionPrice =optionPrice+[[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"pPrice"]floatValue];
                    
                }
                
                
            } 
            productCost+=optionPrice;
            optionPrice=optionPrice*[[[arrProductIds objectAtIndex:index-1]valueForKey:@"quantity"] intValue]; 
            
        }
    }
    _fSubTotal+=optionPrice;
    productTotal+=optionPrice;
    priceWithoutTax+=optionPrice;
  	NSMutableArray *arrTaxDetails=[[NSMutableArray alloc]init];
	[arrTaxDetails addObject:[NSString stringWithFormat:@"%f", productCost]];
	[arrTaxDetails addObject:[NSString stringWithFormat:@"%f",priceWithoutTax]];
	[arrTaxDetails addObject:[NSString stringWithFormat:@"%f",productTotal]];
	[arrTaxDetails addObject:[NSString stringWithFormat:@"%f",_fSubTotal]];
	[arrTaxDetails addObject:[NSString stringWithFormat:@"%f",productTax]];
	[arrTaxDetails addObject:[NSString stringWithFormat:@"%f",fTaxAmount]];
	
	return arrTaxDetails;
	
}

-(float)calculateShippingForCheckoutScreen:(NSArray*)arrProductIds taxDetails:(NSDictionary*)dictTax
{
	float shippingCharges=0;
	if ([arrProductIds count]==1)
	{
		if([[[arrProductIds objectAtIndex:0] valueForKey:@"quantity"] intValue]==1)
		{
			shippingCharges = [[[dictTax valueForKey:@"shipping"] valueForKey:@"fAlone"] floatValue];
			
		}
		else 
		{
			shippingCharges = [[[dictTax valueForKey:@"shipping"] valueForKey:@"fOthers"] floatValue];
		}
		
		
	}
	
	else 
	{
		if([arrProductIds count]==1)   
		{
			
			if ([[[arrProductIds objectAtIndex:0]valueForKey:@"quantity"]intValue]==1)
			{
				shippingCharges = [[[dictTax valueForKey:@"shipping"] valueForKey:@"fAlone"] floatValue];
			}
			else
			{
				shippingCharges = [[[dictTax valueForKey:@"shipping"] valueForKey:@"fOthers"] floatValue];
			}
		}
		else
		{
			
			shippingCharges = [[[dictTax valueForKey:@"shipping"] valueForKey:@"fOthers"] floatValue];
			
		}
		
	}
	return shippingCharges;
	
}


-(float)calculateShippingChargesForProduct:(NSDictionary*)_dict selectedQuantity:(int)_quantity  totalProductsInCart:(NSMutableArray*)arrProductsInCart
{
	float   shippingCharges=0.0;
	
	if([arrProductsInCart count]>1)    //If total products in cart are more than one we will apply use fOther charges for shipping
	{
		shippingCharges=[[[_dict valueForKey:@"shipping"]valueForKey:@"fOthers"]floatValue];	
	}
	else {
		if(_quantity==1)
		{
			//Here we are checking if we user is  purchasing multiple same product 
			shippingCharges=[[[_dict valueForKey:@"shipping"]valueForKey:@"fAlone"]floatValue];
		}
		else
		{
			shippingCharges=[[[_dict valueForKey:@"shipping"]valueForKey:@"fOthers"]floatValue];
			
		}
	}
	
	return shippingCharges;
	
}
//--------------------------------pPrice-----------------
-(NSString*)caluatePriceOptionProduct:(NSDictionary*)_dict pPrice:(float)optionPrice
{
	float productCost=0;
	NSString *strFinalPrice;
	NSString *discount = [NSString stringWithFormat:@"%@", [_dict objectForKey:@"fDiscountedPrice"]];
	
	
	if([_savedPreferences.strCurrencySymbol isEqualToString:@"<null>"]|| _savedPreferences.strCurrencySymbol==nil)
		_savedPreferences.strCurrencySymbol=@"";
	
	
	if((![discount isEqual:[NSNull null]]) && (![discount isEqualToString:@"<null>"]) && ([discount length]!=0))
	{
		if([[_dict objectForKey:@"fPrice"] floatValue]>=[discount floatValue])
			productCost=[discount floatValue];
	}
	else
		productCost=[[_dict objectForKey:@"fPrice"] floatValue];
    
    
    productCost=productCost+optionPrice;
    
	
	if(![[_dict objectForKey:@"bTaxable"]isEqual:[NSNull null]])	
	{
		if([[_dict objectForKey:@"bTaxable"] intValue]==1)
		{
			productCost=productCost+[[_dict objectForKey:@"fTax"] floatValue];
			if(![[_dict objectForKey:@"sTaxType"] isEqualToString:@"default"])
				strFinalPrice=[NSString stringWithFormat:@"%@%0.2f (Inc. %@)",_savedPreferences.strCurrencySymbol,productCost,[_dict objectForKey:@"sTaxType"]];
			else
				strFinalPrice=[NSString stringWithFormat:@"%@%0.2f",_savedPreferences.strCurrencySymbol,productCost];
			
		}
		else {
			strFinalPrice=[NSString stringWithFormat:@"%@%0.2f",_savedPreferences.strCurrencySymbol,productCost];
		}
		
	}
	
	
	return strFinalPrice;
}

@end
