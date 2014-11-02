//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Gameplay.h"

@implementation MainScene {
    BOOL browsing;
    float browseTimer;
}

- (void)onEnter {
    [super onEnter];
    
    _appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    browsing = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startGame:) name:@"peer-connect" object:nil];
}

- (void)onExit {
    [self.appDelegate.mcManager advertiseSelf:NO];
    [self.appDelegate.mcManager browse:NO];
    [super onExit];
}

- (void)startGame: (NSNotification *)message {
    Gameplay *gameplay = (Gameplay *)[CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] presentScene:gameplay];
}

- (void)update: (CCTime)dt {
    if (browsing) {
        browseTimer += dt;
        if (browseTimer > 0.5f) {
        }
    }
}

- (void)browseForDevices {
    NSLog(@"Looking for peer...");
    CCNode *searchDialog = [CCBReader load:@"SearchDialog" owner:self];
    [self addChild:searchDialog];
    [[_appDelegate mcManager] advertiseSelf:YES];
    [[_appDelegate mcManager] browse:YES];
    browsing = YES;
    browseTimer = 0.0f;
}

/*

#pragma mark - MCBrowserViewControllerDelegate methods

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}


-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}

*/
@end
