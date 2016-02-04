//
//  ZMQContext.m
//  ObjCZMQ
//
//  Created by ALEXEY LOBANOV on 03.02.16.
//  Copyright © 2016 Blue Skies Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZMQContext.h"
#import "ZMQException.h"
#import <zmq.h>

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
- (BOOL)destroy
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    BOOL ret = (zmq_ctx_destroy(_context) == 0);
    if (!ret)
    {
#if DEBUG >= LOCAL_LEVEL_0
        NSLog(@"ERROR in %@ '%@' - CODE: %i REASON: %s", self.class, NSStringFromSelector(_cmd),zmq_errno(),zmq_strerror(zmq_errno()));
#endif
        @throw [ZMQException new];
    }
    return ret;
}
- (BOOL)terminate
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    BOOL ret = (zmq_ctx_term(_context) == 0);
    if (!ret)
    {
#if DEBUG >= LOCAL_LEVEL_0
        NSLog(@"ERROR in %@ '%@' - CODE: %i REASON: %s", self.class, NSStringFromSelector(_cmd),zmq_errno(),zmq_strerror(zmq_errno()));
#endif
        @throw [ZMQException new];
    }
    return ret;
}
- (BOOL)shutdown
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    BOOL ret = (zmq_ctx_shutdown(_context) == 0);
    if (!ret)
    {
#if DEBUG >= LOCAL_LEVEL_0
        NSLog(@"ERROR in %@ '%@' - CODE: %i REASON: %s", self.class, NSStringFromSelector(_cmd),zmq_errno(),zmq_strerror(zmq_errno()));
#endif
        @throw [ZMQException new];
    }
    return ret;
}
- (BOOL)setOption:(int)option value:(int)value
{
#if DEBUG >= LOCAL_LEVEL_1
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif
    BOOL ret = (zmq_ctx_set(_context, option, value) == 0);
    if (!ret)
    {
#if DEBUG >= LOCAL_LEVEL_0
        NSLog(@"ERROR in %@ '%@' - CODE: %i REASON: %s", self.class, NSStringFromSelector(_cmd),zmq_errno(),zmq_strerror(zmq_errno()));
#endif
        @throw [ZMQException new];
    }
    return ret;
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
- (void)setBlocky:(BOOL)blocky
{
    [self setOption:ZMQ_BLOCKY value:blocky ? 1 : 0];
    
}
- (BOOL)blocky
{
    return ([self getOption:ZMQ_BLOCKY] != 0);
}

- (NSInteger)ioThreads
{
    set {
    }
    get {
        return getOption(ZMQ_IO_THREADS)
    }
}
- (void)setIoThreads:(NSInteger)ioThreads
{
    setOption(ZMQ_IO_THREADS, value: newValue)
}
public var maxSockets: Int32 {
    set {
        setOption(ZMQ_MAX_SOCKETS, value: newValue)
    }
    get {
        return getOption(ZMQ_MAX_SOCKETS)
    }
}

public var IPV6: Bool {
    set {
        setOption(ZMQ_IPV6, value: newValue ? 1 : 0)
    }
    get {
        return getOption(ZMQ_IPV6) != 0
    }
}

public var socketLimit: Int32 {
    return getOption(ZMQ_SOCKET_LIMIT)
}

public func setThreadSchedulingPolicy(value: Int32) {
    setOption(ZMQ_THREAD_SCHED_POLICY, value: value)
}

public func setThreadPriority(value: Int32) {
    setOption(ZMQ_THREAD_PRIORITY, value: value)
}

@end
