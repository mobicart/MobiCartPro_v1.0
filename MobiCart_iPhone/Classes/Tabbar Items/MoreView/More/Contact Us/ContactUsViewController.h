//
//  ContactUsViewController.h
//  MobiCart
//
//  Created by Mobicart on 7/6/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>
#import "Annotation.h"

@interface ContactUsViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate> 
{
	MKMapView *_mapView;
	CLLocationCoordinate2D coord;

	CSMapAnnotation *annot;
	
	UITextView *contactDetailsLbl;
	NSArray *arrAllData;
	
	NSDictionary *dictUserDetails;
	UIView *contentView;
}

@property (nonatomic, retain) MKMapView *_mapView;
@property (nonatomic, retain) NSString *strStoreName;

- (void)addressLocation;
- (void)updateControls;
@end
