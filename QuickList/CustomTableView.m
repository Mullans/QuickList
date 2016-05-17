//
//  CustomTableView.m
//  Smart Drop
//
//  Created by Sean Mullan on 5/16/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import "CustomTableView.h"

@implementation CustomTableView

- (void)drawRect:(NSRect)dirtyRect{
    NSLog(@"%f",self.numberOfRows*self.rowHeight);
    CGRect drawingRect = CGRectMake(0, self.numberOfRows*40+dirtyRect.origin.y, dirtyRect.size.width, dirtyRect.size.height-self.numberOfRows*40);
    [super drawRect:dirtyRect];
    NSColor* startingColor = [NSColor colorWithRed:0.8088 green:0.6379 blue:1.0 alpha:1.0];
    NSColor* endingColor = [NSColor colorWithRed:0.3567 green:0.0001 blue:0.6258 alpha:1.0];
    NSGradient* gradient = [[NSGradient alloc]initWithStartingColor:startingColor endingColor:endingColor];
    [gradient drawInRect:drawingRect angle:80];
    // Drawing code here.
}

@end
