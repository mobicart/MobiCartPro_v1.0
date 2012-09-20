//
//  SegmentControl_Customized.h
//  MobiCart
//
//  Created by mobicart on 13/08/10.
//  Copyright mobicart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface SegmentControl_Customized : UISegmentedControl
{	
	UIColor *offColor;
	UIColor *onColor;
	
	BOOL hasSetSelectedIndexOnce;
	CGRect *arrowImageFrame;
}

-(id)initWithItems:(NSArray *)items offColor:(UIColor*)offcolor onColor:(UIColor*)oncolor;
-(void)setInitialMode;
-(void)setToggleHighlightColors;


@end
