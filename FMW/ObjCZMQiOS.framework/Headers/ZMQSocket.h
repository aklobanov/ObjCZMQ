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
{
@public
    __block void        *_socket;
}
// Fabric methods
+ (ZMQSocket *)socketWithContext:(void *)context withType:(ZMQSocketType)type;
+ (ZMQSocket *)socketWithContext:(void *)context withType:(ZMQSocketType)type onQueue:(dispatch_queue_t)queue;
// Init methods
- (instancetype)initWithContext:(void *)context withType:(ZMQSocketType)type;
- (instancetype)initWithContext:(void *)context withType:(ZMQSocketType)type onQueue:(dispatch_queue_t)queue;
// Sync methods
- (BOOL)closeSyncWithError:(ZMQError **)error;
- (BOOL)connectSyncWithEndPoint:(ZMQEndPoint *)endPoint withError:(ZMQError *__autoreleasing *)error;
- (BOOL)disconnectSyncWithError:(ZMQError **)error;
- (BOOL)bindSyncWithEndPoint:(ZMQEndPoint *)endPoint withError:(ZMQError *__autoreleasing *)error;
- (BOOL)sendSyncData:(NSData *)data multiPart:(BOOL)isMultiPart withError:(ZMQError *__autoreleasing *)error;
- (BOOL)sendSyncData:(NSData *)data withPartSize:(NSUInteger)size withError:(ZMQError *__autoreleasing *)error;
- (BOOL)sendSyncString:(NSString *)string multiPart:(BOOL)isMultiPart withError:(ZMQError *__autoreleasing *)error;
- (BOOL)sendSyncString:(NSString *)string withPartSize:(NSUInteger)size withError:(ZMQError *__autoreleasing *)error;
- (NSData *)receiveSyncWithError:(ZMQError *__autoreleasing *)error;
- (NSData *)receiveSyncNoWaitWithError:(ZMQError *__autoreleasing *)error;
// Async mathods
- (void)closeAsyncWithCompletion:(void (^)(BOOL success,ZMQError *error))completion;
- (void)connectAsyncWithEndPoint:(ZMQEndPoint *)endPoint withCompletion:(void (^)(BOOL success,ZMQError *error))completion;
- (void)disconnectAsyncWithCompletion:(void (^)(BOOL success,ZMQError *error))completion;
- (void)bindAsyncWithEndPoint:(ZMQEndPoint *)endPoint withCompletion:(void (^)(BOOL success,ZMQError *error))completion;
- (void)sendAsyncData:(NSData *)data multiPart:(BOOL)isMultiPart withCompletion:(void (^)(BOOL success,ZMQError *error))completion;
- (void)sendAsyncData:(NSData *)data withPartSize:(NSUInteger)size withCompletion:(void (^)(BOOL success,ZMQError *error))completion;
- (void)sendAsyncString:(NSString *)string multiPart:(BOOL)isMultiPart withCompletion:(void (^)(BOOL success,ZMQError *error))completion;
- (void)sendAsyncString:(NSString *)string withPartSize:(NSUInteger)size withCompletion:(void (^)(BOOL success,ZMQError *error))completion;
- (void)receiveAsyncWithCompletion:(void (^)(NSData *data,ZMQError *error))completion;
- (void)receiveAsyncNoWaitWithCompletion:(void (^)(NSData *data,ZMQError *error))completion;
// Signalign
- (BOOL)subscribeWithData:(NSData *)subscribtion withError:(ZMQError *__autoreleasing *)error;
- (BOOL)unsubscribeWithData:(NSData *)subscribtion withError:(ZMQError *__autoreleasing *)error;
- (BOOL)pollWithTimeout:(long)timeout withError:(ZMQError *__autoreleasing *)error;
+ (BOOL)indefinitelyPollSockets:(NSArray <ZMQSocket *> *)sockets onQueue:(dispatch_queue_t)queue withSignal:(int)fd withResult:(NSSet <ZMQSocket *> *__autoreleasing *)result withError:(ZMQError *__autoreleasing *)error;
@end
