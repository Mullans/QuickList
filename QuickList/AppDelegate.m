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
    dataMaster = [[DataMaster alloc]init];
    tables = [[NSMutableArray alloc]initWithCapacity:5];
    [dataMaster makeTableForView:_pagedView dataSource:self delegate:self withData:@[@1,@2,@3,@4,@5,@6,@7,@8,@9]];
    [dataMaster makeTableForView:_pagedView dataSource:self delegate:self withData:@[@11,@12,@13,@14]];
    [dataMaster makeTableForView:_pagedView dataSource:self delegate:self withData:@[@21,@22,@23,@24]];

    
    _tableArray = @[@0,@1,@2];
    
    [_pageController setDelegate:self];
    [_pageController setArrangedObjects:_tableArray];
    [_pageController setTransitionStyle:NSPageControllerTransitionStyleHorizontalStrip];
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - NSPageControllerDelegate
//- (void)pageController:(NSPageController *)pageController didTransitionToObject:(id)object {
//    /* When image is changed, update info label's text */
//}

- (NSString *)pageController:(NSPageController *)pageController identifierForObject:(id)object {
    /* Returns object's array index as identiefier */
    NSString *identifier = [[NSNumber numberWithInteger:[_tableArray indexOfObject:object]] stringValue];
    return identifier;
}

- (NSViewController *)pageController:(NSPageController *)pageController viewControllerForIdentifier:(NSString *)identifier {
    NSViewController *vController = [NSViewController new];
    
    NSArray* data = [dataMaster getTableAtIndex:[identifier integerValue]];
    
    [vController setView:data[0]];
    return vController;
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
    CGFloat numberOfRows = [[NSNumber numberWithInt: tableView.numberOfRows] floatValue];
    CGFloat colorFloat = (0.8)*1+(0.2)*(row/numberOfRows);
    result.borderColor = [NSColor colorWithRed:0.7 green:1-colorFloat blue:colorFloat alpha:1];
    NSTextField *cellTF = [[NSTextField alloc]initWithFrame:NSMakeRect(0, 0, tableColumn.width, result.bounds.size.height)];
    [cellTF setAutoresizingMask:NSViewWidthSizable];
    [result addSubview:cellTF];
    result.textField = cellTF;
    [cellTF setBordered:NO];
    [cellTF setEditable:NO];
    [cellTF setDrawsBackground:NO];
    result.textField.stringValue = [dataMaster getDataForTable:tableView][row];
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
    if(dataMaster.data.count==0){
        return 0;
    }
    return [[dataMaster getDataForTable:tableView] count];
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
    NSLog(@"%@",senderButton.identifier);
    [((NSTableView*)[dataMaster getTableAtIndex:_pageController.selectedIndex][1]) deselectAll:nil];
    if(groupButton){
        [_rightHeaderButton setImage:[NSImage imageNamed:@"NSAddTemplate"]];
    }
    [_pageController navigateForward:nil];
}
- (IBAction)backButtonPressed:(id)sender {
    [_pageController navigateBack:nil];
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
