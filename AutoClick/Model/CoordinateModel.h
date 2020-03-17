//
//  CoordinateModel.h
//  AutoClick
//
//  Created by Steven Lin on 2020/3/5.
//  Copyright © 2020 Primax. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoordinateModel : NSObject

@property(nonatomic,strong) NSMutableArray *locationXArray;
@property(nonatomic,strong) NSMutableArray *locationYArray;
@property(nonatomic,strong) NSMutableArray *sequenceArray;
@property(nonatomic,strong) NSMutableArray *timesArray;
@property(nonatomic,strong) NSMutableArray *durationArray;
@property(nonatomic,strong) NSMutableArray *delayArray;

-(void)deleteArrayInfo:(NSInteger)row;
-(void)deleteAllArrayInfo;
-(void)addObject:(NSString*)sequence coordinateX:(NSString*)CoordinateX coordinateY:(NSString*)CoordinateY;

@end

NS_ASSUME_NONNULL_END
