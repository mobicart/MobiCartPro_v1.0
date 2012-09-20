//
//  GlobalSearch.h
//  Mobicart
//
//  Created by Mobicart on 16/05/11.
//  Copyright Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalPrefrences.h"
#import "Constants.h"

@interface GlobalSearch : UIViewController {
	UIView *contentView;
	UITableView *_tableView;
	NSArray *arrSearchedData;
	UIScrollView *	contentScrollView;
	NSString *strProductToSearch;
	UILabel *lblCart;
	UIImageView *imgRatingsTemp[5], *imgRatings[5];
	UIView *viewRatingBG[5];
	
}
@property (nonatomic, retain) NSString *strProductToSearch;
- (id)initWithProductName:(NSString *)productNameToSearch;
-(void)markStarRating:(UIView *)_scrollView:(int)index;
@end
