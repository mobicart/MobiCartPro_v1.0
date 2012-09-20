//
//  SubtotalCalculation.m
//  MobicartApp
//
//  Created by Mobicart on 31/05/11.
//  Copyright 2011 Net Solutions. All rights reserved.
//

#import "SubtotalCalculation.h"


@implementation SubtotalCalculation
+(float)calculateProductCost:(NSDictionary *)dictData arrDataBase:(NSArray *)arrDataB
{
    float productCost = 0.0f,optionPrice=0;
    NSString *discount = [NSString stringWithFormat:@"%@",[dictData valueForKey:@"fDiscountedPrice"]];
    float temp=[GlobalPreferences getRoundedOffValue:[discount floatValue]];
    discount=[NSString stringWithFormat:@"%f",temp];
    
    if ([[dictData valueForKey:@"bTaxable"]intValue]==1)
    {
        if ([[dictData valueForKey:@"fPrice"] floatValue]>[discount floatValue])
        {
            productCost=[discount floatValue]+[[dictData valueForKey:@"fTax"] floatValue];
        }
        else 
        {
            productCost=[[dictData valueForKey:@"fPrice"] floatValue]+[[dictData valueForKey:@"fTax"] floatValue];
        }
    }
    else 
    {
        if ([[dictData valueForKey:@"fPrice"] floatValue]>[discount floatValue])
        {
            productCost=[discount floatValue];
        }
        else
        {
            productCost=[[dictData valueForKey:@"fPrice"] floatValue];
        }
    }
    
    //----------------getOptionPrice
    
    
    if (!([[arrDataB  valueForKey:@"pOptionId"] intValue]==0))
    {    
        NSMutableArray *dictOption = [dictData  objectForKey:@"productOptions"];
        
        NSMutableArray *arrProductOptionSize = [[[NSMutableArray alloc] init] autorelease];
        
        for (int j=0; j<[dictOption count]; j++)
        {
            [arrProductOptionSize addObject:[[dictOption objectAtIndex:j] valueForKey:@"id"]];
            
            
            
        }
        
        NSArray *arrSelectedOptions=[[arrDataB  valueForKey:@"pOptionId"] componentsSeparatedByString:@","];
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
            
            
            
            NSLog(@"%f",[[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"pPrice"]floatValue]);
            optionPrice =optionPrice+[[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"pPrice"]floatValue];
           
        }
        
        
    } 

    productCost+=optionPrice;
        
    return productCost;
}


+(float)calculateProductCostFooter:(NSDictionary *)dictData arrDataBase:(NSArray *)arrDataB tax:(float)tax

{    
    float productCost = 0.0f,optionPrice=0,totalTaxApplied=0;
   
    float productQuantity=[[arrDataB valueForKey:@"quantity"] intValue];
    NSString *discount = [NSString stringWithFormat:@"%@",[dictData valueForKey:@"fDiscountedPrice"]];
    
    
    
    float temp=[GlobalPreferences getRoundedOffValue:[discount floatValue]];
    discount=[NSString stringWithFormat:@"%f",temp];
    
    if ([[dictData valueForKey:@"bTaxable"]intValue]==1)
    {
        if ([[dictData valueForKey:@"fPrice"] floatValue]>[discount floatValue])
        {
            productCost=[discount floatValue]+[[dictData valueForKey:@"fTax"] floatValue];
       totalTaxApplied+=(([discount floatValue]*productQuantity)*tax)/100;
        
        
        }
        else 
        {
            productCost=[[dictData valueForKey:@"fPrice"] floatValue]+[[dictData valueForKey:@"fTax"] floatValue];
            
            totalTaxApplied=(totalTaxApplied+(([[dictData valueForKey:@"fPrice"] floatValue])*productQuantity)*tax)/100;
            
        }
    }
    else 
    {
        if ([[dictData valueForKey:@"fPrice"] floatValue]>[discount floatValue])
        {
            productCost=[discount floatValue];
        }
        else
        {
            productCost=[[dictData valueForKey:@"fPrice"] floatValue];
        }
    }
    
   
    if (!([[arrDataB  valueForKey:@"pOptionId"] intValue]==0))
    {    
        NSMutableArray *dictOption = [dictData  objectForKey:@"productOptions"];
        
        NSMutableArray *arrProductOptionSize = [[[NSMutableArray alloc] init] autorelease];
        
        for (int j=0; j<[dictOption count]; j++)
        {
            [arrProductOptionSize addObject:[[dictOption objectAtIndex:j] valueForKey:@"id"]];
            
            
            
        }
        
        NSArray *arrSelectedOptions=[[arrDataB  valueForKey:@"pOptionId"] componentsSeparatedByString:@","];
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
                          
            NSLog(@"%f",[[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"pPrice"]floatValue]);
            optionPrice =optionPrice+[[[dictOption objectAtIndex:optionSizesIndex[count]]valueForKey:@"pPrice"]floatValue];
            
        }
        
        
    }    
  
     
    productCost+=optionPrice;
    
    productCost=productCost*productQuantity;

    return productCost;
    
   
    
}



@end
