//
//  GameController.m
//  Groupie
//
//  Created by Yuhua Mai on 10/13/13.
//  Copyright (c) 2013 Yuhua Mai. All rights reserved.
//

#import "GameController.h"
#import "ChessView.h"
#import "FrameView.h"
#import "config.h"

#define FRAME_SIZE 40

@implementation GameController
{
    NSMutableArray* _chess;
    NSMutableArray* _frame;
    NSInteger frameCapacity;
    
    //stopwatch variables
    int _secondsLeft;
    NSTimer* _timer;
}

- (id)init
{
    self = [super init];
    if(self != nil){
        
    }
    return self;
}

- (void)createChessByTeam : (NSString*)Team andNumber: (NSInteger)n andTeamPoistion:(NSInteger)p
{
    for (int i = 0; i < n; i++) {
        ChessView* target = [[ChessView alloc] initWithTeam:Team andSideLength:30.0];
        target.center = CGPointMake(50+i*50, p);
        target.dragDelegate = self;
        [self.gameView addSubview:target];
        [_chess addObject:target];
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
    _chess = [[NSMutableArray alloc] init];
    _frame = [[NSMutableArray alloc] init];
    frameCapacity = 3;
    
    [self createChessByTeam:@"red" andNumber:3 andTeamPoistion:50];
    [self createChessByTeam:@"yellow" andNumber:3 andTeamPoistion:90];
    [self createChessByTeam:@"purple" andNumber:3 andTeamPoistion:130];
    [self createChessByTeam:@"green" andNumber:3 andTeamPoistion:170];
    
    
    [self createFrame:50 andY:200 andCapacity:frameCapacity];
    [self createFrame:150 andY:200 andCapacity:frameCapacity];
    [self createFrame:50 andY:300 andCapacity:frameCapacity];
    [self createFrame:150 andY:300 andCapacity:frameCapacity];
    
    [self startStopwatch];
}

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
        chessView.center = CGPointMake(150, 150);
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
                     }
                     completion:^(BOOL finished){
//                         frameView.hidden = YES;
                     }];
    
//    ExplodeView* explode = [[ExplodeView alloc] initWithFrame:CGRectMake(tileView.center.x,tileView.center.y,10,10)];
//    [tileView.superview addSubview: explode];
//    [tileView.superview sendSubviewToBack:explode];
}

#pragma StopWatch
-(void)startStopwatch
{
    //initialize the timer HUD
    _secondsLeft = 30;
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
