//
//  ProductViewController.h
//  MobiCart
//
//  Created by Mobicart on 8/4/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "IconDownloader.h"
#import "AppRecord.h"
extern BOOL isCatogeryEmpty;

@interface ProductViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIScrollViewDelegate,IconDownloaderDelegate>{

	UIView *contentView;
	UITableView *tableView;
	UISearchBar *_searchBar;
	
	
	NSArray *arrAllData; 
	NSMutableDictionary *dictProductNames;
	
	NSSortDescriptor *nameDescriptor,*priceDescriptor,*statusDescriptor;
	NSMutableDictionary *dict;
	NSMutableArray* arrSearch;
	NSString *sTaxType;
	
	NSMutableArray *arrAppRecordsAllEntries;
	NSMutableDictionary *imageDownloadsInProgress; 
	
	NSMutableArray *arrTempProducts;
	UIImageView *imgRatingsTemp[5], *imgRatings[5];
	UIView *viewRatingBG[5];
	UIButton *btnStore;
}

@property (nonatomic, retain) NSMutableArray *arrAppRecordsAllEntries;
@property (nonatomic, retain) NSString *sTaxType;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) NSMutableArray *arrTempProducts;


- (void)markStarRating:(UITableViewCell *)cell:(int)index;
- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath;
- (void)appImageDidLoad:(NSIndexPath *)indexPath;

- (void)createSubViewsAndControls;
- (void)createTableView;
- (void)allocateMemoryToObjects;
- (void)sortingHandlers;



- (void)fetchDataFromServer;

@end
