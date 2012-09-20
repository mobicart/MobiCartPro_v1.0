//
//  AppRecord.h
//  MobicartApp
//
//  Created by mobicart on 10/29/10.
//  Copyright mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppRecord : NSObject
{
    UIImage *appIcon;
   	NSURLRequest *requestImg;
	NSString *tweetSenderName;
	NSString *tweetMsg;
	NSString *tweetDate;
}

@property (nonatomic, retain) UIImage *appIcon;
@property (nonatomic, retain) NSString *tweetSenderName;
@property (nonatomic, retain) NSString *tweetMsg;
@property (nonatomic, retain) NSString *tweetDate;
@property (nonatomic, retain) NSURLRequest *requestImg;

@end
