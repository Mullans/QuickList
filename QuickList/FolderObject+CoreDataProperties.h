//
//  FolderObject+CoreDataProperties.h
//  QuickList
//
//  Created by Sean Mullan on 5/9/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FolderObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface FolderObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *data;
@property (nonatomic) NSTimeInterval dateAdded;
@property (nonatomic) NSTimeInterval dateChanged;
@property (nonatomic) int16_t importance;
@property (nullable, nonatomic, retain) NSString *name;
@property (nonatomic) int16_t type;
@property (nullable, nonatomic, retain) FolderObject *parentFolder;
@property (nullable, nonatomic, retain) NSSet<FolderObject *> *subfolders;

@end

@interface FolderObject (CoreDataGeneratedAccessors)

- (void)addSubfoldersObject:(FolderObject *)value;
- (void)removeSubfoldersObject:(FolderObject *)value;
- (void)addSubfolders:(NSSet<FolderObject *> *)values;
- (void)removeSubfolders:(NSSet<FolderObject *> *)values;

@end

NS_ASSUME_NONNULL_END
