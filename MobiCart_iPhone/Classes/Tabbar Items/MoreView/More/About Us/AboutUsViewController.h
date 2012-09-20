//
//  AboutUsViewController.h
//  MobiCart
//
//  Created by Mobicart on 7/6/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutUsViewController : UIViewController <UIWebViewDelegate>
{
	UILabel *aboutDetailLblText;
    UIWebView *aboutDetailLbl;
	NSArray *arrAllData;
	UIScrollView *contentScrollView;
}

@end
