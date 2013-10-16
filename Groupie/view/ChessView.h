//
//  ChessView.h
//  Groupie
//
//  Created by Yuhua Mai on 10/13/13.
//  Copyright (c) 2013 Yuhua Mai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"

@class ChessView;

@protocol ChessDragDelegateProtocol <NSObject>
-(void)chessView:(ChessView*)chessView didDragToPoint:(CGPoint)pt;
@end


@interface ChessView : UIImageView

@property (strong, nonatomic, readonly) NSString* team;
@property (assign, nonatomic) BOOL isAvailable;
@property (weak, nonatomic) id<ChessDragDelegateProtocol> dragDelegate;

- (id)initWithTeam : (NSString*)team andSideLength:(float)length;

@end
