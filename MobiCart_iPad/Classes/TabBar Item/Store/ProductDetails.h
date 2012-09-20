//
//  ProductDetails.h
//  Mobicart
//
//  Created by Mobicart on 03/05/11.
//  Copyright Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "Constants.h"
#import "webViewVideo.h"
#import "GlobalSearch.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


NSArray *optionArray,*optionsArrayNextProduct;
extern NSString *selectedDepartment;

@interface ProductDetails : UIViewController<MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
	int productID;
	int nextProductID;
	CGRect newFrame, newFrame2;
	NSDictionary *dicProduct,*dicNextProduct;
	
	NSData *dataForProductImage,*dataForNextProductImage;
	UIImageView *productImg,*productImgNextProduct;
	UIImageView *imgStockStatusCurrentProduct,*imgStockStatusNextProduct;
	UIAlertView *theAlert1;
	
	UIScrollView *currentProductScrollView,*nextProductScrollView;
	UIScrollView *currentDescriptionScrollView, *nextDescriptionScrollView;
	UIView *contentView;
	
	UIImageView *imgRatingsTemp[5],*imgRatingsTemp2[5], *imgRatings[5];
	UIView *viewRatingBG[5];
	UILabel *lblReadReviews,*lblReadReviewsSecond, *lblStatusCurrentProduct, *lblStatusNextProduct;
	int tagForEmail;
	
	BOOL isWishlist;
	NSInteger iSelectedProductSize_Index; //To be used, when saving the required info in the DB (ADD to cart Method)
	UILabel  *lblCart;
	UIView *viewForAnimationEffect;
	UITableView *optionTableView,*optionTableViewNextProduct;
	UIButton *btnAddCurrentProductToCart,*btnAddNextProductToCart;
	
	NSString *optionIndex;
	UIButton *optionBtn[100];
	UILabel *lblOption[100];
	NSArray *arrDropDownTable;
	NSMutableArray *arrDropDown[100];
	int dropDownCount;
    NSString *strTitle;
	int selectedIndex[100];
	int pastIndex;
	int index;
	UISearchBar *_searchBar;
	
	UIButton *optionBtnNext[100];
	UILabel *lblOptionNext[100];
	NSArray *arrDropDownTableNext;
	NSMutableArray *arrDropDownNext[100];
	int dropDownCountNext;
    NSString *strTitleNext;
	int selectedIndexNext[100];
	int pastIndexNext;
	int indexNext;
}
@property (nonatomic,retain) NSString *optionIndex;
@property (readwrite) BOOL isWishlist;
@property(readwrite)int productID;
@property(readwrite)int nextProductID;
@property (nonatomic, retain) NSDictionary *dicProduct;
@property (nonatomic, retain) NSDictionary *dicNextProduct;
@property(nonatomic ,retain)UILabel *lblProductPrice;
@property(nonatomic ,retain)NSString *strPriceCurrentProduct;
@property(nonatomic ,retain)NSString *strPriceNxtProduct;
@property(nonatomic ,retain)UILabel *lblProductPriceSecond;

-(void)createDropDownsNext;
-(void)createDropDowns;
-(void)displayProductImage:(NSArray *)arrImagesUrls picToShowAtAIndex:(NSInteger)_picNum;
-(void)markStarRating_onView:(UIView*)_viewName withTag:(int)_tag;
- (void)newEmailTo:(NSArray*)theToRecepients withSubject:(NSString*)theSubject body:(NSString*)theEmailBody;

@end
