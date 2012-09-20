//
//  AppRecord.h
//  MobicartApp
//
//  Created by Mobicart on 10/29/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppRecord : NSObject
{
    UIImage *appIcon;
	NSString *tweetSenderName;
	NSString *tweetMsg;
    NSURLRequest *requestImg;
}

@property (nonatomic, retain) UIImage *appIcon;
@property (nonatomic, retain) NSString *tweetSenderName;
@property (nonatomic, retain) NSString *tweetMsg;
@property (nonatomic, retain) NSURLRequest *requestImg;

@end
