//
//  ContactUsViewController.m
//  MobiCart
//
//  Created by Mobicart on 7/6/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import "ContactUsViewController.h"
#import "Constants.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MobiCartStart.h"
extern int controllersCount;
@implementation ContactUsViewController

@synthesize _mapView,strStoreName;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        self.tabBarItem.image = [UIImage imageNamed:@"more_icon_02.png"];
        // Custom initialization
    }
    return self;
}

- (void)addCartButtonAndLabel
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    //Adding Shopping Cart on the Navigation Bar
	MobiCartStart *as=[[MobiCartStart alloc]init];
	UIButton *btnCartOnNavBar = [UIButton buttonWithType:UIButtonTypeCustom];
	btnCartOnNavBar.frame = CGRectMake(237, 5, 78, 34);
	[btnCartOnNavBar setBackgroundColor:[UIColor clearColor]];
	[btnCartOnNavBar setImage:[UIImage imageNamed:@"add_cart.png"] forState:UIControlStateNormal];
	[btnCartOnNavBar addTarget:as action:@selector(btnShoppingCart_Clicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.navigationController.navigationBar addSubview:btnCartOnNavBar];
	
	UILabel *lblCart = [[UILabel alloc] initWithFrame:CGRectMake(280, 5, 30, 34)];
	lblCart.backgroundColor = [UIColor clearColor];
	lblCart.textAlignment = UITextAlignmentCenter;
	lblCart.font = [UIFont boldSystemFontOfSize:16];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	lblCart.textColor = [UIColor whiteColor];
	[self.navigationController.navigationBar addSubview:lblCart];
	[lblCart release];
	
	[pool release];
}
- (void)viewWillAppear:(BOOL)animated
{ 
	[super viewWillAppear:animated];
	if(controllersCount>5)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removedPoweredByMobicart" object:nil];

	//[self addCartButtonAndLabel];
	[GlobalPreferences setCurrentNavigationController:self.navigationController];
}

- (void)viewWillDisappear:(BOOL)animated
{
	if(controllersCount>5)
	  [[NSNotificationCenter defaultCenter] postNotificationName:@"poweredByMobicart" object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"addCartButton" object:nil];

	
	for (UIView *view in [self.navigationController.navigationBar subviews]) 
    {
		if (([view isKindOfClass:[UIButton class]]) || ([view isKindOfClass:[UILabel class]]))
        {
            [view removeFromSuperview];
        }
	}
}
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	self.navigationItem.titleView = [GlobalPreferences createLogoImage];
	
	NSInvocationOperation *operationFetchDataFromServer= [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fetchDataFromServer) object:nil];
	
	[GlobalPreferences addToOpertaionQueue:operationFetchDataFromServer];
	[operationFetchDataFromServer release];
	
	lblCart = [[UILabel alloc] initWithFrame:CGRectMake(280, 5, 30, 34)];
	lblCart.backgroundColor = [UIColor clearColor];
	lblCart.textAlignment = UITextAlignmentCenter;
	lblCart.font = [UIFont boldSystemFontOfSize:16];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	lblCart.textColor = [UIColor whiteColor];
	[self.navigationController.navigationBar addSubview:lblCart];
	
	contentView=[[UIView alloc]initWithFrame:CGRectMake( 0, 0, 320, 396)];	
	contentView.backgroundColor=[UIColor colorWithRed:200.0/256 green:200.0/256 blue:200.0/256 alpha:1];
	[GlobalPreferences setGradientEffectOnView:contentView:[UIColor whiteColor]:contentView.backgroundColor];
	
	self.view=contentView;
	
	UIImageView *imgBg=[[UIImageView alloc]initWithFrame:CGRectMake(0,30, 320, 350)];
	[imgBg setImage:[UIImage imageNamed:@"product_details_bg.png"]];
	[contentView addSubview:imgBg];
	[imgBg release];
	
	contactDetailsLbl=[[UITextView alloc]initWithFrame:CGRectMake(10, 30,310,104)];
	contactDetailsLbl.textColor=_savedPreferences.labelColor;
	contactDetailsLbl.font =[UIFont fontWithName:@"Helvetica" size:13.0];
	[contactDetailsLbl setBackgroundColor:[UIColor clearColor
										   ]];
	[contactDetailsLbl setEditable:NO];
	[contactDetailsLbl setText:@"Loading..."];
	[contactDetailsLbl resignFirstResponder];
	[contentView addSubview:contactDetailsLbl];
	[contactDetailsLbl	retain];
    
    if(controllersCount<=5)
    {
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(10,145,300,160)];

    }
    else
     _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(10,145,300,217)];   
    
    [[_mapView layer]setBorderWidth:1.0];
    [[_mapView layer] setCornerRadius:10];
	[contentView addSubview:_mapView];
	_mapView.delegate = self;
	
	NSDictionary *dictMerchantDetails =[ServerAPI fetchAddressOfMerchant:[GlobalPreferences getMerchantEmailId]];
	dictUserDetails = [dictMerchantDetails objectForKey:@"user-address"];
	[self addressLocation];
	
	NSDictionary *dicAppSettings = [GlobalPreferences getSettingsOfUserAndOtherDetails];
	
	if (dicAppSettings)
    {
        self.strStoreName =[NSString stringWithFormat:@"%@", [[dicAppSettings objectForKey:@"store"] objectForKey:@"sSName"]];
    }
	else
    {
        self.strStoreName = @"Store Location";
    }
			
	[SingletonLocation sharedInstance].delegate = self;
	[SingletonLocation sharedInstance].distanceFilter = 1000;
	[SingletonLocation sharedInstance].desiredAccuracy = kCLLocationAccuracyBest;
	[[SingletonLocation sharedInstance] startUpdatingLocation];	
	
	UIView *viewTopBar=[[UIView alloc]initWithFrame:CGRectMake(0,-1, 320, 31)];
    [viewTopBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"barNews.png"]]];
    [contentView addSubview:viewTopBar];
    
	[contentView addSubview:viewTopBar];
    
    UIImageView *imgViewContactUs=[[UIImageView alloc]initWithFrame:CGRectMake(10,8,15,15)];
	[imgViewContactUs setImage:[UIImage imageNamed:@"contact_usIcon.png"]];
    [viewTopBar addSubview:imgViewContactUs];
    [imgViewContactUs release];
	
    UILabel *contactLbl=[[UILabel alloc]initWithFrame:CGRectMake(30,9,280, 15)];
	[contactLbl setBackgroundColor:[UIColor clearColor]];
	[contactLbl setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.more.contactus"]];
    [contactLbl setTextColor:[UIColor whiteColor]];
	[contactLbl setFont:[UIFont boldSystemFontOfSize:13]];
	[viewTopBar addSubview:contactLbl];
	[contactLbl release];
	[viewTopBar release];
}

#pragma mark - fetchDataFromServer
- (void)fetchDataFromServer
{
	NSAutoreleasePool* autoReleasePool = [[NSAutoreleasePool alloc] init];
    
	if (!arrAllData)
    {
        arrAllData = [[NSArray alloc] init];
    }
	
    arrAllData = [[ServerAPI fetchStaticPages:iCurrentAppId] objectForKey:@"static-pages"];	
	[self performSelectorOnMainThread:@selector(updateControls) withObject:nil waitUntilDone:YES];
	[autoReleasePool release];
	
}

#pragma mark updateControls
- (void)updateControls
{
	if ([arrAllData count] >0) 
    {
		NSDictionary *dictTemp = [arrAllData objectAtIndex:1];
		if ((![[dictTemp objectForKey:@"sDescription"] isEqual:[NSNull null]]))
		{
			if ((![[dictTemp objectForKey:@"sDescription"] isEqualToString:@""])) 
            {
				contactDetailsLbl.text = [dictTemp objectForKey:@"sDescription"];
            }
			
		}
		else
		{
			contactDetailsLbl.text = @"";
		}
	}
	else
    {
        contactDetailsLbl.text = @"";
    }
		
	//Show Mobicart Logo at the bottom?
}


- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
	//_mapView.delegate = nil;
	//[contentView release];
//	[contactDetailsLbl release];
//	[arrAllData release];
    [super dealloc];
}

#pragma mark CLLocationManagerDelegate Methods

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated 
{
	
	
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	//Set Zoom level using Span
	annot= [[CSMapAnnotation alloc]initWithCoordinate:coord title:self.strStoreName subTitle:nil]; 	
	[_mapView addAnnotation:annot];
	
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord,1000,1000); 	
	[_mapView setRegion:region animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"MAP ERROR %@", [error description]);
	
}

#pragma mark -
#pragma mark Reverse Delegates
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	[_mapView addAnnotation:placemark];
    [_mapView selectAnnotation:placemark animated:YES];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
}

#pragma mark - Address Locator
- (void)addressLocation {
	NSString *google_key = @"ABQIAAAA0lbZAqHh-vHS7WCn1s8sFhSXNnz9Mc3EzpX9jxA7H0PRhkjvWRQFLP11Ocnm_ptoZlq5PxCc-3CtJw";
	
	if ((![dictUserDetails isEqual:[NSNull null]]) && (dictUserDetails !=nil))
	{
		NSString *strMerchantAddress = [NSString stringWithFormat:@"%@,%@,%@",[dictUserDetails objectForKey:@"sAddress"],[dictUserDetails objectForKey:@"sCity"],[dictUserDetails objectForKey:@"sState"],[dictUserDetails objectForKey:@"sCountry"]];
		NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv&key=%@", [strMerchantAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],google_key];
		NSError *err;
    	NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&err];
		NSArray *listItems = [locationString componentsSeparatedByString:@","];
		
		double latitude = 0.0;
		double longitude = 0.0;
		
		if ([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"])
        {
			latitude = [[listItems objectAtIndex:2] doubleValue];
			longitude = [[listItems objectAtIndex:3] doubleValue];
		}
		else 
        {
            // Show Error
		}
		CLLocationCoordinate2D location;
		location.latitude = latitude;
		location.longitude = longitude;
		
		
		coord.latitude = latitude;
		coord.longitude = longitude;
	}
	
	else
	{
		
	}
}

@end
