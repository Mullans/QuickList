//
//  NSTextField+points.h
//  MyPOS
//
//  Created by Sean Mullan on 8/13/15.
//  Copyright (c) 2015 SilentLupin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (points)
@property (nonatomic,readonly) float rightX;
@property (nonatomic,readonly) float midX;
@property (nonatomic, readonly) float leftX;
@property (nonatomic,readonly) float topY;
@property (nonatomic,readonly) float midY;
@property (nonatomic,readonly) float bottomY;
@property (nonatomic,readonly) CGPoint bottomLeft;
@property (nonatomic,readonly) CGPoint bottomRight;
@property (nonatomic,readonly) CGPoint topRight;
@property (nonatomic,readonly) float height;
@property (nonatomic,readonly) float width;
@property (nonatomic, readonly) CGPoint center;
@end
