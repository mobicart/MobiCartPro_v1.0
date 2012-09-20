//
//  TermsViewController.h
//  Mobicart
//
//  Created by Mobicart on 05/03/11.
//  Copyright Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
extern UIViewController * nextController;
@interface TermsViewController : UIViewController<UIWebViewDelegate> {
	UILabel *aboutDetailLbl;
    UIWebView *aboutDetailLbltext;
	NSArray *arrAllData;
	UIScrollView *contentScrollView;
	UILabel *lblCart;
}

@end
