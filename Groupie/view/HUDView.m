//
//  HUDView.m
//  Groupie
//
//  Created by Yuhua Mai on 10/13/13.
//  Copyright (c) 2013 Yuhua Mai. All rights reserved.
//

#import "HUDView.h"
#import "config.h"

@implementation HUDView

+(instancetype)viewWithRect:(CGRect)r
{
    //create the hud layer
    HUDView* hud = [[HUDView alloc] initWithFrame:r];
    hud.userInteractionEnabled = YES;
    
    //the stopwatch
    hud.stopwatch = [[StopwatchView alloc] initWithFrame: CGRectMake(kScreenWidth/2-150, 0, 300, 100)];
    hud.stopwatch.seconds = 0;
    [hud addSubview: hud.stopwatch];
    
//    //"points" label
//    UILabel* pts = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-340,30,140,70)];
//    pts.backgroundColor = [UIColor clearColor];
//    pts.font = kFontHUD;
//    pts.text = @" Points:";
//    [hud addSubview:pts];
//    
//    //the dynamic points label
//    hud.gamePoints = [CounterLabelView labelWithFont:kFontHUD frame:CGRectMake(kScreenWidth-200,30,200,70) andValue:0];
//    hud.gamePoints.textColor = [UIColor colorWithRed:0.38 green:0.098 blue:0.035 alpha:1] /*#611909*/;
//    [hud addSubview: hud.gamePoints];
//    
//    //load the button image
//    UIImage* image = [UIImage imageNamed:@"btn"];
//    
//    //the help button
//    hud.btnHelp = [UIButton buttonWithType:UIButtonTypeCustom];
//    [hud.btnHelp setTitle:@"Hint!" forState:UIControlStateNormal];
//    hud.btnHelp.titleLabel.font = kFontHUD;
//    [hud.btnHelp setBackgroundImage:image forState:UIControlStateNormal];
//    hud.btnHelp.frame = CGRectMake(50, 30, image.size.width, image.size.height);
//    hud.btnHelp.alpha = 0.8;
//    [hud addSubview: hud.btnHelp];
    
    return hud;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
