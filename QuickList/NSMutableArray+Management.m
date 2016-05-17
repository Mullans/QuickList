//
//  NSMutableArray+Management.m
//  QuickList
//
//  Created by Sean Mullan on 4/25/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import "NSMutableArray+Management.h"

@implementation NSMutableArray (Management)
-(void)removeObjectsAfterIndex:(NSInteger)index{
    if(index<=self.count-1){
        [self removeObjectsInRange:NSMakeRange(index, self.count-index-1)];
    }
}
-(void)addObjects:(id)object1, ...{
    id eachObject;
    va_list argumentList;
    if (object1) // The first argument isn't part of the varargs list,
    {                                   // so we'll handle it separately.
        [self addObject:object1];
        va_start(argumentList, object1); // Start scanning for arguments after firstObject.
        while ((eachObject = va_arg(argumentList, id))) // As many times as we can get an argument of type "id"
            [self addObject: eachObject]; // that isn't nil, add it to self's contents.
        va_end(argumentList);
    }
}
@end
