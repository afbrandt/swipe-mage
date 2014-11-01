//
//  Gameplay.m
//  SwipeMage
//
//  Created by Andrew Brandt on 11/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"


@interface Gameplay ()

@property (nonatomic, assign) BOOL isSwiping;
@property (nonatomic, strong) NSMutableArray *swipe;

@end

@implementation Gameplay


- (void)didLoadFromCCB {
    self.isSwiping = NO;
    self.swipe = [NSMutableArray new];
}

- (void)onEnter {
    [super onEnter];
    self.userInteractionEnabled = YES;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    self.isSwiping = YES;
    [self.swipe addObject:touch];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    [self.swipe addObject:touch];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    self.isSwiping = NO;
    [self.swipe addObject:touch];
    NSLog(@"%lo touches cleared...", (unsigned long)[self.swipe count]);
    [self.swipe removeAllObjects];
}


@end
