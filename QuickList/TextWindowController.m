//
//  TextWindowController.m
//  QuickList
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
    _textView.delegate = self;
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(void)textDidEndEditing:(NSNotification *)notification{
    self.folder.data = [_textView.string dataUsingEncoding:NSUTF16StringEncoding];
    NSLog(@"%@",_textView.string);

}
@end
