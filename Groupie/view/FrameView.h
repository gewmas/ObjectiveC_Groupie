//
//  FrameView.h
//  Groupie
//
//  Created by Yuhua Mai on 10/13/13.
//  Copyright (c) 2013 Yuhua Mai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrameView : UIImageView
{
}


@property (nonatomic) NSInteger capacity;
@property (nonatomic) NSInteger size;
@property (nonatomic) NSMutableArray *chess;
@property (nonatomic) UILabel *capacityLabel;


- (id)initWithFrameCapacity:(CGRect)frame andCapacity:(NSInteger)capacity;
- (void)drawBoarder;

@end
