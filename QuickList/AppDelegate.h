//
//  AppDelegate.h
//  QuickList
//
//  Created by Sean Mullan on 4/24/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ToolBox.h"
@interface AppDelegate : NSObject <NSApplicationDelegate, NSPageControllerDelegate>

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak) IBOutlet NSPageController *pageController;
@property (weak) IBOutlet NSView *imageView;
@property (weak) IBOutlet NSTextField *imageLabel;

@property (nonatomic) NSArray *imageArray;


@end

