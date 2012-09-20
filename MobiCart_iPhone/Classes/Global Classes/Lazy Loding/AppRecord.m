//
//  AppRecord.m
//  MobicartApp
//
//  Created by Mobicart on 10/29/10.
//  Copyright 2010 Mobicart. All rights reserved.
//


#import "AppRecord.h"

@implementation AppRecord

@synthesize appIcon;
@synthesize tweetSenderName;
@synthesize tweetMsg;
@synthesize requestImg;

- (void)dealloc
{
    [appIcon release];
	[tweetSenderName release];
	[tweetMsg release];
    [requestImg release];
    
    [super dealloc];
}

@end

