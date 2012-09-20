//
//  CheckoutViewController.h
//  MobiCart
//
//  Created by MobiCart on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZooZSDK/ZooZ.h>


@interface CheckoutViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,ZooZPaymentCallbackDelegate>
{
	UIView *contentView;
	float grandTotalValue, fTaxAmount, fSubTotalAmount, fShippingCharges, fShippingTax,fSubTotal;
	
	NSArray *arrUserDetails, *arrProductIds; 
	NSString *sMerchantPaypayEmail,*sCountry;
	
	UIScrollView *contentScrollView;
	float priceWithoutTax;
	float productShippingTax;
	BOOL istaxToBeApplied;
	float taxOnShipping;
	float totalShippingAmount;
	UITableView *tableView;
	NSDictionary *dicSettings;
	float _fSubTotal;
	float shippingtax;
	NSDictionary *dictTaxAndShippingDetails;
	int countryID;
	int stateID;
	float taxPercent;
	NSDictionary *dictTax;
	NSString *strURL;
	UILabel *lblSubTotalCharges;
	UILabel *lblTaxAmount;
	UILabel *lblShippingCharges;
	UILabel *lblShippingTax;
	UILabel *lblGrandTotal;
	BOOL isLoadingFooterSecondTime;
	//NSString *strCountry;
	//NSString *strState;
	NSMutableArray *arrCartItems;
	NSMutableArray *arrInfoAccount;
   
    UIView *popupView;
}

@property(readwrite)float grandTotalValue;
@property(readwrite)float fTaxAmount;
@property(readwrite)float fSubTotalAmount;
@property(readwrite)float fShippingCharges;
@property(readwrite)float fSubTotal;
@property(nonatomic,retain)NSString *sCountry;
@property(nonatomic,retain)NSString *sMerchantPaypayEmail;
@property(nonatomic,retain) NSArray *arrProductIds;
@property(nonatomic,retain)NSMutableArray *arrCartItems;
-(NSString *) sendDataToServer:(NSURL *)_url withData:(NSString *)strDataToPost;
-(void)fetchDataFromLocalDB;
-(NSMutableArray *) fetchNameOptionProduct:(int)k;

@end
