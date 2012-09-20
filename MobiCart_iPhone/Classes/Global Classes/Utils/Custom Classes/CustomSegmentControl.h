//
//  CustomSegmentControl.h
//  MobiCart
//
//  Created by Mobicart on 13/08/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CustomSegmentControl : UISegmentedControl 
{
	UIColor *offColor;
	UIColor *onColor;
	BOOL hasSetSelectedIndexOnce;
}


-(id)initWithItems:(NSArray *)items offColor:(UIColor*)offcolor onColor:(UIColor*)oncolor;
- (void)setInitialMode;
- (void)setToggleHighlightColors;

@end
