//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "AppDelegate.h"

@interface MainScene : CCNode

@property (nonatomic, strong) AppController* appDelegate;

- (void)startGame;

@end
