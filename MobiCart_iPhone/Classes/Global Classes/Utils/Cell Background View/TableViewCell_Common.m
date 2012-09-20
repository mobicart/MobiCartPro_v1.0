//
//  TableViewCell_Common.m
//  MobiCart
//
//  Created by Mobicart on 12/08/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import "TableViewCell_Common.h"


@implementation TableViewCell_Common
@synthesize isTaxbale;
#pragma mark -
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
    {
        // Initialization code
		lblFeedTitle = [[UILabel alloc] initWithFrame:CGRectMake(80,5,200,40)];
		lblFeedTitle.backgroundColor=[UIColor clearColor];
		lblFeedTitle.textColor=_savedPreferences.headerColor;
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
// Product Layout for Store

#define _TAGproductImage 1
#define productName_TAG 2
#define productPrice_TAG 3
#define productAvailablity_TAG 4
#define productDiscount_TAG 5


- (id)initWithStyleFor_Store_ProductView:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
    {
        // Initialization code
		if(!isShoppingCart_TableStyle &&!isWishlist_TableStyle)
		{
		
		UIImageView *imgPlaceHolder=[[UIImageView alloc]initWithFrame:CGRectMake(0,9, 68, 67)];
		[imgPlaceHolder setImage:[UIImage imageNamed:@"product_list_ph.png"]];
		[self.contentView addSubview:imgPlaceHolder];
		
		cellProductImage=[[UIImageView alloc]initWithFrame:CGRectMake(0 ,0, 60, 65)];
		[cellProductImage setBackgroundColor:[UIColor clearColor]];
		[imgPlaceHolder addSubview:cellProductImage];
		[imgPlaceHolder release];
		}
		if (isShoppingCart_TableStyle)
		{
			cellProductName = [[UILabel alloc]initWithFrame:CGRectMake(85,4.5, 200, 20)];
			//[cellProductName setBackgroundColor:[UIColor redColor]];
			cellProductName.lineBreakMode = UILineBreakModeTailTruncation;
		}
		else
		{
			cellProductName =[[UILabel alloc]initWithFrame:CGRectMake(85,10, 200, 20)];
			cellProductName.lineBreakMode = UILineBreakModeWordWrap;
		}
		cellProductName.backgroundColor=[UIColor clearColor];
		[cellProductName setTextAlignment:UITextAlignmentLeft];
		cellProductName.textColor=_savedPreferences.headerColor;
		//[cellProductName setNumberOfLines:0];
		cellProductName.lineBreakMode=UILineBreakModeTailTruncation;
		[cellProductName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
		if(isShoppingCart_TableStyle||isWishlist_TableStyle)
		{
			[self addSubview:cellProductName];
		}		
		else
		{
			[self.contentView addSubview:cellProductName];
		}
		
		cellProductName.tag = productName_TAG;
		
		if (isShoppingCart_TableStyle)
		{
			cellProductPrice = [[UILabel alloc]initWithFrame:CGRectMake(85, 25, 150, 20)];
			cellProductPrice.textColor=_savedPreferences.labelColor;
			cellProductPrice.font =[UIFont fontWithName:@"Helvetica-Bold" size:14];
			
		}
        else
		{
			cellProductPrice = [[UILabel alloc]initWithFrame:CGRectMake(85,31
																		, 200
																		, 20)];
			
			cellProductPrice.textColor=_savedPreferences.labelColor;
		    [cellProductPrice setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
		}
			
		cellProductPrice.backgroundColor=[UIColor clearColor];
		[cellProductPrice setTextAlignment:UITextAlignmentLeft];
	
		[cellProductPrice setNumberOfLines:0];
		cellProductPrice.lineBreakMode = UILineBreakModeTailTruncation;
		if(isShoppingCart_TableStyle||isWishlist_TableStyle)
			[self addSubview:cellProductPrice];
		else
			[self.contentView addSubview:cellProductPrice];
	
		cellProductPrice.tag= productPrice_TAG;
		
		if (isShoppingCart_TableStyle)
		{
			cellProductAvailablity = [[UIImageView alloc]initWithFrame:CGRectMake(225, 22, 63, 17)];
			lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(225, 21, 63, 17)];
			//[lblStatus setBackgroundColor:[UIColor redColor]];
		}
		else
		{
			cellProductAvailablity=[[UIImageView alloc]initWithFrame:CGRectMake(83, 58, 63, 17)];
			lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(83, 57, 63, 17)];
			//[lblStatus setBackgroundColor:[UIColor redColor]];
		}
        
		[lblStatus setBackgroundColor:[UIColor clearColor]];
		[lblStatus setTextColor:[UIColor whiteColor]];
		[lblStatus setTextAlignment:UITextAlignmentCenter];
		[lblStatus setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10]];		
		cellProductAvailablity.backgroundColor=[UIColor clearColor];		
		if (!(isShoppingCart_TableStyle||isWishlist_TableStyle))
        {
            [self.contentView addSubview:cellProductAvailablity];
        }
			
		cellProductAvailablity.tag = productAvailablity_TAG;
		
		if (isShoppingCart_TableStyle)
        {
            cellProductDiscount = [[UILabel alloc]initWithFrame:CGRectMake(70, 45, 100, 20)];
        }
		else
        {
			cellProductDiscount = [[UILabel alloc]initWithFrame:CGRectMake(cellProductPrice.frame.size.width+cellProductPrice.frame.origin.x+5,31,40, 20)];
		}
					
		cellProductDiscount.backgroundColor=[UIColor clearColor];
		cellProductDiscount.textColor=_savedPreferences.labelColor;
		[cellProductDiscount setNumberOfLines:0];
		cellProductDiscount.lineBreakMode = UILineBreakModeTailTruncation;
		[cellProductDiscount setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
       if(!(isShoppingCart_TableStyle||isWishlist_TableStyle))
	   {
		[self.contentView addSubview:cellProductAvailablity];
		   [self.contentView addSubview:lblStatus];
		[self.contentView addSubview:cellProductDiscount];
	   }
		else {
			[self addSubview:cellProductAvailablity];
			[self addSubview:lblStatus];
			[self addSubview:cellProductDiscount];
		}

		   cellProductDiscount.tag = productDiscount_TAG;
    }
    return self;
}

- (void)setProductName:(NSString*)productName:(NSString *)productPrice: (NSString *)availability: (NSString *)discount: (UIImage*)imageName
{
    if (![productName isEqual:[NSNull null]])
    {
		cellProductName.text = productName;
    }    
    
	if (![productPrice isEqual:[NSNull null]])
	{
	
	cellProductPrice.text =[NSString stringWithFormat:@"%@", productPrice];
	}
    
	if(!isShoppingCart_TableStyle&&!isWishlist_TableStyle)
	{
		//int imageX=imageName.size.width;
      //  int imageY=imageName.size.height;
        
        int y=(67-imageName.size.height/2)/2+4.5;
		int x=(67-imageName.size.width/2)/2+4.5;
		if (![imageName isEqual:[NSNull null]])
		{
			[cellProductImage setFrame:CGRectMake(x, y, imageName.size.width/2-10, imageName.size.height/2-10)];
			cellProductImage.image=imageName;
		}
	}
	

	if (![availability isEqual:[NSNull null]])
    {
		if ([availability isEqualToString:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.comming.soon"]])
        {
		    [cellProductAvailablity setFrame:CGRectMake(83,57, 85, 17) ];
			CGRect frameLbl=[lblStatus frame];
			frameLbl.size.width=85;
			[lblStatus setFrame:frameLbl];
	        [cellProductAvailablity setImage:[UIImage imageNamed:@"coming_soon.png"]];
			[lblStatus setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.comming.soon"]];
	    }
        else if ([availability isEqualToString:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.instock"]])
        {
			[cellProductAvailablity setImage:[UIImage imageNamed:@"instock_btn.png"]];
			[lblStatus setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.instock"]];
		}
		else if ([availability isEqualToString:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]])
		{
			[cellProductAvailablity setImage:[UIImage imageNamed:@"sold_out.png"]];
			[lblStatus setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.wishlist.soldout"]];
		}
		
		
	}

	if ((![discount isEqual:[NSNull null]]) && (![discount isEqualToString:@"<null>"]) && ([discount length]!=0))
    {
		//CGSize size = [productPrice sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
		CGSize size=[productPrice sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:13] constrainedToSize:CGSizeMake(100000,20) lineBreakMode:UILineBreakModeWordWrap];
		if(size.width>80)
		  [cellProductPrice setFrame:CGRectMake(85, 31,80,20)];
		else
			[cellProductPrice setFrame:CGRectMake(85, 31, size.width,20)];
		[cellProductDiscount setFrame:CGRectMake(cellProductPrice.frame.origin.x+cellProductPrice.frame.size.width+10,31,175
												 -cellProductPrice.frame.origin.x+cellProductPrice.frame.size.width+10,20)];
		cellProductDiscount.text = [NSString stringWithFormat:@"%@%@",_savedPreferences.strCurrencySymbol , discount];
		
		
		
    }
	
	
}

#pragma mark -

#pragma mark - Ratings & Reviews Table View Cell 
- (id)initWithRatingsAndReviewStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code.
		self.backgroundView = [[[CustomCellBackgroundView alloc] initWithFrame:CGRectZero] autorelease];
    }
    return self;
	
}
#pragma mark -

#pragma mark  News Feed 
- (void)setFeeds:(NSString *)strFeedTitle dateAndTime:(NSString *)strTime withImage:(UIImage *) cellImage
{
	lblFeedTitle.text = strFeedTitle;
	lblFeedTime.text = strTime;
	self.imageView.image = cellImage;
	
}

- (void)setPosition:(CustomCellBackgroundViewPosition)newPosition 
{	
    [(CustomCellBackgroundView *)self.backgroundView setPosition:newPosition];
}

#pragma mark -

- (void)dealloc
{
	if(cellProductImage)
	  [cellProductImage release];
	[cellProductDiscount release];
	[cellProductName release];
	[cellProductPrice release];
	[cellProductAvailablity release];
	
    [super dealloc];
}


@end
