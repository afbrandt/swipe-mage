//
//  MCManager.m
//  SwipeMage
//
//  Created by Andrew Brandt on 11/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MCManager.h"

static NSString* const SWIPE_MAGE_PVP_KEY = @"swipe-mage-pvp";

@interface MCManager ()

@property (nonatomic, strong) MCPeerID *remotePeerID;
@property (nonatomic, assign) MCSessionState connectionState;

@end

@implementation MCManager

-(id)init{
    self = [super init];
   
    if (self) {
        _localPeerID = nil;
        _session = nil;
        _browser = nil;
        _advertiser = nil;
    }
   
    return self;
}

-(void)setupMCBrowser{
    self.localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.localPeerID serviceType:SWIPE_MAGE_PVP_KEY];
}

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName{
    self.localPeerID = [[MCPeerID alloc] initWithDisplayName:displayName];
   
    self.session = [[MCSession alloc] initWithPeer:self.localPeerID];
    self.session.delegate = self;
}

-(void)advertiseSelf:(BOOL)shouldAdvertise {
    if (shouldAdvertise) {
        self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.localPeerID
                                                        discoveryInfo:nil
                                                          serviceType:SWIPE_MAGE_PVP_KEY];
        self.advertiser.delegate = self;
        [self.advertiser startAdvertisingPeer];
    }
    else{
        [self.advertiser stopAdvertisingPeer];
        self.advertiser = nil;
    }
}

-(void)browse:(BOOL)shouldBrowse {
    if (shouldBrowse) {
        self.browser.delegate = self;
        [self.browser startBrowsingForPeers];
    }
    else {
        self.browser.delegate = nil;
        [self.browser stopBrowsingForPeers];
    }
}

#pragma mark - MCSessionDelegate methods

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    if (state == MCSessionStateConnecting) {
        self.connectionState = MCSessionStateConnecting;
        NSLog(@"connecting...");
    }
    else if (state == MCSessionStateConnected) {
        self.connectionState = MCSessionStateConnected;
        NSLog(@"connected!");
    }
    else {
    
    }
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
   
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
   
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
   
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
   
}

- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void(^)(BOOL accept))certificateHandler {
    certificateHandler(YES);
}

#pragma mark - MCNearbyServiceAdvertiserDelegate methods

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler {
    //NSLog([[NSString alloc] initWithData:context encoding:NSASCIIStringEncoding]);
    invitationHandler(YES, self.session);

}

#pragma mark - MCNearbyServiceBrowserDelegate methods

// Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)remotePeerID withDiscoveryInfo:(NSDictionary *)info {
    if (![self.localPeerID.displayName isEqualToString:remotePeerID.displayName] && self.connectionState == MCSessionStateNotConnected) {
        NSLog(@"found peer!");
        NSLog([remotePeerID displayName]);
        NSData *payload = [self.localPeerID.displayName dataUsingEncoding:NSASCIIStringEncoding];
        [browser invitePeer:remotePeerID toSession:self.session withContext:payload timeout:10.0f];
            
    }
}

// A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {

}

@end
