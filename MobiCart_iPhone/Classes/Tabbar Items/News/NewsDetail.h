//
//  NewsDetail.h
//  MobiCart
//
//  Created by Mobicart on 04/08/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsDetail : UIViewController <UIWebViewDelegate>{

	NSString *strNewsDetail;
	NSString *strNewsTitle;
	NSString *strNewsDate;
}
@property(nonatomic,retain) NSString *strNewsDetail;
@property(nonatomic,retain) NSString *strNewsTitle;
@property(nonatomic,retain) NSString *strNewsDate;

@end
