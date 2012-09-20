//
//  HSSegmentControl_Customized.m
//  MobiCart
//
//  Created by mobicart on 13/08/10.
//  Copyright mobicart. All rights reserved.
//

#import "HSSegmentControl_Customized.h"

extern BOOL isNewsSection;
extern BOOL isOnlyNews;

@implementation HSSegmentControl_Customized

-(id)initWithItems:(NSArray *)items offColor:(UIColor*)offcolor onColor:(UIColor*)oncolor {
	if (self = [super initWithItems:items]) {
        // Initialization code
		offColor = [offcolor retain];
		onColor = [oncolor retain];
		hasSetSelectedIndexOnce = NO;
		[self setInitialMode];
		[self setSelectedSegmentIndex:0];  // default to first button, or the coloring gets all whacked out :(
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(setToggleHighlightColors)
													 name:@"updateSegmentController"
												   object:nil];
    }
    return self;
}

-(void)setInitialMode
{
	//set essential properties
	[self setBackgroundColor:[UIColor clearColor]];
	[self setSegmentedControlStyle:UISegmentedControlStyleBar];
	
	//loop through children and set initial tint
	for( int i = 0; i < [self.subviews count]; i++ )
	{
		[[self.subviews objectAtIndex:i] setTintColor:nil];
		[[self.subviews objectAtIndex:i] setTintColor:offColor];
	}
	
	// listen for updates
	[self addTarget:self action:@selector(setToggleHighlightColors) forControlEvents:UIControlEventValueChanged];
}

-(void)setToggleHighlightColors
{
	
	UIImageView *imgArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrorSortOrder.png"]];
	if(!isNewsSection)
		imgArrow.frame =CGRectMake(55, 11.5, 10, 9);
	else
		if (isOnlyNews)
			imgArrow.frame =CGRectMake(85, 11.5, 10, 9);
		else
			imgArrow.frame =CGRectMake(85, 11.5, 10, 9);
	
	NSArray *arrSubviewsOfButton;
	// get current toggle nav index
	int index = self.selectedSegmentIndex;
	int numSegments = [self.subviews count];
	
	for( int i = 0; i < numSegments; i++ )
	{
		//reset color
		[[self.subviews objectAtIndex:i] setTintColor:nil];
		[[self.subviews objectAtIndex:i] setTintColor:offColor];
		arrSubviewsOfButton = [[self.subviews objectAtIndex:i] subviews];
		if([arrSubviewsOfButton count]>1)
		{
			if([[arrSubviewsOfButton objectAtIndex:1] isKindOfClass:[UIImageView class]])
				[[arrSubviewsOfButton objectAtIndex:1] removeFromSuperview];
		}
	}
	
	if( hasSetSelectedIndexOnce)
	{
		[[self.subviews objectAtIndex: numSegments - 1 - index] setTintColor:onColor];
		[[self.subviews objectAtIndex: numSegments - 1 - index] addSubview:imgArrow];
	}
	else
	{
		[[self.subviews objectAtIndex: index] setTintColor:onColor];
		[[self.subviews objectAtIndex: index] addSubview:imgArrow];
		hasSetSelectedIndexOnce = YES;
	}
	[imgArrow release];
	
}

-(void)setArrowImage_Frame:(NSString *)_frame
{

}



@end
