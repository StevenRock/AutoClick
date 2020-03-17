//
//  LocationViewController.h
//  AutoClick
//
//  Created by Primax on 2019/6/18.
//  Copyright © 2019 Primax. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ViewController.h"

@interface LocationViewController : NSViewController{
//    ViewController *firstVC;
}

@property (nonatomic,assign)ViewController *firstVC;
@property int sequenceNum;

-(void)clearViewArray:(int)ifAll;
@end

