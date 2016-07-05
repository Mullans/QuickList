//
//  NSTextField+points.m
//  MyPOS
//
//  Created by Sean Mullan on 8/13/15.
//  Copyright (c) 2015 SilentLupin. All rights reserved.
//

#import "NSView+points.h"

@implementation NSView (points)

-(float)rightX{
    return self.frame.origin.x+self.frame.size.width;
}
-(float)midX{
    return self.frame.origin.x+self.frame.size.width/2;
}
-(float)leftX{
    return self.frame.origin.x;
}
-(float)topY{
    return self.frame.origin.y+self.frame.size.height;
}
-(float)midY{
    return self.frame.origin.y+self.frame.size.height/2;
}
-(float)bottomY{
    return self.frame.origin.y;
}
-(CGPoint)bottomLeft{
    return self.frame.origin;
}
-(CGPoint)topLeft{
    return CGPointMake(self.frame.origin.x,self.frame.origin.y+self.frame.size.height);
}
-(CGPoint)topRight{
    return CGPointMake(self.frame.origin.x+self.frame.size.width, self.frame.size.height+self.frame.origin.y);
}
-(CGPoint)bottomRight{
    return CGPointMake(self.frame.origin.x+self.frame.size.width,self.frame.origin.y);
}
-(float)height{
    return self.frame.size.height;
}
-(float)width{
    return self.frame.size.width;
}
-(CGPoint)center{
    return CGPointMake(self.frame.origin.x+self.frame.size.width/2,self.frame.origin.y+self.frame.size.height/2);
}
@end
