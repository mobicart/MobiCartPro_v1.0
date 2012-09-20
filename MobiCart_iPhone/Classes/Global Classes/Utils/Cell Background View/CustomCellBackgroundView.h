//
//  CustomCellBackgroundView.h
//
//  Created by Mobicart on 1/31/11.
//  Copyright 2010 HS Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef enum {
    CustomCellBackgroundViewPositionSingle = 0,
    CustomCellBackgroundViewPositionTop, 
    CustomCellBackgroundViewPositionBottom,
    CustomCellBackgroundViewPositionMiddle
} CustomCellBackgroundViewPosition;

@interface CustomCellBackgroundView : UIView 
{
    CustomCellBackgroundViewPosition position;
}

@property(nonatomic) CustomCellBackgroundViewPosition position;

@end
