//
//  GameController.m
//  Groupie
//
//  Created by Yuhua Mai on 10/13/13.
//  Copyright (c) 2013 Yuhua Mai. All rights reserved.
//

#import "config.h"

#import "GameController.h"
#import "ChessContainerView.h"
#import "ChessView.h"
#import "FrameView.h"
#import "config.h"

@implementation GameController
{
    //chess view
    NSMutableArray* _chess1;
    NSMutableArray* _chess2;
    NSMutableArray* _chess3;
    NSMutableArray* _chess4;
    
    UILabel *redLabel;
    UILabel *yellowLabel;
    UILabel *purpleLabel;
    UILabel *greenLabel;
    
    //frame view
    NSMutableArray* _frame;
    
    NSInteger frameCapacity;
    
//    ChessContainerView * _chessContainerView;
    
    //stopwatch variables
    int _secondsLeft;
    NSTimer* _timer;
}

#pragma init

- (id)init
{
    self = [super init];
    if(self != nil){
        
    }
    return self;
}

- (void)createChessByTeam : (NSString*)team
                 andNumber: (NSInteger)n
                  andChess:(NSMutableArray*)chess
{
    //lazy init
    if (chess == nil) {
        chess = [[NSMutableArray alloc] init];
    }
    
    NSInteger teamPos = 0;
    if ([team  isEqual: @"red"]) {
        teamPos = redTeamPos;
        if (redLabel == nil) {
            redLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, teamPos-chessSize/2, 80, 50)];
            redLabel.text = @"Red Left:";
            [redLabel sizeToFit];
            [self.gameView addSubview:redLabel];
        }
    }else if ([team  isEqual: @"yellow"]) {
        teamPos = yellowTeamPos;
        if (yellowLabel == nil) {
            yellowLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, teamPos-chessSize/2, 80, 50)];
            yellowLabel.text = @"Yellow Left:";
            [yellowLabel sizeToFit];
            [self.gameView addSubview:yellowLabel];
        }
    }else if ([team  isEqual: @"purple"]) {
        teamPos = purpleTeamPos;
        if (purpleLabel == nil) {
            purpleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, teamPos-chessSize/2, 80, 50)];
            purpleLabel.text = @"Purple Left:";
            [purpleLabel sizeToFit];
            [self.gameView addSubview:purpleLabel];
        }
    }else if ([team  isEqual: @"green"]) {
        teamPos = greenTeamPos;
        if (greenLabel == nil) {
            greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, teamPos-chessSize/2, 80, 50)];
            greenLabel.text = @"Green Left:";
            [greenLabel sizeToFit];
            [self.gameView addSubview:greenLabel];
        }
    }

    
    for (int i = 0; i < n; i++) {
        ChessView* target = [[ChessView alloc] initWithTeam:team andId:i andSideLength:30.0];
        target.center = CGPointMake(margin*chessSize+chess.count*chessSize, teamPos);
        target.dragDelegate = self;
        [self.gameView addSubview:target];
        [chess addObject:target];
    }
}

- (void)createFrame : (float) x andY:(float)y andCapacity:(NSInteger)capacity
{
    FrameView* frame = [[FrameView alloc] initWithFrameCapacity:CGRectMake(x, y, 100.0, 100.0) andCapacity:capacity];
    [frame drawBoarder];
    [self.gameView addSubview:frame];
    [_frame addObject:frame];
}

- (void)newGame
{
    _frame = [[NSMutableArray alloc] init];
    frameCapacity = 3;
    
    
    //create player(s)
    assert(self.playerNumber >= 1 && self.playerNumber <=4);
    if (self.playerNumber == 1) {
        [self createChessByTeam:@"red" andNumber:5 andChess:_chess1];
    }else if(self.playerNumber == 2){
        [self createChessByTeam:@"red" andNumber:5 andChess:_chess1];
        [self createChessByTeam:@"yellow" andNumber:3 andChess:_chess2];
    }
    else if(self.playerNumber == 3){
        [self createChessByTeam:@"red" andNumber:5 andChess:_chess1];
        [self createChessByTeam:@"yellow" andNumber:3 andChess:_chess2];
        [self createChessByTeam:@"purple" andNumber:4 andChess:_chess3];
    }else if(self.playerNumber == 4){
        [self createChessByTeam:@"red" andNumber:5 andChess:_chess1];
        [self createChessByTeam:@"yellow" andNumber:3 andChess:_chess2];
        [self createChessByTeam:@"purple" andNumber:4 andChess:_chess3];
        [self createChessByTeam:@"green" andNumber:5 andChess:_chess4];
    }

    //create container
    [self createFrame:50 andY:200 andCapacity:frameCapacity];
    [self createFrame:150 andY:200 andCapacity:frameCapacity];
    [self createFrame:50 andY:300 andCapacity:frameCapacity];
    [self createFrame:150 andY:300 andCapacity:frameCapacity];
    
//    [self.gameView bringSubviewToFront:_chessContainerView];
    
    [self startStopwatch];
}

#pragma game logic

- (void) nextRound
{
    
}

- (void) checkGameEnd
{
    
}

#pragma move chess

-(void)chessView:(ChessView*)chessView didDragToPoint:(CGPoint)pt
{
    FrameView* inFrame = nil;
    
    for (FrameView *frame in _frame) {
        if (CGRectContainsPoint(frame.frame, pt) && frame.size < frame.capacity) {
            inFrame = frame;
            frame.size++;
            break;
        }
    }
    
    if (inFrame != nil) {
        [self placeTile:chessView atFrame:inFrame];
    }else{ //fail, restore original position
        NSInteger teamPos = 0;
        
        if ([chessView.team isEqual: @"red"]) {
            teamPos = redTeamPos;
        }else if ([chessView.team isEqual: @"yellow"]) {
            teamPos = yellowTeamPos;
        }else if ([chessView.team isEqual: @"purple"]) {
            teamPos = purpleTeamPos;
        }else if ([chessView.team isEqual: @"green"]) {
            teamPos = greenTeamPos;
        }
        
        chessView.center = CGPointMake(margin*chessSize+(chessView.id)*chessSize, teamPos);
        chessView.transform = CGAffineTransformIdentity;
      
    }
    
}

-(void)placeTile:(ChessView*)chessView atFrame:(FrameView*)frameView
{
//    targetView.isMatched = YES;
//    tileView.isMatched = YES;
    
    chessView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.35
                          delay:0.00
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                    
                         float x = frameView.center.x +rand()%FRAME_SIZE - rand()%FRAME_SIZE;
                         float y = frameView.center.y +rand()%FRAME_SIZE - rand()%FRAME_SIZE;
                         chessView.center = CGPointMake(x, y);
                         chessView.transform = CGAffineTransformIdentity;
                         
                         //remove from current array
                         if ([chessView.team isEqual: @"red"]) {
                             [_chess1 removeObject:chessView];
                         }else if ([chessView.team isEqual: @"yellow"]) {
                             [_chess2 removeObject:chessView];
                         }else if ([chessView.team isEqual: @"purple"]) {
                             [_chess3 removeObject:chessView];
                         }else if ([chessView.team isEqual: @"green"]) {
                             [_chess4 removeObject:chessView];
                         }
                         
                         //add to frame array
                         [frameView.chess addObject:chessView];
                        
                     }
                     completion:^(BOOL finished){
//                         frameView.hidden = YES;
                     }];
    
//    ExplodeView* explode = [[ExplodeView alloc] initWithFrame:CGRectMake(tileView.center.x,tileView.center.y,10,10)];
//    [tileView.superview addSubview: explode];
//    [tileView.superview sendSubviewToBack:explode];
}


- (void)activeAllChess
{
    for(ChessView *chess in _chess1){
        chess.userInteractionEnabled = YES;
    }
}

- (void)deactiveAllChess
{
    for(ChessView *chess in _chess1){
        chess.userInteractionEnabled = NO;
    }
}

#pragma StopWatch
-(void)startStopwatch
{
    //initialize the timer HUD
    _secondsLeft = 10;
    [self.hud.stopwatch setSeconds:_secondsLeft];
    
    //schedule a new timer
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(tick:)
                                            userInfo:nil
                                             repeats:YES];
}

//stop the watch
-(void)stopStopwatch
{
    [_timer invalidate];
    _timer = nil;
    
    [self deactiveAllChess];
}

//stopwatch on tick
-(void)tick:(NSTimer*)timer
{
    _secondsLeft --;
    [self.hud.stopwatch setSeconds:_secondsLeft];
    
    if (_secondsLeft==0) {
        [self stopStopwatch];
    }
}


@end
