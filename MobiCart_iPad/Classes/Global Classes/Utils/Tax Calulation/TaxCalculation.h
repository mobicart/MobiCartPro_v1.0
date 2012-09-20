//
//  TaxCalculation.h
//  Mobicart
//
//  Created by Mobicart on 11/05/11.
//  Copyright Mobicart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalPrefrences.h"
#import "SqlQuery.h"

@interface TaxCalculation : NSObject {

}
+ (id)shared;

-(NSString*)caluateTaxForProduct:(NSDictionary*)_dict;
-(float)caluateTaxForProductInShoppingCart:(NSMutableArray*)_arrTemp forIndexPath:(NSIndexPath*)indexPath;
-(NSArray*)getStateAndCountryIDForTax;
-(float)calculateShippingChargesForProduct:(NSDictionary*)_dict selectedQuantity:(int)_quantity  totalProductsInCart:(NSMutableArray*)arrProductsInCart;


-(float)calculateShippingForCheckoutScreen:(NSArray*)arrProductIds taxDetails:(NSDictionary*)dictTax;
-(NSArray*)calculatetaxForCheckOutScreen:(NSArray*)arrProductIds withSettings:(NSDictionary*)dicSettings forIndex:(int) index forCountryID:(int)countryID taxAmount:(float)taxPercent;
-(NSMutableArray*)calculateTaxForItemsInShoppingCart:(NSArray*)_arrayShoppingCart arrDatabaseCart:(NSArray*)_arrDatabaseCart tax:(float)_tax forIndex:(int)i;
-(NSString*)caluatePriceOptionProduct:(NSDictionary*)_dict pPrice:(float)optionPrice;
@end



