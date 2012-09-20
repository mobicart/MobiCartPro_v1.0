//
//  ShoppingCartViewController.h
//  MobiCart
//
//  Created by Mobicart on 23/07/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

BOOL isShoppingCart_TableStyle;
BOOL isCheckForCheckout;
@interface ShoppingCartViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>
{
	UITableView *tableView,*tblStates,*tblCountries;

	NSMutableArray *arrShoppingCart, *arrDatabaseCart;
	UILabel *lblSubTotalFooter;
	UILabel *lblTax;

	UILabel *lblGrandTotalFooter;

	UILabel *lblCountryName,*lblStateName;
	UIView *contentView;
	UILabel *lblShippingCharges,*lblShippingTax;
	
	NSMutableArray *arrQuantity;
	NSInteger iTagOfCurrentQuantityBtn, iTagOfCurrentQuantityLabel,iTagOfCurrrentQuantityPrice;
	UIActionSheet *actionSheetForPicker;
	
	NSDictionary *dictSettingsDetails;
	NSMutableArray *interDict;
	NSMutableArray *arrCountries;
	NSMutableArray *arrStates;
	
	float mainTotal;
	int	countryID;
	BOOL isEditing;
	NSDictionary *dicStates;
	NSDictionary *dictTaxAndShippingDetails;
	int selectedQuantity;
	NSMutableArray *arrInfoAccount;
	NSMutableArray *arrTempShippingCountries;
	UIBarButtonItem *barBtnEdit;
	int moreTabCount;
	
	NSString *strEditButtonTitle;
	NSString *strDoneButtonTitle;
	
}

- (void)createTableView;
- (void)hideBottomBar;
@end
