//
//  FrameView.m
//  Groupie
//
//  Created by Yuhua Mai on 10/13/13.
//  Copyright (c) 2013 Yuhua Mai. All rights reserved.
//

#import "FrameView.h"

@implementation FrameView

- (id)initWithFrameCapacity:(CGRect)frame andCapacity:(int)capacity
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _capacity = capacity;
        _size = 0;
        _chess = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)drawBoarder
{
    [self.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.layer setBorderWidth: 2.0];
}


//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    [self.layer setBorderColor:[[UIColor blackColor] CGColor]];
//    [self.layer setBorderWidth: 2.0];
//}


@end
