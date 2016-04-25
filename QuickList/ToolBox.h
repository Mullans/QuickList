//
//  ToolBox.h
//  QuickList
//
//  Created by Sean Mullan on 4/24/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
@interface ToolBox : NSObject

/**
 *  Generates a one-column NSTableView for the given view
 *
 *  @param view NSView to fill with a table
 *
 *  @return NSArray: first object is the NSScrollView that holds the table, second object is the NSTableView
 */
+(NSArray*)makeTableForView:(NSView*)view;

@end
