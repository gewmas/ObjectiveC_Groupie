//
//  ChessView.m
//  Groupie
//
//  Created by Yuhua Mai on 10/13/13.
//  Copyright (c) 2013 Yuhua Mai. All rights reserved.
//

#import "ChessView.h"

@implementation ChessView
{
    int _xOffset, _yOffset;
    CGAffineTransform _tempTransform;
}

- (id)initWithTeam : (NSString*)team andSideLength:(float)sideLength
{
    //the tile background
    NSString *s = [[NSString alloc] initWithFormat:@"%@.png", team];
    
    UIImage* img = [UIImage imageNamed:s];
    
    //create a new object
    self = [super initWithImage:img];

    if (self != nil) {
        
        //resize the tile
        float scale = sideLength/img.size.width;
        self.frame = CGRectMake(0,0,img.size.width*scale, img.size.height*scale);

        self.userInteractionEnabled = YES;
    }
    
    return self;
}


//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    NSLog(@"drawing Rect!");
//}

#pragma mark - dragging the tile
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self.superview];
    _xOffset = pt.x - self.center.x;
    _yOffset = pt.y - self.center.y;
    
    //show the drop shadow
    self.layer.shadowOpacity = 0.8;
    
    //save the current transform
    _tempTransform = self.transform;
    
    //enlarge the tile
    self.transform = CGAffineTransformScale(self.transform, 1.2, 1.2);
    
    [self.superview bringSubviewToFront:self];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self.superview];
    self.center = CGPointMake(pt.x - _xOffset, pt.y - _yOffset);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
    
    //restore the original transform
    self.transform = _tempTransform;
    
    if (self.dragDelegate) {
        [self.dragDelegate chessView:self didDragToPoint:self.center];
    }
    
    self.layer.shadowOpacity = 0.0;
}

//reset the view transoform in case drag is cancelled
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.transform = _tempTransform;
    self.layer.shadowOpacity = 0.0;
}

@end
