//
//  XMLParser.m
//  CrystalSAN
//
//  Created by Charles Hsu on 3/14/13.
//  Copyright (c) 2013 Charles Hsu. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser

- (XMLParser *) initXMLParser {
	
	self = [super init];
	
	appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"Books"]) {
		//Initialize the array.
		//appDelegate.books = [[NSMutableArray alloc] init];
	}
	else if([elementName isEqualToString:@"Book"]) {
		
		//Initialize the book.
		//aBook = [[Book alloc] init];
		
		//Extract the attribute here.
		//aBook.bookID = [[attributeDict objectForKey:@"id"] integerValue];
		
		//NSLog(@"Reading id value :%i", aBook.bookID);
	}
	
	NSLog(@"Processing Element: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{	
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
	
	NSLog(@"Processing Value: %@", currentElementValue);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if([elementName isEqualToString:@"Books"])
		return;
	
	//There is nothing to do if we encounter the Books element here.
	//If we encounter the Book element howevere, we want to add the book object to the array
	// and release the object.
    /*
	if([elementName isEqualToString:@"Book"]) {
		[appDelegate.books addObject:aBook];
		
		[aBook release];
		aBook = nil;
	}
	else
		[aBook setValue:currentElementValue forKey:elementName];
	*/
	//[currentElementValue release];
	currentElementValue = nil;
}


@end
