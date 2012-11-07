//
//  CustomImageView.h

//

#import <UIKit/UIKit.h>


@interface CustomImageView : UIImageView {
    
    NSURL * _imageUrl;
    UIImage * _imageObject;
    UIActivityIndicatorView * _indicator;
    
}

@property (nonatomic, retain) UIImage * imageObject;
@property (nonatomic) int isFromCart;

- (id)initWithUrl:(NSURL *)url frame:(CGRect)frame isFrom:(int)isFromCart;
- (void) showImage:(NSURL *)url;

@end