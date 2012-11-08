//
//  PostReviewsViewController.m
//  MobicartApp
//
//  Created by Mobicart on 12/17/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

/** The View Controller for writing reviews and posting reviews **/

#import "PostReviewsViewController.h"
#import "Constants.h"

int rating=0;

@implementation PostReviewsViewController
@synthesize productId;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	[GlobalPreferences setCurrentNavigationController:self.navigationController];
	self.navigationItem.titleView = [GlobalPreferences createLogoImage];
	self.view.backgroundColor=navBarColor;
	
    UIView *contentView = [[UIView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake(0,0,320,480) chageHieght:YES]];
	contentView.backgroundColor=[UIColor colorWithRed:200.0/256 green:200.0/256 blue:200.0/256 alpha:1];
    
	[GlobalPreferences setGradientEffectOnView:contentView:[UIColor whiteColor]:contentView.backgroundColor];
	self.view = contentView;
    rating=0;
	
    UIView *viewTopBar=[[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 32)];
	[viewTopBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"barNews.png"]]];
    [contentView addSubview:viewTopBar];
	
	UIView *viewTopBar1=[[UIView alloc]initWithFrame:CGRectMake(0,43, 320, 2)];
	[viewTopBar1 setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:viewTopBar1];
    
    
    
	UILabel *accountLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 310, 20)];
	[accountLbl setBackgroundColor:[UIColor clearColor]];
	[accountLbl setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.postreview.postreview"]];
    [accountLbl setTextColor:[UIColor whiteColor]];
	[accountLbl setFont:[UIFont boldSystemFontOfSize:14.00]];
	[viewTopBar addSubview:accountLbl];
	[accountLbl release];
	[viewTopBar release];
	
    UIView *viewBottomRatingBar=[[UIView alloc]initWithFrame:CGRectMake(0,30, 320, 40)];
	[viewBottomRatingBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom_bar.png"]]];
    [contentView addSubview:viewBottomRatingBar];
    
    UILabel *lblRating = [[UILabel alloc] initWithFrame:CGRectMake(10,4, 80,32)];
	[lblRating setText:[NSString stringWithFormat:@"%@:",[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.postreview.rateit"]]];
	lblRating.textColor =[UIColor whiteColor];
	[lblRating setBackgroundColor:[UIColor clearColor]];
	lblRating.font=[UIFont boldSystemFontOfSize:16];
	[viewBottomRatingBar addSubview:lblRating];
	[lblRating release];
	
	UIButton *btnRatings[5];
	
	UIView *starratingView=[[UIView alloc]initWithFrame:CGRectMake(70,9.5, 205, 32)];
	[starratingView setTag:1001];
	[viewBottomRatingBar addSubview:starratingView];
	
	int xValue=0;
	
	for (int i=0; i<5; i++)
	{
		btnRatings[i] = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnRatings[i] setFrame:CGRectMake( xValue, 0,20,19)];
		[btnRatings[i] setBackgroundImage:[UIImage imageNamed:@"grey_star1.png"] forState:UIControlStateNormal];
		[btnRatings[i] setTag:i];
		[btnRatings[i] addTarget:self action:@selector(ratingNumber:) forControlEvents:UIControlEventTouchUpInside];
		[starratingView addSubview:btnRatings[i]];
		
		xValue +=25 ;
	}
	
	[starratingView release];
    
    UIButton *btnPostReview=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnPostReview setFrame:CGRectMake(232,7, 83, 25)];
    [btnPostReview setBackgroundImage:[UIImage imageNamed:@"post_review.png"] forState:UIControlStateNormal];
	[btnPostReview setTitle:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.postreview.postreview"] forState:UIControlStateNormal];
	[btnPostReview.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [btnPostReview addTarget:self action:@selector(postToServer) forControlEvents:UIControlEventTouchUpInside];
	[viewBottomRatingBar addSubview:btnPostReview];
	
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake( 6,76, 309, 117)];
	textView.delegate = self;
	[textView setReturnKeyType:UIReturnKeyDefault];
	[textView setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.00]];
	[textView setTag:50];
	[[textView layer] setCornerRadius:10.0];
	[[textView layer] setBorderColor:[[UIColor blackColor] CGColor]];
	[[textView layer] setBorderWidth:0.5];
	[textView becomeFirstResponder];
	[self.view addSubview:textView];
	[textView release];
	
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
	isPostReviews=YES;
	rating=0;
}

// Calculate the rating and handles rating star views
- (void)ratingNumber:(UIButton *)sender
{
	rating	= [sender tag] +1;
	
	UIView *viewContent_Star = (UIView *) [self.view viewWithTag:1001];
	NSArray *_arrTemp = [viewContent_Star subviews];
	
	int iSenderTag = [sender tag];
	for (int i = 0; i<iSenderTag; i++)
	{
		UIButton *pBtn = [_arrTemp objectAtIndex:i];
		[pBtn setImage:[UIImage imageNamed:@"yellow_star1.png"] forState:UIControlStateNormal];
	}
	
	for (int j=iSenderTag+1; j<5; j++)
	{
		UIButton *nBtn = [_arrTemp objectAtIndex:j];
		[nBtn setImage:[UIImage imageNamed:@"grey_star1.png"] forState:UIControlStateNormal];
	}
	
	if ([sender.currentImage isEqual:[UIImage imageNamed:@"yellow_star1.png"]])
	{
		[sender setImage:[UIImage imageNamed:@"grey_star1.png"] forState:UIControlStateNormal];
		if(sender.tag==0)
        {
            rating=0;
        }
	}
	else
	{
		[sender setImage:[UIImage imageNamed:@"yellow_star1.png"] forState:UIControlStateNormal];
		if(sender.tag==0)
        {
            rating=1;
        }
	}
}

- (void)cancelMethod
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if (textView.text.length >= 140 && range.length == 0)
    {
        return NO;
    }
    
	return YES;
}

#pragma mark Send Data To Server
// Posting Reviews and Ratings to Mobicart Server By the Logged In User
- (void)postToServer
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	UITextView *textViewReview = (UITextView *)[self.view viewWithTag:50];
	
	NSArray *arrUserDetails = [[SqlQuery shared] getBuyerData:[GlobalPreferences getUserDefault_Preferences:@"userEmail"]];
	
	NSString *strReview = textViewReview.text;
	strReview = [[strReview componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@" "];
	strReview=[strReview stringByReplacingOccurrencesOfString:@"%" withString:@"--"];
	strReview=[strReview stringByReplacingOccurrencesOfString:@"#" withString:@"__"];
	strReview=[strReview stringByReplacingOccurrencesOfString:@"^" withString:@"$$"];
	strReview=[strReview stringByReplacingOccurrencesOfString:@"\"" withString:@"$$$"];
	strReview=[strReview stringByReplacingOccurrencesOfString:@"[" withString:@"per5B"];
	strReview=[strReview stringByReplacingOccurrencesOfString:@"]" withString:@"per5D"];
	strReview=[strReview stringByReplacingOccurrencesOfString:@"{" withString:@"per7B"];
	strReview=[strReview stringByReplacingOccurrencesOfString:@"}" withString:@"per7D"];
	strReview=[strReview stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
	strReview=[strReview stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
	
	NSString* escapedUrlString =[strReview stringByAddingPercentEscapesUsingEncoding:
								 NSASCIIStringEncoding];
	
	NSString *strDataToPost = [NSString stringWithFormat:@"{\"productId\":%d,\"sReveiwerName\":\"%@\",\"sReviewerEmail\":\"%@\",\"iRating\":%d, \"sReview\":\"%@\"}",productId , [[arrUserDetails objectAtIndex:0] objectForKey:@"sUserName"], [[arrUserDetails objectAtIndex:0] objectForKey:@"sEmailAddress"],rating,escapedUrlString];
	
	if(![GlobalPreferences isInternetAvailable])
	{
		// If internet is not available, then save the data into the database, for sending it later
		NSLog(@"INTERNET IS UNAVAILABLE, SAVING DATA IN THE LOCAL DATABASE");
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.title"] message:@"Internet is unavailable." delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	else
	{
        NSString *reponseRecieved = [ServerAPI postReviewRatings:strDataToPost];
		
        // Now send data to the server for this recently made order
		if ([reponseRecieved isKindOfClass:[NSString class]])
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.review.rating.posted.title"] message:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.review.rating.posted.text"] delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			[alert show];
			[alert release];
			[self.navigationController popViewControllerAnimated:YES];
		}
		else
        {
            NSLog(@"Error While sending billing details to server (PostReviewViewController)");
        }
	}
	
	[pool release];
	[self cancelMethod];
}

// Send Reviews with User Details to Mobicart Server
- (NSString *)sendDataToServer:(NSURL *)_url withData:(NSString *)strDataToPost
{
	NSData *postData = [strDataToPost dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:_url];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	[request setHTTPBody:postData];
	
	NSError *error;
	NSURLResponse *response;
	NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
	return data;
	
}

- (void)viewDidDisappear:(BOOL)animated
{
	isPostReviews=NO;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

@end
