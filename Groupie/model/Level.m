//
//  Level.m
//  Groupie
//
//  Created by Yuhua Mai on 10/13/13.
//  Copyright (c) 2013 Yuhua Mai. All rights reserved.
//

#import "Level.h"

@implementation Level

//factory method to load a .plist file and initialize the model
+(instancetype)levelWithPlayerNum:(int)playerNum;
{
    // find .plist file for this level
    NSString* fileName = [NSString stringWithFormat:@"player%i.plist", playerNum];
    NSString* levelPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    
    // load .plist file
    NSDictionary* levelDict = [NSDictionary dictionaryWithContentsOfFile:levelPath];
    
    // validation
    NSAssert(levelDict, @"level config file not found");
    
    // create Level instance
    Level* l = [[Level alloc] init];
    
    // initialize the object from the dictionary
    l.playerNum = [levelDict[@"playerNum"] intValue];
    l.solveTime = [levelDict[@"solveTime"] intValue];
    l.initChess = [levelDict[@"initChess"] intValue];
    
    return l;
}

@end
