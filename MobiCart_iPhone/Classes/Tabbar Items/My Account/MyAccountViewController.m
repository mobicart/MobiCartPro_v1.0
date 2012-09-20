//
//  MyAccountViewController.m
//  MobiCart
//
//  Created by Mobicart on 7/6/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

/** This class provide options to View Wishlist, My Account, View Order History And Logout **/

#import "MyAccountViewController.h"
#import "WishlistViewController.h"
#import "OrderHistroyViewController.h"
#import "Constants.h"

BOOL isWishlistLogin;
BOOL isOrderLogin;
BOOL isAccount;

@implementation MyAccountViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        // Custom initialization
		self.tabBarItem.image = [UIImage imageNamed:@"accountTab.png"];
	}
    return self;
}

-(void)updateDataForCurrent_Navigation_And_View_Controller
{
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
}	

- (void)viewWillAppear:(BOOL)animated 
{ 
	[super viewWillAppear:animated];
	
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateShoppingLabel) name:@"updateLabelAccount" object:nil];
	
	if (isWishlistLogin)
	{
		WishlistViewController *objWishlist=[[WishlistViewController alloc]init];
		[self.navigationController pushViewController:objWishlist animated:NO];
		[objWishlist release];
	}
    
	if (isOrderLogin)
	{
		OrderHistroyViewController *objOrder=[[OrderHistroyViewController alloc]init];
		[self.navigationController pushViewController:objOrder animated:NO];
		[objOrder release];
	}
    
    if ([[GlobalPreferences getUserDefault_Preferences:@"userEmail"] length]!=0)
    {
        if ([showArray count]==3)
        {
			[tableView setFrame:CGRectMake(10,40, 300,190)];
			[showArray addObject:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.myaccount.logout"]];
			[tableView reloadData];
        }    
    }
	else 
    {
		[tableView setFrame:CGRectMake(10,40, 300,140)];
	}
}

- (void)updateShoppingLabel
{
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	self.navigationItem.titleView = [GlobalPreferences createLogoImage];
	
	lblCart = [[UILabel alloc] initWithFrame:CGRectMake(280, 5, 30, 34)];
	lblCart.backgroundColor = [UIColor clearColor];
	lblCart.textAlignment = UITextAlignmentCenter;
	lblCart.font = [UIFont boldSystemFontOfSize:16];
	lblCart.text = [NSString stringWithFormat:@"%d", iNumOfItemsInShoppingCart];
	lblCart.textColor = [UIColor whiteColor];
	[self.navigationController.navigationBar addSubview:lblCart];
	
	contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,480)];
	contentView.backgroundColor=[UIColor colorWithRed:200.0/256 green:200.0/256 blue:200.0/256 alpha:1];
	self.view=contentView;
	
	UIImageView *imgContentView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 27,320,350)];
	[imgContentView setBackgroundColor:[UIColor clearColor]];
	[imgContentView setImage:[UIImage imageNamed:@"product_details_bg.png"]];
	[contentView addSubview:imgContentView];
	[imgContentView release];
	
	UIView *viewTopBar=[[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 27)];
	[viewTopBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"select_dept_bar.png"]]];
    [contentView addSubview:viewTopBar];
	[contentView addSubview:viewTopBar];
	
	UILabel *accountLbl=[[UILabel alloc]initWithFrame:CGRectMake(9,2, 310, 23)];
	[accountLbl setBackgroundColor:[UIColor clearColor]];
	
	[accountLbl setTextColor:[UIColor whiteColor]];
	[accountLbl setText:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.myaccount.myaccount"]];
    [accountLbl setTextColor:[UIColor whiteColor]];
	[accountLbl setFont:[UIFont boldSystemFontOfSize:13.00]];
	
	[viewTopBar addSubview:accountLbl];
	[accountLbl release];
	
	[viewTopBar release];
	
	showArray=[[NSMutableArray alloc]init];
	[showArray addObject:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.myaccount.wishlist"]];
	[showArray addObject:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.myaccount.myaccount"]];
	[showArray addObject:[[GlobalPreferences getLangaugeLabels] valueForKey:@"key.iphone.myaccount.orderhistory"]];
	
	[self createTableView];
}

- (void)methodLogout
{
	[GlobalPreferences setUserDefault_Preferences:@"" :@"userEmail"];
	[btnLogout setHidden:YES];
}

- (void)createTableView
{
	if (tableView)
	{
		[tableView release];
		tableView=nil;
	}
	tableView=[[UITableView alloc]initWithFrame:CGRectMake(10,40,300,190) style:UITableViewStylePlain];
	tableView.delegate=self;
	tableView.dataSource=self;
    [[tableView layer]setCornerRadius:14.00];
	[[tableView layer]setBorderWidth:1.0];
	[[tableView layer]setBorderColor:[[UIColor lightGrayColor]CGColor]];
    tableView.scrollEnabled = FALSE;
	[tableView setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:tableView];
}

#pragma mark TableView Delegate Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 48;
}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
	return [showArray count];
}

- (UITableViewCell*) tableView:(UITableView*) tableview cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
	NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableIdentifier%d", indexPath.row];
	TableViewCell_Common *cell= (TableViewCell_Common *)[tableview dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	
	if (cell==nil)
	{
		cell = [[TableViewCell_Common alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
		
		UIImageView *imgCellBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,310,50)];
		[imgCellBackground setImage:[UIImage imageNamed:@"seperator_bg.png"]];
		[cell setBackgroundView:imgCellBackground];
		[imgCellBackground release];
		
		cell.contentView.backgroundColor=cellBackColor;
		
		// Setting gradient effect on view
		UILabel *lblCellData=[[UILabel alloc]initWithFrame:CGRectMake(15,12
																	  ,300,20  )];
		[lblCellData setBackgroundColor:[UIColor clearColor]];
		[lblCellData setText:[showArray objectAtIndex:indexPath.row]];
		lblCellData.font=[UIFont fontWithName:@"Helvetica-Bold" size:16.0];
		lblCellData.textColor=_savedPreferences.headerColor;
		[cell.contentView addSubview:lblCellData];
		[lblCellData release];
	}
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return  cell;
}

- (void)tableView:(UITableView*)tableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	switch (indexPath.row) 
	{
		case 0:
		{
			WishlistViewController *objWishlist=[[WishlistViewController alloc]init];
			[self.navigationController pushViewController:objWishlist animated:YES];
			[objWishlist release];
			break;
		}
		case 1:
		{
			isAccount = YES;
			DetailsViewController *objDetail=[[DetailsViewController alloc]init];
			[self.navigationController pushViewController:objDetail animated:YES];
			[objDetail release];
			break;
		}
		case 2:
		{
			NSMutableArray *arrInfoAccount=[[NSMutableArray alloc]init];
			arrInfoAccount=[[SqlQuery shared] getAccountData:[GlobalPreferences getUserDefault_Preferences:@"userEmail"]];
			
			if ([arrInfoAccount count]==0)
			{
				isOrderLogin=YES;
				DetailsViewController *_details = 	[[DetailsViewController alloc] init];
				[self.navigationController pushViewController:_details animated:YES];
				[_details release];
			}
			else
			{				
				OrderHistroyViewController *objOrder=[[OrderHistroyViewController alloc]init];
				[self.navigationController pushViewController:objOrder animated:YES];
				[objOrder release];
			}
            
			[arrInfoAccount release];
			break;
		}
        case 3:
		{
		 	[GlobalPreferences setUserDefault_Preferences:@"" :@"userEmail"];
            [showArray removeLastObject];
			[GlobalPreferences setPersonLoginStatus:YES];
			[tableView setFrame:CGRectMake(10,40, 300,140)];
            [tableview reloadData];
            break;
        }
	}
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
    
    [super dealloc];
}


@end
