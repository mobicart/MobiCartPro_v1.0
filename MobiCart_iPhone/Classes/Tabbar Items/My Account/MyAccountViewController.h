//
//  MyAccountViewController.h
//  MobiCart
//
//  Created by Mobicart on 7/6/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyAccountViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	UIAlertView *alertMain;
	
	UITableView *tableView;
	
	NSMutableArray *showArray;
	
	UILabel *lblCart;
	UIButton *btnLogout;
	
	UIView *viewWhenAlertViewIsVisible;
	UIView *contentView;
}

- (void)createTableView;

@end
