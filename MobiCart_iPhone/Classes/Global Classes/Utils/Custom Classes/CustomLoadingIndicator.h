//
//  CustomLoadingIndicator.h
//  MobicartApp
//
//  Created by Mobicart on 12/10/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CustomLoadingIndicator : UIActivityIndicatorView {

}
+ (id)shared;

- (id)initLoadingIndicator_WithFrame:(CGRect)_frame onView:(UIView *)_topView;
- (void)startLoadingIndicator;
- (void)stopLoadingIndicator;


@end
