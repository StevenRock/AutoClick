//
//  VCWindowController.m
//  AutoClick
//
//  Created by Primax on 2020/2/17.
//  Copyright © 2020 Primax. All rights reserved.
//

#import "VCWindowController.h"

@interface VCWindowController ()

@end

@implementation VCWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (BOOL)windowShouldClose:(NSWindow *)sender{
    [NSApp hide:nil];
    return false;
}
@end
