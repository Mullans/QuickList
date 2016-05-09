//
//  FolderObject.m
//  QuickList
//
//  Created by Sean Mullan on 4/25/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import "FolderObject.h"

@implementation FolderObject

// Insert code here to add functionality to your managed object subclass
-(NSString *)identifier{
     return [NSString stringWithFormat:@"%@-%f",self.name,self.dateAdded];
}

@end
