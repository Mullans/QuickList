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
    [super drawRect:dirtyRect];
    if(_gradientLayer==nil){
        _gradientLayer = [CAGradientLayer layer];
        NSColor* startingColor = [NSColor colorWithRed:0.8088 green:0.6379 blue:1.0 alpha:1.0];
        NSColor* endingColor = [NSColor colorWithRed:0.3567 green:0.0001 blue:0.6258 alpha:1.0];
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = [NSArray arrayWithObjects:(id)[startingColor CGColor], (id)[endingColor CGColor], nil];
        [self.layer insertSublayer:_gradientLayer atIndex:0];
        [_gradientLayer setFrame:self.bounds];
        _gradientLayer.autoresizingMask = kCALayerWidthSizable|kCALayerHeightSizable;
    }
}

@end
