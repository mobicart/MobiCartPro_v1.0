//
//  TermsViewController.h
//  MobicartApp
//
//  Created by Mobicart on 04/11/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TermsViewController : UIViewController<UIWebViewDelegate> {
    UILabel * lbleTxt;
	UIWebView *aboutDetailLbl;
	NSArray *arrAllData;
	UIScrollView *contentScrollView;
}

@end
