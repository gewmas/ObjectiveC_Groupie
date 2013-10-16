//
//  GameController.h
//  Groupie
//
//  Created by Yuhua Mai on 10/13/13.
//  Copyright (c) 2013 Yuhua Mai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChessView.h"
#import "HUDView.h"
#import "Level.h"

typedef void (^CallbackBlock)();

@interface GameController : NSObject <ChessDragDelegateProtocol>
{
        
}

@property (weak, nonatomic) UIView* gameView;
//@property (strong, nonatomic) Level* level;
@property (weak, nonatomic) HUDView* hud;

@property (nonatomic) NSUInteger playerNumber;

@property (strong, nonatomic) CallbackBlock onGameFinish;

- (void)newGame;

@end
