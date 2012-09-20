//
//  MoreTableViewDelegate.m
//  MobicartApp
//
//  Created by Mobicart on 16/05/11.
//  Copyright 2011 Mobicart. All rights reserved.
//

#import "MoreTableViewDelegate.h"
#import "Constants.h"
extern 	MobicartAppAppDelegate *_objMobicartAppDelegate;

@implementation MoreTableViewDelegate
@synthesize originalDelegate,isPoweredByMobicart;

-(MoreTableViewDelegate *) initWithDelegate:(id<UITableViewDelegate>) delegate
{
    originalDelegate=delegate;
    [super init];
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{   
    if(isPoweredByMobicart==YES)
    {
       return 50; 
    }
	else
  
	{
       return 60; 
    }
	
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
	return [originalDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}	

@end
