//
//  TableViewCell_Common.h
//  MobiCart
//
//  Created by Mobicart on 12/08/10.
//  Copyright mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

extern BOOL isWishlist_TableStyle;
extern BOOL isShoppingCart_TableStyle;


@interface TableViewCell_Common : UITableViewCell {
	
	//These controls would be used for Store-->Product Layout
	UILabel *cellProductName, *cellProductPrice, *cellProductDiscount;
	UIImageView *cellProductImage,*cellProductAvailablity;
	
	//For News and Twitter Section
	UILabel *lblFeedTitle, *lblFeedTime, *lblStatus;
	BOOL isTaxbale;
}
@property(readwrite)BOOL isTaxbale;

/***********Store---> Product Layout***********/
- (id)initWithStyleFor_Store_ProductView:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void) setProductName:(NSString*)productName:(NSString *)productPrice: (NSString *)availability: (NSString *)discount;


-(void)setFeeds:(NSString *)strFeedTitle dateAndTime:(NSString *)strTime withImage:(UIImage *) cellImage;


#pragma mark - Ratings and Reviews View
- (id)initWithRatingsAndReviewStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;




@end
