//
//  CustomTableCellView.m
//  Smart Drop
//
//  Created by Sean Mullan on 4/24/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import "CustomTableCellView.h"

@implementation CustomTableCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [_borderColor setStroke];
    NSColor *background = [NSColor colorWithRed:_borderColor.redComponent green:_borderColor.greenComponent blue:_borderColor.blueComponent alpha:0.05];
    [background setFill];
    NSBezierPath* path = [NSBezierPath bezierPathWithRect:dirtyRect];
    [path setLineWidth:2];
    [path stroke];
    [path fill];
    // Drawing code here.
}

-(void)setBorderColor:(NSColor *)borderColor{
    _borderColor = borderColor;
    [self needsDisplay];
}
@end
