//
//  Page2ViewController.h
//  MobicartApp
//
//  Created by Mobicart on 11/10/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Page2ViewController : UIViewController<UIWebViewDelegate> {

    UILabel *aboutDetailLblText;
    UIWebView *aboutDetailLbl;

	NSArray *arrAllData;
	UIScrollView *contentScrollView;
}

@end
