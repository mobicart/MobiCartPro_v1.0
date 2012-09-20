//
//  CustomImageView.h
//  DokTalk
//
//  Created by Mobicart on 14/07/11.


#import <UIKit/UIKit.h>


@interface CustomImageView : UIImageView {
    
    NSURL * _imageUrl;
    UIImage * _imageObject;
    UIActivityIndicatorView * _indicator;
}

@property (nonatomic, retain) UIImage * imageObject;

- (id)initWithUrl:(NSURL *)url frame:(CGRect)frame;
- (void) showImage:(NSURL *)url;

@end
