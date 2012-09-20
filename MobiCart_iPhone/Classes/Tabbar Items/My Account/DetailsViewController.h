//
//  DetailsViewController.h
//  MobiCart
//
//  Created by Mobicart on 8/26/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController <UIAlertViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
	UIAlertView *alertView1;
	UIAlertView *alertMain;
	UIView *contentView;
	UIScrollView *contentScrollView;
	UILabel *lblDetails[6];
	UITextField *txtDetails[6];
	UILabel *lblDeliveryDetails[5];
	UITextField *txtDeliveryDetails[5];
	
	UIView *viewForRegistration, *viewForLogin;
	
	NSArray *interShippingDict;
	
	UITextField *txtEmailForLogin;
	UITextField *txtPasswordForLogin;
	UIButton *btnEdit;
	
	UITextField *txtPassword[2];
	UITextField *txtBillingField[7];
	UIView *deliveryView;
	CGPoint svos;
	UITextField *txtDeliveryField[5];
	UIButton *btnSameAddress;
	UIButton *btnSubmit;
	UIToolbar *toolBar;
	UIPickerView *pickerViewCountry, *pickerViewStates;
	NSArray *arrayCountry;
	NSMutableArray *arrayStates;
	UIButton *btnShowPickerViewState, *btnShowPickerViewDeliveryState;
	
	UIButton *btnShowPickerViewDetails;
	UIButton *btnShowPickerViewDeliveryDetails;
	NSMutableArray *arrcountryCodes;
	int currentCountryIdForDelivery,currentSelectedRow;
	int currentStateIdForDelivery;
	BOOL isDeliveryCountries;
	BOOL isStatesToBeReloaded;
	BOOL isLoadingFirstTime;
	BOOL isReview;
	 
	NSDictionary *dicStates;
	
	NSMutableArray *arrInfoAccount;
	NSDictionary *dicSettings;
	
	BOOL DETAILSPRESENT;
}

@property (nonatomic, retain) UIView *viewForRegistration;
@property (nonatomic, retain) UIView *viewForLogin;
@property (nonatomic, retain) UIAlertView *alertMain;
@property (assign)BOOL isReview;

- (void)displayViewForRegistration;
- (void)displayViewForLogin;
- (void)createDeliveryView;
- (void)animationForViews:(UIView *) viewToShow :(UIView *)viewToHide;
- (void)createPickerView;
- (void)createAccount;
- (void)methodLogin;
- (void)btnCreateAccount_Clicked;
- (void)setStates;
- (void)getStatesOfaCountry:(NSString*)strCountryVal;
- (void)setStatesCountry;

@end
