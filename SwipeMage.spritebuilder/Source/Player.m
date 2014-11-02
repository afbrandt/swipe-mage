//
//  Player.m
//  SwipeMage
//
//  Created by Andrew Brandt on 11/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Player.h"

@interface Player ()

@property (nonatomic, assign) NSInteger shownHealth, shownMagic;
@property (nonatomic, assign) BOOL spentMagic, spentHealth;

@end

@implementation Player {
    CCNodeColor *magicBar;
    CCNodeColor *healthBar;
    float regenTimer;
}

static NSInteger MAX_HEALTH = 100;
static NSInteger MAX_MAGIC = 100;
static float REGEN_INCREMENT = 0.9f;
static NSInteger REGEN_AMOUNT = 10;

- (void)didLoadFromCCB {
    [self setupPlayer];
}

- (void)update: (CCTime)dt {
    regenTimer += dt;

    if (regenTimer > REGEN_INCREMENT) {
        if (self.magicPoints + REGEN_AMOUNT < MAX_MAGIC) {
            self.magicPoints += REGEN_AMOUNT;
            self.shownMagic += REGEN_AMOUNT;
            magicBar.scaleX = (float)self.shownMagic/100.f;
        }
        regenTimer = 0.f;
    }

    if (self.spentHealth) {
        self.shownHealth--;
        if (self.shownHealth > 0) {
            healthBar.scaleX = (float)self.shownHealth/100.f;
        }
        //NSLog(@"Health %ld",(long)self.healthPoints);
        if (self.shownHealth == self.healthPoints) {
            self.spentHealth = NO;
        }
    }
    
    if (self.spentMagic) {
        self.shownMagic--;
        magicBar.scaleX = (float)self.shownMagic/100.f;
        NSLog(@"%.2f",magicBar.scaleX);
        //NSLog(@"Magic %ld", (long)self.magicPoints);
        if (self.shownMagic == self.magicPoints) {
            self.spentMagic = NO;
        }
    }
    
    if (self.healthPoints < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"player-dead" object:nil];
    }
}

- (void)setupPlayer {
    self.healthPoints = MAX_HEALTH;
    self.shownHealth = MAX_HEALTH;
    self.magicPoints = MAX_HEALTH;
    self.shownMagic = MAX_MAGIC;
}

- (BOOL)canCast: (GameEvent)spell {
    switch (spell) {
        case GameEventTap:
            return self.magicPoints > 8;
        case GameEventUpOne:
            return self.magicPoints > 15;
        case GameEventLeftOne:
            return self.magicPoints > 35;
        case GameEventRightOne:
            return self.magicPoints > 10;
        case GameEventDownOne:
            return self.magicPoints > 15;
    }
}

- (void)spendHealth: (GameEvent)spell {
    self.spentHealth = YES;
    switch (spell) {
        case GameEventTap:
            self.healthPoints -= 4;
            break;
        case GameEventUpOne:
            self.healthPoints -= 15;
            break;
        case GameEventLeftOne:
            self.healthPoints -= 60;
            break;
        case GameEventRightOne:
            self.healthPoints -= 20;
            break;
        case GameEventDownOne:
            self.healthPoints -= 4;
            break;
        case GameEventEnd:
        case GameEventFizzle:
        case GameEventReady:
            self.spentHealth = NO;
            break;
    }
}

- (void)spendMagic: (GameEvent)spell {
    self.spentMagic = YES;
    switch (spell) {
        case GameEventTap:
            self.magicPoints -= 8;
            break;
        case GameEventUpOne:
            self.magicPoints -= 15;
            break;
        case GameEventLeftOne:
            self.magicPoints -= 35;
            break;
        case GameEventRightOne:
            self.magicPoints -= 10;
            break;
        case GameEventDownOne:
            self.magicPoints -= 15;
            break;
        case GameEventEnd:
        case GameEventFizzle:
        case GameEventReady:
            self.spentMagic = NO;
            break;
    }
    NSLog(@"spent magic!");
}

@end
