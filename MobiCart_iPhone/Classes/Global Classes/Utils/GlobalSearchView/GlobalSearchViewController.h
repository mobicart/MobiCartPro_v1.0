//
//  GlobalSearchViewController.h
//  MobicartApp
//
//  Created by Mobicart on 04/10/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlobalSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UIAlertViewDelegate>
{
	UIView *contentView;
	UITableView *_tableView;
	
	NSString *strProductToSearch;
	NSArray *arrSearchedData;
}


@property (nonatomic, retain) NSString *strProductToSearch;
- (void)loadTableView;

// Custom Initializer
- (id)initWithProductName:(NSString *)productNameToSearch;

@end
