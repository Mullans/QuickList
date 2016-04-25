//
//  ToolBox.m
//  QuickList
//
//  Created by Sean Mullan on 4/24/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import "ToolBox.h"
@implementation ToolBox
+(NSArray *)makeTableForView:(NSView *)view{
    NSScrollView *tableContainer = [[NSScrollView alloc]initWithFrame:view.frame];
    NSTableView *tableView = [[NSTableView alloc] initWithFrame:view.frame];
    NSTableColumn* column1 = [[NSTableColumn alloc]initWithIdentifier:@"Column1"];
    [column1 setWidth:tableView.frame.size.width];
    [tableView addTableColumn:column1];
    [tableContainer setDocumentView:tableView];
    [tableContainer setHasVerticalScroller:YES];
    [tableContainer setHasHorizontalScroller:NO];
    return @[tableContainer,tableView];
}

@end
