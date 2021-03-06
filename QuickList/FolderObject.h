//
//  FolderObject.h
//  QuickList
//
//  Created by Sean Mullan on 4/25/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Cocoa/Cocoa.h>
NS_ASSUME_NONNULL_BEGIN

@interface FolderObject : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
@property (nonatomic, readonly) NSString* identifier;

@end

NS_ASSUME_NONNULL_END

#import "FolderObject+CoreDataProperties.h"
