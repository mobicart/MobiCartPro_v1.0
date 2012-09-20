//
//  CustomCellBackgroundView.m
//
//  Created by Mobicart on 1/31/11.
//  Copyright 2010 Mobicart. All rights reserved.
//

#define TABLE_CELL_BACKGROUND    { 1, 1, 1, 1, .784, 0.784, 0.784, 1}			
#define kDefaultMargin           10

#import "CustomCellBackgroundView.h"

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,float ovalHeight);

@implementation CustomCellBackgroundView

@synthesize position;

- (BOOL)isOpaque
{
    return NO;
}

- (void)drawRect:(CGRect)aRect 
{
    // Drawing code
    CGContextRef c = UIGraphicsGetCurrentContext();	

    int lineWidth = 1;
	
    CGRect rect = [self bounds];	
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
    miny -= 1;
	
    CGFloat locations[2] = { 0.0, 1.0 };
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef myGradient = nil;
    CGFloat components[8] = TABLE_CELL_BACKGROUND;
    CGContextSetStrokeColorWithColor(c, [[UIColor grayColor] CGColor]);
    CGContextSetLineWidth(c, lineWidth);
    CGContextSetAllowsAntialiasing(c, YES);
    CGContextSetShouldAntialias(c, YES);
    	
    if (position == CustomCellBackgroundViewPositionTop) 
    {
            miny += 1;
            
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, minx, maxy);
        CGPathAddArcToPoint(path, NULL, minx, miny, midx, miny, kDefaultMargin);
        CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, maxy, kDefaultMargin);
        CGPathAddLineToPoint(path, NULL, maxx, maxy);
        CGPathAddLineToPoint(path, NULL, minx, maxy);
        CGPathCloseSubpath(path);
            
        // Fill and stroke the path
        CGContextSaveGState(c);
        CGContextAddPath(c, path);
        CGContextClip(c);
            
        myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, 2);
        CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0);
            
        CGContextAddPath(c, path);
        CGPathRelease(path);
        CGContextStrokePath(c);
        CGContextRestoreGState(c);		

    } 
    else if (position == CustomCellBackgroundViewPositionBottom) 
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, minx, miny);
        CGPathAddArcToPoint(path, NULL, minx, maxy, midx, maxy, kDefaultMargin);
        CGPathAddArcToPoint(path, NULL, maxx, maxy, maxx, miny, kDefaultMargin);
        CGPathAddLineToPoint(path, NULL, maxx, miny);
        CGPathAddLineToPoint(path, NULL, minx, miny);
        CGPathCloseSubpath(path);
		
        // Fill and stroke the path
        CGContextSaveGState(c);
        CGContextAddPath(c, path);
        CGContextClip(c);
            
        myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, 2);
        CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0);
            
        CGContextAddPath(c, path);
        CGPathRelease(path);
        CGContextStrokePath(c);
        CGContextRestoreGState(c);
    } 
    else if (position == CustomCellBackgroundViewPositionMiddle) 
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, minx, miny);
        CGPathAddLineToPoint(path, NULL, maxx, miny);
        CGPathAddLineToPoint(path, NULL, maxx, maxy);
        CGPathAddLineToPoint(path, NULL, minx, maxy);
        CGPathAddLineToPoint(path, NULL, minx, miny);
        CGPathCloseSubpath(path);
            
        // Fill and stroke the path
        CGContextSaveGState(c);
        CGContextAddPath(c, path);
        CGContextClip(c);
            
        myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, 2);
        CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0);
            
        CGContextAddPath(c, path);
        CGPathRelease(path);
        CGContextStrokePath(c);
        CGContextRestoreGState(c);
		
    } 
    else if (position == CustomCellBackgroundViewPositionSingle) 
    {
            miny += 1;
		
	    CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, minx, midy);
        CGPathAddArcToPoint(path, NULL, minx, miny, midx, miny, kDefaultMargin);
        CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, midy, kDefaultMargin);
        CGPathAddArcToPoint(path, NULL, maxx, maxy, midx, maxy, kDefaultMargin);
        CGPathAddArcToPoint(path, NULL, minx, maxy, minx, midy, kDefaultMargin);
        CGPathCloseSubpath(path);
		
        // Fill and stroke the path
        CGContextSaveGState(c);
        CGContextAddPath(c, path);
        CGContextClip(c);
            
        myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, 2);
        CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0);
            
        CGContextAddPath(c, path);
        CGPathRelease(path);
        CGContextStrokePath(c);
        CGContextRestoreGState(c);	
    }
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
    return;
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)setPosition:(CustomCellBackgroundViewPosition)newPosition 
{
    if (position != newPosition) 
    {
        position = newPosition;
        [self setNeedsDisplay];
    }
}
@end

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,float ovalHeight) 
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
	
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect),CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2); 
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); 
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}
