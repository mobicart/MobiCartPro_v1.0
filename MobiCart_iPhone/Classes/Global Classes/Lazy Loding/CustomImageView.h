//
//  CustomImageView.h

//
//  Created by MobiCart.
//

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
