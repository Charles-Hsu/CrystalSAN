//
//  XMLParser.h
//  CrystalSAN
//
//  Created by Charles Hsu on 3/14/13.
//  Copyright (c) 2013 Charles Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

//@class AppDelegate;

@interface XMLParser : NSObject {

    NSMutableString *currentElementValue;
    AppDelegate *appDelegate;
    
}

- (XMLParser *) initXMLParser;

@end
