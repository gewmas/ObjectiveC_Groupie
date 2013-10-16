//
//  Level.h
//  Groupie
//
//  Created by Yuhua Mai on 10/13/13.
//  Copyright (c) 2013 Yuhua Mai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject

@property (assign, nonatomic) int playerNum;
@property (assign, nonatomic) int solveTime;
@property (assign, nonatomic) int initChess;

+(instancetype)levelWithPlayerNum:(int)playerNum;

@end
