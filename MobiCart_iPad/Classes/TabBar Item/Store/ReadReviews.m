//
//  ReadReviews.m
//  Mobicart
//
//  Created by Mobicart on 09/05/11.
//  Copyright Mobicart. All rights reserved.
//

#import "ReadReviews.h"
#import "Constants.h"


int rating=0;

@implementation ReadReviews
@synthesize selectedProductId;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */
-(void)hideLoadingView
{
	[GlobalPrefrences dismissLoadingBar_AtBottom];	
}
#pragma mark viewcontroller methods
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
	self.view=contentView;
	[GlobalPrefrences setBackgroundTheme_OnView:contentView];
	
	
	
    UILabel *lblHeading = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 470, 35)];
	[lblHeading setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:lblHeading];
	[lblHeading setFont:[UIFont boldSystemFontOfSize:15]];
	[lblHeading setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.read.reviews.customer"]];
	lblHeading.textColor = headingColor;
	
	UIButton *btnBackToDepts=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnBackToDepts setTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.home.back"] forState:UIControlStateNormal];
	[btnBackToDepts setFrame:CGRectMake(400, 15, 70, 30)];
	[btnBackToDepts.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
	[btnBackToDepts setTitleColor:btnTextColor forState:UIControlStateNormal];
	[btnBackToDepts setBackgroundImage:[UIImage imageNamed:@"edit_cart_btn.png"] forState:UIControlStateNormal];
	btnBackToDepts.backgroundColor = [UIColor clearColor];
	[btnBackToDepts addTarget:self action:@selector(showListOfDepts) forControlEvents:UIControlEventTouchUpInside];
	[contentView addSubview:btnBackToDepts];
	
	UIImageView *imgLine1=[[UIImageView alloc]initWithFrame:CGRectMake(45,50, 416,5)];
	[imgLine1 setImage:[UIImage imageNamed:@"dot_line.png"]];
	[contentView addSubview:imgLine1];
	[imgLine1 release];
	
	lblProductName = [[UILabel alloc] initWithFrame:CGRectMake(45,56, 470, 35)];
	[lblProductName setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:lblProductName];
	[lblProductName setFont:[UIFont boldSystemFontOfSize:16]];
	[lblProductName setContentMode:UIViewContentModeTop];
	[lblProductName setTextColor:subHeadingColor];
	[contentView addSubview:lblProductName];
	
	lblReviewCount = [[UILabel alloc] initWithFrame:CGRectMake(45,78, 470, 35)];
	[lblReviewCount setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:lblReviewCount];
    [lblReviewCount setFont:[UIFont boldSystemFontOfSize:12]];
	[lblReviewCount setContentMode:UIViewContentModeTop];
	lblReviewCount.textColor = headingColor;
	
	UIImageView *imgLine2=[[UIImageView alloc]initWithFrame:CGRectMake(45,112, 416,5)];
	[imgLine2 setImage:[UIImage imageNamed:@"dot_line.png"]];
	[contentView addSubview:imgLine2];
	[imgLine2 release];
	
	tblReviews = [[UITableView alloc]initWithFrame:CGRectMake(40,110,426,500) style:UITableViewStylePlain];
	[tblReviews setDelegate:self];
	[tblReviews setDataSource:self];
	[tblReviews setHidden:NO];
	[tblReviews setTag:12321];
	[tblReviews setSeparatorColor:[UIColor clearColor]];
	[tblReviews setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:tblReviews];
	
	
	viewForPostReview=[[UIView alloc]initWithFrame:CGRectMake(520, 0, 440, 660)];
	[viewForPostReview setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:viewForPostReview];
	
	
	viewforAccount=[[UIView alloc]initWithFrame:CGRectMake(570,0, 440, 660)];
	[viewforAccount setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:viewforAccount];
	viewforAccount.hidden=YES;
	
	btnShowPostReview=[UIButton buttonWithType:UIButtonTypeRoundedRect];
	[btnShowPostReview setFrame:CGRectMake(0, 0,100,30)];
	[btnShowPostReview setTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] forState:UIControlStateNormal];
	
	UILabel *PostReviewHeading = [[UILabel alloc] initWithFrame:CGRectMake(28, 15, 470, 35)];
	[PostReviewHeading setBackgroundColor:[UIColor clearColor]];
    [PostReviewHeading setFont:[UIFont boldSystemFontOfSize:15]];
	[PostReviewHeading setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.reviews.writereview"]];
	PostReviewHeading.textColor = headingColor;
	[viewForPostReview addSubview:PostReviewHeading];
	[PostReviewHeading release];
	
	
	UIImageView *imgLine3=[[UIImageView alloc]initWithFrame:CGRectMake(28,50, 425,5)];
	[imgLine3 setImage:[UIImage imageNamed:@"dot_line.png"]];
	[viewForPostReview addSubview:imgLine3];
	[imgLine3 release];
	
	
	UIButton *btnCart = [[UIButton alloc]init];
	btnCart.frame = CGRectMake(898, 12, 78,34);
	[btnCart setBackgroundColor:[UIColor clearColor]];
	[btnCart setTag:234567];
	[btnCart setImage:[UIImage imageNamed:@"add_cart.png"] forState:UIControlStateNormal];
	[btnCart addTarget:self action:@selector(btnShoppingCart_Clicked) forControlEvents:UIControlEventTouchUpInside];
	[contentView addSubview:btnCart];
	
	lblCart = [[UILabel alloc] initWithFrame:CGRectMake(42, 2, 30, 30)];
	lblCart.backgroundColor = [UIColor clearColor];
	lblCart.textAlignment = UITextAlignmentCenter;
	lblCart.font = [UIFont boldSystemFontOfSize:16];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	lblCart.textColor = [UIColor whiteColor];	 
	[btnCart addSubview:lblCart];
	
	
	UILabel *lblRateIt = [[UILabel alloc] initWithFrame:CGRectMake(30,62,75, 35)];
	[lblRateIt setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:lblRateIt];
	[lblRateIt setFont:[UIFont boldSystemFontOfSize:18]];
	[lblRateIt setText:[NSString stringWithFormat:@"%@:",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.postreview.rateit"]]];
	[lblRateIt setTextColor:subHeadingColor];
	[viewForPostReview addSubview:lblRateIt];
	[lblRateIt release];
	
	UIImageView *imgLine4=[[UIImageView alloc]initWithFrame:CGRectMake(28,112, 425,5)];
	[imgLine4 setImage:[UIImage imageNamed:@"dot_line.png"]];
	[viewForPostReview addSubview:imgLine4];
	[imgLine4 release];
	
	
	UILabel *lblYourName=  [[UILabel alloc] initWithFrame:CGRectMake(32, 130,100, 35)];
	[lblYourName setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:lblYourName];
	[lblYourName setFont:[UIFont boldSystemFontOfSize:16]];
	[lblYourName setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.read.reviews.your.name"]];
	[lblYourName setTextColor:subHeadingColor];
	[viewForPostReview addSubview:lblYourName];
	[lblYourName release];
	
	UITextField *txtFieldName = [[UITextField alloc] initWithFrame:CGRectMake(141,132,315,30)];
	txtFieldName.delegate = self;
	[txtFieldName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[txtFieldName setFont:[UIFont systemFontOfSize:15]];
	[txtFieldName setTag:50];
	[[txtFieldName layer] setCornerRadius:5.0];
	[[txtFieldName layer] setBorderColor:[[UIColor blackColor] CGColor]];
	[[txtFieldName layer] setBorderWidth:0.5];
	[txtFieldName setBorderStyle:UITextBorderStyleRoundedRect];
	[viewForPostReview addSubview:txtFieldName];
	[txtFieldName release];
	
	
	
	UILabel *lblPostReviewText=[[UILabel alloc] initWithFrame:CGRectMake(32,180,100, 35)];
	[lblPostReviewText setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:lblPostReviewText];
	[lblPostReviewText setFont:[UIFont boldSystemFontOfSize:16]];
	[lblPostReviewText setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.postreview.review"]];
	[lblPostReviewText setTextColor:subHeadingColor];
	[viewForPostReview addSubview:lblPostReviewText];
	[lblPostReviewText release];
	
	UITextView *	textViewReview = [[UITextView alloc] initWithFrame:CGRectMake(141,185,315,450)];
	textViewReview.delegate=self;
	[textViewReview setFont:[UIFont systemFontOfSize:16]];
	[textViewReview setTag:100];
	[[textViewReview layer] setCornerRadius:5.0];
	[[textViewReview layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[textViewReview layer] setBorderWidth:0.5];
	[viewForPostReview addSubview:textViewReview];
	[textViewReview release];
	
	
	
	[self createRatingView];
	
	
	UIButton *btnPostReview=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnPostReview setFrame:CGRectMake(359, 64,99 ,31)];
    [btnPostReview setTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.postreview.postreview"] forState:UIControlStateNormal];
	[btnPostReview setTitleColor:btnTextColor forState:UIControlStateNormal];
	[btnPostReview.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
	btnPostReview.backgroundColor = [UIColor clearColor];
	[btnPostReview setBackgroundImage:[UIImage imageNamed:@"post_review.png"] forState:UIControlStateNormal];
	[btnPostReview addTarget:self action:@selector(postToServer) forControlEvents:UIControlEventTouchUpInside];
	[viewForPostReview addSubview:btnPostReview];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPostReview) name:@"PostReviewShow" object:nil];
	
}


-(void)viewWillAppear:(BOOL)animated
{
	rating=0;
	UIButton *btnTemp = (UIButton *)[contentView viewWithTag:234567];
	[btnTemp setHidden:NO];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	NSInvocationOperation *oprFetchReviews = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fetchDataFromServer) object:nil];
	[GlobalPrefrences addToOpertaionQueue:oprFetchReviews];
	
	[oprFetchReviews release];	
	
}	

-(void)showListOfDepts
{
	NSArray *arrTemp = self.navigationController.viewControllers;
	if([arrTemp count]>0)
	{
	 [[self navigationController] popViewControllerAnimated:YES];
	}
	
}
-(void)btnShoppingCart_Clicked
{
	if(iNumOfItemsInShoppingCart > 0)
		[NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
	ShoppingCartViewController *objShopping = [[ShoppingCartViewController alloc] init];
	[[self navigationController]pushViewController:objShopping animated:YES];
	[objShopping release];
	
}
-(void)showLoading
{
	[GlobalPrefrences addLoadingBar_AtBottom:self.tabBarController.view withTextToDisplay:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
}
#pragma mark post review navigation methods

-(void)showPostReview
{
	[viewforAccount setHidden:YES];
	[viewForPostReview setHidden:NO];
}	

#pragma mark stat rating methods
-(void)createRatingView
{
	
	UIButton *btnRatings[5];
	
	if(starratingView)
	{   [starratingView removeFromSuperview];
		[starratingView release];
		starratingView = nil;
	}	
	starratingView=[[UIView alloc]initWithFrame:CGRectMake(93,60, 205, 32)];
	[starratingView setTag:1001];
	[viewForPostReview addSubview:starratingView];
	
	int xValue=10;
	
	for(int i=0; i<5; i++)
	{
		btnRatings[i] = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnRatings[i] setFrame:CGRectMake( xValue,7,21, 21)];
		[btnRatings[i] setBackgroundImage:[UIImage imageNamed:@"favorite_star-off-transparent.png"] forState:UIControlStateNormal];
		[btnRatings[i] setTag:i];
		[btnRatings[i] addTarget:self action:@selector(ratingNumber:) forControlEvents:UIControlEventTouchUpInside];
		[starratingView addSubview:btnRatings[i]];
		
		xValue +=27 ;
	}
	
	
}	

-(void)ratingNumber:(UIButton *)sender
{
	rating	= [sender tag] +1;
	UIView *viewContent_Star = (UIView *) [self.view viewWithTag:1001];
	NSArray *_arrTemp = [viewContent_Star subviews];
	
	int iSenderTag = [sender tag];
	for (int i = 0; i<iSenderTag; i++) 
	{
		UIButton *pBtn = [_arrTemp objectAtIndex:i];
		
		[pBtn setImage:[UIImage imageNamed:@"favorite_star-on-transparent.png"] forState:UIControlStateNormal];
	}
	
	
	for (int j = iSenderTag+1; j<5; j++) 
	{
		UIButton *nBtn = [_arrTemp objectAtIndex:j];
		
		[nBtn setImage:[UIImage imageNamed:@"favorite_star-off-transparent.png"] forState:UIControlStateNormal];
	}
	
	if ([sender.currentImage isEqual:[UIImage imageNamed:@"favorite_star-on-transparent.png"]]) 
	{
		
		[sender setImage:[UIImage imageNamed:@"favorite_star-off-transparent.png"] forState:UIControlStateNormal];
		rating	= [sender tag];
		if(sender.tag==0)
			rating=0;
	}
	else
	{
		[sender setImage:[UIImage imageNamed:@"favorite_star-on-transparent.png"] forState:UIControlStateNormal];
		if(sender.tag==0)
			rating=1;
	}
	
	
	
}


-(void)markStarRating:(NSDictionary*)dicProduct
{
	
	
	int xValue=340;
	
	
	float rating;
	
	NSDictionary *dictProducts = [ServerAPI fetchDetailsOfProductWithID:[[dicProduct valueForKey:@"id"]intValue]];	
	
	
	if([[[dictProducts valueForKey:@"product"]valueForKey:@"categoryName"] isEqual:[NSNull null]])
		isFeaturedProductWithoutCatogery=YES;
    
	if(![dictProducts isKindOfClass:[NSNull class]])
		if([[[dictProducts valueForKey:@"product"]valueForKey:@"fAverageRating"] isEqual:[NSNull null]])
			rating = 0.0;
		else
			rating = [[[dictProducts valueForKey:@"product"]valueForKey:@"fAverageRating"] floatValue];
	float tempRating;
	tempRating=floor(rating);
	tempRating=rating-tempRating;
    
	for(int i=0; i<5; i++)
	{
		
		imgRatingsTempMain[i] = [[[UIImageView alloc] initWithFrame:CGRectMake( xValue,68, 21, 21)] autorelease];
        imgRatingsTempMain[i].clipsToBounds = TRUE;
		[imgRatingsTempMain[i] setImage:[UIImage imageNamed:@"favorite_star-off-transparent.png"]];
		[imgRatingsTempMain[i] setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:imgRatingsTempMain[i]];
		
		xValue +=27;
	}
	
	int iTemp =0;
	
	for(int i=0; i<abs(rating) ; i++)
	{
		
		viewRatingBGMain[i] = [[[UIView  alloc] initWithFrame:CGRectMake(0, 0, 21, 21)] autorelease];
		[viewRatingBGMain[i] setBackgroundColor:[UIColor clearColor]];
        
		[imgRatingsTempMain[i] addSubview:viewRatingBGMain[i]];
		
		
		
		imgRatingsMain[i] = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21, 21)] autorelease];
		[imgRatingsMain[i] setImage:[UIImage imageNamed:@"favorite_star-on-transparent.png"]];
		[imgRatingsTempMain[i] addSubview:imgRatingsMain[i]];
		iTemp = i;
	}
	
	if (tempRating>0)
	{
		int iLastStarValue = 0;
		if(rating >=1.0)
			iLastStarValue = iTemp + 1;
        
        
        
        viewRatingBGMain[iLastStarValue] = [[[UIView  alloc] initWithFrame:CGRectMake(0, 0, tempRating * 21, 21)] autorelease];
        viewRatingBGMain[iLastStarValue].clipsToBounds = TRUE;
        [imgRatingsTempMain[iLastStarValue] addSubview:viewRatingBGMain[iLastStarValue]];
        
        
        
        imgRatingsMain[iLastStarValue] = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21, 21)] autorelease];
        [imgRatingsMain[iLastStarValue] setImage:[UIImage imageNamed:@"favorite_star-on-transparent.png"]];
        [viewRatingBGMain[iLastStarValue] addSubview:imgRatingsMain[iLastStarValue]];
    }
}


#pragma mark get data from Server

-(void)fetchDataFromServer
{
	NSDictionary *dictProductDetails = [[ServerAPI fetchDetailsOfProductWithID:selectedProductId] objectForKey:@"product"];
	[self performSelectorOnMainThread:@selector(markStarRating:) withObject:dictProductDetails waitUntilDone:YES];
	
    [self performSelectorOnMainThread:@selector(setLabelNames:) withObject:dictProductDetails waitUntilDone:YES];
    
	if(![dictProductDetails isKindOfClass:[NSDecimalNumber class]])
		arrReviews = [[NSArray alloc] initWithArray:[dictProductDetails valueForKey:@"productReviews"]];
	
	
	
	if ([arrReviews count]!=0) 
	{
		UITableView *_tableView = (UITableView *) [contentView viewWithTag:12321];
		if(_tableView)
		{   [_tableView setHidden:NO]; 
  			[_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
		}
	}
	
	else 
		[self performSelectorOnMainThread:@selector(addNoReviewLabel) withObject:nil waitUntilDone:YES];
}

#pragma mark Send Data To Server
-(void) postToServer
{
	
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if([[GlobalPrefrences getUserDefault_Preferences:@"userEmail"] length]==0)
	{
		if(objDetails)
		{
			[objDetails release];
			objDetails=nil;
		}	
		UIButton *btnTemp = (UIButton *)[contentView viewWithTag:234567];
		[btnTemp setHidden:YES];
		objDetails=[[DetailsViewController alloc]init];
        [viewForPostReview setHidden:YES];
		objDetails.isFromPostReview=YES;
		[viewforAccount addSubview:objDetails.view];
		[viewforAccount setHidden:NO];
	}
	
	else {
		
		UITextView *textViewReview = (UITextView *)[self.view viewWithTag:100];
		
		NSArray *arrUserDetails = [[SqlQuery shared] getBuyerData:[GlobalPrefrences getUserDefault_Preferences:@"userEmail"]];
		
		
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
		
		NSString *strDataToPost = [NSString stringWithFormat:@"{\"productId\":%d,\"sReveiwerName\":\"%@\",\"sReviewerEmail\":\"%@\",\"iRating\":%d, \"sReview\":\"%@\"}",selectedProductId , [[arrUserDetails objectAtIndex:0] objectForKey:@"sUserName"], [[arrUserDetails objectAtIndex:0] objectForKey:@"sEmailAddress"],rating,escapedUrlString];
		
		if(![GlobalPrefrences isInternetAvailable])
		{
			// If internet is not available, then save the data into the database, for sending it later
			NSLog(@"INTERNET IS UNAVAILABLE, SAVING DATA IN THE LOCAL DATABASE");
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
			
			[alert show];
			
			[alert release];
			
		}
		else 
		{
			NSString *reponseRecieved = [ServerAPI postReviewRatings:strDataToPost];		
			
			// Now send data to the server for this recently made order 
			if ([reponseRecieved isKindOfClass:[NSString class]]) 
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.review.rating.posted.title"] message:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.review.rating.posted.text"] delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
				[alert show];
				
				[alert release];
				[lblNoReview setHidden:YES];
				
			}
			else
			{
				NSLog(@"Error While sending billing details to server (PostReviewViewController)");
			}
		}
		
		
		
	}
	
	[pool release];
	
}

-(void)addNoReviewLabel
{
	[tblReviews setHidden:YES];
	[lblReviewCount setHidden:YES];
	if(lblNoReview)
		[lblNoReview release];
	lblNoReview=[[UILabel alloc]initWithFrame:CGRectMake(110, 150, 310, 30)];
	[lblNoReview setBackgroundColor:[UIColor clearColor]];
	[lblNoReview setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.read.reviews.no.review"]];
	[lblNoReview setTextColor:subHeadingColor];
	[lblNoReview setTextAlignment:UITextAlignmentCenter];
	[lblNoReview setFont:[UIFont boldSystemFontOfSize:18]];
	[self.view addSubview:lblNoReview];
}
# pragma UIAlertView delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{	
	
	UITextField *txtReviewerName=(UITextField *)[viewForPostReview viewWithTag:50];
	[txtReviewerName setText:@""];
	UITextView *txtViewReviews=(UITextView *)[viewForPostReview viewWithTag:100];
	
	[txtViewReviews setText:@""];
	
	[self createRatingView];
	
	NSInvocationOperation *oprFetchReviewsOnSuccess = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fetchDataFromServer) object:nil];
	[GlobalPrefrences addToOpertaionQueue:oprFetchReviewsOnSuccess];
	[oprFetchReviewsOnSuccess release];		 
}	


#pragma mark Table View Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{	
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	NSString *titleString = [[arrReviews objectAtIndex:indexPath.row] objectForKey:@"sReveiwerName"];
   	NSString *detailString = [[arrReviews objectAtIndex:indexPath.row] valueForKey:@"sReview"];
	detailString = [detailString stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
	detailString=[detailString stringByReplacingOccurrencesOfString:@"--" withString:@"%"];
	detailString=[detailString stringByReplacingOccurrencesOfString:@"__" withString:@"#"];
	detailString=[detailString stringByReplacingOccurrencesOfString:@"$$$" withString:@"\""];
	detailString=[detailString stringByReplacingOccurrencesOfString:@"per5B" withString:@"["];
	detailString=[detailString stringByReplacingOccurrencesOfString:@"per5D" withString:@"]"];
	detailString=[detailString stringByReplacingOccurrencesOfString:@"per7B" withString:@"{"];
	detailString=[detailString stringByReplacingOccurrencesOfString:@"per7D" withString:@"}"];
	detailString=[detailString stringByReplacingOccurrencesOfString:@"%253C" withString:@"<"];
	detailString=[detailString stringByReplacingOccurrencesOfString:@"%253E" withString:@">"];
	
	
	CGSize titleSize = [titleString sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:CGSizeMake(415, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
	CGSize detailSize = [detailString sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(415, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    NSNumber *yValueTemp=[NSNumber numberWithInt:detailSize.height+titleSize.height+15];
	[yValue addObject:yValueTemp];
    
	return detailSize.height+titleSize.height+70;
	
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	[textField resignFirstResponder];
	return YES;
	
	
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	UIButton *btnTemp = (UIButton *)[contentView viewWithTag:234567];
	[btnTemp setHidden:NO];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.5];
	
	viewForPostReview.frame = CGRectMake(520, 0, 440, 660);
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
	
}	


- (void)textViewDidBeginEditing:(UITextView *)textView
{
	UIButton *btnTemp = (UIButton *)[contentView viewWithTag:234567];
	[btnTemp setHidden:YES];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.5];
	viewForPostReview.frame = CGRectMake(520, -160, 440, 660);
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
	
}	


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	return [arrReviews count];	
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell =  (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSString *strText = [[arrReviews objectAtIndex:indexPath.row] valueForKey:@"sReview"];
	if([strText isEqualToString:@"(null)"])
		strText = @"";
	
	strText = [strText stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
	strText=[strText stringByReplacingOccurrencesOfString:@"--" withString:@"%"];
	strText=[strText stringByReplacingOccurrencesOfString:@"__" withString:@"#"];
	strText=[strText stringByReplacingOccurrencesOfString:@"$$$" withString:@"\""];
	strText=[strText stringByReplacingOccurrencesOfString:@"per5B" withString:@"["];
	strText=[strText stringByReplacingOccurrencesOfString:@"per5D" withString:@"]"];
	strText=[strText stringByReplacingOccurrencesOfString:@"per7B" withString:@"{"];
	strText=[strText stringByReplacingOccurrencesOfString:@"per7D" withString:@"}"];
	strText=[strText stringByReplacingOccurrencesOfString:@"%253C" withString:@"<"];
	strText=[strText stringByReplacingOccurrencesOfString:@"%253E" withString:@">"];
	
	CGSize size=[[[arrReviews objectAtIndex:indexPath.row] objectForKey:@"sReveiwerName"] sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(415, MAXFLOAT)];
	
	UILabel *lblBy=[[UILabel alloc]initWithFrame:CGRectMake(7,49,20,17)];
	[lblBy setBackgroundColor:[UIColor clearColor]];
	[lblBy setNumberOfLines:0];
	[lblBy setTextColor:subHeadingColor];
	lblBy.text =[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.read.reviews.by"];
	lblBy.font = [UIFont boldSystemFontOfSize:13];
	[cell addSubview:lblBy];
	
	
	
	UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(29,49,386,size.height)];
	[lblName setBackgroundColor:[UIColor clearColor]];
	[lblName setNumberOfLines:0];
	lblName.textColor = headingColor;
	lblName.text = [NSString stringWithFormat:@"%@",  [[arrReviews objectAtIndex:indexPath.row] objectForKey:@"sReveiwerName"]];
	lblName.font = [UIFont boldSystemFontOfSize:13];
	[cell addSubview:lblName];
	
	
	CGSize size1=[strText sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300, MAXFLOAT)];
	UILabel *lblDetail=[[UILabel alloc]initWithFrame:CGRectMake(7,lblName.frame.size.height+lblName.frame.origin.y, 415,size1.height)];
	[lblDetail setBackgroundColor:[UIColor clearColor]];
	lblDetail.text = strText;
	lblDetail.textColor = subHeadingColor;
	lblDetail.font = [UIFont systemFontOfSize:12];
	lblDetail.numberOfLines = ceilf([strText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(415, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap].height/20.0);
	[cell addSubview:lblDetail];
	
	[lblName release];
	[lblDetail release];
	
	
	
	
	int xValue=3;
    
	
	int rate = [[[arrReviews objectAtIndex:indexPath.row] valueForKey:@"iRating"] intValue];
	
	UIImageView *imgRatings[5];
    int yValueCell=0;
    
	for(int i=0; i<5; i++)
	{   
        yValueCell=[[yValue objectAtIndex:indexPath.row]intValue];
		imgRatings[i] =[[UIImageView alloc] initWithFrame:CGRectMake(xValue,20,17,17)];
		
		if(i<rate)
			[imgRatings[i] setImage:[UIImage imageNamed:@"favorite_star-on-transparent.png"]];
		else
			[imgRatings[i] setImage:[UIImage imageNamed:@"favorite_star-off-transparent.png"]];
		
		[cell.contentView addSubview:imgRatings[i]];
		[imgRatings[i] release];
		
		xValue += 19;
	}
	
	UIImageView *imgLine=[[UIImageView alloc]initWithFrame:CGRectMake(0,lblDetail.frame.size.height+lblDetail.frame.origin.y+20,418,2)];
	[imgLine setImage:[UIImage imageNamed:@"dotted_line_02.png"]];
	[cell addSubview:imgLine];
	[imgLine release];
	
	rating=0;
	return cell;
	
}


-(void)setLabelNames:(NSDictionary *)dictProduct
{
	
    if(![dictProduct isKindOfClass:[NSDecimalNumber class]])
	{
		[lblProductName setText:[dictProduct valueForKey:@"sName"]];
		if([[dictProduct valueForKey:@"productReviews"]count]>1)
		{
			[lblReviewCount setText:[NSString stringWithFormat:@"%d %@",[[dictProduct valueForKey:@"productReviews"]count],[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.reviews.reviews"]]];
		}
		else
		{
			[lblReviewCount setText:[NSString stringWithFormat:@"%d %@",[[dictProduct valueForKey:@"productReviews"]count],[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.reviews.reviews"]]];
		}
		
	}
	
}

// Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
  return UIInterfaceOrientationIsLandscape(interfaceOrientation);
 }

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"PostReviewShow" object:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
