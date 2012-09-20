//
//  Icon downloader.m
//  MobicartApp
//
//  Created by Mobicart on 10/29/10.
//  Copyright 2010 Mobicart. All rights reserved.
//

#import "IconDownloader.h"
#import "AppRecord.h"

#define kAppIconHeight 48


@implementation IconDownloader

@synthesize appRecord;
@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;

#pragma mark

- (void)dealloc
{
    [appRecord release];
    [indexPathInTableView release];
    
    [activeDownload release];
    
    [imageConnection cancel];
    [imageConnection release];
    
    [super dealloc];
}

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];

    NSURLRequest *request=appRecord.requestImg;
	NSURLConnection *conn;
    if(request)
    {
        conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        [conn start];
        
        self.imageConnection = conn;
        [conn release];

    }
    else
    {
		self.activeDownload = nil;
		self.imageConnection = nil;
	    [delegate appImageError:self.indexPathInTableView];
    }
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"%@",response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
	
	[delegate appImageError:self.indexPathInTableView];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    if (image.size.width != kAppIconHeight && image.size.height != kAppIconHeight)
	{
       
		CGSize itemSize=CGSizeMake(image.size.width, image.size.height);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.appRecord.appIcon = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.appRecord.appIcon = image;
    }
    
    self.activeDownload = nil;
    [image release];
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
        
    // call our delegate and tell it that our icon is ready for display
	if(delegate)
    {
        [delegate appImageDidLoad:self.indexPathInTableView];
    }
     
}

@end

