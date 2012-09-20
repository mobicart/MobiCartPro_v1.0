//
//  DepartmentListingViewController.h
//  Mobicart
//
//  Created by Mobicart on 16/05/11.
//  Copyright 2011 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreViewController.h"
@class StoreViewController;

@interface DepartmentListingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{

		
	UIView *contentView;
	UIButton *btnBackToDepts,*btnBackToAllDepts;
    NSArray *arrSubDepts;
    NSMutableArray* arrDepartmentData;
	NSMutableArray *arrSubDepartments,*arrSubDepatermentsSearch,*arrSubDeptID,*arrSubDeptID_Search,*arrNumofProducts,*arrNumofProductsSearch;
	UITableView*tblSubDepts,*tblDepts;
	NSMutableArray *showArray,*arrSubDepts_Search;
	NSMutableArray *showNoArray, *arrDeptIDs, *showArray_Searched, *showNoArray_Searched, *arrDeptIDs_Searched,*arrNumberofProducts,*arrNumberofProducts_Search,*arrSubDeptName_Search;
	BOOL isDepartmentsTable;
}
-(void)allocateMemoryToObjects;
-(void)createTableView;
-(void)createSubDeptsTable;
-(void)fetchDataForDepartments;
@end
