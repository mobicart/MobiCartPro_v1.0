//
//  EbookScrollView.h
//  Mobicart
//
//  Created by Mobicart on 13/08/09.
//  Copyright Mobicart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import "HomeViewController.h"
@class HomeViewController;
extern UIScrollView *ZoomScrollView;
extern UIImageView* backgroundImg;
BOOL moveON;


@interface EbookScrollView : UIScrollView 
{
	int imgNumber;
	int startX;
	int startY;	
	int currentY;
	int currentX;
	BOOL isMoved;
	HomeViewController *objPinchMeViewController;
}

@property (nonatomic, assign) HomeViewController *objPinchMeViewController;
-(void)nextImage;
-(void)previousImage;

@end
