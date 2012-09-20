//
//  EbookScrollView.m
//  Mobicart
//
//  Created by Mobicart on 13/08/09.
//  Copyright 2009 Mobicart. All rights reserved.
// 

#import "EbookScrollView.h"


@implementation EbookScrollView
@synthesize objPinchMeViewController;

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	NSSet *allTouches = [event allTouches];
	
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];	
	
	if([allTouches count] == 1)
		[ZoomScrollView setScrollEnabled:NO];
	
	CGPoint startLocation	= [touch locationInView:self];	
	startX = startLocation.x;
	startY = startLocation.y;
	moveON=YES;
	
	
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{	
	NSSet *allTouches = [event allTouches];
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];	 
	CGPoint currentLocation	= [touch locationInView:self];
		if([allTouches count] == 1 && ZoomScrollView.zoomScale== 1)
	{
		
		[ZoomScrollView setScrollEnabled:NO];
		currentX = currentLocation.x;
		currentY = currentLocation.y;
		
		if(currentX-startX>20)
			[self previousImage];
		else if(startX-currentX>20)
			[self nextImage];
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSSet *allTouches = [event allTouches];
	
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];	
	if([touch tapCount] == 2)
	{
		[self setZoomScale:1.0];
		[self setScrollEnabled:NO];
	}
}

-(void)previousImage
{
	if([arrBanners count]>0)
	{
		if(imgNumber>0 && moveON)
		{
			
			CGContextRef context = UIGraphicsGetCurrentContext();
			CATransition *animation = [CATransition animation]; 
			[animation setDelegate:self]; 
			[animation setType: kCATransitionPush];
			[animation setSubtype:kCATransitionPush]; 
			[animation setDuration:0.5f]; 
			[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
			[UIView beginAnimations:nil context:context];
			[[backgroundImg layer] addAnimation:animation forKey:kCATransition];
			[UIView commitAnimations]; 
			
			imgNumber--;
			if([arrBanners objectAtIndex:imgNumber])
			{
				
				UIImage *imgprod = [UIImage imageWithData:[arrBanners objectAtIndex:imgNumber]];
				int	y1= (325 - imgprod.size.height)/2;
				int x1 = (430 - imgprod.size.width)/2;
				
				[backgroundImg setFrame:CGRectMake(x1+43, y1+22, imgprod.size.width, imgprod.size.height)];	
				[backgroundImg setImage:[UIImage imageWithData:[arrBanners objectAtIndex:imgNumber]]];
			}
			moveON=NO;
			
		}
	}
}

-(void)nextImage
{
	if([arrBanners count]>0)
	{
		if(imgNumber<([arrBanners count]-1) && moveON)		
		{
			CGContextRef context = UIGraphicsGetCurrentContext();
			CATransition *animation = [CATransition animation]; 
			[animation setDelegate:self]; 
			[animation setType: kCATransitionPush];
			[animation setSubtype:kCATransitionPush]; 
			[animation setDuration:0.5f]; 
			[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
			[UIView beginAnimations:nil context:context];
			[[backgroundImg layer] addAnimation:animation forKey:kCATransition];
			[UIView commitAnimations]; 
			
			imgNumber++;
			if([arrBanners objectAtIndex:imgNumber])
			{
				UIImage *imgprod = [UIImage imageWithData:[arrBanners objectAtIndex:imgNumber]];
				int	y1= (325 - imgprod.size.height)/2;
				int x1 = (430 - imgprod.size.width)/2;
				
				[backgroundImg setFrame:CGRectMake(x1+43, y1+22, imgprod.size.width, imgprod.size.height)];	
				[backgroundImg setImage:[UIImage imageWithData:[arrBanners objectAtIndex:imgNumber]]];
			}
			moveON=NO;
						
		}
	}
}

- (void) dealloc
{
	[super dealloc];
}

@end
