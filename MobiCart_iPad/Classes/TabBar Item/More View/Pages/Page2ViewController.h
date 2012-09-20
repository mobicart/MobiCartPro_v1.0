//
//  Page2ViewController.h
//  Mobicart
//
//  Created by Mobicart on 05/03/11.
//  Copyright Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
extern UIViewController * nextController;
@interface Page2ViewController : UIViewController <UIWebViewDelegate>{
	UILabel *aboutDetailLbl;
	NSArray *arrAllData;
    UIWebView *aboutDetailLbltext;
	UIScrollView *contentScrollView;
	UILabel *aboutLbl;
	UILabel *lblCart;
}

@end
