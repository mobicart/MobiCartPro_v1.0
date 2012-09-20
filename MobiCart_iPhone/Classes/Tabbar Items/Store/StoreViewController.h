//
//  StoreViewController.h
//  MobiCart
//
//  Created by Mobicart on 7/6/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>

BOOL isCatogeryEmpty;
BOOL isFeaturedProductWithoutCatogery;
int categoryCount;
BOOL isStoreSearch;
@interface StoreViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
	UIView *contentView;
	UITableView *tableView;
	NSMutableArray *showArray;
	NSMutableArray *showNoArray, *arrDeptIDs, *showArray_Searched, *showNoArray_Searched, *arrDeptIDs_Searched,*arrNumberofProducts,*arrNumberofProducts_Search;
	UISearchBar *_searchBar;
	UILabel *lblCart;
}

- (void)createTableView;
- (void)fetchDataFromServer;
- (void)allocateMemoryToObjects;

@end
