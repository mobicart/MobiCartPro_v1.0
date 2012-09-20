//
//  MobicartParser.m
//  MobicartApp
//
//  Created by Mobicart on 29/09/10.
//  Copyright Mobicart. All rights reserved.
//

#import "MobicartParser.h"


@implementation MobicartParser
@synthesize strUrl;



-(id)initWithUrlString:(NSString *)_strUrl
{
    if (self = [super initWithContentsOfURL:[NSURL URLWithString:_strUrl]])
	{
        // Initialization code
		[self startParsing];
				
    }
    return self;
}


-(void)startParsing
{
	
	if(!stories)
		stories = [[NSMutableArray alloc] init];
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[super setDelegate:self];	
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
	[super setShouldProcessNamespaces:NO];
	[super setShouldReportNamespacePrefixes:NO];
	[super setShouldResolveExternalEntities:NO];
	
	[super parse];
	

}

#pragma mark Parser delegates

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
	[NewsViewController errorOccuredWhileParsing:errorString];
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{			
    
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"item"]) {
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		currentSummary = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
	}	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{     
	
	if ([elementName isEqualToString:@"item"]) {
		// save values to an item, then store that item into the array...
		[item setObject:currentTitle forKey:@"sTitle"];
		[item setObject:currentLink forKey:@"link"];
		[item setObject:currentSummary forKey:@"summary"];
		[item setObject:currentDate forKey:@"date"];
		
		[stories addObject:[item copy]];
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{	
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"title"]) {
		[currentTitle appendString:string];
	} else if ([currentElement isEqualToString:@"link"]) {
		[currentLink appendString:string];
	} else if ([currentElement isEqualToString:@"description"]) {
		[currentSummary appendString:string];
	} else if ([currentElement isEqualToString:@"pubDate"]) {
		[currentDate appendString:string];
	}
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	[NewsViewController reloadTableWithArray:stories];
}


@end

