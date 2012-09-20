//
//  LeavesViewController.h
//  Leaves
//
//  Created by Mobicart on 4/18/10.
//  Copyright Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeavesView.h"

@interface LeavesViewController : UIViewController <LeavesViewDataSource, LeavesViewDelegate> {
	LeavesView *leavesView;
}

@end

