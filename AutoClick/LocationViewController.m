//
//  LocationViewController.m
//  AutoClick
//
//  Created by Primax on 2019/6/18.
//  Copyright © 2019 Primax. All rights reserved.
//

#import "LocationViewController.h"
#import "ViewController.h"
#import <Carbon/Carbon.h>
#import "DDHotKeyCenter.h"
#import "LocationView.h"

@interface LocationViewController ()
@end

@implementation LocationViewController
{
    NSRect screen;
    DDHotKeyCenter *c;
    
    float locationPointY;
    float locationPointX;
    
    NSMutableArray *viewArray;
    NSView *previewView;
}

@synthesize firstVC,sequenceNum;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        sequenceNum = 0;
        locationPointY = 0.0;
        locationPointX = 0.0;
        
        viewArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do view setup here.
}

- (void)viewWillAppear
{
    
    c = [DDHotKeyCenter sharedHotKeyCenter];

    if (![c hasRegisteredHotKeyWithKeyCode:kVK_ANSI_S modifierFlags:NSCommandKeyMask]) {
        if (![c registerHotKeyWithKeyCode:kVK_ANSI_S modifierFlags:NSCommandKeyMask target:self action:@selector(hotkeyWithSaveEvent:) object:nil])
            NSLog(@"Register Hot Key Fail!");
        if (![c registerHotKeyWithKeyCode:kVK_ANSI_A modifierFlags:NSCommandKeyMask target:self action:@selector(hotkeyWithAddEvent:) object:nil])
            NSLog(@"command A Register Hot Key Fail!");
        
    }
}

- (void) hotkeyWithSaveEvent:(NSEvent *)hkEvent {
    
    if ([c hasRegisteredHotKeyWithKeyCode:kVK_ANSI_S modifierFlags:NSCommandKeyMask]) {
        [c unregisterHotKeyWithKeyCode:kVK_ANSI_S modifierFlags:NSCommandKeyMask];
        [c unregisterHotKeyWithKeyCode:kVK_ANSI_A modifierFlags:NSCommandKeyMask];
    }
    
    if (previewView != nil) {
        [previewView removeFromSuperview];
    }
    [firstVC.view.window orderFront:nil];
    [firstVC dissmissLocation];
}

- (void) hotkeyWithAddEvent:(NSEvent *)hkEvent {
    
    sequenceNum = [firstVC.coordinateModel.sequenceArray.lastObject intValue]+1;
    
    [firstVC.coordinateModel.locationXArray addObject:[NSString stringWithFormat:@"%f", locationPointX]];
    [firstVC.coordinateModel.locationYArray addObject:[NSString stringWithFormat:@"%f", locationPointY]];
    [firstVC.coordinateModel.sequenceArray addObject:[NSString stringWithFormat:@"%d",sequenceNum]];
    [firstVC.coordinateModel.delayArray addObject:@"0"];
    [firstVC.coordinateModel.timesArray addObject:@"0"];
    [firstVC.coordinateModel.durationArray addObject:@"0"];
    
    NSLog(@"sequence:%@", firstVC.coordinateModel.sequenceArray);
    NSLog(@"X:%@", firstVC.coordinateModel.locationXArray);
    NSLog(@"Y:%@", firstVC.coordinateModel.locationYArray);
    
    if (previewView != nil) {
        [previewView removeFromSuperview];
    }
    [self addDot];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE" object:nil];
}

- (void)mouseDown:(NSEvent *)event
{
    if (previewView != nil) {
        [previewView removeFromSuperview];
    }
    
//    NSPoint mouseLocation = [event locationInWindow];
    NSPoint mouseLocation = [NSEvent mouseLocation];
    NSLog(@"%@",NSStringFromPoint(mouseLocation));
    locationPointY = fabs(mouseLocation.y - screen.size.height);
//    locationPointY = mouseLocation.y;
    locationPointX = mouseLocation.x;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOCATIONX" object:[NSString stringWithFormat:@"%f", locationPointX]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOCATIONY" object:[NSString stringWithFormat:@"%f", locationPointY]];

    //
    previewView = [[NSView alloc] initWithFrame:NSMakeRect(locationPointX, locationPointY, 3, 3)];

    [previewView setWantsLayer:YES];
    previewView.layer.backgroundColor = [[NSColor yellowColor] CGColor];
//    previewView.superview.needsDisplay = YES;
    [self.view addSubview:previewView];
}

- (void)mouseUp:(NSEvent *)event
{
}

- (void)mouseMoved:(NSEvent *)event{
    
    [super mouseMoved:event];
    
    float firstVCx = firstVC.view.window.frame.origin.x;
    float firstVCy = firstVC.view.window.frame.origin.y;
    float firstVCh = firstVC.view.window.frame.size.height + firstVC.view.window.frame.origin.y;
    float firstVCw = firstVC.view.window.frame.size.width + firstVC.view.window.frame.origin.x;
    
//    NSPoint mouseLocation = [event locationInWindow];
    NSPoint mouseLocation = [NSEvent mouseLocation];
    NSLog(@"%@",NSStringFromPoint(mouseLocation));
    float coordinateY = fabs(mouseLocation.y - screen.size.height);
//    float coordinateY = mouseLocation.y;
    float coordinateX = mouseLocation.x;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOCATIONX" object:[NSString stringWithFormat:@"%f", coordinateX]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOCATIONY" object:[NSString stringWithFormat:@"%f", coordinateY]];
    
    if (coordinateX >= firstVCx && coordinateX <= firstVCw &&
        coordinateY >= firstVCy && coordinateY <= firstVCh) {
        
        [firstVC.view.window orderOut:nil];
    }else{
        [firstVC.view.window orderFront:nil];
    }
}

-(void)addDot{
    NSView *redDotView = [[NSView alloc] initWithFrame:NSMakeRect(locationPointX, locationPointY, 3, 3)];
        
    [redDotView setWantsLayer:YES];
    redDotView.layer.backgroundColor = [[NSColor redColor] CGColor];
//    redDotView.superview.needsDisplay = YES;
    [self.view addSubview:redDotView];
    [viewArray addObject:redDotView];
}

-(void)clearViewArray:(int)ifAll{
    
    if (ifAll == 0) {
        if (viewArray.count != 0) {
            for (int i = 0; i<viewArray.count; i++) {
                [viewArray[i] removeFromSuperview];
            }
            [viewArray removeAllObjects];
        }
    }else{
        [viewArray[ifAll] removeFromSuperview];
        [viewArray removeObjectAtIndex:ifAll];
    }
    
}

@end
