//
//  ReadReviews.h
//  
//
//  Created by Mobicart on 09/05/11.
//  Copyright Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsViewController.h"

@interface ReadReviews : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate> {

	UIView *contentView;	
	UITableView *tblReviews;
    UIFont *font;
    UILabel *lblReviewCount;
    UIImageView *imgRatingsTempMain[5], *imgRatingsMain[5];
	UIView *viewRatingBGMain[5];
    int selectedProductId;
	NSMutableArray *yValue;
	NSArray *arrReviews;
	UILabel *lblProductName;
	UIView *viewForPostReview;
	UIView *starratingView;
    DetailsViewController *objDetails;
	UIView *viewforAccount;
	UIButton *btnShowPostReview;
	UILabel *lblNoReview, *lblCart;
}
@property (readwrite) int selectedProductId;
-(void)createRatingView;
@end
