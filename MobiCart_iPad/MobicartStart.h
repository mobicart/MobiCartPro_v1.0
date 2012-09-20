//
//  MobicartStart.h
//  Mobicart
//
//  Created by Mobicart on 05/03/11.
//  Copyright Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>

UIViewController * nextController;

BOOL isNewsSection;
BOOL isMorePage;

int checkTab;
@interface MobicartStart : UIViewController<UINavigationControllerDelegate,UITabBarControllerDelegate,UITabBarDelegate> {
	UITableView *moreTableView;
	NSArray *arrTabbarDetails;
	UIView *detailsView;
	BOOL hideMobicartCopyrightLogo;
	NSString *PAYPAL_SANDBOX_TOKEN_ID, *PAYPAL_LIVE_TOKEN_ID;
	NSString *MOBICART_MERCHANT_EMAIL;
	UIView *viewRight;
    UIImage *imgFooter;
}
@property(nonatomic,retain) UIImage *imgFooter;

//  ********** USE THIS METHOD TO START APP ********* 
+ (id)sharedApplication;

- (id) startMobicartOnMainWindow:(UIWindow *) _window withMerchantEmail:(NSString *)_merchantEmail  Paypal_Live_Token_ID:(NSString *) paypal_Token_Received_From_Paypal ENV_CHECK:(NSString *)ISTOKENENV Merchant_Secret_Key_Of_Store:(NSString*)strMerchant_Secret_Key;
- (void)poweredMobicart;
- (void)removeMobicart;

+(void)tabSettingForAboutUs:(UINavigationController*)_arr;
@end
