//
//  ViewController.m
//  WZZ_Chat_room
//
//  Created by 王召洲 on 16/8/13.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "ViewController.h"

#define SERVICE @"YY"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
@interface ViewController ()<MCSessionDelegate,MCBrowserViewControllerDelegate>
@property (strong,nonatomic) MCPeerID * peerID;
@property (strong,nonatomic) MCSession * session;
@property (assign,nonatomic) BOOL connected;
@property (strong,nonatomic) MCBrowserViewController * browser;
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
-(MCBrowserViewController *)browser {
    if (_browser == nil) {
        _browser = [[MCBrowserViewController alloc]initWithServiceType:SERVICE session:self.session];
        _browser.delegate = self;
    }
    return _browser;
}

#pragma mark - session  methods
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    switch (state) {
        case MCSessionStateConnected:
            NSLog(@"connected");
            self.connected = YES;
            break;
        case MCSessionStateConnecting:
            NSLog(@"connectING");
        default:
        case MCSessionStateNotConnected:
            NSLog(@"connectedNOT");
            break;
    }
    
}
-(void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL))certificateHandler {
    NSLog(@"%@",peerID.displayName);
    // 连接授权
    certificateHandler(YES);
}
-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
    
}
-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}
-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}
#pragma mark - browser  methods
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)setupUI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 100);
    btn.center = self.view.center;
    btn.layer.cornerRadius = 10;
    [btn setTitle:@"发现" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(browseBtn) forControlEvents:UIControlEventTouchUpInside];
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

-(void)sendTest {
    if (self.connected) {
        
        NSString *str = [NSString stringWithFormat:@"%c%@",arc4random_uniform(26)+65,@"hello"];
        
        
        NSLog(@"%@",self.session.connectedPeers);
        
        NSError *error;
        [self.session sendData:[str dataUsingEncoding:NSUTF8StringEncoding] toPeers:self.session.connectedPeers withMode:(MCSessionSendDataUnreliable) error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
}

-(void)browseBtn {
    [self presentViewController:self.browser animated:YES completion:^{
        NSLog(@"弹出了");
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
