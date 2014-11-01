//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Gameplay.h"

@implementation MainScene

- (void)onEnter {
    [super onEnter];
}

- (void)browseForDevices {
    NSLog(@"Looking for peer...");
    CCNode *searchDialog = [CCBReader load:@"SearchDialog" owner:self];
    [self addChild:searchDialog];
}

- (void)startGame {
    Gameplay *gameplay = (Gameplay *)[CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] presentScene:gameplay];
}

@end
