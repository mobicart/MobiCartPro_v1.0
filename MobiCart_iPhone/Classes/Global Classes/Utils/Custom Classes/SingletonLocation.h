//
//  SingletonLocation.h
//  RealTimeTrips
//
//  Created by Mobicart on 03/11/09.
//  Copyright 2009 Mobicart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SingletonLocation : CLLocationManager
{

}

+ (SingletonLocation *)sharedInstance;

@end
