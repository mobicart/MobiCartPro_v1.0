//
//  HSMobicartParser.h
//  MobicartApp
//
//  Created by Mobicart on 29/09/10.
//  Copyright Mobicart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface HSMobicartParser : NSXMLParser<NSXMLParserDelegate> {
	
	NSMutableDictionary * item;
	NSString * currentElement;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink;
	NSMutableArray *stories;
	
	NSString *strUrl;
}


@property (nonatomic, retain) NSString *strUrl;


-(id)initWithUrlString:(NSString *)_strUrl;

-(void)startParsing;
@end
