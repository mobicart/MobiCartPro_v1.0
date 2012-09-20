//
//  ProductPriceCalculation.m
//  MobicartApp
//
//  Created by Mobicart on 27/05/11.
//  Copyright 2011 Mobicart. All rights reserved.
//

#import "ProductPriceCalculation.h"

@implementation ProductPriceCalculation

// Without INCL TAX display-- DISCOUNTED PRICE
+(float)discountedPrice:(NSDictionary *)dicProduct
{
    float finalProductprice=0;
    
    // Calculation of Discounted Price
    if ([[dicProduct valueForKey:@"bTaxable"]intValue]==1)
	{
		if ([[dicProduct objectForKey:@"fPrice"] floatValue]>[[dicProduct valueForKey:@"fDiscountedPrice"] floatValue])
        {
            finalProductprice= [[dicProduct valueForKey:@"fDiscountedPrice"] floatValue]+[[dicProduct valueForKey:@"fTax"] floatValue];
        }
		else
        {
            finalProductprice= [[dicProduct valueForKey:@"fPrice"] floatValue]+[[dicProduct valueForKey:@"fTax"] floatValue];
        }
	}
	else 
	{
		if ([[dicProduct objectForKey:@"fPrice"] floatValue]>[[dicProduct valueForKey:@"fDiscountedPrice"] floatValue])
        {
            finalProductprice= [[dicProduct valueForKey:@"fDiscountedPrice"] floatValue];
        }
		else
        {
            finalProductprice= [[dicProduct valueForKey:@"fPrice"] floatValue];
        }
    }

    return finalProductprice;
}

// With INCL TAX display-- DISCOUNTED PRICE
+ (NSString *)calculateDiscountedPrice:(NSDictionary *)dicProduct
{
    float finalProductprice=[self discountedPrice:dicProduct];
    
	NSString *strFinalProductPrice=@"";
    
    // Determine Final Product Price with Tax Type 
	if ([[dicProduct valueForKey:@"bTaxable"]intValue]==1)
	{
		if (![[dicProduct objectForKey:@"sTaxType"]isEqualToString:@"default"])
        {
            strFinalProductPrice=[NSString stringWithFormat:@"%0.2f (Inc %@)",finalProductprice,[dicProduct valueForKey:@"sTaxType"]];
        }
		else
        {
            strFinalProductPrice=[NSString stringWithFormat:@"%0.2f",finalProductprice];
        }
	}
	else
    {
		strFinalProductPrice=[NSString stringWithFormat:@"%0.2f",finalProductprice];
	}
    
    return strFinalProductPrice;
}


+ (NSString *)calculateOptionDiscountedPrice:(NSDictionary *)dicProduct pPrice:(float)oPrice
{
    float finalProductprice=[self discountedPrice:dicProduct];
    
	NSString *strFinalProductPrice=@"";
    
    // Determine Final Product Price with Tax Type 
	if ([[dicProduct valueForKey:@"bTaxable"]intValue]==1)
	{
		if (![[dicProduct objectForKey:@"sTaxType"]isEqualToString:@"default"])
        {
            strFinalProductPrice=[NSString stringWithFormat:@"%0.2f (Inc %@)",finalProductprice,[dicProduct valueForKey:@"sTaxType"]];
        }
		else
        {
            strFinalProductPrice=[NSString stringWithFormat:@"%0.2f",finalProductprice];
        }
	}
	else
    {
		strFinalProductPrice=[NSString stringWithFormat:@"%0.2f",finalProductprice];
	}
    
    return strFinalProductPrice;
}


// With INCL TAX display-- ORIGINAL PRICE
+ (NSString *)calculateProductPrice:(NSDictionary *)dicProduct 
{
    NSString *strFinalPrice;
    NSString *strFinalProductPrice=[NSString stringWithFormat:@"%@",[ProductPriceCalculation calculateDiscountedPrice:dicProduct]];
    
    // Determine Only Tax Type
	NSString *strTaxType=[dicProduct objectForKey:@"sTaxType"];
    
	if ([strTaxType isEqualToString:@"default"])
    {
        strTaxType=@"";
    }
	else
    {
        strTaxType=[NSString stringWithFormat:@"(Inc %@)",strTaxType];	
    }
	
	if ([[dicProduct valueForKey:@"bTaxable"]intValue]==0)
    {
        strFinalPrice=[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, [[dicProduct objectForKey:@"fPrice"] floatValue]];
    }
	else	
	{
		if ([[dicProduct objectForKey:@"fPrice"] floatValue]>[[dicProduct valueForKey:@"fDiscountedPrice"] floatValue])
		{
			if ([[dicProduct valueForKey:@"bTaxable"]intValue]==1)
            {
                 strFinalPrice=[NSString stringWithFormat:@"%@%0.2f %@", _savedPreferences.strCurrencySymbol,([[dicProduct objectForKey:@"fPrice"] floatValue]+[[dicProduct objectForKey:@"fTaxOnFPrice"] floatValue]),strTaxType];
            }
			else
            {
                strFinalPrice=[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol,([[dicProduct objectForKey:@"fPrice"] floatValue]+[[dicProduct objectForKey:@"fTax"] floatValue])];
            }
		}
		else
		{
             strFinalPrice=[NSString stringWithFormat:@"%@%@", _savedPreferences.strCurrencySymbol,strFinalProductPrice];
		}
	}

    return strFinalPrice;
}
//--------------------------------pPrice-----------------
+(NSString*)caluatePriceOptionProduct:(NSDictionary*)dicProduct pPrice:(float)optionPrice
{
    NSString *strFinalPrice;
    NSString *strFinalProductPrice=[NSString stringWithFormat:@"%@",[ProductPriceCalculation calculateDiscountedPrice:dicProduct]];
    
    
    
    // Determine Only Tax Type
	NSString *strTaxType=[dicProduct objectForKey:@"sTaxType"];
    
	if ([strTaxType isEqualToString:@"default"])
    {
        strTaxType=@"";
    }
	else
    {
        strTaxType=[NSString stringWithFormat:@"(Inc. %@)",strTaxType];	
    }
	
	if ([[dicProduct valueForKey:@"bTaxable"]intValue]==0)
    {
        strFinalPrice=[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, [[dicProduct objectForKey:@"fPrice"] floatValue]+optionPrice];
    }
	else	
	{
		if ([[dicProduct objectForKey:@"fPrice"] floatValue]>[[dicProduct valueForKey:@"fDiscountedPrice"] floatValue])
		{
			if ([[dicProduct valueForKey:@"bTaxable"]intValue]==1)
            {
                strFinalPrice=[NSString stringWithFormat:@"%@%0.2f %@", _savedPreferences.strCurrencySymbol,([[dicProduct objectForKey:@"fPrice"] floatValue]+optionPrice+[[dicProduct objectForKey:@"fTaxOnFPrice"] floatValue]),strTaxType];
            }
			else
            {
                strFinalPrice=[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol,([[dicProduct objectForKey:@"fPrice"] floatValue]+optionPrice+[[dicProduct objectForKey:@"fTax"] floatValue])];
            }
		}
		else
		{
            float oPrice=optionPrice+[strFinalProductPrice floatValue];
            strFinalPrice=[NSString stringWithFormat:@"%@%@", _savedPreferences.strCurrencySymbol,[NSString stringWithFormat:@"%0.2f",oPrice]];
		}
	}
    //float oPrice=optionPrice+[strFinalPrice floatValue];
   // strFinalPrice=[NSString stringWithFormat:@"%0.2f",oPrice]; 
    
    return strFinalPrice;
}
//--------------------------------pPrice--ORIGINAL PRICE---------------
+(NSString*)caluateOriginalPriceOptionProduct:(NSDictionary*)dicProduct pPrice:(float)optionPrice
{
    float finalProductprice=[self discountedPrice:dicProduct];
    
    finalProductprice+=optionPrice;
    
	NSString *strFinalProductPrice=@"";
    
    // Determine Final Product Price with Tax Type 
	if ([[dicProduct valueForKey:@"bTaxable"]intValue]==1)
	{
		if (![[dicProduct objectForKey:@"sTaxType"]isEqualToString:@"default"])
        {
            strFinalProductPrice=[NSString stringWithFormat:@"%0.2f (Inc. %@)",finalProductprice,[dicProduct valueForKey:@"sTaxType"]];
        }
		else
        {
            strFinalProductPrice=[NSString stringWithFormat:@"%0.2f",finalProductprice];
        }
	}
	else
    {
		strFinalProductPrice=[NSString stringWithFormat:@"%0.2f",finalProductprice];
	}
   strFinalProductPrice=[NSString stringWithFormat:@"%@%@", _savedPreferences.strCurrencySymbol,strFinalProductPrice]; 
    
    
    return strFinalProductPrice;
}

// Without INCL TAX display-- ORIGINAL PRICE
+ (NSString *)productActualPrice:(NSDictionary *)dicProduct
{
    NSString *strFinalPrice;
    NSString *strFinalProductPrice=[NSString stringWithFormat:@"%@",[ProductPriceCalculation calculateDiscountedPrice:dicProduct]];
	
	if ([[dicProduct valueForKey:@"bTaxable"]intValue]==0)
    {
        strFinalPrice=[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol, [[dicProduct objectForKey:@"fPrice"] floatValue]];
    }
	else	
	{
		if ([[dicProduct objectForKey:@"fPrice"] floatValue]>[[dicProduct valueForKey:@"fDiscountedPrice"] floatValue])
		{
			if ([[dicProduct valueForKey:@"bTaxable"]intValue]==1)
            {
                strFinalPrice=[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol,([[dicProduct objectForKey:@"fPrice"] floatValue]+[[dicProduct objectForKey:@"fTaxOnFPrice"] floatValue])];
            }
			else
            {
                strFinalPrice=[NSString stringWithFormat:@"%@%0.2f", _savedPreferences.strCurrencySymbol,([[dicProduct objectForKey:@"fPrice"] floatValue]+[[dicProduct objectForKey:@"fTax"] floatValue])];
            }
		}
		else
		{
            strFinalPrice=[NSString stringWithFormat:@"%@%@", _savedPreferences.strCurrencySymbol,strFinalProductPrice];
		}
	}
  //  NSLog(@"%@",strFinalPrice);
    return strFinalPrice;

}

// ONLY PRICE WITHOUT TAX TYPE
+ (NSString *)finalPriceWithoutTaxType:(NSDictionary *)dicProduct
{
    NSString *discount;
	NSString *strTaxTypeLenght=@"";
	strTaxTypeLenght=[dicProduct objectForKey:@"sTaxType"];
	
	if ([strTaxTypeLenght isEqualToString:@"default"])
    {
		discount = [NSString stringWithFormat:@"%@%@", _savedPreferences.strCurrencySymbol,[dicProduct objectForKey:@"fPrice"]];
    }
    else
	{
		if ([[dicProduct valueForKey:@"bTaxable"]intValue]==1)
        {
            discount = [NSString stringWithFormat:@"%@%@", _savedPreferences.strCurrencySymbol,[dicProduct objectForKey:@"fPrice"]];
        }
		else
        {
            discount = [NSString stringWithFormat:@"%@%@", _savedPreferences.strCurrencySymbol,[dicProduct objectForKey:@"fPrice"]];
        }
	}
    return discount;
}

@end
