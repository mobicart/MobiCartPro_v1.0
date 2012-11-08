//
//  NewsDetail.m
//  MobiCart
//
//  Created by Mobicart on 04/08/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

/** The View To display selected news details **/

#import "NewsDetail.h"
#import "Constants.h"
extern BOOL isTwiiterSelected;

@implementation NewsDetail
@synthesize strNewsDetail, strNewsTitle, strNewsDate;

- (void)viewWillAppear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateLabelNews" object:nil];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	self.navigationItem.titleView = [GlobalPreferences createLogoImage];
	
	UIView *contentView = [[UIView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake(0,0,320,392) chageHieght:YES]];
	contentView.backgroundColor=[UIColor colorWithRed:200.0/256 green:200.0/256 blue:200.0/256 alpha:1];
	[GlobalPreferences setGradientEffectOnView:contentView:[UIColor whiteColor]:contentView.backgroundColor];
	self.view = contentView;
    
    UIView *viewTopBar=[[UIView alloc]initWithFrame:CGRectMake(0, -2, 320,40)];
    [viewTopBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"barNews.png.png"]]];
    [contentView addSubview:viewTopBar];
	
	UIImageView *imgBg=[[UIImageView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake(0, 40, 320, 350) chageHieght:YES]];
	[imgBg setImage:[UIImage imageNamed:@"product_details_bg.png"]];
	[contentView addSubview:imgBg];
	[imgBg release];
	
	
    UIImageView *imgSegmentControllerStatus=[[UIImageView alloc]initWithFrame:CGRectMake(10,13,13,13)];
    [contentView addSubview:imgSegmentControllerStatus];
    
    UILabel *lblSegmentControllerSelected=[[UILabel alloc]initWithFrame:CGRectMake(30, 13, 80, 14)];
    [lblSegmentControllerSelected setBackgroundColor:[UIColor clearColor]];
    [lblSegmentControllerSelected setFont:[UIFont boldSystemFontOfSize:14]];
    [lblSegmentControllerSelected setTextColor:[UIColor whiteColor]];
    [contentView addSubview:lblSegmentControllerSelected];
    
    [imgSegmentControllerStatus setImage:[UIImage imageNamed:@"news_icon_top.png"]];
    [lblSegmentControllerSelected setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.news.news"]];
    [imgSegmentControllerStatus release];
    [lblSegmentControllerSelected release];
    [viewTopBar release];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake(0,40,320,365) chageHieght:YES]];
    if([GlobalPreferences isScreen_iPhone5])
        [scrollView setContentSize:CGSizeMake(320,600+88)];
    else
        [scrollView setContentSize:CGSizeMake(320,600)];
    scrollView.backgroundColor=[UIColor clearColor];
	[contentView addSubview:scrollView];
	
	UILabel *lblNewsTitle = [[UILabel alloc]initWithFrame:CGRectMake(10,10,300,100)];
	lblNewsTitle.backgroundColor=[UIColor clearColor];
	[lblNewsTitle setLineBreakMode:UILineBreakModeWordWrap];
	[lblNewsTitle setNumberOfLines:0];
	
	[lblNewsTitle setTextColor:_savedPreferences.headerColor];
	[lblNewsTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    
	if (([strNewsTitle isEqual:[NSNull null]]) || ([strNewsTitle length] ==0))
    {
        [lblNewsTitle setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.news.news"]];
    }
	else
    {
        [lblNewsTitle setText:strNewsTitle];
    }
	[scrollView addSubview:lblNewsTitle];
    
	CGRect frame = [lblNewsTitle frame];
	CGSize size = [lblNewsTitle.text sizeWithFont:lblNewsTitle.font
                                constrainedToSize:CGSizeMake(frame.size.width, 9999)
                                    lineBreakMode:UILineBreakModeWordWrap];
	frame.size.height = size.height+5;
	[lblNewsTitle setFrame:frame];
    
	UILabel *lblNewsDate = [[UILabel alloc]initWithFrame:CGRectMake( 10, lblNewsTitle.frame.origin.y+lblNewsTitle.frame.size.height+2, 170, 100)];
	lblNewsDate.backgroundColor=[UIColor clearColor];
	[lblNewsDate setLineBreakMode:UILineBreakModeWordWrap];
	[lblNewsDate setTextColor:_savedPreferences.labelColor];
	[lblNewsDate setNumberOfLines:1];
	[lblNewsDate setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
  	
	if (([strNewsDate isEqual:[NSNull null]]) || ([strNewsDate length] ==0))
    {
        NSArray *dateComponenentsTemp=[[[[NSString stringWithFormat:@"%@",[NSDate date]] componentsSeparatedByString:@" " ]objectAtIndex:0]componentsSeparatedByString:@"-"];
		NSCalendar *aCalendar = [NSCalendar currentCalendar];
		NSDateComponents *adateComponents = [[NSDateComponents alloc] init];
		int monCom=0;
		if ([[dateComponenentsTemp objectAtIndex:1] isEqualToString:@"01"])
		{
			monCom=1;
		}
		else if ([[dateComponenentsTemp objectAtIndex:1] isEqualToString:@"02"])
		{
			monCom=2;
		}
		else if ([[dateComponenentsTemp objectAtIndex:1] isEqualToString:@"03"])
		{
			monCom=3;
		}
		
		else if ([[dateComponenentsTemp objectAtIndex:1] isEqualToString:@"04"])
		{
			monCom=4;
		}
		
		else if ([[dateComponenentsTemp objectAtIndex:1] isEqualToString:@"05"])
		{
			monCom=5;
		}
		
		else if ([[dateComponenentsTemp objectAtIndex:1] isEqualToString:@"06"])
		{
			monCom=6;
		}
		
		else if ([[dateComponenentsTemp objectAtIndex:1] isEqualToString:@"07"])
		{
			monCom=7;
		}
		
		else if ([[dateComponenentsTemp objectAtIndex:1] isEqualToString:@"08"])
		{
			monCom=8;
		}
		
		else if ([[dateComponenentsTemp objectAtIndex:1] isEqualToString:@"09"])
		{
			monCom=9;
		}
		
		else if ([[dateComponenentsTemp objectAtIndex:1] isEqualToString:@"10"])
		{
			monCom=10;
		}
		
		
		else if ([[dateComponenentsTemp objectAtIndex:1] isEqualToString:@"11"])
		{
			monCom=11;
		}
		
		else if ([[dateComponenentsTemp objectAtIndex:1] isEqualToString:@"12"])
		{
			monCom=12;
		}
		
		
		
		
		[adateComponents setYear:[[dateComponenentsTemp objectAtIndex:0] integerValue]];
		[adateComponents setDay:[[dateComponenentsTemp objectAtIndex:2] integerValue]];
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
        
		NSArray *dateComponenentsTemp=[[[strNewsDate componentsSeparatedByString:@"+" ]objectAtIndex:0]componentsSeparatedByString:@" "];
		
		
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
		}else if ([[dateComponenentsTemp objectAtIndex:2] isEqualToString:@"Apr"])
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
    
	[scrollView addSubview:lblNewsDate];
	
	frame = [lblNewsDate frame];
	size = [lblNewsDate.text sizeWithFont:lblNewsDate.font
                        constrainedToSize:CGSizeMake(frame.size.width, 9999)
                            lineBreakMode:UILineBreakModeWordWrap];
	frame.size.height = size.height;
	[lblNewsDate setFrame:frame];
	
	UILabel *lblNewsDetail = [[UILabel alloc]initWithFrame:[GlobalPreferences setDimensionsAsPerScreenSize:CGRectMake( 10, lblNewsDate.frame.origin.y+lblNewsDate.frame.size.height+15,280, 100) chageHieght:YES]];
    
    
	lblNewsDetail.backgroundColor=[UIColor clearColor];
	[lblNewsDetail setTextColor:_savedPreferences.labelColor];
	[lblNewsDetail setFont:[UIFont fontWithName:@"Helvetica" size:13]];
	[lblNewsDetail setLineBreakMode:UILineBreakModeWordWrap];
	[lblNewsDetail setNumberOfLines:0];
    
	if (([strNewsDetail isEqual:[NSNull null]]) || ([strNewsDetail length] ==0))
    {
        [lblNewsDetail setText:@""];
    }
	else
    {
        [lblNewsDetail setText:strNewsDetail];
    }
	
	[scrollView addSubview:lblNewsDetail];
	
    frame = [lblNewsDetail frame];
    size = [lblNewsDetail.text sizeWithFont:lblNewsDetail.font
                          constrainedToSize:CGSizeMake(frame.size.width, 9999)
                              lineBreakMode:UILineBreakModeWordWrap];
    frame.size.height = size.height;
    [lblNewsDetail setFrame:frame];
    
	[scrollView setContentSize:CGSizeMake( 320, lblNewsDetail.frame.origin.y+lblNewsDetail.frame.size.height+50)];
    
	[lblNewsDate release];
	[lblNewsTitle release];
	[lblNewsDetail release];
	[scrollView release];
	[contentView release];
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
    isTwitterSelected=NO;
    [super dealloc];
}


@end
