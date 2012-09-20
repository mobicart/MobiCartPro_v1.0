//
//  CustomLoadingIndicator.m
//  MobicartApp
//
//  Created by Mobicart on 12/10/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import "CustomLoadingIndicator.h"

@implementation CustomLoadingIndicator

static CustomLoadingIndicator *shared;

// Intitializes SqlQuery instance
- (id)init {
	if (shared) 
    {
        [self autorelease];
        return shared;
    }
	
	if (![super init]) return nil;
	
	shared = self;
	return self;
}

// Creates a single instance of SqlQuery and returns the same every time called.
+ (id)shared 
{
    if (!shared) 
	{
        [[CustomLoadingIndicator alloc] init];
    }
    return shared;
}


- (id)initLoadingIndicator_WithFrame:(CGRect)_frame onView:(UIView *)_topView
{
    if (self = [super initWithFrame:_frame]) 
    {
		[super setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];

		[_topView addSubview:self];
	}

	return self;
}

- (void)startLoadingIndicator
{
	[super startAnimating];
}

- (void)stopLoadingIndicator
{
	[super stopAnimating];
}


@end
