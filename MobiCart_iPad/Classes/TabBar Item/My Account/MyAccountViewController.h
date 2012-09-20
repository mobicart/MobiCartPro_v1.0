//
//  MyAccountViewController.h
//  MobiCart
//
//  Copyright Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyAccountViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	UIAlertView *alertMain;	
	UIView *contentView;
	UITableView *tableView;
	NSMutableArray *showArray;
	UIButton *btnLogout;	
	UIView *viewWhenAlertViewIsVisible;	
	UIView *rightContentView, *rightView;
	UILabel *lblCart;
}

-(void)createTableView;
@end
