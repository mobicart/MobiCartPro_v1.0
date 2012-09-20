//
//  CustomSegmentControl.m
//  MobiCart
//
//  Created by Mobicart on 13/08/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import "CustomSegmentControl.h"

extern BOOL isNewsSection;
extern BOOL isOnlyNews;

@implementation CustomSegmentControl

-(id)initWithItems:(NSArray *)items offColor:(UIColor*)offcolor onColor:(UIColor*)oncolor
{
	if (self = [super initWithItems:items]) 
    {
        // Initialization code
		offColor = [offcolor retain];
		onColor = [oncolor retain];
		hasSetSelectedIndexOnce = NO;
		
		[self setInitialMode];
        
		[self setSelectedSegmentIndex:0];  
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setToggleHighlightColors) name:@"updateSegmentController" object:nil];
    }
    return self;
}

- (void)setInitialMode
{
	// Set essential properties
	[self setBackgroundColor:[UIColor clearColor]];
    [self setSegmentedControlStyle:UISegmentedControlStyleBar];	

	for( int i = 0; i < [self.subviews count]; i++ )
	{
		[[self.subviews objectAtIndex:i] setTintColor:nil];
		[[self.subviews objectAtIndex:i] setTintColor:offColor];
    }
	// Listen for updates
	[self addTarget:self action:@selector(setToggleHighlightColors) forControlEvents:UIControlEventValueChanged];
}

- (void)setToggleHighlightColors
{
	NSArray *arrSubviewsOfButton;
	
    // Get current toggle nav index
	int index = self.selectedSegmentIndex;
	int numSegments = [self.subviews count];
	
	for( int i=0; i<numSegments;i++ )
	{
		// Reset color
		[[self.subviews objectAtIndex:i] setTintColor:nil];
		[[self.subviews objectAtIndex:i] setTintColor:offColor];
		arrSubviewsOfButton = [[self.subviews objectAtIndex:i] subviews];
		if ([arrSubviewsOfButton count]>1)
		{
			if ([[arrSubviewsOfButton objectAtIndex:1] isKindOfClass:[UIImageView class]])
            {
                [[arrSubviewsOfButton objectAtIndex:1] removeFromSuperview];
            }
		}
	}
	
	if (hasSetSelectedIndexOnce)
	{
		[[self.subviews objectAtIndex: numSegments - 1 - index] setTintColor:onColor];
	}
	else
	{
		[[self.subviews objectAtIndex: index] setTintColor:onColor];
		hasSetSelectedIndexOnce = YES;
	}
}


@end
