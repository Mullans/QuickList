//
//  PageObject.m
//  QuickList
//
//  Created by Sean Mullan on 4/25/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import "PageObject.h"
@implementation PageObject
-(NSString*)name{
    return _folder.name;
}
-(void)reloadTable{
    [_tableView reloadData];
}
-(void)deselectAll{
    [_tableView deselectAll:nil];
}
-(instancetype)initWithArray:(NSArray*)array{
    self = [super init];
    _scrollView = array[0];
    _tableView = array[1];
    
    return self;
}
-(void)setFolder:(FolderObject *)folder{
    _folder = folder;
    _identifier = [NSString stringWithFormat:@"%@-%f",_folder.name,_folder.dateAdded];
}
@end
