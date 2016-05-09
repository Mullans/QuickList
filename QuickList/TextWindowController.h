//
//  TextWindowController.h
//  QuickList
//
//  Created by Sean Mullan on 5/8/16.
//  Copyright © 2016 SilentLupin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FolderObject.h"
@interface TextWindowController : NSWindowController <NSTextViewDelegate>

@property (nonatomic) FolderObject* folder;
@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end
