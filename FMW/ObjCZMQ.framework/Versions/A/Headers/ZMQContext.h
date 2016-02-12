//
//  ZMQContext.h
//  ObjCZMQ
//
//  Created by ALEXEY LOBANOV on 03.02.16.
//  Copyright © 2016 Blue Skies Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZMQSocket.h"

@interface ZMQContext : NSObject
@property (nonatomic, readonly) void *context;
@property (nonatomic, readonly) int socketLimit;
@property (nonatomic, assign)   int maxSockets;
@property (nonatomic, assign)   int ioThreads;
@property (nonatomic, assign, getter=isIPV6)   BOOL useIPV6;
@property (nonatomic, assign, getter=isBlocky) BOOL blocky;
- (instancetype)init;
- (void)setThreadSchedulingPolicy:(int)threadSchedulingPolicy;
- (void)setThreadPriority:(int)threadPriority;
- (void)terminate;
- (ZMQSocket *)socketWithType:(ZMQSocketType)type;
- (ZMQSocket *)socketWithType:(ZMQSocketType)type onQueue:(dispatch_queue_t)queue;
@end
