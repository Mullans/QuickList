//
//  NSMutableArray+Management.h
//  QuickList
//
//  Created by Sean Mullan on 4/25/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Management)
-(void)removeObjectsAfterIndex:(NSInteger)index;
-(void)addObjects:(id)object1,... NS_REQUIRES_NIL_TERMINATION;
@end
