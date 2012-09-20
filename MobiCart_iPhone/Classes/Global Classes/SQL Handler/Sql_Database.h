//
//  Database.h
//  Mobicart
//
//  Created by Mobicart on 23/06/08.
//  Copyright 2008 Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface Sql_Database : NSObject {
	sqlite3 *database;
}

- (void)loadDb;


@end
