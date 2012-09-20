//
//  Database.h
//
//  Created by mobicart on 23/06/08.
//  Copyright mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface Sql_Database : NSObject {
	sqlite3 *database;
}

- (void)loadDb;


@end
