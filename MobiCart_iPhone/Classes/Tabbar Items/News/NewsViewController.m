//
//  NewsViewController.m
//  MobiCart
//
//  Created by Mobicart on 7/6/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

/** The class to Show News and Tweets of Store/Mobicart**/

#import "NewsViewController.h"
#import "NewsDetail.h"
#import "Constants.h"
#import "AppRecord.h"


BOOL isOnlyNews;
BOOL isTwitter;
BOOL isOnlyTwitter;
@implementation NewsViewController
@synthesize arrTwitter,arrAppRecordsAllEntries;
@synthesize imageDownloadsInProgress;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
    {
       	self.tabBarItem.image = [UIImage imageNamed:@"news_icon.png"];
	}
    return self;
}


- (void)viewWillDisappear:(BOOL)animated
{
	isNewsSection = NO;
	[GlobalPreferences stopLoadingIndicator];
	
}
- (void)viewWillAppear:(BOOL)animated 
{ 
	[super viewWillAppear:animated];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	isNewsSection=YES;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateShoppingLabel) name:@"updateLabelNews" object:nil];
}

- (void)updateShoppingLabel
{
	lblCart.text =[NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
}

- (void)updateDataForCurrent_Navigation_And_View_Controller
{
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
}	

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	
	

	[GlobalPreferences addLoadingBar_AtBottom:self.tabBarController.view withTextToDisplay:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
	
	[GlobalPreferences startLoadingIndicator];
	
	self.navigationItem.titleView = [GlobalPreferences createLogoImage];
	
	isOnlyNews=NO;
	
	News = [[NSMutableArray alloc] init];
	
	Twitter = [[NSMutableArray alloc] init];
	
	arrTwitter = [[NSMutableArray alloc] init];
	
	arrEntriesCount = [[NSMutableArray alloc] init];
	
	arrCountTweets = [[NSMutableArray alloc] init];
	
	self.arrAppRecordsAllEntries = [[NSMutableArray alloc] init];
	
    [[FontManager sharedManager] loadFont:@"Abberancy"];
	font = [UIFont fontWithName:@"Arial" size:12];
	font1 = [UIFont fontWithName:@"Arial-BoldMT" size:15];
	
	lblCart =[[UILabel alloc] initWithFrame:CGRectMake(280, 5, 30, 34)];
	lblCart.backgroundColor = [UIColor clearColor];
	lblCart.textAlignment = UITextAlignmentCenter;
	lblCart.font = [UIFont boldSystemFontOfSize:16];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	lblCart.textColor = [UIColor whiteColor];
	
	[self.navigationController.navigationBar addSubview:lblCart];
	
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0,0,320,420)];
	self.view = contentView;
	
	UIImageView *imgBg=[[UIImageView alloc]initWithFrame:CGRectMake(0,30, 320,420)];
	[imgBg setImage:[UIImage imageNamed:@"product_details_bg.png"]];
	[contentView addSubview:imgBg];
	[imgBg release];
	
	noItemLbl=[[UILabel alloc]initWithFrame:CGRectMake( 10, 80, 310, 50)];
	noItemLbl.textColor=[UIColor whiteColor];
	[noItemLbl setFont:[UIFont boldSystemFontOfSize:14]];
	[noItemLbl setBackgroundColor:[UIColor clearColor]];
	[noItemLbl setHidden:YES];
	[contentView addSubview:noItemLbl];
	
	if (!arrSearch)
    {
        arrSearch=[[NSMutableArray alloc]init];
    }
	
	UIView *topSortToolBar=[[UIView alloc]initWithFrame:CGRectMake(0, -1, 320,40)];
    [topSortToolBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"barNews.png"]]];
    [contentView addSubview:topSortToolBar];	
	topSortToolBar.tag = 10101010;
	
	[contentView addSubview:topSortToolBar];

    tblNews = [[UITableView alloc]initWithFrame:CGRectMake(-10,30,342,344) style:UITableViewStyleGrouped];
	[tblNews setDelegate:self];
	[tblNews setDataSource:self];
	[tblNews setHidden:YES];
	[tblNews setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:tblNews];
	
	tblTweets = [[UITableView alloc]initWithFrame:CGRectMake(0,41,320,325) style:UITableViewStylePlain];
	[tblTweets setDelegate:self];
	[tblTweets setDataSource:self];
	[tblTweets setHidden:YES];
	[tblTweets setSeparatorColor:[UIColor clearColor]];
	[tblTweets setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:tblTweets];
	
	imgSegmentControllerStatus=[[UIImageView alloc]initWithFrame:CGRectMake(10,12,13,13)];
    [imgSegmentControllerStatus setImage:[UIImage imageNamed:@"news_icon_top.png"]];
    [topSortToolBar addSubview:imgSegmentControllerStatus];
	
    lblSegmentControllerSelected=[[UILabel alloc]initWithFrame:CGRectMake(30,10 , 80, 20)];
    [lblSegmentControllerSelected setBackgroundColor:[UIColor clearColor]];
	lblSegmentControllerSelected.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
	[lblSegmentControllerSelected setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.news.news"]];
    [lblSegmentControllerSelected setTextColor:[UIColor whiteColor]];
    [topSortToolBar addSubview:lblSegmentControllerSelected];

	 viewLoading=[[UIView alloc]initWithFrame:CGRectMake(0,30, 320,480)];
	[viewLoading setBackgroundColor:[UIColor whiteColor]];
	[contentView addSubview:viewLoading];
	[viewLoading setHidden:YES];
	
	
  [self performSelectorInBackground:@selector(fetchDataFromServer) withObject:nil];
	
	if ([Twitter count]!=0) 
	{
		[self fetchDataFromTwitter];
	}	
	[contentView bringSubviewToFront:topSortToolBar];
	[topSortToolBar release];
}

#pragma mark Fetch data from server
// Fetching Twitter Feed if defined for store
- (void)fetchDataFromTwitter
{
	NSAutoreleasePool* autoReleasePool = [[NSAutoreleasePool alloc] init];	
   
	NSDictionary *dictTemp = [ServerAPI fetchTwitterFeedFor:iCurrentStoreId];
	self.arrTwitter = [dictTemp objectForKey:@"results"];
	
	if ([self.arrAppRecordsAllEntries count]>0)
    {
        [self.arrAppRecordsAllEntries removeAllObjects];
    }
	
	self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
	if ([arrEntriesCount count]>0)
    {
        [arrEntriesCount removeAllObjects];
    }
	
	[self.arrTwitter retain];
	
	
    for(int i =0; i<[self.arrTwitter count] ;i++)
	{
		AppRecord *_currentRecord = [[AppRecord alloc] init];
		_currentRecord.tweetSenderName = [[self.arrTwitter objectAtIndex:i] valueForKey:@"name"];
		_currentRecord.tweetMsg = [[self.arrTwitter objectAtIndex:i] valueForKey:@"text"];
        _currentRecord.requestImg=[ServerAPI createTweetImageRequest:[[self.arrTwitter objectAtIndex:i] valueForKey:@"image"]];
		[self.arrAppRecordsAllEntries addObject:_currentRecord];
		[_currentRecord release];
		[arrEntriesCount addObject:[NSNumber numberWithInt:i]];
	}
    
    
	[arrCountTweets addObjectsFromArray:arrEntriesCount];
	
	 if ([News count]==0 &&[Twitter count]!=0)
	 {
         if (arrayData)
         {
             [arrayData release];
         }
         
        arrayData =[[NSArray alloc]initWithArray:self.arrTwitter];
        isTwitter=YES;
        isTwitterSelected=YES;
        [tblNews setHidden:YES];
        [tblNews removeFromSuperview];
        [tblTweets setHidden:NO];
	 }
	viewLoading.hidden=YES;
	[tblTweets setHidden:NO];
	[GlobalPreferences dismissLoadingBar_AtBottom];
	[tblTweets performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
	[GlobalPreferences stopLoadingIndicator];
	[autoReleasePool release];
}

// Fetch News defined for store from Mobicart server
- (void)fetchDataFromServer
{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
	NSAutoreleasePool* autoReleasePool = [[NSAutoreleasePool alloc] init];
    NSDictionary *dictTemp=[ServerAPI fetchNewsItem:iCurrentStoreId];
	
    NSArray *arrdict = [dictTemp objectForKey:@"news-items"];
	int count = [arrdict count];
	
	for (int i =0; i<count; i++)
	{
		NSDictionary *dictcontent = [arrdict objectAtIndex:i];
		NSString *strType = [[NSString alloc] init];	
		strType = [strType stringByAppendingString:[dictcontent objectForKey:@"sType"]];
		
		if ([strType isEqualToString:@"custom"])
		{
			NSDictionary *dictTemp = [NSDictionary dictionaryWithObjectsAndKeys:[arrdict objectAtIndex:i],@"value",strType,@"type",nil];
			
			[News addObject:dictTemp];
		}
		else if ([strType isEqualToString:@"feed"])
		{
			if (![[dictcontent objectForKey:@"bFeedStatus"] isEqual:[NSNull null]])
            {
                if ([[dictcontent objectForKey:@"bFeedStatus"] intValue]==1)
				{
					NSString *strFeedUrl=[NSString stringWithFormat:@"%@",[[arrdict objectAtIndex:i] valueForKey:@"sFeedUrl"]];
					[self parseXMLFileAtURL:strFeedUrl];
					for(int i=0; i<[stories count]; i++)
					{
						NSDictionary *dictTemp = [NSDictionary dictionaryWithObjectsAndKeys:[stories objectAtIndex:i],@"value",strType,@"type",nil];
						[News addObject:dictTemp];
					}
				}
            }
						
			if (![[dictcontent objectForKey:@"bTwitterStatus"] isEqual:[NSNull null]])
            {
                if ([[dictcontent objectForKey:@"bTwitterStatus"] intValue]==1)
				{
					NSDictionary *dictTemp = [NSDictionary dictionaryWithObjectsAndKeys:[arrdict objectAtIndex:i],@"value",strType,@"type",nil];
					[Twitter addObject:dictTemp];
				}
            }
		}
	}	
	if ([News count]>0)
	{
		arrayData =[[NSArray alloc]initWithArray:News];
	    [tblNews setHidden:NO];
	} 
  
   if ([News count]==0 &&[Twitter count]!=0)
   {
	   [tblTweets setHidden:NO];   
	    [lblSegmentControllerSelected setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.news.twitter"]];
	   [imgSegmentControllerStatus setImage:[UIImage imageNamed:@"twitter_icon.png"]];
	   NSInvocationOperation *operationFetchMainData = [[NSInvocationOperation alloc] initWithTarget:self	selector:@selector(fetchDataFromTwitter) object:nil];
	   
	   [GlobalPreferences addToOpertaionQueue:operationFetchMainData];
	   [operationFetchMainData release];
   }  
	
	[arrayData retain];
	[arrSearch removeAllObjects];
	[arrSearch addObjectsFromArray:arrayData];
	[tblNews performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
	[autoReleasePool release];
	
	[self createSegmentCtrl];
	[GlobalPreferences stopLoadingIndicator];
	[GlobalPreferences performSelector:@selector(dismissLoadingBar_AtBottom)];
	[pool release];
}

- (void)createSegmentCtrl
{
	
	NSArray *toggleItems;
    if ([Twitter count]!=0 &&[News count]!=0)
	{
		toggleItems = [[NSArray alloc] initWithObjects:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.news.news"],[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.news.twitter"],nil];
		isOnlyNews=NO;
	}
	else if ([News count]!=0)
	{
		toggleItems = [[NSArray alloc] initWithObjects:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.news.news"],nil];
		isOnlyNews=YES;
	}
	else if ([Twitter count]!=0)
	{
	    toggleItems = [[NSArray alloc] initWithObjects:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.news.twitter"],nil];
	}	
	else
	{
		toggleItems = [[NSArray alloc] initWithObjects:nil];
	}
	
    // Used to set the frame of arrow button on custom HSSegmentedControl class
	isNewsSection=YES;
	
    if([toggleItems count]>1)
    {
	CustomSegmentControl *sortSegCtrl = [[CustomSegmentControl alloc] initWithItems:toggleItems offColor:[UIColor colorWithRed:81.6/100 green:81.6/100 blue:81.6/100 alpha:1.0] onColor:[UIColor colorWithRed:78.6/100 green:78.3/100 blue:78.3/100 alpha:1.0]];
	
	[sortSegCtrl addTarget:self action:@selector(sortSegementChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self setTextColors:sortSegCtrl];
        
        if ([Twitter count]!=0 &&[News count]!=0)
        {
            [sortSegCtrl setFrame:CGRectMake(166, 5, 150, 30)];
        }
        else if ([News count]!=0 || [Twitter count]!=0)
        {
            [sortSegCtrl setFrame:CGRectMake(241, 5, 75, 30)];	
        }
        else
        {
            [sortSegCtrl setFrame:CGRectMake(316, 5, 0, 0)];
        }
        UIToolbar *topSortToolBar = (UIToolbar *)[contentView viewWithTag:10101010];
        [topSortToolBar addSubview:sortSegCtrl];
        [topSortToolBar addSubview:imgSegmentControllerStatus];
        [topSortToolBar addSubview:lblSegmentControllerSelected];
        [sortSegCtrl release];
        [toggleItems release];

    }
	
}

- (void)sortSegementChanged:(UISegmentedControl *)sender
{
	[self setTextColors:sender];
	
	if (tblNews)
	{
		[tblNews removeFromSuperview];
		[tblNews release];
		tblNews = nil;
	}
	tblNews = [[UITableView alloc]initWithFrame:CGRectMake(-10,30,342,344) style:UITableViewStyleGrouped];
	[tblNews setDelegate:self];
	[tblNews setDataSource:self];
	[tblNews setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:tblNews];
	
	UIToolbar *topSortToolBar =  (UIToolbar *)[contentView viewWithTag:10101010];
	[contentView bringSubviewToFront:topSortToolBar];
	
	switch (sender.selectedSegmentIndex) 
    {
		case 0:
		{
            isTwitterSelected=NO; 
            [lblSegmentControllerSelected setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.news.news"]];
			[imgSegmentControllerStatus setImage:[UIImage imageNamed:@"news_icon_top.png"]];
			if (arrayData)
            {
                [arrayData release];
            }
			
			arrayData=[[NSArray alloc]initWithArray:News];
			[tblNews setHidden:NO];
			[tblTweets setHidden:YES];
			isTwitter=NO;
			break;
		}
			
		case 1:
		{
            isTwitterSelected=YES; 
			
            [lblSegmentControllerSelected setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.news.twitter"]];
            [imgSegmentControllerStatus setImage:[UIImage imageNamed:@"twitter_icon.png"]];
            if (arrayData)
            {
                [arrayData release];
            }
			
			NSInvocationOperation *operationFetchMainData = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fetchDataFromTwitter) object:nil];
			
			[GlobalPreferences addToOpertaionQueue:operationFetchMainData];
			[operationFetchMainData release];
			
			[GlobalPreferences addLoadingBar_AtBottom:viewLoading withTextToDisplay:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
			[viewLoading setHidden:NO];
			[tblNews setHidden:YES];
			[tblNews removeFromSuperview];					
			arrayData=[[NSArray alloc]initWithArray:self.arrTwitter];
			isTwitter=YES;
			break;
		}
			
	}
	[arrSearch removeAllObjects];
	[arrSearch addObjectsFromArray:arrayData];
	
	if ([arrayData count]==0)
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
// Called to parse twitter feed
- (void)parseXMLFileAtURL:(NSString *)URL
{	
	
	NSAutoreleasePool* autoReleasePool = [[NSAutoreleasePool alloc] init];
	
	//Custom parser for RSS News/Twitter Feeds
	CustomMobicartParser *customParser = [[CustomMobicartParser alloc] initWithUrlString:URL];
	[customParser release];
	
	[autoReleasePool release];
	
	
}

#pragma mark - Parser delegate
static BOOL isErrorShowed1stTime = YES;
+(void)errorOccuredWhileParsing:(NSString *)_error
{
	if (isErrorShowed1stTime)
	{
		isErrorShowed1stTime = NO;
		UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.error.loading.title"] message:_error delegate:self cancelButtonTitle:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.nointernet.cancelbutton"] otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
}

- (void)setTextColors:(id)sender
{	
	UISegmentedControl *sg = (UISegmentedControl*)sender;
	
	int eg=0;
    for (id seg in [sg subviews]) 
    {
        int gg=sg.selectedSegmentIndex;
        if(gg==2)
            gg=0;
        else if(gg==0)
            gg=2;
        if(eg==gg && eg!=1)
        {
            for (id label in [seg subviews]) 
                if ([label isKindOfClass:[UILabel class]])
                {
                    [label setTextAlignment:UITextAlignmentCenter];
                    [label setFont:[UIFont fontWithName:@"Helvetica" size:12]];
                    [label setTextColor:[UIColor colorWithRed:57.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1]];
                }
        }
        else if(eg==1)
        {
            for (id label in [seg subviews]) 
                if ([label isKindOfClass:[UILabel class]])
                {
                    [label setTextAlignment:UITextAlignmentCenter];
                    [label setFont:[UIFont fontWithName:@"Helvetica" size:12]];
                    [label setTextColor:[UIColor colorWithRed:58.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1]];
                }
        }
        else
        {
            for (id label in [seg subviews]) 
                if ([label isKindOfClass:[UILabel class]])
                {
                    [label setTextAlignment:UITextAlignmentCenter];
					[label setFont:[UIFont fontWithName:@"Helvetica" size:12]];
                    [label setTextColor:[UIColor colorWithRed:58.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1]];
                }
        }
        eg++;
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


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch=[touches anyObject];
	
	if ([touch tapCount]==1)
    {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (tableView==tblNews)
    {
        return 55;
    }
	else
	{
		if([arrEntriesCount count]>0)
		{
			AppRecord *appRecord = [self.arrAppRecordsAllEntries objectAtIndex:[[arrEntriesCount objectAtIndex:indexPath.row] intValue]];
			
			NSString *strText =appRecord.tweetMsg;
			
			CGSize textsize = [strText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10] constrainedToSize:CGSizeMake(230, 400) lineBreakMode:UILineBreakModeWordWrap];
			return textsize.height+55;
			
			
		}
		else
        {
            return 45.0f;
        }
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	if (tableView==tblNews)
    {
        return [arrSearch count];
    }
	else
	{
		int count = [arrEntriesCount count];
		// If there's no data yet, return enough rows to fill the screen
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
			
		cell= (TableViewCell_Common*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell==nil)
		{
			cell = [[[TableViewCell_Common alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifier]autorelease];
		
			
			UIImageView *imgCellBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 342,55)];
			[imgCellBackground setImage:[UIImage imageNamed:@"store_cell_bg.png"]];
			[cell setBackgroundView:imgCellBackground];
			[imgCellBackground release];
			
			cell.backgroundColor = cellBackColor;
			
			UILabel *lblText=[[UILabel alloc]initWithFrame:CGRectMake(20,10,285,20)];
			[lblText setBackgroundColor:[UIColor clearColor]];
			[lblText setTextColor:_savedPreferences.headerColor];
			[lblText setTag:[[NSString stringWithFormat:@"00101%d",indexPath.row]intValue]];
			[lblText setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
			[cell addSubview:lblText];
			[lblText release];
			
			UIImageView *imgCellView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 45,45)];
			[imgCellView setBackgroundColor:[UIColor clearColor]];
			[imgCellView viewWithTag:[[NSString stringWithFormat:@"004%d",indexPath.row]intValue]];
			[cell addSubview:imgCellView];
			[imgCellView setHidden:YES];
			[imgCellView release];
			
			UILabel *lblDetailText=[[UILabel alloc]initWithFrame:CGRectMake(20,31,285,
																			20)];
			[lblDetailText setBackgroundColor:[UIColor clearColor]];
			[lblDetailText setTextColor:_savedPreferences.labelColor];
			[lblDetailText setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
			[lblDetailText setTag:[[NSString stringWithFormat:@"01010%d",indexPath.row]intValue]];
			[cell addSubview:lblDetailText];
			[lblDetailText release];
			
			NSString *strImageURL=[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey: @"sImage"];
			
			if (strImageURL!=nil)
			{
				NSData *dataCellImage  = [ServerAPI fetchBannerImage:[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey: @"sImage"]];
				
				if (dataCellImage && [[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey: @"sImage"] length]!=0)
				{
									
					imgCellView.image=[UIImage imageWithData:dataCellImage];
					[imgCellView setHidden:NO];
					UILabel *lblText=(UILabel *)[cell viewWithTag:[[NSString stringWithFormat:@"00101%d",indexPath.row]intValue]];
					[lblText setFrame:CGRectMake(80,10,230,20)];
					  UILabel *lblDetailCell=(UILabel *)[cell viewWithTag:[[NSString stringWithFormat:@"01010%d",indexPath.row]intValue]];  
					[lblDetailCell setFrame:CGRectMake(80,31,230,
													   20)];

				}
			}
			 
		}
		if (!isTwitter)
		{
			if (![[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"sTitle"] isEqual:[NSNull null]])
            {
                if (![[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"sTitle"] length]==0)
				{
					UILabel *lblText=(UILabel *)[cell viewWithTag:[[NSString stringWithFormat:@"00101%d",indexPath.row]intValue]];
				   
					lblText.text=[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey: @"sTitle"];					
					
				}
            }
				
            if ([[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"feed"])
            {
				if (![[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"date"] length]==0)
				{
					NSArray *dateComponenentsTemp=[[[[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"date"]componentsSeparatedByString:@"+" ]objectAtIndex:0]componentsSeparatedByString:@" "];
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
					}
					else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"Mar"]) 
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
				    UILabel *lblDetailCell=(UILabel *)[cell viewWithTag:[[NSString stringWithFormat:@"01010%d",indexPath.row]intValue]];  
					lblDetailCell.text=strDateFinal;
					
					
				}
			}
			else {
				
				NSArray *dateComponenentsTemp=[[[[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"dDate2"]componentsSeparatedByString:@"+" ]objectAtIndex:0]componentsSeparatedByString:@" "];
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
				}
				else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"Mar"]) 
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
				UILabel *lblDetailCell=(UILabel *)[cell viewWithTag:[[NSString stringWithFormat:@"01010%d",indexPath.row]intValue]];  
				lblDetailCell.text=strDateFinal;
				
			}

			if (isSearchClicked)
			{
				NSData *dataCellImage  = [ServerAPI fetchBannerImage:[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey: @"sImage"]];
               
				if (dataCellImage && [[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey: @"sImage"] length]!=0)
				{
					UIImageView *imgView=(UIImageView *)[cell viewWithTag:[[NSString stringWithFormat:@"004%d",indexPath.row]intValue]];
					imgView.image=[UIImage imageWithData:dataCellImage];
					[imgView setHidden:NO];
					UILabel *lblText=(UILabel *)[cell viewWithTag:[[NSString stringWithFormat:@"00101%d",indexPath.row]intValue]];
					[lblText setFrame:CGRectMake(80,10,230,20)];
					UILabel *lblDetailCell=(UILabel *)[cell viewWithTag:[[NSString stringWithFormat:@"01010%d",indexPath.row]intValue]];  
					[lblDetailCell setFrame:CGRectMake(80,31,230,20)];
					
				}
			}
		}
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];	
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	}
	else if (tableView == tblTweets)
	{
		NSString *CellIdentifier = [NSString stringWithFormat:@"LazyTableCell%d%d",indexPath.row, indexPath.row];
		
		// Add a placeholder cell while waiting on table data
		int nodeCount = [arrEntriesCount count];
				
		cell = [tblTweets dequeueReusableCellWithIdentifier:CellIdentifier];
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
		// Setting gradient effect on view
		if (nodeCount>0) 
		{
			AppRecord *appRecord = [self.arrAppRecordsAllEntries objectAtIndex:[[arrEntriesCount objectAtIndex:indexPath.row] intValue]];
			
			NSString *strText =appRecord.tweetMsg;
			
			CGSize textsize = [strText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10] constrainedToSize:CGSizeMake(230, 400) lineBreakMode:UILineBreakModeWordWrap];
			int cellHeight=textsize.height;
			cellHeight=cellHeight+55;
			
			
			UIImageView *imgCellBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 342,cellHeight+55)];
			[imgCellBackground setImage:[UIImage imageNamed:@"shoppingcart_bar_stan.png"]];
			[cell setBackgroundView:imgCellBackground];
			[imgCellBackground release];
			
			UIImageView *imgTwitter = [[UIImageView alloc]initWithFrame:CGRectMake( 10,10, 50, 50)];
            [imgTwitter setTag:212121];
			[imgTwitter layer].masksToBounds = YES;
			[imgTwitter layer].cornerRadius = 10.0;
			[cell addSubview:imgTwitter];
			[imgTwitter release];
			
			UILabel* twitterName = [[UILabel alloc]initWithFrame:CGRectMake(80,10, 250, 15)];
			[twitterName setBackgroundColor:[UIColor clearColor]];
			[twitterName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
			[twitterName setTextColor:_savedPreferences.headerColor];
			[twitterName setUserInteractionEnabled:NO];
			[twitterName setTag:1010101010];
			[cell addSubview:twitterName];
			[twitterName release];
			twitterName = nil;
			
			
			}
		
		if(nodeCount > 0)
		{
			AppRecord *appRecord = [self.arrAppRecordsAllEntries objectAtIndex:[[arrEntriesCount objectAtIndex:indexPath.row] intValue]];
			
			NSString *strText =appRecord.tweetMsg;
			
			FontLabel *label4 = [[FontLabel alloc] initWithFrame:CGRectMake(80,30, 230, 40)];
			ZMutableAttributedString *strAttribute=[[ZMutableAttributedString alloc]initWithString:strText];
			label4.textAlignment = UITextAlignmentLeft;
			[label4 setTag:0101010101];
            label4.backgroundColor = [UIColor clearColor];
			[label4 setTextColor:_savedPreferences.labelColor];
			[label4 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
            label4.numberOfLines = 0;
			[cell addSubview:label4];
			
			NSMutableArray *arrAtTheRate=[[NSMutableArray alloc] init];
			NSString *str=[strText stringByAppendingFormat:@" "];
			NSRange range1=[str rangeOfString:strText];
		    [strAttribute addAttribute:ZForegroundColorAttributeName value:_savedPreferences.labelColor range:range1];
		 
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
											NSRange range=[str rangeOfString:st2];
											[strAttribute addAttribute:ZForegroundColorAttributeName value:_savedPreferences.headerColor range:range]; 
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
						 NSRange range=[str rangeOfString:st2];
						 [strAttribute addAttribute:ZForegroundColorAttributeName value:_savedPreferences.headerColor range:range]; 
						[arrAtTheRate addObject:st2];
					}
				}
			
		     }
			 
			label4.zAttributedText = strAttribute;
			//[str release];
			[label4 release];
			
			
			CGSize textsize = [strText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10] constrainedToSize:CGSizeMake(230, 400) lineBreakMode:UILineBreakModeWordWrap];
			int cellHeight1=textsize.height;
			cellHeight1=cellHeight1+55;
			
			
			UIView *viewBackground = (UIView *)[cell viewWithTag:121212];
			[viewBackground setFrame:CGRectMake( 0, 0, 320,cellHeight1)];
			
			UIImageView *imgTwitter = (UIImageView *)[cell viewWithTag:212121];
			
			UILabel *lblTwitterName = (UILabel *) [cell viewWithTag:1010101010];
			[lblTwitterName setText:appRecord.tweetSenderName];
			
			FontLabel *txtTwitterText = (FontLabel *)[cell viewWithTag:0101010101];
			[txtTwitterText setFrame:CGRectMake(80,lblTwitterName.frame.origin.y+lblTwitterName.frame.size.height+5, 232, textsize.height+15)];
			[txtTwitterText setText:strText];
			
			// Only load cached images; defer new downloads until scrolling ends
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
			
		}
		// Leave cells empty if there's no data yet
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
	if (tableView==tblNews)
	{
		if (!isTwitter)
		{
			
			if ([[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"custom"])
			{
				NewsDetail *objNewsDEtail = [[NewsDetail alloc]init];
				objNewsDEtail.strNewsDetail = [[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"sBody"];
				objNewsDEtail.strNewsTitle = [[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"sTitle"]; 
				objNewsDEtail.strNewsDate=[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"dDate2"];
				[self.navigationController pushViewController:objNewsDEtail animated:YES];
				[objNewsDEtail release];
			}
			else
			{
				
                TwitterDetail *objTwitterDetail=[[TwitterDetail alloc]init];
				objTwitterDetail.strFeedsTitle=[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"sTitle"];
				objTwitterDetail.strFeedsDetail=[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"summary"];
				objTwitterDetail.strFeedsDate=[[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"value"] valueForKey:@"date"];
				[self.navigationController pushViewController:objTwitterDetail animated:YES];
				[objTwitterDetail release];
			}
		}
		
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

#pragma mark -
#pragma mark Table cell image support
// Lazy Loading of Images for News
- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
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
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [tblTweets cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
		UIImageView *imageIcon = (UIImageView *)[cell viewWithTag:212121];
        [imageIcon setImage:iconDownloader.appRecord.appIcon];
    }
}
// Called by our ImageDownloader when an icon is ready to be displayed

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
	NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	
	[arrCountTweets release];
	[arrEntriesCount release];
	[arrAppRecordsAllEntries release];
	[imageDownloadsInProgress release];
	[noItemLbl release];
	[News release];
	[Twitter release];
	[_searchBar release];
	[lblNews release];
	[sortView release];
	[contentView release];
	[currentTitle release];
	[currentDate release];
	[currentSummary release];
	[currentLink release];
	[stories release];
    [imgSegmentControllerStatus release];
    [lblSegmentControllerSelected release];
	[viewLoading release];
    [super dealloc];
}


@end
