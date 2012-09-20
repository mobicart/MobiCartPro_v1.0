//
//  NewsViewController.h
//  MobiCart
//
//  Created by Mobicart on 7/6/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import "IconDownloader.h"

@class CustomMobicartParser;

BOOL isSortShown;
BOOL isTwitterSelected;

NSMutableArray *stories;
UITableView *tblNews,*tblTweets;

extern BOOL isNewsSection;

@interface NewsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,IconDownloaderDelegate> 
{
	UIView *contentView,*sortView;
	UIView *viewLoading;
	UILabel *lblNews;
	UISearchBar *_searchBar;
	NSArray *arrNews;
	NSMutableData *webData;
	NSXMLParser *rssParser;
	NSMutableArray *News,*Twitter;
	NSMutableDictionary * item;
	NSString * currentElement;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink;
	UILabel *lblCart;
	NSArray *arrayData;
	
	NSMutableArray *arrSearch;
	UILabel *noItemLbl;
    
    UIImageView *imgSegmentControllerStatus;
    UILabel *lblSegmentControllerSelected;
	
	NSMutableArray *arrTwitter, *arrAppRecordsAllEntries,*arrEntriesCount, *arrCountTweets;
	UIFont *font,*font1;
	
	NSMutableDictionary *imageDownloadsInProgress; 
	BOOL isSearchClicked;
}

@property (nonatomic, retain) NSMutableArray *arrTwitter;
@property (nonatomic, retain) NSMutableArray *arrAppRecordsAllEntries;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath;
- (void)appImageDidLoad:(NSIndexPath *)indexPath;
- (void)createSegmentCtrl;
- (void)parseXMLFileAtURL:(NSString *)URL;
- (void)fetchDataFromTwitter;
- (void)fetchDataFromServer;
+(void)reloadTableWithArray:(NSArray *)_arrTemp;
+(void)errorOccuredWhileParsing:(NSString *)_error;
- (void)setTextColors:(id)sender;

@end
