//
//  AppDelegate.m
//  QuickList
//
//  Created by Sean Mullan on 4/24/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
- (IBAction)saveAction:(id)sender;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Code for testing
    //    [dataMaster newFolderNamed:@"Folder1" inFolder:nil];
    //    [dataMaster newFolderNamed:@"Folder2" inFolder:nil];
    //    [dataMaster newFolderNamed:@"Folder3" inFolder:nil];
    
    dataMaster = [[DataMaster alloc]initWithContext:self.managedObjectContext];
    currentTableContents = dataMaster.currentFolderContents;
    PageObject* newPage = [[PageObject alloc] initWithArray:[DataMaster makeTableForView:_pagedView dataSource:self delegate:self]];
    newPage.folder = dataMaster.currentFolder;
    pages = [NSMutableArray arrayWithObject:newPage];
    [_pagedView addSubview:newPage.scrollView];
    depth = 0;
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    return true;
}

#pragma mark - NSTableViewDelegate/NSTableViewDataSource
-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 40;
}
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    CustomTableCellView *result = [tableView makeViewWithIdentifier:@"TableCell" owner:self];
    if(result==nil){
        result = [[CustomTableCellView alloc]initWithFrame:NSMakeRect(0, 0, tableColumn.width, [self tableView:tableView heightOfRow:row])];
    }
    CGFloat numberOfRows = [[NSNumber numberWithInteger: tableView.numberOfRows] floatValue];
    CGFloat colorFloat = (0.8)*1+(0.2)*(row/numberOfRows);
    result.borderColor = [NSColor colorWithRed:0.7 green:1-colorFloat blue:colorFloat alpha:1];
    NSTextField *cellTF = [[NSTextField alloc]initWithFrame:NSMakeRect(0, 0, tableColumn.width, result.bounds.size.height)];
    [cellTF setAutoresizingMask:NSViewWidthSizable];
    [result addSubview:cellTF];
    result.textField = cellTF;
    [cellTF setBordered:NO];
    [cellTF setEditable:NO];
    [cellTF setDrawsBackground:NO];
    result.textField.stringValue = ((FolderObject*)currentTableContents[row]).name;
    
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    NSFont *cellFont = [fontManager fontWithFamily:@"Verdana"
                                              traits:NSBoldFontMask
                                              weight:0
                                                size:20];
    NSButton *newButton = [[NSButton alloc]initWithFrame:CGRectMake(result.frame.size.width-25, result.frame.size.height-30, 20, 20)];
    [newButton setTarget:self];
    [newButton setAction:@selector(tableButtonPressed:)];
    [newButton setIdentifier:[[NSNumber numberWithInteger:row] stringValue]];
    [result addSubview:newButton];
    result.textField.font = cellFont;
    return result;
}
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return dataMaster.currentFolderSize;
}
-(void)tableViewSelectionIsChanging:(NSNotification *)notification{
    if([(NSTableView*)notification.object selectedRowIndexes].count<=1){
        [_rightHeaderButton setImage:[NSImage imageNamed:@"NSAddTemplate"]];
    }else{
        [_rightHeaderButton setImage:[NSImage imageNamed:@"NSFolder"]];
        groupButton = TRUE;
    }
}
#pragma mark - Table Buttons
-(void)tableButtonPressed:(id)sender{
    NSButton* senderButton = (NSButton*)sender;
//    NSLog(@"%@",senderButton.identifier);
    [pages[depth] deselectAll];
    if(groupButton){
        [_rightHeaderButton setImage:[NSImage imageNamed:@"NSAddTemplate"]];
    }
    [dataMaster openFolder:(FolderObject*)currentTableContents[[senderButton.identifier integerValue]]];
    if(depth+1>pages.count-1){
        //desired page isn't loaded, and nothing exists at that depth
        PageObject* newPage = [[PageObject alloc] initWithArray:[DataMaster makeTableForView:_pagedView dataSource:self delegate:self]];
        newPage.folder = dataMaster.currentFolder;
        [pages addObject:newPage];
        [newPage.scrollView setFrameOrigin:CGPointMake(_pagedView.frame.origin.x+_pagedView.frame.size.width, _pagedView.frame.origin.y)];
        [_pagedView addSubview:newPage.scrollView];
    }else if([((PageObject*)pages[depth+1]).identifier isEqualToString:dataMaster.currentFolder.identifier]){
        //desired page is already loaded
    }else{
        //desired page isn't loaded, and there is history
        [pages removeObjectsAfterIndex:depth+1];
        //remove objects and remove from superview
        PageObject* newPage = [[PageObject alloc] initWithArray:[DataMaster makeTableForView:_pagedView dataSource:self delegate:self]];
        [newPage.scrollView setFrameOrigin:CGPointMake(_pagedView.frame.origin.x+_pagedView.frame.size.width, _pagedView.frame.origin.y)];
        [_pagedView addSubview:newPage.scrollView];
        newPage.folder = dataMaster.currentFolder;
        [pages addObject:newPage];
    }
    depth+=1;
    NSView* animatedView = ((PageObject*)pages[depth]).scrollView;
//    [animatedView setFrameOrigin:_pagedView.frame.origin];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = .4;
        [animatedView.animator setFrameOrigin:_pagedView.frame.origin];
    }completionHandler:nil];
}
- (IBAction)backButtonPressed:(id)sender {
    if([dataMaster openParentFolder]){
        NSView* animatedView = ((PageObject*)pages[depth]).scrollView;
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 1;
            [animatedView.animator setFrameOrigin:CGPointMake(_pagedView.frame.origin.x+_pagedView.frame.size.width, _pagedView.frame.origin.y)];
        }completionHandler:nil];
        depth--;
        //animate back
    }
}

#pragma mark - Core Data stack

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.mullan.QuickList" in the user's Application Support directory.
    NSURL *appSupportURL = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.mullan.QuickList"];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"QuickList" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationDocumentsDirectory = [self applicationDocumentsDirectory];
    BOOL shouldFail = NO;
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    // Make sure the application files directory is there
    NSDictionary *properties = [applicationDocumentsDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    if (properties) {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            failureReason = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationDocumentsDirectory path]];
            shouldFail = YES;
        }
    } else if ([error code] == NSFileReadNoSuchFileError) {
        error = nil;
        [fileManager createDirectoryAtPath:[applicationDocumentsDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (!shouldFail && !error) {
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *url = [applicationDocumentsDirectory URLByAppendingPathComponent:@"OSXCoreDataObjC.storedata"];
        if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
            coordinator = nil;
        }
        _persistentStoreCoordinator = coordinator;
    }
    
    if (shouldFail || error) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        if (error) {
            dict[NSUnderlyingErrorKey] = error;
        }
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

#pragma mark - Core Data Saving and Undo support

- (IBAction)saveAction:(id)sender {
    // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    NSError *error = nil;
    if ([[self managedObjectContext] hasChanges] && ![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
    return [[self managedObjectContext] undoManager];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertFirstButtonReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}


@end
