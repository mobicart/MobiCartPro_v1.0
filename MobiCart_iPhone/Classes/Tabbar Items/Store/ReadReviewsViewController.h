//
//  ReadReviewsViewController.h
//  MobicartApp
//
//  Created by Mobicart on 12/17/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
BOOL isReadReviews;
@interface ReadReviewsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
 	int selectedProductId;
	NSArray *arrReviews;
	UIFont *font;
    UILabel *lblProductName;
    UILabel *lblReviewCount;
    UIImageView *imgRatingsTempMain[5], *imgRatingsMain[5];
	UIView *viewRatingBGMain[5];
    int productId;
    NSMutableArray *yValue;   
	UITableView *tblReviews;
}

@property (nonatomic, retain) NSArray *arrReviews;
@property (nonatomic,retain) NSMutableArray *yValue;
@property (readwrite) int selectedProductId;

- (void)hideBar;
@end
