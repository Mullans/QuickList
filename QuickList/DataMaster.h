//
//  DataMaster.h
//  QuickList
//
//  Created by Sean Mullan on 4/24/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "FolderObject.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, FOFolderType) {
    FORoot,
    FODefault,
    FOHTML,
    FOLocalURL,
    FOTextFile,
    FOImage,
    FOPDF
};

@interface DataMaster : NSObject{
    NSMutableArray* scrollViews;
    NSMutableArray* tables;
    NSManagedObjectContext* context;
}

@property (nonatomic,readonly) NSMutableArray* data;
@property (nonatomic,readonly) NSInteger tableCount;
@property (nonatomic, readonly) NSInteger currentFolderSize;
@property (nonatomic, readonly) NSArray* currentFolderContents;
@property (nonatomic) NSString* currentFolderName;
@property (nonatomic, readonly) FolderObject* currentFolder;
-(void)addNewTable:(NSTableView*)table scroll:(NSScrollView*)scrollView;
-(void)removeTableAtIndex:(NSInteger)index;
-(void)deleteItem:(FolderObject*)item;
-(void)save;
/**
 *  Returns NSArray for the given index
 *
 *  @param index NSInteger for the desired data
 *
 *  @return NSArray: first object is the NSScrollView that holds the table, second object is the NSTableView
 */
-(NSArray*)getTableAtIndex:(NSInteger)index;
-(NSArray*)getDataForTable:(NSTableView*)table;

NS_ASSUME_NONNULL_END

/**
 *  Generates a one-column NSTableView for the given view
 *
 *  @param view NSView to fill with a table
 *  @param dataSource dataSource to assign to NSTtableViews
 *  @param delegate   delegate to assign to NSTableViews
 *
 *  @return NSArray: first object is the NSScrollView that holds the table, second object is the NSTableView
 */
+(nonnull NSArray*)makeTableForView:(NSView* _Nonnull)view dataSource:(id<NSTableViewDataSource> _Nullable)dataSource delegate:(id<NSTableViewDelegate> _Nullable)delegate;

/**
 *  Generates a one-column NSTableView for the given view and adds it to the DataMaster object
 *
 *  @param view NSView to fill with a table
 *  @param dataSource dataSource to assign to NSTtableViews
 *  @param delegate   delegate to assign to NSTableViews
 *  @param data  data to match the NSTableView
 *
 *  @return NSArray: first object is the NSScrollView that holds the table, second object is the NSTableView
 */
-(nonnull NSArray*)makeTableForView:(nonnull NSView*)view dataSource:(nullable id<NSTableViewDataSource>)dataSource delegate:(nullable id<NSTableViewDelegate>)delegate withData:(nonnull NSArray*)data;

/**
 *  Initialize the DataMaster with a reference to the app's CoreData
 *
 *  @param managedContext NSManagedObjectContext from AppDelegate
 *
 *  @return new instance of DataMaster with context
 */
-(nonnull instancetype)initWithContext:(nonnull NSManagedObjectContext*)managedContext;

-(nonnull FolderObject*)openFolder:(nonnull FolderObject*)folder;
-(nonnull FolderObject*)openParentFolder;
-(nonnull FolderObject*)newFolderNamed:(nonnull NSString*)name inFolder:(nullable FolderObject*)parentFolder;
@end
