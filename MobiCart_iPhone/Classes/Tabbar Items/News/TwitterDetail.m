//
//  TwitterDetail.m
//  MobicartApp
//
//  Created by Mobicart on 04/10/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

/** The View To display selected tweet **/ 

#import "TwitterDetail.h"
extern BOOL isTwiiterSelected;


@implementation TwitterDetail
@synthesize strFeedsTitle,strFeedsDetail;
@synthesize strFeedsDate;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	self.navigationItem.titleView = [GlobalPreferences createLogoImage];	
	
	UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0,0,320,392)];
	contentView.backgroundColor=[UIColor colorWithRed:200.0/256 green:200.0/256 blue:200.0/256 alpha:1];
	[GlobalPreferences setGradientEffectOnView:contentView:[UIColor whiteColor]:contentView.backgroundColor];
	self.view = contentView;
	
    UIView *viewTopBar=[[UIView alloc]initWithFrame:CGRectMake(0, -1, 320,40)];
    [viewTopBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"barNews.png"]]];
    [contentView addSubview:viewTopBar];
   
    UIImageView *imgSegmentControllerStatus=[[UIImageView alloc]initWithFrame:CGRectMake(10,13,13,13)];
    [contentView addSubview:imgSegmentControllerStatus];
    
    UILabel *lblSegmentControllerSelected=[[UILabel alloc]initWithFrame:CGRectMake(30, 13, 80, 14)];
    [lblSegmentControllerSelected setBackgroundColor:[UIColor clearColor]];
    [lblSegmentControllerSelected setFont:[UIFont boldSystemFontOfSize:14]];
    [lblSegmentControllerSelected setTextColor:[UIColor whiteColor]];
    [contentView addSubview:lblSegmentControllerSelected];
    
    if (isTwitterSelected==YES)
    {
        [imgSegmentControllerStatus setImage:[UIImage imageNamed:@"twitter_icon.png"]];
         [lblSegmentControllerSelected setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.news.twitter"]];
    }
    else
    {
        [imgSegmentControllerStatus setImage:[UIImage imageNamed:@"news_icon_top.png"]];
        [lblSegmentControllerSelected setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.news.news"]];  
    }
    
    [imgSegmentControllerStatus release];
    [lblSegmentControllerSelected release];
    [viewTopBar release];
	
	UIImageView *imgBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 320, 350)];
	[imgBg setImage:[UIImage imageNamed:@"product_details_bg.png"]];
	[contentView addSubview:imgBg];
	[imgBg release];
	
	UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,40,320,392)];
	[scrollView setContentSize:CGSizeMake(320,600)];
	scrollView.backgroundColor=[UIColor clearColor];
	[contentView addSubview:scrollView];
	
	UIToolbar *topSortToolBar = [[UIToolbar alloc]init];
	topSortToolBar.backgroundColor=[UIColor clearColor];
	
    // Setting gradient effect on view

    CGSize sizeTitle=[strFeedsTitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    
    
	UILabel *lblFeedsTitle = [[UILabel alloc]initWithFrame:CGRectMake(10,6,300,sizeTitle.height)];
	[lblFeedsTitle setBackgroundColor:[UIColor clearColor]];
	[lblFeedsTitle setLineBreakMode:UILineBreakModeWordWrap];
	[lblFeedsTitle setNumberOfLines:0];
     
	lblFeedsTitle.textColor=_savedPreferences.headerColor;
	[lblFeedsTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
	
	[lblFeedsTitle setText:strFeedsTitle];
	
	[scrollView addSubview:lblFeedsTitle];
	
	CGRect frame = [lblFeedsTitle frame];
	CGSize size = [lblFeedsTitle.text sizeWithFont:lblFeedsTitle.font constrainedToSize:CGSizeMake(frame.size.width, 9999) lineBreakMode:UILineBreakModeWordWrap];
	frame.size.height = size.height;
	[lblFeedsTitle setFrame:frame];
	
	UILabel *lblNewsDate = [[UILabel alloc]initWithFrame:CGRectMake( 10, frame.size.height+5, 300, 50)];
	lblNewsDate.backgroundColor=[UIColor clearColor];
	[lblNewsDate setLineBreakMode:UILineBreakModeWordWrap];
	[lblNewsDate setNumberOfLines:0];
	[lblNewsDate setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
	lblNewsDate.textColor=_savedPreferences.labelColor;
	
    if (strFeedsTitle&& strFeedsDate.length!=0)
    {
		NSArray *dateComponenentsTemp=[[[strFeedsDate componentsSeparatedByString:@"+" ]objectAtIndex:0]componentsSeparatedByString:@" "];
		NSCalendar *aCalendar = [NSCalendar currentCalendar];
		NSDateComponents *adateComponents = [[NSDateComponents alloc] init];
		int monCom=0;
		if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"Jan"]) 
		{
			monCom=1;
		}
		else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"Feb"]) 
		{
			monCom=2;
		}
		else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"March"]) 
		{
			monCom=3;
		}else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"Mar"]) 
		{
			monCom=3;
		}
		
		else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"April"]) 
		{
			monCom=4;
		}
		else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"Apr"]) 
		{
			monCom=4;
		}

		else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"May"]) 
		{
			monCom=5;
		}
		
		else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"June"]) 
		{
			monCom=6;
		}
		else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"Jun"]) 
		{
			monCom=6;
		}
		else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"July"]) 
		{
			monCom=7;
		}
        else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"Jul"]) 
		{
			monCom=7;
		}
		
		else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"Aug"]) 
		{
			monCom=8;
		}
		
		else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"Sep"]) 
		{
			monCom=9;
		}
		
		else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"Oct"]) 
		{
			monCom=10;
		}
		
		
		else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"Nov"]) 
		{
			monCom=11;
		}
		
		else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"Dec"]) 
		{
			monCom=12;
		}
		
		
		[adateComponents setYear:[[dateComponenentsTemp objectAtIndex:3] integerValue]];
		[adateComponents setDay:[[dateComponenentsTemp objectAtIndex:1] integerValue]];    
		[adateComponents setMonth:monCom];
		
		NSDate *date = [aCalendar dateFromComponents:adateComponents];	
		NSDateFormatter *prefixDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[prefixDateFormatter setDateFormat:@"d"];
		NSString *prefixDateString = [prefixDateFormatter stringFromDate:date];
		NSDateFormatter *monthDayFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[monthDayFormatter setDateFormat:@"d"];         
		int date_day = [[monthDayFormatter stringFromDate:date] intValue];      
		NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
		NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
		NSString *suffix = [suffixes objectAtIndex:date_day];  
		suffix	=[suffix uppercaseString];
		NSString *dateString = [prefixDateString stringByAppendingString:suffix]; 
		dateString=[dateString uppercaseString];
		NSDateFormatter *formatSuffix=[[NSDateFormatter alloc] init];
		[formatSuffix setDateFormat:@"MMMM YYYY"];
		NSString *suffix1=[formatSuffix stringFromDate:date];
		suffix1=[suffix1 uppercaseString];
	
		[suffix1 capitalizedString];
		
		NSString *strDateFinal=[NSString stringWithFormat:@"%@ %@",dateString,suffix1];
		[lblNewsDate setText:strDateFinal];
    }
	else
    {   
		
		}
	
	[scrollView addSubview:lblNewsDate];
	
	frame = [lblNewsDate frame];
	size = [lblNewsDate.text sizeWithFont:lblNewsDate.font constrainedToSize:CGSizeMake(frame.size.width, 9999) lineBreakMode:UILineBreakModeWordWrap];
	frame.size.height = size.height;
	[lblNewsDate setFrame:frame];
	
	lblNewsDetail=[[UIWebView alloc]initWithFrame:CGRectMake( 0, lblNewsDate.frame.origin.y+lblNewsDate.frame.size.height+10, 320, 270)];
	[lblNewsDetail setOpaque:0];
    lblNewsDetail.delegate=self;
	[lblNewsDetail setBackgroundColor:[UIColor clearColor]];
    
    
    if(strFeedsDetail.length>0)
    {
  
        if ([strFeedsDetail rangeOfString:@"src=\""].location== NSNotFound) 
        {
            
        }
        else{  
            if([strFeedsDetail rangeOfString:@"src=\"http"].location== NSNotFound)
            {
                strFeedsDetail= [strFeedsDetail stringByReplacingOccurrencesOfString:@"src=\""
                                                      withString:@"src=\"http:"];    
            }
            else
            {
                
            }
        }

    }
    
    NSString * strnew = [NSString stringWithFormat:@"<html><head><script> document.ontouchmove = function(event) { if (document.body.scrollHeight == document.body.clientHeight) event.preventDefault(); } </script><style type='text/css'>* { margin-right:2px;margin-left:2px; padding:0; } p { color:%@; font-family:Helvetica; font-size:14px; } a { color:%@; text-decoration:none; }</style></head><body><p>%@</p></body></html>", _savedPreferences.strHexadecimalColor,_savedPreferences.subHeaderColor,strFeedsDetail];            
    
	[lblNewsDetail loadHTMLString:strnew baseURL:nil];
	[scrollView addSubview:lblNewsDetail];
	
	frame.origin.y=lblNewsDate.frame.origin.y+lblNewsDate.frame.size.height+15;
	
	[scrollView setContentSize:CGSizeMake( 320, lblNewsDetail.frame.origin.y+lblNewsDetail.frame.size.height+10)];

	[lblNewsDate release];
	[lblFeedsTitle release];
	[lblNewsDetail release];
	[scrollView release];
	[contentView release];
	
    [super viewDidLoad];
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


- (void)dealloc {
    isTwitterSelected=NO;
    [super dealloc];
}
#pragma  WebView Delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType

{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [NSThread detachNewThreadSelector:@selector(showLoadingbar) toTarget:self withObject:nil];
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    lblNewsDetail.scalesPageToFit=YES; 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [NSThread detachNewThreadSelector:@selector(hideIndicator1) toTarget:self withObject:nil];
  
}


#pragma mark loading indicator


- (void)showLoadingbar
{   
	if (!loadingActionSheet1.superview)
    {
        loadingActionSheet1 = [[UIActionSheet alloc] initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"] delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        [loadingActionSheet1 showInView:self.tabBarController.view];
        
    }
    
	
}	

-(void)hideIndicator1

{
	
	if (loadingActionSheet1.superview)
    {
        [loadingActionSheet1 dismissWithClickedButtonIndex:0 animated:YES];
        [loadingActionSheet1 release];
		loadingActionSheet1 = nil;
    }
	
}


@end
