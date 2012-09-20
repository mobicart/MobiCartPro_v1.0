//
//  OrderHistroyViewController.h
//  MobiCart
//
//  Copyright Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHistroyViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
	UIView *contentView;
	UITableView *tableView;
	NSArray *arrAllOrderHistory;	
	UILabel *lblCart;
}

@property (nonatomic, retain) NSArray *arrAllOrderHistory;
-(void)createTableView;
-(NSString *)setRequiredFormatForDate:(NSString *)strDate;

@end
