//
//  ShoppingCartViewController.h
//  Mobicart
//
//  Created by Mobicart on 11/05/11.
//  Copyright Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
extern BOOL isLoadingTableFooter;
@interface ShoppingCartViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate> {

	UIView *contentView;
	NSMutableArray *arrShoppingCart, *arrDatabaseCart,*arrQuantity;
	NSMutableArray *arrTempShippingCountries;
	UITableView *tableView,*tblStates,*tblCountries;
	UIView *viewFooter;
	
	int selectedQuantity;
	NSInteger iTagOfCurrentQuantityBtn, iTagOfCurrentQuantityLabel;
	UIActionSheet *actionSheetForPicker;
	BOOL isLoadingTableFooter2ndTime;
	UIPickerView *pickerViewQuantity;
	
	NSDictionary *dictTaxAndShippingDetails,*dictSettingsDetails;
	UIAlertView *alertLogin;
	UILabel *lblSubTotalFooter,*lblGrandTotalFooter,*lblTax,*lblShippingCharges,*lblShippingTax;
	UILabel *lblCountryName,*lblStateName;
	NSMutableArray *interDict;
	int	countryID;
	UIView *rightContentView;
	NSMutableArray *arrCountries,*arrStates,*arrInfoAccount;
	BOOL isEditing;
}
-(void)viewForFooter;
-(void)setRightContentView;
-(void)createTableView;
-(void)reloadMe;
-(void)checkoutMethod;
@end
