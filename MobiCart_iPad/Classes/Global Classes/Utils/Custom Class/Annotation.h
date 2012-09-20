//
//  CSMapAnnotation.h
//  mapLines
//
//  Created by Mobicart on 5/15/09.
//  Copyright Mobicart. All rights reserved.
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
