//
//  Gameplay.m
//  SwipeMage
//
//  Created by Andrew Brandt on 11/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "MainScene.h"
#import "Player.h"
#import "AppDelegate.h"

@interface Gameplay ()

@property (nonatomic, assign) BOOL isSwiping, isBusy;
@property (nonatomic, assign) CGPoint first, last;
@property (nonatomic, strong) NSMutableArray *swipe;
@property (nonatomic, strong) NSArray *peers;

@end

@implementation Gameplay {
    CCSprite *opponent;
    Player *player;
    float delay;
}


- (void)didLoadFromCCB {
    self.isSwiping = NO;
    self.isBusy = NO;
    self.swipe = [NSMutableArray new];
    self.peers = ((AppController *)[[UIApplication sharedApplication] delegate]).mcManager.session.connectedPeers;
    self.connectionManager = ((AppController *)[[UIApplication sharedApplication] delegate]).mcManager;
}

- (void)onEnter {
    [super onEnter];
    self.userInteractionEnabled = YES;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedEvent:) name:@"event-received" object:nil];
    self.connectionManager.session.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameOver:) name:@"player-dead" object:nil];
}

- (void)onExit {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super onExit];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    self.isSwiping = YES;
    self.first = touch.locationInWorld;
    [self.swipe addObject:touch];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    [self.swipe addObject:touch];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    self.isSwiping = NO;
    self.last = touch.locationInWorld;
    [self.swipe addObject:touch];
    
    GameEvent spell = [self getSpellFromSwipe];
    NSLog(@"%lo touches cleared...", (unsigned long)[self.swipe count]);
    [self.swipe removeAllObjects];
    
    //[self sendEvent:GameEventTap];
    NSLog(@"current magic: %ld", player.magicPoints);
    
    self.isBusy = YES;
    if([player canCast:spell]) {
        NSLog(@"spell cast!");
        [self sendEvent:spell];
        [self createEvent:spell];
    } else {
        NSLog(@"spell failed");
        [self sendEvent:GameEventFizzle];
        [self createEvent:GameEventFizzle];
    }
}

- (GameEvent)getSpellFromSwipe {
    if ([self.swipe count] < 5) {
        return GameEventTap;
    } else {
        int diffX = self.last.x - self.first.x;
        int diffY = self.last.y - self.first.y;
        if (diffX == 0) diffX = 0.1f;
        if (diffY/diffX > 1.8) {
            if (diffY > 0) {
                return GameEventUpOne;
            } else {
                return GameEventDownOne;
            }
        } else {
            if (diffX > 0) {
                return GameEventRightOne;
            } else {
                return GameEventLeftOne;
            }
        }
    }
    return GameEventFizzle;
}

- (void)gameOver: (NSNotification *)message {
    [self.animationManager runAnimationsForSequenceNamed:@"RecapSummon"];
}

- (void)mainMenu {
    MainScene *main = (MainScene *)[CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] presentScene:main];
}

#pragma mark - Event handling methods

- (void)sendEvent: (GameEvent)event {
    NSNumber *num = [NSNumber numberWithInteger:event];
    NSDictionary *payload = @{@"event":num};
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:payload];
    //NSData *data = [@"hello world" dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    [self.connectionManager.session sendData:data toPeers:self.peers withMode:MCSessionSendDataReliable error:&error];
}

- (void)createEvent: (GameEvent)event {
    [player spendMagic:event];
    CCAction *path;
    CCNode *spell = [CCNode node];
    spell.position = self.last;
    CCParticleSystem *effect;
    switch (event) {
        case GameEventTap:
            effect = (CCParticleSystem *)[CCBReader load:@"Spells/MagicMissile"];
            effect.autoRemoveOnFinish = YES;
            path = [CCActionMoveTo actionWithDuration:1.0f position:opponent.position];
            break;
        case GameEventUpOne:
            spell = [CCBReader load:@"Spells/FireBlast"];
            spell.position = self.last;
            path = [CCActionJumpTo actionWithDuration:1.0f position:opponent.position height:0.5f jumps:1];
            break;
        case GameEventDownOne:
            spell = [CCBReader load:@"Spells/Nullify"];
            spell.position = opponent.position;
            path = [CCAction action];
            break;
        case GameEventLeftOne:
            spell = [CCBReader load:@"Spells/MegaBlast"];
            spell.position = self.last;
            path = [CCActionMoveTo actionWithDuration:2.0f position:opponent.position];
            break;
        case GameEventRightOne:
            spell = (CCParticleSystem *)[CCBReader load:@"Spells/IceStorm"];
            spell.position = ccpAdd(opponent.position, ccp(0,100));
            path = [CCAction action];
            break;
        case GameEventFizzle:
            spell = [CCNode node];
            spell.position = self.last;
            effect = (CCParticleSystem *)[CCBReader load:@"Spells/Fizzle"];
            effect.autoRemoveOnFinish = YES;
            break;
        case GameEventReady:
            break;
    }
    [self addChild:spell];
    if (effect) {
        [spell addChild:effect];
    }
    if (path) {
        [spell.animationManager setCompletedAnimationCallbackBlock:^(id sender) {
            [spell removeFromParent];
        }];
        [spell runAction:path];
    }
}

- (void)receivedEvent: (NSData *)message {
    NSDictionary *payload = (NSDictionary *) [NSKeyedUnarchiver unarchiveObjectWithData:message];
    NSNumber *num = payload[@"event"];
    GameEvent event = [num integerValue];
    switch (event) {
        case GameEventTap:
            NSLog(@"received tap!");
            break;
        case GameEventUpOne:
            NSLog(@"received up!");
            break;
        case GameEventDownOne:
            NSLog(@"received down!");
            break;
        case GameEventLeftOne:
            NSLog(@"received left!");
            break;
        case GameEventRightOne:
            NSLog(@"received right!");
            break;
        case GameEventFizzle:
            NSLog(@"recieved fizzle");
            break;
        case GameEventReady:
            break;
    }
    [player spendHealth:event];
}


#pragma mark - MCSessionDelegate methods

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    switch (state) {
        case MCSessionStateConnected:
            break;
        case MCSessionStateConnecting:
            break;
        case MCSessionStateNotConnected:
            break;
    }
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
   NSLog(@"Received new data!");
   [self receivedEvent:data];
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
   //not used...
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
   //not used...
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
   //not used...
}

- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void(^)(BOOL accept))certificateHandler {
    certificateHandler(YES);
}

@end
