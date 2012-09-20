//
//  WishlistViewController.h
//  MobiCart
//
//  Created by Mobicart on 7/26/10.
//  Copyright 2Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsViewController.h"
BOOL isWishlist_TableStyle;

@interface WishlistViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>{
    UIView *viewForLogin,*viewForRegistration;
	UIView *contentView;
	UITableView *tableView;
	NSMutableArray *showWishlistArray, *arrWishlist;
	DetailsViewController *objDetails;
	UITextField *txtEmailForLogin;
	UITextField *txtPasswordForLogin;
    UIImageView *imgRatingsTemp[5], *imgRatings[5];
	UIView *viewRatingBG[5];
	UILabel *lblCart;
}


@property (nonatomic, retain) UIAlertView *alertMain;

-(void)createTableView;
-(void)showView;

@end
