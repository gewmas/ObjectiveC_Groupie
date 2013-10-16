//
//  HUDView.h
//  Groupie
//
//  Created by Yuhua Mai on 10/13/13.
//  Copyright (c) 2013 Yuhua Mai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopWatchView.h"

@interface HUDView : UIView

@property (strong, nonatomic) StopwatchView* stopwatch;

+(instancetype)viewWithRect:(CGRect)r;

@end
