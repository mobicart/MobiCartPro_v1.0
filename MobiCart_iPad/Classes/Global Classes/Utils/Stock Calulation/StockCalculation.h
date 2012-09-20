//
//  StockCalculation.h
//  MobicartApp
//
//  Created by Mobicart on 20/06/11.
//  Copyright 2011 Mobicart. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StockCalculation : NSObject {
	
	NSMutableArray *arrDropdown[100];
	BOOL isOutOfStock;
	int dropDownCount;
	NSString *strTitle;

}
-(BOOL)checkOptionsAvailability:(NSArray *)arrOptionsData;

@end
