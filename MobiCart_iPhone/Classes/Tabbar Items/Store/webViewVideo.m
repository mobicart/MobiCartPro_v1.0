//
//  webViewVideo.h
//  MobiCart
//
//  Created by Mobicart on 8/7/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import "webViewVideo.h"
#import "Constants.h"

@implementation webViewVideo
@synthesize strVideo;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	self.navigationItem.titleView = [GlobalPreferences createLogoImage];
	
	[self.navigationController.navigationBar setHidden:NO];
	[self.navigationController.navigationBar setTranslucent:NO];
	
	contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 372)];
	[contentView setBackgroundColor:[UIColor blackColor]];
	self.view=contentView;
	if ([self.strVideo isEqual:[NSNull null]]) 
    {
		self.strVideo=@"http://www.youtube.com/watch?v=CmSCh5ZkMqk&feature=related";
	}
	
	videoWeb = [[UIWebView alloc]initWithFrame:CGRectMake(30, 120, 260, 120)];
	videoWeb=[self embedYouTube:self.strVideo frame:CGRectMake(30, 120, 260, 120)];
	videoWeb.delegate=self;
	[contentView addSubview:videoWeb];
}

- (void)viewWillAppear:(BOOL)animated
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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[[self navigationController]popViewControllerAnimated:YES];
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
	[contentView release];
	contentView=nil;
	[videoWeb release];
	videoWeb=nil;
    [super dealloc];
}


@end
