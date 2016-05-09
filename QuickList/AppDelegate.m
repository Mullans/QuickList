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
    dataMaster = [[DataMaster alloc]initWithContext:self.managedObjectContext];
    
//    FolderObject* folder1 = [dataMaster newFolderNamed:@"Folder1" inFolder:nil];
//    FolderObject* folder1_1 = [dataMaster newFolderNamed:@"Folder1_1" inFolder:folder1];
//    FolderObject* folder1_2 = [dataMaster newFolderNamed:@"Folder1_2" inFolder:folder1];
//    FolderObject* folder2 = [dataMaster newFolderNamed:@"Folder2" inFolder:nil];
//    FolderObject* folder2_1 = [dataMaster newFolderNamed:@"Folder2_1" inFolder:folder2];
//    FolderObject* folder3 = [dataMaster newFolderNamed:@"Folder3" inFolder:nil];
    activeName = -1;
    currentTableContents = dataMaster.currentFolderContents;
    PageObject* newPage = [[PageObject alloc] initWithArray:[DataMaster makeTableForView:_pagedView dataSource:self delegate:self]];
    newPage.folder = dataMaster.currentFolder;
    pages = [NSMutableArray arrayWithObject:newPage];
    [_pagedView addSubview:newPage.scrollView];
    [newPage.tableView registerForDraggedTypes:[NSArray arrayWithObjects:NSPasteboardTypeHTML,NSPasteboardTypePNG,NSPasteboardTypeString,NSURLPboardType, nil]];
    depth = 0;
    _headerLabel.stringValue = dataMaster.currentFolderName;
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
    NSTextField *cellTF = [[NSTextField alloc]initWithFrame:NSMakeRect(0, 0, tableColumn.width-30, result.bounds.size.height)];
    [cellTF setAutoresizingMask:NSViewWidthSizable];
    [result addSubview:cellTF];
    result.textField = cellTF;
    [cellTF setBordered:NO];
    [cellTF setEditable:NO];
    [cellTF setDrawsBackground:NO];
    FolderObject* rowFolder = (FolderObject*)currentTableContents[row];
    result.textField.stringValue = rowFolder.name;
    if(row==activeName){
        result.textField.editable = YES;
        result.textField.target = self;
        result.textField.action = @selector(finishEditingName:);
        activeField = result.textField;
    }
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    NSFont *cellFont = [fontManager fontWithFamily:@"Verdana"
                                              traits:NSBoldFontMask
                                              weight:0
                                                size:20];
    NSButton *newButton = [[NSButton alloc]initWithFrame:CGRectMake(result.frame.size.width-25, result.frame.size.height-30, 20, 20)];
    switch (rowFolder.type) {
        case FOHTML:
            [newButton setImage:[NSImage imageNamed:@"html"]];
            break;
        case FOLocalURL:
            [newButton setImage:[NSImage imageNamed:@"url"]];
            break;
        case FOTextFile:
            [newButton setImage:[NSImage imageNamed:@"text"]];
            break;
        case FOImage:
            [newButton setImage:[NSImage imageNamed:@"image"]];
            break;
        case FOPDF:
            [newButton setImage:[NSImage imageNamed:@"pdf"]];
            break;
        default:
            [newButton setImage:[NSImage imageNamed:@"next"]];
            break;
    }
    [((NSButtonCell*)[newButton cell]) setImageScaling:NSImageScaleProportionallyDown];
    [newButton setBezelStyle:NSShadowlessSquareBezelStyle];
    [newButton setButtonType:NSMomentaryPushInButton];
    if(rowFolder.type==FODefault){
        [newButton setTarget:self];
        [newButton setAction:@selector(tableButtonPressed:)];
        [newButton setIdentifier:[[NSNumber numberWithInteger:row] stringValue]];
    }else{
        [newButton setBordered:NO];
        [newButton setEnabled:NO];
    }
    [result addSubview:newButton];
    result.textField.font = cellFont;
    return result;
}
-(void)finishEditingName:(id)sender{
    NSTextField* textField = (NSTextField*)sender;
    textField.editable = NO;
    FolderObject* currentFolder = currentTableContents[activeName];
    currentFolder.name = textField.stringValue;
    activeName = -1;
}
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return dataMaster.currentFolderSize;
}
-(void)tableViewSelectionIsChanging:(NSNotification *)notification{
    if([(NSTableView*)notification.object selectedRowIndexes].count<=1){
        [_rightHeaderButton setImage:[NSImage imageNamed:@"NSAddTemplate"]];
        groupButton = FALSE;
    }else{
        [_rightHeaderButton setImage:[NSImage imageNamed:@"NSFolder"]];
        groupButton = TRUE;
    }
}
-(void)tableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forRowIndexes:(NSIndexSet *)rowIndexes{
    NSLog(@"dragginStarted");
}
-(NSString*)getFolderName{
    NSAlert* folderAlert = [[NSAlert alloc]init];
    [folderAlert setMessageText:@"What is the title of the new group?"];
    [folderAlert setIcon:[NSImage imageNamed:NSImageNameFolder]];
    [folderAlert addButtonWithTitle:@"OK"];
    [folderAlert addButtonWithTitle:@"Cancel"];
    NSTextField* input = [[NSTextField alloc] initWithFrame:NSMakeRect(0,0,200,24)];
    [folderAlert setAccessoryView:input];
    NSInteger response = [folderAlert runModal];
    if(response==NSAlertFirstButtonReturn){
        return input.stringValue;
    }else if(response==NSAlertSecondButtonReturn){
        return @"Untitled Group";
    }else{
        NSLog(@"Folder alert error");
        return @"Untitled Group";
    }
}
-(BOOL)tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation{
    NSPasteboard* pasteboard = [info draggingPasteboard];
//    NSLog(@"%ld -- %lu",(long)row,(unsigned long)dropOperation);
    if(dropOperation==NSTableViewDropOn){
        NSString* folderName = [self getFolderName];
        FolderObject* groupFolder = [dataMaster newFolderNamed:folderName inFolder:nil];
        [groupFolder setParentFolder:dataMaster.currentFolder.parentFolder];
        [dataMaster.currentFolder setParentFolder:groupFolder];
        [self nextPageWithIndex:row];
    }
    NSArray* items = [pasteboard readObjectsForClasses:@[[NSImage class],[NSString class],[NSURL class],[NSAttributedString class]] options:nil];
    for(id object in items){
        NSLog(@"%@ %@",object,[object class]);
        FolderObject* newFolder = [dataMaster newFolderNamed:@"draggedItem" inFolder:nil];
        if([object isKindOfClass:[NSImage class]]){
            newFolder.type = FOImage;
            NSString* nameString = ((NSImage*)object).name;
            if(nameString==nil){
                nameString = @"untitledImage";
            }
            newFolder.name = nameString;
        }else if([object isKindOfClass:[NSString class]]||[object isKindOfClass:[NSAttributedString class]]){
            NSString* itemString;
            if([object isKindOfClass:[NSAttributedString class]]){
                itemString = [object string];
            }else{
                itemString = object;
            }
            if ([itemString hasPrefix:@"http://"] || [itemString hasPrefix:@"https://"])
            {
                newFolder.type = FOHTML;
                NSString * htmlCode = [NSString stringWithContentsOfURL:[NSURL URLWithString:itemString] encoding:NSASCIIStringEncoding error:nil];
                NSString * start = @"<title>";
                NSRange range1 = [htmlCode rangeOfString:start];
                NSString * end = @"</title>";
                NSRange range2 = [htmlCode rangeOfString:end];
                if(range1.location==NSNotFound||range2.location==NSNotFound){
                    newFolder.name = ((NSURL*)itemString).host;
                }else{
                    NSString * subString = [htmlCode substringWithRange:NSMakeRange(range1.location + 7, range2.location - range1.location - 7)];
                    newFolder.name = subString;
                }
                if(newFolder.name==nil){
                    newFolder.name = @"Untitled URL";
                }
            }else{
                newFolder.type = FOTextFile;
                newFolder.name = [itemString substringToIndex:MIN(itemString.length,11)];
            }
        }else if([object isKindOfClass:[NSURL class]]){
            newFolder.type = FOLocalURL;
            newFolder.name = ((NSURL*)object).lastPathComponent;
        }else{
            [NSException raise:@"Invalid Dragged Object" format:@"Type %@ is invalid", [object class]];
        }
        newFolder.name = [[newFolder.name componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
//        NSLog(@"Name:%@",newFolder.name);
        currentTableContents = dataMaster.currentFolderContents;
    }
    //TODO: change this so it only reloads the relevant lines
    PageObject* tempView = ((PageObject*)pages[depth]);
    [tempView reloadTable];
    return true;
}
-(NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation{
    return (row==currentTableContents.count&&dropOperation==NSTableViewDropAbove)||(dropOperation==NSTableViewDropOn);
}
#pragma mark - Table Buttons
-(void)tableButtonPressed:(id)sender{
    NSButton* senderButton = (NSButton*)sender;
    NSInteger senderIndex = [senderButton.identifier integerValue];
    [self nextPageWithIndex:senderIndex];
}
-(void)nextPageWithIndex:(NSInteger)index{
    [pages[depth] deselectAll];
    if(groupButton){
        [_rightHeaderButton setImage:[NSImage imageNamed:@"NSAddTemplate"]];
        groupButton = FALSE;
    }
    [dataMaster openFolder:(FolderObject*)currentTableContents[index]];
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
    currentTableContents = [dataMaster currentFolderContents];
    PageObject* tempView = ((PageObject*)pages[depth]);
    [tempView reloadTable];
    NSView* animatedView = ((PageObject*)pages[depth]).scrollView;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = .4;
        [animatedView.animator setFrameOrigin:_pagedView.frame.origin];
    }completionHandler:nil];
    _headerLabel.stringValue = dataMaster.currentFolderName;
}
-(void)previousPage{
    if([dataMaster openParentFolder]){
        PageObject* backPage = pages[depth];
        NSView* animatedView = backPage.scrollView;
        [backPage reloadTable];
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 1;
            [animatedView.animator setFrameOrigin:CGPointMake(_pagedView.frame.origin.x+_pagedView.frame.size.width, _pagedView.frame.origin.y)];
        }completionHandler:nil];
        currentTableContents = [dataMaster currentFolderContents];
        depth--;
        //animate back
        _headerLabel.stringValue = dataMaster.currentFolderName;
    }
}
- (IBAction)backButtonPressed:(id)sender {
    [self previousPage];
}

- (IBAction)rightHeaderButtonPressed:(id)sender {
    NSString* newFolderName = [self getFolderName];
    FolderObject* newFolder = [dataMaster newFolderNamed:newFolderName inFolder:nil];
    if(groupButton){
        PageObject* currentPage = pages[depth];
        [currentPage.tableView.selectedRowIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            FolderObject* item = currentTableContents[idx];
            item.parentFolder = newFolder;
        }];
    }
    currentTableContents = dataMaster.currentFolderContents;
    PageObject* backPage = pages[depth];
    [backPage reloadTable];
}


#pragma mark MenuItems
- (IBAction)newGroupItem:(id)sender {
    NSString* newFolderName = [self getFolderName];
    [dataMaster newFolderNamed:newFolderName inFolder:nil];
    currentTableContents = dataMaster.currentFolderContents;
    PageObject* backPage = pages[depth];
    [backPage reloadTable];
}

- (IBAction)renameSelectedItem:(id)sender {
    PageObject* currentPage = pages[depth];
    if(currentPage.tableView.selectedRowIndexes.count>1){
        NSAlert* folderAlert = [[NSAlert alloc]init];
        [folderAlert setMessageText:@"Multiple Items Selected."];
        [folderAlert setIcon:[NSImage imageNamed:NSImageNameCaution]];
        [folderAlert addButtonWithTitle:@"OK"];
    }else if(currentPage.tableView.selectedRow==-1){
        NSAlert* folderAlert = [[NSAlert alloc]init];
        [folderAlert setMessageText:@"No Item Selected."];
        [folderAlert setIcon:[NSImage imageNamed:NSImageNameCaution]];
        [folderAlert addButtonWithTitle:@"OK"];
    }else{
        activeName = currentPage.tableView.selectedRow;
        [currentPage.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:currentPage.tableView.selectedRow] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
        [activeField becomeFirstResponder];
    }
}

- (IBAction)goToParentItem:(id)sender {
    [self previousPage];
}

- (IBAction)goToSelectedItem:(id)sender {
    PageObject* currentPage = pages[depth];
    if(currentPage.tableView.selectedRowIndexes.count>1){
        NSAlert* folderAlert = [[NSAlert alloc]init];
        [folderAlert setMessageText:@"Multiple Items Selected."];
        [folderAlert setIcon:[NSImage imageNamed:NSImageNameCaution]];
        [folderAlert addButtonWithTitle:@"OK"];
    }else if(currentPage.tableView.selectedRow==-1){
        NSAlert* folderAlert = [[NSAlert alloc]init];
        [folderAlert setMessageText:@"No Item Selected."];
        [folderAlert setIcon:[NSImage imageNamed:NSImageNameCaution]];
        [folderAlert addButtonWithTitle:@"OK"];
    }else{
        [self nextPageWithIndex:currentPage.tableView.selectedRow];
    }
}

- (IBAction)moveSelectedUpItem:(id)sender {
    PageObject* currentPage = pages[depth];
    [currentPage.tableView.selectedRowIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        FolderObject* item = currentTableContents[idx];
        item.parentFolder = item.parentFolder.parentFolder;
    }];
    currentTableContents = dataMaster.currentFolderContents;
    [self previousPage];
}

- (IBAction)groupSelectedItem:(id)sender {
    NSString* newFolderName = [self getFolderName];
    FolderObject* newFolder = [dataMaster newFolderNamed:newFolderName inFolder:nil];
    PageObject* currentPage = pages[depth];
    [currentPage.tableView.selectedRowIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        FolderObject* item = currentTableContents[idx];
        item.parentFolder = newFolder;
    }];
    currentTableContents = dataMaster.currentFolderContents;
    PageObject* backPage = pages[depth];
    [backPage reloadTable];
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
