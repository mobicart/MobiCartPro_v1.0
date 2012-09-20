//
//  SingletonLocation.m
//  RealTimeTrips
//
//  Created by Mobicart on 03/11/09.
//  Copyright Mobicart. All rights reserved.
//

#import "SingletonLocation.h"




static SingletonLocation *sharedSingletonLocationDelegate = nil;

@implementation SingletonLocation



#pragma mark ---- singleton object methods ----


+(SingletonLocation *)sharedInstance 
{
	@synchronized(self) 
	{
		if (sharedSingletonLocationDelegate == nil) 
		{
			NSLog(@"Location Manager created");
          // assignment not done here
			sharedSingletonLocationDelegate = [[super allocWithZone:NULL] init]; 
		}
	}
	return sharedSingletonLocationDelegate;
}

+ (id)allocWithZone:(NSZone *)zone 
{
	@synchronized(self)
	{
		if (sharedSingletonLocationDelegate == nil) 
		{
			sharedSingletonLocationDelegate = [super allocWithZone:zone];
			return sharedSingletonLocationDelegate ;  // assignment and return on first allocation
		}
	}
	return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
	
	//do nothing
}

- (id)autorelease {
	return self;
}
@end

