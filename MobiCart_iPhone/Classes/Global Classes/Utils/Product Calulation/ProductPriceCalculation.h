//
//  ProductPriceCalculation.h
//  MobicartApp
//
//  Created by Mobicart on 27/05/11.
//  Copyright 2011 Mobicart. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "GlobalPreferences.h"
#import "Constants.h"
#import "SBJSON.h"

@interface ProductPriceCalculation : NSObject {
    
}
+ (float)discountedPrice:(NSDictionary *)dicProduct;
+ (NSString *)calculateProductPrice:(NSDictionary *)dictData;
+ (NSString *)calculateDiscountedPrice:(NSDictionary *)dicProduct;

+ (NSString *)finalPriceWithoutTaxType:(NSDictionary *)dicProduct;
+ (NSString *)productActualPrice:(NSDictionary *)dicProduct;
+(NSString*)caluatePriceOptionProduct:(NSDictionary*)dicProduct pPrice:(float)optionPrice;
+ (NSString *)calculateOptionDiscountedPrice:(NSDictionary *)dicProduct pPrice:(float)oPrice;
+(NSString*)caluateOriginalPriceOptionProduct:(NSDictionary*)dicProduct pPrice:(float)optionPrice;
@end