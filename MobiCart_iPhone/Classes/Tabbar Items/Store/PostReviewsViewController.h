//
//  PostReviewsViewController.h
//  MobicartApp
//
//  Created by Mobicart on 12/17/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
BOOL isPostReviews;
@interface PostReviewsViewController : UIViewController <UITextViewDelegate>{

	int productId;
	int previousTag;
}

@property (readwrite) int productId;

-(NSString *) sendDataToServer:(NSURL *)_url withData:(NSString *)strDataToPost;
- (void)cancelMethod;

@end
