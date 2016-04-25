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
        currentFolder = (FolderObject*)[NSEntityDescription insertNewObjectForEntityForName:@"FolderObject" inManagedObjectContext:context];
        currentFolder.type = FORoot;
        currentFolder.parentFolder = nil;
    }else if(fetchedObjects.count>1){
        NSLog(@"Error: Multiple RootFolders found");
        currentFolder = (FolderObject*)[NSEntityDescription insertNewObjectForEntityForName:@"FolderObject" inManagedObjectContext:context];
        currentFolder.type = FORoot;
        currentFolder.parentFolder = nil;
        for(FolderObject* folder in fetchedObjects){
            [currentFolder addSubfoldersObject:folder];
            folder.type = FODefault;
            folder.parentFolder = currentFolder;
            folder.name = @"Untitled Folder";
        }
    }else{
        currentFolder = [fetchedObjects lastObject];
    }
    
    return self;
}
-(FolderObject*)openFolder:(FolderObject *)folder{
    if([currentFolder doesContain:folder]){
        currentFolder = folder;
        return currentFolder;
    }
    return nil;
}
-(FolderObject*)newFolderNamed:(NSString*)name inFolder:(FolderObject*)parentFolder{
    FolderObject* newFolder = (FolderObject*)[NSEntityDescription insertNewObjectForEntityForName:@"FolderObject" inManagedObjectContext:context];
    newFolder.type = FODefault;
    newFolder.parentFolder = parentFolder;
    [parentFolder addSubfoldersObject:newFolder];
    return newFolder;
}
-(NSInteger)currentFolderSize{
    //should be 0 for anything other than FORoot and FODefault
    return [currentFolder.subfolders count];
}
@end
