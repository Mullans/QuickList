//
//  FolderObject+CoreDataProperties.m
//  QuickList
//
//  Created by Sean Mullan on 5/9/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FolderObject+CoreDataProperties.h"

@implementation FolderObject (CoreDataProperties)

@dynamic data;
@dynamic dateAdded;
@dynamic dateChanged;
@dynamic importance;
@dynamic name;
@dynamic type;
@dynamic parentFolder;
@dynamic subfolders;

@end
