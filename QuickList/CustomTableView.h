//
//  CustomTableView.h
//  Smart Drop
//
//  Created by Sean Mullan on 5/16/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
@interface CustomTableView : NSTableView

@property (nonatomic) CAGradientLayer* gradientLayer;
@property (nonatomic) CALayer* solidLayer;
@property (nonatomic) NSColor* backgroundColor;
@property (nonatomic) NSColor* startingColor;
@property (nonatomic) NSColor* endingColor;
@property (nonatomic) int backgroundType;
@end
