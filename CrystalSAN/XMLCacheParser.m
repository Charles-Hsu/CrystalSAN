//
//  XMLCacheParser.m
//  CrystalSAN
//
//  Created by Charles Hsu on 3/14/13.
//  Copyright (c) 2013 Charles Hsu. All rights reserved.
//

#import "XMLCacheParser.h"

@interface XMLCacheParser () {
    
    NSString *tableName;
    NSMutableArray *records;
    NSMutableDictionary *dict;
}

@end


@implementation XMLCacheParser

- (XMLCacheParser *) initXMLParser {
	self = [super init];
	appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    records = [[NSMutableArray alloc] init];
 	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
    if([elementName isEqualToString:@"record"]) {
        dict = [[NSMutableDictionary alloc] init];
	}
    if (tableName == nil) {
        tableName = elementName;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {	
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"record"]) {
        [appDelegate insertIntoCache:tableName values:dict];
    }
    else {
        [dict setValue:currentElementValue forKey:elementName];
    }
	currentElementValue = nil;
}


@end
