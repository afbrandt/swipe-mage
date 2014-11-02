//
//  MCManager.h
//  SwipeMage
//
//  Created by Andrew Brandt on 11/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MCManager : NSObject<MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>

@property (nonatomic, strong) MCPeerID *localPeerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;

-(void)advertiseSelf:(BOOL)shouldAdvertise;
-(void)browse:(BOOL)shouldBrowse;

@end
