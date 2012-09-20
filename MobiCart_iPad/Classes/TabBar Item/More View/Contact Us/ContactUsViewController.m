    //
//  ContactUsViewController.m
//  Mobicart
//
//  Created by Mobicart on 05/03/11.
//  Copyright Mobicart. All rights reserved.
//

#import "ContactUsViewController.h"


@implementation ContactUsViewController
@synthesize _mapView,strStoreName;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		
		if( checkTab==1)
			self.tabBarItem.image=[UIImage imageNamed:@"Contact_us.png"];
		
	}

    return self;
}
// Implement loadView to create a view hierarchy programmatically, without using a nib.


-(void)viewWillAppear:(BOOL)animated { 
	[super viewWillAppear:animated];
	_mapView.delegate = self;
	[self.navigationController.navigationBar setHidden:YES];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	if( checkTab==1)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"poweredByMobicart" object:nil];
	}
}

-(void)viewWillDisappear:(BOOL)animated
{
	if( checkTab==1)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"removedPoweredByMobicart" object:nil];
	}
	
	for (UIView *view in [self.navigationController.navigationBar subviews]) {
		
		if (([view isKindOfClass:[UIButton class]]) || ([view isKindOfClass:[UILabel class]]))
			[view removeFromSuperview];
	}
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	CLLocationManager *userLocation = [[CLLocationManager alloc] init];
	userLocation.delegate = self;
    
	const CLLocationAccuracy * ptr = &kCLLocationAccuracyBestForNavigation;
	BOOL frameworkSupports = (ptr != NULL);
	
    if (frameworkSupports)
    {
        userLocation.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
	else
    {
        userLocation.desiredAccuracy = kCLLocationAccuracyBest;
    }
	
	[userLocation startUpdatingLocation];
	
	NSInvocationOperation *operationFetchDataFromServer= [[NSInvocationOperation alloc] initWithTarget:self
																							  selector:@selector(fetchDataFromServer) 
																								object:nil];
	[GlobalPrefrences addToOpertaionQueue:operationFetchDataFromServer];
	[operationFetchDataFromServer release];
	
	contentView=[[UIView alloc]initWithFrame:CGRectMake( 0, 0, 520, 696)];	
	contentView.backgroundColor=[UIColor clearColor];
	self.view=contentView;
	
	if( checkTab==1)
	{
		[GlobalPrefrences setBackgroundTheme_OnView:contentView];
	}
	
	UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(52, 42, 414,2)];
	[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
	[contentView addSubview:imgHorizontalDottedLine];
	[imgHorizontalDottedLine release];
	
	 UILabel *contact_Lbl=[[UILabel alloc]initWithFrame:CGRectMake(53, 395, 310, 50)];
	 contact_Lbl.textColor=headingColor;
	 contact_Lbl.font=[UIFont boldSystemFontOfSize:28];
	 [contact_Lbl setNumberOfLines:0];
	 [contact_Lbl setLineBreakMode:UILineBreakModeWordWrap];
	 [contact_Lbl setBackgroundColor:[UIColor clearColor]];
	 [contact_Lbl setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.more.contactus"]];
	 [contentView addSubview:contact_Lbl];
	 
	contactDetailsLbl=[[UITextView alloc]initWithFrame:CGRectMake(51, 450, 420, 200)];
	contactDetailsLbl.textColor=labelColor;
	contactDetailsLbl.font=[UIFont boldSystemFontOfSize:14];
	[contactDetailsLbl setBackgroundColor:[UIColor clearColor]];
	[contactDetailsLbl setEditable:NO];
	[contactDetailsLbl setText:@"Loading..."];
	[contactDetailsLbl resignFirstResponder];
	[contentView addSubview:contactDetailsLbl];
	
	
	
	if(!_mapView)
	_mapView = [[MKMapView alloc]initWithFrame:CGRectMake(54,60,407,325)];
	[[_mapView layer] setCornerRadius:5.0];
	[[_mapView layer] setBorderColor:[[UIColor clearColor] CGColor]];
	[[_mapView layer] setBorderWidth:1.0];
	[contentView addSubview:_mapView];
	
    NSDictionary *dictMerchantDetails =[ServerAPI fetchMerchantAddress:[GlobalPrefrences getMerchantEmailId]];
	dictUserDetails = [dictMerchantDetails objectForKey:@"user-address"];
	[self addressLocation];
	
	
	NSDictionary *dicAppSettings = [GlobalPrefrences getSettingsOfUserAndOtherDetails];
	
	if(dicAppSettings)
	{
		self.strStoreName = [NSString stringWithFormat:@"%@", [[dicAppSettings objectForKey:@"store"] objectForKey:@"sSName"]];
	}
	else
	{
		self.strStoreName = @"Store Location";
	}
	[SingletonLocation sharedInstance].delegate = self;
	[SingletonLocation sharedInstance].distanceFilter = 1000;
	[SingletonLocation sharedInstance].desiredAccuracy = kCLLocationAccuracyBest;
	[[SingletonLocation sharedInstance] startUpdatingLocation];	
	
	UIView *viewTopBar=[[UIView alloc]initWithFrame:CGRectMake(50,0, 450, 40)];
	[viewTopBar setBackgroundColor:[UIColor clearColor]];
	if( checkTab==1)
	{
		viewTopBar.frame = CGRectMake(50,10, 450, 40);
	}
	[contentView addSubview:viewTopBar];
	
    UIButton *btnCart = [[UIButton alloc]init];
	btnCart.frame = CGRectMake(340, 3, 78,34);
	[btnCart setBackgroundColor:[UIColor clearColor]];
	[btnCart setImage:[UIImage imageNamed:@"add_cart.png"] forState:UIControlStateNormal];
	[btnCart addTarget:nextController action:@selector(btnShoppingCart_Clicked) forControlEvents:UIControlEventTouchUpInside];
	[viewTopBar addSubview:btnCart];
	
	lblCart = [[UILabel alloc] initWithFrame:CGRectMake(42, 2, 30, 30)];
	lblCart.backgroundColor = [UIColor clearColor];
	lblCart.textAlignment = UITextAlignmentCenter;
	lblCart.font = [UIFont boldSystemFontOfSize:16];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	lblCart.textColor = [UIColor whiteColor];	 
	[btnCart addSubview:lblCart];
	
	
	UILabel *contactLbl=[[UILabel alloc]initWithFrame:CGRectMake(2, 5, 310, 30)];
	[contactLbl setBackgroundColor:[UIColor clearColor]];
	[contactLbl setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.more.contactus"]];
	contactLbl.textColor=headingColor;
	[contactLbl setFont:[UIFont boldSystemFontOfSize:15]];
	[viewTopBar addSubview:contactLbl];
	[contactLbl release];
	
	
	
	[viewTopBar release];
}

#pragma mark - fetchDataFromServer
-(void)fetchDataFromServer
{
	NSAutoreleasePool* autoReleasePool = [[NSAutoreleasePool alloc] init];
	if (!arrAllData)
		arrAllData = [[NSArray alloc] init];
	
	arrAllData = [[ServerAPI fetchStaticPages:iCurrentAppId] objectForKey:@"static-pages"];

	
	[self performSelectorOnMainThread:@selector(updateControls) withObject:nil waitUntilDone:YES];
	[autoReleasePool release];
	
}


#pragma mark updateControls
-(void)updateControls
{
	
	if ([arrAllData count] >0) {
		NSDictionary *dictTemp = [arrAllData objectAtIndex:1];
		if ((![[dictTemp objectForKey:@"sDescription"] isEqual:[NSNull null]]) && (![[dictTemp objectForKey:@"sDescription"] isEqualToString:@""]))
		{
			contactDetailsLbl.text = [dictTemp objectForKey:@"sDescription"];
			
		}
		else
		{
			contactDetailsLbl.text = @"";
			
		}
	}
	else
		contactDetailsLbl.text = @"";
	//Show Mobicart Logo at the bottom?
	
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

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
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
-(void) addressLocation {
	NSString *google_key = @"ABQIAAAA0lbZAqHh-vHS7WCn1s8sFhSXNnz9Mc3EzpX9jxA7H0PRhkjvWRQFLP11Ocnm_ptoZlq5PxCc-3CtJw";
	
	if((![dictUserDetails isEqual:[NSNull null]]) && (dictUserDetails !=nil))
	{
		NSString *strMerchantAddress = [NSString stringWithFormat:@"%@,%@,%@,%@",[dictUserDetails objectForKey:@"sAddress"],[dictUserDetails objectForKey:@"sCity"],[dictUserDetails objectForKey:@"sState"],[dictUserDetails objectForKey:@"sCountry"]];
		NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv&key=%@", 
							   [strMerchantAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],google_key];
		NSError *err;
    	NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&err];
		NSArray *listItems = [locationString componentsSeparatedByString:@","];
		
		double latitude = 0.0;
		double longitude = 0.0;
		
		if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
			latitude = [[listItems objectAtIndex:2] doubleValue];
			longitude = [[listItems objectAtIndex:3] doubleValue];
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



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
   	return UIInterfaceOrientationIsLandscape(interfaceOrientation);

}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
   
}


- (void)dealloc {
	[_mapView setDelegate:nil];
	[contentView release];
	[lblCart release];
	[contactDetailsLbl release];
	[arrAllData release];
    [super dealloc];
}


@end
