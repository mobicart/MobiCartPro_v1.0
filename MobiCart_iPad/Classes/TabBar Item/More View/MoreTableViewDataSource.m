//
//  MoreTableViewDataSource.m
//  MobicartApp
//
//  Created by Mobicart on 08/04/11.
//  Copyright Mobicart. All rights reserved.
//

#import "MoreTableViewDataSource.h"
#import "Constants.h"


@implementation MoreTableViewDataSource
@synthesize originalDataSource,originalDelegate,isPoweredByMobicart;

-(MoreTableViewDataSource *) initWithDataSource:(id<UITableViewDataSource>) dataSource
{
    originalDataSource = dataSource;
    [super init];
    return self;
}

-(MoreTableViewDataSource *) initWithDelegate:(id<UITableViewDelegate>) delegate
{
    originalDelegate = delegate;
    [super init];
	
	
    return self;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [originalDataSource tableView:table numberOfRowsInSection:section];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 63;
	
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
    UITableViewCell *cell = [originalDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor=[UIColor clearColor];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:15]];
    cell.backgroundColor=[UIColor clearColor];
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.accessoryType=UITableViewCellAccessoryNone;

	
	UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(90, 15, 200, 30)];
	[btn setTitle:[NSString stringWithFormat:@"%@",cell.textLabel.text] forState:UIControlStateNormal];
	[btn addTarget:nextController action:@selector(moreTableCellClicked:) forControlEvents:UIControlEventTouchUpInside];
	[[btn titleLabel]setFont:[UIFont boldSystemFontOfSize:16]];
	btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	[btn setTitleColor:subHeadingColor forState:UIControlStateNormal];
	[btn setTag:indexPath.row+1];
	[btn setBackgroundColor:[UIColor clearColor]];
	[cell addSubview:btn];
	
	UIImageView *imgLogo=[[UIImageView alloc]initWithFrame:CGRectMake(43, 18, 24, 24)];
	[imgLogo setBackgroundColor:[UIColor clearColor]];
	[cell addSubview:imgLogo];
	
	if([btn.titleLabel.text isEqualToString:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.more.aboutus"]])
	{
		imgLogo.frame = CGRectMake(43, 17, 31, 22);
		[imgLogo setImage:[UIImage imageNamed:@"more_icon_01.png"]];
	}
	else if([btn.titleLabel.text isEqualToString:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.more.contactus"]])
	{
		imgLogo.frame = CGRectMake(43, 15, 26, 26);
		[imgLogo setImage:[UIImage imageNamed:@"more_icon_02.png"]];

	}
	else if([btn.titleLabel.text isEqualToString:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.more.tandc"]])
	{
		imgLogo.frame = CGRectMake(43, 16, 24, 25);
		[imgLogo setImage:[UIImage imageNamed:@"more_icon_03.png"]];

	}
	else if([btn.titleLabel.text isEqualToString:[[GlobalPrefrences getLangaugeLabels] valueForKey:@"key.iphone.more.privacy"]])
	{
		imgLogo.frame = CGRectMake(43, 14, 19, 26);
		[imgLogo setImage:[UIImage imageNamed:@"more_icon_04.png"]];

	}
	else 
	{
		[imgLogo setImage:[UIImage imageNamed:@"page_1.png"]];

	}
	[btn release];
		 [imgLogo release];
	
	
	UIImageView *imgArrow=[[UIImageView alloc]initWithFrame:CGRectMake(445, 23, 11, 14)];
	[imgArrow setImage:[UIImage imageNamed:@"arrow_left.png"]];
	[imgArrow setBackgroundColor:[UIColor clearColor]];
	[cell addSubview:imgArrow];
	
	UIImageView *imgSeprator=[[UIImageView alloc]initWithFrame:CGRectMake(40, 61, 425, 3)];
	[imgSeprator setImage:[UIImage imageNamed:@"seperator.png"]];
	[imgSeprator setBackgroundColor:[UIColor clearColor]];
	[cell addSubview:imgSeprator];
    
    return cell;
}



@end
