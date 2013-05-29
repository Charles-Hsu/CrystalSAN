//
//  XMLCacheParser.h
//  CrystalSAN
//
//  Created by Charles Hsu on 3/14/13.
//  Copyright (c) 2013 Charles Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

//@class AppDelegate;

@interface XMLCacheParser : NSObject {

    NSMutableString *currentElementValue;
    AppDelegate *appDelegate;
    
}

- (XMLCacheParser *) initXMLParser;

@end
