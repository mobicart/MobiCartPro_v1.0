//
//  DetailsViewController.h
//  MobiCart
//
//  Copyright Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
BOOL isLoadingTableFooter;
@interface DetailsViewController : UIViewController <UIAlertViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
	UIAlertView *alertView1;
	UIAlertView *alertMain;
	UIView *contentView;
	UIScrollView *contentScrollView;
	UILabel *lblDetails[6],*lblCart;
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
	BOOL DETAILSPRESENT;
	UIPickerView *pickerViewCountry, *pickerViewStates;
	NSArray *arrayCountry;
	NSMutableArray *arrayStates;
	UIButton *btnShowPickerViewState, *btnShowPickerViewDeliveryState;	
	UIButton *btnShowPickerViewDetails;
	UIButton *btnShowPickerViewDeliveryDetails;
	NSMutableArray *arrcountryCodes;
	int currentCountryIdForDelivery,currentSelectedRow;
	int currentStateIdForDelivery;
	BOOL isLoadingFirstTime;
	BOOL isReview;
	BOOL isFromPostReview; 
	BOOL isLoginByCheckOut;
	NSDictionary *dicStates;	
	NSMutableArray *arrInfoAccount;
	NSDictionary *dicSettings;
}
@property (nonatomic, retain) UIPickerView *pickerViewCountry;
@property (nonatomic, retain) UIPickerView *pickerViewStates;
@property (nonatomic, retain) UIView *viewForRegistration;
@property (nonatomic, retain) UIView *viewForLogin;
@property (nonatomic, retain) UIAlertView *alertMain;
@property (assign)BOOL isReview;
@property (assign)BOOL isFromPostReview;
-(void)displayViewForRegistration;
-(void)displayViewForLogin;
-(void)createDeliveryView;
-(void)animationForViews:(UIView *) viewToShow :(UIView *)viewToHide;
-(void)createPickerView;
-(void)createAccount;
-(void)methodLogin;
-(void)btnCreateAccount_Clicked;
-(void)setStates;
-(void)setStatesCountry;
-(void)AccountInfoToEdit;
- (void)getStatesOfaCountry:(NSString*)strCountryVal;
@end
