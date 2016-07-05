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
    
    if(_backgroundType==0){
        if(_gradientLayer==nil){
            if(_solidLayer!=nil){
                [_solidLayer removeFromSuperlayer];
                _solidLayer = nil;
            }
            _gradientLayer = [CAGradientLayer layer];
            if(_startingColor==nil){
                _startingColor = [NSColor colorWithRed:0.8088 green:0.6379 blue:1.0 alpha:1.0];
            }
            if(_endingColor==nil){
                _endingColor = [NSColor colorWithRed:0.3567 green:0.0001 blue:0.6258 alpha:1.0];
            }
            _gradientLayer.colors = [NSArray arrayWithObjects:(id)[_startingColor CGColor], (id)[_endingColor CGColor], nil];
            [self.layer insertSublayer:_gradientLayer atIndex:0];
            [_gradientLayer setFrame:self.bounds];
            _gradientLayer.autoresizingMask = kCALayerWidthSizable|kCALayerHeightSizable;
        }
    }else if(_backgroundType==1){
        if(_solidLayer==nil){
            if(_gradientLayer!=nil){
                [_gradientLayer removeFromSuperlayer];
                _gradientLayer = nil;
            }
            _solidLayer = [CALayer layer];
            if(_backgroundColor == nil){
                _backgroundColor = [NSColor purpleColor];
            }
            _solidLayer.backgroundColor = [_backgroundColor CGColor];
            [self.layer insertSublayer:_solidLayer atIndex:0];
            [_solidLayer setFrame:self.bounds];
            _solidLayer.autoresizingMask = kCALayerWidthSizable|kCALayerHeightSizable;
        }
    }
}

@end
