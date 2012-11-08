//
//  CustomImageView.m
//
//
//  Created by MobiCart on 14/07/11.
//
//

#import "CustomImageView.h"

@implementation CustomImageView

@synthesize isFromCart = _isFromCart;

@synthesize imageObject = _imageObject;



- (void) loadImageFromUrl:(NSURL*)url {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    NSData * data = [[NSData alloc]initWithContentsOfURL:url];
    UIImage * image = [[UIImage alloc]initWithData:data];
    int x1,y1;
    if(_isFromCart)
    {
        
        y1= (67-image.size.height/2)/2;
        x1 = (67 - image.size.width/2+5)/2;
        [self setFrame:CGRectMake(x1, y1+4, image.size.width/2-5, image.size.height/2-10)];
        
    }
    
    
    [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    
    [image release];
    [data release];
    [pool release];
}

- (void) setImage:(UIImage *)image {
    
    [super setImage:image];
    [_indicator stopAnimating];
    [_indicator setHidden:YES];
}

- (void) showImage:(NSURL *)url {
    
    [_indicator setHidden:NO];
    [_indicator startAnimating];
    [NSThread detachNewThreadSelector:@selector(loadImageFromUrl:) toTarget:self withObject:url];
}

- (id) init {
    
    return nil;
}

- (id)initWithUrl:(NSURL *)url frame:(CGRect)frame isFrom:(int)isFromCart{
    
    self = [super init];
    if (self) {
        _isFromCart=isFromCart;
        
        
        [self setClipsToBounds:YES];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.frame = frame;
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        _indicator.frame = CGRectMake((frame.size.width-20)/2, (frame.size.height-20)/2, 20.0, 20.0);
        [_indicator hidesWhenStopped];
        [_indicator setHidden:YES];
        [self addSubview:_indicator];
        self.contentMode = UIViewContentModeScaleAspectFit;
        [self showImage:url];
    }
    
    return self;
}

- (void)dealloc {
    
    [_indicator release];
    _indicator = nil;
    [_imageObject release];
    self.imageObject = nil;
    [super dealloc];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
