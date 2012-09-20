//
//  MoreTableViewDelegate.h
//  MobicartApp
//
//  Created by Mobicart on 16/05/11.
//  Copyright 2011 Mobicart. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MoreTableViewDelegate : NSObject<UITableViewDelegate> {
    id<UITableViewDelegate> originalDelegate;
	BOOL isPoweredByMobicart;
    
}

@property (retain) id<UITableViewDelegate>originalDelegate;
@property(nonatomic,assign)BOOL isPoweredByMobicart;
-(MoreTableViewDelegate *) initWithDelegate:(id<UITableViewDelegate>)delegate;

@end
