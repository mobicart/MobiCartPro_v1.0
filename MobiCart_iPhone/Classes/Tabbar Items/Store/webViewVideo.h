//
//  webViewVideo.h
//  MobiCart
//
//  Created by Mobicart on 8/7/10.
//  Copyright 2010 Mobicart. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface webViewVideo : UIViewController<UIWebViewDelegate> 
{
	UIView *contentView;
	UIWebView *videoWeb;

	NSString *strVideo;
}
@property (nonatomic,retain) NSString *strVideo;

- (UIWebView *)embedYouTube:(NSString *)urlString frame:(CGRect)frame;

@end
