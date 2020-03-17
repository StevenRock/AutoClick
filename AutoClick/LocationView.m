//
//  LocationView.m
//  AutoClick
//
//  Created by Steven Lin on 2020/2/26.
//  Copyright © 2020 Primax. All rights reserved.
//

#import "LocationView.h"
#import <QuartzCore/QuartzCore.h>
//#import <CoreGraphics/CoreGraphics.h>

@implementation LocationView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [self.window setAcceptsMouseMovedEvents:YES];
    [self.window makeFirstResponder:self];
// Drawing code here.
}



- (void)viewWillDraw{
    NSRect screen = [[NSScreen mainScreen] frame];
    [self setFrame:screen];
    
    [self.window makeKeyAndOrderFront:nil];
    [self.window setLevel:NSStatusWindowLevel];
    
    [self viewTransparent];
}

-(void)viewTransparent
{
    self.window.opaque = FALSE;
    self.window.backgroundColor = [NSColor colorWithCalibratedRed:0.5 green:0.5 blue:0.5 alpha:0.3];
    self.window.titlebarAppearsTransparent = TRUE;
    [self.window setStyleMask:NSWindowStyleMaskBorderless];
}
@end
