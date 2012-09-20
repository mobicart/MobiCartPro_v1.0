//
//  MoreTableViewDataSource.m
//  MobicartApp
//
//  Created by Mobicart on 08/04/11.
//  Copyright 2011 Mobicart. All rights reserved.
//

#import "MoreTableViewDataSource.h"
#import "Constants.h"


@implementation MoreTableViewDataSource
@synthesize originalDataSource;
@synthesize isMobicartBrand;

-(MoreTableViewDataSource *) initWithDataSource:(id<UITableViewDataSource>) dataSource
{
    originalDataSource = dataSource;
    [super init];
    
    return self;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [originalDataSource tableView:table numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [originalDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
   // cell.textLabel.textColor=[UIColor darkGrayColor];
	cell.textLabel.textColor=_savedPreferences.headerColor;
   [cell.textLabel setFont:[UIFont boldSystemFontOfSize:15]];

    cell.backgroundColor=cellBackColor;

	UIImageView *imgCellBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,60)];
	if(isMobicartBrand==YES)
	{
		[imgCellBackground setFrame:CGRectMake(0, 0, 320,50)];
		[imgCellBackground setImage:[UIImage imageNamed:@"320-50.png"]];
	}
	else 
	{
		[imgCellBackground setImage:[UIImage imageNamed:@"320-60.png"]];

	}
	[cell setBackgroundView:imgCellBackground];
	[imgCellBackground release];
	
	UIImageView *imgViewCellAcccesory=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
	[cell setAccessoryView:imgViewCellAcccesory];
	[imgViewCellAcccesory release];
	
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	return cell;
}

@end
