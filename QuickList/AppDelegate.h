//
//  AppDelegate.h
//  QuickList
//
//  Created by Sean Mullan on 4/24/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DataMaster.h"
#import "CustomTableCellView.h"
#import "PageObject.h"
#import "NSMutableArray+Management.h"
@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate,NSTableViewDataSource>{
    NSMutableArray* tables;
    DataMaster* dataMaster;
    BOOL groupButton;
    NSArray* currentTableContents;
    NSInteger depth;
    NSMutableArray* pages;
    NSInteger activeName;
    NSTextField* activeField;
}

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak) IBOutlet NSView *pagedView;

@property (nonatomic) NSArray *tableArray;
@property (weak) IBOutlet NSButton *rightHeaderButton;
@property (weak) IBOutlet NSTextField *headerLabel;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)rightHeaderButtonPressed:(id)sender;
- (IBAction)newGroupItem:(id)sender;
- (IBAction)renameSelectedItem:(id)sender;
- (IBAction)goToParentItem:(id)sender;
- (IBAction)goToSelectedItem:(id)sender;
- (IBAction)moveSelectedUpItem:(id)sender;
- (IBAction)groupSelectedItem:(id)sender;

@end

