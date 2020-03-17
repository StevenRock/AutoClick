//
//  ViewController.h
//  AutoClick
//
//  Created by Primax on 2019/6/14.
//  Copyright © 2019 Primax. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VCWindowController.h"
#import "CoordinateModel.h"

@interface ViewController : NSViewController<NSWindowDelegate,NSTextFieldDelegate,NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTextField *labelLoactionX;
@property (weak) IBOutlet NSTextField *labelLoactionY;

@property (weak) IBOutlet NSScrollView *scrollTestItem;
@property (weak) IBOutlet NSTableView *locationTableView;

@property (nonatomic,strong) CoordinateModel *coordinateModel;

-(void)dissmissLocation;


@end

