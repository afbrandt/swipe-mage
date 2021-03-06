//
//  Player.h
//  SwipeMage
//
//  Created by Andrew Brandt on 11/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Gameplay.h"

@interface Player : CCNode

@property (nonatomic, assign) NSInteger healthPoints;
@property (nonatomic, assign) NSInteger magicPoints;

- (void)spendHealth: (GameEvent)event;
- (void)spendMagic: (GameEvent)event;
- (BOOL)canCast: (GameEvent)event;

@end
