//
//  ZMQContext.m
//  ObjCZMQ
//
//  Created by ALEXEY LOBANOV on 03.02.16.
//  Copyright © 2016 Blue Skies Software. All rights reserved.
//

#import "ZMQContext.h"
#import "ZMQException.h"
#import "ZMQSocket.h"
#include "zmq.h"

#define LOCAL_LEVEL_0 0
#define LOCAL_LEVEL_1 1
#define LOCAL_LEVEL_2 2

@implementation ZMQContext
{
    void *_context;
}
- (instancetype)init
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    self = [super init];
    if (self != nil)
    {
        _context = zmq_ctx_new();
        if (_context == NULL)
        {
#if DEBUG >= LOCAL_LEVEL_0
            NSLog(@"ERROR in %@ '%@' - CODE: %i REASON: %s", self.class, NSStringFromSelector(_cmd),zmq_errno(),zmq_strerror(zmq_errno()));
#endif
            @throw [ZMQException new];
        }
    }
    return self;
}
- (void)dealloc
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    if (_context != NULL) [self terminate];
    _context = NULL;
}
- (void *)context
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    return _context;
}
- (void)setBlocky:(BOOL)blocky
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    [self setOption:ZMQ_BLOCKY value:blocky?1:0];
}
- (BOOL)isBlocky
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    return ([self getOption:ZMQ_BLOCKY] > 0);
}
- (void)setUseIPV6:(BOOL)useIPV6
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    [self setOption:ZMQ_IPV6 value:useIPV6?1:0];
}
- (BOOL)isIPV6
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    return ([self getOption:ZMQ_IPV6] > 0);
}
- (int)socketLimit
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    return [self getOption:ZMQ_SOCKET_LIMIT];
}
- (int)maxSockets
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    return [self getOption:ZMQ_MAX_SOCKETS];
}
- (void)setMaxSockets:(int)maxSockets
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    if (maxSockets <= [self socketLimit])
    {
        [self setOption:ZMQ_MAX_SOCKETS value:maxSockets];
    }
}
- (void)setIoThreads:(int)ioThreads
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    if (ioThreads >= 0)
    {
        [self setOption:ZMQ_IO_THREADS value:ioThreads];
    }
}
- (int)ioThreads
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    return [self getOption:ZMQ_IO_THREADS];
}
- (void)setThreadSchedulingPolicy:(int)threadSchedulingPolicy
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    [self setOption:ZMQ_THREAD_SCHED_POLICY value:threadSchedulingPolicy];
}
- (void)setThreadPriority:(int)threadPriority
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    [self setOption:ZMQ_THREAD_PRIORITY value:threadPriority];
}
- (ZMQSocket *)socketWithType:(ZMQSocketType)type
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    ZMQSocket *	socket = [ZMQSocket socketWithContext:_context withType:type];
    return socket;
}
- (ZMQSocket *)socketWithType:(ZMQSocketType)type onQueue:(dispatch_queue_t)queue
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    ZMQSocket *	socket = [ZMQSocket socketWithContext:_context withType:type onQueue:queue];
    return socket;
}
- (void)terminate
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    if (zmq_ctx_term(_context) == -1)
    {
#if DEBUG >= LOCAL_LEVEL_0
        NSLog(@"ERROR in %@ '%@' - CODE: %i REASON: %s", self.class, NSStringFromSelector(_cmd),zmq_errno(),zmq_strerror(zmq_errno()));
#endif
        @throw [ZMQException new];
    }
}
- (void)setOption:(int)option value:(int)value
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    if (zmq_ctx_set(_context, option, value) == -1)
    {
#if DEBUG >= LOCAL_LEVEL_0
        NSLog(@"ERROR in %@ '%@' - CODE: %i REASON: %s", self.class, NSStringFromSelector(_cmd),zmq_errno(),zmq_strerror(zmq_errno()));
#endif
        @throw [ZMQException new];
    }
}
- (BOOL)getOption:(int)option
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    int ret = zmq_ctx_get(_context, option);
    if (ret == -1)
    {
#if DEBUG >= LOCAL_LEVEL_0
        NSLog(@"ERROR in %@ '%@' - CODE: %i REASON: %s", self.class, NSStringFromSelector(_cmd),zmq_errno(),zmq_strerror(zmq_errno()));
#endif
        @throw [ZMQException new];
    }
    return ret;
}
@end
