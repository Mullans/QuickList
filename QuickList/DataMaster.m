//
//  DataMaster.m
//  QuickList
//
//  Created by Sean Mullan on 4/24/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import "DataMaster.h"

@implementation DataMaster
+(NSArray*)makeTableForView:(NSView* _Nonnull)view dataSource:(id<NSTableViewDataSource> _Nullable)dataSource delegate:(id<NSTableViewDelegate> _Nullable)delegate{
    NSScrollView *tableContainer = [[NSScrollView alloc]initWithFrame:view.frame];
    NSTableView *tableView = [[NSTableView alloc] initWithFrame:view.frame];
    NSTableColumn* column1 = [[NSTableColumn alloc]initWithIdentifier:@"Column1"];
    [column1 setWidth:tableView.frame.size.width];
    [tableView addTableColumn:column1];
    [tableView setHeaderView:nil];
    [tableView setAutoresizingMask:NSViewWidthSizable];
    [tableView setIntercellSpacing:NSMakeSize(0, 0)];
    [tableView setAllowsMultipleSelection:YES];
    [tableContainer setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [tableContainer setDocumentView:tableView];
    [tableContainer setHasVerticalScroller:YES];
    [tableContainer setHasHorizontalScroller:NO];
    if(dataSource!=nil){
        tableView.dataSource = dataSource;
    }
    if(delegate!=nil){
        tableView.delegate = delegate;
    }
    [tableView setDoubleAction:@selector(tableDoubleClicked:)];
    return @[tableContainer,tableView];
}
-(NSArray*)makeTableForView:(NSView* _Nonnull)view dataSource:(id<NSTableViewDataSource> _Nullable)dataSource delegate:(id<NSTableViewDelegate> _Nullable)delegate withData:(nonnull NSArray*)data{
    NSArray *returnArray = [DataMaster makeTableForView:view dataSource:dataSource delegate:delegate];
    [tables addObject:returnArray[1]];
    [scrollViews addObject:returnArray[0]];
    [_data addObject:data];
    return returnArray;
}
-(instancetype)init{
    tables = [[NSMutableArray alloc]initWithCapacity:5];
    scrollViews = [[NSMutableArray alloc]initWithCapacity:5];
    _data = [[NSMutableArray alloc]initWithCapacity:5];
    return self;
}
-(NSInteger)tableCount{
    return tables.count;
}
-(void)addNewTable:(NSTableView *)table scroll:(NSScrollView *)scrollView{
    [tables addObject:table];
    [scrollViews addObject:scrollView];
}
-(void)removeTableAtIndex:(NSInteger)index{
    [tables removeObjectAtIndex:index];
    [scrollViews removeObjectAtIndex:index];
}
-(NSArray *)getTableAtIndex:(NSInteger)index{
    return @[[scrollViews objectAtIndex:index],[tables objectAtIndex:index]];
}
-(NSObject *)getDataFromTable:(NSInteger)tableIndex atIndex:(NSInteger)index{
    return tables[tableIndex][index];
}
-(NSArray*)getDataForTable:(NSTableView*)table{
    NSInteger index = [tables indexOfObject:table];
    if(index!=NSNotFound){
        return _data[index];
    }else{
        return nil;
    }
}
#pragma mark - CoreData Methods
-(instancetype)initWithContext:(NSManagedObjectContext*)managedContext{
    tables = [[NSMutableArray alloc]initWithCapacity:5];
    scrollViews = [[NSMutableArray alloc]initWithCapacity:5];
    _data = [[NSMutableArray alloc]initWithCapacity:5];
    context = managedContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"FolderObject" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type=%lui",FORoot];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if(fetchedObjects==nil){
        NSLog(@"Error Loading DataMaster");
    }
    if(fetchedObjects.count==0){
        _currentFolder = (FolderObject*)[NSEntityDescription insertNewObjectForEntityForName:@"FolderObject" inManagedObjectContext:context];
        _currentFolder.type = FORoot;
        _currentFolder.parentFolder = nil;
        _currentFolder.dateAdded = [[NSDate date] timeIntervalSince1970];
        _currentFolder.dateChanged = [[NSDate date]timeIntervalSince1970];
        _currentFolder.importance = 0;
        _currentFolder.name = @"RootFolder";
    }else if(fetchedObjects.count>1){
        NSLog(@"Error: Multiple RootFolders found");
        _currentFolder = (FolderObject*)[NSEntityDescription insertNewObjectForEntityForName:@"FolderObject" inManagedObjectContext:context];
        _currentFolder.type = FORoot;
        _currentFolder.parentFolder = nil;
        _currentFolder.name = @"RootFolder";
        _currentFolder.dateAdded = [[NSDate date] timeIntervalSince1970];
        _currentFolder.dateChanged = [[NSDate date]timeIntervalSince1970];
        _currentFolder.importance = 0;
        for(FolderObject* folder in fetchedObjects){
            [_currentFolder addSubfoldersObject:folder];
            folder.type = FODefault;
            folder.parentFolder = _currentFolder;
            folder.name = @"Untitled Folder";
        }
    }else{
        _currentFolder = [fetchedObjects lastObject];
    }
    return self;
}
-(FolderObject*)openFolder:(FolderObject *)folder{
    if(folder.parentFolder == _currentFolder){
        _currentFolder = folder;
        return _currentFolder;
    }
    return nil;
}
-(FolderObject*)openParentFolder{
    if(_currentFolder.type==FORoot){
        return nil;
    }else{
        _currentFolder = _currentFolder.parentFolder;
        return _currentFolder;
    }
}
-(nonnull FolderObject*)newFolderNamed:(nonnull NSString*)name inFolder:(nullable FolderObject*)parentFolder{
    if(parentFolder==nil){
        parentFolder = _currentFolder;
    }
    FolderObject* newFolder = (FolderObject*)[NSEntityDescription insertNewObjectForEntityForName:@"FolderObject" inManagedObjectContext:context];
    newFolder.type = FODefault;
    newFolder.name = name;
    newFolder.dateAdded = [[NSDate date] timeIntervalSince1970];
    newFolder.dateChanged = [[NSDate date]timeIntervalSince1970];
    newFolder.importance = 5;
    newFolder.parentFolder = parentFolder;
    [parentFolder addSubfoldersObject:newFolder];
    return newFolder;
}
-(NSInteger)currentFolderSize{
    //should be 0 for anything other than FORoot and FODefault
    return [_currentFolder.subfolders count];
}
-(NSArray *)currentFolderContents{
    return [_currentFolder.subfolders allObjects];
}
-(NSString *)currentFolderName{
    return _currentFolder.name;
}
-(void)setCurrentFolderName:(NSString *)currentFolderName{
    _currentFolder.name = currentFolderName;
}
-(void)deleteItem:(FolderObject*)item{
    NSMutableArray* toDelete = [[NSMutableArray alloc]initWithObjects:item, nil];
    if(item.type==FODefault){
        for(FolderObject* subItem in item.subfolders){
            [self addItemToDelete:subItem fromArray:toDelete];
        }
    }
    for(FolderObject* subItem in toDelete){
        [subItem.parentFolder removeSubfoldersObject:item];
        [context deleteObject:subItem];
//        NSLog(@"deleted object: %@",subItem.name);
    }
}
-(NSMutableArray*)addItemToDelete:(FolderObject*)item fromArray:(NSMutableArray*)array{
    [array addObject:item];
    for(FolderObject* subItem in item.subfolders){
        [self addItemToDelete:subItem fromArray:array];
    }
    return array;
}
@end
