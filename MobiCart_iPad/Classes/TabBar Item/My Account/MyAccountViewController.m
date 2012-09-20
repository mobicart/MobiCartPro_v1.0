//
//  MyAccountViewController.m
//  MobiCart
//
//  Copyright Mobicart. All rights reserved.
//

#import "MyAccountViewController.h"
#import "WishlistViewController.h"
#import "OrderHistroyViewController.h"
#import "GlobalPrefrences.h"
#import "Constants.h"

BOOL isWishlistLogin;
BOOL isOrderLogin;
BOOL isAccount;

@implementation MyAccountViewController


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.tabBarItem.image = [UIImage imageNamed:@"account_icon.png"];
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated 
{ 
	if ([[GlobalPrefrences getUserDefault_Preferences:@"userEmail"] length]!=0)
	{
		if([showArray count]==3)
		{
			[showArray addObject:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.myaccount.logout"]];
			[tableView setFrame:CGRectMake(46, 78, 420, 180)];
			[tableView reloadData];
		}    
	}
	if (rightContentView) 
	{
		NSArray *arrTemp = [rightContentView subviews];
		if([arrTemp count] > 0)
		{
			for(int i = 0; i <[arrTemp count]; i++)
				[[arrTemp objectAtIndex:i] removeFromSuperview];
		}
		[rightContentView removeFromSuperview];
		[rightContentView release];
		rightContentView = nil;
	}
	if (!rightView) {
		rightView = [[UIView alloc] initWithFrame:CGRectMake(560, 0, 512, 600)];
		[contentView addSubview:rightView];
		
		
		UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 51, 424,2)];
		[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
		[rightView addSubview:imgHorizontalDottedLine];
		[imgHorizontalDottedLine release];
		
		
		UIButton *btnCart = [[UIButton alloc]init];
		btnCart.frame = CGRectMake(350, 13, 78,34);
		[btnCart setBackgroundColor:[UIColor clearColor]];
		[btnCart setImage:[UIImage imageNamed:@"add_cart.png"] forState:UIControlStateNormal];
		[btnCart addTarget:self action:@selector(btnShoppingCart_Clicked) forControlEvents:UIControlEventTouchUpInside];
		[rightView addSubview:btnCart];
		
		lblCart = [[UILabel alloc] initWithFrame:CGRectMake(42, 2, 30, 30)];
		lblCart.backgroundColor = [UIColor clearColor];
		lblCart.textAlignment = UITextAlignmentCenter;
		lblCart.font = [UIFont boldSystemFontOfSize:16];
		lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
		lblCart.textColor = [UIColor whiteColor];	 
		[btnCart addSubview:lblCart];
	}
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	[super viewWillAppear:animated];
}

-(void)btnShoppingCart_Clicked
{
	if(iNumOfItemsInShoppingCart > 0)
		[NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
	ShoppingCartViewController *objShopping = [[ShoppingCartViewController alloc] init];
	[[self navigationController]pushViewController:objShopping animated:YES];
	[objShopping release];
	
}
-(void)viewWillDisappear:(BOOL)animated
{
	isWishlist_TableStyle = NO;
}
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	[GlobalPrefrences setCurrentNavigationController:self.navigationController];
	
	[self.navigationController.navigationBar setHidden:YES];
	contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
	self.view=contentView;
	[GlobalPrefrences setBackgroundTheme_OnView:contentView];
	
	UILabel *accountLbl=[[UILabel alloc]initWithFrame:CGRectMake(46, 15, 310, 28)];
	[accountLbl setBackgroundColor:[UIColor clearColor]];
	accountLbl.textColor = headingColor;
	[accountLbl setText:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.myaccount.myaccount"]];
	[accountLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
	[contentView addSubview:accountLbl];
	[accountLbl release];
	
	UIImageView *imgHorizontalDottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(44, 50, 424,2)];
	[imgHorizontalDottedLine setImage:[UIImage imageNamed:@"dot_line.png"]];
	[contentView addSubview:imgHorizontalDottedLine];
	[imgHorizontalDottedLine release];
	
	showArray=[[NSMutableArray alloc]init];
	[showArray addObject:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.myaccount.wishlist"]];
	[showArray addObject:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.myaccount.myaccount"]];
	[showArray addObject:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.myaccount.orderhistory"]];
	[self createTableView];
	
	
}




-(void)methodLogout
{
	[GlobalPrefrences setUserDefault_Preferences:@"" :@"userEmail"];
	[btnLogout setHidden:YES];
}



-(void)navigationMethods:(id)sender
{
	switch ([sender tag]) 
	{
		default:
			break;
	}
}


-(void)createTableView
{
	if(tableView)
	{
		[tableView release];
		tableView=nil;
	}
	tableView=[[UITableView alloc]initWithFrame:CGRectMake(46, 78, 420, 135) style:UITableViewStylePlain];
	tableView.delegate=self;
	tableView.dataSource=self;
	tableView.scrollEnabled = FALSE;
	
	[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];	
	[[tableView layer] setCornerRadius:18.00];
	
	UIImageView *imgbackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 424, 180)];
	[imgbackground setImage:[UIImage imageNamed:@"bgview.png"]];
	imgbackground.backgroundColor = backGroundColor;	
	tableView.backgroundView = imgbackground;
	[imgbackground release];
	
	[contentView addSubview:tableView];
}



#pragma mark TableView Delegate Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 45;
}


- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{	
	return [showArray count];
}


- (UITableViewCell*) tableView:(UITableView*) tableview cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
	NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableIdentifier%d", indexPath.row];
	TableViewCell_Common *cell= (TableViewCell_Common *)[tableview dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if(cell==nil)
	{		
		cell = [[TableViewCell_Common alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];		
		UILabel *lblCellText = [[UILabel alloc] initWithFrame:CGRectMake(19, 5, 200, 37)];
		lblCellText.textColor=subHeadingColor;
		lblCellText.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
		lblCellText.backgroundColor = [UIColor clearColor];
		lblCellText.text = [showArray objectAtIndex:indexPath.row];
		[cell addSubview:lblCellText];
		UIImageView *imgSeprator=[[UIImageView alloc]initWithFrame:CGRectMake(0, 45, 420, 1)];
		[imgSeprator setImage:[UIImage imageNamed:@"seperator.png"]];
		[imgSeprator setBackgroundColor:[UIColor clearColor]];
		[cell addSubview:imgSeprator];
	}	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return  cell;
}

-(void)showLoading
{
	[GlobalPrefrences addLoadingBar_AtBottom:self.tabBarController.view withTextToDisplay:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.LoaderText"]];
}


- (void) tableView:(UITableView*)tableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	
	if (rightContentView) {
		
		NSArray *arrTemp = [rightContentView subviews];
		if([arrTemp count] > 0)
		{
			for(int i = 0; i <[arrTemp count]; i++)
				[[arrTemp objectAtIndex:i] removeFromSuperview];
		}
		[rightContentView removeFromSuperview];
		[rightContentView release];
		rightContentView = nil;
		}
	
	if (!rightContentView) {
		if (rightView) {
			
			NSArray *arrTemp = [rightView subviews];
			if([arrTemp count] > 0)
			{
				for(int i = 0; i <[arrTemp count]; i++)
					[[arrTemp objectAtIndex:i] removeFromSuperview];
			}
			[rightView removeFromSuperview];
			[rightView release];
			rightView = nil;
		}
		rightContentView = [[UIView alloc] initWithFrame:CGRectMake(560, 0, 512, 600)];
		[contentView addSubview:rightContentView];
	}
	
	
	switch (indexPath.row) 
	{
		case 0:
		{
			[NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
			WishlistViewController *objWishlist=[[WishlistViewController alloc]init];
			[rightContentView addSubview:objWishlist.view];
			[rightContentView bringSubviewToFront:objWishlist.view];
			break;
		}
		case 1:
		{
			isAccount = YES;
			DetailsViewController *objDetail=[[DetailsViewController alloc]init];			
			[rightContentView addSubview:objDetail.view];
			[rightContentView bringSubviewToFront:objDetail.view];
			break;
		}
		case 2:
		{
			
			NSMutableArray *arrInfoAccount=[[NSMutableArray alloc]init];
			arrInfoAccount=[[SqlQuery shared] getAccountData:[GlobalPrefrences getUserDefault_Preferences:@"userEmail"]];
			if([arrInfoAccount count]==0)
			{
				isOrderLogin=YES;
				DetailsViewController *_details = 	[[DetailsViewController alloc] init];
				[rightContentView addSubview:_details.view];
				[rightContentView bringSubviewToFront:_details.view];
			}
			
			else
			{	
				OrderHistroyViewController *objOrder=[[OrderHistroyViewController alloc]init];
				[rightContentView addSubview:objOrder.view];
				[rightContentView bringSubviewToFront:objOrder.view];
			}
			[arrInfoAccount release];
			break;
		}
            
        case 3:
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Log out of Mobicart" message:@"Shall we log you out?" delegate:self cancelButtonTitle:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.cancel"] otherButtonTitles:[[GlobalPrefrences getLangaugeLabels]valueForKey:@"key.iphone.nointernet.cancelbutton"],nil];
			[alert show];
			[alert release];		 	
            break;      
	    }		
	}
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{ 
	if(buttonIndex == 1)
	{
		[GlobalPrefrences setUserDefault_Preferences:@"" :@"userEmail"];
		[showArray removeLastObject];
		[tableView setFrame:CGRectMake(46, 78, 420, 135)];
		[tableView reloadData];
	}
	
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 
 
 [super viewDidLoad];
 }
 */
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	[lblCart release];
	[contentView release];
	contentView=nil;
    [super dealloc];
}


@end
