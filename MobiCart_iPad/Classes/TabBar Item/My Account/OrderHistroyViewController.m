//
//  OrderHistroyViewController.m
//  MobiCart
//
//  Copyright Mobicart. All rights reserved.
//

#import "OrderHistroyViewController.h"
#import "Constants.h"

extern BOOL isOrderLogin;

@implementation OrderHistroyViewController
@synthesize arrAllOrderHistory;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

-(void)btnShoppingCart_Clicked
{
	if(iNumOfItemsInShoppingCart > 0)
		[NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
	ShoppingCartViewController *objShopping = [[ShoppingCartViewController alloc] init];
	[[GlobalPrefrences getCurrentNavigationController]pushViewController:objShopping animated:YES];
	[objShopping release];
	
}
-(void)showLoading
{
	[GlobalPrefrences addLoadingBar_AtBottom:self.tabBarController.view withTextToDisplay:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
}


-(void)viewWillAppear:(BOOL)animated
{
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateLabelAccount" object:nil];
}

-(void)hideLoadingView
{
	[GlobalPrefrences dismissLoadingBar_AtBottom];	
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[NSTimer scheduledTimerWithTimeInterval:0.03
									 target:self
								   selector:@selector(hideLoadingView)
								   userInfo:nil
									repeats:NO];
	isOrderLogin=NO;
	
	contentView=[[UIView alloc]initWithFrame:CGRectMake( -10, 0, 420, 570)];
	contentView.backgroundColor=[UIColor clearColor];
	self.view = contentView;
	
	
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fetchDataFromServer) object:nil];
	[GlobalPrefrences addToOpertaionQueue:operation];
	[operation release];
	
	[self performSelectorOnMainThread:@selector(createTableView) withObject:nil waitUntilDone:YES];
	
	UIView *viewTopBar=[[UIView alloc]initWithFrame:CGRectMake( 0, 0, 300, 40)];
	
	[viewTopBar setTag:1010101010];
	[contentView addSubview:viewTopBar];
	
	
	UIButton *	btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
	btnCart.frame = CGRectMake(350, 13, 78,34);
	[btnCart setBackgroundColor:[UIColor clearColor]];
	[btnCart setImage:[UIImage imageNamed:@"add_cart.png"] forState:UIControlStateNormal];
	[btnCart addTarget:nextController action:@selector(btnShoppingCart_Clicked) forControlEvents:UIControlEventTouchUpInside];
	[contentView addSubview:btnCart];
	[contentView bringSubviewToFront:btnCart];
	
	
	lblCart = [[UILabel alloc] initWithFrame:CGRectMake(42, 2, 30, 30)];
	lblCart.backgroundColor = [UIColor clearColor];
	lblCart.textAlignment = UITextAlignmentCenter;
	lblCart.font = [UIFont boldSystemFontOfSize:16];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	lblCart.textColor = [UIColor whiteColor];	 
	[btnCart addSubview:lblCart];
	
	
	UILabel *orderLbl=[[UILabel alloc]initWithFrame:CGRectMake( 0, 27, 150, 15)];
	orderLbl.textColor=headingColor;
	[orderLbl setFont:[UIFont boldSystemFontOfSize:15]];
	[orderLbl setBackgroundColor:[UIColor clearColor]];
	[orderLbl setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.myaccount.orderhistory"]];
	[viewTopBar addSubview:orderLbl];
	[orderLbl release];
	
	UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 51, 426,2)];
	[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
	[contentView addSubview:imgHorizontalDottedLine];
	[imgHorizontalDottedLine release];
}



#pragma mark Fetch data from server
- (void)fetchDataFromServer
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if(!self.arrAllOrderHistory)
    {
        self.arrAllOrderHistory = [[NSArray alloc] init];
    }
	
	self.arrAllOrderHistory = [[ServerAPI fetchOrderDetails:[GlobalPrefrences getUserDefault_Preferences:@"userEmail"]:iCurrentAppId:iCurrentStoreId] objectForKey:@"product-orders"]; 
	
	if(![self.arrAllOrderHistory isEqual:[NSNull null]])
	{
		if([self.arrAllOrderHistory count]>0)
		{
			if(tableView)
            {
                [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
			else 
            {
				[self performSelectorOnMainThread:@selector(createTableView) withObject:nil waitUntilDone:YES];
			}
		}
		else 
        {
            NSLog (@"No Order History Available for this Buyer (OrderHistoryViewContoller)");
        }
        
	}
	else
    {
        NSLog (@"No Order History Available for this Buyer (OrderHistoryViewContoller)");
    }
	
	[pool release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self.navigationController popViewControllerAnimated:YES];
}	

-(void)createTableView
{
	if([self.arrAllOrderHistory count]>0)
	{
		if(!tableView)
		{		
			tableView=[[UITableView alloc]initWithFrame:CGRectMake( -5, 70, 400, 600) style:UITableViewStylePlain];
			tableView.delegate=self;
			tableView.dataSource=self;
			tableView.showsVerticalScrollIndicator = FALSE;
			[tableView setBackgroundColor:[UIColor clearColor]];
			[tableView setSeparatorColor:[UIColor clearColor]];
			[contentView addSubview:tableView];
		}
		//Removing label, if Data returned
		for (UILabel *lbl in [contentView subviews]) {
			if ([lbl isKindOfClass:[UILabel class]]) {
				if([lbl.text isEqualToString:@"There are no items in order history"])
					[lbl removeFromSuperview];
			}
		}
		
		UIView *viewTopBar = (UIView *) [contentView viewWithTag:1010101010];
		[contentView bringSubviewToFront:viewTopBar];
		
	}
}

#pragma mark TableView Delegate Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 30;
}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
	
	return [self.arrAllOrderHistory count];
}


- (UITableViewCell*) tableView:(UITableView*) tableview cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
	NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableIdentifier%d", indexPath.row];
	TableViewCell_Common *cell= (TableViewCell_Common *)[tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if(cell==nil)
	{
		cell = [[[TableViewCell_Common alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: SimpleTableIdentifier]autorelease];
		cell.backgroundColor = [UIColor clearColor];
		
		UIImageView *imgclock = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 25,25)];
		[imgclock setImage:[UIImage imageNamed:@"clock.png"]];
		[cell addSubview:imgclock];
		[imgclock release];
		
		UILabel *lblShowDateText=[[UILabel alloc]init];
		lblShowDateText.backgroundColor=[UIColor clearColor];
		[lblShowDateText setTextAlignment:UITextAlignmentLeft];
		lblShowDateText.textColor=subHeadingColor;
		[lblShowDateText setNumberOfLines:0];
		lblShowDateText.lineBreakMode = UILineBreakModeWordWrap;
		lblShowDateText.font=[UIFont boldSystemFontOfSize:14];
		[cell addSubview:lblShowDateText];
		[lblShowDateText release];
		
		
		UILabel *lblOrderTotalText = [[UILabel alloc]init];
		lblOrderTotalText .backgroundColor=[UIColor clearColor];
		[lblOrderTotalText  setTextAlignment:UITextAlignmentLeft];
		lblOrderTotalText .textColor=subHeadingColor;
		[lblOrderTotalText  setNumberOfLines:0];
		lblOrderTotalText .lineBreakMode = UILineBreakModeWordWrap;
		lblOrderTotalText .font=[UIFont boldSystemFontOfSize:15];
		[cell addSubview:lblOrderTotalText ];
		[lblOrderTotalText  release];
		
		if(arrAllOrderHistory)
		{
			if([arrAllOrderHistory count]>0)
			{
				NSString *OrderDate=[[arrAllOrderHistory objectAtIndex:indexPath.row]valueForKey:@"formattedOrderDate"];
				NSString *strOrderDate=[self setRequiredFormatForDate:OrderDate];
				NSString *strOrderTotal=[[arrAllOrderHistory objectAtIndex:indexPath.row]valueForKey:@"fTotalAmount"];
				NSString *strTotal;
				if(!([[[arrAllOrderHistory objectAtIndex:indexPath.row]valueForKey:@"formattedOrderDate"] isEqual:[NSNull null]]))
				{
					[lblShowDateText setText:[NSString stringWithFormat:@"%@",strOrderDate]];			
				}	
				else 
				{
					[lblShowDateText setText:@"N.A"];
				}
				
				if(!([[[arrAllOrderHistory objectAtIndex:indexPath.row]valueForKey:@"fTotalAmount"] isEqual:[NSNull null]]))
				{
					strTotal = [NSString stringWithFormat:@"%@%0.2f",_savedPreferences.strCurrencySymbol , [strOrderTotal floatValue]];
					[lblOrderTotalText setText:[NSString stringWithFormat:@"%@%0.2f",_savedPreferences.strCurrencySymbol , [strOrderTotal floatValue]]];			
				}	
				else 
				{
					strTotal = @"N.A";
					[lblOrderTotalText setText:@"N.A"];
				}
				CGSize size=[strTotal sizeWithFont:[UIFont systemFontOfSize:14.00] constrainedToSize:CGSizeMake(500,500) lineBreakMode:UILineBreakModeWordWrap];
				int x = size.width;
				lblOrderTotalText.frame = CGRectMake(35,2, x+10,20);
				lblShowDateText.frame=CGRectMake(x+55,2, 210,20);
			}
			
		}
	}
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return  cell;
}
//Set date format
-(NSString *)setRequiredFormatForDate:(NSString *)strDate
{
	NSString *day = [strDate substringWithRange:NSMakeRange(0,2)];				
	NSString *month = [strDate substringWithRange:NSMakeRange(3,3)];				
	NSString *year = [strDate substringWithRange:NSMakeRange(7,4)];
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
	NSString *dateString = [prefixDateString stringByAppendingString:suffix]; 
	
	NSDateFormatter *formatSuffix=[[NSDateFormatter alloc] init];
	[formatSuffix setDateFormat:@"MMMM"];
	NSString *suffix1=[formatSuffix stringFromDate:date];
	
	NSString *strDateFinal=[NSString stringWithFormat:@"%@ %@",dateString,suffix1];
	return strDateFinal;
}



- (void) tableView:(UITableView*)tableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */


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
	
	
	[tableView release];
	tableView =nil;
	[contentView release];
	contentView=nil;
	[lblCart release];
    [super dealloc];
}


@end
