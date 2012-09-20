//
//  SingletonLocation.m
//  RealTimeTrips
//
//  Created by Mobicart on 03/11/09.
//  Copyright 2009 Mobicart. All rights reserved.
//

#import "SingletonLocation.h"

static SingletonLocation *sharedSingletonLocationDelegate = nil;

@implementation SingletonLocation

#pragma mark ---- singleton object methods ----

+ (SingletonLocation *)sharedInstance
{
	@synchronized(self) 
    {
		if (sharedSingletonLocationDelegate == nil) 
        {
			NSLog(@"Location Manager created");
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
            // Assignment and return on first allocation
			return sharedSingletonLocationDelegate ;  
		}
	}
    // On subsequent allocation attempts return nil
	return nil; 
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)retain 
{
	return self;
}

- (unsigned)retainCount 
{
     // Denotes an object that cannot be released
	return UINT_MAX; 
}

- (void)release 
{
	// Do nothing
}

- (id)autorelease 
{
	return self;
}
@end

