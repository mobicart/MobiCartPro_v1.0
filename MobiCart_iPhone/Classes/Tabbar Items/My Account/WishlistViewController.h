//
//  WishlistViewController.h
//  MobiCart
//
//  Created by Mobicart on 7/26/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsViewController.h"

BOOL isWishlist_TableStyle;

@interface WishlistViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>
{
    UIView *viewForLogin;
	UIView *viewForRegistration;
	UIView *contentView;
	
	UITableView *tableView;
	
	NSMutableArray *showWishlistArray;
	NSMutableArray *arrWishlist;
	
	UITextField *txtEmailForLogin;
	UITextField *txtPasswordForLogin;
	
    UIImageView *imgRatingsTemp[5], *imgRatings[5];
	UIView *viewRatingBG[5];
    
	DetailsViewController *objDetails;
	BOOL isComingSoonChecked;
    
}


@property (nonatomic, retain) UIAlertView *alertMain;

- (void)createTableView;
- (void)showView;

@end
