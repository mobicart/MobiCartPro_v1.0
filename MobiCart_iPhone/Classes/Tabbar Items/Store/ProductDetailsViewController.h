//
//  ProductDetailsViewController.h
//  MobiCart
//
//  Created by Mobicart on 8/7/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
UIActionSheet *loadingActionSheet1;

NSArray *optionArray;
UIActionSheet *loadingActionSheet;
@interface ProductDetailsViewController : UIViewController <UISearchBarDelegate,UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate> 
{
	UIView *contentView;
	UIScrollView *scrollProductImg;
	UIScrollView *contentScrollView;

	UITableView *optionTableView;
	UIAlertView *theAlert1;
	
	UIImageView *productImg;
	
	UIButton *btnCloseZoom;
	UIButton *addToWishBtn;
	
	NSDictionary *dicProduct;
	UIImageView *imgZoom;
	UIButton *btnZoom;
	
	BOOL isWishlist;
	BOOL shouldNavigateToWriteReview;
	NSString *optionIndex;
	BOOL FeaturedProductFromHomePage;
	UIView *viewForAnimationEffect;
	NSData *dataForProductImage;
	
	UILabel *lblStock;
	NSTimer *imgTimer;
	
	NSInteger iSelectedProductSize_Index; //To be used, when saving the required info in the DB (ADD to cart Method)

	NSInteger iCurrentThumbnailNum;
	UIButton *btnLeftArrow,*btnRightArrow;
	
	UIButton *addToCartBtn;
	
	UIImageView *zoomProduct, *whiteView;
	
	int startX,	startY,	currentX, currentY;
	
	UIImageView *imgRatingsTemp[5], *imgRatings[5];
	UIView *viewRatingBG[5];
	UILabel *lblReadReviews;
	NSArray *arrDropDownTable;
	UIImageView *imgStock;
	UIButton *optionBtn[100];
	UILabel *lblOption[100];
	NSMutableArray *arrDropDown[100];
	NSString *strTitle;
	int dropDownCount;
	NSMutableArray *arrAddedToCartList;
	int pastIndex;
	int index;
	int selectedIndex[100];
	NSMutableArray *wishlistSelectedIndex;
	BOOL loadingStatus;
	BOOL resetIndex;
	BOOL imageCheck;
	BOOL isComingSoonCheck;
	UILabel *lblImgStock;
    UILabel *lblProductPrice;
    UILabel *lblProductDiscount;
}

@property (nonatomic, retain) NSDictionary *dicProduct;
@property (readwrite) BOOL isWishlist;
@property (nonatomic,retain) NSString *optionIndex;

- (void)allocateMemoryToObjects;
- (void)dataValidationChecks;
- (void)createBasicControls;
- (void)createTableView;
- (void)getOptionTable;
- (void)newEmailTo:(NSArray*)theToRecepients withSubject:(NSString*)theSubject body:(NSString*)theEmailBody;
- (void)displayProductImage:(NSArray *)arrImagesUrls picToShowAtAIndex:(NSInteger)_picNum willZoom:(NSNumber *)isHandlingZoomImage;
- (void)previousImage;
- (void)nextImage;
- (void)previousImageSwap;
- (void)nextImageSwap;
- (void)markStarRating;
-(void)createDropDowns;
@end
