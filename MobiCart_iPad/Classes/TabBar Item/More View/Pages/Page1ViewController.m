    //
//  Page1ViewController.m
//  Mobicart
//
//  Created by Mobicart on 05/03/11.
//  Copyright Mobicart. All rights reserved.
//

#import "Page1ViewController.h"


@implementation Page1ViewController

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		
		if( checkTab==4)
			self.tabBarItem.image=[UIImage imageNamed:@"page_1.png"];
		
	}
	
	
    return self;
}
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

-(void)viewWillAppear:(BOOL)animated { 
	[super viewWillAppear:animated];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	if( checkTab==4)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"poweredByMobicart" object:nil];
		
	}
	
	
}


-(void)viewWillDisappear:(BOOL)animated
{
	if( checkTab==4)
	{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"removedPoweredByMobicart" object:nil];
	}
	for (UIView *view in [self.navigationController.navigationBar subviews]) {
		
		if (([view isKindOfClass:[UIButton class]]) || ([view isKindOfClass:[UILabel class]]))
			[view removeFromSuperview];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  	[self.navigationController.navigationBar setHidden:YES];
	
	NSInvocationOperation *operationFetchDataFromServer= [[NSInvocationOperation alloc] initWithTarget:self
																							  selector:@selector(fetchDataFromServer) 
																								object:nil];
	[GlobalPrefrences addToOpertaionQueue:operationFetchDataFromServer];
	[operationFetchDataFromServer release];
	
	UIView *contentView=[[UIView alloc]initWithFrame:CGRectMake( 0, 0, 450, 700)];
	contentView.backgroundColor=[UIColor clearColor];
	contentView.tag = 101010;
	self.view=contentView;
	UIView *viewTopBar=[[[UIView alloc]initWithFrame:CGRectMake(50,0, 450, 40)]autorelease];
	if( checkTab==4)
	{
		viewTopBar.frame = CGRectMake(50,10, 450, 40);
		[GlobalPrefrences setBackgroundTheme_OnView:contentView];
		
	}
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
	viewTopBar.backgroundColor=[UIColor clearColor];
	//setting gradient effect on view
	[contentView addSubview:viewTopBar];
	
	
	UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(5, 42, 414,2)];
	[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
	[viewTopBar addSubview:imgHorizontalDottedLine];
	[imgHorizontalDottedLine release];

	
	 aboutLbl=[[UILabel alloc]initWithFrame:CGRectMake(5, 8, 310, 30)];
	[aboutLbl setBackgroundColor:[UIColor clearColor]];
	[aboutLbl setText:[self.title uppercaseString]];
	[aboutLbl setFont:[UIFont boldSystemFontOfSize:15]];
	[viewTopBar addSubview:aboutLbl];
	
	
	contentScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(50, 60, 420, 600)];
	[contentScrollView setBackgroundColor:[UIColor clearColor]];
	[contentScrollView setContentSize:CGSizeMake( 420, 326)];
	[contentView addSubview:contentScrollView];
	
	
	aboutDetailLbl=[[UILabel alloc]initWithFrame:CGRectMake( 5, 0, 420, 50)];
	aboutDetailLbl.textColor=[UIColor blackColor];
	aboutDetailLbl.font= [UIFont systemFontOfSize:13];
	[aboutDetailLbl setNumberOfLines:0];
	[aboutDetailLbl setLineBreakMode:UILineBreakModeWordWrap];
	[aboutDetailLbl setBackgroundColor:[UIColor clearColor]];
	aboutDetailLbl.text=@" Loading...";
	aboutDetailLbl.textColor=labelColor;
	[contentScrollView addSubview:aboutDetailLbl];
	aboutDetailLbltext=[[UIWebView alloc]initWithFrame:CGRectMake( 0, 0, 420, 590)];
    [aboutDetailLbltext setOpaque:0];
    aboutDetailLbltext.delegate=self;
    aboutDetailLbltext.dataDetectorTypes=UIDataDetectorTypeAll;
    [aboutDetailLbltext setBackgroundColor:[UIColor clearColor]];
    [contentScrollView addSubview:aboutDetailLbltext];

	[contentScrollView setContentSize:CGSizeMake(420, 600)];
	
	[contentView release];
	
	[super viewDidLoad];
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
	int index=[[arrAllData valueForKey:@"sName"]indexOfObject:@"page1"];
	
	
		NSDictionary *dictTemp = [arrAllData objectAtIndex:index];
		[aboutLbl setText:[dictTemp valueForKey:@"sTitle"]];
		aboutLbl.textColor=headingColor;
		if ((![[dictTemp objectForKey:@"sDescription"] isEqual:[NSNull null]]) && (![[dictTemp objectForKey:@"sDescription"] isEqualToString:@""]))
		{
			aboutDetailLbl.hidden=YES;
            NSString * htmlString = [NSString stringWithFormat:@"<html><head><script> document.ontouchmove = function(event) { if (document.body.scrollHeight == document.body.clientHeight) event.preventDefault(); } </script><style type='text/css'>* { margin:0; padding:0; } p { color:%@; font-family:Helvetica; font-size:14px; } a { color:%@; text-decoration:none; }</style></head><body><p>%@</p></body></html>", _savedPreferences.hexLabelcolor,_savedPreferences.hexcolor,[dictTemp objectForKey:@"sDescription"]];
            
            [aboutDetailLbltext loadHTMLString:htmlString baseURL:nil];            
			
			[contentScrollView setContentSize:CGSizeMake(320, 600)];
			
		}
		
		
	
	
}
#pragma Webview delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType

{
    
    
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    aboutDetailLbltext.scalesPageToFit=YES; 
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    
    
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  
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
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[contentScrollView release];
	[aboutDetailLbl release];
	[arrAllData release];
	[lblCart release];
	[aboutLbl release];
    [super dealloc];
}


@end
