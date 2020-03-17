//
//  CoordinateModel.m
//  AutoClick
//
//  Created by Steven Lin on 2020/3/5.
//  Copyright © 2020 Primax. All rights reserved.
//

#import "CoordinateModel.h"

@implementation CoordinateModel

@synthesize timesArray,durationArray,delayArray,sequenceArray,locationXArray,locationYArray;

- (instancetype)init
{
    self = [super init];
    if (self) {
        sequenceArray = [NSMutableArray new];
        locationYArray = [NSMutableArray new];
        locationXArray = [NSMutableArray new];
        timesArray = [NSMutableArray new];
        durationArray = [NSMutableArray new];
        delayArray = [NSMutableArray new];
    }
    return self;
}

-(void)deleteArrayInfo:(NSInteger)row{
    [locationXArray removeObjectAtIndex:row];
    [locationYArray removeObjectAtIndex:row];
    [delayArray removeObjectAtIndex:row];
    [durationArray removeObjectAtIndex:row];
    [timesArray removeObjectAtIndex:row];
    [sequenceArray removeLastObject];
}

-(void)addObject:(NSString*)Sequence coordinateX:(NSString*)CoordinateX coordinateY:(NSString*)CoordinateY{
    [locationXArray addObject:CoordinateX];
    [locationYArray addObject:CoordinateY];
    [sequenceArray addObject:Sequence];
    [delayArray addObject:@"0"];
    [timesArray addObject:@"0"];
    [durationArray addObject:@"0"];

}

-(void)deleteAllArrayInfo{
    [locationXArray removeAllObjects];
    [locationYArray removeAllObjects];
    [sequenceArray removeAllObjects];
    [delayArray removeAllObjects];
    [durationArray removeAllObjects];
    [timesArray removeAllObjects];
}



@end
