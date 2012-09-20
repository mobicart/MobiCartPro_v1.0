//
//  webViewVideo.h
// 
//
//  Created by Mobicart on 3/29/10.
//  Copyright Mobicart. All rights reserved.
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
