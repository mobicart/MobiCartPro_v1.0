//
//  MoreTableViewDataSource.h
//  MobicartApp
//
//  Created by Mobicart on 08/04/11.
//  Copyright 2011 Mobicart. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MoreTableViewDataSource : NSObject<UITableViewDataSource> {
    
    id<UITableViewDataSource> originalDataSource;
	BOOL isMobicartBrand;
    
}

@property (retain) id<UITableViewDataSource> originalDataSource;
@property(nonatomic,assign)	BOOL isMobicartBrand;

-(MoreTableViewDataSource *) initWithDataSource:(id<UITableViewDataSource>) dataSource;

@end


