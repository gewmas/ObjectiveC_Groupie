//
//  GroupieControllerViewController.m
//  Groupie
//
//  Created by Yuhua Mai on 10/13/13.
//  Copyright (c) 2013 Yuhua Mai. All rights reserved.
//

#import "GroupieControllerViewController.h"
#import "GameController.h"
#import "config.h"

@interface GroupieControllerViewController ()
@property (strong, nonatomic) GameController* controller;
@end

@implementation GroupieControllerViewController


- (id)init
{
    self = [super init];
    if(self != nil){
        self.controller = [[GameController alloc] init];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //add one layer for all game elements
    UIView* gameLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    [gameLayer setAlpha:1.2];
    [self.view addSubview: gameLayer];
    self.controller.gameView = gameLayer;
    
    //add one layer for all hud and controls
    HUDView* hudView = [HUDView viewWithRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:hudView];
    self.controller.hud = hudView;
    
    [self.view bringSubviewToFront:gameLayer];
    
    
    __weak GroupieControllerViewController* weakSelf = self;
    self.controller.onGameFinish = ^(){
        [weakSelf showLevelMenu];
    };
    
    
}

//show tha game menu on app start
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showLevelMenu];
}

#pragma mark - Game manu
//show the level selector menu
-(void)showLevelMenu
{
    UIActionSheet* action = [[UIActionSheet alloc] initWithTitle:@"Play with # bored friends:"
                                                        delegate:(id)self
                                               cancelButtonTitle:@"Oh! Don't touch me!"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"1 guy", @"2  dudes" , @"3 for triangle", @"4 in a group", nil];
    [action showInView:self.view];
}

//level was selected, load it up and start the game
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //1 check if the user tapped outside the menu
    if (buttonIndex==-1) {
        [self showLevelMenu];
        return;
    }
    
    //2 map index 0 to level 1, etc...
    int playerNum = buttonIndex+1;
    
    //3 load the level, fire up the game
    
    self.controller.playerNumber = playerNum;
//    self.controller.level = [Level levelWithPlayerNum:levelNum];
//    [self.controller dealRandomAnagram];
    [self.controller newGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
