//
//  OrderHistroyViewController.h
//  MobiCart
//
//  Created by Mobicart on 7/28/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrderHistroyViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
	UIView *contentView;
	UITableView *tableView;
	NSArray *arrAllOrderHistory;
}


@property (nonatomic, retain) NSArray *arrAllOrderHistory;
- (void)createTableView;


@end
