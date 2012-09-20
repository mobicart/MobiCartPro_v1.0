//
//  LeavesView.h
//  Leaves
//
//  Created by Mobicart on 4/18/10.
//  Copyright Mobicart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class LeavesCache;

typedef enum {
    LeavesViewModeSinglePage,
    LeavesViewModeFacingPages,
} LeavesViewMode;





@protocol LeavesViewDataSource;
@protocol LeavesViewDelegate;

@interface LeavesView : UIView {
	CALayer *topPage;
	CALayer *topPageOverlay;
	CAGradientLayer *topPageShadow;
	
	CALayer *topPageReverse;
	CALayer *topPageReverseImage;
	CALayer *topPageReverseOverlay;
	CAGradientLayer *topPageReverseShading;
	
	CALayer *bottomPage;
	CAGradientLayer *bottomPageShadow;

	CALayer *leftPageOverlay;
    CALayer *leftPage,*basePage;
    LeavesViewMode mode;
    
	CGFloat leafEdge;
   	NSUInteger currentPageIndex;
	NSUInteger numberOfPages;
    NSUInteger numberOfVisiblePages;
	id<LeavesViewDelegate> delegate;
	
	CGSize pageSize;
	LeavesCache *pageCache;
	BOOL backgroundRendering;
	
	CGPoint touchBeganPoint;
	BOOL touchIsActive;
	CGRect nextPageRect, prevPageRect;
	BOOL interactionLocked;
}

@property (assign) id<LeavesViewDataSource> dataSource;
@property (assign) id<LeavesViewDelegate> delegate;
@property (assign) LeavesViewMode mode;
@property (readonly) CGFloat targetWidth;
@property (assign) NSUInteger currentPageIndex;
@property (assign) BOOL backgroundRendering;
@property(nonatomic,retain) CALayer *basePage;
- (void) reloadData;

@end


@protocol LeavesViewDataSource <NSObject>

- (NSUInteger) numberOfPagesInLeavesView:(LeavesView*)leavesView;
- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx;

@end

@protocol LeavesViewDelegate <NSObject>

@optional

- (void) leavesView:(LeavesView *)leavesView willTurnToPageAtIndex:(NSUInteger)pageIndex;
- (void) leavesView:(LeavesView *)leavesView didTurnToPageAtIndex:(NSUInteger)pageIndex;

@end
