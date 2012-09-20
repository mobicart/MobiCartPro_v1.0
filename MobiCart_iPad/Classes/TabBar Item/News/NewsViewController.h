//
//  NewsViewController.h
//  MobiCart
//
//  Copyright Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import "IconDownloader.h"
#import "MobicartParser.h"
@class CustomParser;

BOOL isSortShown;

NSMutableArray *stories;
UITableView *tblNews,*tblTweets;

extern BOOL isNewsSection;

@interface NewsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,IconDownloaderDelegate,UIWebViewDelegate> {
	UIWebView *lblNewsDetail;
	UIView *contentView,*sortView;
	UILabel *lblNews;
	NSArray *arrNews;
	NSMutableData *webData;
	NSXMLParser *rssParser;
	NSMutableArray *News,*Twitter;
	NSMutableDictionary * item;
	NSString * currentElement;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink;
	NSArray *arrayData;
	
	NSMutableArray *arrSearch;
	UILabel *noItemLbl;
	
	NSMutableArray *arrTwitter, *arrAppRecordsAllEntries,*arrEntriesCount, *arrCountTweets,*arrTwitterFirstHalf,*arrTwittterSecondHalf;
	UIFont *font,*font1;
	
	NSMutableArray *arrTwitterHalf;
	
	UITableView *tblHalfTwitter;
	UILabel *lblCart;
	
	NSMutableDictionary *imageDownloadsInProgress; 
	BOOL isSearchClicked;
	NSString *strNewsDate;
	NSString *strImagePath;
	NSString *strFeedsDetail1;
	UIView *contentView1;
}

@property (nonatomic, retain) NSMutableArray *arrTwitter;
@property (nonatomic, retain) NSMutableArray *arrAppRecordsAllEntries;

@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
-(NSString *)setRequiredFormatForCurrentDate:(NSDate *)strDate;
-(void)tblTwtDetails: (NSString *)strFeedsTitle :(NSString *)strFeedsDetail :(NSString *)strFeedsDate;
-(void)tblNewsDetails: (NSString *)strNewsTitle :(NSString *)strNewsDetail :(NSString *)str_Date;
- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath;
- (void)startIconDownload1:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath;
-(NSString *)setRequiredFormatForDate:(NSString *)strDate;
-(void)createSegmentCtrl;
-(void)parseXMLFileAtURL:(NSString *)URL;
-(void)fetchDataFromTwitter;
-(void)fetchDataFromServer;
+(void)reloadTableWithArray:(NSArray *)_arrTemp;
+(void)errorOccuredWhileParsing:(NSString *)_error;
-(NSString*)findString:(NSString*)str;
-(NSString *)setRequiredFormatForTweeetDate:(NSString *)strDate;
- (void)appImageDidLoad:(NSIndexPath *)indexPath chkValue:(BOOL)chkForindex;
@end
