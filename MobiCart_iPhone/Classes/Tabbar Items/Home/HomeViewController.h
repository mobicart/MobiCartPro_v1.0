//
//  HomeViewController.h
//  MobiCart
//
//  Created by Mobicart on 7/6/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import "Constants.h"
#import "IconDownloader.h"
#import "AppRecord.h"
#import "CustomImageView.h"


UILabel *lblCart;
CustomImageView *backgroundImg;
UIScrollView *ZoomScrollView;
NSMutableArray *arrBanners;
@interface HomeViewController : UIViewController <UISearchBarDelegate,UIScrollViewDelegate>
{
	UIView *contentView;
	UIScrollView *bottomHorizontalView;
	UIButton *btnBlue[300];
	UILabel *lblPrice[300];
	UISearchBar *_searchBar;
	
	NSMutableArray *clothImg;
    NSMutableArray *arrTemp;
	
	int startX;
	int startY;	
	int currentY;
	int currentX;
	
	NSArray *arrAllData;
	NSDictionary *dictFeaturedProducts, *dictBanners;
	
	BOOL isUpdateControlsCalled;
	NSMutableArray *arrAppRecordsAllEntries;
	NSMutableDictionary *imageDownloadsInProgress; 
}

@property (nonatomic, retain) NSMutableArray *arrAppRecordsAllEntries;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) NSDictionary *dictFeaturedProducts;
@property (nonatomic, retain)NSMutableArray *arrTemp;

- (void)fetchBannerImages;
- (void)fetchFeaturedProducts;


@end
