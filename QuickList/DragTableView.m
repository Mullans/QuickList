//
//  DragTableView.m
//  QuickList
//
//  Created by Sean Mullan on 5/1/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import "DragTableView.h"

@implementation DragTableView

-(id)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if(self){
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSPasteboardTypeHTML,NSPasteboardTypePNG,NSPasteboardTypeString, nil]];
        NSLog(@"Drag init");
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
