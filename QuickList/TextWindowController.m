//
//  TextWindowController.m
//  Smart Drop
//
//  Created by Sean Mullan on 5/8/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import "TextWindowController.h"

@interface TextWindowController ()

@end

@implementation TextWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
}

-(void)setFolder:(FolderObject *)folder{
    _folder = folder;
    NSString *textString = [[NSString alloc] initWithData:_folder.data encoding:NSUTF16StringEncoding];
    [_textView setString:textString];
}
- (IBAction)saveButton:(id)sender {
    self.folder.data = [_textView.string dataUsingEncoding:NSUTF16StringEncoding];
    [self close];
}
@end
