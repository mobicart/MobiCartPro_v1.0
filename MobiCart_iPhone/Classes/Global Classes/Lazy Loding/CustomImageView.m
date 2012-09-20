//
//  CustomImageView.m
//  DokTalk
//
//  Created by MobiCart on 14/07/11.
//
//

#import "CustomImageView.h"


@implementation CustomImageView



@synthesize imageObject = _imageObject;



- (void) loadImageFromUrl:(NSURL*)url {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    NSData * data = [[NSData alloc]initWithContentsOfURL:url];
    UIImage * image = [[UIImage alloc]initWithData:data];
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

- (id)initWithUrl:(NSURL *)url frame:(CGRect)frame {
    
    self = [super init];
    if (self) {
        [self setClipsToBounds:YES];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.frame = frame;
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.frame = CGRectMake((frame.size.width-20)/2, (frame.size.height-20)/2, 20.0, 20.0);
        [_indicator hidesWhenStopped];
        [_indicator setHidden:YES];
        [self addSubview:_indicator];
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
