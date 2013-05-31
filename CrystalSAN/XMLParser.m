//
//  XMLParser.m
//  CrystalSAN
//
//  Created by Charles Hsu on 3/14/13.
//  Copyright (c) 2013 Charles Hsu. All rights reserved.
//

#import "XMLParser.h"

@interface XMLParser () {
    
    NSString *tableName;
    NSMutableArray *records;
    NSMutableDictionary *dict;
}

@end


@implementation XMLParser

- (XMLParser *) initXMLParser {
	
	self = [super init];
	
	appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    records = [[NSMutableArray alloc] init];
    
    //dict = [[NSMutableDictionary alloc] init];
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
    NSLog(@"%s elementName=%@, namespaceURI=%@, qualifiedName=%@, attributes=%@", __func__, elementName, namespaceURI, qualifiedName, attributeDict);
    

    
	if ([elementName isEqualToString:@"Books"]) {
		//Initialize the array.
		//appDelegate.books = [[NSMutableArray alloc] init];
	}
	//else if([elementName isEqualToString:@"Book"]) {
    else if ([elementName isEqualToString:@"record"]) {
		
		//Initialize the book.
		//aBook = [[Book alloc] init];
        
        dict = [[NSMutableDictionary alloc] init];
		
		//Extract the attribute here.
		//aBook.bookID = [[attributeDict objectForKey:@"id"] integerValue];
		
		//NSLog(@"Reading id value :%i", aBook.bookID);
	} else if ([elementName isEqualToString:@"table"]) {
        /*
         2013-05-31 12:38:31.867 CrystalSAN[2070:c07] -[XMLParser parser:didStartElement:namespaceURI:qualifiedName:attributes:] elementName=table, namespaceURI=(null), qualifiedName=(null), attributes={
         name = "engine_cli_conmgr_drive_status";
         }
         */
        tableName = [attributeDict valueForKey:@"name"];

    }
	
	//NSLog(@"<%@>", elementName);
    
    if (tableName == nil) {
        tableName = elementName;
        //NSLog(@"tableName=%@", tableName);
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{	
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
    NSLog(@"%s elementName=%@, namespaceURI=%@, qualifiedName=%@", __func__, elementName, namespaceURI, qName);
    
	//if([elementName isEqualToString:@"Books"])
    if([elementName isEqualToString:@"ha_cluster"]) {
        //NSLog(@"elementName=%@", elementName);
        //NSLog(@"write to database");
        tableName = nil;
		return;
    }
    
    //NSLog(@"</%@>", elementName);
	
	//There is nothing to do if we encounter the Books element here.
	//If we encounter the Book element howevere, we want to add the book object to the array
	// and release the object.
    /*
	if([elementName isEqualToString:@"book"]) {
		[appDelegate.books addObject:aBook];
		
		[aBook release];
		aBook = nil;
	}
	else
		[aBook setValue:currentElementValue forKey:elementName];
	*/
     if([elementName isEqualToString:@"record"]) {

        // NSLog(@"%s Dict = %@", __func__, dict);
          [appDelegate insertInto:tableName values:dict];
     }
     else {
         //[aBook setValue:currentElementValue forKey:elementName];
         [dict setValue:currentElementValue forKey:elementName];
     }

	//[currentElementValue release]; // *** ARC forbids explicit message send of 'release'
	currentElementValue = nil;
}


@end
