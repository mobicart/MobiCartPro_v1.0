//
//  AboutUsViewController.h
//  Mobicart
//
//  Created by Mobicart on 05/03/11.
//  Copyright Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>

extern BOOL isMorePage;
extern int checkTab;
extern UIViewController * nextController;
@interface AboutUsViewController : UIViewController<UIWebViewDelegate> {
	UILabel *aboutDetailLbl;
    UIWebView *aboutDetailLbltext;
	NSArray *arrAllData;
	UIScrollView *contentScrollView;
	UILabel *lblCart;
    UIActionSheet *loadingActionSheet1;
}

@end
