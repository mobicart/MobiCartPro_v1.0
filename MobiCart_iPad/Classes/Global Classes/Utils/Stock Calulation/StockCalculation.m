//
//  StockCalculation.m
//  MobicartApp
//
//  Created by Mobicart on 20/06/11.
//  Copyright 2011 Mobicart. All rights reserved.
//

#import "StockCalculation.h"


@implementation StockCalculation

-(BOOL)checkOptionsAvailability:(NSArray *)arrOptionsData

{
	 isOutOfStock=NO;
	 dropDownCount=-1;
	
	if([arrOptionsData count]>0)
	{
		dropDownCount=0;
		strTitle= [NSString stringWithFormat:@"%@",[[arrOptionsData objectAtIndex:0] objectForKey:@"sTitle"]];
		NSLog(@"%@",strTitle);
	}	
	else
	{
		isOutOfStock=YES;	
	}	
	
	
	for(int count=0;count<[arrOptionsData count];count++)
	{
		if(([[NSString stringWithFormat:@"%@",[[arrOptionsData objectAtIndex:count]objectForKey:@"sTitle"]] isEqualToString:strTitle]))
		{ 
			if(!arrDropdown[dropDownCount])
				arrDropdown[dropDownCount]=[[[NSMutableArray alloc]init]autorelease];
			
			[arrDropdown[dropDownCount] addObject:[arrOptionsData objectAtIndex:count]];
		}
		
		else 
		{
			BOOL isValueSet=NO;
			for(int countTemp=0;countTemp<=dropDownCount;countTemp++)
			{
			    if([[[arrDropdown[countTemp] objectAtIndex:0]objectForKey:@"sTitle"]isEqualToString:[[arrOptionsData objectAtIndex:count]objectForKey:@"sTitle"]])
				{
					[arrDropdown[countTemp] addObject:[arrOptionsData objectAtIndex:count]];
					isValueSet=YES;
					break;
				}			
			}	
			
			if(isValueSet==NO)
			{
				strTitle=[NSString stringWithFormat:@"%@",[[arrOptionsData objectAtIndex:count]objectForKey:@"sTitle"]];
				dropDownCount++;
				
				if(!arrDropdown[dropDownCount])
					arrDropdown[dropDownCount]=[[NSMutableArray alloc]init];	
				
				[arrDropdown[dropDownCount] addObject:[arrOptionsData objectAtIndex:count]];			
				
		    }
		}
		
	}
	
	for(int i=0;i<=dropDownCount;i++)
	{
		if(isOutOfStock==NO)
		{
			for(int j=0;j<[arrDropdown[i] count];j++)
			{
				if ([[[arrDropdown[i] objectAtIndex:j]valueForKey:@"iAvailableQuantity"]intValue]!=0)
				{
					isOutOfStock=NO;
					break;
				}	
				else 
				{
					isOutOfStock=YES;
				}
			}
	    }
		else 
		{
			break;
		}
	}	
	return isOutOfStock;
	
}	






-(void)dealloc
{  
	[super dealloc];
		
}	

@end
