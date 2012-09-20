//
//  CSMapAnnotation.h
//  Mobicart
//
//  Created by Mobicart on 5/15/09.
//  Copyright 2010 Mobicart Spitzkoff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface CSMapAnnotation : NSObject <MKAnnotation>
{
	CLLocationCoordinate2D _coordinate;
	NSString*              _title;
	NSString*              _subTitle;
}

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)title subTitle:(NSString*)subTitle;

@end
