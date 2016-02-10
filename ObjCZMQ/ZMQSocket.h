//
//  ZMQSocket.h
//  ObjCZMQ
//
//  Created by ALEXEY LOBANOV on 10.02.16.
//  Copyright © 2016 Blue Skies Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZMQContext.h"
#import "ZMQError.h"
#import "ZMQEndPoint.h"
#import "zmq.h"

typedef NS_ENUM(NSUInteger,ZMQSocketType)
{
    kZMQSocketPair      = ZMQ_PAIR,
    kZMQSocketPub       = ZMQ_PUB,
    kZMQSocketSub       = ZMQ_SUB,
    kZMQSocketReq       = ZMQ_REQ,
    kZMQSocketRep       = ZMQ_REP,
    kZMQSocketDealer    = ZMQ_DEALER,
    kZMQSocketRouter    = ZMQ_ROUTER,
    kZMQSocketPull      = ZMQ_PULL,
    kZMQSocketPush      = ZMQ_PUSH,
    kZMQSocketXPub      = ZMQ_XPUB,
    kZMQSocketXSub      = ZMQ_XSUB,
    kZMQSocketStream    = ZMQ_STREAM,
    kZMQSocketServer    = ZMQ_SERVER,
    kZMQSocketClient    = ZMQ_CLIENT,
    kZMQSocketRadio     = ZMQ_RADIO,
    kZMQSocketDish      = ZMQ_DISH,
    kZMQSocketXReq      = ZMQ_XREQ,
    kZMQSocketXRep      = ZMQ_XREP
};
@interface ZMQSocket : NSObject
// Fabric methods
+ (ZMQSocket *)socketWithContext:(ZMQContext *)context withType:(ZMQSocketType)type;
+ (ZMQSocket *)socketWithContext:(ZMQContext *)context withType:(ZMQSocketType)type onQueue:(dispatch_queue_t)queue;
// Init methods
- (instancetype)initWithContext:(ZMQContext *)context withType:(ZMQSocketType)type;
- (instancetype)initWithContext:(ZMQContext *)context withType:(ZMQSocketType)type onQueue:(dispatch_queue_t)queue;
// Sync methods
- (BOOL)closeSyncWithError:(ZMQError **)error;
- (BOOL)connectSyncWithEndPoint:(ZMQEndPoint *)endPoint withError:(ZMQError **)error;
- (BOOL)disconnectSyncWithError:(ZMQError **)error;
- (BOOL)bindSyncWithEndPoint:(ZMQEndPoint *)endPoint withError:(ZMQError **)error;
- (BOOL)sendSyncData:(NSData *)data multiPart:(BOOL)isMultiPart withError:(ZMQError **)error;
- (BOOL)sendSyncString:(NSString *)string multiPart:(BOOL)isMultiPart withError:(ZMQError **)error;
- (NSData *)receiveSyncWithError:(ZMQError **)error;
// Async mathods
- (void)closeAsyncWithCompletion:(void (^)(BOOL success,ZMQError *error))completion;
- (void)connectAsyncWithEndPoint:(ZMQEndPoint *)endPoint withCompletion:(void (^)(BOOL success,ZMQError *error))completion;
- (void)disconnectAsyncWithCompletion:(void (^)(BOOL success,ZMQError *error))completion;
- (void)bindAsyncWithEndPoint:(ZMQEndPoint *)endPoint withCompletion:(void (^)(BOOL success,ZMQError *error))completion;
- (void)sendAsyncData:(NSData *)data multiPart:(BOOL)isMultiPart withCompletion:(void (^)(BOOL success,ZMQError *error))completion;
- (void)sendAsyncString:(NSString *)string multiPart:(BOOL)isMultiPart withCompletion:(void (^)(BOOL success,ZMQError *error))completion;
- (void)receiveAsyncWithCompletion:(void (^)(NSData *data,ZMQError *error))completion;
@end
