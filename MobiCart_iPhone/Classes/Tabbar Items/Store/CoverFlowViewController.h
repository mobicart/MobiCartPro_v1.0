//
//  CoverFlowViewController.h
//  CoverFlow
//
//  Created by Mobicart on 4/7/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFOpenFlowView.h"


@interface CoverFlowViewController :  UIViewController<AFOpenFlowViewDelegate,AFOpenFlowViewDataSource>
{
    UIPopoverController *PickerPopover;
    AFOpenFlowView *viewAF;
    UIView *coverflowBackView;

	NSOperationQueue *loadImagesOperationQueue;

}
@property (nonatomic, retain) UIPopoverController *PickerPopover;
-(void)LoadCoverflow;
@property (nonatomic,retain) NSMutableArray *arrImages;
@property (nonatomic,retain) NSData *dataForProductImage;
@property (nonatomic,retain) NSMutableDictionary *tempdic;
- (void)displayProductImage:(NSMutableArray *)arrImagesUrls picToShowAtAIndex:(NSInteger)_picNum;


@end

