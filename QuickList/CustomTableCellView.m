//
//  CustomTableCellView.m
//  QuickList
//
//  Created by Sean Mullan on 4/24/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import "CustomTableCellView.h"
@implementation CustomTableCellView
@synthesize isFolder = _isFolder;

- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
    [_cellColor setStroke];
    float inset = 2;
    CGRect insetRect = CGRectMake(dirtyRect.origin.x, dirtyRect.origin.y+inset, dirtyRect.size.width, dirtyRect.size.height-inset*2);
    float rightX = insetRect.origin.x+insetRect.size.width;
    float topY = insetRect.origin.y+insetRect.size.height;
    NSColor *background = [NSColor colorWithRed:_cellColor.redComponent green:_cellColor.greenComponent blue:_cellColor.blueComponent alpha:1];
    [background setFill];
    NSBezierPath* path;
    if(!self.isFolder){
        path = [NSBezierPath bezierPath];
        [path moveToPoint:insetRect.origin];
        [path lineToPoint:CGPointMake(rightX-20,insetRect.origin.y)];
        [path curveToPoint:CGPointMake(rightX-20,topY)
             controlPoint1:CGPointMake(rightX+2,topY*.05)
             controlPoint2:CGPointMake(rightX+2,topY*.95)];
        [path lineToPoint:CGPointMake(insetRect.origin.x,topY)];
        [path lineToPoint:insetRect.origin];
    }else{
        path = [NSBezierPath bezierPathWithRect:insetRect];
    }

    [[NSColor blackColor] setStroke];
    [path setLineWidth:2];
    [path stroke];
    [path fill];



}

-(void)setCellColor:(NSColor *)borderColor{
    _cellColor = borderColor;
    [self needsDisplay];
}

-(BOOL)isFolder{
    return _isFolder;
}
-(void)setIsFolder:(BOOL)isFolder{
    _isFolder = isFolder;
    [self needsDisplay];
}
@end
