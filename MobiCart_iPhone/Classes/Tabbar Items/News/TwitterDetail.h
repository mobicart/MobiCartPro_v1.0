//
//  TwitterDetail.h
//  MobicartApp
//
//  Created by Mobicart on 04/10/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"


@interface TwitterDetail : UIViewController<UIWebViewDelegate>
{
	NSString *strFeedsTitle;
	NSString *strFeedsDetail;
	NSString *strFeedsDate;
	NSString *strFeedsDetail1;
	NSString *strImagePath;
    UIWebView *lblNewsDetail;
}

@property(nonatomic,retain) NSString *strFeedsTitle;
@property(nonatomic,retain) NSString *strFeedsDetail;
@property(nonatomic,retain)	NSString *strFeedsDate;
@end
