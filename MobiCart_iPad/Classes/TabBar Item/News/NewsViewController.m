//
//  NewsViewController.m
//  MobiCart
//
//  Copyright Mobicart. All rights reserved.
//

#import "NewsViewController.h"
#import "GlobalPrefrences.h"
#import "Constants.h"
#import "AppRecord.h"

BOOL isOnlyNews, isRowSelected;
BOOL isTwitter;
@implementation NewsViewController
@synthesize arrTwitter,arrAppRecordsAllEntries;
@synthesize imageDownloadsInProgress;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.tabBarItem.image = [UIImage imageNamed:@"news_icon.png"];
		
		
	}
    return self;
}


-(void)viewWillDisappear:(BOOL)animated
{
	isNewsSection = NO;
	UIView *topSortToolBar = (UIView *)[self.tabBarController.view viewWithTag:10101010]; 	
	[topSortToolBar setHidden:YES];	
	
}
-(void)viewWillAppear:(BOOL)animated
{ 	
	[super viewWillAppear:animated];
	isNewsSection=YES;
	UIView *topSortToolBar = (UIView *)[self.tabBarController.view viewWithTag:10101010]; 	
	[topSortToolBar setHidden:NO];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
}


UILabel *lblHeading;
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	[self.navigationController.navigationBar setHidden:YES];
	[GlobalPrefrences addLoadingBar_AtBottom:self.tabBarController.view withTextToDisplay:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
	
	isOnlyNews=NO;
	
	News = [[NSMutableArray alloc] init];	
	Twitter = [[NSMutableArray alloc] init];
	arrTwitter = [[NSMutableArray alloc] init];
	arrEntriesCount = [[NSMutableArray alloc] init];
	arrCountTweets = [[NSMutableArray alloc] init];
	self.arrAppRecordsAllEntries = [[NSMutableArray alloc] init];
	font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
	font1 = [UIFont fontWithName:@"Helvetica-Bold" size:14.5];
	
	contentView = [[UIView alloc]initWithFrame:CGRectMake(0,0,1024,768)];
	self.view = contentView;
	
	noItemLbl=[[UILabel alloc]initWithFrame:CGRectMake( 10, 80, 310, 50)];
	noItemLbl.textColor=subHeadingColor;
	[noItemLbl setFont:[UIFont boldSystemFontOfSize:14]];
	[noItemLbl setBackgroundColor:[UIColor clearColor]];
	[noItemLbl setHidden:YES];
	[contentView addSubview:noItemLbl];
	[GlobalPrefrences setBackgroundTheme_OnView:contentView];
	if(!arrSearch)
		arrSearch=[[NSMutableArray alloc]init];
	UIView *topSortToolBar = [[UIView alloc]initWithFrame:CGRectMake( 10, 719, 320, 50)];
	
	topSortToolBar.backgroundColor = [UIColor clearColor];
	topSortToolBar.tag = 10101010;
	
	UIView *viewRemoveLine = [[UIView alloc] initWithFrame:CGRectMake( 0, 43, 320, 2)];
	[viewRemoveLine setBackgroundColor:self.navigationController.navigationBar.tintColor];
	[self.navigationController.navigationBar addSubview:viewRemoveLine];
	[viewRemoveLine release];
	
	
	UILabel *lblSort=[[UILabel alloc]initWithFrame:CGRectMake(10, 8, 80, 30)];
    [lblSort setText:[NSString stringWithFormat:@"%@:",[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.news.show.by"]]];
    [lblSort setBackgroundColor:[UIColor clearColor]];
	[lblSort setTextColor:[UIColor lightGrayColor]];
	[lblSort setFont:[UIFont boldSystemFontOfSize:12]];
	
	[self.tabBarController.view addSubview:topSortToolBar];
	[topSortToolBar addSubview:lblSort];
	[lblSort release];
	
	lblHeading = [[UILabel alloc] initWithFrame:CGRectMake(48, 15, 470, 35)];
	[lblHeading setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:lblHeading];
	[lblHeading setFont:[UIFont boldSystemFontOfSize:15]];
	[lblHeading setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.news.news"]];
	lblHeading.textColor =headingColor;
	
	UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 414,2)];
	[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
	[contentView addSubview:imgHorizontalDottedLine];
	[imgHorizontalDottedLine release];
		
	tblNews = [[UITableView alloc]initWithFrame:CGRectMake(40,70,420,600) style:UITableViewStylePlain];
	[tblNews setDelegate:self];
	[tblNews setDataSource:self];
	[tblTweets setHidden:NO];
	[tblNews setSeparatorColor:[UIColor clearColor]];
	[tblNews setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:tblNews];
	
	
	[self performSelectorInBackground:@selector(fetchDataFromServer) withObject:nil];
	
	if ([Twitter count]!=0) 
	{
		[self fetchDataFromTwitter];
		
	}	
	[topSortToolBar release];
	
	
}

#pragma mark Fetch data from server
// Fetching Twitter Feed if defined for store
-(void)fetchDataFromTwitter
{
	
	NSAutoreleasePool* autoReleasePool = [[NSAutoreleasePool alloc] init];
		    
    NSDictionary *dictTemp = [ServerAPI fetchTweets:iCurrentStoreId];
	self.arrTwitter = [dictTemp objectForKey:@"results"];
	
	if([self.arrAppRecordsAllEntries count]>0)
		[self.arrAppRecordsAllEntries removeAllObjects];
	
	
	if([arrEntriesCount count]>0)
		[arrEntriesCount removeAllObjects];
	
	
	[self.arrTwitter retain];
	
	for(int i =0; i<[self.arrTwitter count] ;i++)
	{
		AppRecord *_currentRecord = [[AppRecord alloc] init];
		_currentRecord.tweetSenderName = [[self.arrTwitter objectAtIndex:i] valueForKey:@"name"];
		_currentRecord.tweetMsg = [[self.arrTwitter objectAtIndex:i] valueForKey:@"text"];
		_currentRecord.requestImg=[ServerAPI createTweetImageRequest:[[self.arrTwitter objectAtIndex:i] valueForKey:@"image"]];
		_currentRecord.tweetDate = [[self.arrTwitter objectAtIndex:i] valueForKey:@"createdAt"];
		[self.arrAppRecordsAllEntries addObject:_currentRecord];
		[_currentRecord release];
		[arrEntriesCount addObject:[NSNumber numberWithInt:i]];
	}
	[arrCountTweets addObjectsFromArray:arrEntriesCount];
	
	[tblTweets performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
	[autoReleasePool release];
	
}

// Fetch News defined for store from Mobicart server
-(void)fetchDataFromServer
{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
	NSAutoreleasePool* autoReleasePool = [[NSAutoreleasePool alloc] init];
	NSDictionary *dictTemp=[ServerAPI fetchNewsAndTwitter:iCurrentAppId];
	NSArray *arrdict = [dictTemp objectForKey:@"news-items"];
	int count = [arrdict count];
	
	for(int i =0; i<count; i++)
	{
		NSDictionary *dictcontent = [arrdict objectAtIndex:i];
		NSString *strType = [[NSString alloc] init];	
		strType = [strType stringByAppendingString:[dictcontent objectForKey:@"sType"]];
		
		if([strType isEqualToString:@"custom"])
		{
			NSDictionary *dictTemp = [NSDictionary dictionaryWithObjectsAndKeys:[arrdict objectAtIndex:i],@"value",strType,@"type",nil];
			
			[News addObject:dictTemp];
		}
		else if([strType isEqualToString:@"feed"])
		{
			if(![[dictcontent objectForKey:@"bFeedStatus"] isEqual:[NSNull null]])
				if([[dictcontent objectForKey:@"bFeedStatus"] intValue]==1)
				{
					
					NSString *strFeedUrl=[NSString stringWithFormat:@"%@",[[arrdict objectAtIndex:i] valueForKey:@"sFeedUrl"]];
					[self parseXMLFileAtURL:strFeedUrl];
					for(int i=0; i<[stories count]; i++)
					{
						NSDictionary *dictTemp = [NSDictionary dictionaryWithObjectsAndKeys:[stories objectAtIndex:i],@"value",strType,@"type",nil];
						[News addObject:dictTemp];
					}
				}
			
			if(![[dictcontent objectForKey:@"bTwitterStatus"] isEqual:[NSNull null]])
				if([[dictcontent objectForKey:@"bTwitterStatus"] intValue]==1)
				{
					NSDictionary *dictTemp = [NSDictionary dictionaryWithObjectsAndKeys:[arrdict objectAtIndex:i],@"value",strType,@"type",nil];
					[Twitter addObject:dictTemp];
				}
		}
		
	}	
	
	if([News count]>0)
	{
		arrayData =[[NSArray alloc]initWithArray:News];
	} 
	
	[arrayData retain];
	[arrSearch removeAllObjects];
	[arrSearch addObjectsFromArray:arrayData];
	[tblNews performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
	[autoReleasePool release];
	
	if ([Twitter count]!=0) 
	{
		tblTweets = [[UITableView alloc]initWithFrame:CGRectMake(40,70,1000,600) style:UITableViewStylePlain];
		[tblTweets setDelegate:self];
		[tblTweets setDataSource:self];
		[tblTweets setHidden:YES];
		[tblTweets setSeparatorColor:[UIColor clearColor]];
		[tblTweets setBackgroundColor:[UIColor clearColor]];
		[contentView addSubview:tblTweets];
	}		
	[self createSegmentCtrl];
	
	
	if ([Twitter count]!=0 && [News count] == 0) 
	{
		if(arrayData)
			[arrayData release];
		[lblHeading setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.news.twitter"]];
		[contentView1 setHidden:YES];
		NSInvocationOperation *operationFetchMainData = [[NSInvocationOperation alloc] initWithTarget:self
																							 selector:@selector(fetchDataFromTwitter) 
																							   object:nil];
		[GlobalPrefrences addToOpertaionQueue:operationFetchMainData];
		[operationFetchMainData release];
		[tblNews setHidden:YES];
		[tblNews removeFromSuperview];
		[tblNews release];
		tblNews = nil;
		[tblTweets setHidden:NO];
		arrayData=[[NSArray alloc]initWithArray:self.arrTwitter];
		isTwitter=YES;
	}
	
	[GlobalPrefrences performSelector:@selector(dismissLoadingBar_AtBottom)];
	[pool release];
}

-(void)createSegmentCtrl
{
	NSArray *toggleItems;
	
	if([Twitter count]!=0 &&[News count]!=0)
	{
		toggleItems = [[NSArray alloc] initWithObjects:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.news.news"],[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.news.twitter"],nil];
		isOnlyNews=NO;
	}
	else if([News count]!=0)
	{
		toggleItems = [[NSArray alloc] initWithObjects:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.news.news"],nil];
		isOnlyNews=YES;
	}
	else if([Twitter count]!=0)
	{
		toggleItems = [[NSArray alloc] initWithObjects:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.news.twitter"],nil];
		isOnlyNews=YES;
	}
	else
	{
		toggleItems = [[NSArray alloc] initWithObjects:nil];
	}
	//used to set the frame of arrow button on custom HSSegmentedControl class
	isNewsSection=YES;
	
	SegmentControl_Customized *sortSegCtrl = [[SegmentControl_Customized alloc] initWithItems:toggleItems offColor:[UIColor blackColor] onColor:[UIColor grayColor]];
	[sortSegCtrl addTarget:self action:@selector(sortSegementChanged:) forControlEvents:UIControlEventValueChanged];
	
	if([Twitter count]!=0 &&[News count]!=0)
		[sortSegCtrl setFrame:CGRectMake(100, 8, 210, 30)];
	else if([News count]!=0 || [Twitter count]!=0)
		[sortSegCtrl setFrame:CGRectMake(100, 8, 105, 30)];
	else
		[sortSegCtrl setFrame:CGRectMake(100, 8, 0, 0)];
	
	
	
	
	UIView *topSortToolBar = (UIView *)[self.tabBarController.view viewWithTag:10101010];
	[topSortToolBar setHidden:NO];
	[topSortToolBar addSubview:sortSegCtrl];
	[sortSegCtrl release];
	
	[toggleItems release];
}

-(void)sortSegementChanged:(UISegmentedControl *)sender
{	
	if(tblNews)
	{
		[tblNews removeFromSuperview];
		[tblNews release];
		tblNews = nil;

	}
	
	tblNews = [[UITableView alloc]initWithFrame:CGRectMake(40,80,420,600) style:UITableViewStylePlain];
	[tblNews setDelegate:self];
	[tblNews setDataSource:self];
	[tblNews setSeparatorColor:[UIColor clearColor]];
	[tblNews setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:tblNews];
	
	UIView *topSortToolBar =  (UIView *)[contentView viewWithTag:10101010];
	[contentView bringSubviewToFront:topSortToolBar];	
	
	switch (sender.selectedSegmentIndex) {
		case 0:
		{
			if(arrayData)
				[arrayData release];
			
			if([News count]!=0)
			{
				[lblHeading setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.news.news"]];
				[tblNews setHidden:NO];
				[tblTweets setHidden:YES];
				isTwitter=NO;
				arrayData=[[NSArray alloc]initWithArray:News];
				[contentView1 setHidden:NO];
				
			}
			else if([Twitter count]!=0 && ([News count]==0))
			{
				if(arrayData)
					[arrayData release];
				[lblHeading setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.news.twitter"]];
				[contentView1 setHidden:YES];

				NSInvocationOperation *operationFetchMainData = [[NSInvocationOperation alloc] initWithTarget:self
																									 selector:@selector(fetchDataFromTwitter) 
																									   object:nil];
				
				[GlobalPrefrences addToOpertaionQueue:operationFetchMainData];
				[operationFetchMainData release];
				[tblNews setHidden:YES];
				[tblNews removeFromSuperview];
				[tblNews release];
				tblNews = nil;

				[tblTweets setHidden:NO];
				arrayData=[[NSArray alloc]initWithArray:self.arrTwitter];
				isTwitter=YES;
			}
			
			
			break;
		}
			
		case 1:
		{
			if(arrayData)
				[arrayData release];
			[lblHeading setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.news.twitter"]];
			[contentView1 setHidden:YES];

			NSInvocationOperation *operationFetchMainData = [[NSInvocationOperation alloc] initWithTarget:self
																								 selector:@selector(fetchDataFromTwitter) 
																								   object:nil];
			
			[GlobalPrefrences addToOpertaionQueue:operationFetchMainData];
			[operationFetchMainData release];
			[tblNews setHidden:YES];
			[tblNews removeFromSuperview];
			[tblNews release];
			tblNews = nil;

			[tblTweets setHidden:NO];
			arrayData=[[NSArray alloc]initWithArray:self.arrTwitter];
			isTwitter=YES;
			break;
		}
			
	}
	[arrSearch removeAllObjects];
	[arrSearch addObjectsFromArray:arrayData];
	
	if([arrayData count]==0)
	{
		[noItemLbl setHidden:NO];
		[tblNews setHidden:YES];
	}
	else
	{
		[noItemLbl setHidden:YES];
		[tblNews setHidden:NO];
	}
	
	
}
#pragma mark XML_Parsing

- (void)parseXMLFileAtURL:(NSString *)URL
{	
	NSAutoreleasePool* autoReleasePool = [[NSAutoreleasePool alloc] init];
	MobicartParser *customParser = [[MobicartParser alloc] initWithUrlString:URL];
	[customParser release];
	
	[autoReleasePool release];
	
	
}

#pragma mark - Parser delegate
static BOOL isErrorShowed1stTime = YES;
+(void)errorOccuredWhileParsing:(NSString *)_error
{
	if(isErrorShowed1stTime)
	{
		isErrorShowed1stTime = NO;
		UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.error.loading.title"] message:_error delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
}
#pragma mark  - Reload Table With data

+(void)reloadTableWithArray:(NSArray *)_arrTemp
{
	stories = [_arrTemp copy];
	
}
#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(tableView==tblNews)
		return 150;
	else
	{
		if([arrEntriesCount count]>0)
		{
			AppRecord *appRecord = [self.arrAppRecordsAllEntries objectAtIndex:[[arrEntriesCount objectAtIndex:indexPath.row] intValue]];
			
			NSString *strText =[NSString stringWithFormat:@"<FONT COLOR=%@><font face='Helvetica-Bold' size=2.7>%@</font></FONT>", HexVAlueForsubHeadingColor, appRecord.tweetMsg];
			
			CGSize textsize = [strText sizeWithFont:font constrainedToSize:CGSizeMake(330, 400) lineBreakMode:UILineBreakModeWordWrap];
			
			
			AppRecord *appRecord1=[self.arrAppRecordsAllEntries objectAtIndex:[[arrEntriesCount objectAtIndex:indexPath.row+[arrEntriesCount count]/2] intValue]];
			NSString *strSecondTweetMsg=[NSString stringWithFormat:@"<FONT COLOR=%@><font face='Helvetica-Bold' size=2.7>%@</font></FONT>", HexVAlueForsubHeadingColor, appRecord1.tweetMsg];
			
			CGSize textsize2 = [strSecondTweetMsg sizeWithFont:font constrainedToSize:CGSizeMake(330, 400) lineBreakMode:UILineBreakModeWordWrap];
			
			int height = 0;
			
			if(textsize.height > textsize2.height)
			{
				height = textsize.height +51;
			}
			else 
			{
				height = textsize2.height +51;
			}
			NSLog(@"line height  %d  for cell %d",height,indexPath.row);
			return height;
			
		}
		else
			NSLog(@"line height  45  for cell %d",indexPath.row);
		return 72;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	if(tableView==tblNews)
		return [arrSearch count];
	else
	{
		int count = [arrEntriesCount count]/2;
		
		// ff there's no data yet, return enough rows to fill the screen
		if (count == 0)
		{
			return 1;
		}
		
		return count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
	if(tableView==tblNews)
	{
		NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.row]; 
		
		cell= (TableViewCell_Common *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if(cell==nil)
		{			
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier]autorelease];
			cell.backgroundColor = [UIColor clearColor];
			NSString *strImageURL=[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey: @"sImage"];
			NSData *dataCellImage;
			if(strImageURL!=nil )
			{
				dataCellImage  = [ServerAPI fetchBannerImage:[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey: @"sImage"]];
				
				if(dataCellImage && [[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey: @"sImage"] length]!=0)
				{
					UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageWithData:dataCellImage]];
					[img setFrame:CGRectMake(cell.contentView.frame.origin.x+10, cell.contentView.frame.origin.y+15, 80, 80)];
					[cell.contentView addSubview:img];
				}
			}
			UIImageView *imgSeprator=[[UIImageView alloc]initWithFrame:CGRectMake(5, 148, 410, 2)];
			[imgSeprator setImage:[UIImage imageNamed:@"dotted_line_02.png"]];
			[imgSeprator setBackgroundColor:[UIColor clearColor]];
			[cell addSubview:imgSeprator];
			
			UILabel *lblNewsDate = [[UILabel alloc]init];
			
			UILabel *lblNewsHeading = [[UILabel alloc]init];
			if(dataCellImage && [[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey: @"sImage"] length]!=0)
			{
				lblNewsHeading.frame = CGRectMake( 105, 10, 270, 25);
				lblNewsDate.frame = CGRectMake( 110, 115, 250, 20);
			}
			else {
				lblNewsHeading.frame = CGRectMake( 10, 10, 270, 25);
				lblNewsDate.frame = CGRectMake( 10, 115, 250, 20);
			}
			
			lblNewsHeading.backgroundColor=[UIColor clearColor];
			[lblNewsHeading setLineBreakMode:UILineBreakModeWordWrap];
			[lblNewsHeading setNumberOfLines:0];
			lblNewsHeading.textColor=headingColor;
			lblNewsHeading.font=[UIFont boldSystemFontOfSize:17.5];
			[cell addSubview:lblNewsHeading];
			
			
			lblNewsDate.backgroundColor=[UIColor clearColor];
			lblNewsDate.textColor=subHeadingColor;
			lblNewsDate.font=[UIFont boldSystemFontOfSize:10];
			NSString *strDate;
			if(!isTwitter)
			{
				if(![[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"custom"] && [[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"sTitle"])
				{
					if (!([[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"date"] isEqual:[NSNull null]]) || ([[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"date"] length] ==0))  
						
					{  
                        if([[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"date"] length]==0)
                        {
                            NSLog(@"0");
                        }else
                        {
                          strDate = [self setRequiredFormatForDate:[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"date"]];	  
                            [lblNewsDate setText:strDate];
                        }
                        
						
					}
				}
				
				else {
					strDate = [self setRequiredFormatForDate:[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"dDate2"]];
                    [lblNewsDate setText:strDate];
				}
				
				
				
				[cell addSubview:lblNewsDate]; 
				
			}
			
			if(!isTwitter)
			{
				if([[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"custom"])
				{
					UILabel *lblNewsDetail = [[UILabel alloc]init];
					if(dataCellImage && [[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey: @"sImage"] length]!=0)
					{
						lblNewsDetail.frame = CGRectMake( 105, 40, 310, 70);
					}
					else {
						lblNewsDetail.frame = CGRectMake( 10, 40, 410, 70);
					}
					lblNewsDetail.backgroundColor=[UIColor clearColor];
					[lblNewsDetail setLineBreakMode:UILineBreakModeWordWrap];
					[lblNewsDetail setNumberOfLines:0];
					lblNewsDetail.textColor=labelColor;	
					lblNewsDetail.font=[UIFont boldSystemFontOfSize:13];
					NSString *strNewsDetail = [[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"sBody"];
					
					if (([strNewsDetail isEqual:[NSNull null]]) || ([strNewsDetail length] ==0))  
						[lblNewsDetail setText:@""];
					else
						[lblNewsDetail setText:strNewsDetail];
					[cell addSubview:lblNewsDetail];
				}
				else
				{
					UIWebView *lblNewsDetail=[[UIWebView alloc]init];
					if(dataCellImage && [[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey: @"sImage"] length]!=0)
					{
						lblNewsDetail.frame = CGRectMake( 100, 40, 310, 70);
					}
					else {
						lblNewsDetail.frame = CGRectMake(5, 40, 410, 70);
					}
					[lblNewsDetail setUserInteractionEnabled:NO];
					[lblNewsDetail setOpaque:0];
					[lblNewsDetail setBackgroundColor:[UIColor clearColor]];	
					
                        
                    NSString *temp=[NSString new]; 
                    temp=[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"summary"];
                        
                    if ([temp rangeOfString:@"src=\""].location== NSNotFound) 
                    {
                        
                    }
                    else{  
                        if([temp rangeOfString:@"src=\"http"].location== NSNotFound)
                        {
                            temp= [temp stringByReplacingOccurrencesOfString:@"src=\""
                                                                                      withString:@"src=\"http:"];     }
                        else
                        {
                            
                        }
                        
                    }
                    

					NSString *FeedsDetail = [NSString stringWithFormat:@"<html><head><style type='text/css'>body { color:%@;}</style></head><body><font face='Helvetica-Bold' size=2.65>%@</font></body></html>",HexVAlueForLabelColor, temp];
					[lblNewsDetail loadHTMLString:FeedsDetail baseURL:nil];
					[cell addSubview:lblNewsDetail];
				}
				
				
			}
			if(!isTwitter)
			{
				if(![[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"sTitle"] isEqual:[NSNull null]])
					if(![[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"sTitle"] length]==0)
						lblNewsHeading.text = [[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey: @"sTitle"];
				
				if (isSearchClicked)
				{
					NSData *dataCellImage  = [ServerAPI fetchBannerImage:[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey: @"sImage"]];
					if(dataCellImage && [[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey: @"sImage"] length]!=0)
					{
						UIImageView *img1 = [[UIImageView alloc] initWithImage:[UIImage imageWithData:dataCellImage]];
						[img1 setFrame:CGRectMake(cell.contentView.frame.origin.x+10, cell.contentView.frame.origin.y+16, 80, 80)];
						[cell.contentView addSubview:img1];
					}
				}
				
				[lblNewsHeading release];
			}
		}
		[cell setAccessoryType:UITableViewCellAccessoryNone];	
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
		
		if(indexPath.row >= 0 && !isRowSelected)
		{
			isRowSelected = YES;
			if(contentView1)
			{
				[contentView1 removeFromSuperview];
				[contentView1 release];
				contentView1 = nil;

				
			}
			contentView1 = [[UIView alloc]initWithFrame:CGRectMake(545,60,440,600)];
			[contentView1 setBackgroundColor:[UIColor clearColor]];
			[contentView addSubview:contentView1];
			
			if(!isTwitter)
			{
				
				if([[[arrSearch objectAtIndex:0] valueForKey:@"type"] isEqualToString:@"custom"])
				{
					[self tblNewsDetails:[[[arrSearch objectAtIndex:0] valueForKey:@"value"] valueForKey:@"sTitle"] :[[[arrSearch objectAtIndex:0] valueForKey:@"value"] valueForKey:@"sBody"]: [[[arrSearch objectAtIndex:0] valueForKey:@"value"] valueForKey:@"dDate2"]];
				}
				else
				{
					[self tblTwtDetails:[[[arrSearch objectAtIndex:0] valueForKey:@"value"] valueForKey:@"sTitle"] :[[[arrSearch objectAtIndex:0] valueForKey:@"value"] valueForKey:@"summary"] :[[[arrSearch objectAtIndex:0] valueForKey:@"value"] valueForKey:@"date"]];
				}
			}
		}
		
	}
	else if(tableView == tblTweets)
	{
		NSString *CellIdentifier = [NSString stringWithFormat:@"LazyTableCell%d%d",indexPath.row, indexPath.row];
		static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
		
		// add a placeholder cell while waiting on table data
		int nodeCount = [arrEntriesCount count];
		
		if (nodeCount == 0 && indexPath.row == 0)
		{ 
			cell = [tblTweets dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
			if (cell == nil)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
											   reuseIdentifier:PlaceholderCellIdentifier] autorelease];   
				cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			cell.detailTextLabel.text = @"Loading…";
			cell.detailTextLabel.textColor = labelColor;
			
			
			return cell;
		}
		cell = [tblTweets dequeueReusableCellWithIdentifier:CellIdentifier];
		
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.backgroundColor = [UIColor clearColor];
		
		if (nodeCount>0) 
		{
			UIImageView *imgTwitter = [[UIImageView alloc]initWithFrame:CGRectMake( 10, 12, 66, 66)];
			[imgTwitter setTag:212121];
			[imgTwitter setBackgroundColor:[UIColor clearColor]];
			[imgTwitter layer].masksToBounds = YES;
			[imgTwitter layer].cornerRadius = 10.0;
			[cell addSubview:imgTwitter];
			[imgTwitter release];
			
			UIImageView *imgTwitterTwo = [[UIImageView alloc]initWithFrame:CGRectMake( 510, 12, 66, 66)];
			[imgTwitterTwo setTag:31313131];
			[imgTwitterTwo setBackgroundColor:[UIColor clearColor]];
			[imgTwitterTwo layer].masksToBounds = YES;
			[imgTwitterTwo layer].cornerRadius = 10.0;
			[cell addSubview:imgTwitterTwo];
			[imgTwitterTwo release];
			
			UILabel* twitterName = [[UILabel alloc]initWithFrame:CGRectMake(105, 14, 250, 20)];
			[twitterName setBackgroundColor:[UIColor clearColor]];
			[twitterName setFont:font1];
			[twitterName setTextColor:headingColor];
			[twitterName setUserInteractionEnabled:NO];
			[twitterName setTag:1010101010];
			[cell addSubview:twitterName];
			[twitterName release];
			twitterName = nil;
			
			UIWebView *twitterText=[[UIWebView alloc]initWithFrame:CGRectMake(130, 29 , 250, 50)];
			[twitterText setOpaque:0];
			[twitterText setBackgroundColor:[UIColor clearColor]];	
			[twitterText setUserInteractionEnabled:NO];
			[twitterText setTag:0101010101];
			[cell addSubview:twitterText];	
			[twitterText release];
			twitterText = nil;
			
			UIWebView *twitterTextTwo=[[UIWebView alloc]initWithFrame:CGRectMake(630, 29 , 250, 50)];
			[twitterTextTwo setOpaque:0];
			[twitterTextTwo setBackgroundColor:[UIColor clearColor]];	
			[twitterTextTwo setUserInteractionEnabled:NO];
			[twitterTextTwo setTag:1111111];
			[cell addSubview:twitterTextTwo];	
			[twitterTextTwo release];
			twitterText = nil;
			
			UILabel* twitterNameTwo = [[UILabel alloc]initWithFrame:CGRectMake(605, 14, 250, 20)];
			[twitterNameTwo setBackgroundColor:[UIColor clearColor]];
			[twitterNameTwo setFont:font1];
			[twitterNameTwo setTextColor:headingColor];
			[twitterNameTwo setUserInteractionEnabled:NO];
			[twitterNameTwo setTag:9999999];
			[cell addSubview:twitterNameTwo];
			[twitterNameTwo release];
			twitterNameTwo = nil;
			
			UILabel *lblNewsDate = [[UILabel alloc]init];
			[lblNewsDate setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
			[lblNewsDate setTag:44004400];
			lblNewsDate.backgroundColor=[UIColor clearColor];
			lblNewsDate.textColor=subHeadingColor;
			[cell addSubview:lblNewsDate]; 
			
			UILabel *lblNewsDatetwo = [[UILabel alloc]init];
			[lblNewsDatetwo setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
			[lblNewsDatetwo setTag:00440044];
			lblNewsDatetwo.backgroundColor=[UIColor clearColor];
			lblNewsDatetwo.textColor=subHeadingColor;
			[cell addSubview:lblNewsDatetwo]; 
			
		}
		
		
		
		if (nodeCount > 0)
		{
			// Set up the cell...
			AppRecord *appRecord = [self.arrAppRecordsAllEntries objectAtIndex:[[arrEntriesCount objectAtIndex:indexPath.row] intValue]];
			
			AppRecord *appRecord1=[self.arrAppRecordsAllEntries objectAtIndex:[[arrEntriesCount objectAtIndex:indexPath.row+[arrEntriesCount count]/2] intValue]];
			
			NSString *strText =[NSString stringWithFormat:@"<FONT COLOR=%@><font face='Helvetica-Bold' size=2.5>%@</font></FONT>", HexVAlueForLabelColor, appRecord.tweetMsg];
			NSString *strSecondTweetMsg=[NSString stringWithFormat:@"<FONT COLOR=%@><font face='Helvetica-Bold' size=2.5>%@</font></FONT>", HexVAlueForLabelColor, appRecord1.tweetMsg];
			
			CGSize textsize = [strText sizeWithFont:font constrainedToSize:CGSizeMake(330, 400) lineBreakMode:UILineBreakModeWordWrap];
			CGSize textsize2 = [strSecondTweetMsg sizeWithFont:font constrainedToSize:CGSizeMake(330, 400) lineBreakMode:UILineBreakModeWordWrap];
			
			UIImageView *imgTwitter = (UIImageView *)[cell viewWithTag:212121];
			[imgTwitter setBackgroundColor:[UIColor clearColor]];
			
			UIImageView *imgTwitterTwo = (UIImageView *)[cell viewWithTag:31313131];
			[imgTwitterTwo setBackgroundColor:[UIColor clearColor]];
			
			UILabel *lblTwitterName = (UILabel *) [cell viewWithTag:1010101010];
			[lblTwitterName setText:appRecord.tweetSenderName];
			
			UILabel *lblTwitterNameTwo = (UILabel *) [cell viewWithTag:9999999];
			[lblTwitterNameTwo setText:appRecord1.tweetSenderName];
			
			UIWebView *txtTwitterText = (UIWebView *)[cell viewWithTag:0101010101];
			[txtTwitterText setFrame:CGRectMake(100, 34, 330, textsize.height)];
			NSString *tweetDetails = [self findString:strText];
			[txtTwitterText loadHTMLString:tweetDetails baseURL:nil];
			
			
			UIWebView *txtTwitterTextTwo = (UIWebView *)[cell viewWithTag:1111111];
			[txtTwitterTextTwo setFrame:CGRectMake(597, 34, 330, textsize2.height)];
			NSString *tweetDetailsTwo = [self findString:strSecondTweetMsg];
			[txtTwitterTextTwo loadHTMLString:tweetDetailsTwo baseURL:nil];
			
			
			// Only load cached images; defer new downloads until scrolling ends
			if (!appRecord1.appIcon)
			{
				if (tableView.dragging == NO && tableView.decelerating == NO)
				{
					[self startIconDownload1:appRecord1 forIndexPath:indexPath];
				}
				// if a download is deferred or in progress, return a placeholder image
				[imgTwitterTwo setImage:[UIImage imageNamed:@"Placeholder.png"]];
			}
			else
			{
				[imgTwitterTwo setImage: appRecord1.appIcon];
			}
			
			if (!appRecord.appIcon)
			{
				if (tableView.dragging == NO && tableView.decelerating == NO)
				{
					
					[self startIconDownload:appRecord forIndexPath:indexPath];
				}
				// if a download is deferred or in progress, return a placeholder image
				[imgTwitter setImage:[UIImage imageNamed:@"Placeholder.png"]];
				
			}
			else
			{
				[imgTwitter setImage: appRecord.appIcon];
			}
			
			int j = 0;
			
			if([arrEntriesCount count]>0)
			{
				AppRecord *appRecord = [self.arrAppRecordsAllEntries objectAtIndex:[[arrEntriesCount objectAtIndex:indexPath.row] intValue]];
				
				NSString *strText =[NSString stringWithFormat:@"<FONT COLOR=%@><font face='Helvetica-Bold' size=2.7>%@</font></FONT>", HexVAlueForLabelColor, appRecord.tweetMsg];
				
				CGSize textsize = [strText sizeWithFont:font constrainedToSize:CGSizeMake(330, 400) lineBreakMode:UILineBreakModeWordWrap];
				
				
				AppRecord *appRecord1=[self.arrAppRecordsAllEntries objectAtIndex:[[arrEntriesCount objectAtIndex:indexPath.row+[arrEntriesCount count]/2] intValue]];
				
				NSString *strSecondTweetMsg=[NSString stringWithFormat:@"<FONT COLOR=%@><font face='Helvetica-Bold' size=2.7>%@</font></FONT>", HexVAlueForLabelColor, appRecord1.tweetMsg];
				
				
				CGSize textsize2 = [strSecondTweetMsg sizeWithFont:font constrainedToSize:CGSizeMake(330, 400) lineBreakMode:UILineBreakModeWordWrap];
				
				
				
				if(textsize.height > textsize2.height)
				{
					j = textsize.height +49;
				}
				else 
				{
					j = textsize2.height +49;
				}
				
			}
			else
			{
				j= 69;
			}
			
			
			NSDate *Datetoday = [NSDate date];
			NSString *date1 = [self setRequiredFormatForTweeetDate:appRecord.tweetDate];
			NSString *date2 = [self setRequiredFormatForTweeetDate:appRecord1.tweetDate];
			
		    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			NSDate *prevday1 = [formatter dateFromString:date1];	
			NSDate *prevday2 = [formatter dateFromString:date2];
		    NSString *displayString = [formatter stringFromDate:Datetoday];
			NSDate *curday = [formatter dateFromString:displayString];
			
			
			NSCalendar *gregorian = [[NSCalendar alloc] 
									 initWithCalendarIdentifier:NSGregorianCalendar];	
		    NSUInteger unitFlags = NSYearCalendarUnit |NSMonthCalendarUnit| NSDayCalendarUnit| NSHourCalendarUnit|NSMinuteCalendarUnit |NSSecondCalendarUnit;	
		    NSDateComponents *components1 = [gregorian components:unitFlags 
														 fromDate:prevday1 toDate:curday options:0];
			NSInteger day1 = [components1 day];
			NSInteger hours1 = [components1 hour];
			
			NSDateComponents *components2 = [gregorian components:unitFlags 
														 fromDate:prevday2 toDate:curday options:0];
			NSInteger day2 = [components2 day];
			NSInteger hours2 = [components2 hour];	
			
			NSString *timeDiff1;
			NSString *timeDiff2;
			
			if(day1 > 1)
			{
				timeDiff1 = [NSString stringWithFormat:@"%d Days Ago", day1];
			}
			else
			{
				timeDiff1 = [NSString stringWithFormat:@"%d Hours Ago", hours1];
			}
			if(day2 > 1)
			{
				timeDiff2 = [NSString stringWithFormat:@"%d Days Ago", day2];
			}
			else
			{
				timeDiff2 = [NSString stringWithFormat:@"%d Hours Ago", hours2];
			}
			
			UILabel *lblNewsDate = (UILabel *) [cell viewWithTag:44004400];
			lblNewsDate.frame = CGRectMake( 104, j-25, 250, 20);
			
			[lblNewsDate setText:timeDiff1];
			
			UILabel *lblNewsDatetwo = (UILabel *) [cell viewWithTag:00440044];
			lblNewsDatetwo.frame = CGRectMake( 604, j-25, 250, 20);
			
			[lblNewsDatetwo setText:timeDiff2];
			
			NSLog(@"line height cell for row %d  for cell %d",j,indexPath.row);
			
			UIImageView *imgSeprator=[[UIImageView alloc]initWithFrame:CGRectMake(5, j, 420, 2)];
			[imgSeprator setImage:[UIImage imageNamed:@"dotted_line_02.png"]];
			[imgSeprator setBackgroundColor:[UIColor clearColor]];
			[cell addSubview:imgSeprator];
			
			UIImageView *imgSeprator4=[[UIImageView alloc]initWithFrame:CGRectMake(496, j, 420, 2)];
			[imgSeprator4 setImage:[UIImage imageNamed:@"dotted_line_02.png"]];
			[imgSeprator4 setBackgroundColor:[UIColor clearColor]];
			[cell addSubview:imgSeprator4];
		}
	}
	return cell;
}



-(NSString*)findString:(NSString*)str
{
	NSString *strResult;
	str=[str stringByAppendingFormat:@" "];
	
	NSMutableArray *arrAtTheRate=[[NSMutableArray alloc] init];
	NSMutableArray *arrHash=[[NSMutableArray alloc] init];
	NSMutableArray *arrRest = [[NSMutableArray alloc] init];
	for (int i=0; i<str.length; i++)
	{
		if ([str characterAtIndex:i]=='h')
		{
			if ([str characterAtIndex:i+1]=='t')
			{
                if ([str characterAtIndex:i+2]=='t')
				{
					if ([str characterAtIndex:i+3]=='p')
					{
						NSString *temp=[str substringFromIndex:i];
						if ([temp rangeOfString:@" "].length) 
						{
							int beg=[temp rangeOfString:@" "].location;
							NSString *st2=[temp substringToIndex:beg];
							if ([st2 characterAtIndex:st2.length-1]==':'||[st2 characterAtIndex:st2.length-1]==','||[st2 characterAtIndex:st2.length-1]==')'||[st2 characterAtIndex:st2.length-1]=='\''||[st2 characterAtIndex:st2.length-1]=='?'||[st2 characterAtIndex:st2.length-1]=='.'||[st2 characterAtIndex:st2.length-1]=='-') 
							{
								st2=[st2 substringToIndex:st2.length-1];
							}
							[arrHash addObject:st2];
						}
					}
				}
			}
		}
		
		else if ([str characterAtIndex:i]=='@')
		{
			NSString *temp=[str substringFromIndex:i];
			if ([temp rangeOfString:@" "].length) 
			{
				int beg=[temp rangeOfString:@" "].location;
				NSString *st2=[temp substringToIndex:beg];
				if ([st2 characterAtIndex:st2.length-1]==':'||[st2 characterAtIndex:st2.length-1]==','||[st2 characterAtIndex:st2.length-1]==')'||[st2 characterAtIndex:st2.length-1]=='\''||[st2 characterAtIndex:st2.length-1]=='?'||[st2 characterAtIndex:st2.length-1]=='.'||[st2 characterAtIndex:st2.length-1]=='-') 
				{
					st2=[st2 substringToIndex:st2.length-1];
				}
				[arrAtTheRate addObject:st2];
			}
		}
		else
		{
			NSString *temp=[str substringFromIndex:i];
			if ([temp rangeOfString:@" "].length) 
			{
				int beg=[temp rangeOfString:@" "].location;
				NSString *st2=[temp substringToIndex:beg];
				if ([st2 characterAtIndex:st2.length-1]==':'||[st2 characterAtIndex:st2.length-1]==','||[st2 characterAtIndex:st2.length-1]==')'||[st2 characterAtIndex:st2.length-1]=='\''||[st2 characterAtIndex:st2.length-1]=='?'||[st2 characterAtIndex:st2.length-1]=='.'||[st2 characterAtIndex:st2.length-1]=='-') 
				{
					st2=[st2 substringToIndex:st2.length-1];
				}
				[arrRest addObject:st2];
			}
		}
	} 
	for (int i=0; i<[arrHash count]; i++)
	{
		NSString *strReplace=[NSString stringWithFormat:@"<FONT COLOR =%@>%@</FONT>",HexVAlueForsubHeadingColor,[arrHash objectAtIndex:i]];
		str=[str stringByReplacingOccurrencesOfString:[arrHash objectAtIndex:i] withString:strReplace];
	}
	for (int i=0; i<[arrAtTheRate count]; i++)
	{
		NSString *strReplace=[NSString stringWithFormat:@"<FONT COLOR =%@>%@</FONT>",HexVAlueForsubHeadingColor,[arrAtTheRate objectAtIndex:i]];
		str=[str stringByReplacingOccurrencesOfString:[arrAtTheRate objectAtIndex:i] withString:strReplace];
	}
	for (int i=0; i<[arrRest count]; i++)
	{
		NSString *strReplace=[NSString stringWithFormat:@"%@",[arrRest objectAtIndex:i]];
		str=[str stringByReplacingOccurrencesOfString:[arrRest objectAtIndex:i] withString:strReplace];
	}
	[arrHash release];
	[arrAtTheRate release];
	[arrRest release ];
	strResult=str;
	
	return strResult;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"%d", indexPath.row);
	
	if(tableView==tblNews)
	{
		if(contentView1)
		{
			[contentView1 removeFromSuperview];
			[contentView1 release];
			contentView1 = nil;
		}
		contentView1 = [[UIView alloc]initWithFrame:CGRectMake(545,60,420,600)];
		[contentView1 setBackgroundColor:[UIColor clearColor]];
		[contentView addSubview:contentView1];
		
		if(!isTwitter)
		{
			
			if([[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"custom"])
			{
				[self tblNewsDetails:[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"sTitle"] :[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"sBody"]: [[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"dDate2"]];
			}
			else
			{
				[self tblTwtDetails:[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"sTitle"] :[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"summary"] :[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"date"]];
			}
		}
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}


-(void)tblNewsDetails: (NSString *)strNewsTitle :(NSString *)strNewsDetail :(NSString *)str_Date
{
	UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,440,600)];
	[scrollView setContentSize:CGSizeMake(440,600)];
	scrollView.backgroundColor=[UIColor clearColor];
	[contentView1 addSubview:scrollView];
	
	UILabel *lblNewsTitle = [[UILabel alloc]initWithFrame:CGRectMake(3,3,410,100)];
	lblNewsTitle.backgroundColor=[UIColor clearColor];
	[lblNewsTitle setLineBreakMode:UILineBreakModeWordWrap];
	[lblNewsTitle setNumberOfLines:0];
	lblNewsTitle.textColor=headingColor;
	[lblNewsTitle setFont:[UIFont boldSystemFontOfSize:22]];
	
	if (([strNewsTitle isEqual:[NSNull null]]) || ([strNewsTitle length] ==0))  
		[lblNewsTitle setText:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.news.news"]];
	else
		[lblNewsTitle setText:strNewsTitle];
	
	[scrollView addSubview:lblNewsTitle];
	
	CGRect frame = [lblNewsTitle frame];
	CGSize size = [lblNewsTitle.text sizeWithFont:lblNewsTitle.font
								constrainedToSize:CGSizeMake(frame.size.width, 9999)
									lineBreakMode:UILineBreakModeWordWrap];
	frame.size.height = size.height;
	[lblNewsTitle setFrame:frame];
	
	CGSize size1=[strNewsDetail sizeWithFont:[UIFont systemFontOfSize:12.00] constrainedToSize:CGSizeMake(440,400) lineBreakMode:UILineBreakModeWordWrap];
	int x=size1.height;
		
	UILabel *lblNewsDetail = [[UILabel alloc]initWithFrame:CGRectMake( 5, lblNewsTitle.frame.origin.y+lblNewsTitle.frame.size.height+10, 440, x+20)];
	lblNewsDetail.backgroundColor=[UIColor clearColor];
	[lblNewsDetail setLineBreakMode:UILineBreakModeWordWrap];
	[lblNewsDetail setNumberOfLines:0];
	lblNewsDetail.textColor=labelColor;
	lblNewsDetail.font=[UIFont fontWithName:@"Helvetica" size:13];
	
	if (([strNewsDetail isEqual:[NSNull null]]) || ([strNewsDetail length] ==0))  
		[lblNewsDetail setText:@""];
	else
		[lblNewsDetail setText:strNewsDetail];
	
	
	[scrollView addSubview:lblNewsDetail];
	
	frame = [lblNewsDetail frame];
	size = [lblNewsDetail.text sizeWithFont:lblNewsDetail.font
						  constrainedToSize:CGSizeMake(frame.size.width, 9999)
							  lineBreakMode:UILineBreakModeWordWrap];
	frame.size.height = size.height;
	[lblNewsDetail setFrame:frame];
	
	UILabel *lblNewsDate = [[UILabel alloc]initWithFrame:CGRectMake( 5, lblNewsDetail.frame.origin.y+lblNewsDetail.frame.size.height, 250, 40)];
	lblNewsDate.backgroundColor=[UIColor clearColor];
	lblNewsDate.textColor=subHeadingColor;
	lblNewsDate.font=[UIFont boldSystemFontOfSize:10];
	if([str_Date length]==0){
        
    }else 
    {
        NSString *strDate = [self setRequiredFormatForDate:str_Date];
        [lblNewsDate setText:strDate];
        [scrollView addSubview:lblNewsDate];
    }
	
	
	
	[scrollView setContentSize:CGSizeMake( 440, lblNewsDate.frame.origin.y+lblNewsDate.frame.size.height+10)];
	
}




-(void)tblTwtDetails: (NSString *)strFeedsTitle :(NSString *)strFeedsDetail :(NSString *)strFeedsDate
{
	
	UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,440,630)];
	[scrollView setContentSize:CGSizeMake(420,600)];
	scrollView.backgroundColor=[UIColor clearColor];
	[contentView1 addSubview:scrollView];
	
	if(strFeedsDetail)
	{
	}	
	UILabel *lblFeedsTitle = [[UILabel alloc]initWithFrame:CGRectMake(3,3,430,100)];
	[lblFeedsTitle setBackgroundColor:[UIColor clearColor]];
	[lblFeedsTitle setLineBreakMode:UILineBreakModeWordWrap];
	[lblFeedsTitle setNumberOfLines:0];
	lblFeedsTitle.textColor=headingColor;
	[lblFeedsTitle setFont:[UIFont boldSystemFontOfSize:22]];
	
	[lblFeedsTitle setText:strFeedsTitle];
	
	[scrollView addSubview:lblFeedsTitle];
	
	CGRect frame = [lblFeedsTitle frame];
	CGSize size = [lblFeedsTitle.text sizeWithFont:lblFeedsTitle.font
								 constrainedToSize:CGSizeMake(frame.size.width, 9999)
									 lineBreakMode:UILineBreakModeWordWrap];
	frame.size.height = size.height;
	[lblFeedsTitle setFrame:frame];	
	
		
	
	lblNewsDetail=[[UIWebView alloc]initWithFrame:CGRectMake(  0, lblFeedsTitle.frame.origin.y+lblFeedsTitle
																		.frame.size.height, 440, 500)];
	[lblNewsDetail setOpaque:0];
	[lblNewsDetail setBackgroundColor:[UIColor clearColor]];	
	[scrollView setBackgroundColor:[UIColor clearColor]];
    
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
    
	NSString *FeedsDetail = [NSString stringWithFormat:@"<html><head><style type='text/css'>body { color:%@;}</style></head><body><font face='Helvetica' size=2.95>%@</font></body></html>",HexVAlueForLabelColor,  strFeedsDetail];
	[lblNewsDetail loadHTMLString:FeedsDetail baseURL:nil];
	[scrollView addSubview:lblNewsDetail];
	
	UILabel *lblNewsDate = [[UILabel alloc]initWithFrame:CGRectMake( 5, lblNewsDetail.frame.origin.y+lblNewsDetail.frame.size.height, 250, 40)];
	lblNewsDate.backgroundColor=[UIColor clearColor];
	lblNewsDate.textColor=subHeadingColor;
	lblNewsDate.font=[UIFont boldSystemFontOfSize:10];
	NSString *strDate;
	if(strFeedsTitle)
	{   if(strFeedsDate.length==0){
        
    }else {
        strDate = [self setRequiredFormatForDate:[[strFeedsDate componentsSeparatedByString:@"+"] objectAtIndex:0]];
        [lblNewsDate setText:strDate];
    }
		
	}
	else 
	{
		strDate = [self setRequiredFormatForCurrentDate:[NSDate date]];
        [lblNewsDate setText:strDate];
	}
	
	
	[contentView1 addSubview:lblNewsDate];
	frame.origin.y=lblNewsDate.frame.origin.y+lblNewsDate.frame.size.height+15;
	[scrollView setContentSize:CGSizeMake( 440, lblNewsDetail.frame.origin.y+lblNewsDetail.frame.size.height+10)];
	
}

-(NSString *)setRequiredFormatForDate:(NSString *)strDate
{
	NSString *day = [strDate substringWithRange:NSMakeRange(5,2)];				
	NSString *month = [strDate substringWithRange:NSMakeRange(8,3)];				
	NSString *year = [strDate substringWithRange:NSMakeRange(12,4)];
	int iMonth=0;
	if ([month isEqualToString:@"Jan"]) 
		iMonth=1;
	else if([month isEqualToString:@"Feb"])
		iMonth=2;
	else if([month isEqualToString:@"Mar"])
		iMonth=3;
	else if([month isEqualToString:@"Apr"])
		iMonth=4;
	else if([month isEqualToString:@"May"])
		iMonth=5;
	else if([month isEqualToString:@"Jun"])
		iMonth=6;
	else if([month isEqualToString:@"Jul"])
		iMonth=7;
	else if([month isEqualToString:@"Aug"])
		iMonth=8;
	else if([month isEqualToString:@"Sep"])
		iMonth=9;
	else if([month isEqualToString:@"Oct"])
		iMonth=10;
	else if([month isEqualToString:@"Nov"])
		iMonth=11;
	else if([month isEqualToString:@"Dec"])
		iMonth=12;
	
	NSCalendar *calendar=[NSCalendar currentCalendar];
	
	NSDateComponents *dateComponents=[[NSDateComponents alloc] init];
	[dateComponents setDay:[day integerValue]];
	[dateComponents setMonth:iMonth];
	[dateComponents setYear:[year integerValue]];
	
	NSDate *date=[calendar dateFromComponents:dateComponents];
	
	
	NSDateFormatter *prefixDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[prefixDateFormatter setDateFormat:@"EEEE d"];
	
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
	[formatSuffix setDateFormat:@"MMMM"];
	NSString *suffix1=[formatSuffix stringFromDate:date];
	suffix1=[suffix1 uppercaseString];
	
	[suffix1 capitalizedString];
	
	NSString *strDateFinal=[NSString stringWithFormat:@"%@ %@",dateString,suffix1];
	return strDateFinal;
}


-(NSString *)setRequiredFormatForCurrentDate:(NSDate *)strDate
{
	
	NSDate *date = strDate;
	NSDateFormatter *prefixDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[prefixDateFormatter setDateFormat:@"EEEE d"];
	
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
	[formatSuffix setDateFormat:@"MMMM"];
	NSString *suffix1=[formatSuffix stringFromDate:date];
	suffix1=[suffix1 uppercaseString];
	[suffix1 capitalizedString];
	
	NSString *strDateFinal=[NSString stringWithFormat:@"%@ %@",dateString,suffix1];
	return strDateFinal;
}

-(NSString *)setRequiredFormatForTweeetDate:(NSString *)strDate
{
NSDate *day= [NSDate dateWithTimeIntervalSince1970:([strDate longLongValue]/1000)];
    NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*_dateString=[_dateFormatter stringFromDate:day];
    [_dateFormatter release]; 
    
    return _dateString;
    

	/*NSString *day = [strDate substringWithRange:NSMakeRange(5,2)];				
	NSString *month = [strDate substringWithRange:NSMakeRange(8,3)];				
	NSString *year = [strDate substringWithRange:NSMakeRange(12,4)];
	NSString *hr =  [strDate substringWithRange:NSMakeRange(17,2)];
	NSString *min = [strDate substringWithRange:NSMakeRange(20,2)];
	NSString *sec = [strDate substringWithRange:NSMakeRange(23,2)];
	int iMonth=0;
	if ([month isEqualToString:@"Jan"]) 
		iMonth=1;
	else if([month isEqualToString:@"Feb"])
		iMonth=2;
	else if([month isEqualToString:@"Mar"])
		iMonth=3;
	else if([month isEqualToString:@"Apr"])
		iMonth=4;
	else if([month isEqualToString:@"May"])
		iMonth=5;
	else if([month isEqualToString:@"Jun"])
		iMonth=6;
	else if([month isEqualToString:@"Jul"])
		iMonth=7;
	else if([month isEqualToString:@"Aug"])
		iMonth=8;
	else if([month isEqualToString:@"Sep"])
		iMonth=9;
	else if([month isEqualToString:@"Oct"])
		iMonth=10;
	else if([month isEqualToString:@"Nov"])
		iMonth=11;
	else if([month isEqualToString:@"Dec"])
		iMonth=12;
	
	NSCalendar *calendar=[NSCalendar currentCalendar];
	
	NSDateComponents *dateComponents=[[NSDateComponents alloc] init];
	[dateComponents setDay:[day integerValue]];
	[dateComponents setMonth:iMonth];
	[dateComponents setYear:[year integerValue]];
	[dateComponents setHour:[hr integerValue]];
	[dateComponents setMinute:[min integerValue]];
	[dateComponents setSecond:[sec integerValue]];
	
	NSDate *date=[calendar dateFromComponents:dateComponents];
	
	NSDateFormatter *prefixDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[prefixDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *strDateFinal=[prefixDateFormatter stringFromDate:date];
	return strDateFinal;*/
   
}


#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
	IconDownloader *iconDownloader;
	self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
	iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	if (iconDownloader == nil) 
	{
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
		iconDownloader.chkForindex = NO;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];   
	}
		
}

- (void)startIconDownload1:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
	IconDownloader *iconDownloader;
	self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
	iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	if (iconDownloader == nil) 
	{
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
		iconDownloader.chkForindex = YES;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];   
	}
	
	
}   

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet

- (void)loadImagesForOnscreenRows
{
    if ([self.arrAppRecordsAllEntries count] > 0)
    {
        NSArray *visiblePaths = [tblTweets indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            AppRecord *appRecord = [self.arrAppRecordsAllEntries objectAtIndex:indexPath.row];
            if (!appRecord.appIcon) // avoid the app icon download if the app already has an icon
            {
				
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
			AppRecord *appRecord1=[self.arrAppRecordsAllEntries objectAtIndex:[[arrEntriesCount objectAtIndex:indexPath.row+[arrEntriesCount count]/2] intValue]];
            if (!appRecord1.appIcon) // avoid the app icon download if the app already has an icon
            {
				
                [self startIconDownload1:appRecord1 forIndexPath:indexPath];
            }
        }
    }
}




// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath chkValue:(BOOL)chkForindex
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [tblTweets cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
         cell.imageView.image = iconDownloader.appRecord.appIcon;
        // Display the newly loaded image
		
		if(chkForindex)
		{
			UIImageView *imageIcon = (UIImageView *)[cell viewWithTag:31313131];
			[imageIcon setImage:iconDownloader.appRecord.appIcon];
		}
		else {
			UIImageView *imageIcon = (UIImageView *)[cell viewWithTag:212121];
			[imageIcon setImage:iconDownloader.appRecord.appIcon];
		}

        [tblTweets reloadData];
	}
	
	
	// Display the newly loaded image
	
	
}
// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageError:(NSIndexPath *)indexPath
{
	
}





#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}



#pragma mark -
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(560, 50, 420,2)];
	[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
	[imgHorizontalDottedLine setTag:5555];
	[contentView addSubview:imgHorizontalDottedLine];
	[imgHorizontalDottedLine setHidden:NO];
	
	[imgHorizontalDottedLine release];
	
	
	
	
	UIButton *btnCart = [[UIButton alloc]init];
	btnCart.frame = CGRectMake(903, 14, 78,34);
	[btnCart setBackgroundColor:[UIColor clearColor]];
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
	
    [super viewDidLoad];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
	NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    // Release any cached data, images, etc that aren't in use.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[contentView1 release];
	[lblHeading release];
	[arrCountTweets release];
	[arrEntriesCount release];
	[arrAppRecordsAllEntries release];
	[imageDownloadsInProgress release];
	[noItemLbl release];
	[lblCart release];
	[News release];
	[Twitter release];
	[lblNews release];
	[sortView release];
	[contentView release];
	[currentTitle release];
	[currentDate release];
	[currentSummary release];
	[currentLink release];
	[stories release];
    [super dealloc];
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
    lblNewsDetail.scalesPageToFit=YES; 
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    
    
    
    
}


@end
