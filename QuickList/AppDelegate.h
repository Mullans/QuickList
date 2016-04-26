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
@interface AppDelegate : NSObject <NSApplicationDelegate, NSPageControllerDelegate,NSTableViewDelegate,NSTableViewDataSource>{
    NSMutableArray* tables;
    DataMaster* dataMaster;
    BOOL groupButton;
    NSArray* currentTableContents;
    PageObject* currentPage;
    NSInteger depth;
    NSMutableArray* pages;
}

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak) IBOutlet NSPageController *pageController;
@property (weak) IBOutlet NSView *pagedView;

@property (nonatomic) NSArray *tableArray;
@property (weak) IBOutlet NSButton *rightHeaderButton;

- (IBAction)backButtonPressed:(id)sender;

@end

