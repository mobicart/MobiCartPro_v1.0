    //
//  webViewVideo.m

//
//  Created by Mobicart on 3/29/10.
//  Copyright Mobicart. All rights reserved.
//

#import "webViewVideo.h"
#import "Constants.h"

@implementation webViewVideo
@synthesize strVideo;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	self.navigationController.navigationBar.hidden = NO;
	self.navigationController.navigationBar.tintColor = [UIColor clearColor];
	contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 718)];
	[contentView setBackgroundColor:[UIColor blackColor]];
	self.view=contentView;
	
	[GlobalPrefrences setBackgroundTheme_OnView:contentView];
	if ([self.strVideo isEqual:[NSNull null]]) 
	{
		self.strVideo=@"http://www.youtube.com/watch?v=CmSCh5ZkMqk&feature=related";
	}
	
	videoWeb = [[UIWebView alloc]initWithFrame:CGRectMake(30, 20, 950, 620)];
	videoWeb=[self embedYouTube:self.strVideo frame:CGRectMake(30, 20, 950, 620)];
	videoWeb.delegate=self;
	[contentView addSubview:videoWeb];
	
}

-(void)viewWillAppear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateLabelStore" object:nil];
}

- (UIWebView *)embedYouTube:(NSString *)urlString frame:(CGRect)frame {
	NSString *embedHTML = @"\
    <html><head>\
	<style type=\"text/css\">\
	body {\
	background-color: transparent;\
	color: white;\
	}\
	</style>\
	</head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
	width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
	NSString *html = [NSString stringWithFormat:embedHTML, urlString, frame.size.width, frame.size.height];
	videoWeb = [[UIWebView alloc] initWithFrame:frame];
	[videoWeb loadHTMLString:html baseURL:nil];
	return videoWeb;
}

-(void)webViewDidStartLoad:(UIWebView *) portal {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES; 
	
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[[self navigationController]popViewControllerAnimated:YES];
	
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

-(void)viewWillDisappear:(BOOL)animated

{
    
  	NSString *embedHTML = @"\
    <html><head>\
	<style type=\"text/css\">\
	body {\
	background-color: transparent;\
	color: black;\
	}\
	</style>\
	</head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
	width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
	
	NSString *urlString = @"";
	NSString *html = [NSString stringWithFormat:embedHTML, urlString, 950, 620];
	if(videoWeb)
	{
		[videoWeb loadHTMLString:html baseURL:nil];
		[videoWeb release];
		videoWeb = nil;
		
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[contentView release];
	contentView=nil;
	videoWeb.delegate = nil;
	[videoWeb release];
	videoWeb=nil;
    [super dealloc];
}


@end
