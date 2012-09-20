//
//  ContactUsViewController.h
//  Mobicart
//
//  Created by Mobicart on 05/03/11.
//  Copyright Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>
#import "Annotation.h"
#import "Constants.h"
#import "SingletonLocation.h"
extern UIViewController * nextController;
@interface ContactUsViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate> {
	MKMapView *_mapView;
	CLLocationCoordinate2D coord;
	
	CSMapAnnotation *annot;
	
	UITextView *contactDetailsLbl;
	NSArray *arrAllData;
	UILabel *lblCart;
	NSDictionary *dictUserDetails;
	UIView *contentView;
}
@property (nonatomic, retain) MKMapView *_mapView;
@property (nonatomic, retain) NSString *strStoreName;

-(void) addressLocation;
@end
