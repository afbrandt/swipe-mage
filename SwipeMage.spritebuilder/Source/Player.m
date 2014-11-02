//
//  Player.m
//  SwipeMage
//
//  Created by Andrew Brandt on 11/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Player.h"

@implementation Player

- (void)didLoadFromCCB {
    [self setupPlayer];
}

- (void)setupPlayer {
    self.healthPoints = 100;
    self.magicPoints = 100;
}

@end
