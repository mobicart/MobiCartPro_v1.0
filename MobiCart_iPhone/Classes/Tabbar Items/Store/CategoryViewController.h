//
//  CategoryViewController.h
//  MobiCart
//
//  Created by Mobicart on 8/4/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>

extern BOOL isCatogeryEmpty;

@interface CategoryViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
	UIView *contentView;
	UITableView *tableView;
	NSMutableArray *showArray;
	NSMutableArray *showNoArray, *arrCategoryIDs,*showNoArrayCategories;
	UISearchBar *_searchBar;
	int selectedRow;
	UIButton *btnStore;
	NSMutableArray *showArray_Searched,*showNoArray_Searched,*arrCategoryIDs_Searched,*arrCategoriesCount_Searched;
    int categoryId;
    
}

@property(readwrite) int selectedRow;
@property(readwrite) int categoryId;


- (void)createSubViewsAndControls;
- (void)createTableView;
- (void)fetchDataFromServer;
- (void)allocateMemoryToObjects;

@end
