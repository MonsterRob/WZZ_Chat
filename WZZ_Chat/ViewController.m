//
//  ViewController.m
//  WZZ_Chat
//
//  Created by 王召洲 on 16/8/13.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "ViewController.h"

#define SERVICE @"YY"
@import MultipeerConnectivity;
@interface ViewController ()<MCSessionDelegate,MCAdvertiserAssistantDelegate>
@property (strong,nonatomic) MCPeerID * peerID;
@property (strong,nonatomic) MCSession * session;
@property (strong,nonatomic) MCAdvertiserAssistant * advertiser;

@end

@implementation ViewController

-(MCPeerID *)peerID {
    if (_peerID == nil) {
        _peerID = [[MCPeerID alloc]initWithDisplayName:@"WZZ"];
    }
    return _peerID;
}

-(MCSession *)session {
    if (_session == nil) {
        _session = [[MCSession alloc]initWithPeer:self.peerID];
        _session.delegate = self;
    }
    return _session;
}
-(MCAdvertiserAssistant *)advertiser {
    if (_advertiser == nil) {
        _advertiser = [[MCAdvertiserAssistant alloc]initWithServiceType:SERVICE discoveryInfo:nil session:self.session];
        _advertiser.delegate = self;
    }
    return  _advertiser;
}


#pragma mark - control  methods
//==================================================================//
-(void)setupUI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 100);
    btn.center = self.view.center;
    btn.layer.cornerRadius = 10;
    [btn setTitle:@"广播" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(advertiseBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 100);
    btn.center = CGPointMake(self.view.center.x, 200);
    btn.layer.cornerRadius = 10;
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(sendTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}
-(void)advertiseBtn {
    [self.advertiser start];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
//==================================================================//




#pragma mark - session  methods
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
    switch (state) {
        case MCSessionStateConnected:
            NSLog(@"connected----->");
            
            break;
        case MCSessionStateConnecting:
            NSLog(@"connectING----->");
        default:
        case MCSessionStateNotConnected:
            NSLog(@"connectedNOT------>");
            break;
    }

    
}
-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    NSLog(@"source come");
}
-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    NSLog(@"stream come");
}
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSLog(@"data come");
    
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
}
-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    NSLog(@"resource finish");
}
-(void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL))certificateHandler {
    
    NSLog(@"%@",peerID.displayName);
    certificateHandler(YES);
    
}
-(void)advertiserAssistantDidDismissInvitation:(MCAdvertiserAssistant *)advertiserAssistant {
    
}
-(void)advertiserAssistantWillPresentInvitation:(MCAdvertiserAssistant *)advertiserAssistant {
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
