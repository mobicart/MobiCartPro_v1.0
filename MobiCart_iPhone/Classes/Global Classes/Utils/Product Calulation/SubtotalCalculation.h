//
//  SubtotalCalculation.h
//  MobicartApp
//
//  Created by Mobicart on 31/05/11.
//  Copyright 2011 Net Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GlobalPreferences.h"
#import "Constants.h"
#import "SBJSON.h"


@interface SubtotalCalculation : NSObject {
    
}
+(float)calculateProductCost:(NSDictionary *)dictData arrDataBase:(NSArray*)arrDataB;
+(float)calculateProductCostFooter:(NSDictionary *)dictData arrDataBase:(NSArray *)arrDataB tax:(float)tax;


@end
