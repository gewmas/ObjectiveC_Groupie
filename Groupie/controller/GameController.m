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
    NSArray *_teamArray;
    NSUInteger _teamNum;
    
    //chess view
    NSMutableDictionary *_chess;
    NSUInteger _chessNum;
    
    //label
    NSMutableDictionary *_chessLabel;
    
    //frame view
    NSMutableArray* _frame;
    
    //drawing factor
    double _factor;
    int _framePerRow;
    double _frameTop;
    
    //stopwatch variables
    int _secondsLeft;
    int _gameTime;
    NSTimer* _timer;
}

#pragma init

- (id)init
{
    self = [super init];
    if(self != nil){
        NSString *deviceType = [UIDevice currentDevice].model;
        
        _factor = 1;
        if([deviceType isEqualToString:@"iPhone"]) {
            //iPhone
            _factor = 1.5;
            _framePerRow = 2;
        }else if([deviceType isEqualToString:@"iPad"]){
            //iPad
            _factor = 2;
            _framePerRow = 3;
        }
        
        _chess = [[NSMutableDictionary alloc] init];
        _chessLabel = [[NSMutableDictionary alloc] init];
        _teamArray = @[@"red",@"yellow",@"purple",@"green"];
        _teamNum = _teamArray.count;
        _chessNum = 0;
        
        _gameTime = 15;
    }
    return self;
}

- (void)createChessLabel : (NSString*) team
{
    UILabel *label;
    double teamPos = 0;
    if ([team  isEqual: @"red"]) {
        teamPos = redTeamPos;
    }
    else if ([team  isEqual: @"yellow"]) {
        teamPos = yellowTeamPos;
    }
    else if ([team  isEqual: @"purple"]) {
        teamPos = purpleTeamPos;
    }
    else if ([team  isEqual: @"green"]) {
        teamPos = greenTeamPos;
    }
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, _factor*teamPos, 100, 100)];
    label.text = [[NSString alloc] initWithFormat:@"%@ left:", team];
    _frameTop = _factor*teamPos*1.5;
    
    [label sizeToFit];
    _chessLabel[team] = label;
    
    
    [self.gameView addSubview:label];
    
}



- (void)createChessByTeam : (NSString*)team
                 andNumber: (NSInteger)n
{
    [self createChessLabel:team];
    
    NSMutableArray* chess = [[NSMutableArray alloc] init];
    for (int i = 0; i < n; i++) {
        ChessView* chessView = [[ChessView alloc] initWithTeam:team andId:i andSideLength:_factor*30.0];
        [chess addObject:chessView];
    }
    
    _chess[team] = chess;
    
    
}

- (void) drawChess
{
    for(NSString *team in _teamArray){
        NSMutableArray *chesses = _chess[team];
        
        NSInteger teamPos = 0;
        if ([team isEqual: @"red"]) {
            teamPos = redTeamPos;
        }else if ([team isEqual: @"yellow"]) {
            teamPos = yellowTeamPos;
        }else if ([team isEqual: @"purple"]) {
            teamPos = purpleTeamPos;
        }else if ([team isEqual: @"green"]) {
            teamPos = greenTeamPos;
        }
        
        if (chesses != nil) {
            int i = 0;
            for (ChessView *chess in chesses) {
                chess.center = CGPointMake(margin*chessSize+(i++)*_factor*chessSize, _factor*teamPos);
                
                chess.dragDelegate = self;
                [self.gameView addSubview:chess];
            }
        }
    }
    
}

- (void)createFrame
{
    [self countAllChess];
    
    int capacity = rand()%_chessNum;
    NSInteger frameNum = _chessNum/capacity;
    if (frameNum <= 0) {
        frameNum = 1;
    }
    
    for (int i = 0; i < frameNum; i++) {
        FrameView* frame = [[FrameView alloc] initWithFrameCapacity:CGRectMake(0, 0, _factor*FRAME_SIZE, _factor*FRAME_SIZE) andCapacity:capacity];
        [frame drawBoarder];
        [_frame addObject:frame];
    }
    
    [self drawFrame];
}


- (void) drawFrame
{
    int i = 0, j = 0;
    for(FrameView *fv in _frame){
        [self.gameView addSubview:fv];
        fv.center = CGPointMake(1.5*FRAME_SIZE+_factor*FRAME_SIZE*1.5*i, _frameTop+_factor*FRAME_SIZE*1.5*j);
        
        
        
        fv.capacityLabel.text = [[NSString alloc] initWithFormat:@"%ld",(long)fv.capacity];
        fv.capacityLabel.center = fv.center;
        
        [self.gameView addSubview:fv.capacityLabel];
        
        i++;
        
        if (i % _framePerRow == 0) {
            j++;
            i -= _framePerRow;
        }
    }
}

- (void)newGame
{
    _frame = [[NSMutableArray alloc] init];
    
    //create chess(s)
    assert(self.playerNumber >= 1 && self.playerNumber <=4);
    if (self.playerNumber == 1) {
        [self createChessByTeam:@"red" andNumber:5];
    }
    else if(self.playerNumber == 2){
        [self createChessByTeam:@"red" andNumber:5];
        [self createChessByTeam:@"yellow" andNumber:5];
    }
    else if(self.playerNumber == 3){
        [self createChessByTeam:@"red" andNumber:5];
        [self createChessByTeam:@"yellow" andNumber:5];
        [self createChessByTeam:@"purple" andNumber:5];
    }
    else if(self.playerNumber == 4){
        [self createChessByTeam:@"red" andNumber:5];
        [self createChessByTeam:@"yellow" andNumber:5];
        [self createChessByTeam:@"purple" andNumber:5];
        [self createChessByTeam:@"green" andNumber:5];
    }
    [self drawChess];
    
    //create container
    [self createFrame];
    
    [self startStopwatch];
}



#pragma game logic

- (void) countAllChess
{
    _chessNum = 0;
    for(NSString *team in _teamArray){
        NSMutableArray *chesses = _chess[team];
        if (chesses != nil) {
            for (ChessView *chess in chesses) {
                _chessNum++;
            }
        }
    }
}

- (void) nextRound
{
    [self drawChess];
    
    //recreate frame
    [self createFrame];
    
    [self activeAllChess];
    [self startStopwatch];
}

- (void) checkGameEnd
{
    [self deactiveAllChess];
    
    //clear current chess
    for(NSString *team in _teamArray){
        NSMutableArray *chesses = _chess[team];
        if (chesses != nil) {
            //remove from view
            for (ChessView *chess in chesses) {
                [chess removeFromSuperview];
            }
            
            [chesses removeAllObjects];
        }
    }
    
    //recaculate chess for each team
    for (FrameView *frameView in _frame) {
        for (ChessView *chess in frameView.chess){
            [_chess[chess.team] addObject:chess];
            [chess removeFromSuperview];
        }
        [frameView removeFromSuperview];
    }
    //clear _frame
    for (FrameView *frameView in _frame) {
        [frameView.capacityLabel removeFromSuperview];
    }
    [_frame removeAllObjects];
    
    //check which fails
    for(NSString *team in _teamArray){
        NSMutableArray *chesses = _chess[team];
        if (chesses != nil) {
            //no chess left
            if (chesses.count == 0) {
                UILabel *label = _chessLabel[team];
                label.text = [NSString stringWithFormat:@"%@ fail", team];
                [_chess removeObjectForKey:team];
            }
        }
    }
    
    // the only one left win!
    if (_chess.count == 1) {
        for(NSString *team in _teamArray){
            NSMutableArray *chesses = _chess[team];
            if (chesses != nil) {
                UILabel *label = _chessLabel[team];
                label.text = [NSString stringWithFormat:@"%@ win", team];
                [_chess removeObjectForKey:team];
                [self stopStopwatch];
                return;
            }
        }
    }
    
    [self nextRound];
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
    
    //success, put in frame
    if (inFrame != nil) {
        [self placeTile:chessView atFrame:inFrame];
        
        //remove from current array
        [_chess[chessView.team] removeObject:chessView];
        //        if ([chessView.team isEqual: @"red"]) {
        //            [_chess1 removeObject:chessView];
        //        }else if ([chessView.team isEqual: @"yellow"]) {
        //            [_chess2 removeObject:chessView];
        //        }else if ([chessView.team isEqual: @"purple"]) {
        //            [_chess3 removeObject:chessView];
        //        }else if ([chessView.team isEqual: @"green"]) {
        //            [_chess4 removeObject:chessView];
        //        }
        
        //add to frame array
        [inFrame.chess addObject:chessView];
    }
    //fail, restore original position
    else{
        [self drawChess];
//        NSInteger teamPos = 0;
//        
//        if ([chessView.team isEqual: @"red"]) {
//            teamPos = redTeamPos;
//        }else if ([chessView.team isEqual: @"yellow"]) {
//            teamPos = yellowTeamPos;
//        }else if ([chessView.team isEqual: @"purple"]) {
//            teamPos = purpleTeamPos;
//        }else if ([chessView.team isEqual: @"green"]) {
//            teamPos = greenTeamPos;
//        }
//        
//        chessView.center = CGPointMake(margin*chessSize+(chessView.id)*chessSize, teamPos);
//        chessView.transform = CGAffineTransformIdentity;
        
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
                         
                         float x = frameView.center.x + rand()%FRAME_SIZE/2*2 - FRAME_SIZE/2;
                         float y = frameView.center.y + rand()%FRAME_SIZE/2*2 - FRAME_SIZE/2;
                         
                         chessView.center = CGPointMake(x, y);
                         chessView.transform = CGAffineTransformIdentity;
                         
                         
                         
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
    for(NSString *team in _teamArray){
        NSMutableArray *chesses = _chess[team];
        if (chesses != nil) {
            for (ChessView *chess in chesses) {
                chess.userInteractionEnabled = YES;
            }
        }
    }
}

- (void)deactiveAllChess
{
    for(NSString *team in _teamArray){
        NSMutableArray *chesses = _chess[team];
        if (chesses != nil) {
            for (ChessView *chess in chesses) {
                chess.userInteractionEnabled = NO;
            }
        }
    }
}

#pragma StopWatch
-(void)startStopwatch
{
    //initialize the timer HUD
    _secondsLeft = (_gameTime *= 0.7);
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
    
    [self checkGameEnd];
}

//stopwatch on tick
-(void)tick:(NSTimer*)timer
{
    _secondsLeft--;
    [self.hud.stopwatch setSeconds:_secondsLeft];
    
    if (_secondsLeft==0) {
        [self stopStopwatch];
    }
}


@end
