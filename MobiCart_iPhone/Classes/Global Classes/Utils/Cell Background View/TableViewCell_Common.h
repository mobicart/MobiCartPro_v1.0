//
//  TableViewCell_Common.h
//  MobiCart
//
//  Created by Mobicart on 12/08/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "CustomCellBackgroundView.h"

extern BOOL isWishlist_TableStyle;
extern BOOL isShoppingCart_TableStyle;


@interface TableViewCell_Common : UITableViewCell 
{
	UILabel *cellProductName, *cellProductPrice, *cellProductDiscount;
	UIImageView *cellProductImage,*cellProductAvailablity;
	
	// For News and Twitter Section
	UILabel *lblFeedTitle, *lblFeedTime, *lblStatus;
	BOOL isTaxbale;
}
@property(readwrite)BOOL isTaxbale;

// Product Layout for Store

- (id)initWithStyleFor_Store_ProductView:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setProductName:(NSString*)productName:(NSString *)productPrice: (NSString *)availability: (NSString *)discount: (UIImage*)imageName;
- (void)setFeeds:(NSString *)strFeedTitle dateAndTime:(NSString *)strTime withImage:(UIImage *) cellImage;


#pragma mark - Ratings and Reviews View
- (id)initWithRatingsAndReviewStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setPosition:(CustomCellBackgroundViewPosition)newPosition;	
													  
@end
