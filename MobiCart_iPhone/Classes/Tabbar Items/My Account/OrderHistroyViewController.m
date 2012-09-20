//
//  OrderHistroyViewController.m
//  MobiCart
//
//  Created by Mobicart on 7/28/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

/** The View Controller to view the Order history and status of products ordered by user/user email **/

#import "OrderHistroyViewController.h"
#import "Constants.h"

extern BOOL isOrderLogin;

@implementation OrderHistroyViewController
@synthesize arrAllOrderHistory;

- (void)viewWillAppear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateLabelAccount" 
                                          object:nil];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	self.navigationItem.titleView = [GlobalPreferences createLogoImage];
	
	isOrderLogin=NO;
	
	contentView=[[UIView alloc]initWithFrame:CGRectMake( 0, 0, 320, 396)];
	self.view = contentView;
	
	UIImageView *imgBg=[[UIImageView alloc]initWithFrame:CGRectMake(0,30, 320, 396)];
	[imgBg setImage:[UIImage imageNamed:@"product_details_bg.png"]];
	[contentView addSubview:imgBg];
	[imgBg release];
	
	
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fetchDataFromServer) object:nil];
	
	[GlobalPreferences addToOpertaionQueue:operation];
	[operation release];
	
	[self performSelectorOnMainThread:@selector(createTableView) withObject:nil waitUntilDone:YES];
	
	UIView *viewTopBar=[[UIView alloc]initWithFrame:CGRectMake( 0, 0, 320,40)];
	[viewTopBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"barNews.png"]]]; 	
	[viewTopBar setTag:1010101010];
	[contentView addSubview:viewTopBar];
	
	UILabel *orderLbl=[[UILabel alloc]initWithFrame:CGRectMake( 10, 5, 310, 30)];
	orderLbl.textColor=[UIColor whiteColor];
	[orderLbl setFont:[UIFont boldSystemFontOfSize:14]];
	[orderLbl setBackgroundColor:[UIColor clearColor]];
	[orderLbl setText:[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.myaccount.orderhistory"]];
	[viewTopBar addSubview:orderLbl];
	[orderLbl release];
}

#pragma mark Fetch data from server
- (void)fetchDataFromServer
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if(!self.arrAllOrderHistory)
    {
        self.arrAllOrderHistory = [[NSArray alloc] init];
    }
		
	self.arrAllOrderHistory = [[ServerAPI fetchOrderDetails:[GlobalPreferences getUserDefault_Preferences:@"userEmail"]:iCurrentAppId:iCurrentStoreId] objectForKey:@"product-orders"]; 
	
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

- (void)createTableView
{
	if([self.arrAllOrderHistory count]>0)
	{
		if(!tableView)
		{		
			tableView=[[UITableView alloc]initWithFrame:CGRectMake( 0, 40, 320, 335) style:UITableViewStylePlain];
			tableView.delegate=self;
			tableView.dataSource=self;
			tableView.showsVerticalScrollIndicator = FALSE;
			[tableView setBackgroundColor:[UIColor clearColor]];
			[tableView setSeparatorColor:[UIColor clearColor]];
			[contentView addSubview:tableView];
		}
        
		//Removing label, if Data returned
		for (UILabel *lbl in [contentView subviews]) 
        {
			if ([lbl isKindOfClass:[UILabel class]]) 
            {
				if([lbl.text isEqualToString:@"There are no items in order history"])
                {
                    [lbl removeFromSuperview];
                }
			}
		}
		UIView *viewTopBar = (UIView *) [contentView viewWithTag:1010101010];
		[contentView bringSubviewToFront:viewTopBar];
	}
}

#pragma mark TableView Delegate Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
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
		cell.backgroundColor = cellBackColor;
		
		UIImageView *imgCellBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,91)];
		[imgCellBackground setImage:[UIImage imageNamed:@"store_cell_bg.png"]];
		[[cell layer] insertSublayer:imgCellBackground.layer atIndex:0];
		[imgCellBackground release];
		
		UILabel *showDateText = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 120, 20)];
		showDateText.backgroundColor=[UIColor clearColor];
		[showDateText setText:[NSString stringWithFormat:@"%@:",[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.order.history.date"]]];
		[showDateText setTextAlignment:UITextAlignmentLeft];
		showDateText.textColor=[UIColor grayColor];
		[showDateText setNumberOfLines:0];
		showDateText.lineBreakMode = UILineBreakModeWordWrap;
		showDateText.font=[UIFont systemFontOfSize:14];
		[cell addSubview:showDateText];
		[showDateText release];
		
		UILabel *lblShowDateText=[[UILabel alloc]initWithFrame:CGRectMake(150,5, 170,20)];
		lblShowDateText.backgroundColor=[UIColor clearColor];
		[lblShowDateText setTextAlignment:UITextAlignmentLeft];
		lblShowDateText.textColor=[UIColor darkGrayColor];
		[lblShowDateText setNumberOfLines:0];
		lblShowDateText.lineBreakMode = UILineBreakModeWordWrap;
		lblShowDateText.font=[UIFont systemFontOfSize:14];
		[cell addSubview:lblShowDateText];
		[lblShowDateText release];
		
		UILabel *showOrderText = [[UILabel alloc]initWithFrame:CGRectMake(40, 25, 120, 20)];
		showOrderText.backgroundColor=[UIColor clearColor];
		[showOrderText setText:[NSString stringWithFormat:@"%@:",[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.order.history.order"]]];
		[showOrderText setTextAlignment:UITextAlignmentLeft];
		showOrderText.textColor=[UIColor grayColor];
		[showOrderText setNumberOfLines:0];
		showOrderText.lineBreakMode = UILineBreakModeWordWrap;
		showOrderText.font=[UIFont systemFontOfSize:14];
		[cell addSubview:showOrderText];
		[showOrderText release];
		
		UILabel *lblOrderText = [[UILabel alloc]initWithFrame:CGRectMake(150,25,60,20)];
		lblOrderText.backgroundColor=[UIColor clearColor];
		[lblOrderText setTextAlignment:UITextAlignmentLeft];
		lblOrderText.textColor=[UIColor darkGrayColor];
		[lblOrderText setNumberOfLines:0];
		lblOrderText.lineBreakMode = UILineBreakModeWordWrap;
		lblOrderText.font=[UIFont systemFontOfSize:14];
		[cell addSubview:lblOrderText];
		[lblOrderText release];
		
			
		UILabel *lblOrderProcessTitle = [[UILabel alloc]initWithFrame:CGRectMake(40,45,120,20)];
		lblOrderProcessTitle.backgroundColor=[UIColor clearColor];
		[lblOrderProcessTitle setTextAlignment:UITextAlignmentLeft];
		[lblOrderProcessTitle setNumberOfLines:0];
		[lblOrderProcessTitle setText:[NSString stringWithFormat:@"%@:",[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.order.history.status"]]];
		lblOrderProcessTitle.textColor=[UIColor grayColor];
        lblOrderProcessTitle.lineBreakMode = UILineBreakModeTailTruncation;
		lblOrderProcessTitle.font=[UIFont systemFontOfSize:14];
		[cell addSubview:lblOrderProcessTitle];
		[lblOrderProcessTitle release];
		
				
		UILabel *showOrderTotalText = [[UILabel alloc]initWithFrame:CGRectMake(40, 65, 120, 20)];
		showOrderTotalText .backgroundColor=[UIColor clearColor];
		[showOrderTotalText setText:[NSString stringWithFormat:@"%@:",[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.order.history.order.total"]]];
		[showOrderTotalText  setTextAlignment:UITextAlignmentLeft];
		showOrderTotalText .textColor=[UIColor grayColor];
		[showOrderTotalText  setNumberOfLines:0];
		showOrderTotalText .lineBreakMode = UILineBreakModeWordWrap;
		showOrderTotalText .font=[UIFont systemFontOfSize:14];
		[cell addSubview:showOrderTotalText ];
		[showOrderTotalText release];
		
		
		
		UILabel *lblOrderTotalText = [[UILabel alloc]initWithFrame:CGRectMake(150,65,170 ,20)];
		lblOrderTotalText .backgroundColor=[UIColor clearColor];
		[lblOrderTotalText  setTextAlignment:UITextAlignmentLeft];
		lblOrderTotalText .textColor=[UIColor darkGrayColor];
		[lblOrderTotalText  setNumberOfLines:0];
		lblOrderTotalText .lineBreakMode = UILineBreakModeWordWrap;
		lblOrderTotalText .font=[UIFont systemFontOfSize:14];
		[cell addSubview:lblOrderTotalText ];
		if(arrAllOrderHistory)
		{
			if([arrAllOrderHistory count]>0)
			{
				NSString *strOrderDate=[[arrAllOrderHistory objectAtIndex:indexPath.row]valueForKey:@"formattedOrderDate"];
				NSString *strOrder=[[arrAllOrderHistory objectAtIndex:indexPath.row]valueForKey:@"id"];
				NSString *strOrderTotal=[[arrAllOrderHistory objectAtIndex:indexPath.row]valueForKey:@"fTotalAmount"];
				NSString *strOrderStatus=[[arrAllOrderHistory objectAtIndex:indexPath.row]valueForKey:@"sStatus"];
    			
				
				if(!([[[arrAllOrderHistory objectAtIndex:indexPath.row]valueForKey:@"sStatus"] isEqual:[NSNull null]]))
				{   
					if([strOrderStatus isEqualToString:@"pending"])
					{
                      strOrderStatus= [NSString stringWithFormat:@"%@",[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.order.status.pending"]];
        
					}					
					else if([strOrderStatus isEqualToString:@"completed"])
					{
					 strOrderStatus= [NSString stringWithFormat:@"%@",[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.order.status.completed"]];
			 		}
					else if([strOrderStatus isEqualToString:@"cancel"])
					{
					 strOrderStatus= [NSString stringWithFormat:@"%@",[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.order.status.cancelled"]];
					}                    
					else 
					{
					strOrderStatus= [NSString stringWithFormat:@"%@",[[GlobalPreferences getLangaugeLabels]valueForKey:@"key.iphone.order.status.processing"]];
					}		
                    UILabel *lblOrderStatus = [[UILabel alloc]initWithFrame:CGRectMake(150,45,150,20)];
                    lblOrderStatus.text=[NSString stringWithFormat:@"%@",strOrderStatus];
                    lblOrderStatus .backgroundColor=[UIColor clearColor];
                    [lblOrderStatus  setTextAlignment:UITextAlignmentLeft];
                    lblOrderStatus.textColor=[UIColor darkGrayColor];
                    [lblOrderStatus  setNumberOfLines:0];
                    lblOrderStatus.lineBreakMode = UILineBreakModeWordWrap;
                    lblOrderStatus.font=[UIFont systemFontOfSize:14];
                    [cell addSubview:lblOrderStatus];
                    [lblOrderStatus release];
                    
		                  
				}	
				
				else 
				{
				               
				}
				
				if(!([[[arrAllOrderHistory objectAtIndex:indexPath.row]valueForKey:@"formattedOrderDate"] isEqual:[NSNull null]]))
				{
					[lblShowDateText setText:[NSString stringWithFormat:@"%@",strOrderDate]];			
				}	
				else 
				{
					[lblShowDateText setText:@"N.A"];
				}
				
				if(!([[[arrAllOrderHistory objectAtIndex:indexPath.row]valueForKey:@"id"] isEqual:[NSNull null]]))
				{
					[lblOrderText setText:[NSString stringWithFormat:@"%@",strOrder]];		
				}	
				else 
                {
					[lblOrderText setText:@"N.A"];
				}
				
				if(!([[[arrAllOrderHistory objectAtIndex:indexPath.row]valueForKey:@"fTotalAmount"] isEqual:[NSNull null]]))
				{
					[lblOrderTotalText setText:[NSString stringWithFormat:@"%@%0.2f",_savedPreferences.strCurrencySymbol , [strOrderTotal floatValue]]];			
				}	
				else 
				{
					[lblOrderTotalText setText:@"N.A"];
				}
				
            }
		}
	}
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return  cell;
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
	[tableView release];
	tableView =nil;
    
	[contentView release];
	contentView=nil;
	
    [super dealloc];
}


@end
