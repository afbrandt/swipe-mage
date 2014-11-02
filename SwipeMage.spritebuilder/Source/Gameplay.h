//
//  Gameplay.h
//  SwipeMage
//
//  Created by Andrew Brandt on 11/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
@class MCManager;

typedef NS_ENUM(NSInteger, GameEvent) {
    GameReady,
    GameEventTap,
    GameEventUpOne,
    GameEventDownOne,
    GameEventLeftOne,
    GameEventRightOne,
    GameEventFizzle
};

@interface Gameplay : CCNode<MCSessionDelegate>

@property (nonatomic, strong) MCManager *connectionManager;

@end


