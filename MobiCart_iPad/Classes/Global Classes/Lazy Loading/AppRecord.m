//
//  MobicartApp
//
//  Created by mobicart on 10/29/10.
//  Copyright mobicart. All rights reserved.
//


#import "AppRecord.h"

@implementation AppRecord

@synthesize appIcon;
@synthesize tweetSenderName;
@synthesize tweetMsg;
@synthesize tweetDate;
@synthesize requestImg;
- (void)dealloc
{
    [appIcon release];
   	[tweetSenderName release];
	[tweetMsg release];
    [tweetDate release];
	[requestImg release];
    [super dealloc];
}

@end

