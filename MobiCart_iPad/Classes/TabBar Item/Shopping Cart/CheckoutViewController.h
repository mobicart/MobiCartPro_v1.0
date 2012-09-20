//
//  CheckoutViewController.h
//  MobiCart
//
//  Created by Mobicart on 8/31/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZooZSDK/ZooZ.h>
UIView *contentView;
@interface CheckoutViewController : UIViewController<ZooZPaymentCallbackDelegate>
{
	
	float grandTotalValue, fTaxAmount, fSubTotalAmount, fShippingCharges, fShippingTax,fSubTotal;
	
	NSArray *arrUserDetails, *arrProductIds; 
	NSString *sMerchantPaypayEmail,*sCountry;	
	UIScrollView *contentScrollView;
	float priceWithoutTax;
	float productShippingTax;
	BOOL istaxToBeApplied;
	float taxOnShipping;
	float totalShippingAmount;
	NSMutableArray *arrCartItems;
    UIButton *btnPayPal2;
}

@property(readwrite)float grandTotalValue;
@property(readwrite)float fTaxAmount;
@property(readwrite)float fSubTotalAmount;
@property(readwrite)float fShippingCharges;
@property(readwrite)float fSubTotal;
@property(nonatomic,retain)NSString *sCountry;
@property(nonatomic,retain) UIButton *btnPayPal2;
@property(nonatomic,retain) NSArray *arrProductIds;
@property(nonatomic,retain)NSMutableArray *arrCartItems;
-(NSMutableArray *) fetchNameOptionProduct:(int)k;

@end
