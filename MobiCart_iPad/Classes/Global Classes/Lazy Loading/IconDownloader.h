//
//  Icon downloader.h
//  MobicartApp
//
//  Created by mobicart on 10/29/10.
//  Copyright mobicart. All rights reserved.
//
@class AppRecord;
@class RootViewController;

@protocol IconDownloaderDelegate;

@interface IconDownloader : NSObject
{
    AppRecord *appRecord;
    NSIndexPath *indexPathInTableView;
    id <IconDownloaderDelegate> delegate;
	
	int index;
    BOOL chkForindex;
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, retain) AppRecord *appRecord;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign)  BOOL chkForindex;
@property (nonatomic, assign) id <IconDownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol IconDownloaderDelegate 

- (void)appImageDidLoad:(NSIndexPath *)indexPath chkValue:(BOOL)chkForindex;
- (void)appImageError:(NSIndexPath *)indexPath;

@end