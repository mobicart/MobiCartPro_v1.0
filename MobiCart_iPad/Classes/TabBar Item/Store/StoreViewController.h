//
//  StoreViewController.h
//  Mobicart
//
//  Created by Mobicart on 05/03/11.
//  Copyright Mobicart All rights reserved.
//



#import <UIKit/UIKit.h>
#import "SegmentControl_Customized.h"
#import "DepartmentListingViewController.h"
#import "Constants.h"
#import "AppRecord.h"
#include "LeavesView.h"
#import "Utilities.h"
@class StoreViewController;
@class LeavesView;

BOOL isWishlist_TableStyle;   
BOOL isShoppingCart_TableStyle;   
BOOL isFeaturedProductWithoutCatogery;
BOOL isCatogeryEmpty;
extern NSString *selectedDepartment;
extern NSUInteger currentPageIndex;
UIView *contentView;
UIScrollView *contentScrollView;

StoreViewController *objStoreView;
NSMutableArray *arrSearch;

int lastPageIndex;
int startIndex;
LeavesView *leavesView;
#import "MobicartAppDelegate.h"
@interface StoreViewController : UIViewController<UISearchBarDelegate,UIPopoverControllerDelegate,LeavesViewDelegate,LeavesViewDataSource,UINavigationControllerDelegate,UITabBarControllerDelegate> {
	
	UITableView *tableView;
	NSMutableArray *showArray;

	NSMutableArray *showNoArray, *arrCategoryIDs;
	UISearchBar *_searchBar,*productSearchBar;
	int selectedRow;
	
	NSMutableArray *showArray_Searched,*showNoArray_Searched,*arrCategoryIDs_Searched,*arrAppRecordsAllEntries;
	NSArray *arrAllData;
    
    //NSMutableArray *arrAllData;
	
	UIActivityIndicatorView *indicator;
	SegmentControl_Customized *sortSegCtrl;
	UIImageView *imgRatingsTemp[5], *imgRatings[5];
	UIView *viewRatingBG[5],*tempView;
	NSArray *images;
	UILabel *lblCart;
	UIImageView *imgNextPage, *imgPrePage;
	NSSortDescriptor *nameDescriptor,*priceDescriptor,*statusDescriptor;
	BOOL isComingFromHomePage;
	BOOL isProductWithoutSubCategory;
	UIPopoverController *popOverController;
	UILabel *lblDepartmetsName;
	UIButton *	btnProductImage,*btnDept;
	int firstPageIndex;
	BOOL isBack;
	CALayer *mainLayer;
	UIButton *	btnCart;
}
@property(readwrite) int selectedRow;
@property (nonatomic, retain) NSMutableArray *arrAppRecordsAllEntries;
@property(nonatomic,readwrite)BOOL isComingFromHomePage;
@property(nonatomic,readwrite)BOOL isProductWithoutSubCategory;
@property(nonatomic,retain)	UIPopoverController *popOverController;
@property(nonatomic,retain)	UIImageView *imgNextPage;
@property(nonatomic,retain)	UIImageView *imgPrePage;
@property(nonatomic,retain) UIButton *	btnProductImage;
@property(readwrite)int firstPageIndex;
@property(assign)BOOL isBack;
-(void)createSubViewsAndControls;
-(void)createBasicControls;
-(void)fetchDataFromServer;
-(void)allocateMemoryToObjects;
-(void)loadStart:(int)intValue;
-(void)markStarRating:(UIView *)_scrollView:(int)index;
@end


