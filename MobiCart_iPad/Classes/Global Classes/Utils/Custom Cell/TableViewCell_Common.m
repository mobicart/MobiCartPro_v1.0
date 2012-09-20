//
//  TableViewCell_Common.m
//  MobiCart
//
//  Created by mobicart on 12/08/10.
//  Copyright mobicart. All rights reserved.
//

#import "TableViewCell_Common.h"
#import <QuartzCore/QuartzCore.h>

@implementation TableViewCell_Common
@synthesize isTaxbale;
#pragma mark -
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		
		lblFeedTitle = [[UILabel alloc] initWithFrame:CGRectMake(80,5,200,40)];
		lblFeedTitle.backgroundColor=[UIColor clearColor];
		lblFeedTitle.textColor=subHeadingColor;
		[lblFeedTitle setFont:[UIFont systemFontOfSize:14]];
		[lblFeedTitle setLineBreakMode:UILineBreakModeWordWrap];
		[lblFeedTitle setNumberOfLines:2];
		[self.contentView addSubview:lblFeedTitle];
		
		
        lblFeedTime = [[UILabel alloc]initWithFrame:CGRectMake(80,40,200,40)];
		lblFeedTime.backgroundColor=[UIColor clearColor];
		[lblFeedTime setFont:[UIFont systemFontOfSize:12]];
		[lblFeedTime setLineBreakMode:UILineBreakModeWordWrap];
		[lblFeedTime setNumberOfLines:2];
		[self.contentView addSubview:lblFeedTime];
		
		
		
    } 
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}
#pragma mark Layout for Store --> Product
//Layout For Store--->Product

#define _TAGproductImage 1
#define productName_TAG 2
#define productPrice_TAG 3
#define productAvailablity_TAG 4
#define productDiscount_TAG 5


- (id)initWithStyleFor_Store_ProductView:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		
		cellProductName = [[UILabel alloc]initWithFrame:CGRectMake(107, 10, 180, 20)];
		cellProductName.lineBreakMode = UILineBreakModeTailTruncation;
		
		cellProductName.backgroundColor=[UIColor clearColor];
		[cellProductName setTextAlignment:UITextAlignmentLeft];
		cellProductName.textColor=subHeadingColor;
		[cellProductName setNumberOfLines:0];
		cellProductName.lineBreakMode=UILineBreakModeTailTruncation;
		[cellProductName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
		[self addSubview:cellProductName];
		cellProductName.tag = productName_TAG;
		cellProductPrice = [[UILabel alloc]initWithFrame:CGRectMake(107, 25, 120, 20)];
		
		
		cellProductPrice.backgroundColor=[UIColor clearColor];
		[cellProductPrice setTextAlignment:UITextAlignmentLeft];
		cellProductPrice.textColor=labelColor;
		[cellProductPrice setNumberOfLines:0];
		cellProductPrice.lineBreakMode = UILineBreakModeTailTruncation;
		[cellProductPrice setFont:[UIFont fontWithName:@"Helvetica" size:12]];
		
		[self addSubview:cellProductPrice];
		cellProductPrice.tag= productPrice_TAG;
		
		if(isShoppingCart_TableStyle || isWishlist_TableStyle)
		{
			cellProductAvailablity=[[UIImageView alloc]initWithFrame:CGRectMake(225, 20, 63, 17)];
			lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(225, 20, 63, 17)];
			
		}
		else
		{
            cellProductAvailablity=[[UIImageView alloc]initWithFrame:CGRectMake(220, 30
																				, 73, 17)];
			lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(220, 30
																  , 73, 17)];
			
		}
		[lblStatus setBackgroundColor:[UIColor clearColor]];
		[lblStatus setTextColor:[UIColor whiteColor]];
		[lblStatus setTextAlignment:UITextAlignmentCenter];
		[lblStatus setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10]];
		
		
		cellProductAvailablity.backgroundColor=[UIColor clearColor];
		
		cellProductAvailablity.tag = productAvailablity_TAG;
		
		cellProductDiscount = [[UILabel alloc]initWithFrame:CGRectMake(cellProductPrice.frame.size.width+cellProductPrice.frame.origin.x+1
																	   , 25, 120, 20)];
		
		cellProductDiscount.backgroundColor=[UIColor clearColor];
		cellProductDiscount.textColor=subHeadingColor;
		[cellProductDiscount setNumberOfLines:0];
		cellProductDiscount.lineBreakMode = UILineBreakModeTailTruncation;
		[cellProductDiscount setFont:[UIFont fontWithName:@"Helvetica" size:12]];
		
		
        [self addSubview:cellProductAvailablity];
		[self addSubview:cellProductDiscount];
		[self addSubview:lblStatus]; 
		
		cellProductDiscount.tag = productDiscount_TAG;
		
    }
    return self;
}

- (void) setProductName:(NSString*)productName:(NSString *)productPrice: (NSString *)availability: (NSString *)discount
{		
    if(![productName isEqual:[NSNull null]])
    {
		cellProductName.text = productName;
    }    
	if(![productPrice isEqual:[NSNull null]])
	{
		
		cellProductPrice.text =[NSString stringWithFormat:@"%@", productPrice];
		
		
	}
	
	if(![availability isEqual:[NSNull null]])
    {
       	if ([availability isEqualToString:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.comming.soon"]])
        {
			[cellProductAvailablity setFrame:CGRectMake(325,25, 81, 16) ];
			[lblStatus setFrame:CGRectMake(325,25, 81, 16) ];
			[cellProductAvailablity setImage:[UIImage imageNamed:@"coming_soon.png"]];
			[lblStatus setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.comming.soon"]];
	    }
        else if ([availability isEqualToString:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.instock"]])
        {
			[cellProductAvailablity setFrame:CGRectMake(345,25, 59, 16) ];
			[lblStatus setFrame:CGRectMake(345,25, 59, 16) ];
			[cellProductAvailablity setImage:[UIImage imageNamed:@"instock_btn.png"]];
			[lblStatus setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.instock"]];
        }
		else if ([availability isEqualToString:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]])
		{
			[cellProductAvailablity setFrame:CGRectMake(345,25, 59, 16) ];
			[lblStatus setFrame:CGRectMake(345,25, 59, 16) ];
			[cellProductAvailablity setImage:[UIImage imageNamed:@"sold_out.png"]];
			[lblStatus setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
		}
		
		
	}
	
	
	if((![discount isEqual:[NSNull null]]) && (![discount isEqualToString:@"<null>"]) && ([discount length]!=0)){
		cellProductPrice.text = [NSString stringWithFormat:@"%@%@",_savedPreferences.strCurrencySymbol , discount ];
    }
        
}

#pragma mark -

#pragma mark - Ratings & Reviews Table View Cell 
- (id)initWithRatingsAndReviewStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		
    }
    return self;
	
}
#pragma mark -

#pragma mark  News Feed 
-(void)setFeeds:(NSString *)strFeedTitle dateAndTime:(NSString *)strTime withImage:(UIImage *) cellImage
{
	lblFeedTitle.text = strFeedTitle;
	lblFeedTime.text = strTime;
	self.imageView.image = cellImage;
	
}

#pragma mark -

- (void)dealloc {
	[cellProductImage release];
	[cellProductDiscount release];
	[cellProductName release];
	[cellProductPrice release];
	[cellProductAvailablity release];
	
    [super dealloc];
}


@end
