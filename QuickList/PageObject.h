//
//  PageObject.h
//  QuickList
//
//  Created by Sean Mullan on 4/25/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataMaster.h"
@interface PageObject : NSObject

@property (nonatomic) NSScrollView* scrollView;
@property (nonatomic) NSTableView* tableView;
@property (nonatomic) FolderObject* folder;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* identifier;

-(void)reloadTable;
-(void)deselectAll;
-(instancetype)initWithArray:(NSArray*)array;
@end
