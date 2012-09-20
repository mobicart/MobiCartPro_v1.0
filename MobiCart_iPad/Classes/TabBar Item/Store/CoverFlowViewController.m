//
//  CoverFlowViewController.m
//  CoverFlow
//
//  Created by Mobicart on 4/7/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "CoverFlowViewController.h"
#import "Constants.h"

@implementation CoverFlowViewController

@synthesize PickerPopover;
@synthesize arrImages, dataForProductImage,tempdic;

- (void)displayProductImage:(NSMutableArray *)arrImagesUrls picToShowAtAIndex:(NSInteger)_picNum 
{
	if ([arrImagesUrls count]==0)
	{
		dataForProductImage = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noImage_M" ofType:@"png"]];
	}
	else 
	{
		dataForProductImage = [ServerAPI fetchBannerImage:[[arrImages objectAtIndex:_picNum] objectForKey:@"productImageCoverFlowIpad"]];
	}
    
	if (!dataForProductImage)
	{
		dataForProductImage = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noImage_M" ofType:@"png"]];
	}
	
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.navigationController.navigationBar.hidden = NO;
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];     
    coverflowBackView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    coverflowBackView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:coverflowBackView];
    
    
    viewAF=[[AFOpenFlowView alloc]initWithFrame:CGRectMake(0,-55,1024,748)];
	viewAF.dataSource=self;
	viewAF.viewDelegate=self;
	[coverflowBackView addSubview:viewAF];
    
    [self LoadCoverflow];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}
#pragma mark LoadCoverflow
-(void)LoadCoverflow
{
    
    for(int j=0;j<[arrImages  count];j++)
	{
        [self displayProductImage:arrImages picToShowAtAIndex:j];
       UIImage *result=[UIImage  imageWithData:dataForProductImage];
       [viewAF setImage:result forIndex:j];
        
    }
	[viewAF setNumberOfImages:[arrImages count]];
    
    
}
-(void)openFlowView: (AFOpenFlowView *)openFlowView selectionDidChange:(int)index
{

}
- (void)openFlowView: (AFOpenFlowView *)openFlowView imageSelected:(int)index
{
    [self displayProductImage:arrImages picToShowAtAIndex:index];
	
}
-(void)viewWillAppear:(BOOL)animated
{        
	[NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(hideIndicator) userInfo:nil repeats:NO];	
	[self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
}	

-(void)hideIndicator

{
    
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
     [GlobalPrefrences dismissLoadingBar_AtBottom];
     [pool release];
 
}	
@end
