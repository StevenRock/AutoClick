//
//  ViewController.m
//  AutoClick
//
//  Created by Primax on 2019/6/14.
//  Copyright © 2019 Primax. All rights reserved.
//

#import "ViewController.h"
#import <CoreGraphics/CGEvent.h>
#import "LocationViewController.h"
#import "NSTextFieldNumberFormatter.h"
#import "CoordinateModel.h"

@implementation ViewController
{
    BOOL bSwitch;
    int round;
    int duration;
    float delay;
    NSTimer *stopWatchTimer;
    NSDate *startDate;
    BOOL bBreak;
//    BOOL bEnd;
    
    int intCountDown;
    int intMouseClick;
    LocationViewController *locationViewController;
        
    NSPoint mouseLocation;
}

@synthesize locationTableView, coordinateModel;

- (void)awakeFromNib{
    
}

-(void)initObject{
    bSwitch = NO;
    bBreak = NO;
    intCountDown = 0;
    intMouseClick = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(incomingNotification:)
                                                 name:@"LOCATIONX"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(incomingNotification:)
                                                 name:@"LOCATIONY"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTable:)
                                                 name:@"UPDATE"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controlTextDidChange:)
                                                 name:NSControlTextDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(frontOrder:)
                                                 name:@"ORDERFRONT"
                                               object:nil];
    
    
    _labelLoactionX.stringValue = @"0";
    _labelLoactionY.stringValue = @"0";
    
    coordinateModel = [[CoordinateModel alloc] init];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initObject];
    
//    [self.view.window setLevel:NSStatusWindowLevel];
    
    [self setButtonOutlet];
//    [self addActionMenu];
    
    locationViewController = [[LocationViewController alloc] init];
    locationViewController.firstVC = self;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)viewDidAppear{

    self.view.window.delegate = self;
//
//    [sequenceArray addObject:@"1"];
//    [locationXArray addObject:@"500"];
//    [locationYArray addObject:@"500"];
//    [timesArray addObject:@"0"];
//    [durationArray addObject:@"0"];
//    [delayArray addObject:@"0"];
//
//    [self.locationTableView reloadData];
}

- (void)viewWillAppear{

    
}
- (IBAction)simulateClick:(id)sender {
//    [self.view.window makeFirstResponder:self];
//    [self.view.window orderBack:nil];
//    [self.view.window orderOut:nil];
        
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGFloat valCgX = [self->_labelLoactionX.stringValue floatValue];
        CGFloat valCgY = [self->_labelLoactionY.stringValue floatValue];
        
        for (int i = 0;i < self->coordinateModel.sequenceArray.count;i++)
        {
            self->bBreak = NO;
            
            self->intMouseClick = 0;
            self->duration = [self->coordinateModel.durationArray[i] intValue];
            
            valCgX = [self->coordinateModel.locationXArray[i] floatValue];
            valCgY = [self->coordinateModel.locationYArray[i] floatValue];
            
            if ([self->coordinateModel.timesArray[i] isEqualToString:@"0"] && [self->coordinateModel.durationArray[i] intValue] != 0)
            {
                //position
                [self methodToRepeatEveryOneSecond];
                
                while (true)
                {
                    [self simulateMouseClick:valCgX cgY:valCgY];
                    
                    if (self->bBreak) {
                        break;
                    }
                    usleep([self->coordinateModel.delayArray[i] floatValue]*1000*1000);
                }
            }
            else
            {
                //round
                for (int j = 0; j < [self->coordinateModel.timesArray[i] intValue]; j++)  {
                    
                    [self simulateMouseClick:valCgX cgY:valCgY];
                    
                    if (j != [self->coordinateModel.timesArray[i] intValue]-1) {
                        usleep([self->coordinateModel.delayArray[i] floatValue]*1000*1000);
                    }
                }
            }
        }
//        [self.view.window orderFront:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDERFRONT" object:nil];

    });
}

- (void)frontOrder:(NSNotification *)notification{
    [self.view.window orderFront:nil];
}

- (void)methodToRepeatEveryOneSecond
{    
    // Call this method again using GCD
    dispatch_queue_t q_background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC);
    dispatch_after(popTime, q_background, ^(void){
        
        self->bBreak = YES;
    });
}

//- (void)controlTextDidChange:(NSNotification *)obj
//{
//    NSTextField *valueField = [obj object];
//    NSNumberFormatter *formatter = valueField.formatter;
//    NSText *fieldEditor = valueField.currentEditor;
//    id newValue = (fieldEditor != nil ? [formatter numberFromString:fieldEditor.string] : valueField.objectValue);
//}

- (IBAction)locateMouse:(id)sender {
    
    [self showAlert];
    
    [self presentViewControllerAsModalWindow:locationViewController];
}

- (void)dissmissLocation{
    
    [self dismissViewController:locationViewController];
}

- (void) incomingNotification:(NSNotification *)notification{

    NSString *theString = [notification object];
    
    if ([notification.name isEqualToString:@"LOCATIONX"])
    {
        _labelLoactionX.stringValue = theString;
        [_labelLoactionX sizeToFit];
    }
    else if ([notification.name isEqualToString:@"LOCATIONY"])
    {
        _labelLoactionY.stringValue = theString;
        [_labelLoactionY sizeToFit];
    }
    
}

-(void)simulateMouseClick:(CGFloat)x cgY:(CGFloat)y
{
    intMouseClick++;
    NSLog(@"Mouseclick: %d", intMouseClick);
    NSLog(@"MouseClick: X:%f",x);
    NSLog(@"MouseClick: Y:%f",y);
    
    CGEventRef theEvent = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDown, CGPointMake(x, y), kCGMouseButtonLeft);
    CGEventSetIntegerValueField(theEvent, kCGMouseEventClickState, 1);
    CGEventPost(kCGHIDEventTap, theEvent);
    CGEventSetType(theEvent, kCGEventLeftMouseUp);
    CGEventPost(kCGHIDEventTap, theEvent);
    
    mouseLocation = [NSEvent mouseLocation];
    NSLog(@"realLocation X: %f",mouseLocation.x);
    NSLog(@"realLocation Y: %f",mouseLocation.y);
    
    CFRelease(theEvent);
}

-(void)updateTable:(NSNotification *)notification{
    
    NSLog(@"VC reload X: %@", coordinateModel.locationXArray);
    NSLog(@"VC reload Y: %@", coordinateModel.locationYArray);
    NSLog(@"VC reload sequence: %@", coordinateModel.sequenceArray);
    [self.locationTableView reloadData];
}

- (IBAction)clearTable:(id)sender {
    
    [coordinateModel deleteAllArrayInfo];
    
    locationViewController.sequenceNum = 0;
    
    [locationViewController clearViewArray:0];
    
    [self.locationTableView reloadData];
}

-(void)setButtonOutlet{
    //Clear Button
    NSButton *BtnClear = [[NSButton alloc] initWithFrame:NSMakeRect(17, 17, 460, 40)];
    [BtnClear setBezelStyle:NSBezelStyleRegularSquare];
    [BtnClear setTitle:@"Clear Table"];
    [BtnClear setAlignment:NSTextAlignmentCenter];
    [BtnClear setFont:[NSFont systemFontOfSize:20]];
    [BtnClear setToolTip:@"to clear all positions"];
    [BtnClear setTarget:self];
    [BtnClear setAction:@selector(clearTable:)];
    [self.view addSubview:BtnClear];
    
    //Locate
    NSButton *BtnLocate = [[NSButton alloc]initWithFrame:NSMakeRect(391, 197, 85, 60)];
    [BtnLocate setBezelStyle:NSBezelStyleRegularSquare];
    [BtnLocate setTitle:@"Locate"];
    [BtnLocate setAlignment:NSTextAlignmentCenter];
    [BtnLocate setFont:[NSFont systemFontOfSize:20]];
    [BtnLocate setToolTip:@"to clear all positions"];
    [BtnLocate setTarget:self];
    [BtnLocate setAction:@selector(locateMouse:)];
    [self.view addSubview:BtnLocate];
    
    //Auto
    NSButton *BtnAutoClick = [[NSButton alloc]initWithFrame:NSMakeRect(280, 197, 110, 60)];
    [BtnAutoClick setBezelStyle:NSBezelStyleRegularSquare];
    [BtnAutoClick setTitle:@"AutoClick"];
    [BtnAutoClick setAlignment:NSTextAlignmentCenter];
    [BtnAutoClick setFont:[NSFont systemFontOfSize:20]];
    [BtnAutoClick setToolTip:@"launch auto-click"];
    [BtnAutoClick setTarget:self];
    [BtnAutoClick setAction:@selector(simulateClick:)];
    [self.view addSubview:BtnAutoClick];
}

//NSTableViewDataSource Protocal Method

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return coordinateModel.sequenceArray.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSString *identifier = tableColumn.identifier;
    
    if ([identifier isEqualToString:@"sequence"]) {
        return coordinateModel.sequenceArray[row];
    }
    else if([identifier isEqualToString:@"locationX"]) {
        return coordinateModel.locationXArray[row];
    }
    else if([identifier isEqualToString:@"locationY"]){
        return coordinateModel.locationYArray[row];
    }else if([identifier isEqualToString:@"times"]){
        [tableColumn setEditable:YES];
        return coordinateModel.timesArray[row];
    }else if([identifier isEqualToString:@"duration"]){
        [tableColumn setEditable:YES];
        return coordinateModel.durationArray[row];
    }else {
        [tableColumn setEditable:YES];
        return coordinateModel.delayArray[row];
    }
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    NSString *identifier = tableColumn.identifier;
    
    NSDecimal decimal;
    NSScanner *numSc = [NSScanner scannerWithString:object];
    [numSc scanDecimal:&decimal];
    BOOL isDecimal = [numSc isAtEnd];
    
    if (isDecimal) {
        if ([identifier isEqualToString:@"times"]) {
            [coordinateModel.timesArray replaceObjectAtIndex:row withObject:object];
            [coordinateModel.durationArray replaceObjectAtIndex:row withObject:@"0"];
        }else if ([identifier isEqualToString:@"duration"]){
            [coordinateModel.durationArray replaceObjectAtIndex:row withObject:object];
            [coordinateModel.timesArray replaceObjectAtIndex:row withObject:@"0"];
        }else if ([identifier isEqualToString:@"delay"]){
            [coordinateModel.delayArray replaceObjectAtIndex:row withObject:object];
        }
    }else{
        NSString *strAlertRes = @"Warning";
        NSAlert *blsAlert = [[NSAlert alloc] init];
        [blsAlert setAlertStyle:NSAlertStyleWarning];
        [blsAlert addButtonWithTitle:@"OK"];
        [blsAlert setMessageText:strAlertRes];
        [blsAlert setInformativeText:@"Please enter numeric"];
        
        [blsAlert runModal];
    }
    
}

- (IBAction)deleteRowInf:(id)sender {
    NSInteger selectedRow = locationTableView.clickedRow;
    
    [coordinateModel deleteArrayInfo:selectedRow];
    
    [locationTableView reloadData];
    
    [locationViewController clearViewArray:(int)selectedRow];
}

-(void)showAlert{
    NSString *strAlertRes = @"Tip";
    NSAlert *blsAlert = [[NSAlert alloc] init];
    [blsAlert setAlertStyle:NSAlertStyleWarning];
    [blsAlert addButtonWithTitle:@"Got it"];
    [blsAlert setMessageText:strAlertRes];
    [blsAlert setInformativeText:@"Press COMMAND+S for finishing locating\nPress COMMAND+A for Adding location"];
    
    [blsAlert runModal];
}

-(void)addActionMenu{
    NSMenu *mainMenu = [NSApp mainMenu];
    
    NSMenuItem *actionMenu = [[NSMenuItem alloc] init];
    [actionMenu setTitle:@"Action"];
    [mainMenu addItem:actionMenu];
   
    NSMenu *subMenu = [[NSMenu alloc] initWithTitle:@"Load_TEXT"];
    
    [subMenu addItemWithTitle:@"Add" action:@selector(showAlert) keyEquivalent:@"A"];
    [subMenu addItemWithTitle:@"Save" action:@selector(clearTable:) keyEquivalent:@"S"];
    
    [actionMenu setMenu:subMenu];
    [NSApp setMainMenu:mainMenu];
}

@end
