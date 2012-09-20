//
//  HomeViewController.h
//  Mobicart
//
//  Created by Mobicart on 05/03/11.
//  Copyright 2011 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "EbookScrollView.h"
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import "ServerAPI.h"
#import "CustomImageView.h"
#import "TaxCalculation.h"
#import <CoreLocation/CoreLocation.h>
UILabel *lblCart;
UIImageView *backgroundImg;
UIScrollView *ZoomScrollView;
NSMutableArray *arrBanners;
NSString *selectedDepartment;

@interface HomeViewController : UIViewController <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,CLLocationManagerDelegate>{
	 CustomImageView *img[7];
	UIView *contentView;  
	UIScrollView *bottomHorizontalView;
	UIButton *btnBlue[200];
	UILabel *lblPrice[200];
	UILabel *lblProductName[200];
	UIButton *btnBackToDepts;
	
	NSMutableArray *clothImg;
	CLLocationCoordinate2D tempLocation;
	int startX;
	int startY;	
	int currentY;
	int currentX;
	NSArray *arrAllData;
    NSMutableArray* arrDepartmentData;
	NSDictionary *dictFeaturedProducts, *dictBanners;
	BOOL isUpdateControlsCalled,isDepartmentsTable;
	
	
	//For lazy loading of featured products
	NSMutableArray *arrAppRecordsAllEntries;
	NSMutableDictionary *imageDownloadsInProgress; 
     NSMutableArray *arrTempImage;
	
	NSArray *arrSubDepts;
	NSMutableArray *arrSubDepartments,*arrSubDepatermentsSearch,*arrSubDeptID,*arrSubDeptID_Search,*arrNumofProducts,*arrNumofProductsSearch;
	UITableView*tblDepts;
	NSMutableArray *showArray,*arrSubDepts_Search;
	NSMutableArray *showNoArray, *arrDeptIDs, *showArray_Searched, *showNoArray_Searched, *arrDeptIDs_Searched,*arrNumberofProducts,*arrNumberofProducts_Search,*arrSubDeptName_Search,*arrSubCategoryCount;
	UISearchBar *_searchBar;
	UIButton *	btnCart;
	
}
@property (nonatomic, retain) NSMutableArray *arrTempImage;
@property (nonatomic, retain) NSMutableArray *arrAppRecordsAllEntries;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) NSMutableDictionary *dictdataFeatures;

-(void)fetchBannerImages;
-(void)fetchFeaturedProducts;
-(void)showDepartments;
-(void)fetchDataForDepartments;
-(void)createTableView;
-(void)createSubDeptsTable;


@end
