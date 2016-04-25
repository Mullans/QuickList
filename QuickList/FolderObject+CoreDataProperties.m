//
//  FolderObject+CoreDataProperties.m
//  QuickList
//
//  Created by Sean Mullan on 4/25/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FolderObject+CoreDataProperties.h"

@implementation FolderObject (CoreDataProperties)

@dynamic type;
@dynamic data;
@dynamic name;
@dynamic subfolders;
@dynamic parentFolder;

@end
