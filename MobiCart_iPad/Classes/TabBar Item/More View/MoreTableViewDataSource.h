//
//  MoreTableViewDataSource.h
//  MobicartApp
//  Created by Mobicart on 08/04/11.
//  Copyright Mobicart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
extern UIViewController * nextController;
@interface MoreTableViewDataSource : NSObject<UITableViewDataSource,UITableViewDelegate> {
    
    id<UITableViewDataSource> originalDataSource;
	id<UITableViewDelegate> originalDelegate;
 BOOL isPoweredByMobicart;
	
}

@property (retain) id<UITableViewDataSource> originalDataSource;
@property (retain) id<UITableViewDelegate> originalDelegate;
@property(nonatomic,assign)BOOL isPoweredByMobicart;
-(MoreTableViewDataSource *) initWithDataSource:(id<UITableViewDataSource>) dataSource;
-(MoreTableViewDataSource *) initWithDelegate:(id<UITableViewDelegate>) originalDelegate;

@end


